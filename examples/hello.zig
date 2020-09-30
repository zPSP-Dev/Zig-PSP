//A simple hello world

//We have 2 different ways of including the PSPSDK - either the minimalist version within utils (you can later include other modules...)
//Or the full SDK through pspsdk.zig with all libraries.
//In a minimalist instance, binaries are 10,195 bytes on release small versus 31,590 bytes on the full version
const psp = @import("psp/pspsdk.zig");

comptime {
    asm(psp.module_info("Zig PSP App", 0, 1, 0));
}

pub fn main() !void {
    psp.utils.enableHBCB();
    psp.debug.screenInit();

    psp.debug.print("Hello from Zig!");
}
