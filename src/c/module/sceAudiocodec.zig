// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

pub extern fn sceAudiocodecCheckNeedMem(Buffer: [*c]c_ulong, Type: c_int) callconv(.c) c_int;

pub extern fn sceAudiocodecInit(Buffer: [*c]c_ulong, Type: c_int) callconv(.c) c_int;

pub extern fn sceAudiocodecDecode(Buffer: [*c]c_ulong, Type: c_int) callconv(.c) c_int;

pub extern fn sceAudiocodecGetInfo() callconv(.c) void;

pub extern fn sceAudiocodec_6CD2A861() callconv(.c) void;

pub extern fn sceAudiocodec_59176A0F() callconv(.c) void;

pub extern fn sceAudiocodecGetEDRAM(Buffer: [*c]c_ulong, Type: c_int) callconv(.c) c_int;

pub extern fn sceAudiocodecReleaseEDRAM(Buffer: [*c]c_ulong) callconv(.c) c_int;

comptime {
    asm (macro.import_module_start("sceAudiocodec", "0x40090000", "8"));
    asm (macro.import_function("sceAudiocodec", "0x9D3F790C", "sceAudiocodecCheckNeedMem"));
    asm (macro.import_function("sceAudiocodec", "0x5B37EB1D", "sceAudiocodecInit"));
    asm (macro.import_function("sceAudiocodec", "0x70A703F8", "sceAudiocodecDecode"));
    asm (macro.import_function("sceAudiocodec", "0x8ACA11D5", "sceAudiocodecGetInfo"));
    asm (macro.import_function("sceAudiocodec", "0x6CD2A861", "sceAudiocodec_6CD2A861"));
    asm (macro.import_function("sceAudiocodec", "0x59176A0F", "sceAudiocodec_59176A0F"));
    asm (macro.import_function("sceAudiocodec", "0x3A20A200", "sceAudiocodecGetEDRAM"));
    asm (macro.import_function("sceAudiocodec", "0x29681260", "sceAudiocodecReleaseEDRAM"));
}
