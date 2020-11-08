usingnamespace @import("psptypes.zig");

pub const PspSysMemBlockTypes = extern enum(c_int) {
    MemLow = 0,
    MemHigh = 1,
    MemAddr = 2,
};
pub const SceKernelSysMemAlloc_t = c_int;

// Allocate a memory block from a memory partition.
//
// @param partitionid - The UID of the partition to allocate from.
// @param name - Name assigned to the new block.
// @param type - Specifies how the block is allocated within the partition.  One of ::PspSysMemBlockTypes.
// @param size - Size of the memory block, in bytes.
// @param addr - If type is PSP_SMEM_Addr, then addr specifies the lowest address allocate the block from.
//
// @return The UID of the new block, or if less than 0 an error.
pub extern fn sceKernelAllocPartitionMemory(partitionid: SceUID, name: [*c]const u8, typec: c_int, size: SceSize, addr: ?*c_void) SceUID;

pub fn kernelAllocPartitionMemory(partitionid: SceUID, name: [*c]const u8, typec: c_int, size: SceSize, addr: ?*c_void) !SceUID {
    var res = sceKernelAllocPartitionMemory(partitionid, name, typec, size, addr);
    if (res < 0) {
        return error.AllocationError;
    }
    return res;
}

// Free a memory block allocated with ::sceKernelAllocPartitionMemory.
//
// @param blockid - UID of the block to free.
//
// @return ? on success, less than 0 on error.
pub extern fn sceKernelFreePartitionMemory(blockid: SceUID) c_int;

// Get the address of a memory block.
//
// @param blockid - UID of the memory block.
//
// @return The lowest address belonging to the memory block.
pub extern fn sceKernelGetBlockHeadAddr(blockid: SceUID) ?*c_void;

// Get the total amount of free memory.
//
// @return The total amount of free memory, in bytes.
pub extern fn sceKernelTotalFreeMemSize() SceSize;

// Get the size of the largest free memory block.
//
// @return The size of the largest free memory block, in bytes.
pub extern fn sceKernelMaxFreeMemSize() SceSize;

// Get the firmware version.
//
// @return The firmware version.
// 0x01000300 on v1.00 unit,
// 0x01050001 on v1.50 unit,
// 0x01050100 on v1.51 unit,
// 0x01050200 on v1.52 unit,
// 0x02000010 on v2.00/v2.01 unit,
// 0x02050010 on v2.50 unit,
// 0x02060010 on v2.60 unit,
// 0x02070010 on v2.70 unit,
// 0x02070110 on v2.71 unit.
pub extern fn sceKernelDevkitVersion() c_int;

// Set the version of the SDK with which the caller was compiled.
// Version numbers are as for sceKernelDevkitVersion().
//
// @return 0 on success, < 0 on error.
pub extern fn sceKernelSetCompiledSdkVersion(version: c_int) c_int;
pub fn kernelSetCompiledSdkVersion(version: c_int) !void {
    var res = sceKernelSetCompiledSdkVersion(version);
    if (res < 0) {
        return error.Unexpected;
    }
}

// Get the SDK version set with sceKernelSetCompiledSdkVersion().
//
// @return Version number, or 0 if unset.
pub extern fn sceKernelGetCompiledSdkVersion() c_int;
