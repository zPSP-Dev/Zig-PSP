// MP3 audio codec
//
// Wraps:
//   c/module/sceMp3.zig

const c = @import("../c/modules.zig");
const err = @import("errors/mp3.zig");
const check = err.check;
const checkPositive = err.checkPositive;
const Error = err.Error;

const mp3 = c.sceMp3;

pub const InitArg = c.types.SceMp3InitArg;

// -- Resource lifecycle ------------------------------------------------

pub fn init_resource() Error!void {
    return check(mp3.sceMp3InitResource());
}

pub fn term_resource() Error!void {
    return check(mp3.sceMp3TermResource());
}

// -- Handle lifecycle --------------------------------------------------

pub fn reserve_handle(args: *InitArg) Error!i32 {
    return checkPositive(i32, mp3.sceMp3ReserveMp3Handle(args));
}

pub fn release_handle(handle: i32) Error!void {
    return check(mp3.sceMp3ReleaseMp3Handle(handle));
}

pub fn init(handle: i32) Error!void {
    return check(mp3.sceMp3Init(handle));
}

// -- Decoding ----------------------------------------------------------

pub fn decode(handle: i32, dst: [*c]i16) Error!i32 {
    return checkPositive(i32, mp3.sceMp3Decode(handle, dst));
}

pub fn check_stream_data_needed(handle: i32) bool {
    return mp3.sceMp3CheckStreamDataNeeded(handle) > 0;
}

// -- Stream data -------------------------------------------------------

pub fn get_info_to_add_stream_data(handle: i32, dst: [*c]u8, towrite: *i32, srcpos: *i32) Error!void {
    return check(mp3.sceMp3GetInfoToAddStreamData(handle, dst, towrite, srcpos));
}

pub fn notify_add_stream_data(handle: i32, size: i32) Error!void {
    return check(mp3.sceMp3NotifyAddStreamData(handle, size));
}

// -- Playback control --------------------------------------------------

pub fn reset_play_position(handle: i32) Error!void {
    return check(mp3.sceMp3ResetPlayPosition(handle));
}

pub fn reset_play_position_by_frame(handle: i32, frame: u32) Error!void {
    return check(mp3.sceMp3ResetPlayPositionByFrame(handle, frame));
}

pub fn set_loop_num(handle: i32, loop: i32) Error!void {
    return check(mp3.sceMp3SetLoopNum(handle, loop));
}

// -- Info queries ------------------------------------------------------

pub fn get_loop_num(handle: i32) i32 {
    return mp3.sceMp3GetLoopNum(handle);
}

pub fn get_sum_decoded_sample(handle: i32) i32 {
    return mp3.sceMp3GetSumDecodedSample(handle);
}

pub fn get_max_output_sample(handle: i32) i32 {
    return mp3.sceMp3GetMaxOutputSample(handle);
}

pub fn get_sampling_rate(handle: i32) i32 {
    return mp3.sceMp3GetSamplingRate(handle);
}

pub fn get_bit_rate(handle: i32) i32 {
    return mp3.sceMp3GetBitRate(handle);
}

pub fn get_channel_num(handle: i32) i32 {
    return mp3.sceMp3GetMp3ChannelNum(handle);
}

pub fn get_mpeg_version(handle: i32) i32 {
    return mp3.sceMp3GetMPEGVersion(handle);
}

pub fn get_frame_num(handle: i32) i32 {
    return mp3.sceMp3GetFrameNum(handle);
}

// -- Low-level ---------------------------------------------------------

pub fn low_level_init(handle: i32, src: [*c]u8) Error!void {
    return check(mp3.sceMp3LowLevelInit(handle, src));
}

pub fn low_level_decode(handle: i32, mp3src: [*c]u8, mp3srcused: *u32, pcmdst: [*c]i16, pcmdstoutsz: *u32) Error!void {
    return check(mp3.sceMp3LowLevelDecode(handle, mp3src, mp3srcused, pcmdst, pcmdstoutsz));
}
