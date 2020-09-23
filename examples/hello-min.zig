//A simple hello world

//We have 2 different ways of including the PSPSDK - either the minimalist version within utils (you can later include other modules...)
//Or the full SDK through pspsdk.zig with all libraries.
//In a minimalist instance, binaries are 7310 bytes on release small versus 22,724 bytes on the full version (no GU)
const mod = @import("psp/utils/module.zig");
const debug = @import("psp/utils/debug.zig");
usingnamespace @import("psp/utils/mem-fix.zig");
const utils = @import("psp/utils/utils.zig");

comptime {
    _ = mod.module_start_struct;
}

pub fn main() !void {
    utils.enableHBCB();
    debug.screenInit();

    debug.print("Hello from Zig!");
}
