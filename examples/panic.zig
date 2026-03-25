// Demonstrates the PSP panic handler via integer overflow.

const std = @import("std");
const sdk = @import("pspsdk");

pub const panic = sdk.extra.debug.panic;

pub const std_options_debug_threaded_io: ?*std.Io.Threaded = null;
pub const std_options_debug_io: std.Io = sdk.extra.Io.psp_io;
pub fn std_options_cwd() std.Io.Dir { return .{ .handle = -1 }; }

comptime {
    asm (sdk.extra.module.module_info("SDK Panic", .{ .mode = .User }, 1, 0));
}

fn addOne(x: u8) u8 {
    return x + 1;
}

pub fn main(_: std.process.Init) void {
    sdk.extra.utils.enableHBCB();
    sdk.extra.debug.screenInit();

    _ = addOne(255);

    sdk.extra.debug.print("Hello world!\n", .{});
}
