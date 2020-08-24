//Using colors!

const psp = @import("psp/pspsdk.zig");

comptime {
    _ = psp.module_start_struct;
}

pub fn main() !void {
    //psp.utils.enable_home_callback();
    psp.debug.screenInit();

    //This is LE - so backwards ABGR
    psp.debug.screenSetClearColor(0xFFFFCA82);
    psp.debug.screenClear();

    psp.debug.screenEnableBackColor();
    psp.debug.screenSetBackColor(0xFF00FFFF);
    psp.debug.screenSetFrontColor(0xFFFF00FF);

    try psp.debug.printFormat("Hello {}!\n", .{"world"});
}
