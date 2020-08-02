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
pub extern fn sceRegGetKeyInfo(hd: REGHANDLE, name: [*c]const u8, hk: [*c]REGHANDLE, type: [*c]c_uint, size: [*c]SceSize) c_int;
pub extern fn sceRegGetKeyInfoByName(hd: REGHANDLE, name: [*c]const u8, type: [*c]c_uint, size: [*c]SceSize) c_int;
pub extern fn sceRegGetKeyValue(hd: REGHANDLE, hk: REGHANDLE, buf: ?*c_void, size: SceSize) c_int;
pub extern fn sceRegGetKeyValueByName(hd: REGHANDLE, name: [*c]const u8, buf: ?*c_void, size: SceSize) c_int;
pub extern fn sceRegSetKeyValue(hd: REGHANDLE, name: [*c]const u8, buf: ?*const c_void, size: SceSize) c_int;
pub extern fn sceRegGetKeysNum(hd: REGHANDLE, num: [*c]c_int) c_int;
pub extern fn sceRegGetKeys(hd: REGHANDLE, buf: [*c]u8, num: c_int) c_int;
pub extern fn sceRegCreateKey(hd: REGHANDLE, name: [*c]const u8, type: c_int, size: SceSize) c_int;
pub extern fn sceRegRemoveRegistry(reg: [*c]struct_RegParam) c_int;

pub const RegKeyTypes = enum_RegKeyTypes;
pub const RegParam = struct_RegParam;
