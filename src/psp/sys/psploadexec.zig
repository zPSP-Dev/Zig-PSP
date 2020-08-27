usingnamespace @import("psptypes.zig");

pub extern fn sceKernelRegisterExitCallback(cbid: c_int) c_int;
pub extern fn sceKernelExitGame() void;
pub const struct_SceKernelLoadExecParam = extern struct {
    size: SceSize,
    args: SceSize,
    argp: ?*c_void,
    key: [*c]const u8,
};
pub extern fn sceKernelLoadExec(file: [*c]const u8, param: [*c]struct_SceKernelLoadExecParam) c_int;

pub const SceKernelLoadExecParam = struct_SceKernelLoadExecParam;