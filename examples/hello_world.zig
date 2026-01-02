const sdk = @import("pspsdk");

pub const panic = sdk.extra.debug.panic; // Import panic handler

comptime {
    asm (sdk.extra.module.module_info("SDK Hello World", 0, 1, 0));
}

pub fn main() !void {
    sdk.extra.utils.enableHBCB();
    try sdk.extra.debug.screenInit();

    sdk.extra.debug.print("Hello from Zig!");
}
