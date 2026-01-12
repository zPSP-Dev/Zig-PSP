// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

pub extern fn sceKernelPowerLock() callconv(.c) void;

pub extern fn sceKernelPowerUnlock() callconv(.c) void;

pub extern fn sceKernelPowerTick() callconv(.c) void;

/// Allocate the extra 4megs of RAM
/// `unk` - No idea as it is never used, set to anything
/// `ptr` - Pointer to a pointer to hold the address of the memory
/// `size` - Pointer to an int which will hold the size of the memory
/// Returns 0 on success
pub extern fn sceKernelVolatileMemLock(unk: c_int, ptr: ?*anyopaque, size: [*c]c_int) callconv(.c) c_int;

/// Try and allocate the extra 4megs of RAM, will return an error if
/// something has already allocated it
/// `unk` - No idea as it is never used, set to anything
/// `ptr` - Pointer to a pointer to hold the address of the memory
/// `size` - Pointer to an int which will hold the size of the memory
/// Returns 0 on success
pub extern fn sceKernelVolatileMemTryLock(unk: c_int, ptr: ?*anyopaque, size: [*c]c_int) callconv(.c) c_int;

/// Deallocate the extra 4 megs of RAM
/// `unk` - Set to 0, otherwise it fails in 3.52+, possibly earlier
/// Returns 0 on success
pub extern fn sceKernelVolatileMemUnlock(unk: c_int) callconv(.c) c_int;

comptime {
    asm (macro.import_module_start("sceSuspendForUser", "0x40000000", "6"));
    asm (macro.import_function("sceSuspendForUser", "0xEADB1BD7", "sceKernelPowerLock"));
    asm (macro.import_function("sceSuspendForUser", "0x3AEE7261", "sceKernelPowerUnlock"));
    asm (macro.import_function("sceSuspendForUser", "0x090CCB3F", "sceKernelPowerTick"));
    asm (macro.import_function("sceSuspendForUser", "0x3E0271D3", "sceKernelVolatileMemLock"));
    asm (macro.import_function("sceSuspendForUser", "0xA14F40B2", "sceKernelVolatileMemTryLock"));
    asm (macro.import_function("sceSuspendForUser", "0xA569E425", "sceKernelVolatileMemUnlock"));
}
