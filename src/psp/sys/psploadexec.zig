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

const macro = @import("pspmacros.zig");

comptime{
    asm(macro.import_module_start("LoadExecForUser", 0x40010000));
    asm(macro.import_function2("LoadExecForUser",0xBD2F1094, "sceKernelLoadExec"));
    asm(macro.import_function2("LoadExecForUser",0x2AC9954B, "sceKernelExitGameWithStatus"));
    asm(macro.import_function2("LoadExecForUser",0x05572A5F, "sceKernelExitGame"));
    asm(macro.import_function2("LoadExecForUser",0x4AC57943, "sceKernelRegisterExitCallback"));
}

