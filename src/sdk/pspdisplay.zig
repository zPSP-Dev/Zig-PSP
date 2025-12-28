const module = @import("libzpsp").sceDisplay;

pub const PspDisplayPixelFormats = enum(u24) {
    Format565 = 0,
    Format5551 = 1,
    Format4444 = 2,
    Format8888 = 3,
};

pub const PspDisplaySetBufSync = enum(c_int) {
    NextHSync = 0,
    NextVSync = 1,
};

pub const PspDisplayErrorCodes = enum(c_int) {
    Ok = 0,
    Pointer = 2147483907,
    Argument = 2147483911,
};

pub const PspDisplayMode = enum(c_int) {
    LCD = 0, // LCD MAX 480x272 at 59.94005995 Hz
    VESA1A = 0x1A, // VESA VGA MAX 640x480 at 59.94047618Hz
    PSEUDO_VGA = 0x60, // PSEUDO VGA MAX 640x480 at 59.94005995Hz
};

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
pub fn sceDisplaySetMode(mode: PspDisplayMode, width: c_int, height: c_int) c_int {
    return module.sceDisplaySetMode(@intFromEnum(mode), width, height);
}

/// Get display mode
/// `pmode` - Pointer to an integer to receive the current mode.
/// `pwidth` - Pointer to an integer to receive the current width.
/// `pheight` - Pointer to an integer to receive the current height,
/// Returns 0 on success
pub fn sceDisplayGetMode(pmode: [*c]c_int, pwidth: [*c]c_int, pheight: [*c]c_int) c_int {
    return module.sceDisplayGetMode(pmode, pwidth, pheight);
}

/// Get number of frames per second
pub fn sceDisplayGetFramePerSec() f32 {
    return module.sceDisplayGetFramePerSec();
}

pub fn sceDisplaySetHoldMode() void {
    module.sceDisplaySetHoldMode();
}

pub fn sceDisplaySetResumeMode() void {
    module.sceDisplaySetResumeMode();
}

/// Display set framebuf
/// `topaddr` - address of start of framebuffer
/// `bufferwidth` - buffer width (must be power of 2)
/// `pixelformat` - One of ::PspDisplayPixelFormats.
/// `sync` - One of ::PspDisplaySetBufSync
/// Returns 0 on success
pub fn sceDisplaySetFrameBuf(topaddr: ?*anyopaque, bufferwidth: c_int, pixelformat: PspDisplayPixelFormats, sync: PspDisplaySetBufSync) c_int {
    return module.sceDisplaySetFrameBuf(topaddr, bufferwidth, @intFromEnum(pixelformat), @intFromEnum(sync));
}

/// Get Display Framebuffer information
/// `topaddr` - pointer to void* to receive address of start of framebuffer
/// `bufferwidth` - pointer to int to receive buffer width (must be power of 2)
/// `pixelformat` - pointer to int to receive one of ::PspDisplayPixelFormats.
/// `sync` - One of ::PspDisplaySetBufSync
/// Returns 0 on success
pub fn sceDisplayGetFrameBuf(topaddr: ?*anyopaque, bufferwidth: [*c]c_int, pixelformat: [*c]PspDisplayPixelFormats, sync: PspDisplaySetBufSync) c_int {
    return module.sceDisplayGetFrameBuf(topaddr, bufferwidth, pixelformat, sync);
}

/// Get whether or not frame buffer is being displayed
pub fn sceDisplayIsForeground() c_int {
    return module.sceDisplayIsForeground();
}

pub fn sceDisplay_31C4BAA8() void {
    return module.sceDisplay_31C4BAA8();
}

/// Number of vertical blank pulses up to now
pub fn sceDisplayGetVcount() c_uint {
    return module.sceDisplayGetVcount();
}

/// Test whether VBLANK is active
pub fn sceDisplayIsVblank() c_int {
    return module.sceDisplayIsVblank();
}

/// Wait for vertical blank
/// Wait for vertical blank start with callback
/// Wait for vertical blank start
pub fn sceDisplayWaitVblank() c_int {
    return module.sceDisplayWaitVblank();
}

/// Wait for vertical blank with callback
pub fn sceDisplayWaitVblankCB() c_int {
    return module.sceDisplayWaitVblankCB();
}

/// Wait for vertical blank start
pub fn sceDisplayWaitVblankStart() c_int {
    return module.sceDisplayWaitVblankStart();
}

/// Wait for vertical blank start with callback
pub fn sceDisplayWaitVblankStartCB() c_int {
    return module.sceDisplayWaitVblankStartCB();
}

/// Get current HSYNC count
pub fn sceDisplayGetCurrentHcount() c_int {
    return module.sceDisplayGetCurrentHcount();
}

/// Get accumlated HSYNC count
pub fn sceDisplayGetAccumulatedHcount() c_int {
    return module.sceDisplayGetAccumulatedHcount();
}
