pub const enum_PspAudioFormats = extern enum(c_int) {
    PSP_AUDIO_FORMAT_STEREO = 0,
    PSP_AUDIO_FORMAT_MONO = 16,
    _,
};
const struct_unnamed_1 = extern struct {
    unknown1: c_int,
    gain: c_int,
    unknown2: c_int,
    unknown3: c_int,
    unknown4: c_int,
    unknown5: c_int,
};
pub const PspAudioFormats = enum_PspAudioFormats;
pub const pspAudioInputParams = struct_unnamed_1;
pub extern fn sceAudioChReserve(channel: c_int, samplecount: c_int, format: c_int) c_int;
pub extern fn sceAudioChRelease(channel: c_int) c_int;
pub extern fn sceAudioOutput(channel: c_int, vol: c_int, buf: ?*c_void) c_int;
pub extern fn sceAudioOutputBlocking(channel: c_int, vol: c_int, buf: ?*c_void) c_int;
pub extern fn sceAudioOutputPanned(channel: c_int, leftvol: c_int, rightvol: c_int, buf: ?*c_void) c_int;
pub extern fn sceAudioOutputPannedBlocking(channel: c_int, leftvol: c_int, rightvol: c_int, buf: ?*c_void) c_int;
pub extern fn sceAudioGetChannelRestLen(channel: c_int) c_int;
pub extern fn sceAudioGetChannelRestLength(channel: c_int) c_int;
pub extern fn sceAudioSetChannelDataLen(channel: c_int, samplecount: c_int) c_int;
pub extern fn sceAudioChangeChannelConfig(channel: c_int, format: c_int) c_int;
pub extern fn sceAudioChangeChannelVolume(channel: c_int, leftvol: c_int, rightvol: c_int) c_int;
pub extern fn sceAudioOutput2Reserve(samplecount: c_int) c_int;
pub extern fn sceAudioOutput2Release() c_int;
pub extern fn sceAudioOutput2ChangeLength(samplecount: c_int) c_int;
pub extern fn sceAudioOutput2OutputBlocking(vol: c_int, buf: ?*c_void) c_int;
pub extern fn sceAudioOutput2GetRestSample() c_int;
pub extern fn sceAudioSRCChReserve(samplecount: c_int, freq: c_int, channels: c_int) c_int;
pub extern fn sceAudioSRCChRelease() c_int;
pub extern fn sceAudioSRCOutputBlocking(vol: c_int, buf: ?*c_void) c_int;
pub extern fn sceAudioInputInit(unknown1: c_int, gain: c_int, unknown2: c_int) c_int;
pub extern fn sceAudioInputInitEx(params: [*c]pspAudioInputParams) c_int;
pub extern fn sceAudioInputBlocking(samplecount: c_int, freq: c_int, buf: ?*c_void) c_int;
pub extern fn sceAudioInput(samplecount: c_int, freq: c_int, buf: ?*c_void) c_int;
pub extern fn sceAudioGetInputLength() c_int;
pub extern fn sceAudioWaitInputEnd() c_int;
pub extern fn sceAudioPollInputEnd() c_int;

const macro = @import("pspmacros.zig");

comptime{
    asm(macro.import_module_start("sceAudio", "0x40010000", "27"));
    asm(macro.import_function("sceAudio", "0x8C1009B2", "sceAudioOutput"));
    asm(macro.import_function("sceAudio", "0x136CAF51", "sceAudioOutputBlocking"));
    asm(macro.import_function("sceAudio", "0xE2D56B2D", "sceAudioOutputPanned"));
    asm(macro.import_function("sceAudio", "0x13F592BC", "sceAudioOutputPannedBlocking"));
    asm(macro.import_function("sceAudio", "0x5EC81C55", "sceAudioChReserve"));
    asm(macro.import_function("sceAudio", "0x41EFADE7", "sceAudioOneshotOutput"));
    asm(macro.import_function("sceAudio", "0x6FC46853", "sceAudioChRelease"));
    asm(macro.import_function("sceAudio", "0xE9D97901", "sceAudioGetChannelRestLen"));
    asm(macro.import_function("sceAudio", "0xCB2E439E", "sceAudioSetChannelDataLen"));
    asm(macro.import_function("sceAudio", "0x95FD0C2D", "sceAudioChangeChannelConfig"));
    asm(macro.import_function("sceAudio", "0xB7E1D8E7", "sceAudioChangeChannelVolume"));
    asm(macro.import_function("sceAudio", "0x38553111", "sceAudioSRCChReserve"));
    asm(macro.import_function("sceAudio", "0x5C37C0AE", "sceAudioSRCChRelease"));
    asm(macro.import_function("sceAudio", "0xE0727056", "sceAudioSRCOutputBlocking"));
    asm(macro.import_function("sceAudio", "0x086E5895", "sceAudioInputBlocking"));
    asm(macro.import_function("sceAudio", "0x6D4BEC68", "sceAudioInput"));
    asm(macro.import_function("sceAudio", "0xA708C6A6", "sceAudioGetInputLength"));
    asm(macro.import_function("sceAudio", "0x87B2E651", "sceAudioWaitInputEnd"));
    asm(macro.import_function("sceAudio", "0x7DE61688", "sceAudioInputInit"));
    asm(macro.import_function("sceAudio", "0xA633048E", "sceAudioPollInputEnd"));
    asm(macro.import_function("sceAudio", "0xB011922F", "sceAudioGetChannelRestLength"));
    asm(macro.import_function("sceAudio", "0xE926D3FB", "sceAudioInputInitEx"));
    asm(macro.import_function("sceAudio", "0x01562BA3", "sceAudioOutput2Reserve"));
    asm(macro.import_function("sceAudio", "0x2D53F36E", "sceAudioOutput2OutputBlocking"));
    asm(macro.import_function("sceAudio", "0x43196845", "sceAudioOutput2Release"));
    asm(macro.import_function("sceAudio", "0x63F2889C", "sceAudioOutput2ChangeLength"));
    asm(macro.import_function("sceAudio", "0x647CEF33", "sceAudioOutput2GetRestSample"));
}