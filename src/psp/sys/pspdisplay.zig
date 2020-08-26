pub const enum_PspDisplayPixelFormats = extern enum(c_int) {
    Format565 = 0,
    Format5551 = 1,
    Format4444 = 2,
    Format8888 = 3,
    _,
};

pub const enum_PspDisplaySetBufSync = extern enum(c_int) {
    Immediate = 0,
    Nextframe = 1,
    _,
};

pub const enum_PspDisplayErrorCodes = extern enum(c_int) {
    Ok = 0,
    Pointer = 2147483907,
    Argument = 2147483911,
    _,
};
pub extern fn sceDisplaySetMode(mode: c_int, width: c_int, height: c_int) c_int;
pub extern fn sceDisplayGetMode(pmode: [*c]c_int, pwidth: [*c]c_int, pheight: [*c]c_int) c_int;
pub extern fn sceDisplaySetFrameBuf(topaddr: ?*c_void, bufferwidth: c_int, pixelformat: c_int, sync: c_int) c_int;
pub extern fn sceDisplayGetFrameBuf(topaddr: [*c]?*c_void, bufferwidth: [*c]c_int, pixelformat: [*c]c_int, sync: c_int) c_int;
pub extern fn sceDisplayGetVcount() c_uint;
pub extern fn sceDisplayWaitVblankStart() c_int;
pub extern fn sceDisplayWaitVblankStartCB() c_int;
pub extern fn sceDisplayWaitVblank() c_int;
pub extern fn sceDisplayWaitVblankCB() c_int;
pub extern fn sceDisplayGetAccumulatedHcount() c_int;
pub extern fn sceDisplayGetCurrentHcount() c_int;
pub extern fn sceDisplayGetFramePerSec() f32;
pub extern fn sceDisplayIsForeground() c_int;
pub extern fn sceDisplayIsVblank() c_int;

pub const PspDisplayPixelFormats = enum_PspDisplayPixelFormats;
pub const PspDisplaySetBufSync = enum_PspDisplaySetBufSync;
pub const PspDisplayErrorCodes = enum_PspDisplayErrorCodes;

const macro = @import("pspmacros.zig");

comptime{
    asm(macro.import_module_start("sceDisplay", "0x40010000", "17"));
    asm(macro.import_function("sceDisplay", "0x0E20F177", "sceDisplaySetMode"));
    asm(macro.import_function("sceDisplay", "0xDEA197D4", "sceDisplayGetMode"));
    asm(macro.import_function("sceDisplay", "0xDBA6C4C4", "sceDisplayGetFramePerSec"));
    asm(macro.import_function("sceDisplay", "0x7ED59BC4", "sceDisplaySetHoldMode"));
    asm(macro.import_function("sceDisplay", "0xA544C486", "sceDisplaySetResumeMode"));
    asm(macro.import_function("sceDisplay", "0x289D82FE", "sceDisplaySetFrameBuf"));
    asm(macro.import_function("sceDisplay", "0xEEDA2E54", "sceDisplayGetFrameBuf"));
    asm(macro.import_function("sceDisplay", "0xB4F378FA", "sceDisplayIsForeground"));
    asm(macro.import_function("sceDisplay", "0x31C4BAA8", "sceDisplay_31C4BAA8"));
    asm(macro.import_function("sceDisplay", "0x9C6EAAD7", "sceDisplayGetVcount"));
    asm(macro.import_function("sceDisplay", "0x4D4E10EC", "sceDisplayIsVblank"));
    asm(macro.import_function("sceDisplay", "0x36CDFADE", "sceDisplayWaitVblank"));
    asm(macro.import_function("sceDisplay", "0x8EB9EC49", "sceDisplayWaitVblankCB"));
    asm(macro.import_function("sceDisplay", "0x984C27E7", "sceDisplayWaitVblankStart"));
    asm(macro.import_function("sceDisplay", "0x46F186C3", "sceDisplayWaitVblankStartCB"));
    asm(macro.import_function("sceDisplay", "0x773DD3A3", "sceDisplayGetCurrentHcount"));
    asm(macro.import_function("sceDisplay", "0x210EAB3A", "sceDisplayGetAccumulatedHcount"));
}
