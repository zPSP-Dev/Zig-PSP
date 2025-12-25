// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// sceMp3ReserveMp3Handle
/// `args` - Pointer to SceMp3InitArg structure
/// Returns sceMp3 handle on success, < 0 on error.
pub extern fn sceMp3ReserveMp3Handle(args: [*c]c_int) callconv(.C) types.SceInt32;

/// sceMp3NotifyAddStreamData
/// `handle` - sceMp3 handle
/// `size` - number of bytes added to the stream data buffer
/// Returns 0 if success, < 0 on error.
pub extern fn sceMp3NotifyAddStreamData(handle: types.SceInt32, size: types.SceInt32) callconv(.C) types.SceInt32;

/// sceMp3ResetPlayPosition
/// `handle` - sceMp3 handle
/// Returns 0 if success, < 0 on error.
pub extern fn sceMp3ResetPlayPosition(handle: types.SceInt32) callconv(.C) types.SceInt32;

/// sceMp3GetSumDecodedSample
/// `handle` - sceMp3 handle
/// Returns Number of decoded samples, < 0 on error.
pub extern fn sceMp3GetSumDecodedSample(handle: types.SceInt32) callconv(.C) types.SceInt32;

/// sceMp3InitResource
/// Returns 0 if success, < 0 on error.
pub extern fn sceMp3InitResource() callconv(.C) types.SceInt32;

/// sceMp3TermResource
/// Returns 0 if success, < 0 on error.
pub extern fn sceMp3TermResource() callconv(.C) types.SceInt32;

/// sceMp3SetLoopNum
/// `handle` - sceMp3 handle
/// `loop` - Number of loops
/// Returns 0 if success, < 0 on error.
pub extern fn sceMp3SetLoopNum(handle: types.SceInt32, loop: types.SceInt32) callconv(.C) types.SceInt32;

/// sceMp3Init
/// `handle` - sceMp3 handle
/// Returns 0 if success, < 0 on error.
/// sceMp3InitResource
/// Returns 0 if success, < 0 on error.
pub extern fn sceMp3Init(handle: types.SceInt32) callconv(.C) types.SceInt32;

pub extern fn sceMp3_732B042A() callconv(.C) void;

/// sceMp3GetMp3ChannelNum
/// `handle` - sceMp3 handle
/// Returns Number of channels of the mp3, < 0 on error.
pub extern fn sceMp3GetMp3ChannelNum(handle: types.SceInt32) callconv(.C) types.SceInt32;

/// sceMp3GetBitRate
/// `handle` - sceMp3 handle
/// Returns Bitrate of the mp3, < 0 on error.
pub extern fn sceMp3GetBitRate(handle: types.SceInt32) callconv(.C) types.SceInt32;

/// sceMp3GetMaxOutputSample
/// `handle` - sceMp3 handle
/// Returns Number of max samples to output, < 0 on error.
pub extern fn sceMp3GetMaxOutputSample(handle: types.SceInt32) callconv(.C) types.SceInt32;

pub extern fn sceMp3_8AB81558() callconv(.C) void;

/// sceMp3GetSamplingRate
/// `handle` - sceMp3 handle
/// Returns Sampling rate of the mp3, < 0 on error.
pub extern fn sceMp3GetSamplingRate(handle: types.SceInt32) callconv(.C) types.SceInt32;

/// sceMp3GetInfoToAddStreamData
/// `handle` - sceMp3 handle
/// `dst` - Pointer to stream data buffer
/// `towrite` - Space remaining in stream data buffer
/// `srcpos` - Position in source stream to start reading from
/// Returns 0 if success, < 0 on error.
pub extern fn sceMp3GetInfoToAddStreamData(handle: types.SceInt32, dst: [*c]types.SceUChar8, towrite: [*c]types.SceInt32, srcpos: [*c]types.SceInt32) callconv(.C) types.SceInt32;

/// sceMp3Decode
/// `handle` - sceMp3 handle
/// `dst` - Pointer to destination pcm samples buffer
/// Returns number of bytes in decoded pcm buffer, < 0 on error.
pub extern fn sceMp3Decode(handle: types.SceInt32, dst: [*c]types.SceShort16) callconv(.C) types.SceInt32;

/// sceMp3CheckStreamDataNeeded
/// `handle` - sceMp3 handle
/// Returns 1 if more stream data is needed, < 0 on error.
pub extern fn sceMp3CheckStreamDataNeeded(handle: types.SceInt32) callconv(.C) types.SceInt32;

/// sceMp3GetLoopNum
/// `handle` - sceMp3 handle
/// Returns Number of loops, < 0 on error.
pub extern fn sceMp3GetLoopNum(handle: types.SceInt32) callconv(.C) types.SceInt32;

/// sceMp3ReleaseMp3Handle
/// `handle` - sceMp3 handle
/// Returns 0 if success, < 0 on error.
pub extern fn sceMp3ReleaseMp3Handle(handle: types.SceInt32) callconv(.C) types.SceInt32;

/// sceMp3GetMPEGVersion
/// `handle` - sceMp3 handle
/// Returns MPEG Version, < 0 on error
pub extern fn sceMp3GetMPEGVersion(handle: types.SceInt32) callconv(.C) types.SceInt32;

/// sceMp3GetFrameNum
/// `handle` - sceMp3 handle
/// Returns Number of audio frames, < 0 on error
pub extern fn sceMp3GetFrameNum(handle: types.SceInt32) callconv(.C) types.SceInt32;

/// sceMp3ResetPlayPositionByFrame
/// `handle` - sceMp3 handle
/// `frame` - frame
/// Returns 0 if success, < 0 on error.
pub extern fn sceMp3ResetPlayPositionByFrame(handle: types.SceInt32, frame: types.SceUInt32) callconv(.C) types.SceInt32;

/// sceMp3LowLevelInit
/// `handle` - sceMp3 handle
/// `src` - Pointer to a buffer to contain raw mp3 stream data
/// Returns 0 if success, < 0 on error.
pub extern fn sceMp3LowLevelInit(handle: types.SceInt32, src: [*c]types.SceUChar8) callconv(.C) types.SceInt32;

/// sceMp3LowLevelDecode
/// `handle` - sceMp3 handle
/// `mp3src` - Pointer to a buffer to contain raw mp3 stream data
/// `mp3srcused` - mp3 data size consumed by decoding
/// `pcmdst` - Pointer to destination pcm samples buffer
/// `pcmdstoutsz` - Size of pcm data output by decoding
/// Returns 0 if success, < 0 on error.
pub extern fn sceMp3LowLevelDecode(handle: types.SceInt32, mp3src: [*c]types.SceUChar8, mp3srcused: [*c]types.SceUInt32, pcmdst: [*c]types.SceShort16, pcmdstoutsz: [*c]types.SceUInt32) callconv(.C) types.SceInt32;

comptime {
    asm (macro.import_module_start("sceMp3", "0x00090011", "24"));
    asm (macro.import_function("sceMp3", "0x07EC321A", "sceMp3ReserveMp3Handle"));
    asm (macro.import_function("sceMp3", "0x0DB149F4", "sceMp3NotifyAddStreamData"));
    asm (macro.import_function("sceMp3", "0x2A368661", "sceMp3ResetPlayPosition"));
    asm (macro.import_function("sceMp3", "0x354D27EA", "sceMp3GetSumDecodedSample"));
    asm (macro.import_function("sceMp3", "0x35750070", "sceMp3InitResource"));
    asm (macro.import_function("sceMp3", "0x3C2FA058", "sceMp3TermResource"));
    asm (macro.import_function("sceMp3", "0x3CEF484F", "sceMp3SetLoopNum"));
    asm (macro.import_function("sceMp3", "0x44E07129", "sceMp3Init"));
    asm (macro.import_function("sceMp3", "0x732B042A", "sceMp3_732B042A"));
    asm (macro.import_function("sceMp3", "0x7F696782", "sceMp3GetMp3ChannelNum"));
    asm (macro.import_function("sceMp3", "0x87677E40", "sceMp3GetBitRate"));
    asm (macro.import_function("sceMp3", "0x87C263D1", "sceMp3GetMaxOutputSample"));
    asm (macro.import_function("sceMp3", "0x8AB81558", "sceMp3_8AB81558"));
    asm (macro.import_function("sceMp3", "0x8F450998", "sceMp3GetSamplingRate"));
    asm (macro.import_function("sceMp3", "0xA703FE0F", "sceMp3GetInfoToAddStreamData"));
    asm (macro.import_function("sceMp3", "0xD021C0FB", "sceMp3Decode"));
    asm (macro.import_function("sceMp3", "0xD0A56296", "sceMp3CheckStreamDataNeeded"));
    asm (macro.import_function("sceMp3", "0xD8F54A51", "sceMp3GetLoopNum"));
    asm (macro.import_function("sceMp3", "0xF5478233", "sceMp3ReleaseMp3Handle"));
    asm (macro.import_function("sceMp3", "0xAE6D2027", "sceMp3GetMPEGVersion"));
    asm (macro.import_function("sceMp3", "0x3548AEC8", "sceMp3GetFrameNum"));
    asm (macro.import_function("sceMp3", "0x0840E808", "sceMp3ResetPlayPositionByFrame"));
    asm (macro.import_function("sceMp3", "0x1B839B83", "sceMp3LowLevelInit"));
    asm (macro.import_function("sceMp3", "0xE3EE2C81", "sceMp3LowLevelDecode_stub"));
    asm (macro.generic_abi_wrapper("sceMp3LowLevelDecode", 5));
}
