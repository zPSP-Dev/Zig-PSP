//! Fixed-buffer pool allocator backed by an intrusive treap of free blocks.
//!
//! Buffer layout:
//!   [BlockHeader | payload] [BlockHeader | payload] ... [Sentinel]
//!
//! Every block boundary and user-data start is BLOCK_ALIGN-aligned.
//! Free blocks embed a `FreeTree.Node` at the start of their payload (intrusive).
//! The treap is keyed by (size, address): best_fit() is one O(log n) descent.
//!
//! Over-aligned requests (alignment > BLOCK_ALIGN) are handled by over-allocating
//! and storing a back-offset immediately before the user pointer, the same
//! strategy used by the page allocator.
//!
//! alloc — O(log n): best_fit descent + optional split + one insertion
//! free  — O(log n): up to two coalesce removals + one insertion

const std = @import("std");
const assert = std.debug.assert;

/// All block boundaries and user-data pointers are aligned to this.
pub const BLOCK_ALIGN: usize = 2 * @sizeOf(usize);

/// Prepended to every block, free or allocated.
const BlockHeader = extern struct {
    /// Total block bytes including this header, always a multiple of BLOCK_ALIGN.
    /// Bit 0: 1 = allocated, 0 = free.
    size_flags: usize,
    /// Size of the immediately preceding physical block; 0 for the first block.
    prev_size: usize,
};

comptime {
    assert(@sizeOf(BlockHeader) == 2 * @sizeOf(usize));
    assert(@sizeOf(BlockHeader) == BLOCK_ALIGN);
}

/// Treap key: sort primarily by block size (best-fit search), break ties by
/// address so every key is unique.
const Key = struct { size: usize, addr: usize };

fn cmp_key(a: Key, b: Key) std.math.Order {
    if (a.size != b.size) return std.math.order(a.size, b.size);
    return std.math.order(a.addr, b.addr);
}

const FreeTree = std.Treap(Key, cmp_key);

/// Minimum free-block size: header + intrusive treap node.
pub const MIN_BLOCK: usize = @sizeOf(BlockHeader) + @sizeOf(FreeTree.Node);

// -- block helpers -------------------------------------------------------------

inline fn blk_sz(h: *const BlockHeader) usize {
    return h.size_flags & ~@as(usize, 1);
}
inline fn blk_used(h: *const BlockHeader) bool {
    return (h.size_flags & 1) != 0;
}
inline fn blk_next(h: *BlockHeader) *BlockHeader {
    return @ptrFromInt(@intFromPtr(h) + blk_sz(h));
}
inline fn blk_node(h: *BlockHeader) *FreeTree.Node {
    return @ptrFromInt(@intFromPtr(h) + @sizeOf(BlockHeader));
}
inline fn node_blk(n: *FreeTree.Node) *BlockHeader {
    return @ptrFromInt(@intFromPtr(n) - @sizeOf(BlockHeader));
}
inline fn blk_key(h: *BlockHeader) Key {
    return .{ .size = blk_sz(h), .addr = @intFromPtr(h) };
}

/// Recover the block header from a user pointer, accounting for over-alignment.
/// For standard alignment (<= BLOCK_ALIGN), the header sits directly before the
/// user data. For over-aligned allocations, a back-offset stored immediately
/// before the user pointer indicates the distance to the block header.
inline fn user_to_blk(ptr: [*]u8, alignment: std.mem.Alignment) *BlockHeader {
    const user_addr = @intFromPtr(ptr);
    if (alignment.toByteUnits() > BLOCK_ALIGN) {
        const back: *const usize = @ptrFromInt(user_addr - @sizeOf(usize));
        return @ptrFromInt(user_addr - back.*);
    }
    return @ptrFromInt(user_addr - @sizeOf(BlockHeader));
}

// -- treap wrappers ------------------------------------------------------------

fn tree_insert(tree: *FreeTree, h: *BlockHeader) void {
    var entry = tree.getEntryFor(blk_key(h));
    entry.set(blk_node(h));
}

fn tree_remove(tree: *FreeTree, h: *BlockHeader) void {
    var entry = tree.getEntryForExisting(blk_node(h));
    entry.set(null);
}

/// Walk the treap to find the smallest free block with size >= min_size.
/// O(log n) — the primary key is size, so we descend left when the current
/// node already qualifies and right when it's too small.
fn best_fit(tree: *FreeTree, min_size: usize) ?*BlockHeader {
    var best: ?*FreeTree.Node = null;
    var cur = tree.root;
    while (cur) |n| {
        if (n.key.size >= min_size) {
            best = n;
            cur = n.children[0]; // try smaller
        } else {
            cur = n.children[1]; // need larger
        }
    }
    return if (best) |n| node_blk(n) else null;
}

// -- public allocator ----------------------------------------------------------

pub const PoolAlloc = struct {
    buf: []u8,
    tree: FreeTree,
    used: usize,
    budget: usize,
    name: []const u8,

    const vtable = std.mem.Allocator.VTable{
        .alloc = alloc_fn,
        .resize = resize_fn,
        .remap = remap_fn,
        .free = free_fn,
    };

    pub fn init(buf: []u8, name: []const u8) PoolAlloc {
        // Advance the start to the next BLOCK_ALIGN boundary.
        const start = std.mem.alignForward(usize, @intFromPtr(buf.ptr), BLOCK_ALIGN);
        const end = @intFromPtr(buf.ptr) + buf.len;
        const total = ((end - start) / BLOCK_ALIGN) * BLOCK_ALIGN;
        assert(total >= MIN_BLOCK + @sizeOf(BlockHeader));

        var self = PoolAlloc{
            .buf = buf,
            .tree = .{},
            .used = 0,
            .budget = buf.len,
            .name = name,
        };

        // One free block spanning the usable region, then an end sentinel.
        // Sentinel: size=0, used-bit set — stops forward coalescing at the edge.
        const free_sz = total - @sizeOf(BlockHeader);
        const main: *BlockHeader = @ptrFromInt(start);
        main.* = .{ .size_flags = free_sz, .prev_size = 0 };
        const sent: *BlockHeader = @ptrFromInt(start + free_sz);
        sent.* = .{ .size_flags = 0 | 1, .prev_size = free_sz };

        tree_insert(&self.tree, main);
        return self;
    }

    pub fn allocator(self: *PoolAlloc) std.mem.Allocator {
        return .{ .ptr = self, .vtable = &vtable };
    }

    pub fn reset(self: *PoolAlloc) void {
        self.* = init(self.buf, self.name);
    }

    // -- vtable callbacks ------------------------------------------------------

    fn alloc_fn(ctx: *anyopaque, n: usize, alignment: std.mem.Alignment, _: usize) ?[*]u8 {
        const self: *PoolAlloc = @ptrCast(@alignCast(ctx));
        const align_bytes = alignment.toByteUnits();
        const over_aligned = align_bytes > BLOCK_ALIGN;

        // For over-aligned requests, reserve extra space for alignment padding
        // and a back-offset (usize) stored immediately before the user pointer.
        const overhead: usize = if (over_aligned)
            @sizeOf(BlockHeader) + @sizeOf(usize) + align_bytes - 1
        else
            @sizeOf(BlockHeader);

        // Round the request up to a full block size (header + payload, aligned).
        // Must be at least MIN_BLOCK so the block can hold an intrusive treap node
        // if it is ever freed without adjacent free neighbours to coalesce with.
        const need = @max(roundup(overhead + n, BLOCK_ALIGN), MIN_BLOCK);

        const h = best_fit(&self.tree, need) orelse return null;
        tree_remove(&self.tree, h);

        const found = blk_sz(h);
        if (found >= need + MIN_BLOCK) {
            // Split: keep `need` bytes here, return the remainder to the tree.
            const split: *BlockHeader = @ptrFromInt(@intFromPtr(h) + need);
            split.* = .{ .size_flags = found - need, .prev_size = need };
            blk_next(split).prev_size = found - need;
            tree_insert(&self.tree, split);
            h.size_flags = need | 1;
        } else {
            h.size_flags = found | 1;
        }

        blk_next(h).prev_size = blk_sz(h);
        self.used += blk_sz(h);

        if (over_aligned) {
            const header_addr = @intFromPtr(h);
            const min_user = header_addr + @sizeOf(BlockHeader) + @sizeOf(usize);
            const user_addr = std.mem.alignForward(usize, min_user, align_bytes);
            const back: *usize = @ptrFromInt(user_addr - @sizeOf(usize));
            back.* = user_addr - header_addr;
            return @ptrFromInt(user_addr);
        }
        return @ptrFromInt(@intFromPtr(h) + @sizeOf(BlockHeader));
    }

    fn resize_fn(ctx: *anyopaque, buf: []u8, alignment: std.mem.Alignment, new_len: usize, _: usize) bool {
        const self: *PoolAlloc = @ptrCast(@alignCast(ctx));
        const h = user_to_blk(buf.ptr, alignment);
        const cur_sz = blk_sz(h);
        const user_offset = @intFromPtr(buf.ptr) - @intFromPtr(h);

        // Shrink or already fits within block slack
        if (new_len <= cur_sz - user_offset) return true;

        // Growth: check if next physical block is free and large enough
        const nx = blk_next(h);
        if (blk_used(nx)) return false;

        const combined = cur_sz + blk_sz(nx);
        if (new_len > combined - user_offset) return false;

        // Absorb the next free block
        tree_remove(&self.tree, nx);

        const needed = @max(roundup(user_offset + new_len, BLOCK_ALIGN), MIN_BLOCK);
        if (combined >= needed + MIN_BLOCK) {
            // Split: use needed, return remainder to tree
            h.size_flags = needed | 1;
            const sp: *BlockHeader = @ptrFromInt(@intFromPtr(h) + needed);
            sp.* = .{ .size_flags = combined - needed, .prev_size = needed };
            blk_next(sp).prev_size = combined - needed;
            tree_insert(&self.tree, sp);
        } else {
            // Absorb entire block
            h.size_flags = combined | 1;
            blk_next(h).prev_size = combined;
        }

        self.used += blk_sz(h) - cur_sz;
        return true;
    }

    fn remap_fn(_: *anyopaque, _: []u8, _: std.mem.Alignment, _: usize, _: usize) ?[*]u8 {
        // Signal to the caller that it must do the alloc + copy + free itself.
        return null;
    }

    fn free_fn(ctx: *anyopaque, buf: []u8, alignment: std.mem.Alignment, _: usize) void {
        const self: *PoolAlloc = @ptrCast(@alignCast(ctx));

        var h = user_to_blk(buf.ptr, alignment);
        assert(blk_used(h));

        const sz = blk_sz(h);
        self.used -= sz;
        h.size_flags = sz; // clear used bit

        // Coalesce forward with the next physical block if it is free.
        // The sentinel is always "used" (bit 0 set) so it stops coalescing.
        const nx = blk_next(h);
        if (!blk_used(nx)) {
            tree_remove(&self.tree, nx);
            const merged = sz + blk_sz(nx);
            h.size_flags = merged;
            blk_next(h).prev_size = merged;
        }

        // Coalesce backward with the previous physical block if it is free.
        if (h.prev_size != 0) {
            const pv: *BlockHeader = @ptrFromInt(@intFromPtr(h) - h.prev_size);
            if (!blk_used(pv)) {
                tree_remove(&self.tree, pv);
                const merged = blk_sz(pv) + blk_sz(h);
                pv.size_flags = merged;
                blk_next(pv).prev_size = merged;
                h = pv;
            }
        }

        tree_insert(&self.tree, h);
    }
};

inline fn roundup(n: usize, a: usize) usize {
    return (n + a - 1) & ~(a - 1);
}

// -- tests ---------------------------------------------------------------------

const testing = std.testing;

test "pool_alloc: basic alloc and free" {
    var buf: [4096]u8 align(BLOCK_ALIGN) = undefined;
    var pa = PoolAlloc.init(buf[0..], "test");
    const ally = pa.allocator();

    const slice = try ally.alloc(u8, 64);
    try testing.expect(pa.used > 0);
    ally.free(slice);
    try testing.expectEqual(@as(usize, 0), pa.used);
}

test "pool_alloc: used tracks multiple allocations" {
    var buf: [4096]u8 align(BLOCK_ALIGN) = undefined;
    var pa = PoolAlloc.init(buf[0..], "test");
    const ally = pa.allocator();

    const a = try ally.alloc(u8, 64);
    const used_one = pa.used;
    const b = try ally.alloc(u8, 64);
    try testing.expect(pa.used > used_one);

    ally.free(a);
    ally.free(b);
    try testing.expectEqual(@as(usize, 0), pa.used);
}

test "pool_alloc: coalesce forward" {
    var buf: [4096]u8 align(BLOCK_ALIGN) = undefined;
    var pa = PoolAlloc.init(buf[0..], "test");
    const ally = pa.allocator();

    const a = try ally.alloc(u8, 64);
    const b = try ally.alloc(u8, 64);
    ally.free(a);
    ally.free(b);
    try testing.expectEqual(@as(usize, 0), pa.used);

    const big = try ally.alloc(u8, 128);
    ally.free(big);
    try testing.expectEqual(@as(usize, 0), pa.used);
}

test "pool_alloc: coalesce backward" {
    var buf: [4096]u8 align(BLOCK_ALIGN) = undefined;
    var pa = PoolAlloc.init(buf[0..], "test");
    const ally = pa.allocator();

    const a = try ally.alloc(u8, 64);
    const b = try ally.alloc(u8, 64);
    ally.free(b);
    ally.free(a);
    try testing.expectEqual(@as(usize, 0), pa.used);

    const big = try ally.alloc(u8, 128);
    ally.free(big);
    try testing.expectEqual(@as(usize, 0), pa.used);
}

test "pool_alloc: coalesce both directions" {
    var buf: [4096]u8 align(BLOCK_ALIGN) = undefined;
    var pa = PoolAlloc.init(buf[0..], "test");
    const ally = pa.allocator();

    const a = try ally.alloc(u8, 64);
    const b = try ally.alloc(u8, 64);
    const c = try ally.alloc(u8, 64);

    ally.free(a);
    ally.free(c);
    ally.free(b);
    try testing.expectEqual(@as(usize, 0), pa.used);
}

test "pool_alloc: returned pointers are BLOCK_ALIGN-aligned" {
    var buf: [4096]u8 align(BLOCK_ALIGN) = undefined;
    var pa = PoolAlloc.init(buf[0..], "test");
    const ally = pa.allocator();

    const a = try ally.alloc(u8, 1);
    const b = try ally.alloc(u8, 3);
    const c = try ally.alloc(u8, 17);
    const d = try ally.alloc(u8, 100);

    try testing.expectEqual(@as(usize, 0), @intFromPtr(a.ptr) % BLOCK_ALIGN);
    try testing.expectEqual(@as(usize, 0), @intFromPtr(b.ptr) % BLOCK_ALIGN);
    try testing.expectEqual(@as(usize, 0), @intFromPtr(c.ptr) % BLOCK_ALIGN);
    try testing.expectEqual(@as(usize, 0), @intFromPtr(d.ptr) % BLOCK_ALIGN);

    ally.free(a);
    ally.free(b);
    ally.free(c);
    ally.free(d);
}

test "pool_alloc: reset restores full capacity" {
    var buf: [4096]u8 align(BLOCK_ALIGN) = undefined;
    var pa = PoolAlloc.init(buf[0..], "test");
    const ally = pa.allocator();

    _ = try ally.alloc(u8, 512);
    _ = try ally.alloc(u8, 256);
    try testing.expect(pa.used > 0);

    pa.reset();
    try testing.expectEqual(@as(usize, 0), pa.used);

    const big = try pa.allocator().alloc(u8, 1024);
    pa.allocator().free(big);
}

test "pool_alloc: resize shrink and grow" {
    var buf: [4096]u8 align(BLOCK_ALIGN) = undefined;
    var pa = PoolAlloc.init(buf[0..], "test");
    const ally = pa.allocator();

    const a = try ally.alloc(u8, 64);
    const b = try ally.alloc(u8, 64);

    // Shrink: always succeeds (wastes the tail)
    try testing.expect(ally.resize(a, 32));

    // Grow with occupied next block: must fail
    try testing.expect(!ally.resize(a, 256));

    // Free the next block, now growth can absorb it
    ally.free(b);
    try testing.expect(ally.resize(a, 100));

    ally.free(a);
    try testing.expectEqual(@as(usize, 0), pa.used);
}

test "pool_alloc: block contents are writable" {
    var buf: [4096]u8 align(BLOCK_ALIGN) = undefined;
    var pa = PoolAlloc.init(buf[0..], "test");
    const ally = pa.allocator();

    const ints = try ally.alloc(u32, 32);
    for (ints, 0..) |*v, i| v.* = @intCast(i * i);
    for (ints, 0..) |v, i| try testing.expectEqual(@as(u32, @intCast(i * i)), v);
    ally.free(ints);
    try testing.expectEqual(@as(usize, 0), pa.used);
}

test "pool_alloc: interleaved alloc and free" {
    var buf: [4096]u8 align(BLOCK_ALIGN) = undefined;
    var pa = PoolAlloc.init(buf[0..], "test");
    const ally = pa.allocator();

    const a = try ally.alloc(u8, 32);
    const b = try ally.alloc(u8, 32);
    ally.free(a);
    const c = try ally.alloc(u8, 32);
    const d = try ally.alloc(u8, 32);
    ally.free(c);
    ally.free(b);
    ally.free(d);
    try testing.expectEqual(@as(usize, 0), pa.used);
}

test "pool_alloc: over-alignment" {
    var buf: [8192]u8 align(BLOCK_ALIGN) = undefined;
    var pa = PoolAlloc.init(buf[0..], "test");
    const ally = pa.allocator();
    const over_align = comptime std.mem.Alignment.fromByteUnits(BLOCK_ALIGN * 2);

    // Allocate with alignment > BLOCK_ALIGN via raw vtable call.
    const raw = ally.vtable.alloc(ally.ptr, 64, over_align, 0) orelse
        return error.TestUnexpectedResult;

    // Verify alignment
    try testing.expectEqual(@as(usize, 0), @intFromPtr(raw) % (BLOCK_ALIGN * 2));

    // Writable
    @memset(raw[0..64], 0xAB);
    try testing.expectEqual(@as(u8, 0xAB), raw[0]);

    // Free and verify cleanup
    ally.vtable.free(ally.ptr, raw[0..64], over_align, 0);
    try testing.expectEqual(@as(usize, 0), pa.used);
}

test "pool_alloc: OOM returns error" {
    var buf: [512]u8 align(BLOCK_ALIGN) = undefined;
    var pa = PoolAlloc.init(buf[0..], "test");
    const ally = pa.allocator();

    // Request more than available — must get OutOfMemory, not a panic.
    try testing.expectError(error.OutOfMemory, ally.alloc(u8, 4096));
}
