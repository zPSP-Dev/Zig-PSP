// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Suspend all interrupts.
/// Returns The current state of the interrupt controller, to be used with ::sceKernelCpuResumeIntr().
pub extern fn sceKernelCpuSuspendIntr() callconv(.C) c_uint;

/// Resume all interrupts.
/// `flags` - The value returned from ::sceKernelCpuSuspendIntr().
pub extern fn sceKernelCpuResumeIntr(flags: c_uint) callconv(.C) void;

/// Resume all interrupts (using sync instructions).
/// `flags` - The value returned from ::sceKernelCpuSuspendIntr()
pub extern fn sceKernelCpuResumeIntrWithSync(flags: c_uint) callconv(.C) void;

/// Determine if interrupts are suspended or active, based on the given flags.
/// `flags` - The value returned from ::sceKernelCpuSuspendIntr().
/// Returns 1 if flags indicate that interrupts were not suspended, 0 otherwise.
pub extern fn sceKernelIsCpuIntrSuspended(flags: c_uint) callconv(.C) c_int;

/// Determine if interrupts are enabled or disabled.
/// Returns 1 if interrupts are currently enabled.
pub extern fn sceKernelIsCpuIntrEnable() callconv(.C) c_int;

/// Lock a lightweight mutex
/// `workarea` - The pointer to the workarea
/// `lockCount` - value of increase the lock counter
/// `pTimeout` - The pointer for timeout waiting
/// Returns 0 on success, otherwise one of ::PspKernelErrorCodes
pub extern fn sceKernelLockLwMutex(workarea: [*c]c_int, lockCount: c_int, pTimeout: [*c]c_uint) callconv(.C) c_int;

/// Lock a lightweight mutex
/// `workarea` - The pointer to the workarea
/// `lockCount` - value of decrease the lock counter
/// Returns 0 on success, otherwise one of ::PspKernelErrorCodes
pub extern fn sceKernelUnlockLwMutex(workarea: [*c]c_int, lockCount: c_int) callconv(.C) c_int;

/// Try to lock a lightweight mutex
/// `workarea` - The pointer to the workarea
/// `lockCount` - value of increase the lock counter
/// Returns 0 on success, otherwise one of ::PspKernelErrorCodes
pub extern fn sceKernelTryLockLwMutex(workarea: [*c]c_int, lockCount: c_int) callconv(.C) c_int;

comptime {
    asm(macro.import_module_start("Kernel_Library", "0x00010000", "8"));
    asm(macro.import_function("Kernel_Library", "0x092968F4", "sceKernelCpuSuspendIntr"));
    asm(macro.import_function("Kernel_Library", "0x5F10D406", "sceKernelCpuResumeIntr"));
    asm(macro.import_function("Kernel_Library", "0x3B84732D", "sceKernelCpuResumeIntrWithSync"));
    asm(macro.import_function("Kernel_Library", "0x47A0B729", "sceKernelIsCpuIntrSuspended"));
    asm(macro.import_function("Kernel_Library", "0xB55249D2", "sceKernelIsCpuIntrEnable"));
    asm(macro.import_function("Kernel_Library", "0xBEA46419", "sceKernelLockLwMutex"));
    asm(macro.import_function("Kernel_Library", "0x15B6446B", "sceKernelUnlockLwMutex"));
    asm(macro.import_function("Kernel_Library", "0xDC692EE3", "sceKernelTryLockLwMutex"));
}
