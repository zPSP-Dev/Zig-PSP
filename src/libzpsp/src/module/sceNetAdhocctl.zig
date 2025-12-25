// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Initialise the Adhoc control library
/// `stacksize` - Stack size of the adhocctl thread. Set to 0x2000
/// `priority` - Priority of the adhocctl thread. Set to 0x30
/// `product` - Pass a filled in ::productStruct
/// Returns 0 on success, < 0 on error
pub extern fn sceNetAdhocctlInit(stacksize: c_int, priority: c_int, product: [*c]c_int) callconv(.C) c_int;

/// Terminate the Adhoc control library
/// Returns 0 on success, < on error.
pub extern fn sceNetAdhocctlTerm() callconv(.C) c_int;

/// Connect to the Adhoc control
/// `name` - The name of the connection (maximum 8 alphanumeric characters).
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocctlConnect(name: [*c]const c_char) callconv(.C) c_int;

/// Connect to the Adhoc control (as a host)
/// `name` - The name of the connection (maximum 8 alphanumeric characters).
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocctlCreate(name: [*c]const c_char) callconv(.C) c_int;

/// Connect to the Adhoc control (as a client)
/// `scaninfo` - A valid ::SceNetAdhocctlScanInfo struct that has been filled by sceNetAchocctlGetScanInfo
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocctlJoin(scaninfo: [*c]c_int) callconv(.C) c_int;

/// Scan the adhoc channels
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocctlScan() callconv(.C) c_int;

/// Disconnect from the Adhoc control
/// Returns 0 on success, < 0 on error
pub extern fn sceNetAdhocctlDisconnect() callconv(.C) c_int;

/// Register an adhoc event handler
/// `handler` - The event handler.
/// `unknown` - Pass NULL.
/// Returns Handler id on success, < 0 on error.
pub extern fn sceNetAdhocctlAddHandler(handler: c_int, unknown: ?*anyopaque) callconv(.C) c_int;

/// Delete an adhoc event handler
/// `id` - The handler id as returned by sceNetAdhocctlAddHandler.
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocctlDelHandler(id: c_int) callconv(.C) c_int;

/// Get the state of the Adhoc control
/// `event` - Pointer to an integer to receive the status. Can continue when it becomes 1.
/// Returns 0 on success, < 0 on error
pub extern fn sceNetAdhocctlGetState(event: [*c]c_int) callconv(.C) c_int;

/// Get the adhoc ID
/// `product` - A pointer to a  ::productStruct
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocctlGetAdhocId(product: [*c]c_int) callconv(.C) c_int;

/// Get a list of peers
/// `length` - The length of the list.
/// `buf` - An allocated area of size length.
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocctlGetPeerList(length: [*c]c_int, buf: ?*anyopaque) callconv(.C) c_int;

/// Get mac address from nickname
/// `nickname` - The nickname.
/// `length` - The length of the list.
/// `buf` - An allocated area of size length.
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocctlGetAddrByName(nickname: [*c]c_char, length: [*c]c_int, buf: ?*anyopaque) callconv(.C) c_int;

/// Get nickname from a mac address
/// `mac` - The mac address.
/// `nickname` - Pointer to a char buffer where the nickname will be stored.
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocctlGetNameByAddr(mac: [*c]u8, nickname: [*c]c_char) callconv(.C) c_int;

/// Get Adhocctl parameter
/// `params` - Pointer to a ::SceNetAdhocctlParams
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocctlGetParameter(params: [*c]c_int) callconv(.C) c_int;

/// Get the results of a scan
/// `length` - The length of the list.
/// `buf` - An allocated area of size length.
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocctlGetScanInfo(length: [*c]c_int, buf: ?*anyopaque) callconv(.C) c_int;

/// Connect to the Adhoc control game mode (as a host)
/// `name` - The name of the connection (maximum 8 alphanumeric characters).
/// `unknown` - Pass 1.
/// `num` - The total number of players (including the host).
/// `macs` - A pointer to a list of the participating mac addresses, host first, then clients.
/// `timeout` - Timeout in microseconds.
/// `unknown2` - pass 0.
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocctlCreateEnterGameMode(name: [*c]const c_char, unknown: c_int, num: c_int, macs: [*c]u8, timeout: c_uint, unknown2: c_int) callconv(.C) c_int;

/// Connect to the Adhoc control game mode (as a client)
/// `name` - The name of the connection (maximum 8 alphanumeric characters).
/// `hostmac` - The mac address of the host.
/// `timeout` - Timeout in microseconds.
/// `unknown` - pass 0.
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocctlJoinEnterGameMode(name: [*c]const c_char, hostmac: [*c]u8, timeout: c_uint, unknown: c_int) callconv(.C) c_int;

/// Exit game mode.
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocctlExitGameMode() callconv(.C) c_int;

/// Get game mode information
/// `gamemodeinfo` - Pointer to store the info.
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocctlGetGameModeInfo(gamemodeinfo: [*c]c_int) callconv(.C) c_int;

/// Get peer information
/// `mac` - The mac address of the peer.
/// `size` - Size of peerinfo.
/// `peerinfo` - Pointer to store the information.
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocctlGetPeerInfo(mac: [*c]u8, size: c_int, peerinfo: [*c]c_int) callconv(.C) c_int;

comptime {
    asm (macro.import_module_start("sceNetAdhocctl", "0x00090000", "21"));
    asm (macro.import_function("sceNetAdhocctl", "0xE26F226E", "sceNetAdhocctlInit"));
    asm (macro.import_function("sceNetAdhocctl", "0x9D689E13", "sceNetAdhocctlTerm"));
    asm (macro.import_function("sceNetAdhocctl", "0x0AD043ED", "sceNetAdhocctlConnect"));
    asm (macro.import_function("sceNetAdhocctl", "0xEC0635C1", "sceNetAdhocctlCreate"));
    asm (macro.import_function("sceNetAdhocctl", "0x5E7F79C9", "sceNetAdhocctlJoin"));
    asm (macro.import_function("sceNetAdhocctl", "0x08FFF7A0", "sceNetAdhocctlScan"));
    asm (macro.import_function("sceNetAdhocctl", "0x34401D65", "sceNetAdhocctlDisconnect"));
    asm (macro.import_function("sceNetAdhocctl", "0x20B317A0", "sceNetAdhocctlAddHandler"));
    asm (macro.import_function("sceNetAdhocctl", "0x6402490B", "sceNetAdhocctlDelHandler"));
    asm (macro.import_function("sceNetAdhocctl", "0x75ECD386", "sceNetAdhocctlGetState"));
    asm (macro.import_function("sceNetAdhocctl", "0x362CBE8F", "sceNetAdhocctlGetAdhocId"));
    asm (macro.import_function("sceNetAdhocctl", "0xE162CB14", "sceNetAdhocctlGetPeerList"));
    asm (macro.import_function("sceNetAdhocctl", "0x99560ABE", "sceNetAdhocctlGetAddrByName"));
    asm (macro.import_function("sceNetAdhocctl", "0x8916C003", "sceNetAdhocctlGetNameByAddr"));
    asm (macro.import_function("sceNetAdhocctl", "0xDED9D28E", "sceNetAdhocctlGetParameter"));
    asm (macro.import_function("sceNetAdhocctl", "0x81AEE1BE", "sceNetAdhocctlGetScanInfo"));
    asm (macro.import_function("sceNetAdhocctl", "0xA5C055CE", "sceNetAdhocctlCreateEnterGameMode_stub"));
    asm (macro.generic_abi_wrapper("sceNetAdhocctlCreateEnterGameMode", 6));
    asm (macro.import_function("sceNetAdhocctl", "0x1FF89745", "sceNetAdhocctlJoinEnterGameMode"));
    asm (macro.import_function("sceNetAdhocctl", "0xCF8E084D", "sceNetAdhocctlExitGameMode"));
    asm (macro.import_function("sceNetAdhocctl", "0x5A014CE0", "sceNetAdhocctlGetGameModeInfo"));
    asm (macro.import_function("sceNetAdhocctl", "0x8DB83FDC", "sceNetAdhocctlGetPeerInfo"));
}
