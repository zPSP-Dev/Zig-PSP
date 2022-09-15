const macro = @import("pspmacros.zig");

comptime {
    asm (macro.import_module_start("sceCtrl", "0x40010000", "16"));
    asm (macro.import_function("sceCtrl", "0x6A2774F3", "sceCtrlSetSamplingCycle"));
    asm (macro.import_function("sceCtrl", "0x02BAAD91", "sceCtrlGetSamplingCycle"));
    asm (macro.import_function("sceCtrl", "0x1F4011E6", "sceCtrlSetSamplingMode"));
    asm (macro.import_function("sceCtrl", "0xDA6B76A1", "sceCtrlGetSamplingMode"));
    asm (macro.import_function("sceCtrl", "0x3A622550", "sceCtrlPeekBufferPositive"));
    asm (macro.import_function("sceCtrl", "0xC152080A", "sceCtrlPeekBufferNegative"));
    asm (macro.import_function("sceCtrl", "0x1F803938", "sceCtrlReadBufferPositive"));
    asm (macro.import_function("sceCtrl", "0x60B81F86", "sceCtrlReadBufferNegative"));
    asm (macro.import_function("sceCtrl", "0xB1D0E5CD", "sceCtrlPeekLatch"));
    asm (macro.import_function("sceCtrl", "0x0B588501", "sceCtrlReadLatch"));
    asm (macro.import_function("sceCtrl", "0x348D99D4", "sceCtrl_348D99D4"));
    asm (macro.import_function("sceCtrl", "0xAF5960F3", "sceCtrl_AF5960F3"));
    asm (macro.import_function("sceCtrl", "0xA68FD260", "sceCtrlClearRapidFire"));
    asm (macro.import_function("sceCtrl", "0x6841BE1A", "sceCtrlSetRapidFire"));
    asm (macro.import_function("sceCtrl", "0xA7144800", "sceCtrlSetIdleCancelThreshold"));
    asm (macro.import_function("sceCtrl", "0x687660FA", "sceCtrlGetIdleCancelThreshold"));
}
