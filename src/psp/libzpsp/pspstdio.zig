const macro = @import("pspmacros.zig");

comptime {
    asm (macro.import_module_start("StdioForUser", "0x40010000", "9"));
    asm (macro.import_function("StdioForUser", "0x3054D478", "sceKernelStdioRead"));
    asm (macro.import_function("StdioForUser", "0x0CBB0571", "sceKernelStdioLseek"));
    asm (macro.import_function("StdioForUser", "0xA46785C9", "sceKernelStdioSendChar"));
    asm (macro.import_function("StdioForUser", "0xA3B931DB", "sceKernelStdioWrite"));
    asm (macro.import_function("StdioForUser", "0x9D061C19", "sceKernelStdioClose"));
    asm (macro.import_function("StdioForUser", "0x924ABA61", "sceKernelStdioOpen"));
    asm (macro.import_function("StdioForUser", "0x172D316E", "sceKernelStdin"));
    asm (macro.import_function("StdioForUser", "0xA6BAB2E9", "sceKernelStdout"));
    asm (macro.import_function("StdioForUser", "0xF78BA90A", "sceKernelStderr"));
}
