// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Returns The current routing volume mode.
pub extern fn sceAudioRoutingGetVolumeMode() callconv(.c) c_int;

/// Set routing mode.
/// `mode The routing mode to set (0 or 1)`
/// Returns the previous routing mode, or < 0 on error
pub extern fn sceAudioRoutingSetMode(mode: c_int) callconv(.c) c_int;

/// Get routing mode.
/// Returns the current routing mode.
pub extern fn sceAudioRoutingGetMode() callconv(.c) c_int;

/// `vol_mode The routing volume to set (`0` or `1`).`
/// Returns `0` on success, `< 0` on error.
pub extern fn sceAudioRoutingSetVolumeMode(vol_mode: c_int) callconv(.c) c_int;

comptime {
    asm (macro.import_module_start("sceAudioRouting", "0x40010000", "4"));
    asm (macro.import_function("sceAudioRouting", "0x28235C56", "sceAudioRoutingGetVolumeMode"));
    asm (macro.import_function("sceAudioRouting", "0x36FD8AA9", "sceAudioRoutingSetMode"));
    asm (macro.import_function("sceAudioRouting", "0x39240E7D", "sceAudioRoutingGetMode"));
    asm (macro.import_function("sceAudioRouting", "0xBB548475", "sceAudioRoutingSetVolumeMode"));
}
