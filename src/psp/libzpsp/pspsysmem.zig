const macro = @import("pspmacros.zig");

comptime {
    asm (macro.import_module_start("SysMemUserForUser", "0x40000000", "9"));
    asm (macro.import_function("SysMemUserForUser", "0xA291F107", "sceKernelMaxFreeMemSize"));
    asm (macro.import_function("SysMemUserForUser", "0xF919F628", "sceKernelTotalFreeMemSize"));
    asm (macro.import_function("SysMemUserForUser", "0x237DBD4F", "sceKernelAllocPartitionMemory"));
    asm (macro.import_function("SysMemUserForUser", "0xB6D61D02", "sceKernelFreePartitionMemory"));
    asm (macro.import_function("SysMemUserForUser", "0x9D9A5BA1", "sceKernelGetBlockHeadAddr"));
    asm (macro.import_function("SysMemUserForUser", "0x3FC9AE6A", "sceKernelDevkitVersion"));
    asm (macro.import_function("SysMemUserForUser", "0x13A5ABEF", "sceKernelPrintf"));
    asm (macro.import_function("SysMemUserForUser", "0x7591C7DB", "sceKernelSetCompiledSdkVersion"));
    asm (macro.import_function("SysMemUserForUser", "0xFC114573", "sceKernelGetCompiledSdkVersion"));
}
