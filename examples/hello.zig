//A simple hello world

const psp = @import("psp/pspsdk.zig");

comptime {
    _ = psp.module_start_struct;
}

pub fn main() !void {
    psp.utils.enableHomeButton();
    psp.debug.screenInit();

    psp.debug.print("Hello from Zig!");
}