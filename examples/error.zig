//Testing main error handling.

const psp = @import("psp/pspsdk.zig");
const std = @import("std");
const fmt = std.fmt;

comptime {
    _ = psp.module_start_struct;
}

const MyTestErrors = error{
    TestError,
};

pub fn main() !void {
    psp.utils.enableHomeButton();
    psp.debug.screenInit();

    try psp.debug.printFormat("Hello {}!\n", .{"world"});
    
    return MyTestErrors.TestError;
}