// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Initialise the Adhoc matching library
/// `memsize` - Internal memory pool size. Lumines uses 0x20000
/// Returns 0 on success, < 0 on error
pub extern fn sceNetAdhocMatchingInit(memsize: c_int) callconv(.c) c_int;

/// Terminate the Adhoc matching library
/// Returns 0 on success, < 0 on error
pub extern fn sceNetAdhocMatchingTerm() callconv(.c) c_int;

/// Create an Adhoc matching object
/// `mode` - One of ::pspAdhocMatchingModes
/// `maxpeers` - Maximum number of peers to match (only used when mode is PSP_ADHOC_MATCHING_MODE_HOST)
/// `port` - Port. Lumines uses 0x22B
/// `bufsize` - Receiving buffer size
/// `hellodelay` - Hello message send delay in microseconds (only used when mode is PSP_ADHOC_MATCHING_MODE_HOST or PSP_ADHOC_MATCHING_MODE_PTP)
/// `pingdelay` - Ping send delay in microseconds. Lumines uses 0x5B8D80 (only used when mode is PSP_ADHOC_MATCHING_MODE_HOST or PSP_ADHOC_MATCHING_MODE_PTP)
/// `initcount` - Initial count of the of the resend counter. Lumines uses 3
/// `msgdelay` - Message send delay in microseconds
/// `callback` - Callback to be called for matching
/// Returns ID of object on success, < 0 on error.
pub extern fn sceNetAdhocMatchingCreate(mode: c_int, maxpeers: c_int, port: c_ushort, bufsize: c_int, hellodelay: c_uint, pingdelay: c_uint, initcount: c_int, msgdelay: c_uint, callback: types.pspAdhocMatchingCallback) callconv(.c) c_int;

/// Start a matching object
/// `matchingid` - The ID returned from ::sceNetAdhocMatchingCreate
/// `evthpri` - Priority of the event handler thread. Lumines uses 0x10
/// `evthstack` - Stack size of the event handler thread. Lumines uses 0x2000
/// `inthpri` - Priority of the input handler thread. Lumines uses 0x10
/// `inthstack` - Stack size of the input handler thread. Lumines uses 0x2000
/// `optlen` - Size of hellodata
/// `optdata` - Pointer to block of data passed to callback
/// Returns 0 on success, < 0 on error
pub extern fn sceNetAdhocMatchingStart(matchingid: c_int, evthpri: c_int, evthstack: c_int, inthpri: c_int, inthstack: c_int, optlen: c_int, optdata: ?*anyopaque) callconv(.c) c_int;

/// Stop a matching object
/// `matchingid` - The ID returned from ::sceNetAdhocMatchingCreate
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocMatchingStop(matchingid: c_int) callconv(.c) c_int;

/// Delete an Adhoc matching object
/// `matchingid` - The ID returned from ::sceNetAdhocMatchingCreate
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocMatchingDelete(matchingid: c_int) callconv(.c) c_int;

/// Select a matching target
/// `matchingid` - The ID returned from ::sceNetAdhocMatchingCreate
/// `mac` - MAC address to select
/// `optlen` - Optional data length
/// `optdata` - Pointer to the optional data
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocMatchingSelectTarget(matchingid: c_int, mac: [*c]u8, optlen: c_int, optdata: ?*anyopaque) callconv(.c) c_int;

/// Cancel a matching target
/// `matchingid` - The ID returned from ::sceNetAdhocMatchingCreate
/// `mac` - The MAC address to cancel
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocMatchingCancelTarget(matchingid: c_int, mac: [*c]u8) callconv(.c) c_int;

/// Set the optional hello message
/// `matchingid` - The ID returned from ::sceNetAdhocMatchingCreate
/// `optlen` - Length of the hello data
/// `optdata` - Pointer to the hello data
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocMatchingSetHelloOpt(matchingid: c_int, optlen: c_int, optdata: ?*anyopaque) callconv(.c) c_int;

/// Get the optional hello message
/// `matchingid` - The ID returned from ::sceNetAdhocMatchingCreate
/// `optlen` - Length of the hello data
/// `optdata` - Pointer to the hello data
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocMatchingGetHelloOpt(matchingid: c_int, optlen: [*c]c_int, optdata: ?*anyopaque) callconv(.c) c_int;

/// Get a list of matching members
/// `matchingid` - The ID returned from ::sceNetAdhocMatchingCreate
/// `length` - The length of the list.
/// `buf` - An allocated area of size length.
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocMatchingGetMembers(matchingid: c_int, length: [*c]c_int, buf: ?*anyopaque) callconv(.c) c_int;

/// Get the maximum memory usage by the matching library
/// Returns The memory usage on success, < 0 on error.
pub extern fn sceNetAdhocMatchingGetPoolMaxAlloc() callconv(.c) c_int;

/// Cancel a matching target (with optional data)
/// `matchingid` - The ID returned from ::sceNetAdhocMatchingCreate
/// `mac` - The MAC address to cancel
/// `optlen` - Optional data length
/// `optdata` - Pointer to the optional data
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocMatchingCancelTargetWithOpt(matchingid: c_int, mac: [*c]u8, optlen: c_int, optdata: ?*anyopaque) callconv(.c) c_int;

/// Get the status of the memory pool used by the matching library
/// `poolstat` - A ::pspAdhocPoolStat.
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocMatchingGetPoolStat(poolstat: [*c]c_int) callconv(.c) c_int;

/// Send data to a matching target
/// `matchingid` - The ID returned from ::sceNetAdhocMatchingCreate
/// `mac` - The MAC address to send the data to
/// `datalen` - Length of the data
/// `data` - Pointer to the data
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocMatchingSendData(matchingid: c_int, mac: [*c]u8, datalen: c_int, data: ?*anyopaque) callconv(.c) c_int;

/// Abort a data send to a matching target
/// `matchingid` - The ID returned from ::sceNetAdhocMatchingCreate
/// `mac` - The MAC address to send the data to
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocMatchingAbortSendData(matchingid: c_int, mac: [*c]u8) callconv(.c) c_int;

comptime {
    asm (macro.import_module_start("sceNetAdhocMatching", "0x00090000", "16"));
    asm (macro.import_function("sceNetAdhocMatching", "0x2A2A1E07", "sceNetAdhocMatchingInit"));
    asm (macro.import_function("sceNetAdhocMatching", "0x7945ECDA", "sceNetAdhocMatchingTerm"));
    asm (macro.import_function("sceNetAdhocMatching", "0xCA5EDA6F", "sceNetAdhocMatchingCreate_stub"));
    asm (macro.generic_abi_wrapper("sceNetAdhocMatchingCreate", 9));
    asm (macro.import_function("sceNetAdhocMatching", "0x93EF3843", "sceNetAdhocMatchingStart_stub"));
    asm (macro.generic_abi_wrapper("sceNetAdhocMatchingStart", 7));
    asm (macro.import_function("sceNetAdhocMatching", "0x32B156B3", "sceNetAdhocMatchingStop"));
    asm (macro.import_function("sceNetAdhocMatching", "0xF16EAF4F", "sceNetAdhocMatchingDelete"));
    asm (macro.import_function("sceNetAdhocMatching", "0x5E3D4B79", "sceNetAdhocMatchingSelectTarget"));
    asm (macro.import_function("sceNetAdhocMatching", "0xEA3C6108", "sceNetAdhocMatchingCancelTarget"));
    asm (macro.import_function("sceNetAdhocMatching", "0xB58E61B7", "sceNetAdhocMatchingSetHelloOpt"));
    asm (macro.import_function("sceNetAdhocMatching", "0xB5D96C2A", "sceNetAdhocMatchingGetHelloOpt"));
    asm (macro.import_function("sceNetAdhocMatching", "0xC58BCD9E", "sceNetAdhocMatchingGetMembers"));
    asm (macro.import_function("sceNetAdhocMatching", "0x40F8F435", "sceNetAdhocMatchingGetPoolMaxAlloc"));
    asm (macro.import_function("sceNetAdhocMatching", "0x8F58BEDF", "sceNetAdhocMatchingCancelTargetWithOpt"));
    asm (macro.import_function("sceNetAdhocMatching", "0x9C5CFB7D", "sceNetAdhocMatchingGetPoolStat"));
    asm (macro.import_function("sceNetAdhocMatching", "0xF79472D7", "sceNetAdhocMatchingSendData"));
    asm (macro.import_function("sceNetAdhocMatching", "0xEC19337D", "sceNetAdhocMatchingAbortSendData"));
}
