// UMD disc drive
//
// Wraps:
//   c/module/sceUmdUser.zig

const c = @import("../c/modules.zig");
const internal = @import("internal.zig");
const check = internal.check;
const ci = internal.ci;
const cu = internal.cu;
const Error = internal.Error;

const umd = c.sceUmdUser;

pub const UmdInfo = c.types.pspUmdInfo;
pub const SceUID = c.types.SceUID;

// -- Status -------------------------------------------------------------

pub fn check_medium() bool {
    return umd.sceUmdCheckMedium() != 0;
}

pub fn get_disc_info(info: *UmdInfo) Error!void {
    return check(umd.sceUmdGetDiscInfo(info));
}

pub fn get_drive_stat() u32 {
    return cu(umd.sceUmdGetDriveStat());
}

pub fn get_error_stat() i32 {
    return umd.sceUmdGetErrorStat();
}

// -- Activation ---------------------------------------------------------

pub fn activate(unit: u32, drive: [*:0]const u8) Error!void {
    return check(umd.sceUmdActivate(ci(unit), drive));
}

pub fn deactivate(unit: u32, drive: [*:0]const u8) Error!void {
    return check(umd.sceUmdDeactivate(ci(unit), drive));
}

// -- Waiting ------------------------------------------------------------

pub fn wait_drive_stat(stat: u32) Error!void {
    return check(umd.sceUmdWaitDriveStat(ci(stat)));
}

pub fn wait_drive_stat_with_timer(stat: u32, timeout: u32) Error!void {
    return check(umd.sceUmdWaitDriveStatWithTimer(ci(stat), timeout));
}

pub fn wait_drive_stat_cb(stat: u32, timeout: u32) Error!void {
    return check(umd.sceUmdWaitDriveStatCB(ci(stat), timeout));
}

pub fn cancel_wait_drive_stat() Error!void {
    return check(umd.sceUmdCancelWaitDriveStat());
}

// -- Replace ------------------------------------------------------------

pub fn replace_permit() Error!void {
    return check(umd.sceUmdReplacePermit());
}

pub fn replace_prohibit() Error!void {
    return check(umd.sceUmdReplaceProhibit());
}

// -- Callbacks ----------------------------------------------------------

pub fn register_umd_callback(cbid: SceUID) Error!void {
    return check(umd.sceUmdRegisterUMDCallBack(cbid));
}

pub fn unregister_umd_callback(cbid: SceUID) Error!void {
    return check(umd.sceUmdUnRegisterUMDCallBack(cbid));
}
