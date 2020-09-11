//A simple hello world

//We have 2 different ways of including the PSPSDK - either the minimalist version within utils (you can later include other modules...)
//Or the full SDK through pspsdk.zig with all libraries.
//In a minimalist instance, binaries are 13,284 bytes on release safe versus 22,724 bytes on the full version (no GU)
const psp = @import("psp/utils/psp.zig");

comptime {
    _ = psp.module_start_struct;
}

pub fn main() !void {
    psp.utils.enableHBCB();
    psp.debug.screenInit();

    psp.debug.print("Hello from Zig!");
}
