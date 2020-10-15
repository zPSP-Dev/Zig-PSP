usingnamespace @import("psptypes.zig");

pub const SceMp3InitArg = extern struct {
    mp3StreamStart: SceUInt32,
    unk1: SceUInt32,
    mp3StreamEnd: SceUInt32,
    unk2: SceUInt32,
    mp3Buf: ?*SceVoid,
    mp3BufSize: SceInt32,
    pcmBuf: ?*SceVoid,
    pcmBufSize: SceInt32,
};

pub extern fn sceMp3ReserveMp3Handle(args: [*c]SceMp3InitArg) SceInt32;
pub extern fn sceMp3ReleaseMp3Handle(handle: SceInt32) SceInt32;
pub extern fn sceMp3InitResource(...) SceInt32;
pub extern fn sceMp3TermResource(...) SceInt32;
pub extern fn sceMp3Init(handle: SceInt32) SceInt32;
pub extern fn sceMp3Decode(handle: SceInt32, dst: [*c][*c]SceShort16) SceInt32;
pub extern fn sceMp3GetInfoToAddStreamData(handle: SceInt32, dst: [*c][*c]SceUChar8, towrite: [*c]SceInt32, srcpos: [*c]SceInt32) SceInt32;
pub extern fn sceMp3NotifyAddStreamData(handle: SceInt32, size: SceInt32) SceInt32;
pub extern fn sceMp3CheckStreamDataNeeded(handle: SceInt32) SceInt32;
pub extern fn sceMp3SetLoopNum(handle: SceInt32, loop: SceInt32) SceInt32;
pub extern fn sceMp3GetLoopNum(handle: SceInt32) SceInt32;
pub extern fn sceMp3GetSumDecodedSample(handle: SceInt32) SceInt32;
pub extern fn sceMp3GetMaxOutputSample(handle: SceInt32) SceInt32;
pub extern fn sceMp3GetSamplingRate(handle: SceInt32) SceInt32;
pub extern fn sceMp3GetBitRate(handle: SceInt32) SceInt32;
pub extern fn sceMp3GetMp3ChannelNum(handle: SceInt32) SceInt32;
pub extern fn sceMp3ResetPlayPosition(handle: SceInt32) SceInt32;
