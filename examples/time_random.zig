// PSP time and random example using the std.Io vtable.
//
// Demonstrates clock resolution, timestamps, sleep, and random number
// generation -- all routed through the PSP Io vtable backed by sceRtc,
// sceKernelDelayThread, and sceKernelUtilsMt19937.
//
// Expected output:
//
//   [1] Clock resolution: 1000 ns
//   [2] Current time: <nanoseconds> ns
//   [3] Sleeping 1 second...
//   [4] Slept! Elapsed: ~1000 ms
//   [5] Random bytes: XX XX XX XX XX XX XX XX
//   [6] Random u32: NNNNNNNNNN
//   Done!
const std = @import("std");
const sdk = @import("pspsdk");

pub const panic = sdk.extra.debug.panic;

pub const std_options_debug_threaded_io: ?*std.Io.Threaded = null;
pub const std_options_debug_io: std.Io = sdk.extra.Io.psp_io;

pub fn std_options_cwd() std.Io.Dir {
    return .{ .handle = -1 };
}

comptime {
    asm (sdk.extra.module.module_info("SDK Time Random", .{ .mode = .User }, 1, 0));
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    sdk.extra.utils.enableHBCB();
    sdk.extra.debug.screenInit();

    // [1] Clock resolution
    const res = try std.Io.Clock.real.resolution(io);
    sdk.extra.debug.print("[1] Clock resolution: {} ns\n", .{res.nanoseconds});

    // [2] Current timestamp
    const t1 = std.Io.Clock.real.now(io);
    sdk.extra.debug.print("[2] Current time: {} ns\n", .{t1.nanoseconds});

    // [3] Sleep 1 second and measure elapsed
    sdk.extra.debug.print("[3] Sleeping 1 second...\n", .{});
    const before = std.Io.Clock.real.now(io);
    try std.Io.sleep(io, .{ .nanoseconds = 1_000_000_000 }, .real);
    const after = std.Io.Clock.real.now(io);
    const elapsed_ms = @divTrunc(after.nanoseconds - before.nanoseconds, 1_000_000);
    sdk.extra.debug.print("[4] Slept! Elapsed: ~{} ms\n", .{elapsed_ms});

    // [5] Random bytes
    var buf: [8]u8 = undefined;
    std.Io.random(io, &buf);
    sdk.extra.debug.print("[5] Random bytes:", .{});
    for (buf) |b| {
        sdk.extra.debug.print(" {X:0>2}", .{b});
    }
    sdk.extra.debug.print("\n", .{});

    // [6] Random u32 from 4 bytes
    var u32_buf: [4]u8 = undefined;
    std.Io.random(io, &u32_buf);
    const val = std.mem.readInt(u32, &u32_buf, .little);
    sdk.extra.debug.print("[6] Random u32: {}\n", .{val});

    sdk.extra.debug.print("Done!\n", .{});
}
