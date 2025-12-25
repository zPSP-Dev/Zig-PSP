// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

pub extern fn sceImposeGetHomePopup() callconv(.C) void;

pub extern fn sceImposeGetLanguageMode() callconv(.C) void;

pub extern fn sceImposeSetLanguageMode() callconv(.C) void;

pub extern fn sceImposeHomeButton() callconv(.C) void;

pub extern fn sceImposeSetHomePopup() callconv(.C) void;

pub extern fn sceImposeSetUMDPopup() callconv(.C) void;

pub extern fn sceImposeBatteryIconStatus() callconv(.C) void;

pub extern fn sceImposeGetBacklightOffTime() callconv(.C) void;

pub extern fn sceImposeSetBacklightOffTime() callconv(.C) void;

pub extern fn sceImpose_9BA61B49() callconv(.C) void;

pub extern fn sceImpose_A9884B00() callconv(.C) void;

pub extern fn sceImpose_BB3F5DEC() callconv(.C) void;

pub extern fn sceImposeGetUMDPopup() callconv(.C) void;

pub extern fn sceImpose_FCD44963() callconv(.C) void;

pub extern fn sceImpose_FF1A2F07() callconv(.C) void;

comptime {
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
    asm(macro.import_function("sceImpose", "0xA9884B00", "sceImpose_A9884B00"));
    asm(macro.import_function("sceImpose", "0xBB3F5DEC", "sceImpose_BB3F5DEC"));
    asm(macro.import_function("sceImpose", "0xE0887BC8", "sceImposeGetUMDPopup"));
    asm(macro.import_function("sceImpose", "0xFCD44963", "sceImpose_FCD44963"));
    asm(macro.import_function("sceImpose", "0xFF1A2F07", "sceImpose_FF1A2F07"));
}
