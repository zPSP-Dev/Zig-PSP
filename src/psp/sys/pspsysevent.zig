pub const struct_PspSysEventHandler = extern struct {
    size: c_int,
    name: [*c]u8,
    type_mask: c_int,
    handler: ?fn (c_int, [*c]u8, ?*c_void, [*c]c_int) callconv(.C) c_int,
    r28: c_int,
    busy: c_int,
    next: [*c]_PspSysEventHandler,
    reserved: [9]c_int,
};
pub const _PspSysEventHandler = struct_PspSysEventHandler;
pub const PspSysEventHandlerFunc = ?fn (c_int, [*c]u8, ?*c_void, [*c]c_int) callconv(.C) c_int;
pub const PspSysEventHandler = struct_PspSysEventHandler;
pub extern fn sceKernelSysEventDispatch(ev_type_mask: c_int, ev_id: c_int, ev_name: [*c]u8, param: ?*c_void, result: [*c]c_int, break_nonzero: c_int, break_handler: [*c]PspSysEventHandler) c_int;
pub extern fn sceKernelReferSysEventHandler() [*c]PspSysEventHandler;
pub extern fn sceKernelIsRegisterSysEventHandler(handler: [*c]PspSysEventHandler) c_int;
pub extern fn sceKernelRegisterSysEventHandler(handler: [*c]PspSysEventHandler) c_int;
pub extern fn sceKernelUnregisterSysEventHandler(handler: [*c]PspSysEventHandler) c_int;

const macro = @import("pspmacros.zig");

comptime{
    asm(macro.import_module_start("sceSysEventForKernel", "0x00010000", "5"));
    asm(macro.import_function("sceSysEventForKernel", "0xAEB300AE", "sceKernelIsRegisterSysEventHandler"));
    asm(macro.import_function("sceSysEventForKernel", "0xCD9E4BB5", "sceKernelRegisterSysEventHandler"));
    asm(macro.import_function("sceSysEventForKernel", "0xD7D3FDCD", "sceKernelUnregisterSysEventHandler"));
    asm(macro.import_function("sceSysEventForKernel", "0x36331294", "sceKernelSysEventDispatch_stub"));
    asm(macro.import_function("sceSysEventForKernel", "0x68D55505", "sceKernelReferSysEventHandler"));

    asm(macro.generic_abi_wrapper("sceKernelSysEventDispatch", 7));
}
