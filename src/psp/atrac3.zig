const libzpsp = @import("libzpsp");
const c = libzpsp.sceAtrac3plus;

pub const AtracError = enum(u32) {
    ParamFail = (0x80630001),
    ApiFail = (0x80630002),
    NoAtracid = (0x80630003),
    BadCodectype = (0x80630004),
    BadAtracid = (0x80630005),
    UnknownFormat = (0x80630006),
    UnmatchFormat = (0x80630007),
    BadData = (0x80630008),
    AlldataIsOnmemory = (0x80630009),
    UnsetData = (0x80630010),
    ReadsizeIsTooSmall = (0x80630011),
    NeedSecondBuffer = (0x80630012),
    ReadsizeOverBuffer = (0x80630013),
    Not4byteAlignment = (0x80630014),
    BadSample = (0x80630015),
    WritebyteFirstBuffer = (0x80630016),
    WritebyteSecondBuffer = (0x80630017),
    AddDataIsTooBig = (0x80630018),
    UnsetParam = (0x80630021),
    NoneedSecondBuffer = (0x80630022),
    NodataInBuffer = (0x80630023),
    AlldataWasDecoded = (0x80630024),
};

fn intToError(res: c_int) !void {
    if (res < 0) {
        const translated = @as(u32, @bitCast(res));
        _ = translated;
        switch (@as(AtracError, @enumFromInt(res))) {
            .ParamFail => {
                return error.ParamFail;
            },
            .ApiFail => {
                return error.ApiFail;
            },
            .NoAtracid => {
                return error.NoAtracid;
            },
            .BadCodectype => {
                return error.BadCodectype;
            },
            .BadAtracid => {
                return error.BadAtracid;
            },
            .UnknownFormat => {
                return error.UnknownFormat;
            },
            .UnmatchFormat => {
                return error.UnmatchFormat;
            },
            .BadData => {
                return error.BadData;
            },
            .AlldataIsOnmemory => {
                return error.AlldataIsOnmemory;
            },
            .UnsetData => {
                return error.UnsetData;
            },
            .ReadSizeIsTooSmall => {
                return error.ReadSizeIsTooSmall;
            },
            .NeedSecondBuffer => {
                return error.NeedSecondBuffer;
            },
            .ReadSizeOverBuffer => {
                return error.ReadSizeOverBuffer;
            },
            .Not4byteAlignment => {
                return error.Not4byteAlignment;
            },
            .BadSample => {
                return error.BadSample;
            },
            .WriteByteFirstBuffer => {
                return error.WriteByteFirstBuffer;
            },
            .WriteByteSecondBuffer => {
                return error.WriteByteSecondBuffer;
            },
            .AddDataIsTooBig => {
                return error.AddDataIsTooBig;
            },
            .UnsetParam => {
                return error.UnsetParam;
            },
            .NoNeedSecondBuffer => {
                return error.NoNeedSecondBuffer;
            },
            .NoDataInBuffer => {
                return error.NoDataInBuffer;
            },
            .AllDataWasDecoded => {
                return error.AllDataWasDecoded;
            },
        }
    }
}

//Buffer information
pub const PspBufferInfo = extern struct {
    pucWritePositionFirstBuf: [*c]u8,
    uiWritableByteFirstBuf: u32,
    uiMinWriteByteFirstBuf: u32,
    uiReadPositionFirstBuf: u32,
    pucWritePositionSecondBuf: [*c]u8,
    uiWritableByteSecondBuf: u32,
    uiMinWriteByteSecondBuf: u32,
    uiReadPositionSecondBuf: u32,
};

// Codec ID Enumeration
pub const AtracCodecType = enum(u32) {
    At3Plus = 0x1000,
    At3 = 0x1001,
};

// Gets the ID for a certain codec.
// Can return error for invalid ID.
pub fn get_atrac_id(uiCodecType: AtracCodecType) !i32 {
    const res = c.sceAtracGetAtracID(@intFromEnum(uiCodecType));
    try intToError(res);
    return res;
}

// Creates a new Atrac ID from the specified data
//
// @param buf - the buffer holding the atrac3 data, including the RIFF/WAVE header.
// @param bufsize - the size of the buffer pointed by buf
//
// @return the new atrac ID, or < 0 on error
pub fn set_data_and_get_id(buf: *anyopaque, bufSize: usize) !u32 {
    const res = c.sceAtracSetDataAndGetID(buf, bufSize);
    try intToError(res);
    return res;
}

// Decode a frame of data.
//
// @param atracID - the atrac ID
// @param outSamples - pointer to a buffer that receives the decoded data of the current frame
// @param outN - pointer to a integer that receives the number of audio samples of the decoded frame
// @param outEnd - pointer to a integer that receives a boolean value indicating if the decoded frame is the last one
// @param outRemainFrame - pointer to a integer that receives either -1 if all at3 data is already on memory,
//  or the remaining (not decoded yet) frames at memory if not all at3 data is on memory
//
//
// @return < 0 on error, otherwise 0
pub fn decode_data(atracID: u32, outSamples: []u16, outN: []i32, outEnd: []i32, outRemainFrame: []i32) !void {
    const res = c.sceAtracDecodeData(atracID, outSamples, outN, outEnd, outRemainFrame);
    try intToError(res);
}

// Gets the remaining (not decoded) number of frames
//
// @param atracID - the atrac ID
// @param outRemainFrame - pointer to a integer that receives either -1 if all at3 data is already on memory,
//  or the remaining (not decoded yet) frames at memory if not all at3 data is on memory
//
// @return < 0 on error, otherwise 0
pub fn get_remain_frame(atracID: u32, outRemainFrame: []i32) !void {
    const res = c.sceAtracGetRemainFrame(@bitCast(atracID), @ptrCast(outRemainFrame.ptr));
    try intToError(res);
}

// Gets the info of stream data
// @param atracID - the atrac ID
// @param writePointer - Pointer to where to read the atrac data
// @param availableBytes - Number of bytes available at the writePointer location
// @param readOffset - Offset where to seek into the atrac file before reading
//
// @return < 0 on error, otherwise 0
pub fn get_stream_data_info(atracID: u32, writePointer: [*c][*c]u8, availableBytes: [*c]u32, readOffset: [*c]u32) !void {
    const res = c.sceAtracGetStreamDataInfo(@bitCast(atracID), writePointer, availableBytes, readOffset);
    try intToError(res);
}

// Adds to stream data
// @param atracID - the atrac ID
// @param bytesToAdd - Number of bytes read into location given by sceAtracGetStreamDataInfo().
//
// @return < 0 on error, otherwise 0
pub fn add_stream_data(atracID: u32, bytesToAdd: u32) !void {
    const res = c.sceAtracAddStreamData(@bitCast(atracID), @bitCast(bytesToAdd));
    try intToError(res);
}

// Gets the bitrate.
//
// @param atracID - the atracID
// @param outBitrate - pointer to a integer that receives the bitrate in kbps
//
// @return < 0 on error, otherwise 0
pub fn get_bitrate(atracID: u32, outBitrate: [*c]c_int) !void {
    const res = c.sceAtracGetBitrate(@bitCast(atracID), outBitrate);
    try intToError(res);
}

// Sets the number of loops for this atrac ID
//
// @param atracID - the atracID
// @param nloops - the number of loops to set
//
// @return < 0 on error, otherwise 0
pub fn set_loop_num(atracID: u32, nloops: c_int) !void {
    const res = c.sceAtracSetLoopNum(@bitCast(atracID), @bitCast(nloops));
    try intToError(res);
}

// Releases an atrac ID
//
// @param atracID - the atrac ID to release
//
// @return < 0 on error
pub fn release_atrac_id(atracID: u32) !i32 {
    const res = c.sceAtracReleaseAtracID(@bitCast(atracID));
    try intToError(res);
    return res;
}

//Gets the number of samples of the next frame to be decoded.
//
//@param atracID - the atrac ID
//@param outN - pointer to receives the number of samples of the next frame.
//
//@return < 0 on error, otherwise 0
pub fn get_next_sample(atracID: u32, outN: [*c]c_int) !void {
    const res = c.sceAtracGetNextSample(@bitCast(atracID), outN);
    try intToError(res);
}
