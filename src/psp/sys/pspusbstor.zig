pub extern fn sceUsbstorBootRegisterNotify(eventFlag: u32_3) c_int;
pub extern fn sceUsbstorBootUnregisterNotify(eventFlag: u32_3) c_int;
pub extern fn sceUsbstorBootSetCapacity(size: u32_3) c_int;
pub const PSP_USBSTOR_DRIVERNAME = "USBStor_Driver";
