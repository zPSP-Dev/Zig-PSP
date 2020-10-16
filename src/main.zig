const psp = @import("psp/pspsdk.zig");
pub const os = @import("psp/pspos.zig");
pub const panic = @import("psp/utils/debug.zig").panic;

const std = @import("std");

comptime {
    asm (psp.module_info("Zig PSP", 0, 1, 0));
}

fn addOne(x: u8) u8 {
    return x + 1;
}

pub fn main() !void {
    psp.utils.enableHBCB();
    psp.debug.screenInit();
    psp.debug.print("Hi!");
    
    @panic("Heelo");
}
