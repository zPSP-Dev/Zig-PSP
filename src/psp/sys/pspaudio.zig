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

//Kernel?
pub const enum_PspAudioFrequencies = extern enum(c_int) {
    PSP_AUDIO_FREQ_44K = 44100,
    PSP_AUDIO_FREQ_48K = 48000,
    _,
};
pub extern fn sceAudioSetFrequency(frequency: c_int) c_int;
pub const PspAudioFrequencies = enum_PspAudioFrequencies;

//Kernel?
pub extern fn sceAudioRoutingSetMode(mode: c_int) c_int;
pub extern fn sceAudioRoutingGetMode(...) c_int;