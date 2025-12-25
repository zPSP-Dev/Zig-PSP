// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

pub extern fn sceOpenPSIDGetOpenPSID(openpsid: [*c]c_int) callconv(.C) c_int;

comptime {
    asm (macro.import_module_start("sceOpenPSID", "0x40010011", "1"));
    asm (macro.import_function("sceOpenPSID", "0xC69BEBCE", "sceOpenPSIDGetOpenPSID"));
}
