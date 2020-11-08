usingnamespace @import("psptypes.zig");

// Start a USB driver.
//
// @param driverName - name of the USB driver to start
// @param size - Size of arguments to pass to USB driver start
// @param args - Arguments to pass to USB driver start
//
// @return 0 on success
pub extern fn sceUsbStart(driverName: [*c]const u8, size: c_int, args: ?*c_void) c_int;
pub fn usbStart(driverName: [*c]const u8, size: c_int, args: ?*c_void) bool {
    return sceUsbStart(driverName, size, args) == 0;
}

// Stop a USB driver.
//
// @param driverName - name of the USB driver to stop
// @param size - Size of arguments to pass to USB driver start
// @param args - Arguments to pass to USB driver start
//
// @return 0 on success
pub extern fn sceUsbStop(driverName: [*c]const u8, size: c_int, args: ?*c_void) c_int;
pub fn usbStop(driverName: [*c]const u8, size: c_int, args: ?*c_void) bool {
    return sceUsbStop(driverName, size, args) == 0;
}

// Activate a USB driver.
//
// @param pid - Product ID for the default USB Driver
//
// @return 0 on success
pub extern fn sceUsbActivate(pid: u32) c_int;
pub fn usbActivate(pid: u32) bool {
    return sceUsbActivate(pid) == 0;
}

// Deactivate USB driver.
//
// @param pid - Product ID for the default USB driver
//
// @return 0 on success
pub extern fn sceUsbDeactivate(pid: u32) c_int;
pub fn usbDeactivate(pid: u32) bool {
    return sceUsbDeactivate(pid) == 0;
}

// Get USB state
//
// @return OR'd PSP_USB_* constants
pub extern fn sceUsbGetState() c_int;

// Get state of a specific USB driver
//
// @param driverName - name of USB driver to get status from
//
// @return 1 if the driver has been started, 2 if it is stopped
pub extern fn sceUsbGetDrvState(driverName: [*c]const u8) c_int;

pub const PSP_USB_CABLE_CONNECTED = 0x020;
pub const PSP_USB_CONNECTION_ESTABLISHED = 0x002;
pub const PSP_USB_ACTIVATED = 0x200;
pub const PSP_USBBUS_DRIVERNAME = "USBBusDriver";
pub const PSP_USBACC_DRIVERNAME = "USBAccBaseDriver";
