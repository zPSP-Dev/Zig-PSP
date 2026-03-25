// PSP registry access
//
// Wraps:
//   c/module/sceReg.zig

const c = @import("../c/modules.zig");
const internal = @import("internal.zig");
const check = internal.check;
const ci = internal.ci;
const Error = internal.Error;

const reg = c.sceReg;

// -- Re-exported types --------------------------------------------------

pub const Handle = c.types.REGHANDLE;
pub const Param = c.types.RegParam;

// -- Registry operations ------------------------------------------------

pub fn exit() void {
    reg.sceRegExit();
}

pub fn open_registry(param: *Param, mode: u32, h: *Handle) Error!void {
    return check(reg.sceRegOpenRegistry(param, ci(mode), h));
}

pub fn close_registry(h: Handle) Error!void {
    return check(reg.sceRegCloseRegistry(h));
}

pub fn remove_registry(param: *Param) Error!void {
    return check(reg.sceRegRemoveRegistry(param));
}

pub fn flush_registry(h: Handle) Error!void {
    return check(reg.sceRegFlushRegistry(h));
}

// -- Category (directory) operations ------------------------------------

pub fn open_category(h: Handle, name: [*:0]const u8, mode: u32, hd: *Handle) Error!void {
    return check(reg.sceRegOpenCategory(h, name, ci(mode), hd));
}

pub fn close_category(hd: Handle) Error!void {
    return check(reg.sceRegCloseCategory(hd));
}

pub fn flush_category(hd: Handle) Error!void {
    return check(reg.sceRegFlushCategory(hd));
}

pub fn remove_category(h: Handle, name: [*:0]const u8) Error!void {
    return check(reg.sceRegRemoveCategory(h, name));
}

// -- Key operations -----------------------------------------------------

pub fn create_key(hd: Handle, name: [*:0]const u8, key_type: u32, size: usize) Error!void {
    return check(reg.sceRegCreateKey(hd, name, ci(key_type), size));
}

pub fn set_key_value(hd: Handle, name: [*:0]const u8, buf: ?*const anyopaque, size: usize) Error!void {
    return check(reg.sceRegSetKeyValue(hd, name, buf, size));
}

pub fn get_key_info(hd: Handle, name: [*:0]const u8, hk: *Handle, key_type: *u32, size: *usize) Error!void {
    return check(reg.sceRegGetKeyInfo(hd, name, hk, @ptrCast(key_type), size));
}

pub fn get_key_value(hd: Handle, hk: Handle, buf: ?*anyopaque, size: usize) Error!void {
    return check(reg.sceRegGetKeyValue(hd, hk, buf, size));
}

pub fn get_keys_num(hd: Handle) Error!u32 {
    var num: c_int = undefined;
    check(reg.sceRegGetKeysNum(hd, &num)) catch return error.Unexpected;
    return @intCast(num);
}

pub fn get_keys(hd: Handle, buf: [*]u8, num: u32) Error!void {
    return check(reg.sceRegGetKeys(hd, buf, ci(num)));
}

pub fn get_key_info_by_name(hd: Handle, name: [*:0]const u8, key_type: *u32, size: *usize) Error!void {
    return check(reg.sceRegGetKeyInfoByName(hd, name, @ptrCast(key_type), size));
}

pub fn get_key_value_by_name(hd: Handle, name: [*:0]const u8, buf: ?*anyopaque, size: usize) Error!void {
    return check(reg.sceRegGetKeyValueByName(hd, name, buf, size));
}
