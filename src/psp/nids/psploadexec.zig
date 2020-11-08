const macro = @import("pspmacros.zig");

comptime {
    asm (macro.import_module_start("LoadExecForUser", "0x40010000", "3"));
    asm (macro.import_function("LoadExecForUser", "0xBD2F1094", "sceKernelLoadExec"));
    asm (macro.import_function("LoadExecForUser", "0x05572A5F", "sceKernelExitGame"));
    asm (macro.import_function("LoadExecForUser", "0x4AC57943", "sceKernelRegisterExitCallback"));
}
