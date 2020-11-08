usingnamespace @import("psptypes.zig");

pub const SceKernelLoadExecParam = extern struct {
    size: SceSize,
    args: SceSize,
    argp: ?*c_void,
    key: [*c]const u8,
};

// Register callback
//
// By installing the exit callback the home button becomes active. However if sceKernelExitGame
// is not called in the callback it is likely that the psp will just crash.
//
// @par Example:
// @code
// int exit_callback(void) { sceKernelExitGame(); }
//
// cbid = sceKernelCreateCallback("ExitCallback", exit_callback, NULL);
// sceKernelRegisterExitCallback(cbid);
// @endcode
//
// @param cbid Callback id
// @return < 0 on error
pub extern fn sceKernelRegisterExitCallback(cbid: c_int) c_int;

// Execute a new game executable, limited when not running in kernel mode.
//
// @param file - The file to execute.
// @param param - Pointer to a ::SceKernelLoadExecParam structure, or NULL.
//
// @return < 0 on error, probably.
pub extern fn sceKernelLoadExec(file: []const u8, param: ?*SceKernelLoadExecParam) c_int;

// Exit game and go back to the PSP browser.
//
// @note You need to be in a thread in order for this function to work
pub extern fn sceKernelExitGame() void;
