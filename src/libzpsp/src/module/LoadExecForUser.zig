// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Execute a new game executable, limited when not running in kernel mode.
/// `file` - The file to execute.
/// `param` - Pointer to a ::SceKernelLoadExecParam structure, or NULL.
/// Returns < 0 on error, probably.
pub extern fn sceKernelLoadExec(file: [*c]const c_char, param: [*c]c_int) callconv(.C) c_int;

pub extern fn sceKernelExitGameWithStatus() callconv(.C) void;

/// Exit game and go back to the PSP browser.
/// @note You need to be in a thread in order for this function to work
pub extern fn sceKernelExitGame() callconv(.C) void;

/// Register callback
/// @note By installing the exit callback the home button becomes active. However if sceKernelExitGame
/// is not called in the callback it is likely that the psp will just crash.
/// @par Example:
/// `
/// int exit_callback(void) { sceKernelExitGame(); }
/// cbid = sceKernelCreateCallback("ExitCallback", exit_callback, NULL);
/// sceKernelRegisterExitCallback(cbid);
/// `
/// `cbid Callback id`
/// Returns < 0 on error
pub extern fn sceKernelRegisterExitCallback(cbid: c_int) callconv(.C) c_int;

comptime {
    asm(macro.import_module_start("LoadExecForUser", "0x40010000", "4"));
    asm(macro.import_function("LoadExecForUser", "0xBD2F1094", "sceKernelLoadExec"));
    asm(macro.import_function("LoadExecForUser", "0x2AC9954B", "sceKernelExitGameWithStatus"));
    asm(macro.import_function("LoadExecForUser", "0x05572A5F", "sceKernelExitGame"));
    asm(macro.import_function("LoadExecForUser", "0x4AC57943", "sceKernelRegisterExitCallback"));
}
