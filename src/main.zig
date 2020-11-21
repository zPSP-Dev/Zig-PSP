const psp = @import("psp/utils/psp.zig");
pub const os = @import("psp/pspos.zig");
pub const panic = @import("psp/utils/debug.zig").panic;

const std = @import("std");

comptime {
    asm (psp.module_info("Zig PSP", 0, 1, 0));
}

pub fn main() !void {
    psp.utils.enableHBCB();
    psp.debug.screenInit();
    psp.debug.print("Hi!");
}
