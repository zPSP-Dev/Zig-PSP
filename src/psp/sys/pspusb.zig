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


const macro = @import("pspmacros.zig");

comptime{
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