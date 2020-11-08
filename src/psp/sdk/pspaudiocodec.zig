pub const Codec = extern enum(c_int) {
    At3Plus = 0x1000,
    At3 = 0x1001,
    Mp3 = 0x1002,
    Aac = 0x1003,
};

pub extern fn sceAudiocodecCheckNeedMem(buffer: [*c]c_ulong, typec: c_int) c_int;
pub extern fn sceAudiocodecInit(buffer: [*c]c_ulong, typec: c_int) c_int;
pub extern fn sceAudiocodecDecode(buffer: [*c]c_ulong, typec: c_int) c_int;
pub extern fn sceAudiocodecGetEDRAM(buffer: [*c]c_ulong, typec: c_int) c_int;
pub extern fn sceAudiocodecReleaseEDRAM(buffer: [*c]c_ulong) c_int;
