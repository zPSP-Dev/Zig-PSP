const c = @import("../c/modules.zig");

pub const SceUID = c.types.SceUID;
pub const SceMp3InitArg = c.types.SceMp3InitArg;

// sceMp3ReserveMp3Handle
//
// @param args - Pointer to SceMp3InitArg structure
//
// @return sceMp3 handle on success, < 0 on error.
pub extern fn sceMp3ReserveMp3Handle(args: *SceMp3InitArg) i32;
pub fn mp3ReserveMp3Handle(args: *SceMp3InitArg) !i32 {
    const res = sceMp3ReserveMp3Handle(args);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// sceMp3ReleaseMp3Handle
//
// @param handle - sceMp3 handle
//
// @return 0 if success, < 0 on error.
pub extern fn sceMp3ReleaseMp3Handle(handle: i32) i32;
pub fn mp3ReleaseMp3Handle(handle: i32) !void {
    const res = sceMp3ReleaseMp3Handle(handle);
    if (res < 0) {
        return error.Unexpected;
    }
}

// sceMp3InitResource
//
// @return 0 if success, < 0 on error.
pub extern fn sceMp3InitResource() i32;
pub fn mp3InitResource() !void {
    const res = sceMp3InitResource();
    if (res < 0) {
        return error.Unexpected;
    }
}

// sceMp3TermResource
//
// @return 0 if success, < 0 on error.
pub extern fn sceMp3TermResource() i32;
pub fn mp3TermResource() !void {
    const res = sceMp3TermResource();
    if (res < 0) {
        return error.Unexpected;
    }
}

// sceMp3Init
//
// @param handle - sceMp3 handle
//
// @return 0 if success, < 0 on error.
pub extern fn sceMp3Init(handle: i32) i32;
pub fn mp3Init(handle: i32) !void {
    const res = sceMp3Init(handle);
    if (res < 0) {
        return error.Unexpected;
    }
}

// sceMp3Decode
//
// @param handle - sceMp3 handle
// @param dst - Pointer to destination pcm samples buffer
//
// @return number of bytes in decoded pcm buffer, < 0 on error.
pub extern fn sceMp3Decode(handle: i32, dst: *[]i16) i32;
pub fn mp3Decode(handle: i32, dst: *[]i16) !i32 {
    const res = sceMp3Decode(handle, dst);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// sceMp3GetInfoToAddStreamData
//
// @param handle - sceMp3 handle
// @param dst - Pointer to stream data buffer
// @param towrite - Space remaining in stream data buffer
// @param srcpos - Position in source stream to start reading from
//
// @return 0 if success, < 0 on error.
pub extern fn sceMp3GetInfoToAddStreamData(handle: i32, dst: *[]u8, towrite: *i32, srcpos: *i32) i32;
pub fn mp3GetInfoToAddStreamData(handle: i32, dst: *[]u8, towrite: *i32, srcpos: *i32) !void {
    const res = sceMp3GetInfoToAddStreamData(handle, dst, towrite, srcpos);
    if (res < 0) {
        return error.Unexpected;
    }
}

// sceMp3NotifyAddStreamData
//
// @param handle - sceMp3 handle
// @param size - number of bytes added to the stream data buffer
//
// @return 0 if success, < 0 on error.
pub extern fn sceMp3NotifyAddStreamData(handle: i32, size: i32) i32;
pub fn mp3NotifyAddStreamData(handle: i32, size: i32) !void {
    const res = sceMp3NotifyAddStreamData(handle, size);
    if (res < 0) {
        return error.Unexpected;
    }
}

// sceMp3CheckStreamDataNeeded
//
// @param handle - sceMp3 handle
//
// @return 1 if more stream data is needed, < 0 on error.
pub extern fn sceMp3CheckStreamDataNeeded(handle: i32) i32;

// sceMp3SetLoopNum
//
// @param handle - sceMp3 handle
// @param loop - Number of loops
//
// @return 0 if success, < 0 on error.
pub extern fn sceMp3SetLoopNum(handle: i32, loop: i32) i32;
pub fn mp3SetLoopNum(handle: i32, loop: i32) !void {
    const res = sceMp3SetLoopNum(handle, loop);
    if (res < 0) {
        return error.Unexpected;
    }
}

// sceMp3GetLoopNum
//
// @param handle - sceMp3 handle
//
// @return Number of loops
pub extern fn sceMp3GetLoopNum(handle: i32) i32;

// sceMp3GetSumDecodedSample
//
// @param handle - sceMp3 handle
//
// @return Number of decoded samples
pub extern fn sceMp3GetSumDecodedSample(handle: i32) i32;

// sceMp3GetMaxOutputSample
//
// @param handle - sceMp3 handle
//
// @return Number of max samples to output
pub extern fn sceMp3GetMaxOutputSample(handle: i32) i32;

// sceMp3GetSamplingRate
//
// @param handle - sceMp3 handle
//
// @return Sampling rate of the mp3
pub extern fn sceMp3GetSamplingRate(handle: i32) i32;

// sceMp3GetBitRate
//
// @param handle - sceMp3 handle
//
// @return Bitrate of the mp3
pub extern fn sceMp3GetBitRate(handle: i32) i32;

// sceMp3GetMp3ChannelNum
//
// @param handle - sceMp3 handle
//
// @return Number of channels of the mp3
pub extern fn sceMp3GetMp3ChannelNum(handle: i32) i32;

// sceMp3ResetPlayPosition
//
// @param handle - sceMp3 handle
//
// @return < 0 on error
pub extern fn sceMp3ResetPlayPosition(handle: i32) i32;
pub fn mp3ResetPlayPosition(handle: i32) !void {
    const res = sceMp3ResetPlayPosition(handle);
    if (res < 0) {
        return error.Unexpected;
    }
}
