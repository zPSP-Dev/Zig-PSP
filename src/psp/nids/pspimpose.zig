const macro = @import("pspmacros.zig");

comptime{
    asm(macro.import_module_start("sceImpose", "0x40010011", "15"));
    asm(macro.import_function("sceImpose", "0x0F341BE4", "sceImposeGetHomePopup"));
    asm(macro.import_function("sceImpose", "0x24FD7BCF", "sceImposeGetLanguageMode"));
    asm(macro.import_function("sceImpose", "0x36AA6E91", "sceImposeSetLanguageMode"));
    asm(macro.import_function("sceImpose", "0x381BD9E7", "sceImposeHomeButton"));
    asm(macro.import_function("sceImpose", "0x5595A71A", "sceImposeSetHomePopup"));
    asm(macro.import_function("sceImpose", "0x72189C48", "sceImposeSetUMDPopup"));
    asm(macro.import_function("sceImpose", "0x8C943191", "sceImposeBatteryIconStatus"));
    asm(macro.import_function("sceImpose", "0x8F6E3518", "sceImposeGetBacklightOffTime"));
    asm(macro.import_function("sceImpose", "0x967F6D4A", "sceImposeSetBacklightOffTime"));
    asm(macro.import_function("sceImpose", "0x9BA61B49", "sceImpose_9BA61B49"));
    asm(macro.import_function("sceImpose", "0xBB3F5DEC", "sceImpose_BB3F5DEC"));
    asm(macro.import_function("sceImpose", "0xE0887BC8", "sceImposeGetUMDPopup"));
}
