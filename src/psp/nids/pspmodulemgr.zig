const macro = @import("pspmacros.zig");

comptime {
    asm (macro.import_module_start("ModuleMgrForUser", "0x40010000", "11"));
    asm (macro.import_function("ModuleMgrForUser", "0xB7F46618", "sceKernelLoadModuleByID"));
    asm (macro.import_function("ModuleMgrForUser", "0x977DE386", "sceKernelLoadModule"));
    asm (macro.import_function("ModuleMgrForUser", "0x710F61B5", "sceKernelLoadModuleMs"));
    asm (macro.import_function("ModuleMgrForUser", "0xF9275D98", "sceKernelLoadModuleBufferUsbWlan"));
    asm (macro.import_function("ModuleMgrForUser", "0x50F0C1EC", "sceKernelStartModule_stub"));
    asm (macro.import_function("ModuleMgrForUser", "0xD1FF982A", "sceKernelStopModule_stub"));
    asm (macro.import_function("ModuleMgrForUser", "0x2E0911AA", "sceKernelUnloadModule"));
    asm (macro.import_function("ModuleMgrForUser", "0xD675EBB8", "sceKernelSelfStopUnloadModule"));
    asm (macro.import_function("ModuleMgrForUser", "0xCC1D3699", "sceKernelStopUnloadSelfModule"));
    asm (macro.import_function("ModuleMgrForUser", "0x748CBED9", "sceKernelQueryModuleInfo"));
    asm (macro.import_function("ModuleMgrForUser", "0x644395E2", "sceKernelGetModuleIdList"));

    asm (macro.generic_abi_wrapper("sceKernelStartModule", 5));
    asm (macro.generic_abi_wrapper("sceKernelStopModule", 5));
}
