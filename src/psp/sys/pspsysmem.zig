usingnamespace @import("psptypes.zig");

pub const enum_PspSysMemBlockTypes = extern enum(c_int) {
    PSP_SMEM_Low = 0,
    PSP_SMEM_High = 1,
    PSP_SMEM_Addr = 2,
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
