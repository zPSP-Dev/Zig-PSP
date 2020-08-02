pub const enum_PspDisplayPixelFormats = extern enum(c_int) {
    PSP_DISPLAY_PIXEL_FORMAT_565 = 0,
    PSP_DISPLAY_PIXEL_FORMAT_5551 = 1,
    PSP_DISPLAY_PIXEL_FORMAT_4444 = 2,
    PSP_DISPLAY_PIXEL_FORMAT_8888 = 3,
    _,
};

pub const enum_PspDisplaySetBufSync = extern enum(c_int) {
    PSP_DISPLAY_SETBUF_IMMEDIATE = 0,
    PSP_DISPLAY_SETBUF_NEXTFRAME = 1,
    _,
};

pub const enum_PspDisplayErrorCodes = extern enum(c_int) {
    SCE_DISPLAY_ERROR_OK = 0,
    SCE_DISPLAY_ERROR_POINTER = 2147483907,
    SCE_DISPLAY_ERROR_ARGUMENT = 2147483911,
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
