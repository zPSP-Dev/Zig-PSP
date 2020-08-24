usingnamespace @import("psptypes.zig");

pub const enum_PspSysMemBlockTypes = extern enum(c_int) {
    MemLow = 0,
    MemHigh = 1,
    MemAddr = 2,
    _,
};
pub const SceKernelSysMemAlloc_t = c_int;
pub extern fn sceKernelAllocPartitionMemory(partitionid: SceUID, name: [*c]const u8, type: c_int, size: SceSize, addr: ?*c_void) SceUID;
pub extern fn sceKernelFreePartitionMemory(blockid: SceUID) c_int;
pub extern fn sceKernelGetBlockHeadAddr(blockid: SceUID) ?*c_void;
pub extern fn sceKernelTotalFreeMemSize() SceSize;
pub extern fn sceKernelMaxFreeMemSize() SceSize;
pub extern fn sceKernelDevkitVersion() c_int;
pub extern fn sceKernelSetCompiledSdkVersion(version: c_int) c_int;
pub extern fn sceKernelGetCompiledSdkVersion() c_int;

pub const PspSysMemBlockTypes = enum_PspSysMemBlockTypes;

const macro = @import("pspmacros.zig");

comptime{
    asm(macro.import_module_start("SysMemUserForUser", "0x40000000", "9"));
    asm(macro.import_function2("SysMemUserForUser", "0xA291F107", "sceKernelMaxFreeMemSize"));
    asm(macro.import_function2("SysMemUserForUser", "0xF919F628", "sceKernelTotalFreeMemSize"));
    asm(macro.import_function2("SysMemUserForUser", "0x237DBD4F", "sceKernelAllocPartitionMemory"));
    asm(macro.import_function2("SysMemUserForUser", "0xB6D61D02", "sceKernelFreePartitionMemory"));
    asm(macro.import_function2("SysMemUserForUser", "0x9D9A5BA1", "sceKernelGetBlockHeadAddr"));
    asm(macro.import_function2("SysMemUserForUser", "0x3FC9AE6A", "sceKernelDevkitVersion"));
    asm(macro.import_function2("SysMemUserForUser", "0x13A5ABEF", "sceKernelPrintf"));
    asm(macro.import_function2("SysMemUserForUser", "0x7591C7DB", "sceKernelSetCompiledSdkVersion"));
    asm(macro.import_function2("SysMemUserForUser", "0xFC114573", "sceKernelGetCompiledSdkVersion"));
}