const macro = @import("pspmacros.zig");

comptime {
    asm (macro.import_module_start("UtilsForUser", "0x40010000", "26"));
    asm (macro.import_function("UtilsForUser", "0xBFA98062", "sceKernelDcacheInvalidateRange"));
    asm (macro.import_function("UtilsForUser", "0xC8186A58", "sceKernelUtilsMd5Digest"));
    asm (macro.import_function("UtilsForUser", "0x9E5C5086", "sceKernelUtilsMd5BlockInit"));
    asm (macro.import_function("UtilsForUser", "0x61E1E525", "sceKernelUtilsMd5BlockUpdate"));
    asm (macro.import_function("UtilsForUser", "0xB8D24E78", "sceKernelUtilsMd5BlockResult"));
    asm (macro.import_function("UtilsForUser", "0x840259F1", "sceKernelUtilsSha1Digest"));
    asm (macro.import_function("UtilsForUser", "0xF8FCD5BA", "sceKernelUtilsSha1BlockInit"));
    asm (macro.import_function("UtilsForUser", "0x346F6DA8", "sceKernelUtilsSha1BlockUpdate"));
    asm (macro.import_function("UtilsForUser", "0x585F1C09", "sceKernelUtilsSha1BlockResult"));
    asm (macro.import_function("UtilsForUser", "0xE860E75E", "sceKernelUtilsMt19937Init"));
    asm (macro.import_function("UtilsForUser", "0x06FB8A63", "sceKernelUtilsMt19937UInt"));
    asm (macro.import_function("UtilsForUser", "0x37FB5C42", "sceKernelGetGPI"));
    asm (macro.import_function("UtilsForUser", "0x6AD345D7", "sceKernelSetGPO"));
    asm (macro.import_function("UtilsForUser", "0x91E4F6A7", "sceKernelLibcClock"));
    asm (macro.import_function("UtilsForUser", "0x27CC57F0", "sceKernelLibcTime"));
    asm (macro.import_function("UtilsForUser", "0x71EC4271", "sceKernelLibcGettimeofday"));
    asm (macro.import_function("UtilsForUser", "0x79D1C3FA", "sceKernelDcacheWritebackAll"));
    asm (macro.import_function("UtilsForUser", "0xB435DEC5", "sceKernelDcacheWritebackInvalidateAll"));
    asm (macro.import_function("UtilsForUser", "0x3EE30821", "sceKernelDcacheWritebackRange"));
    asm (macro.import_function("UtilsForUser", "0x34B9FA9E", "sceKernelDcacheWritebackInvalidateRange"));
    asm (macro.import_function("UtilsForUser", "0x80001C4C", "sceKernelDcacheProbe"));
    asm (macro.import_function("UtilsForUser", "0x16641D70", "sceKernelDcacheReadTag"));
    asm (macro.import_function("UtilsForUser", "0x4FD31C9D", "sceKernelIcacheProbe"));
    asm (macro.import_function("UtilsForUser", "0xFB05FAD0", "sceKernelIcacheReadTag"));
    asm (macro.import_function("UtilsForUser", "0x920F104A", "sceKernelIcacheInvalidateAll"));
    asm (macro.import_function("UtilsForUser", "0xC2DF770E", "sceKernelIcacheInvalidateRange"));
}
