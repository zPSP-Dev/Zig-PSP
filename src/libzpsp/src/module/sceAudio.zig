// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Output audio of the specified channel
/// `channel` - The channel number.
/// `vol` - The volume.
/// `buf` - Pointer to the PCM data to output.
/// Returns 0 on success, an error if less than 0.
pub extern fn sceAudioOutput(channel: c_int, vol: c_int, buf: ?*anyopaque) callconv(.C) c_int;

/// Output audio of the specified channel (blocking)
/// `channel` - The channel number.
/// `vol` - The volume.
/// `buf` - Pointer to the PCM data to output.
/// Returns 0 on success, an error if less than 0.
pub extern fn sceAudioOutputBlocking(channel: c_int, vol: c_int, buf: ?*anyopaque) callconv(.C) c_int;

/// Output panned audio of the specified channel
/// `channel` - The channel number.
/// `leftvol` - The left volume.
/// `rightvol` - The right volume.
/// `buf` - Pointer to the PCM data to output.
/// Returns 0 on success, an error if less than 0.
pub extern fn sceAudioOutputPanned(channel: c_int, leftvol: c_int, rightvol: c_int, buf: ?*anyopaque) callconv(.C) c_int;

/// Output panned audio of the specified channel (blocking)
/// `channel` - The channel number.
/// `leftvol` - The left volume.
/// `rightvol` - The right volume.
/// `buf` - Pointer to the PCM data to output.
/// Returns 0 on success, an error if less than 0.
pub extern fn sceAudioOutputPannedBlocking(channel: c_int, leftvol: c_int, rightvol: c_int, buf: ?*anyopaque) callconv(.C) c_int;

/// Allocate and initialize a hardware output channel.
/// `channel` - Use a value between 0 - 7 to reserve a specific channel.
/// Pass PSP_AUDIO_NEXT_CHANNEL to get the first available channel.
/// `samplecount` - The number of samples that can be output on the channel per
/// output call.  It must be a value between ::PSP_AUDIO_SAMPLE_MIN
/// and ::PSP_AUDIO_SAMPLE_MAX, and it must be aligned to 64 bytes
/// (use the ::PSP_AUDIO_SAMPLE_ALIGN macro to align it).
/// `format` - The output format to use for the channel.  One of ::PspAudioFormats.
/// Returns The channel number on success, an error code if less than 0.
pub extern fn sceAudioChReserve(channel: c_int, samplecount: c_int, format: c_int) callconv(.C) c_int;

pub extern fn sceAudioOneshotOutput() callconv(.C) void;

/// Release a hardware output channel.
/// `channel` - The channel to release.
/// Returns 0 on success, an error if less than 0.
pub extern fn sceAudioChRelease(channel: c_int) callconv(.C) c_int;

/// Get count of unplayed samples remaining
/// `channel` - The channel number.
/// Returns Number of samples to be played, an error if less than 0.
pub extern fn sceAudioGetChannelRestLen(channel: c_int) callconv(.C) c_int;

/// Change the output sample count, after it's already been reserved
/// `channel` - The channel number.
/// `samplecount` - The number of samples to output in one output call.
/// Returns 0 on success, an error if less than 0.
pub extern fn sceAudioSetChannelDataLen(channel: c_int, samplecount: c_int) callconv(.C) c_int;

/// Change the format of a channel
/// `channel` - The channel number.
/// `format` - One of ::PspAudioFormats
/// Returns 0 on success, an error if less than 0.
pub extern fn sceAudioChangeChannelConfig(channel: c_int, format: c_int) callconv(.C) c_int;

/// Change the volume of a channel
/// `channel` - The channel number.
/// `leftvol` - The left volume.
/// `rightvol` - The right volume.
/// Returns 0 on success, an error if less than 0.
pub extern fn sceAudioChangeChannelVolume(channel: c_int, leftvol: c_int, rightvol: c_int) callconv(.C) c_int;

/// Reserve the audio output
/// `samplecount` - The number of samples to output in one output call (min 17, max 4111).
/// `freq` - The frequency. One of 48000, 44100, 32000, 24000, 22050, 16000, 12000, 11050, 8000.
/// `channels` - Number of channels. Pass 2 (stereo).
/// Returns 0 on success, an error if less than 0.
pub extern fn sceAudioSRCChReserve(samplecount: c_int, freq: c_int, channels: c_int) callconv(.C) c_int;

/// Release the audio output
/// Returns 0 on success, an error if less than 0.
pub extern fn sceAudioSRCChRelease() callconv(.C) c_int;

/// Output audio
/// `vol` - The volume.
/// `buf` - Pointer to the PCM data to output.
/// Returns 0 on success, an error if less than 0.
pub extern fn sceAudioSRCOutputBlocking(vol: c_int, buf: ?*anyopaque) callconv(.C) c_int;

/// Perform audio input (blocking)
/// `samplecount` - Number of samples.
/// `freq` - Either 44100, 22050 or 11025.
/// `buf` - Pointer to where the audio data will be stored.
/// Returns 0 on success, an error if less than 0.
pub extern fn sceAudioInputBlocking(samplecount: c_int, freq: c_int, buf: ?*anyopaque) callconv(.C) c_int;

/// Perform audio input
/// `samplecount` - Number of samples.
/// `freq` - Either 44100, 22050 or 11025.
/// `buf` - Pointer to where the audio data will be stored.
/// Returns 0 on success, an error if less than 0.
/// Perform audio input (blocking)
/// `samplecount` - Number of samples.
/// `freq` - Either 44100, 22050 or 11025.
/// `buf` - Pointer to where the audio data will be stored.
/// Returns 0 on success, an error if less than 0.
/// Init audio input (with extra arguments)
/// `params` - A pointer to a ::pspAudioInputParams struct.
/// Returns 0 on success, an error if less than 0.
/// Init audio input
/// `unknown1` - Unknown. Pass 0.
/// `gain` - Gain.
/// `unknown2` - Unknown. Pass 0.
/// Returns 0 on success, an error if less than 0.
pub extern fn sceAudioInput(samplecount: c_int, freq: c_int, buf: ?*anyopaque) callconv(.C) c_int;

/// Get the number of samples that were acquired
/// Returns Number of samples acquired, an error if less than 0.
pub extern fn sceAudioGetInputLength() callconv(.C) c_int;

/// Wait for non-blocking audio input to complete
/// Returns 0 on success, an error if less than 0.
pub extern fn sceAudioWaitInputEnd() callconv(.C) c_int;

/// Init audio input
/// `unknown1` - Unknown. Pass 0.
/// `gain` - Gain.
/// `unknown2` - Unknown. Pass 0.
/// Returns 0 on success, an error if less than 0.
pub extern fn sceAudioInputInit(unknown1: c_int, gain: c_int, unknown2: c_int) callconv(.C) c_int;

/// Poll for non-blocking audio input status
/// Returns 0 if input has completed, 1 if not completed or an error if less than 0.
pub extern fn sceAudioPollInputEnd() callconv(.C) c_int;

/// Get count of unplayed samples remaining
/// `channel` - The channel number.
/// Returns Number of samples to be played, an error if less than 0.
pub extern fn sceAudioGetChannelRestLength(channel: c_int) callconv(.C) c_int;

/// Init audio input (with extra arguments)
/// `params` - A pointer to a ::pspAudioInputParams struct.
/// Returns 0 on success, an error if less than 0.
pub extern fn sceAudioInputInitEx(params: [*c]c_int) callconv(.C) c_int;

/// Reserve the audio output and set the output sample count
/// `samplecount` - The number of samples to output in one output call (min 17, max 4111).
/// Returns 0 on success, an error if less than 0.
pub extern fn sceAudioOutput2Reserve(samplecount: c_int) callconv(.C) c_int;

/// Output audio (blocking)
/// `vol` - The volume.
/// `buf` - Pointer to the PCM data.
/// Returns 0 on success, an error if less than 0.
pub extern fn sceAudioOutput2OutputBlocking(vol: c_int, buf: ?*anyopaque) callconv(.C) c_int;

/// Release the audio output
/// Returns 0 on success, an error if less than 0.
pub extern fn sceAudioOutput2Release() callconv(.C) c_int;

/// Change the output sample count, after it's already been reserved
/// `samplecount` - The number of samples to output in one output call (min 17, max 4111).
/// Returns 0 on success, an error if less than 0.
pub extern fn sceAudioOutput2ChangeLength(samplecount: c_int) callconv(.C) c_int;

/// Get count of unplayed samples remaining
/// Returns Number of samples to be played, an error if less than 0.
pub extern fn sceAudioOutput2GetRestSample() callconv(.C) c_int;

comptime {
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
