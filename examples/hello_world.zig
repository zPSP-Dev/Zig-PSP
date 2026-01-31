const sdk = @import("pspsdk");

pub const panic = sdk.extra.debug.panic; // Import panic handler

comptime {
    asm (sdk.extra.module.module_info("SDK Hello World", .{ .mode = .User }, 1, 0));
}

pub fn main() !void {
    sdk.extra.utils.enableHBCB();
    sdk.extra.debug.screenInit();

    sdk.extra.debug.print("Hello from Zig!");
}
