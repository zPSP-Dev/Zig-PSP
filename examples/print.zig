//Using colors!

const psp = @import("psp/utils/psp.zig");

comptime {
    asm(psp.module_info("Zig PSP App", 0, 1, 0));
}

pub fn main() !void {
    psp.utils.enableHBCB();
    psp.debug.screenInit();

    //This is LE - so backwards ABGR
    psp.debug.screenSetClearColor(0xFFFFCA82);
    psp.debug.screenClear();

    psp.debug.screenEnableBackColor();
    psp.debug.screenSetBackColor(0xFF00FFFF);
    psp.debug.screenSetFrontColor(0xFFFF00FF);

    try psp.debug.printFormat("Hello {}!\n", .{"world"});
}
