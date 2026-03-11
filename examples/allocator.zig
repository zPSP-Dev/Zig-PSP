// PSP Page Allocator example / integration test.
//
// Expected output (values will vary):
//
//   [1] Free mem: XXXXXXXX bytes
//   [2] After alloc (string): "Hello from Zig!"
//   [3] Free mem: YYYYYYYY bytes  (should be less than [1])
//   [4] After free — free mem: XXXXXXXX bytes  (should match [1])
//   [5] ArrayList test: 0 1 2 3 4 5 6 7 8 9
//   [6] Free mem: XXXXXXXX bytes  (should match [1] again)
//   Done!
const std = @import("std");
const sdk = @import("pspsdk");

pub const panic = sdk.extra.debug.panic;

comptime {
    asm(sdk.extra.module.module_info("PSP Page Alloc", .{ .mode = .User }, 1, 0));
}

const alloc = sdk.extra.allocator.psp_page_allocator;

fn printFree(label: []const u8) void {
    const free_bytes = sdk.kernel.total_free_mem_size();
    const msg = std.fmt.allocPrint(alloc, "{s}: {d} bytes free\n", .{ label, free_bytes }) catch unreachable;
    defer alloc.free(msg);
    sdk.extra.debug.print(msg);
}

pub fn main() !void {
    sdk.extra.utils.enableHBCB();
    sdk.extra.debug.screenInit();

    // [1] Baseline
    printFree("[1] Free mem");

    // [2] Allocate a formatted string and print it.
    const greeting = try std.fmt.allocPrint(alloc, "Hello from Zig!\n", .{});
    sdk.extra.debug.print("[2] Alloc'd: ");
    sdk.extra.debug.print(greeting);

    // [3] Memory should be reduced.
    printFree("[3] After alloc");

    // [4] Free the string; memory should return to baseline.
    alloc.free(greeting);
    printFree("[4] After free");

    // [5] ArrayList — exercises alloc, resize/remap, and free in a loop.
    // In Zig 0.15, ArrayList is unmanaged; the allocator is passed per-call.
    {
        var list = std.ArrayList(u32){};
        defer list.deinit(alloc);

        for (0..10) |i| try list.append(alloc, @intCast(i));

        sdk.extra.debug.print("[5] ArrayList:");
        for (list.items) |v| {
            const s = std.fmt.allocPrint(alloc, " {d}", .{v}) catch unreachable;
            defer alloc.free(s);
            sdk.extra.debug.print(s);
        }
        sdk.extra.debug.print("\n");
    }

    // [6] After ArrayList is deinit'd, memory should be back to baseline.
    printFree("[6] After ArrayList deinit");

    sdk.extra.debug.print("Done!\n");
}
