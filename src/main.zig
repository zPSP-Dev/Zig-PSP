const psp = @import("psp/utils/psp.zig");

comptime{
    asm(psp.module_info("Zig PSP", 0, 1, 0));
}

pub fn main() !void {
    psp.utils.enableHBCB();
    psp.debug.screenInit();
    psp.debug.print("Hi!");
}
