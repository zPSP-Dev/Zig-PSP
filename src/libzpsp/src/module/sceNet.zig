// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Initialise the networking library
/// `poolsize` - Memory pool size (appears to be for the whole of the networking library).
/// `calloutprio` - Priority of the SceNetCallout thread.
/// `calloutstack` - Stack size of the SceNetCallout thread (defaults to 4096 on non 1.5 firmware regardless of what value is passed).
/// `netintrprio` - Priority of the SceNetNetintr thread.
/// `netintrstack` - Stack size of the SceNetNetintr thread (defaults to 4096 on non 1.5 firmware regardless of what value is passed).
/// Returns 0 on success, < 0 on error
pub extern fn sceNetInit(poolsize: c_int, calloutprio: c_int, calloutstack: c_int, netintrprio: c_int, netintrstack: c_int) callconv(.c) c_int;

/// Terminate the networking library
/// Returns 0 on success, < 0 on error
pub extern fn sceNetTerm() callconv(.c) c_int;

/// Free (delete) thread info/data
/// `thid` - The thread id.
/// Returns 0 on success, < 0 on error
pub extern fn sceNetFreeThreadinfo(thid: c_int) callconv(.c) c_int;

/// Abort a thread
/// `thid` - The thread id.
/// Returns 0 on success, < 0 on error
pub extern fn sceNetThreadAbort(thid: c_int) callconv(.c) c_int;

/// Convert Mac address to a string
/// `mac` - The Mac address to convert.
/// `name` - Pointer to a buffer to store the result.
pub extern fn sceNetEtherNtostr(mac: [*c]u8, name: [*c]c_char) callconv(.c) void;

/// Convert string to a Mac address
/// `name` - The string to convert.
/// `mac` - Pointer to a buffer to store the result.
pub extern fn sceNetEtherStrton(name: [*c]c_char, mac: [*c]u8) callconv(.c) void;

/// Retrieve the local Mac address
/// `mac` - Pointer to a buffer to store the result.
/// Returns 0 on success, < 0 on error
pub extern fn sceNetGetLocalEtherAddr(mac: [*c]u8) callconv(.c) c_int;

/// Retrieve the networking library memory usage
/// `stat` - Pointer to a ::SceNetMallocStat type to store the result.
/// Returns 0 on success, < 0 on error
pub extern fn sceNetGetMallocStat(stat: [*c]types.SceNetMallocStat) callconv(.c) c_int;

comptime {
    asm (macro.import_module_start("sceNet", "0x00090000", "8"));
    asm (macro.import_function("sceNet", "0x39AF39A6", "sceNetInit_stub"));
    asm (macro.generic_abi_wrapper("sceNetInit", 5));
    asm (macro.import_function("sceNet", "0x281928A9", "sceNetTerm"));
    asm (macro.import_function("sceNet", "0x50647530", "sceNetFreeThreadinfo"));
    asm (macro.import_function("sceNet", "0xAD6844C6", "sceNetThreadAbort"));
    asm (macro.import_function("sceNet", "0x89360950", "sceNetEtherNtostr"));
    asm (macro.import_function("sceNet", "0xD27961C9", "sceNetEtherStrton"));
    asm (macro.import_function("sceNet", "0x0BF0A3AE", "sceNetGetLocalEtherAddr"));
    asm (macro.import_function("sceNet", "0xCC393E48", "sceNetGetMallocStat"));
}
