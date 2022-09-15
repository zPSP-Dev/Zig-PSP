const macro = @import("pspmacros.zig");

comptime {
    asm (macro.import_module_start("sceReg", "0x40010000", "18"));
    asm (macro.import_function("sceReg", "0x92E41280", "sceRegOpenRegistry"));
    asm (macro.import_function("sceReg", "0xFA8A5739", "sceRegCloseRegistry"));
    asm (macro.import_function("sceReg", "0xDEDA92BF", "sceRegRemoveRegistry"));
    asm (macro.import_function("sceReg", "0x1D8A762E", "sceRegOpenCategory"));
    asm (macro.import_function("sceReg", "0x0CAE832B", "sceRegCloseCategory"));
    asm (macro.import_function("sceReg", "0x39461B4D", "sceRegFlushRegistry"));
    asm (macro.import_function("sceReg", "0x0D69BF40", "sceRegFlushCategory"));
    asm (macro.import_function("sceReg", "0x57641A81", "sceRegCreateKey"));
    asm (macro.import_function("sceReg", "0x17768E14", "sceRegSetKeyValue"));
    asm (macro.import_function("sceReg", "0xD4475AA8", "sceRegGetKeyInfo_stub"));
    asm (macro.import_function("sceReg", "0x28A8E98A", "sceRegGetKeyValue"));
    asm (macro.import_function("sceReg", "0x2C0DB9DD", "sceRegGetKeysNum"));
    asm (macro.import_function("sceReg", "0x2D211135", "sceRegGetKeys"));
    asm (macro.import_function("sceReg", "0x4CA16893", "sceRegRemoveCategory"));
    asm (macro.import_function("sceReg", "0xC5768D02", "sceRegGetKeyInfoByName"));
    asm (macro.import_function("sceReg", "0x30BE0259", "sceRegGetKeyValueByName"));
    asm (macro.generic_abi_wrapper("sceRegGetKeyInfo", 6));
}
