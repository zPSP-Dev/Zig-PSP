pub extern fn sceVideocodecOpen(Buffer: [*c]c_ulong, Type: c_int) c_int;
pub extern fn sceVideocodecGetEDRAM(Buffer: [*c]c_ulong, Type: c_int) c_int;
pub extern fn sceVideocodecInit(Buffer: [*c]c_ulong, Type: c_int) c_int;
pub extern fn sceVideocodecDecode(Buffer: [*c]c_ulong, Type: c_int) c_int;
pub extern fn sceVideocodecReleaseEDRAM(Buffer: [*c]c_ulong) c_int;

const macro = @import("pspmacros.zig");

comptime{
    asm(macro.import_module_start("sceVideocodec", "0x40010011", "5"));
    asm(macro.import_function("sceVideocodec","0x17099F0A", "sceVideocodecInit"));
    asm(macro.import_function("sceVideocodec","0x2D31F5B1", "sceVideocodecGetEDRAM"));
    asm(macro.import_function("sceVideocodec","0x4F160BF4", "sceVideocodecReleaseEDRAM"));
    asm(macro.import_function("sceVideocodec","0xC01EC829", "sceVideocodecOpen"));
    asm(macro.import_function("sceVideocodec","0xDBA273FA", "sceVideocodecDecode"));
}