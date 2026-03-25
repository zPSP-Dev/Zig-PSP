// Audio hardware -- channel output/input, routing, virtual audio
//
// Wraps:
//   c/module/sceAudio.zig
//   c/module/sceAudioRouting.zig
//   c/module/sceVaudio.zig

const c = @import("../c/modules.zig");
const internal = @import("internal.zig");
const check = internal.check;
const checkPositive = internal.checkPositive;
const ci = internal.ci;
const cu = internal.cu;
const Error = internal.Error;

const audio = c.sceAudio;
const routing = c.sceAudioRouting;
const vaudio = c.sceVaudio;

pub const InputParams = c.types.pspAudioInputParams;

pub const Format = enum(c_int) {
    stereo = 0,
    mono = 0x10,
};

pub const next_channel: i32 = -1;
pub const sample_min: i32 = 64;
pub const sample_max: i32 = 65472;

// -- Channel management -----------------------------------------------

pub fn ch_reserve(channel: i32, samplecount: i32, format: Format) Error!i32 {
    const ret = audio.sceAudioChReserve(@as(c_int, channel), @as(c_int, samplecount), @intFromEnum(format));
    return checkPositive(ret);
}

pub fn ch_release(channel: i32) Error!void {
    return check(audio.sceAudioChRelease(@as(c_int, channel)));
}

pub fn set_channel_data_len(channel: i32, samplecount: i32) Error!void {
    return check(audio.sceAudioSetChannelDataLen(@as(c_int, channel), @as(c_int, samplecount)));
}

pub fn change_channel_config(channel: i32, format: Format) Error!void {
    return check(audio.sceAudioChangeChannelConfig(@as(c_int, channel), @intFromEnum(format)));
}

pub fn change_channel_volume(channel: i32, leftvol: i32, rightvol: i32) Error!void {
    return check(audio.sceAudioChangeChannelVolume(@as(c_int, channel), @as(c_int, leftvol), @as(c_int, rightvol)));
}

pub fn get_channel_rest_len(channel: i32) Error!i32 {
    const ret = audio.sceAudioGetChannelRestLen(@as(c_int, channel));
    return checkPositive(ret);
}

pub fn get_channel_rest_length(channel: i32) Error!i32 {
    const ret = audio.sceAudioGetChannelRestLength(@as(c_int, channel));
    return checkPositive(ret);
}

// -- Output ------------------------------------------------------------

pub fn output(channel: i32, vol: i32, buf: ?*anyopaque) Error!void {
    return check(audio.sceAudioOutput(@as(c_int, channel), @as(c_int, vol), buf));
}

pub fn output_blocking(channel: i32, vol: i32, buf: ?*anyopaque) Error!void {
    return check(audio.sceAudioOutputBlocking(@as(c_int, channel), @as(c_int, vol), buf));
}

pub fn output_panned(channel: i32, leftvol: i32, rightvol: i32, buf: ?*anyopaque) Error!void {
    return check(audio.sceAudioOutputPanned(@as(c_int, channel), @as(c_int, leftvol), @as(c_int, rightvol), buf));
}

pub fn output_panned_blocking(channel: i32, leftvol: i32, rightvol: i32, buf: ?*anyopaque) Error!void {
    return check(audio.sceAudioOutputPannedBlocking(@as(c_int, channel), @as(c_int, leftvol), @as(c_int, rightvol), buf));
}

// -- Output2 (simplified channel) -------------------------------------

pub fn output2_reserve(samplecount: i32) Error!void {
    return check(audio.sceAudioOutput2Reserve(@as(c_int, samplecount)));
}

pub fn output2_release() Error!void {
    return check(audio.sceAudioOutput2Release());
}

pub fn output2_change_length(samplecount: i32) Error!void {
    return check(audio.sceAudioOutput2ChangeLength(@as(c_int, samplecount)));
}

pub fn output2_output_blocking(vol: i32, buf: ?*anyopaque) Error!void {
    return check(audio.sceAudioOutput2OutputBlocking(@as(c_int, vol), buf));
}

pub fn output2_get_rest_sample() Error!i32 {
    const ret = audio.sceAudioOutput2GetRestSample();
    return checkPositive(ret);
}

// -- SRC (sample rate conversion) channel -----------------------------

pub fn src_ch_reserve(samplecount: i32, freq: i32, channels: i32) Error!void {
    return check(audio.sceAudioSRCChReserve(@as(c_int, samplecount), @as(c_int, freq), @as(c_int, channels)));
}

pub fn src_ch_release() Error!void {
    return check(audio.sceAudioSRCChRelease());
}

pub fn src_output_blocking(vol: i32, buf: ?*anyopaque) Error!void {
    return check(audio.sceAudioSRCOutputBlocking(@as(c_int, vol), buf));
}

// -- Input (microphone) -----------------------------------------------

pub fn input_init(unk1: i32, gain: i32, unk2: i32) Error!void {
    return check(audio.sceAudioInputInit(@as(c_int, unk1), @as(c_int, gain), @as(c_int, unk2)));
}

pub fn input_init_ex(params: *InputParams) Error!void {
    return check(audio.sceAudioInputInitEx(params));
}

pub fn input_blocking(samplecount: i32, freq: i32, buf: ?*anyopaque) Error!void {
    return check(audio.sceAudioInputBlocking(@as(c_int, samplecount), @as(c_int, freq), buf));
}

pub fn input(samplecount: i32, freq: i32, buf: ?*anyopaque) Error!void {
    return check(audio.sceAudioInput(@as(c_int, samplecount), @as(c_int, freq), buf));
}

pub fn get_input_length() Error!i32 {
    const ret = audio.sceAudioGetInputLength();
    return checkPositive(ret);
}

pub fn wait_input_end() Error!void {
    return check(audio.sceAudioWaitInputEnd());
}

pub fn poll_input_end() bool {
    return audio.sceAudioPollInputEnd() == 0;
}

// -- sceAudioRouting --------------------------------------------------

pub fn routing_get_mode() i32 {
    return routing.sceAudioRoutingGetMode();
}

pub fn routing_set_mode(mode: i32) Error!void {
    return check(routing.sceAudioRoutingSetMode(@as(c_int, mode)));
}

pub fn routing_get_volume_mode() i32 {
    return routing.sceAudioRoutingGetVolumeMode();
}

pub fn routing_set_volume_mode(mode: i32) Error!void {
    return check(routing.sceAudioRoutingSetVolumeMode(@as(c_int, mode)));
}

// -- sceVaudio (virtual audio) ----------------------------------------

pub fn vaudio_output_blocking(volume: i32, buffer: ?*anyopaque) Error!void {
    return check(vaudio.sceVaudioOutputBlocking(@as(c_int, volume), buffer));
}

pub fn vaudio_ch_reserve(samplecount: i32, frequency: i32, format: i32) Error!void {
    return check(vaudio.sceVaudioChReserve(@as(c_int, samplecount), @as(c_int, frequency), @as(c_int, format)));
}

pub fn vaudio_ch_release() Error!void {
    return check(vaudio.sceVaudioChRelease());
}

pub fn vaudio_set_effect_type(effect: i32, volume: i32) Error!void {
    return check(vaudio.sceVaudioSetEffectType(@as(c_int, effect), @as(c_int, volume)));
}

pub fn vaudio_set_alc_mode(mode: i32) Error!void {
    return check(vaudio.sceVaudioSetAlcMode(@as(c_int, mode)));
}
