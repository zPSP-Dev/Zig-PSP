pub const struct_pspUmdInfo = extern struct {
    size: c_uint,
    type: c_uint,
};
pub const pspUmdInfo = struct_pspUmdInfo;

pub const enum_pspUmdTypes = extern enum(c_int) {
    PSP_UMD_TYPE_GAME = 16,
    PSP_UMD_TYPE_VIDEO = 32,
    PSP_UMD_TYPE_AUDIO = 64,
    _,
};

pub const enum_pspUmdState = extern enum(c_int) {
    PSP_UMD_NOT_PRESENT = 1,
    PSP_UMD_PRESENT = 2,
    PSP_UMD_CHANGED = 4,
    PSP_UMD_INITING = 8,
    PSP_UMD_INITED = 16,
    PSP_UMD_READY = 32,
    _,
};

pub const enum_UmdDriveStat = extern enum(c_int) {
    UMD_WAITFORDISC = 2,
    UMD_WAITFORINIT = 32,
    _,
};
pub const UmdCallback = ?fn (c_int, c_int) callconv(.C) c_int;
pub extern fn sceUmdCheckMedium() c_int;
pub extern fn sceUmdGetDiscInfo(info: [*c]pspUmdInfo) c_int;
pub extern fn sceUmdActivate(unit: c_int, drive: [*c]const u8) c_int;
pub extern fn sceUmdDeactivate(unit: c_int, drive: [*c]const u8) c_int;
pub extern fn sceUmdWaitDriveStat(stat: c_int) c_int;
pub extern fn sceUmdWaitDriveStatWithTimer(stat: c_int, timeout: c_uint) c_int;
pub extern fn sceUmdWaitDriveStatCB(stat: c_int, timeout: c_uint) c_int;
pub extern fn sceUmdCancelWaitDriveStat() c_int;
pub extern fn sceUmdGetDriveStat() c_int;
pub extern fn sceUmdGetErrorStat() c_int;
pub extern fn sceUmdRegisterUMDCallBack(cbid: c_int) c_int;
pub extern fn sceUmdUnRegisterUMDCallBack(cbid: c_int) c_int;
pub extern fn sceUmdReplacePermit() c_int;
pub extern fn sceUmdReplaceProhibit() c_int;

pub const pspUmdTypes = enum_pspUmdTypes;
pub const pspUmdState = enum_pspUmdState;
pub const UmdDriveStat = enum_UmdDriveStat;
