// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Register a sub interrupt handler.
/// `intno` - The interrupt number to register.
/// `no` - The sub interrupt handler number (user controlled)
/// `handler` - The interrupt handler
/// `arg` - An argument passed to the interrupt handler
/// Returns < 0 on error.
pub extern fn sceKernelRegisterSubIntrHandler(intno: c_int, no: c_int, handler: ?*anyopaque, arg: ?*anyopaque) callconv(.C) c_int;

/// Release a sub interrupt handler.
/// `intno` - The interrupt number to register.
/// `no` - The sub interrupt handler number
/// Returns < 0 on error.
pub extern fn sceKernelReleaseSubIntrHandler(intno: c_int, no: c_int) callconv(.C) c_int;

/// Enable a sub interrupt.
/// `intno` - The sub interrupt to enable.
/// `no` - The sub interrupt handler number
/// Returns < 0 on error.
pub extern fn sceKernelEnableSubIntr(intno: c_int, no: c_int) callconv(.C) c_int;

/// Disable a sub interrupt handler.
/// `intno` - The sub interrupt to disable.
/// `no` - The sub interrupt handler number
/// Returns < 0 on error.
pub extern fn sceKernelDisableSubIntr(intno: c_int, no: c_int) callconv(.C) c_int;

pub extern fn sceKernelSuspendSubIntr() callconv(.C) void;

pub extern fn sceKernelResumeSubIntr() callconv(.C) void;

pub extern fn sceKernelIsSubInterruptOccurred() callconv(.C) void;

pub extern fn QueryIntrHandlerInfo(intr_code: types.SceUID, sub_intr_code: types.SceUID, data: [*c]c_int) callconv(.C) c_int;

pub extern fn sceKernelRegisterUserSpaceIntrStack() callconv(.C) void;

comptime {
    asm(macro.import_module_start("InterruptManager", "0x40000000", "9"));
    asm(macro.import_function("InterruptManager", "0xCA04A2B9", "sceKernelRegisterSubIntrHandler"));
    asm(macro.import_function("InterruptManager", "0xD61E6961", "sceKernelReleaseSubIntrHandler"));
    asm(macro.import_function("InterruptManager", "0xFB8E22EC", "sceKernelEnableSubIntr"));
    asm(macro.import_function("InterruptManager", "0x8A389411", "sceKernelDisableSubIntr"));
    asm(macro.import_function("InterruptManager", "0x5CB5A78B", "sceKernelSuspendSubIntr"));
    asm(macro.import_function("InterruptManager", "0x7860E0DC", "sceKernelResumeSubIntr"));
    asm(macro.import_function("InterruptManager", "0xFC4374B8", "sceKernelIsSubInterruptOccurred"));
    asm(macro.import_function("InterruptManager", "0xD2E8363F", "QueryIntrHandlerInfo"));
    asm(macro.import_function("InterruptManager", "0xEEE43F47", "sceKernelRegisterUserSpaceIntrStack"));
}
