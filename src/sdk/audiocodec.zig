// Audio codec -- low-level codec engine
//
// Wraps:
//   c/module/sceAudiocodec.zig

const c = @import("../c/modules.zig");
const err = @import("errors/audiocodec.zig");
const check = err.check;
const Error = err.Error;

const codec = c.sceAudiocodec;

pub const Codec = enum(c_int) {
    at3plus = 0x1000,
    at3 = 0x1001,
    mp3 = 0x1002,
    aac = 0x1003,
};

pub fn check_need_mem(buffer: [*c]c_ulong, codec_type: Codec) Error!void {
    return check(codec.sceAudiocodecCheckNeedMem(buffer, @intFromEnum(codec_type)));
}

pub fn init(buffer: [*c]c_ulong, codec_type: Codec) Error!void {
    return check(codec.sceAudiocodecInit(buffer, @intFromEnum(codec_type)));
}

pub fn decode(buffer: [*c]c_ulong, codec_type: Codec) Error!void {
    return check(codec.sceAudiocodecDecode(buffer, @intFromEnum(codec_type)));
}

pub fn get_edram(buffer: [*c]c_ulong, codec_type: Codec) Error!void {
    return check(codec.sceAudiocodecGetEDRAM(buffer, @intFromEnum(codec_type)));
}

pub fn release_edram(buffer: [*c]c_ulong) Error!void {
    return check(codec.sceAudiocodecReleaseEDRAM(buffer));
}

// Undocumented stubs
pub const get_info = codec.sceAudiocodecGetInfo;
