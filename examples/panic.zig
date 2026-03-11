// Demonstrates the PSP panic handler via integer overflow.

const std = @import("std");
const sdk = @import("pspsdk");

pub const panic = sdk.extra.debug.panic;

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

    sdk.extra.debug.print("Hello world!\n");
}
