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


const macro = @import("pspmacros.zig");

comptime{
    asm(macro.import_module_start("sceUmdUser", "0x40010011", "14"));
    asm(macro.import_function("sceUmdUser", "0x20628E6F", "sceUmdGetErrorStat"));
    asm(macro.import_function("sceUmdUser", "0x340B7686", "sceUmdGetDiscInfo"));
    asm(macro.import_function("sceUmdUser", "0x46EBB729", "sceUmdCheckMedium"));
    asm(macro.import_function("sceUmdUser", "0x4A9E5E29", "sceUmdWaitDriveStatCB"));
    asm(macro.import_function("sceUmdUser", "0x56202973", "sceUmdWaitDriveStatWithTimer"));
    asm(macro.import_function("sceUmdUser", "0x6AF9B50A", "sceUmdCancelWaitDriveStat"));
    asm(macro.import_function("sceUmdUser", "0x6B4A146C", "sceUmdGetDriveStat"));
    asm(macro.import_function("sceUmdUser", "0x87533940", "sceUmdReplaceProhibit"));
    asm(macro.import_function("sceUmdUser", "0x8EF08FCE", "sceUmdWaitDriveStat"));
    asm(macro.import_function("sceUmdUser", "0xAEE7404D", "sceUmdRegisterUMDCallBack"));
    asm(macro.import_function("sceUmdUser", "0xBD2BDE07", "sceUmdUnRegisterUMDCallBack"));
    asm(macro.import_function("sceUmdUser", "0xC6183D47", "sceUmdActivate"));
    asm(macro.import_function("sceUmdUser", "0xCBE9F02A", "sceUmdReplacePermit"));
    asm(macro.import_function("sceUmdUser", "0xE83742BA", "sceUmdDeactivate"));
}