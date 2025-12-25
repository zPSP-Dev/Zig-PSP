// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Start a USB driver.
/// `driverName` - name of the USB driver to start
/// `size` - Size of arguments to pass to USB driver start
/// `args` - Arguments to pass to USB driver start
/// Returns 0 on success
pub extern fn sceUsbStart(driverName: [*c]const c_char, size: c_int, args: ?*anyopaque) callconv(.C) c_int;

/// Stop a USB driver.
/// `driverName` - name of the USB driver to stop
/// `size` - Size of arguments to pass to USB driver stop
/// `args` - Arguments to pass to USB driver stop
/// Returns 0 on success
pub extern fn sceUsbStop(driverName: [*c]const c_char, size: c_int, args: ?*anyopaque) callconv(.C) c_int;

/// Get USB state
/// Returns OR'd PSP_USB_* constants
pub extern fn sceUsbGetState() callconv(.C) c_int;

pub extern fn sceUsbGetDrvList(r4one: u32, r5ret: [*c]u32, r6one: u32) callconv(.C) c_int;

/// Get state of a specific USB driver
/// `driverName` - name of USB driver to get status from
/// Returns 1 if the driver has been started, 2 if it is stopped
pub extern fn sceUsbGetDrvState(driverName: [*c]const c_char) callconv(.C) c_int;

/// Activate a USB driver.
/// `pid` - Product ID for the default USB Driver
/// Returns 0 on success
pub extern fn sceUsbActivate(pid: u32) callconv(.C) c_int;

/// Deactivate USB driver.
/// `pid` - Product ID for the default USB driver
/// Returns 0 on success
pub extern fn sceUsbDeactivate(pid: u32) callconv(.C) c_int;

pub extern fn sceUsbWaitState(state: u32, waitmode: c_int, timeout: [*c]u32) callconv(.C) c_int;

pub extern fn sceUsbWaitCancel() callconv(.C) c_int;

comptime {
    asm(macro.import_module_start("sceUsb", "0x40010000", "9"));
    asm(macro.import_function("sceUsb", "0xAE5DE6AF", "sceUsbStart"));
    asm(macro.import_function("sceUsb", "0xC2464FA0", "sceUsbStop"));
    asm(macro.import_function("sceUsb", "0xC21645A4", "sceUsbGetState"));
    asm(macro.import_function("sceUsb", "0x4E537366", "sceUsbGetDrvList"));
    asm(macro.import_function("sceUsb", "0x112CC951", "sceUsbGetDrvState"));
    asm(macro.import_function("sceUsb", "0x586DB82C", "sceUsbActivate"));
    asm(macro.import_function("sceUsb", "0xC572A9C8", "sceUsbDeactivate"));
    asm(macro.import_function("sceUsb", "0x5BE0E002", "sceUsbWaitState"));
    asm(macro.import_function("sceUsb", "0x1C360735", "sceUsbWaitCancel"));
}
