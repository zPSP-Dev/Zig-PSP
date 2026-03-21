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
    asm (sdk.extra.module.module_info("PSP Page Alloc", .{ .mode = .User }, 1, 0));
}

fn printFree(gpa: std.mem.Allocator, label: []const u8) void {
    const free_bytes = sdk.kernel.total_free_mem_size();
    const msg = std.fmt.allocPrint(gpa, "{s}: {d} bytes free\n", .{ label, free_bytes }) catch unreachable;
    defer gpa.free(msg);
    sdk.extra.debug.print(msg);
}

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;

    sdk.extra.utils.enableHBCB();
    sdk.extra.debug.screenInit();

    // [1] Baseline
    printFree(gpa, "[1] Free mem");

    // [2] Allocate a formatted string and print it.
    const greeting = try std.fmt.allocPrint(gpa, "Hello from Zig!\n", .{});
    sdk.extra.debug.print("[2] Alloc'd: ");
    sdk.extra.debug.print(greeting);

    // [3] Memory should be reduced.
    printFree(gpa, "[3] After alloc");

    // [4] Free the string; memory should return to baseline.
    gpa.free(greeting);
    printFree(gpa, "[4] After free");

    // [5] ArrayList — exercises alloc, resize/remap, and free in a loop.
    // In Zig 0.15, ArrayList is unmanaged; the allocator is passed per-call.
    {
        var list = std.ArrayList(u32){ .items = &.{}, .capacity = 0 };
        defer list.deinit(gpa);

        for (0..10) |i| try list.append(gpa, @intCast(i));

        sdk.extra.debug.print("[5] ArrayList:");
        for (list.items) |v| {
            const s = std.fmt.allocPrint(gpa, " {d}", .{v}) catch unreachable;
            defer gpa.free(s);
            sdk.extra.debug.print(s);
        }
        sdk.extra.debug.print("\n");
    }

    // [6] After ArrayList is deinit'd, memory should be back to baseline.
    printFree(gpa, "[6] After ArrayList deinit");

    sdk.extra.debug.print("Done!\n");
}
