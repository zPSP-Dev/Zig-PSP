// Demonstrates colored text output using the debug screen.

const sdk = @import("pspsdk");

pub const panic = sdk.extra.debug.panic;

comptime {
    asm (sdk.extra.module.module_info("SDK Print", .{ .mode = .User }, 1, 0));
}

pub fn main() void {
    sdk.extra.utils.enableHBCB();
    sdk.extra.debug.screenInit();

    // Colors are ABGR (little-endian)
    sdk.extra.debug.screenSetClearColor(0xFFFFCA82);
    sdk.extra.debug.screenClear();

    sdk.extra.debug.screenEnableBackColor();
    sdk.extra.debug.screenSetBackColor(0xFF00FFFF);
    sdk.extra.debug.screenSetFrontColor(0xFFFF00FF);

    sdk.extra.debug.print("Hello world!\n");
}
