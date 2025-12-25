// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Attach to the wlan device
/// Returns 0 on success, < 0 on error.
pub extern fn sceWlanDevAttach() callconv(.C) c_int;

/// Detach from the wlan device
/// Returns 0 on success, < 0 on error/
pub extern fn sceWlanDevDetach() callconv(.C) c_int;

pub extern fn sceWlanDrv_lib_19E51F54() callconv(.C) void;

pub extern fn sceWlanDevIsGameMode() callconv(.C) void;

pub extern fn sceWlanGPPrevEstablishActive() callconv(.C) void;

pub extern fn sceWlanGPSend() callconv(.C) void;

pub extern fn sceWlanGPRecv() callconv(.C) void;

pub extern fn sceWlanGPRegisterCallback() callconv(.C) void;

pub extern fn sceWlanGPUnRegisterCallback() callconv(.C) void;

pub extern fn sceWlanDrv_lib_81579D36() callconv(.C) void;

pub extern fn sceWlanDrv_lib_5BAA1FE5() callconv(.C) void;

pub extern fn sceWlanDrv_lib_4C14BACA() callconv(.C) void;

pub extern fn sceWlanDrv_lib_2D0FAE4E() callconv(.C) void;

pub extern fn sceWlanDrv_lib_56F467CA() callconv(.C) void;

pub extern fn sceWlanDrv_lib_FE8A0B46() callconv(.C) void;

pub extern fn sceWlanDrv_lib_40B0AA4A() callconv(.C) void;

pub extern fn sceWlanDevSetGPIO() callconv(.C) void;

pub extern fn sceWlanDevGetStateGPIO() callconv(.C) void;

comptime {
    asm(macro.import_module_start("sceWlanDrv_lib", "0x40010000", "18"));
    asm(macro.import_function("sceWlanDrv_lib", "0x482CAE9A", "sceWlanDevAttach"));
    asm(macro.import_function("sceWlanDrv_lib", "0xC9A8CAB7", "sceWlanDevDetach"));
    asm(macro.import_function("sceWlanDrv_lib", "0x19E51F54", "sceWlanDrv_lib_19E51F54"));
    asm(macro.import_function("sceWlanDrv_lib", "0x5E7C8D94", "sceWlanDevIsGameMode"));
    asm(macro.import_function("sceWlanDrv_lib", "0x5ED4049A", "sceWlanGPPrevEstablishActive"));
    asm(macro.import_function("sceWlanDrv_lib", "0xB4D7CB74", "sceWlanGPSend"));
    asm(macro.import_function("sceWlanDrv_lib", "0xA447103A", "sceWlanGPRecv"));
    asm(macro.import_function("sceWlanDrv_lib", "0x9658C9F7", "sceWlanGPRegisterCallback"));
    asm(macro.import_function("sceWlanDrv_lib", "0x4C7F62E0", "sceWlanGPUnRegisterCallback"));
    asm(macro.import_function("sceWlanDrv_lib", "0x81579D36", "sceWlanDrv_lib_81579D36"));
    asm(macro.import_function("sceWlanDrv_lib", "0x5BAA1FE5", "sceWlanDrv_lib_5BAA1FE5"));
    asm(macro.import_function("sceWlanDrv_lib", "0x4C14BACA", "sceWlanDrv_lib_4C14BACA"));
    asm(macro.import_function("sceWlanDrv_lib", "0x2D0FAE4E", "sceWlanDrv_lib_2D0FAE4E"));
    asm(macro.import_function("sceWlanDrv_lib", "0x56F467CA", "sceWlanDrv_lib_56F467CA"));
    asm(macro.import_function("sceWlanDrv_lib", "0xFE8A0B46", "sceWlanDrv_lib_FE8A0B46"));
    asm(macro.import_function("sceWlanDrv_lib", "0x40B0AA4A", "sceWlanDrv_lib_40B0AA4A"));
    asm(macro.import_function("sceWlanDrv_lib", "0x7FF54BD2", "sceWlanDevSetGPIO"));
    asm(macro.import_function("sceWlanDrv_lib", "0x05FE320C", "sceWlanDevGetStateGPIO"));
}
