usingnamespace @import("psptypes.zig");

const struct_unnamed_5 = extern struct {
    pucWritePositionFirstBuf: [*c]u8_1,
    uiWritableByteFirstBuf: u32_3,
    uiMinWriteByteFirstBuf: u32_3,
    uiReadPositionFirstBuf: u32_3,
    pucWritePositionSecondBuf: [*c]u8_1,
    uiWritableByteSecondBuf: u32_3,
    uiMinWriteByteSecondBuf: u32_3,
    uiReadPositionSecondBuf: u32_3,
};
pub const PspBufferInfo = struct_unnamed_5;
pub extern fn sceAtracGetAtracID(uiCodecType: u32) c_int;
pub extern fn sceAtracSetDataAndGetID(buf: ?*c_void, bufsize: SceSize) c_int;
pub extern fn sceAtracDecodeData(atracID: c_int, outSamples: [*c]u16_2, outN: [*c]c_int, outEnd: [*c]c_int, outRemainFrame: [*c]c_int) c_int;
pub extern fn sceAtracGetRemainFrame(atracID: c_int, outRemainFrame: [*c]c_int) c_int;
pub extern fn sceAtracGetStreamDataInfo(atracID: c_int, writePointer: [*c][*c]u8_1, availableBytes: [*c]u32_3, readOffset: [*c]u32_3) c_int;
pub extern fn sceAtracAddStreamData(atracID: c_int, bytesToAdd: c_uint) c_int;
pub extern fn sceAtracGetBitrate(atracID: c_int, outBitrate: [*c]c_int) c_int;
pub extern fn sceAtracSetLoopNum(atracID: c_int, nloops: c_int) c_int;
pub extern fn sceAtracReleaseAtracID(atracID: c_int) c_int;
pub extern fn sceAtracGetNextSample(atracID: c_int, outN: [*c]c_int) c_int;
pub extern fn sceAtracGetMaxSample(atracID: c_int, outMax: [*c]c_int) c_int;
pub extern fn sceAtracGetBufferInfoForReseting(atracID: c_int, uiSample: u32_3, pBufferInfo: [*c]PspBufferInfo) c_int;
pub extern fn sceAtracGetChannel(atracID: c_int, puiChannel: [*c]u32_3) c_int;
pub extern fn sceAtracGetInternalErrorInfo(atracID: c_int, piResult: [*c]c_int) c_int;
pub extern fn sceAtracGetLoopStatus(atracID: c_int, piLoopNum: [*c]c_int, puiLoopStatus: [*c]u32_3) c_int;
pub extern fn sceAtracGetNextDecodePosition(atracID: c_int, puiSamplePosition: [*c]u32_3) c_int;
pub extern fn sceAtracGetSecondBufferInfo(atracID: c_int, puiPosition: [*c]u32_3, puiDataByte: [*c]u32_3) c_int;
pub extern fn sceAtracGetSoundSample(atracID: c_int, piEndSample: [*c]c_int, piLoopStartSample: [*c]c_int, piLoopEndSample: [*c]c_int) c_int;
pub extern fn sceAtracResetPlayPosition(atracID: c_int, uiSample: u32_3, uiWriteByteFirstBuf: u32_3, uiWriteByteSecondBuf: u32_3) c_int;
pub extern fn sceAtracSetData(atracID: c_int, pucBufferAddr: [*c]u8_1, uiBufferByte: u32_3) c_int;
pub extern fn sceAtracSetHalfwayBuffer(atracID: c_int, pucBufferAddr: [*c]u8_1, uiReadByte: u32_3, uiBufferByte: u32_3) c_int;
pub extern fn sceAtracSetHalfwayBufferAndGetID(pucBufferAddr: [*c]u8_1, uiReadByte: u32_3, uiBufferByte: u32_3) c_int;
pub extern fn sceAtracSetSecondBuffer(atracID: c_int, pucSecondBufferAddr: [*c]u8_1, uiSecondBufferByte: u32_3) c_int;
