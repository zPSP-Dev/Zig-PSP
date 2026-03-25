// std.heap.ArenaAllocator backed by psp_page_allocator.
//
// std.heap.GeneralPurposeAllocator cannot be used on freestanding targets:
// its struct definition contains `backing_allocator: Allocator = std.heap.page_allocator`
// as a default field value, which causes PageAllocator (posix mmap/munmap) to
// be compiled in regardless of what backing allocator you pass. ArenaAllocator
// has no such default and works cleanly.
//
// The arena suballocates PSP kernel blocks across many small requests.
// All memory is freed at once on deinit -- useful for frame or request scopes.
//
// Expected output:
//   [1] baseline:  ~57916672 bytes
//   Hello from the Arena!
//   Squares: 0 1 4 9 16 25 36 49 64 81 100 121 144 169 196
//   [2] mid-arena:  lower than [1]
//   [3] after deinit:  matches [1]
//   Done!
const std = @import("std");
const sdk = @import("pspsdk");

pub const panic = sdk.extra.debug.panic;

pub const std_options_debug_threaded_io: ?*std.Io.Threaded = null;
pub const std_options_debug_io: std.Io = sdk.extra.Io.psp_io;
pub fn std_options_cwd() std.Io.Dir { return .{ .handle = -1 }; }

comptime {
    asm(sdk.extra.module.module_info("PSP Arena", .{ .mode = .User }, 1, 0));
}

fn printFree(label: []const u8) void {
    const free_bytes = sdk.kernel.total_free_mem_size();
    sdk.extra.debug.print("{s}: {d} bytes\n", .{ label, free_bytes });
}

pub fn main(init: std.process.Init) !void {
    sdk.extra.utils.enableHBCB();
    sdk.extra.debug.screenInit();

    printFree("[1] baseline");

    var arena = std.heap.ArenaAllocator.init(init.gpa);
    defer {
        arena.deinit();
        // All memory returned to init.gpa here; [3] should match [1].
        printFree("[3] after deinit");
    }
    const alloc = arena.allocator();

    // Many small allocations -- all suballocated within the arena's pages
    // rather than each paying a 256-byte PSP kernel block.
    const greeting = try std.fmt.allocPrint(alloc, "Hello from the Arena!\n", .{});
    sdk.extra.debug.print("{s}", .{greeting});

    sdk.extra.debug.print("Squares:", .{});
    for (0..15) |i| {
        const n: u32 = @intCast(i);
        const s = try std.fmt.allocPrint(alloc, " {d}", .{n * n});
        sdk.extra.debug.print("{s}", .{s});
    }
    sdk.extra.debug.print("\n", .{});

    printFree("[2] mid-arena");

    // Intentionally do NOT free individual arena allocations -- that is the
    // whole point. arena.deinit() in the defer above frees everything at once.

    sdk.extra.debug.print("Done!\n", .{});
}
