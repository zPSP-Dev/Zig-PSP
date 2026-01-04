// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

pub extern fn sceAtracStartEntry() callconv(.c) void;

pub extern fn sceAtracEndEntry() callconv(.c) void;

pub extern fn sceAtracGetAtracID() callconv(.c) void;

/// It releases an atrac ID
/// `atracID` - the atrac ID to release
/// Returns < 0 on error
pub extern fn sceAtracReleaseAtracID(atracID: c_int) callconv(.c) c_int;

/// Creates a new Atrac ID from the specified data
/// `buf` - the buffer holding the atrac3 data, including the RIFF/WAVE header.
/// `bufsize` - the size of the buffer pointed by buf
/// Returns the new atrac ID, or < 0 on error
pub extern fn sceAtracSetData(atracID: c_int, pucBufferAddr: [*c]u8, uiBufferByte: u32) callconv(.c) c_int;

pub extern fn sceAtracSetHalfwayBuffer(atracID: c_int, pucBufferAddr: [*c]u8, uiReadByte: u32, uiBufferByte: u32) callconv(.c) c_int;

/// Creates a new Atrac ID from the specified data
/// `buf` - the buffer holding the atrac3 data, including the RIFF/WAVE header.
/// `bufsize` - the size of the buffer pointed by buf
/// Returns the new atrac ID, or < 0 on error
pub extern fn sceAtracSetDataAndGetID(buf: ?*anyopaque, bufsize: types.SceSize) callconv(.c) c_int;

pub extern fn sceAtracSetHalfwayBufferAndGetID(pucBufferAddr: [*c]u8, uiReadByte: u32, uiBufferByte: u32) callconv(.c) c_int;

/// Decode a frame of data.
/// `atracID` - the atrac ID
/// `outSamples` - pointer to a buffer that receives the decoded data of the current frame
/// `outN` - pointer to a integer that receives the number of audio samples of the decoded frame
/// `outEnd` - pointer to a integer that receives a boolean value indicating if the decoded frame is the last one
/// `outRemainFrame` - pointer to a integer that receives either -1 if all at3 data is already on memory,
/// or the remaining (not decoded yet) frames at memory if not all at3 data is on memory
/// Returns < 0 on error, otherwise 0
pub extern fn sceAtracDecodeData(atracID: c_int, outSamples: [*c]u16, outN: [*c]c_int, outEnd: [*c]c_int, outRemainFrame: [*c]c_int) callconv(.c) c_int;

/// Gets the remaining (not decoded) number of frames
/// `atracID` - the atrac ID
/// `outRemainFrame` - pointer to a integer that receives either -1 if all at3 data is already on memory,
/// or the remaining (not decoded yet) frames at memory if not all at3 data is on memory
/// Returns < 0 on error, otherwise 0
pub extern fn sceAtracGetRemainFrame(atracID: c_int, outRemainFrame: [*c]c_int) callconv(.c) c_int;

pub extern fn sceAtracGetStreamDataInfo(atracID: c_int, writePointer: [*c]u8, availableBytes: [*c]u32, readOffset: [*c]u32) callconv(.c) c_int;

/// `atracID` - the atrac ID
/// `bytesToAdd` - Number of bytes read into location given by sceAtracGetStreamDataInfo().
/// Returns < 0 on error, otherwise 0
pub extern fn sceAtracAddStreamData(atracID: c_int, bytesToAdd: c_uint) callconv(.c) c_int;

pub extern fn sceAtracGetSecondBufferInfo(atracID: c_int, puiPosition: [*c]u32, puiDataByte: [*c]u32) callconv(.c) c_int;

pub extern fn sceAtracSetSecondBuffer(atracID: c_int, pucSecondBufferAddr: [*c]u8, uiSecondBufferByte: u32) callconv(.c) c_int;

pub extern fn sceAtracGetNextDecodePosition(atracID: c_int, puiSamplePosition: [*c]u32) callconv(.c) c_int;

pub extern fn sceAtracGetSoundSample(atracID: c_int, piEndSample: [*c]c_int, piLoopStartSample: [*c]c_int, piLoopEndSample: [*c]c_int) callconv(.c) c_int;

pub extern fn sceAtracGetChannel(atracID: c_int, puiChannel: [*c]u32) callconv(.c) c_int;

/// Gets the maximum number of samples of the atrac3 stream.
/// `atracID` - the atrac ID
/// `outMax` - pointer to a integer that receives the maximum number of samples.
/// Returns < 0 on error, otherwise 0
pub extern fn sceAtracGetMaxSample(atracID: c_int, outMax: [*c]c_int) callconv(.c) c_int;

/// Gets the number of samples of the next frame to be decoded.
/// `atracID` - the atrac ID
/// `outN` - pointer to receives the number of samples of the next frame.
/// Returns < 0 on error, otherwise 0
pub extern fn sceAtracGetNextSample(atracID: c_int, outN: [*c]c_int) callconv(.c) c_int;

/// Gets the bitrate.
/// `atracID` - the atracID
/// `outBitrate` - pointer to a integer that receives the bitrate in kbps
/// Returns < 0 on error, otherwise 0
pub extern fn sceAtracGetBitrate(atracID: c_int, outBitrate: [*c]c_int) callconv(.c) c_int;

pub extern fn sceAtracGetLoopStatus(atracID: c_int, piLoopNum: [*c]c_int, puiLoopStatus: [*c]u32) callconv(.c) c_int;

/// Sets the number of loops for this atrac ID
/// `atracID` - the atracID
/// `nloops` - the number of loops to set
/// Returns < 0 on error, otherwise 0
pub extern fn sceAtracSetLoopNum(atracID: c_int, nloops: c_int) callconv(.c) c_int;

pub extern fn sceAtracGetBufferInfoForReseting(atracID: c_int, uiSample: u32, pBufferInfo: [*c]types.PspBufferInfo) callconv(.c) c_int;

pub extern fn sceAtracResetPlayPosition(atracID: c_int, uiSample: u32, uiWriteByteFirstBuf: u32, uiWriteByteSecondBuf: u32) callconv(.c) c_int;

pub extern fn sceAtracGetInternalErrorInfo(atracID: c_int, piResult: [*c]c_int) callconv(.c) c_int;

comptime {
    asm (macro.import_module_start("sceAtrac3plus", "0x00090000", "25"));
    asm (macro.import_function("sceAtrac3plus", "0xD1F59FDB", "sceAtracStartEntry"));
    asm (macro.import_function("sceAtrac3plus", "0xD5C28CC0", "sceAtracEndEntry"));
    asm (macro.import_function("sceAtrac3plus", "0x780F88D1", "sceAtracGetAtracID"));
    asm (macro.import_function("sceAtrac3plus", "0x61EB33F5", "sceAtracReleaseAtracID"));
    asm (macro.import_function("sceAtrac3plus", "0x0E2A73AB", "sceAtracSetData"));
    asm (macro.import_function("sceAtrac3plus", "0x3F6E26B5", "sceAtracSetHalfwayBuffer"));
    asm (macro.import_function("sceAtrac3plus", "0x7A20E7AF", "sceAtracSetDataAndGetID"));
    asm (macro.import_function("sceAtrac3plus", "0x0FAE370E", "sceAtracSetHalfwayBufferAndGetID"));
    asm (macro.import_function("sceAtrac3plus", "0x6A8C3CD5", "sceAtracDecodeData_stub"));
    asm (macro.generic_abi_wrapper("sceAtracDecodeData", 5));
    asm (macro.import_function("sceAtrac3plus", "0x9AE849A7", "sceAtracGetRemainFrame"));
    asm (macro.import_function("sceAtrac3plus", "0x5D268707", "sceAtracGetStreamDataInfo"));
    asm (macro.import_function("sceAtrac3plus", "0x7DB31251", "sceAtracAddStreamData"));
    asm (macro.import_function("sceAtrac3plus", "0x83E85EA0", "sceAtracGetSecondBufferInfo"));
    asm (macro.import_function("sceAtrac3plus", "0x83BF7AFD", "sceAtracSetSecondBuffer"));
    asm (macro.import_function("sceAtrac3plus", "0xE23E3A35", "sceAtracGetNextDecodePosition"));
    asm (macro.import_function("sceAtrac3plus", "0xA2BBA8BE", "sceAtracGetSoundSample"));
    asm (macro.import_function("sceAtrac3plus", "0x31668BAA", "sceAtracGetChannel"));
    asm (macro.import_function("sceAtrac3plus", "0xD6A5F2F7", "sceAtracGetMaxSample"));
    asm (macro.import_function("sceAtrac3plus", "0x36FAABFB", "sceAtracGetNextSample"));
    asm (macro.import_function("sceAtrac3plus", "0xA554A158", "sceAtracGetBitrate"));
    asm (macro.import_function("sceAtrac3plus", "0xFAA4F89B", "sceAtracGetLoopStatus"));
    asm (macro.import_function("sceAtrac3plus", "0x868120B5", "sceAtracSetLoopNum"));
    asm (macro.import_function("sceAtrac3plus", "0xCA3CA3D2", "sceAtracGetBufferInfoForReseting"));
    asm (macro.import_function("sceAtrac3plus", "0x644E5607", "sceAtracResetPlayPosition"));
    asm (macro.import_function("sceAtrac3plus", "0xE88F759B", "sceAtracGetInternalErrorInfo"));
}
