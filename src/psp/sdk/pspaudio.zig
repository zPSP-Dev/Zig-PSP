pub const PspAudioFormats = extern enum(c_int) {
    Stereo = 0,
    Mono = 16,
    _,
};
pub const PspAudioInputParams = extern struct {
    unknown1: c_int,
    gain: c_int,
    unknown2: c_int,
    unknown3: c_int,
    unknown4: c_int,
    unknown5: c_int,
};

// Allocate and initialize a hardware output channel.
//
// @param channel - Use a value between 0 - 7 to reserve a specific channel.
//                   Pass PSP_AUDIO_NEXT_CHANNEL to get the first available channel.
// @param samplecount - The number of samples that can be output on the channel per
//                      output call.  It must be a value between ::PSP_AUDIO_SAMPLE_MIN
//                      and ::PSP_AUDIO_SAMPLE_MAX, and it must be aligned to 64 bytes
//                      (use the ::PSP_AUDIO_SAMPLE_ALIGN macro to align it).
// @param format - The output format to use for the channel.  One of ::PspAudioFormats.
//
// @return The channel number on success, an error code if less than 0.
pub extern fn sceAudioChReserve(channel: c_int, samplecount: c_int, format: c_int) c_int;

// Release a hardware output channel.
//
// @param channel - The channel to release.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioChRelease(channel: c_int) c_int;

// Output audio of the specified channel
//
// @param channel - The channel number.
//
// @param vol - The volume.
//
// @param buf - Pointer to the PCM data to output.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioOutput(channel: c_int, vol: c_int, buf: ?*c_void) c_int;

// Output audio of the specified channel (blocking)
//
// @param channel - The channel number.
//
// @param vol - The volume.
//
// @param buf - Pointer to the PCM data to output.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioOutputBlocking(channel: c_int, vol: c_int, buf: ?*c_void) c_int;

// Output panned audio of the specified channel
//
// @param channel - The channel number.
//
// @param leftvol - The left volume.
//
// @param rightvol - The right volume.
//
// @param buf - Pointer to the PCM data to output.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioOutputPanned(channel: c_int, leftvol: c_int, rightvol: c_int, buf: ?*c_void) c_int;

// Output panned audio of the specified channel (blocking)
//
// @param channel - The channel number.
//
// @param leftvol - The left volume.
//
// @param rightvol - The right volume.
//
// @param buf - Pointer to the PCM data to output.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioOutputPannedBlocking(channel: c_int, leftvol: c_int, rightvol: c_int, buf: ?*c_void) c_int;

// Get count of unplayed samples remaining
//
// @param channel - The channel number.
//
// @return Number of samples to be played, an error if less than 0.
pub extern fn sceAudioGetChannelRestLen(channel: c_int) c_int;

// Get count of unplayed samples remaining
//
// @param channel - The channel number.
//
// @return Number of samples to be played, an error if less than 0.
pub extern fn sceAudioGetChannelRestLength(channel: c_int) c_int;

// Change the output sample count, after it's already been reserved
//
// @param channel - The channel number.
// @param samplecount - The number of samples to output in one output call.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioSetChannelDataLen(channel: c_int, samplecount: c_int) c_int;

// Change the format of a channel
//
// @param channel - The channel number.
//
// @param format - One of ::PspAudioFormats
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioChangeChannelConfig(channel: c_int, format: c_int) c_int;

// Change the volume of a channel
//
// @param channel - The channel number.
//
// @param leftvol - The left volume.
//
// @param rightvol - The right volume.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioChangeChannelVolume(channel: c_int, leftvol: c_int, rightvol: c_int) c_int;

// Reserve the audio output and set the output sample count
//
// @param samplecount - The number of samples to output in one output call (min 17, max 4111).
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioOutput2Reserve(samplecount: c_int) c_int;

// Release the audio output
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioOutput2Release() c_int;

// Change the output sample count, after it's already been reserved
//
// @param samplecount - The number of samples to output in one output call (min 17, max 4111).
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioOutput2ChangeLength(samplecount: c_int) c_int;

// Output audio (blocking)
//
// @param vol - The volume.
//
// @param buf - Pointer to the PCM data.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioOutput2OutputBlocking(vol: c_int, buf: ?*c_void) c_int;

// Get count of unplayed samples remaining
//
// @return Number of samples to be played, an error if less than 0.
pub extern fn sceAudioOutput2GetRestSample() c_int;

// Reserve the audio output
//
// @param samplecount - The number of samples to output in one output call (min 17, max 4111).
//
// @param freq - The frequency. One of 48000, 44100, 32000, 24000, 22050, 16000, 12000, 11050, 8000.
//
// @param channels - Number of channels. Pass 2 (stereo).
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioSRCChReserve(samplecount: c_int, freq: c_int, channels: c_int) c_int;

// Release the audio output
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioSRCChRelease() c_int;

// Output audio
//
// @param vol - The volume.
//
// @param buf - Pointer to the PCM data to output.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioSRCOutputBlocking(vol: c_int, buf: ?*c_void) c_int;

// Init audio input
//
// @param unknown1 - Unknown. Pass 0.
//
// @param gain - Gain.
//
// @param unknown2 - Unknown. Pass 0.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioInputInit(unknown1: c_int, gain: c_int, unknown2: c_int) c_int;

// Init audio input (with extra arguments)
//
// @param params - A pointer to a ::pspAudioInputParams struct.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioInputInitEx(params: [*]PspAudioInputParams) c_int;

// Perform audio input (blocking)
//
// @param samplecount - Number of samples.
//
// @param freq - Either 44100, 22050 or 11025.
//
// @param buf - Pointer to where the audio data will be stored.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioInputBlocking(samplecount: c_int, freq: c_int, buf: ?*c_void) c_int;

// Perform audio input
//
// @param samplecount - Number of samples.
//
// @param freq - Either 44100, 22050 or 11025.
//
// @param buf - Pointer to where the audio data will be stored.
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioInput(samplecount: c_int, freq: c_int, buf: ?*c_void) c_int;

// Get the number of samples that were acquired
//
// @return Number of samples acquired, an error if less than 0.
pub extern fn sceAudioGetInputLength() c_int;

// Wait for non-blocking audio input to complete
//
// @return 0 on success, an error if less than 0.
pub extern fn sceAudioWaitInputEnd() c_int;

// Poll for non-blocking audio input status
//
// @return 0 if input has completed, 1 if not completed or an error if less than 0.
pub extern fn sceAudioPollInputEnd() c_int;
