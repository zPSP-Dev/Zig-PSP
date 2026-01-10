const c = @import("../c/modules.zig");
const module = c.SysMemUserForUser;

const SceUID = c.types.SceUID;

pub const PspSysMemBlockTypes = enum(c_int) {
    MemLow = 0,
    MemHigh = 1,
    MemAddr = 2,
};

pub const PspSysMemPartitionID = enum(u32) {
    Kernel = 1,
    User = 2,
};

/// Get the size of the largest free memory block.
/// Returns The size of the largest free memory block, in bytes.
pub fn sceKernelMaxFreeMemSize() usize {
    return module.sceKernelMaxFreeMemSize();
}

/// Get the total amount of free memory.
/// Returns The total amount of free memory, in bytes.
pub fn sceKernelTotalFreeMemSize() usize {
    return module.sceKernelTotalFreeMemSize();
}

/// Allocate a memory block from a memory partition.
/// `partitionid` - The UID of the partition to allocate from.
/// `name` - Name assigned to the new block.
/// `type` - Specifies how the block is allocated within the partition.  One of ::PspSysMemBlockTypes.
/// `size` - Size of the memory block, in bytes.
/// `addr` - If type is PSP_SMEM_Addr, then addr specifies the lowest address allocate the block from.
/// Returns The UID of the new block, or if less than 0 an error.
pub fn sceKernelAllocPartitionMemory(partitionid: PspSysMemPartitionID, name: [:0]const u8, block_type: PspSysMemBlockTypes, size: usize, addr: ?*anyopaque) SceUID {
    return module.sceKernelAllocPartitionMemory(@intFromEnum(partitionid), @ptrCast(name), @intFromEnum(block_type), size, addr);
}

/// Free a memory block allocated with ::sceKernelAllocPartitionMemory.
/// `blockid` - UID of the block to free.
/// Returns ? on success, less than 0 on error.
pub fn sceKernelFreePartitionMemory(blockid: SceUID) c_int {
    return module.sceKernelFreePartitionMemory(blockid);
}

/// Get the address of a memory block.
/// `blockid` - UID of the memory block.
/// Returns The lowest address belonging to the memory block.
pub fn sceKernelGetBlockHeadAddr(blockid: SceUID) ?*anyopaque {
    return module.sceKernelGetBlockHeadAddr(blockid);
}

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
pub fn sceKernelDevkitVersion() c_int {
    return module.sceKernelDevkitVersion();
}

/// Kernel printf function.
/// `format` - The format string.
/// `...` - Arguments for the format string.
pub fn sceKernelPrintf(format: [*c]const c_char, ...) void {
    _ = format;
    @panic("How do we even handle this?");
}

/// Set the version of the SDK with which the caller was compiled.
/// Version numbers are as for sceKernelDevkitVersion().
/// Returns 0 on success, < 0 on error.
pub fn sceKernelSetCompiledSdkVersion(version: c_int) c_int {
    return module.sceKernelSetCompiledSdkVersion(version);
}

/// Get the SDK version set with sceKernelSetCompiledSdkVersion().
/// Returns Version number, or 0 if unset.
pub fn sceKernelGetCompiledSdkVersion() c_int {
    return module.sceKernelGetCompiledSdkVersion();
}
