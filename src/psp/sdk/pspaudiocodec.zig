pub extern fn sceAudiocodecCheckNeedMem(Buffer: [*c]c_ulong, Type: c_int) c_int;
pub extern fn sceAudiocodecInit(Buffer: [*c]c_ulong, Type: c_int) c_int;
pub extern fn sceAudiocodecDecode(Buffer: [*c]c_ulong, Type: c_int) c_int;
pub extern fn sceAudiocodecGetEDRAM(Buffer: [*c]c_ulong, Type: c_int) c_int;
pub extern fn sceAudiocodecReleaseEDRAM(Buffer: [*c]c_ulong) c_int;
