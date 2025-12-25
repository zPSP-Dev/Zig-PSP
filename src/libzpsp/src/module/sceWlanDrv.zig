// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Determine if the wlan device is currently powered on
/// Returns 0 if off, 1 if on
pub extern fn sceWlanDevIsPowerOn() callconv(.C) c_int;

/// Determine the state of the Wlan power switch
/// Returns 0 if off, 1 if on
pub extern fn sceWlanGetSwitchState() callconv(.C) c_int;

/// Get the Ethernet Address of the wlan controller
/// `etherAddr` - pointer to a buffer of uint8_t (NOTE: it only writes to 6 bytes, but
/// requests 8 so pass it 8 bytes just in case)
/// Returns 0 on success, < 0 on error
pub extern fn sceWlanGetEtherAddr(etherAddr: [*c]u8) callconv(.C) c_int;

comptime {
    asm (macro.import_module_start("sceWlanDrv", "0x40010000", "3"));
    asm (macro.import_function("sceWlanDrv", "0x93440B11", "sceWlanDevIsPowerOn"));
    asm (macro.import_function("sceWlanDrv", "0xD7763699", "sceWlanGetSwitchState"));
    asm (macro.import_function("sceWlanDrv", "0x0C622081", "sceWlanGetEtherAddr"));
}
