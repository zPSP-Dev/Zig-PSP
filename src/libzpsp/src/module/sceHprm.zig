// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

pub extern fn sceHprmRegisterCallback() callconv(.c) void;

pub extern fn sceHprmUnregisterCallback() callconv(.c) void;

/// Determines whether the remote is plugged in.
/// Returns 1 if the remote is plugged in, else 0.
pub extern fn sceHprmIsRemoteExist() callconv(.c) c_int;

/// Determines whether the headphones are plugged in.
/// Returns 1 if the headphones are plugged in, else 0.
pub extern fn sceHprmIsHeadphoneExist() callconv(.c) c_int;

/// Determines whether the microphone is plugged in.
/// Returns 1 if the microphone is plugged in, else 0.
pub extern fn sceHprmIsMicrophoneExist() callconv(.c) c_int;

/// Peek at the current being pressed on the remote.
/// `key` - Pointer to the u32 to receive the key bitmap, should be one or
/// more of ::PspHprmKeys
/// Returns < 0 on error
pub extern fn sceHprmPeekCurrentKey(key: [*c]u32) callconv(.c) c_int;

/// Peek at the current latch data.
/// `latch` - Pointer a to a 4 dword array to contain the latch data.
/// Returns < 0 on error.
pub extern fn sceHprmPeekLatch(latch: [*c]u32) callconv(.c) c_int;

/// Read the current latch data.
/// `latch` - Pointer a to a 4 dword array to contain the latch data.
/// Returns < 0 on error.
pub extern fn sceHprmReadLatch(latch: [*c]u32) callconv(.c) c_int;

comptime {
    asm (macro.import_module_start("sceHprm", "0x40010000", "8"));
    asm (macro.import_function("sceHprm", "0xC7154136", "sceHprmRegisterCallback"));
    asm (macro.import_function("sceHprm", "0x444ED0B7", "sceHprmUnregisterCallback"));
    asm (macro.import_function("sceHprm", "0x208DB1BD", "sceHprmIsRemoteExist"));
    asm (macro.import_function("sceHprm", "0x7E69EDA4", "sceHprmIsHeadphoneExist"));
    asm (macro.import_function("sceHprm", "0x219C58F1", "sceHprmIsMicrophoneExist"));
    asm (macro.import_function("sceHprm", "0x1910B327", "sceHprmPeekCurrentKey"));
    asm (macro.import_function("sceHprm", "0x2BCEC83E", "sceHprmPeekLatch"));
    asm (macro.import_function("sceHprm", "0x40D2F9F0", "sceHprmReadLatch"));
}
