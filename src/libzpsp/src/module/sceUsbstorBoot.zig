// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Tell the USBstorBoot driver the size of MS
/// @note I'm not sure if this is the actual size of the media or not
/// as it seems to have no bearing on what size windows detects.
/// PSPPET passes 0x800000
/// `size` - capacity of memory stick
/// Returns 0 on success
pub extern fn sceUsbstorBootSetCapacity(size: u32) callconv(.c) c_int;

pub extern fn sceUsbstorBootSetLoadAddr(addr: u32) callconv(.c) c_int;

pub extern fn sceUsbstorBootGetDataSize() callconv(.c) c_int;

pub extern fn sceUsbstorBootSetStatus(status: u32) callconv(.c) c_int;

/// Register an eventFlag to send notifications to.
/// `eventFlag` - eventFlag created with sceKernelCreateEventFlag
/// Returns 0 on success
pub extern fn sceUsbstorBootRegisterNotify(eventFlag: u32) callconv(.c) c_int;

/// Unregister a previously registered eventFlag.
/// `eventFlag` - eventFlag created with sceKernelCreateEventFlag
/// Returns 0 on success
pub extern fn sceUsbstorBootUnregisterNotify(eventFlag: u32) callconv(.c) c_int;

comptime {
    asm (macro.import_module_start("sceUsbstorBoot", "0x40090000", "6"));
    asm (macro.import_function("sceUsbstorBoot", "0xE58818A8", "sceUsbstorBootSetCapacity"));
    asm (macro.import_function("sceUsbstorBoot", "0x594BBF95", "sceUsbstorBootSetLoadAddr"));
    asm (macro.import_function("sceUsbstorBoot", "0x6D865ECD", "sceUsbstorBootGetDataSize"));
    asm (macro.import_function("sceUsbstorBoot", "0xA1119F0D", "sceUsbstorBootSetStatus"));
    asm (macro.import_function("sceUsbstorBoot", "0x1F080078", "sceUsbstorBootRegisterNotify"));
    asm (macro.import_function("sceUsbstorBoot", "0xA55C9E16", "sceUsbstorBootUnregisterNotify"));
}
