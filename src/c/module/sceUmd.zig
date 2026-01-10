// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

pub extern fn sceUmd_075F1E0B() callconv(.c) void;

pub extern fn sceUmd_086DDC0D() callconv(.c) void;

pub extern fn sceUmdSetDriveStatus() callconv(.c) void;

pub extern fn sceUmd_27A764A1() callconv(.c) void;

pub extern fn sceUmd_2D81508D() callconv(.c) void;

pub extern fn sceUmd_319ED97C() callconv(.c) void;

/// Get the disc info
/// `info` - A pointer to a ::pspUmdInfo struct
/// Returns < 0 on error
pub extern fn sceUmdGetDiscInfo(info: [*c]types.pspUmdInfo) callconv(.c) c_int;

pub extern fn sceUmd_3925CBD8() callconv(.c) void;

pub extern fn sceUmd_3D0DECD5() callconv(.c) void;

/// Check whether there is a disc in the UMD drive
/// Returns 0 if no disc present, anything else indicates a disc is inserted.
pub extern fn sceUmdCheckMedium() callconv(.c) c_int;

pub extern fn sceUmd_4832ABF3() callconv(.c) void;

/// Wait for the UMD drive to reach a certain state (plus callback)
/// `stat` - One or more of ::pspUmdState
/// `timeout` - Timeout value in microseconds
/// Returns < 0 on error
pub extern fn sceUmdWaitDriveStatCB(stat: c_int, timeout: c_uint) callconv(.c) c_int;

pub extern fn sceUmd_4BA25F4A() callconv(.c) void;

pub extern fn sceUmdSetSuspendResumeMode() callconv(.c) void;

pub extern fn sceUmd_5469DC37() callconv(.c) void;

/// Wait for the UMD drive to reach a certain state
/// `stat` - One or more of ::pspUmdState
/// `timeout` - Timeout value in microseconds
/// Returns < 0 on error
pub extern fn sceUmdWaitDriveStatWithTimer(stat: c_int, timeout: c_uint) callconv(.c) c_int;

pub extern fn sceUmd_659587F7() callconv(.c) void;

pub extern fn sceUmdGetSuspendResumeMode() callconv(.c) void;

pub extern fn sceUmd_6AF9B50A() callconv(.c) void;

pub extern fn sceUmd_71F81482() callconv(.c) void;

pub extern fn sceUmd_7850F057() callconv(.c) void;

/// Prohibit UMD disc being replaced
/// Returns < 0 on error
pub extern fn sceUmdReplaceProhibit() callconv(.c) c_int;

/// Wait for the UMD drive to reach a certain state
/// `stat` - One or more of ::pspUmdState
/// Returns < 0 on error
pub extern fn sceUmdWaitDriveStat(stat: c_int) callconv(.c) c_int;

pub extern fn sceUmd_9B22AED7() callconv(.c) void;

pub extern fn sceUmdClearDriveStatus() callconv(.c) void;

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
pub extern fn sceUmdRegisterUMDCallBack(cbid: c_int) callconv(.c) c_int;

pub extern fn sceUmd_BBB5F05C() callconv(.c) void;

/// Un-register a callback for the UMD drive
/// `cbid` - A callback ID created from sceKernelCreateCallback
/// Returns < 0 on error
pub extern fn sceUmdUnRegisterUMDCallBack(cbid: c_int) callconv(.c) c_int;

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
pub extern fn sceUmdActivate(unit: c_int, drive: [*c]const c_char) callconv(.c) c_int;

/// Permit UMD disc being replaced
/// Returns < 0 on error
pub extern fn sceUmdReplacePermit() callconv(.c) c_int;

pub extern fn sceUmd_D01B2DC6() callconv(.c) void;

pub extern fn sceUmdGetDriveStatus() callconv(.c) void;

/// Deativates the UMD drive
/// `unit` - The unit to initialise (probably). Should be set to 1.
/// `drive` - A prefix string for the fs device to mount the UMD on (e.g. "disc0:")
/// Returns < 0 on error
pub extern fn sceUmdDeactivate(unit: c_int, drive: [*c]const c_char) callconv(.c) c_int;

pub extern fn sceUmd_EB56097E() callconv(.c) void;

pub extern fn sceUmd_F8352373() callconv(.c) void;

comptime {
    asm (macro.import_module_start("sceUmd", "0x00090000", "35"));
    asm (macro.import_function("sceUmd", "0x075F1E0B", "sceUmd_075F1E0B"));
    asm (macro.import_function("sceUmd", "0x086DDC0D", "sceUmd_086DDC0D"));
    asm (macro.import_function("sceUmd", "0x230666E3", "sceUmdSetDriveStatus"));
    asm (macro.import_function("sceUmd", "0x27A764A1", "sceUmd_27A764A1"));
    asm (macro.import_function("sceUmd", "0x2D81508D", "sceUmd_2D81508D"));
    asm (macro.import_function("sceUmd", "0x319ED97C", "sceUmd_319ED97C"));
    asm (macro.import_function("sceUmd", "0x340B7686", "sceUmdGetDiscInfo"));
    asm (macro.import_function("sceUmd", "0x3925CBD8", "sceUmd_3925CBD8"));
    asm (macro.import_function("sceUmd", "0x3D0DECD5", "sceUmd_3D0DECD5"));
    asm (macro.import_function("sceUmd", "0x46EBB729", "sceUmdCheckMedium"));
    asm (macro.import_function("sceUmd", "0x4832ABF3", "sceUmd_4832ABF3"));
    asm (macro.import_function("sceUmd", "0x4A9E5E29", "sceUmdWaitDriveStatCB"));
    asm (macro.import_function("sceUmd", "0x4BA25F4A", "sceUmd_4BA25F4A"));
    asm (macro.import_function("sceUmd", "0x4C952ACF", "sceUmdSetSuspendResumeMode"));
    asm (macro.import_function("sceUmd", "0x5469DC37", "sceUmd_5469DC37"));
    asm (macro.import_function("sceUmd", "0x56202973", "sceUmdWaitDriveStatWithTimer"));
    asm (macro.import_function("sceUmd", "0x659587F7", "sceUmd_659587F7"));
    asm (macro.import_function("sceUmd", "0x6A41ED25", "sceUmdGetSuspendResumeMode"));
    asm (macro.import_function("sceUmd", "0x6AF9B50A", "sceUmd_6AF9B50A"));
    asm (macro.import_function("sceUmd", "0x71F81482", "sceUmd_71F81482"));
    asm (macro.import_function("sceUmd", "0x7850F057", "sceUmd_7850F057"));
    asm (macro.import_function("sceUmd", "0x87533940", "sceUmdReplaceProhibit"));
    asm (macro.import_function("sceUmd", "0x8EF08FCE", "sceUmdWaitDriveStat"));
    asm (macro.import_function("sceUmd", "0x9B22AED7", "sceUmd_9B22AED7"));
    asm (macro.import_function("sceUmd", "0xAE53DC2D", "sceUmdClearDriveStatus"));
    asm (macro.import_function("sceUmd", "0xAEE7404D", "sceUmdRegisterUMDCallBack"));
    asm (macro.import_function("sceUmd", "0xBBB5F05C", "sceUmd_BBB5F05C"));
    asm (macro.import_function("sceUmd", "0xBD2BDE07", "sceUmdUnRegisterUMDCallBack"));
    asm (macro.import_function("sceUmd", "0xC6183D47", "sceUmdActivate"));
    asm (macro.import_function("sceUmd", "0xCBE9F02A", "sceUmdReplacePermit"));
    asm (macro.import_function("sceUmd", "0xD01B2DC6", "sceUmd_D01B2DC6"));
    asm (macro.import_function("sceUmd", "0xD45D1FE6", "sceUmdGetDriveStatus"));
    asm (macro.import_function("sceUmd", "0xE83742BA", "sceUmdDeactivate"));
    asm (macro.import_function("sceUmd", "0xEB56097E", "sceUmd_EB56097E"));
    asm (macro.import_function("sceUmd", "0xF8352373", "sceUmd_F8352373"));
}
