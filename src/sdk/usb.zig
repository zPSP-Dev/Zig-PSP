// USB core -- driver start/stop/state
//
// Wraps:
//   c/module/sceUsb.zig

const c = @import("../c/modules.zig");
const internal = @import("internal.zig");
const check = internal.check;
const ci = internal.ci;
const cu = internal.cu;
const Error = internal.Error;

const usb = c.sceUsb;

pub fn start(driver_name: [*:0]const u8, size: u32, args: ?*anyopaque) Error!void {
    return check(usb.sceUsbStart(driver_name, ci(size), args));
}

pub fn stop(driver_name: [*:0]const u8, size: u32, args: ?*anyopaque) Error!void {
    return check(usb.sceUsbStop(driver_name, ci(size), args));
}

pub fn get_state() u32 {
    return cu(usb.sceUsbGetState());
}

pub fn get_drv_state(driver_name: [*:0]const u8) u32 {
    return cu(usb.sceUsbGetDrvState(driver_name));
}

pub fn activate(pid: u32) Error!void {
    return check(usb.sceUsbActivate(pid));
}

pub fn deactivate(pid: u32) Error!void {
    return check(usb.sceUsbDeactivate(pid));
}

pub fn wait_state(state: u32, waitmode: i32, timeout: ?*u32) Error!void {
    return check(usb.sceUsbWaitState(state, waitmode, timeout));
}

pub fn wait_cancel() Error!void {
    return check(usb.sceUsbWaitCancel());
}
