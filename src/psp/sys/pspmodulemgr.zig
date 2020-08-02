usingnamespace @import("psptypes.zig");

pub const struct_SceKernelLMOption = extern struct {
    size: SceSize,
    mpidtext: SceUID,
    mpiddata: SceUID,
    flags: c_uint,
    position: u8,
    access: u8,
    creserved: [2]u8,
};
pub const SceKernelLMOption = struct_SceKernelLMOption;
pub const struct_SceKernelSMOption = extern struct {
    size: SceSize,
    mpidstack: SceUID,
    stacksize: SceSize,
    priority: c_int,
    attribute: c_uint,
};
pub const SceKernelSMOption = struct_SceKernelSMOption;
pub extern fn sceKernelLoadModule(path: [*c]const u8, flags: c_int, option: [*c]SceKernelLMOption) SceUID;
pub extern fn sceKernelLoadModuleMs(path: [*c]const u8, flags: c_int, option: [*c]SceKernelLMOption) SceUID;
pub extern fn sceKernelLoadModuleByID(fid: SceUID, flags: c_int, option: [*c]SceKernelLMOption) SceUID;
pub extern fn sceKernelLoadModuleBufferUsbWlan(bufsize: SceSize, buf: ?*c_void, flags: c_int, option: [*c]SceKernelLMOption) SceUID;
pub extern fn sceKernelStartModule(modid: SceUID, argsize: SceSize, argp: ?*c_void, status: [*c]c_int, option: [*c]SceKernelSMOption) c_int;
pub extern fn sceKernelStopModule(modid: SceUID, argsize: SceSize, argp: ?*c_void, status: [*c]c_int, option: [*c]SceKernelSMOption) c_int;
pub extern fn sceKernelUnloadModule(modid: SceUID) c_int;
pub extern fn sceKernelSelfStopUnloadModule(unknown: c_int, argsize: SceSize, argp: ?*c_void) c_int;
pub extern fn sceKernelStopUnloadSelfModule(argsize: SceSize, argp: ?*c_void, status: [*c]c_int, option: [*c]SceKernelSMOption) c_int;
pub const struct_SceKernelModuleInfo = extern struct {
    size: SceSize,
    nsegment: u8,
    reserved: [3]u8,
    segmentaddr: [4]c_int,
    segmentsize: [4]c_int,
    entry_addr: c_uint,
    gp_value: c_uint,
    text_addr: c_uint,
    text_size: c_uint,
    data_size: c_uint,
    bss_size: c_uint,
    attribute: c_ushort,
    version: [2]u8,
    name: [28]u8,
};
pub const SceKernelModuleInfo = struct_SceKernelModuleInfo;
pub extern fn sceKernelQueryModuleInfo(modid: SceUID, info: [*c]SceKernelModuleInfo) c_int;
pub extern fn sceKernelGetModuleIdList(readbuf: [*c]SceUID, readbufsize: c_int, idcount: [*c]c_int) c_int;

pub const PSP_MEMORY_PARTITION_KERNEL = 1;
pub const PSP_MEMORY_PARTITION_USER = 2;
