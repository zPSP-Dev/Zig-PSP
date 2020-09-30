//Testing main error handling.

const psp = @import("psp/utils/psp.zig");
const std = @import("std");
const fmt = std.fmt;

comptime {
    asm(psp.module_info("Zig PSP App", 0, 1, 0));
}

const MyTestErrors = error{
    TestError,
};

pub fn main() !void {
    psp.utils.enableHBCB();
    psp.debug.screenInit();

    try psp.debug.printFormat("Hello {}!\n", .{"world"});
    
    return MyTestErrors.TestError;
}
