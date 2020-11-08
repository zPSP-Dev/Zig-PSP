const macro = @import("pspmacros.zig");

comptime {
    asm (macro.import_module_start("sceOpenPSID", "0x40010011", "18"));
    asm (macro.import_function("sceOpenPSID", "0xC69BEBCE", "sceOpenPSIDGetOpenPSID"));
}
