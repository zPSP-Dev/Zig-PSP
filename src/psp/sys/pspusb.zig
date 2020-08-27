usingnamespace @import("psptypes.zig");

pub extern fn sceUsbStart(driverName: [*c]const u8, size: c_int, args: ?*c_void) c_int;
pub extern fn sceUsbStop(driverName: [*c]const u8, size: c_int, args: ?*c_void) c_int;
pub extern fn sceUsbActivate(pid: u32) c_int;
pub extern fn sceUsbDeactivate(pid: u32) c_int;
pub extern fn sceUsbGetState() c_int;
pub extern fn sceUsbGetDrvState(driverName: [*c]const u8) c_int;

pub const PSP_USB_CABLE_CONNECTED = 0x020;
pub const PSP_USB_CONNECTION_ESTABLISHED = 0x002;
pub const PSP_USB_ACTIVATED = 0x200;
pub const PSP_USBBUS_DRIVERNAME = "USBBusDriver";

pub const PSP_USBACC_DRIVERNAME = "USBAccBaseDriver";
