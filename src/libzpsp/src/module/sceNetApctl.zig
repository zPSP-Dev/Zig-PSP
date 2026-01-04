// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Init the apctl.
/// `stackSize` - The stack size of the internal thread.
/// `initPriority` - The priority of the internal thread.
/// Returns < 0 on error.
pub extern fn sceNetApctlInit(stackSize: c_int, initPriority: c_int) callconv(.c) c_int;

/// Terminate the apctl.
/// Returns < 0 on error.
pub extern fn sceNetApctlTerm() callconv(.c) c_int;

/// Get the apctl information.
/// `code` - One of the PSP_NET_APCTL_INFO_* defines.
/// `pInfo` - Pointer to a ::SceNetApctlInfo.
/// Returns < 0 on error.
pub extern fn sceNetApctlGetInfo(code: c_int, pInfo: [*c]types.SceNetApctlInfo) callconv(.c) c_int;

/// Add an apctl event handler.
/// `handler` - Pointer to the event handler function.
/// `pArg` - Value to be passed to the pArg parameter of the handler function.
/// Returns A handler id or < 0 on error.
pub extern fn sceNetApctlAddHandler(handler: types.sceNetApctlHandler, pArg: ?*anyopaque) callconv(.c) c_int;

/// Delete an apctl event handler.
/// `handlerId` - A handler as created returned from sceNetApctlAddHandler.
/// Returns < 0 on error.
pub extern fn sceNetApctlDelHandler(handlerId: c_int) callconv(.c) c_int;

/// Connect to an access point.
/// `connIndex` - The index of the connection.
/// Returns < 0 on error.
pub extern fn sceNetApctlConnect(connIndex: c_int) callconv(.c) c_int;

/// Disconnect from an access point.
/// Returns < 0 on error.
pub extern fn sceNetApctlDisconnect() callconv(.c) c_int;

/// Get the state of the access point connection.
/// `pState` - Pointer to receive the current state (one of the PSP_NET_APCTL_STATE_* defines).
/// Returns < 0 on error.
pub extern fn sceNetApctlGetState(pState: [*c]c_int) callconv(.c) c_int;

comptime {
    asm (macro.import_module_start("sceNetApctl", "0x00090000", "8"));
    asm (macro.import_function("sceNetApctl", "0xE2F91F9B", "sceNetApctlInit"));
    asm (macro.import_function("sceNetApctl", "0xB3EDD0EC", "sceNetApctlTerm"));
    asm (macro.import_function("sceNetApctl", "0x2BEFDF23", "sceNetApctlGetInfo"));
    asm (macro.import_function("sceNetApctl", "0x8ABADD51", "sceNetApctlAddHandler"));
    asm (macro.import_function("sceNetApctl", "0x5963991B", "sceNetApctlDelHandler"));
    asm (macro.import_function("sceNetApctl", "0xCFB957C6", "sceNetApctlConnect"));
    asm (macro.import_function("sceNetApctl", "0x24FE91A1", "sceNetApctlDisconnect"));
    asm (macro.import_function("sceNetApctl", "0x5DEAC81B", "sceNetApctlGetState"));
}
