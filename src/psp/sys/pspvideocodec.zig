pub extern fn sceVideocodecOpen(Buffer: [*c]c_ulong, Type: c_int) c_int;
pub extern fn sceVideocodecGetEDRAM(Buffer: [*c]c_ulong, Type: c_int) c_int;
pub extern fn sceVideocodecInit(Buffer: [*c]c_ulong, Type: c_int) c_int;
pub extern fn sceVideocodecDecode(Buffer: [*c]c_ulong, Type: c_int) c_int;
pub extern fn sceVideocodecReleaseEDRAM(Buffer: [*c]c_ulong) c_int;
