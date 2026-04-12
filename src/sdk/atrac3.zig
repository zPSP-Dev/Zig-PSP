// ATRAC3plus audio codec
//
// Wraps:
//   c/module/sceAtrac3plus.zig

const c = @import("../c/modules.zig");
const err = @import("errors/atrac3.zig");
const check = err.check;
const checkPositive = err.checkPositive;
const Error = err.Error;

const atrac = c.sceAtrac3plus;

pub const PspBufferInfo = c.types.PspBufferInfo;

// -- Lifecycle ---------------------------------------------------------

pub const start_entry = atrac.sceAtracStartEntry;
pub const end_entry = atrac.sceAtracEndEntry;

pub fn release_atrac_id(atrac_id: i32) Error!void {
    return check(atrac.sceAtracReleaseAtracID(@as(c_int, atrac_id)));
}

// -- Data setup --------------------------------------------------------

pub fn set_data(atrac_id: i32, buf: [*]u8, buf_size: u32) Error!void {
    return check(atrac.sceAtracSetData(@as(c_int, atrac_id), buf, buf_size));
}

pub fn set_halfway_buffer(atrac_id: i32, buf: [*]u8, read_size: u32, buf_size: u32) Error!void {
    return check(atrac.sceAtracSetHalfwayBuffer(@as(c_int, atrac_id), buf, read_size, buf_size));
}

/// Creates a new Atrac ID from the specified data.
pub fn set_data_and_get_id(buf: ?*anyopaque, bufsize: usize) Error!i32 {
    const ret = atrac.sceAtracSetDataAndGetID(buf, bufsize);
    return checkPositive(i32, ret);
}

pub fn set_halfway_buffer_and_get_id(buf: [*]u8, read_size: u32, buf_size: u32) Error!i32 {
    const ret = atrac.sceAtracSetHalfwayBufferAndGetID(buf, read_size, buf_size);
    return checkPositive(i32, ret);
}

// -- Decoding ----------------------------------------------------------

pub fn decode_data(atrac_id: i32, out_samples: [*c]u16, out_n: *i32, out_end: *i32, out_remain_frame: *i32) Error!void {
    return check(atrac.sceAtracDecodeData(@as(c_int, atrac_id), out_samples, @ptrCast(out_n), @ptrCast(out_end), @ptrCast(out_remain_frame)));
}

pub fn get_remain_frame(atrac_id: i32, out_remain_frame: *i32) Error!void {
    return check(atrac.sceAtracGetRemainFrame(@as(c_int, atrac_id), @ptrCast(out_remain_frame)));
}

pub fn get_next_sample(atrac_id: i32, out_n: *i32) Error!void {
    return check(atrac.sceAtracGetNextSample(@as(c_int, atrac_id), @ptrCast(out_n)));
}

pub fn get_max_sample(atrac_id: i32, out_max: *i32) Error!void {
    return check(atrac.sceAtracGetMaxSample(@as(c_int, atrac_id), @ptrCast(out_max)));
}

pub fn get_next_decode_position(atrac_id: i32, out_pos: *u32) Error!void {
    return check(atrac.sceAtracGetNextDecodePosition(@as(c_int, atrac_id), out_pos));
}

// -- Stream data -------------------------------------------------------

pub fn get_stream_data_info(atrac_id: i32, write_pointer: [*c]u8, available_bytes: *u32, read_offset: *u32) Error!void {
    return check(atrac.sceAtracGetStreamDataInfo(@as(c_int, atrac_id), write_pointer, available_bytes, read_offset));
}

pub fn add_stream_data(atrac_id: i32, bytes_to_add: u32) Error!void {
    return check(atrac.sceAtracAddStreamData(@as(c_int, atrac_id), bytes_to_add));
}

// -- Second buffer -----------------------------------------------------

pub fn get_second_buffer_info(atrac_id: i32, position: *u32, data_byte: *u32) Error!void {
    return check(atrac.sceAtracGetSecondBufferInfo(@as(c_int, atrac_id), position, data_byte));
}

pub fn set_second_buffer(atrac_id: i32, buf: [*]u8, buf_size: u32) Error!void {
    return check(atrac.sceAtracSetSecondBuffer(@as(c_int, atrac_id), buf, buf_size));
}

// -- Info --------------------------------------------------------------

pub fn get_bitrate(atrac_id: i32, out_bitrate: *i32) Error!void {
    return check(atrac.sceAtracGetBitrate(@as(c_int, atrac_id), @ptrCast(out_bitrate)));
}

pub fn get_channel(atrac_id: i32, out_channel: *u32) Error!void {
    return check(atrac.sceAtracGetChannel(@as(c_int, atrac_id), out_channel));
}

pub fn get_sound_sample(atrac_id: i32, end_sample: *i32, loop_start: *i32, loop_end: *i32) Error!void {
    return check(atrac.sceAtracGetSoundSample(@as(c_int, atrac_id), @ptrCast(end_sample), @ptrCast(loop_start), @ptrCast(loop_end)));
}

// -- Loop --------------------------------------------------------------

pub fn set_loop_num(atrac_id: i32, nloops: i32) Error!void {
    return check(atrac.sceAtracSetLoopNum(@as(c_int, atrac_id), @as(c_int, nloops)));
}

pub fn get_loop_status(atrac_id: i32, loop_num: *i32, loop_status: *u32) Error!void {
    return check(atrac.sceAtracGetLoopStatus(@as(c_int, atrac_id), @ptrCast(loop_num), loop_status));
}

// -- Reset / seek ------------------------------------------------------

pub fn get_buffer_info_for_reseting(atrac_id: i32, sample: u32, buf_info: *PspBufferInfo) Error!void {
    return check(atrac.sceAtracGetBufferInfoForReseting(@as(c_int, atrac_id), sample, buf_info));
}

pub fn reset_play_position(atrac_id: i32, sample: u32, write_byte_first: u32, write_byte_second: u32) Error!void {
    return check(atrac.sceAtracResetPlayPosition(@as(c_int, atrac_id), sample, write_byte_first, write_byte_second));
}

// -- Error info --------------------------------------------------------

pub fn get_internal_error_info(atrac_id: i32, result: *i32) Error!void {
    return check(atrac.sceAtracGetInternalErrorInfo(@as(c_int, atrac_id), @ptrCast(result)));
}
