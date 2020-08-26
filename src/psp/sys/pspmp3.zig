usingnamespace @import("psptypes.zig");

pub const struct_SceMp3InitArg = extern struct {
    mp3StreamStart: SceUInt32,
    unk1: SceUInt32,
    mp3StreamEnd: SceUInt32,
    unk2: SceUInt32,
    mp3Buf: ?*SceVoid,
    mp3BufSize: SceInt32,
    pcmBuf: ?*SceVoid,
    pcmBufSize: SceInt32,
};
pub const SceMp3InitArg = struct_SceMp3InitArg;
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

const macro = @import("pspmacros.zig");

comptime{
    asm(macro.import_module_start("sceMp3", "0x00090011", "19"));
    asm(macro.import_function("sceMp3", "0x07EC321A", "sceMp3ReserveMp3Handle"));
    asm(macro.import_function("sceMp3", "0x0DB149F4", "sceMp3NotifyAddStreamData"));
    asm(macro.import_function("sceMp3", "0x2A368661", "sceMp3ResetPlayPosition"));
    asm(macro.import_function("sceMp3", "0x354D27EA", "sceMp3GetSumDecodedSample"));
    asm(macro.import_function("sceMp3", "0x35750070", "sceMp3InitResource"));
    asm(macro.import_function("sceMp3", "0x3C2FA058", "sceMp3TermResource"));
    asm(macro.import_function("sceMp3", "0x3CEF484F", "sceMp3SetLoopNum"));
    asm(macro.import_function("sceMp3", "0x44E07129", "sceMp3Init"));
    asm(macro.import_function("sceMp3", "0x732B042A", "sceMp3_732B042A"));
    asm(macro.import_function("sceMp3", "0x7F696782", "sceMp3GetMp3ChannelNum"));
    asm(macro.import_function("sceMp3", "0x87677E40", "sceMp3GetBitRate"));
    asm(macro.import_function("sceMp3", "0x87C263D1", "sceMp3GetMaxOutputSample"));
    asm(macro.import_function("sceMp3", "0x8AB81558", "sceMp3_8AB81558"));
    asm(macro.import_function("sceMp3", "0x8F450998", "sceMp3GetSamplingRate"));
    asm(macro.import_function("sceMp3", "0xA703FE0F", "sceMp3GetInfoToAddStreamData"));
    asm(macro.import_function("sceMp3", "0xD021C0FB", "sceMp3Decode"));
    asm(macro.import_function("sceMp3", "0xD0A56296", "sceMp3CheckStreamDataNeeded"));
    asm(macro.import_function("sceMp3", "0xD8F54A51", "sceMp3GetLoopNum"));
    asm(macro.import_function("sceMp3", "0xF5478233", "sceMp3ReleaseMp3Handle"));
}