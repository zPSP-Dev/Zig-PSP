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

const macro = @import("pspmacros.zig");

comptime{
    asm(macro.import_module_start("ModuleMgrForUser", "0x40010000", "11"));
    asm(macro.import_function("ModuleMgrForUser", "0xB7F46618", "sceKernelLoadModuleByID"));
    asm(macro.import_function("ModuleMgrForUser", "0x977DE386", "sceKernelLoadModule"));
    asm(macro.import_function("ModuleMgrForUser", "0x710F61B5", "sceKernelLoadModuleMs"));
    asm(macro.import_function("ModuleMgrForUser", "0xF9275D98", "sceKernelLoadModuleBufferUsbWlan"));
    asm(macro.import_function("ModuleMgrForUser", "0x50F0C1EC", "sceKernelStartModule_stub"));
    asm(macro.import_function("ModuleMgrForUser", "0xD1FF982A", "sceKernelStopModule_stub"));
    asm(macro.import_function("ModuleMgrForUser", "0x2E0911AA", "sceKernelUnloadModule"));
    asm(macro.import_function("ModuleMgrForUser", "0xD675EBB8", "sceKernelSelfStopUnloadModule"));
    asm(macro.import_function("ModuleMgrForUser", "0xCC1D3699", "sceKernelStopUnloadSelfModule"));
    asm(macro.import_function("ModuleMgrForUser", "0x748CBED9", "sceKernelQueryModuleInfo"));
    asm(macro.import_function("ModuleMgrForUser", "0x644395E2", "sceKernelGetModuleIdList"));

    asm(macro.generic_abi_wrapper("sceKernelStartModule", 5));
    asm(macro.generic_abi_wrapper("sceKernelStopModule", 5));
}