// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Get the error code associated with a failed event
/// Returns < 0 on error, the error code on success
pub extern fn sceUmdGetErrorStat() callconv(.C) c_int;

/// Get the disc info
/// `info` - A pointer to a ::pspUmdInfo struct
/// Returns < 0 on error
pub extern fn sceUmdGetDiscInfo(info: [*c]c_int) callconv(.C) c_int;

/// Check whether there is a disc in the UMD drive
/// Returns 0 if no disc present, anything else indicates a disc is inserted.
pub extern fn sceUmdCheckMedium() callconv(.C) c_int;

/// Wait for the UMD drive to reach a certain state (plus callback)
/// `stat` - One or more of ::pspUmdState
/// `timeout` - Timeout value in microseconds
/// Returns < 0 on error
pub extern fn sceUmdWaitDriveStatCB(stat: c_int, timeout: c_uint) callconv(.C) c_int;

/// Wait for the UMD drive to reach a certain state
/// `stat` - One or more of ::pspUmdState
/// `timeout` - Timeout value in microseconds
/// Returns < 0 on error
pub extern fn sceUmdWaitDriveStatWithTimer(stat: c_int, timeout: c_uint) callconv(.C) c_int;

/// Cancel a sceUmdWait* call
/// Returns < 0 on error
pub extern fn sceUmdCancelWaitDriveStat() callconv(.C) c_int;

/// Get (poll) the current state of the UMD drive
/// Returns < 0 on error, one or more of ::pspUmdState on success
pub extern fn sceUmdGetDriveStat() callconv(.C) c_int;

/// Prohibit UMD disc being replaced
/// Returns < 0 on error
pub extern fn sceUmdReplaceProhibit() callconv(.C) c_int;

/// Wait for the UMD drive to reach a certain state
/// `stat` - One or more of ::pspUmdState
/// Returns < 0 on error
pub extern fn sceUmdWaitDriveStat(stat: c_int) callconv(.C) c_int;

/// Register a callback for the UMD drive
/// @note Callback is of type UmdCallback
/// `cbid` - A callback ID created from sceKernelCreateCallback
/// Returns < 0 on error
/// @par Example:
/// `
/// int umd_callback(int unknown, int event)
/// {
/// //do something
/// }
/// int cbid = sceKernelCreateCallback("UMD Callback", umd_callback, NULL);
/// sceUmdRegisterUMDCallBack(cbid);
/// `
pub extern fn sceUmdRegisterUMDCallBack(cbid: c_int) callconv(.C) c_int;

/// Un-register a callback for the UMD drive
/// `cbid` - A callback ID created from sceKernelCreateCallback
/// Returns < 0 on error
pub extern fn sceUmdUnRegisterUMDCallBack(cbid: c_int) callconv(.C) c_int;

/// Activates the UMD drive
/// `unit` - The unit to initialise (probably). Should be set to 1.
/// `drive` - A prefix string for the fs device to mount the UMD on (e.g. "disc0:")
/// Returns < 0 on error
/// @par Example:
/// `
/// // Wait for disc and mount to filesystem
/// int i;
/// i = sceUmdCheckMedium();
/// if(i == 0)
/// {
/// sceUmdWaitDriveStat(PSP_UMD_PRESENT);
/// }
/// sceUmdActivate(1, "disc0:"); // Mount UMD to disc0: file system
/// sceUmdWaitDriveStat(PSP_UMD_READY);
/// // Now you can access the UMD using standard sceIo functions
/// `
pub extern fn sceUmdActivate(unit: c_int, drive: [*c]const c_char) callconv(.C) c_int;

/// Permit UMD disc being replaced
/// Returns < 0 on error
pub extern fn sceUmdReplacePermit() callconv(.C) c_int;

/// Deativates the UMD drive
/// `unit` - The unit to initialise (probably). Should be set to 1.
/// `drive` - A prefix string for the fs device to mount the UMD on (e.g. "disc0:")
/// Returns < 0 on error
pub extern fn sceUmdDeactivate(unit: c_int, drive: [*c]const c_char) callconv(.C) c_int;

comptime {
    asm (macro.import_module_start("sceUmdUser", "0x40010011", "14"));
    asm (macro.import_function("sceUmdUser", "0x20628E6F", "sceUmdGetErrorStat"));
    asm (macro.import_function("sceUmdUser", "0x340B7686", "sceUmdGetDiscInfo"));
    asm (macro.import_function("sceUmdUser", "0x46EBB729", "sceUmdCheckMedium"));
    asm (macro.import_function("sceUmdUser", "0x4A9E5E29", "sceUmdWaitDriveStatCB"));
    asm (macro.import_function("sceUmdUser", "0x56202973", "sceUmdWaitDriveStatWithTimer"));
    asm (macro.import_function("sceUmdUser", "0x6AF9B50A", "sceUmdCancelWaitDriveStat"));
    asm (macro.import_function("sceUmdUser", "0x6B4A146C", "sceUmdGetDriveStat"));
    asm (macro.import_function("sceUmdUser", "0x87533940", "sceUmdReplaceProhibit"));
    asm (macro.import_function("sceUmdUser", "0x8EF08FCE", "sceUmdWaitDriveStat"));
    asm (macro.import_function("sceUmdUser", "0xAEE7404D", "sceUmdRegisterUMDCallBack"));
    asm (macro.import_function("sceUmdUser", "0xBD2BDE07", "sceUmdUnRegisterUMDCallBack"));
    asm (macro.import_function("sceUmdUser", "0xC6183D47", "sceUmdActivate"));
    asm (macro.import_function("sceUmdUser", "0xCBE9F02A", "sceUmdReplacePermit"));
    asm (macro.import_function("sceUmdUser", "0xE83742BA", "sceUmdDeactivate"));
}
