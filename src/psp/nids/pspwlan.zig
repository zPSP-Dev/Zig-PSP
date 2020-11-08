const macro = @import("pspmacros.zig");

comptime {
    asm (macro.import_module_start("sceWlanDrv", "0x40010000", "3"));
    asm (macro.import_function("sceWlanDrv", "0x93440B11", "sceWlanDevIsPowerOn"));
    asm (macro.import_function("sceWlanDrv", "0xD7763699", "sceWlanGetSwitchState"));
    asm (macro.import_function("sceWlanDrv", "0x0C622081", "sceWlanGetEtherAddr"));
}
