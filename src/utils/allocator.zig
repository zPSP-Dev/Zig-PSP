/// PSP Page Allocator -- analogous to std.heap.page_allocator.
///
/// Each allocation maps directly to one sceKernelAllocPartitionMemory block.
/// No pooling, no coalescing; free releases the block back to the kernel.
///
/// Memory layout per allocation:
///
///   [ raw block base ]
///   [ ... optional padding ... ]
///   [ Header: SceUID (4 bytes) ]   <- immediately before user pointer
///   [ user data (len bytes)    ]   <- aligned to requested alignment
///
/// Use `psp_page_allocator` directly (stateless, no init required).
const std = @import("std");
const sysmem = @import("../sdk/pspsysmem.zig");
const SceUID = sysmem.SceUID;

const Header = extern struct {
    uid: SceUID,
};

fn alloc(_: *anyopaque, len: usize, alignment: std.mem.Alignment, _: usize) ?[*]u8 {
    const align_bytes = alignment.toByteUnits();

    // Worst-case overhead: header must sit immediately before the aligned user
    // address, so we need up to (align_bytes - 1) bytes of padding after the
    // raw base to reach the next aligned boundary past the header.
    const overhead = @sizeOf(Header) + align_bytes - 1;
    const total = overhead + len;

    const uid = sysmem.sceKernelAllocPartitionMemory(.User, "psp_page", .MemLow, total, null);
    if (uid < 0) return null;

    const base = @as([*]u8, @ptrCast(sysmem.sceKernelGetBlockHeadAddr(uid) orelse {
        _ = sysmem.sceKernelFreePartitionMemory(uid);
        return null;
    }));

    // Find the first aligned address that leaves room for the header before it.
    const base_addr = @intFromPtr(base);
    const min_user_addr = base_addr + @sizeOf(Header);
    const user_addr = alignment.forward(min_user_addr);

    // Store the UID in the header immediately before the user pointer.
    const header: *Header = @ptrFromInt(user_addr - @sizeOf(Header));
    header.uid = uid;

    return @ptrFromInt(user_addr);
}

fn resize(_: *anyopaque, memory: []u8, _: std.mem.Alignment, new_len: usize, _: usize) bool {
    // PSP kernel blocks cannot be resized. Allow shrinks (waste the tail);
    // deny growths so the caller falls back to alloc + copy + free.
    return new_len <= memory.len;
}

fn remap(_: *anyopaque, _: []u8, _: std.mem.Alignment, _: usize, _: usize) ?[*]u8 {
    // Signal to the caller that it must do the alloc + copy + free itself.
    return null;
}

fn free(_: *anyopaque, memory: []u8, _: std.mem.Alignment, _: usize) void {
    const user_addr = @intFromPtr(memory.ptr);
    const header: *Header = @ptrFromInt(user_addr - @sizeOf(Header));
    _ = sysmem.sceKernelFreePartitionMemory(header.uid);
}

const vtable = std.mem.Allocator.VTable{
    .alloc = alloc,
    .resize = resize,
    .remap = remap,
    .free = free,
};

/// Stateless PSP page allocator. Use this directly -- no init needed.
pub const psp_page_allocator = std.mem.Allocator{
    .ptr = undefined,
    .vtable = &vtable,
};
