// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Create a new Network Configuration
/// @note This creates a new configuration at conf and clears 0
/// `conf` - Net Configuration number (1 to n)
/// Returns 0 on success
pub extern fn sceUtilityCreateNetParam(conf: c_int) callconv(.C) c_int;

/// Deletes a Network Configuration
/// `conf` - Net Configuration number (1 to n)
/// Returns 0 on success
pub extern fn sceUtilityDeleteNetParam(conf: c_int) callconv(.C) c_int;

/// Copies a Network Configuration to another
/// `src` - Source Net Configuration number (0 to n)
/// `dest` - Destination Net Configuration number (0 to n)
/// Returns 0 on success
pub extern fn sceUtilityCopyNetParam(src: c_int, dest: c_int) callconv(.C) c_int;

/// Sets a network parameter
/// @note This sets only to configuration 0
/// `param` - Which parameter to set
/// `val` - Pointer to the the data to set
/// Returns 0 on success
pub extern fn sceUtilitySetNetParam(param: c_int, val: ?*const anyopaque) callconv(.C) c_int;

comptime {
    asm(macro.import_module_start("sceUtility_netparam_internal", "0x40010000", "4"));
    asm(macro.import_function("sceUtility_netparam_internal", "0x072DEBF2", "sceUtilityCreateNetParam"));
    asm(macro.import_function("sceUtility_netparam_internal", "0x9CE50172", "sceUtilityDeleteNetParam"));
    asm(macro.import_function("sceUtility_netparam_internal", "0xFB0C4840", "sceUtilityCopyNetParam"));
    asm(macro.import_function("sceUtility_netparam_internal", "0xFC4516F3", "sceUtilitySetNetParam"));
}
