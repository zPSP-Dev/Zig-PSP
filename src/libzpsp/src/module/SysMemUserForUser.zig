// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Get the size of the largest free memory block.
/// Returns The size of the largest free memory block, in bytes.
pub extern fn sceKernelMaxFreeMemSize() callconv(.C) types.SceSize;

/// Get the total amount of free memory.
/// Returns The total amount of free memory, in bytes.
pub extern fn sceKernelTotalFreeMemSize() callconv(.C) types.SceSize;

/// Allocate a memory block from a memory partition.
/// `partitionid` - The UID of the partition to allocate from.
/// `name` - Name assigned to the new block.
/// `type` - Specifies how the block is allocated within the partition.  One of ::PspSysMemBlockTypes.
/// `size` - Size of the memory block, in bytes.
/// `addr` - If type is PSP_SMEM_Addr, then addr specifies the lowest address allocate the block from.
/// Returns The UID of the new block, or if less than 0 an error.
pub extern fn sceKernelAllocPartitionMemory(partitionid: types.SceUID, name: [*c]const c_char, type: c_int, size: types.SceSize, addr: ?*anyopaque) callconv(.C) types.SceUID;

/// Free a memory block allocated with ::sceKernelAllocPartitionMemory.
/// `blockid` - UID of the block to free.
/// Returns ? on success, less than 0 on error.
pub extern fn sceKernelFreePartitionMemory(blockid: types.SceUID) callconv(.C) c_int;

/// Get the address of a memory block.
/// `blockid` - UID of the memory block.
/// Returns The lowest address belonging to the memory block.
pub extern fn sceKernelGetBlockHeadAddr(blockid: types.SceUID) callconv(.C) ?*anyopaque;

/// Get the firmware version.
/// Returns The firmware version.
/// 0x01000300 on v1.00 unit,
/// 0x01050001 on v1.50 unit,
/// 0x01050100 on v1.51 unit,
/// 0x01050200 on v1.52 unit,
/// 0x02000010 on v2.00/v2.01 unit,
/// 0x02050010 on v2.50 unit,
/// 0x02060010 on v2.60 unit,
/// 0x02070010 on v2.70 unit,
/// 0x02070110 on v2.71 unit.
pub extern fn sceKernelDevkitVersion() callconv(.C) c_int;

/// Kernel printf function.
/// `format` - The format string.
/// `...` - Arguments for the format string.
pub extern fn sceKernelPrintf(format: [*c]const c_char, ...) callconv(.C) void;

/// Set the version of the SDK with which the caller was compiled.
/// Version numbers are as for sceKernelDevkitVersion().
/// Returns 0 on success, < 0 on error.
pub extern fn sceKernelSetCompiledSdkVersion(version: c_int) callconv(.C) c_int;

/// Get the SDK version set with sceKernelSetCompiledSdkVersion().
/// Returns Version number, or 0 if unset.
pub extern fn sceKernelGetCompiledSdkVersion() callconv(.C) c_int;

comptime {
    asm (macro.import_module_start("SysMemUserForUser", "0x40000000", "9"));
    asm (macro.import_function("SysMemUserForUser", "0xA291F107", "sceKernelMaxFreeMemSize"));
    asm (macro.import_function("SysMemUserForUser", "0xF919F628", "sceKernelTotalFreeMemSize"));
    asm (macro.import_function("SysMemUserForUser", "0x237DBD4F", "sceKernelAllocPartitionMemory_stub"));
    asm (macro.generic_abi_wrapper("sceKernelAllocPartitionMemory", 5));
    asm (macro.import_function("SysMemUserForUser", "0xB6D61D02", "sceKernelFreePartitionMemory"));
    asm (macro.import_function("SysMemUserForUser", "0x9D9A5BA1", "sceKernelGetBlockHeadAddr"));
    asm (macro.import_function("SysMemUserForUser", "0x3FC9AE6A", "sceKernelDevkitVersion"));
    asm (macro.import_function("SysMemUserForUser", "0x13A5ABEF", "sceKernelPrintf"));
    asm (macro.import_function("SysMemUserForUser", "0x7591C7DB", "sceKernelSetCompiledSdkVersion"));
    asm (macro.import_function("SysMemUserForUser", "0xFC114573", "sceKernelGetCompiledSdkVersion"));
}
