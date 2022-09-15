const sce = struct {
    usingnamespace @import("psptypes.zig");
};

/// Atrac Errors
pub const AtracError = enum(u32) {
    ParamFail = (0x80630001),
    ApiFail = (0x80630002),
    NoAtracid = (0x80630003),
    BadCodectype = (0x80630004),
    BadAtracID = (0x80630005),
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

/// Function to convert return results to an error
fn intToError(res: c_int) !void {
    @setRuntimeSafety(false);
    if (res < 0) {
        switch (@intToEnum(AtracError, res)) {
            AtracError.ParamFail => {
                return error.ParamFail;
            },
            AtracError.ApiFail => {
                return error.ApiFail;
            },
            AtracError.NoAtracid => {
                return error.NoAtracid;
            },
            AtracError.BadCodectype => {
                return error.BadCodectype;
            },
            AtracError.BadAtracID => {
                return error.BadAtracID;
            },
            AtracError.UnknownFormat => {
                return error.UnknownFormat;
            },
            AtracError.UnmatchFormat => {
                return error.UnmatchFormat;
            },
            AtracError.BadData => {
                return error.BadData;
            },
            AtracError.AlldataIsOnmemory => {
                return error.AlldataIsOnmemory;
            },
            AtracError.UnsetData => {
                return error.UnsetData;
            },
            AtracError.ReadSizeIsTooSmall => {
                return error.ReadSizeIsTooSmall;
            },
            AtracError.NeedSecondBuffer => {
                return error.NeedSecondBuffer;
            },
            AtracError.ReadSizeOverBuffer => {
                return error.ReadSizeOverBuffer;
            },
            AtracError.Not4byteAlignment => {
                return error.Not4byteAlignment;
            },
            AtracError.BadSample => {
                return error.BadSample;
            },
            AtracError.WriteByteFirstBuffer => {
                return error.WriteByteFirstBuffer;
            },
            AtracError.WriteByteSecondBuffer => {
                return error.WriteByteSecondBuffer;
            },
            AtracError.AddDataIsTooBig => {
                return error.AddDataIsTooBig;
            },
            AtracError.UnsetParam => {
                return error.UnsetParam;
            },
            AtracError.NoNeedSecondBuffer => {
                return error.NoNeedSecondBuffer;
            },
            AtracError.NoDataInBuffer => {
                return error.NoDataInBuffer;
            },
            AtracError.AllDataWasDecoded => {
                return error.AllDataWasDecoded;
            },
        }
    }
}

/// Buffer information
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

/// Codec ID Enumeration
pub const AtracCodecType = enum(u32) {
    At3Plus = 0x1000,
    At3 = 0x1001,
};

extern fn sceAtracGetAtracID(uiCodecType: u32) c_int;

/// Gets the ID for a certain codec.
/// Can return error for invalid ID.
pub fn getAtracID(uiCodecType: AtracCodecType) !i32 {
    var res = sceAtracGetAtracID(@enumToInt(uiCodecType));
    try intToError(res);
    return res;
}

extern fn sceAtracSetDataAndGetID(buf: ?*anyopaque, bufsize: sce.Size) c_int;

/// Creates a new Atrac ID from the specified data
///
/// @param buf - the buffer holding the atrac3 data, including the RIFF/WAVE header.
/// @param bufsize - the size of the buffer pointed by buf
///
/// @return the new atrac ID, or < 0 on error
pub fn setDataAndGetID(buf: *anyopaque, bufSize: usize) !u32 {
    var res = sceAtracSetDataAndGetID(buf, bufSize);
    try intToError(res);
    return res;
}

extern fn sceAtracDecodeData(atracID: u32, outSamples: [*c]u16, outN: [*c]c_int, outEnd: [*c]c_int, outRemainFrame: [*c]c_int) c_int;

/// Decode a frame of data.
///
/// @param atracID - the atrac ID
/// @param outSamples - pointer to a buffer that receives the decoded data of the current frame
/// @param outN - pointer to a integer that receives the number of audio samples of the decoded frame
/// @param outEnd - pointer to a integer that receives a boolean value indicating if the decoded frame is the last one
/// @param outRemainFrame - pointer to a integer that receives either -1 if all at3 data is already on memory,
///  or the remaining (not decoded yet) frames at memory if not all at3 data is on memory
pub fn decodeData(atracID: u32, outSamples: []u16, outN: []i32, outEnd: []i32, outRemainFrame: []i32) !void {
    var res = sceAtracDecodeData(atracID, outSamples, outN, outEnd, outRemainFrame);
    try intToError(res);
}

extern fn sceAtracGetRemainFrame(atracID: u32, outRemainFrame: [*c]c_int) c_int;

/// Gets the remaining (not decoded) number of frames
///
/// @param atracID - the atrac ID
/// @param outRemainFrame - pointer to a integer that receives either -1 if all at3 data is already on memory,
///  or the remaining (not decoded yet) frames at memory if not all at3 data is on memory
pub fn getRemainFrame(atracID: u32, outRemainFrame: []i32) !void {
    var res = sceAtracGetRemainFrame(atracID, outRemainFrame);
    try intToError(res);
}

extern fn sceAtracGetStreamDataInfo(atracID: u32, writePointer: [*c][*c]u8, availableBytes: [*c]u32, readOffset: [*c]u32) c_int;

/// Gets the info of stream data
/// @param atracID - the atrac ID
/// @param writePointer - Pointer to where to read the atrac data
/// @param availableBytes - Number of bytes available at the writePointer location
/// @param readOffset - Offset where to seek into the atrac file before reading
pub fn getStreamDataInfo(atracID: u32, writePointer: *[]u8, availableBytes: *u32, readOffset: *u32) !void {
    var res = sceAtracGetStreamDataInfo(atracID, writePointer, availableBytes, readOffset);
    try intToError(res);
}

extern fn sceAtracAddStreamData(atracID: u32, bytesToAdd: c_uint) c_int;

/// Adds to stream data
/// @param atracID - the atrac ID
/// @param bytesToAdd - Number of bytes read into location given by sceAtracGetStreamDataInfo().
pub fn addStreamData(atracID: u32, bytesToAdd: u32) !void {
    var res = sceAtracAddStreamData(atracID, bytesToAdd);
    try intToError(res);
}


extern fn sceAtracGetBitrate(atracID: u32, outBitrate: [*c]c_int) c_int;

/// Gets the bitrate.
///
/// @param atracID - the atracID
/// @param outBitrate - pointer to a integer that receives the bitrate in kbps
pub fn getBitrate(atracID: u32, outBitrate: *i32) !void {
    var res = sceAtracGetBitrate(atracID, outBitrate);
    try intToError(res);
}

extern fn sceAtracSetLoopNum(atracID: u32, nloops: c_int) c_int;

/// Sets the number of loops for this atrac ID
///
/// @param atracID - the atracID
/// @param nloops - the number of loops to set
pub fn setLoopNum(atracID: u32, nloops: c_int) !void {
    var res = sceAtracSetLoopNum(atracID, nloops);
    try intToError(res);
}

extern fn sceAtracReleaseAtracID(atracID: u32) c_int;

/// Releases an atrac ID
///
/// @param atracID - the atrac ID to release
pub fn releaseAtracID(atracID: u32) !void {
    var res = sceAtracReleaseAtracID(atracID);
    try intToError(res);
}

extern fn sceAtracGetNextSample(atracID: u32, outN: [*c]c_int) c_int;

/// Gets the number of samples of the next frame to be decoded.
/// 
/// @param atracID - the atrac ID
/// @param outN - pointer to receives the number of samples of the next frame.
pub fn getNextSample(atracID: u32, outN: *i32) !void {
    var res = sceAtracGetNextSample(atracID, outN);
    try intToError(res);
}

extern fn sceAtracGetMaxSample(atracID: c_int, outMax: [*c]c_int) c_int;

/// Gets the maximum number of samples to be decoded.
/// 
/// @param atracID - the atrac ID
/// @param outN - pointer to receives the max number of samleps.
pub fn getMaxSample(atracID: u32, outMax: *i32) !void {
    var res = sceAtracGetMaxSample(atracID, outMax);
    try intToError(res);
}

extern fn sceAtracGetBufferInfoForReseting(atracID: c_int, uiSample: c_uint, pBufferInfo: [*c]PspBufferInfo) c_int;

/// Gets Buffer information
///
/// @param atracID - the atrac ID
/// @param uiSample - ???
/// @param pBufferInfo - the buffer information structure to fill
pub fn getBufferInfoForReseting(atracID: u32, uiSample: u32, pBufferInfo: *PspBufferInfo){
    var res = sceAtracGetBufferInfoForReseting(atracID, uiSample, pBufferInfo);
    try intToError(res);
}

extern fn sceAtracGetChannel(atracID: c_int, puiChannel: [*c]u32) c_int;


extern fn sceAtracGetInternalErrorInfo(atracID: c_int, piResult: [*c]c_int) c_int;
extern fn sceAtracGetLoopStatus(atracID: c_int, piLoopNum: [*c]c_int, puiLoopStatus: [*c]u32) c_int;
extern fn sceAtracGetNextDecodePosition(atracID: c_int, puiSamplePosition: [*c]u32) c_int;
extern fn sceAtracGetSecondBufferInfo(atracID: c_int, puiPosition: [*c]u32, puiDataByte: [*c]u32) c_int;
extern fn sceAtracGetSoundSample(atracID: c_int, piEndSample: [*c]c_int, piLoopStartSample: [*c]c_int, piLoopEndSample: [*c]c_int) c_int;
extern fn sceAtracResetPlayPosition(atracID: c_int, uiSample: u32, uiWriteByteFirstBuf: u32, uiWriteByteSecondBuf: u32) c_int;
extern fn sceAtracSetData(atracID: c_int, pucBufferAddr: [*c]u8, uiBufferByte: u32) c_int;
extern fn sceAtracSetHalfwayBuffer(atracID: c_int, pucBufferAddr: [*c]u8, uiReadByte: u32, uiBufferByte: u32) c_int;
extern fn sceAtracSetHalfwayBufferAndGetID(pucBufferAddr: [*c]u8, uiReadByte: u32, uiBufferByte: u32) c_int;
extern fn sceAtracSetSecondBuffer(atracID: c_int, pucSecondBufferAddr: [*c]u8, uiSecondBufferByte: u32) c_int;
