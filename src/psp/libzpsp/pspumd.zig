const macro = @import("pspmacros.zig");

comptime {
    asm (macro.import_module_start("sceUmdUser", "0x40010011", "14"));
    asm (macro.import_function("sceUmdUser", "0x20628E6F", "sceUmdGetErrorStat"));
    asm (macro.import_function("sceUmdUser", "0x340B7686", "sceUmdGetDiscInfo"));
    asm (macro.import_function("sceUmdUser", "0x46EBB729", "sceUmdCheckMedium"));
    asm (macro.import_function("sceUmdUser", "0x4A9E5E29", "sceUmdWaitDriveStatCB"));
    asm (macro.import_function("sceUmdUser", "0x56202973", "sceUmdWaitDriveStatWithTimer"));
    asm (macro.import_function("sceUmdUser", "0x6AF9B50A", "sceUmdCancelWaitDriveStat"));
    asm (macro.import_function("sceUmdUser", "0x6B4A146C", "sceUmdGetDriveStat"));
    asm (macro.import_function("sceUmdUser", "0x87533940", "sceUmdReplaceProhibit"));
    asm (macro.import_function("sceUmdUser", "0x8EF08FCE", "sceUmdWaitDriveStat"));
    asm (macro.import_function("sceUmdUser", "0xAEE7404D", "sceUmdRegisterUMDCallBack"));
    asm (macro.import_function("sceUmdUser", "0xBD2BDE07", "sceUmdUnRegisterUMDCallBack"));
    asm (macro.import_function("sceUmdUser", "0xC6183D47", "sceUmdActivate"));
    asm (macro.import_function("sceUmdUser", "0xCBE9F02A", "sceUmdReplacePermit"));
    asm (macro.import_function("sceUmdUser", "0xE83742BA", "sceUmdDeactivate"));
}
