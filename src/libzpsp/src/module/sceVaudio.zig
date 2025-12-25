// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Output audio (blocking)
/// `volume` - It must be a value between 0 and ::PSP_VAUDIO_VOLUME_MAX
/// `buffer` - Pointer to the PCM data to output.
/// Returns 0 on success, an error if less than 0.
pub extern fn sceVaudioOutputBlocking(volume: c_int, buffer: ?*anyopaque) callconv(.C) c_int;

/// Allocate and initialize a virtual output channel.
/// `samplecount` - The number of samples that can be output on the channel per
/// output call. One of 256, 576, 1024, 1152, 2048.
/// It must be a value between ::PSP_VAUDIO_SAMPLE_MIN and ::PSP_VAUDIO_SAMPLE_MAX.
/// `frequency` - The frequency. One of 48000, 44100, 32000, 24000, 22050, 16000, 12000, 11050, 8000.
/// `format` - The output format to use for the channel. One of ::PSP_VAUDIO_FORMAT_MONO or ::PSP_VAUDIO_FORMAT_STEREO
/// Returns 0 if success, < 0 on error.
pub extern fn sceVaudioChReserve(samplecount: c_int, frequency: c_int, format: c_int) callconv(.C) c_int;

/// Release  a virtual output channel.
/// Returns 0 if success, < 0 on error.
pub extern fn sceVaudioChRelease() callconv(.C) c_int;

/// Set effect type
/// `effect` - The effect type. One of ::PSP_VAUDIO_EFFECT_OFF or ::PSP_VAUDIO_EFFECT_HEAVY or ::PSP_VAUDIO_EFFECT_POPS or ::PSP_VAUDIO_EFFECT_JAZZ or ::PSP_VAUDIO_EFFECT_UNIQUE or ::PSP_VAUDIO_EFFECT_MAX
/// `volume` - The volume. It must be a value between 0 and ::PSP_VAUDIO_VOLUME_MAX
/// Returns The volume value on success, < 0 on error.
pub extern fn sceVaudioSetEffectType(effect: c_int, volume: c_int) callconv(.C) c_int;

/// Set ALC(dynamic normalizer)
/// `mode` - The mode. One of ::PSP_VAUDIO_ALC_OFF or ::PSP_VAUDIO_ALC_MODE1 or ::PSP_VAUDIO_ALC_MODE_MAX
/// Returns 0 if success, < 0 on error.
pub extern fn sceVaudioSetAlcMode(mode: c_int) callconv(.C) c_int;

pub extern fn sceVaudio_504E4745() callconv(.C) void;

pub extern fn sceVaudioChReserveBuffering() callconv(.C) void;

pub extern fn sceVaudio_E8E78DC8() callconv(.C) void;

comptime {
    asm(macro.import_module_start("sceVaudio", "0x40090000", "8"));
    asm(macro.import_function("sceVaudio", "0x8986295E", "sceVaudioOutputBlocking"));
    asm(macro.import_function("sceVaudio", "0x03B6807D", "sceVaudioChReserve"));
    asm(macro.import_function("sceVaudio", "0x67585DFD", "sceVaudioChRelease"));
    asm(macro.import_function("sceVaudio", "0x346fbe94", "sceVaudioSetEffectType"));
    asm(macro.import_function("sceVaudio", "0xcbd4ac51", "sceVaudioSetAlcMode"));
    asm(macro.import_function("sceVaudio", "0x504E4745", "sceVaudio_504E4745"));
    asm(macro.import_function("sceVaudio", "0x27ACC20B", "sceVaudioChReserveBuffering"));
    asm(macro.import_function("sceVaudio", "0xE8E78DC8", "sceVaudio_E8E78DC8"));
}
