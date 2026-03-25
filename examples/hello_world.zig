const std = @import("std");
const sdk = @import("pspsdk");

pub const panic = sdk.extra.debug.panic;

pub const std_options_debug_threaded_io: ?*std.Io.Threaded = null;
pub const std_options_debug_io: std.Io = sdk.extra.Io.psp_io;
pub fn std_options_cwd() std.Io.Dir {
    return .{ .handle = -1 };
}

comptime {
    asm (sdk.extra.module.module_info("SDK Hello World", .{ .mode = .User }, 1, 0));
}

pub fn main(_: std.process.Init) !void {
    sdk.extra.utils.enableHBCB();
    sdk.extra.debug.screenInit();

    sdk.extra.debug.print("Hello from Zig!", .{});
}
