// USB mass storage
//
// Wraps:
//   c/module/sceUsbstor.zig
//   c/module/sceUsbstorBoot.zig

const c = @import("../c/modules.zig");
const internal = @import("internal.zig");
const check = internal.check;
const checkPositive = internal.checkPositive;
const Error = internal.Error;

const stor = c.sceUsbstor;
const boot = c.sceUsbstorBoot;

// -- sceUsbstor ---------------------------------------------------------

pub const get_status = stor.sceUsbstorGetStatus;

// -- sceUsbstorBoot -----------------------------------------------------

pub fn set_capacity(size: u32) Error!void {
    return check(boot.sceUsbstorBootSetCapacity(size));
}

pub fn set_load_addr(addr: u32) Error!void {
    return check(boot.sceUsbstorBootSetLoadAddr(addr));
}

pub fn get_data_size() Error!u32 {
    const ret = boot.sceUsbstorBootGetDataSize();
    return checkPositive(ret);
}

pub fn set_status(status: u32) Error!void {
    return check(boot.sceUsbstorBootSetStatus(status));
}

pub fn register_notify(event_flag: u32) Error!void {
    return check(boot.sceUsbstorBootRegisterNotify(event_flag));
}

pub fn unregister_notify(event_flag: u32) Error!void {
    return check(boot.sceUsbstorBootUnregisterNotify(event_flag));
}
