const macro = @import("pspmacros.zig");

comptime {
    asm (macro.import_module_start("sceDmac", "0x40010011", "2"));
    asm (macro.import_function("sceDmac", "0x617F3FE6", "sceDmacMemcpy"));
    asm (macro.import_function("sceDmac", "0xD97F94D8", "sceDmacTryMemcpy"));
}
