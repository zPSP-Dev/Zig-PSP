usingnamespace @import("psptypes.zig");

const struct_unnamed_5 = extern struct {
    pucWritePositionFirstBuf: [*c]u8,
    uiWritableByteFirstBuf: u32,
    uiMinWriteByteFirstBuf: u32,
    uiReadPositionFirstBuf: u32,
    pucWritePositionSecondBuf: [*c]u8,
    uiWritableByteSecondBuf: u32,
    uiMinWriteByteSecondBuf: u32,
    uiReadPositionSecondBuf: u32,
};
pub const PspBufferInfo = struct_unnamed_5;
pub extern fn sceAtracGetAtracID(uiCodecType: u32) c_int;
pub extern fn sceAtracSetDataAndGetID(buf: ?*c_void, bufsize: SceSize) c_int;
pub extern fn sceAtracDecodeData(atracID: c_int, outSamples: [*c]u16, outN: [*c]c_int, outEnd: [*c]c_int, outRemainFrame: [*c]c_int) c_int;
pub extern fn sceAtracGetRemainFrame(atracID: c_int, outRemainFrame: [*c]c_int) c_int;
pub extern fn sceAtracGetStreamDataInfo(atracID: c_int, writePointer: [*c][*c]u8, availableBytes: [*c]u32, readOffset: [*c]u32) c_int;
pub extern fn sceAtracAddStreamData(atracID: c_int, bytesToAdd: c_uint) c_int;
pub extern fn sceAtracGetBitrate(atracID: c_int, outBitrate: [*c]c_int) c_int;
pub extern fn sceAtracSetLoopNum(atracID: c_int, nloops: c_int) c_int;
pub extern fn sceAtracReleaseAtracID(atracID: c_int) c_int;
pub extern fn sceAtracGetNextSample(atracID: c_int, outN: [*c]c_int) c_int;
pub extern fn sceAtracGetMaxSample(atracID: c_int, outMax: [*c]c_int) c_int;
pub extern fn sceAtracGetBufferInfoForReseting(atracID: c_int, uiSample: u32, pBufferInfo: [*c]PspBufferInfo) c_int;
pub extern fn sceAtracGetChannel(atracID: c_int, puiChannel: [*c]u32) c_int;
pub extern fn sceAtracGetInternalErrorInfo(atracID: c_int, piResult: [*c]c_int) c_int;
pub extern fn sceAtracGetLoopStatus(atracID: c_int, piLoopNum: [*c]c_int, puiLoopStatus: [*c]u32) c_int;
pub extern fn sceAtracGetNextDecodePosition(atracID: c_int, puiSamplePosition: [*c]u32) c_int;
pub extern fn sceAtracGetSecondBufferInfo(atracID: c_int, puiPosition: [*c]u32, puiDataByte: [*c]u32) c_int;
pub extern fn sceAtracGetSoundSample(atracID: c_int, piEndSample: [*c]c_int, piLoopStartSample: [*c]c_int, piLoopEndSample: [*c]c_int) c_int;
pub extern fn sceAtracResetPlayPosition(atracID: c_int, uiSample: u32, uiWriteByteFirstBuf: u32, uiWriteByteSecondBuf: u32) c_int;
pub extern fn sceAtracSetData(atracID: c_int, pucBufferAddr: [*c]u8, uiBufferByte: u32) c_int;
pub extern fn sceAtracSetHalfwayBuffer(atracID: c_int, pucBufferAddr: [*c]u8, uiReadByte: u32, uiBufferByte: u32) c_int;
pub extern fn sceAtracSetHalfwayBufferAndGetID(pucBufferAddr: [*c]u8, uiReadByte: u32, uiBufferByte: u32) c_int;
pub extern fn sceAtracSetSecondBuffer(atracID: c_int, pucSecondBufferAddr: [*c]u8, uiSecondBufferByte: u32) c_int;

const macro = @import("pspmacros.zig");

comptime{
    asm(macro.import_module_start("sceAtrac3plus", "0x00090000", "25"));
    asm(macro.import_function("sceAtrac3plus", "0xD1F59FDB", "sceAtracStartEntry"));
    asm(macro.import_function("sceAtrac3plus", "0xD5C28CC0", "sceAtracEndEntry"));
    asm(macro.import_function("sceAtrac3plus", "0x780F88D1", "sceAtracGetAtracID"));
    asm(macro.import_function("sceAtrac3plus", "0x61EB33F5", "sceAtracReleaseAtracID"));
    asm(macro.import_function("sceAtrac3plus", "0x0E2A73AB", "sceAtracSetData"));
    asm(macro.import_function("sceAtrac3plus", "0x3F6E26B5", "sceAtracSetHalfwayBuffer"));
    asm(macro.import_function("sceAtrac3plus", "0x7A20E7AF", "sceAtracSetDataAndGetID"));
    asm(macro.import_function("sceAtrac3plus", "0x0FAE370E", "sceAtracSetHalfwayBufferAndGetID"));
    asm(macro.import_function("sceAtrac3plus", "0x6A8C3CD5", "sceAtracDecodeData_stub"));
    asm(macro.import_function("sceAtrac3plus", "0x9AE849A7", "sceAtracGetRemainFrame"));
    asm(macro.import_function("sceAtrac3plus", "0x5D268707", "sceAtracGetStreamDataInfo"));
    asm(macro.import_function("sceAtrac3plus", "0x7DB31251", "sceAtracAddStreamData"));
    asm(macro.import_function("sceAtrac3plus", "0x83E85EA0", "sceAtracGetSecondBufferInfo"));
    asm(macro.import_function("sceAtrac3plus", "0x83BF7AFD", "sceAtracSetSecondBuffer"));
    asm(macro.import_function("sceAtrac3plus", "0xE23E3A35", "sceAtracGetNextDecodePosition"));
    asm(macro.import_function("sceAtrac3plus", "0xA2BBA8BE", "sceAtracGetSoundSample"));
    asm(macro.import_function("sceAtrac3plus", "0x31668BAA", "sceAtracGetChannel"));
    asm(macro.import_function("sceAtrac3plus", "0xD6A5F2F7", "sceAtracGetMaxSample"));
    asm(macro.import_function("sceAtrac3plus", "0x36FAABFB", "sceAtracGetNextSample"));
    asm(macro.import_function("sceAtrac3plus", "0xA554A158", "sceAtracGetBitrate"));
    asm(macro.import_function("sceAtrac3plus", "0xFAA4F89B", "sceAtracGetLoopStatus"));
    asm(macro.import_function("sceAtrac3plus", "0x868120B5", "sceAtracSetLoopNum"));
    asm(macro.import_function("sceAtrac3plus", "0xCA3CA3D2", "sceAtracGetBufferInfoForReseting"));
    asm(macro.import_function("sceAtrac3plus", "0x644E5607", "sceAtracResetPlayPosition"));
    asm(macro.import_function("sceAtrac3plus", "0xE88F759B", "sceAtracGetInternalErrorInfo"));

    asm(macro.generic_abi_wrapper("sceAtracDecodeData", 5));
}