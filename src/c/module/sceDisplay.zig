// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Set display mode
/// @par Example1:
/// `
/// int mode = PSP_DISPLAY_MODE_LCD;
/// int width = 480;
/// int height = 272;
/// sceDisplaySetMode(mode, width, height);
/// `
/// `mode` - One of ::PspDisplayMode
/// `width` - Width of screen in pixels.
/// `height` - Height of screen in pixels.
/// Returns when error, a negative value is returned.
pub extern fn sceDisplaySetMode(mode: c_int, width: c_int, height: c_int) callconv(.c) c_int;

/// Get display mode
/// `pmode` - Pointer to an integer to receive the current mode.
/// `pwidth` - Pointer to an integer to receive the current width.
/// `pheight` - Pointer to an integer to receive the current height,
/// Returns 0 on success
pub extern fn sceDisplayGetMode(pmode: [*c]c_int, pwidth: [*c]c_int, pheight: [*c]c_int) callconv(.c) c_int;

/// Get number of frames per second
pub extern fn sceDisplayGetFramePerSec() callconv(.c) f32;

pub extern fn sceDisplaySetHoldMode() callconv(.c) void;

pub extern fn sceDisplaySetResumeMode() callconv(.c) void;

/// Display set framebuf
/// `topaddr` - address of start of framebuffer
/// `bufferwidth` - buffer width (must be power of 2)
/// `pixelformat` - One of ::PspDisplayPixelFormats.
/// `sync` - One of ::PspDisplaySetBufSync
/// Returns 0 on success
pub extern fn sceDisplaySetFrameBuf(topaddr: ?*anyopaque, bufferwidth: c_int, pixelformat: c_int, sync: c_int) callconv(.c) c_int;

/// Get Display Framebuffer information
/// `topaddr` - pointer to void* to receive address of start of framebuffer
/// `bufferwidth` - pointer to int to receive buffer width (must be power of 2)
/// `pixelformat` - pointer to int to receive one of ::PspDisplayPixelFormats.
/// `sync` - One of ::PspDisplaySetBufSync
/// Returns 0 on success
pub extern fn sceDisplayGetFrameBuf(topaddr: ?*anyopaque, bufferwidth: [*c]c_int, pixelformat: [*c]c_int, sync: c_int) callconv(.c) c_int;

/// Get whether or not frame buffer is being displayed
pub extern fn sceDisplayIsForeground() callconv(.c) c_int;

pub extern fn sceDisplay_31C4BAA8() callconv(.c) void;

/// Number of vertical blank pulses up to now
pub extern fn sceDisplayGetVcount() callconv(.c) c_uint;

/// Test whether VBLANK is active
pub extern fn sceDisplayIsVblank() callconv(.c) c_int;

/// Wait for vertical blank
/// Wait for vertical blank start with callback
/// Wait for vertical blank start
pub extern fn sceDisplayWaitVblank() callconv(.c) c_int;

/// Wait for vertical blank with callback
pub extern fn sceDisplayWaitVblankCB() callconv(.c) c_int;

/// Wait for vertical blank start
pub extern fn sceDisplayWaitVblankStart() callconv(.c) c_int;

/// Wait for vertical blank start with callback
pub extern fn sceDisplayWaitVblankStartCB() callconv(.c) c_int;

/// Get current HSYNC count
pub extern fn sceDisplayGetCurrentHcount() callconv(.c) c_int;

/// Get accumlated HSYNC count
pub extern fn sceDisplayGetAccumulatedHcount() callconv(.c) c_int;

comptime {
    asm (macro.import_module_start("sceDisplay", "0x40010000", "17"));
    asm (macro.import_function("sceDisplay", "0x0E20F177", "sceDisplaySetMode"));
    asm (macro.import_function("sceDisplay", "0xDEA197D4", "sceDisplayGetMode"));
    asm (macro.import_function("sceDisplay", "0xDBA6C4C4", "sceDisplayGetFramePerSec"));
    asm (macro.import_function("sceDisplay", "0x7ED59BC4", "sceDisplaySetHoldMode"));
    asm (macro.import_function("sceDisplay", "0xA544C486", "sceDisplaySetResumeMode"));
    asm (macro.import_function("sceDisplay", "0x289D82FE", "sceDisplaySetFrameBuf"));
    asm (macro.import_function("sceDisplay", "0xEEDA2E54", "sceDisplayGetFrameBuf"));
    asm (macro.import_function("sceDisplay", "0xB4F378FA", "sceDisplayIsForeground"));
    asm (macro.import_function("sceDisplay", "0x31C4BAA8", "sceDisplay_31C4BAA8"));
    asm (macro.import_function("sceDisplay", "0x9C6EAAD7", "sceDisplayGetVcount"));
    asm (macro.import_function("sceDisplay", "0x4D4E10EC", "sceDisplayIsVblank"));
    asm (macro.import_function("sceDisplay", "0x36CDFADE", "sceDisplayWaitVblank"));
    asm (macro.import_function("sceDisplay", "0x8EB9EC49", "sceDisplayWaitVblankCB"));
    asm (macro.import_function("sceDisplay", "0x984C27E7", "sceDisplayWaitVblankStart"));
    asm (macro.import_function("sceDisplay", "0x46F186C3", "sceDisplayWaitVblankStartCB"));
    asm (macro.import_function("sceDisplay", "0x773DD3A3", "sceDisplayGetCurrentHcount"));
    asm (macro.import_function("sceDisplay", "0x210EAB3A", "sceDisplayGetAccumulatedHcount"));
}
