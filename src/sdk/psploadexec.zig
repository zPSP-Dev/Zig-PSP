const libzpsp = @import("libzpsp");
const module = libzpsp.LoadExecForUser;

const SceKernelLoadExecParam = libzpsp.SceKernelLoadExecParam;

/// Execute a new game executable, limited when not running in kernel mode.
/// `file` - The file to execute.
/// `param` - Pointer to a ::SceKernelLoadExecParam structure, or NULL.
/// Returns < 0 on error, probably.
pub fn sceKernelLoadExec(file: [*c]const c_char, param: SceKernelLoadExecParam) c_int {
    return module.sceKernelLoadExec(file, &param);
}

// NOTE: Probably the wrong signature
pub fn sceKernelExitGameWithStatus() void {
    module.sceKernelExitGameWithStatus();
}

/// Exit game and go back to the PSP browser.
/// @note You need to be in a thread in order for this function to work
pub fn sceKernelExitGame() void {
    module.sceKernelExitGame();
}

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
pub fn sceKernelRegisterExitCallback(cbid: c_int) c_int {
    return module.sceKernelRegisterExitCallback(cbid);
}
