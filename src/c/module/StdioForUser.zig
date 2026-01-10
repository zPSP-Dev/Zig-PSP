// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

pub extern fn sceKernelStdioRead() callconv(.c) void;

pub extern fn sceKernelStdioLseek() callconv(.c) void;

pub extern fn sceKernelStdioSendChar() callconv(.c) void;

pub extern fn sceKernelStdioWrite() callconv(.c) void;

pub extern fn sceKernelStdioClose() callconv(.c) void;

pub extern fn sceKernelStdioOpen() callconv(.c) void;

/// Function to get the current standard in file no
/// Returns The stdin fileno
pub extern fn sceKernelStdin() callconv(.c) types.SceUID;

/// Function to get the current standard out file no
/// Returns The stdout fileno
pub extern fn sceKernelStdout() callconv(.c) types.SceUID;

/// Function to get the current standard err file no
/// Returns The stderr fileno
pub extern fn sceKernelStderr() callconv(.c) types.SceUID;

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
