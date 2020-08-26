usingnamespace @import("psptypes.zig");

pub const enum_RegKeyTypes = extern enum(c_int) {
    REG_TYPE_DIR = 1,
    REG_TYPE_INT = 2,
    REG_TYPE_STR = 3,
    REG_TYPE_BIN = 4,
    _,
};
pub const REGHANDLE = c_uint;
pub const struct_RegParam = extern struct {
    regtype: c_uint,
    name: [256]u8,
    namelen: c_uint,
    unk2: c_uint,
    unk3: c_uint,
};
pub extern fn sceRegOpenRegistry(reg: [*c]struct_RegParam, mode: c_int, h: [*c]REGHANDLE) c_int;
pub extern fn sceRegFlushRegistry(h: REGHANDLE) c_int;
pub extern fn sceRegCloseRegistry(h: REGHANDLE) c_int;
pub extern fn sceRegOpenCategory(h: REGHANDLE, name: [*c]const u8, mode: c_int, hd: [*c]REGHANDLE) c_int;
pub extern fn sceRegRemoveCategory(h: REGHANDLE, name: [*c]const u8) c_int;
pub extern fn sceRegCloseCategory(hd: REGHANDLE) c_int;
pub extern fn sceRegFlushCategory(hd: REGHANDLE) c_int;
pub extern fn sceRegGetKeyInfo(hd: REGHANDLE, name: [*c]const u8, hk: [*c]REGHANDLE, typec: [*c]c_uint, size: [*c]SceSize) c_int;
pub extern fn sceRegGetKeyInfoByName(hd: REGHANDLE, name: [*c]const u8, typec: [*c]c_uint, size: [*c]SceSize) c_int;
pub extern fn sceRegGetKeyValue(hd: REGHANDLE, hk: REGHANDLE, buf: ?*c_void, size: SceSize) c_int;
pub extern fn sceRegGetKeyValueByName(hd: REGHANDLE, name: [*c]const u8, buf: ?*c_void, size: SceSize) c_int;
pub extern fn sceRegSetKeyValue(hd: REGHANDLE, name: [*c]const u8, buf: ?*const c_void, size: SceSize) c_int;
pub extern fn sceRegGetKeysNum(hd: REGHANDLE, num: [*c]c_int) c_int;
pub extern fn sceRegGetKeys(hd: REGHANDLE, buf: [*c]u8, num: c_int) c_int;
pub extern fn sceRegCreateKey(hd: REGHANDLE, name: [*c]const u8, typec: c_int, size: SceSize) c_int;
pub extern fn sceRegRemoveRegistry(reg: [*c]struct_RegParam) c_int;

pub const RegKeyTypes = enum_RegKeyTypes;
pub const RegParam = struct_RegParam;

const macro = @import("pspmacros.zig");

comptime{
    asm(macro.import_module_start("sceReg", "0x40010000", "18"));
    asm(macro.import_function("sceReg", "0x9B25EDF1", "sceRegExit"));
    asm(macro.import_function("sceReg", "0x92E41280", "sceRegOpenRegistry"));
    asm(macro.import_function("sceReg", "0xFA8A5739", "sceRegCloseRegistry"));
    asm(macro.import_function("sceReg", "0xDEDA92BF", "sceRegRemoveRegistry"));
    asm(macro.import_function("sceReg", "0x1D8A762E", "sceRegOpenCategory"));
    asm(macro.import_function("sceReg", "0x0CAE832B", "sceRegCloseCategory"));
    asm(macro.import_function("sceReg", "0x39461B4D", "sceRegFlushRegistry"));
    asm(macro.import_function("sceReg", "0x0D69BF40", "sceRegFlushCategory"));
    asm(macro.import_function("sceReg", "0x57641A81", "sceRegCreateKey"));
    asm(macro.import_function("sceReg", "0x17768E14", "sceRegSetKeyValue"));
    asm(macro.import_function("sceReg", "0xD4475AA8", "sceRegGetKeyInfo_stub"));
    asm(macro.import_function("sceReg", "0x28A8E98A", "sceRegGetKeyValue"));
    asm(macro.import_function("sceReg", "0x2C0DB9DD", "sceRegGetKeysNum"));
    asm(macro.import_function("sceReg", "0x2D211135", "sceRegGetKeys"));
    asm(macro.import_function("sceReg", "0x4CA16893", "sceRegRemoveCategory"));
    asm(macro.import_function("sceReg", "0x3615BC87", "sceRegRemoveKey"));
    asm(macro.import_function("sceReg", "0xC5768D02", "sceRegGetKeyInfoByName"));
    asm(macro.import_function("sceReg", "0x30BE0259", "sceRegGetKeyValueByName"));
    asm(macro.generic_abi_wrapper("sceRegGetKeyInfo", 6));
}