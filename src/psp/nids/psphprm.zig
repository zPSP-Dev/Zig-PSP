const macro = @import("pspmacros.zig");

comptime {
    asm (macro.import_module_start("sceHprm", "0x40010000", "8"));

    asm (macro.import_function("sceHprm", "0xC7154136", "sceHprmRegisterCallback"));
    asm (macro.import_function("sceHprm", "0x444ED0B7", "sceHprmUnregisterCallback"));
    asm (macro.import_function("sceHprm", "0x208DB1BD", "sceHprmIsRemoteExist"));
    asm (macro.import_function("sceHprm", "0x7E69EDA4", "sceHprmIsHeadphoneExist"));
    asm (macro.import_function("sceHprm", "0x219C58F1", "sceHprmIsMicrophoneExist"));
    asm (macro.import_function("sceHprm", "0x1910B327", "sceHprmPeekCurrentKey"));
    asm (macro.import_function("sceHprm", "0x2BCEC83E", "sceHprmPeekLatch"));
    asm (macro.import_function("sceHprm", "0x40D2F9F0", "sceHprmReadLatch"));
}
