const c = @import("libzpsp").sceDisplay;

pub const DisplayMode = enum(c_int) {
    LCD = 0,
    Vesa = 0x1A,
    PseudoVGA = 0x60,
};

pub const PixelFormats = enum(c_int) {
    Format565 = 0,
    Format5551 = 1,
    Format4444 = 2,
    Format8888 = 3,
};

pub const SetBufSync = enum(c_int) {
    Immediate = 0,
    NextVSync = 1,
};

pub const ErrorCodes = enum(c_int) {
    Ok = 0,
    Pointer = 2147483907,
    Argument = 2147483911,
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
/// When error, a negative value is returned.
pub fn set_mode(mode: DisplayMode, width: u32, height: u32) !void {
    if(c.sceDisplaySetMode(@intFromEnum(mode), @bitCast(width), @bitCast(height)) < 0) {
        return error.SetModeFailed;
    }
}

/// Get display mode
/// `pmode` - Pointer to an integer to receive the current mode.
/// `pwidth` - Pointer to an integer to receive the current width.
/// `pheight` - Pointer to an integer to receive the current height,
/// Returns 0 on success
pub fn get_mode(pmode: *DisplayMode, pwidth: *u32, pheight: *u32) !void {
    if(c.sceDisplayGetMode(@ptrCast(pmode), @ptrCast(pwidth), @ptrCast(pheight)) < 0) {
        return error.GetModeFailed;
    }
}

/// Get number of frames per second
pub fn get_frames_per_sec() f32 {
    return c.sceDisplayGetFramePerSec();
}

pub fn set_hold_mode() void {
    c.sceDisplaySetHoldMode();
}

pub fn set_resume_mode() void {
    c.sceDisplaySetResumeMode();
}

/// Display set framebuf
/// `topaddr` - address of start of framebuffer
/// `bufferwidth` - buffer width (must be power of 2)
/// `pixelformat` - One of ::PspDisplayPixelFormats.
/// `sync` - One of ::PspDisplaySetBufSync
/// Returns 0 on success
pub fn set_frame_buf(topaddr: ?*anyopaque, bufferwidth: u32, pixelformat: PixelFormats, sync: SetBufSync) !void {
    if(c.sceDisplaySetFrameBuf(topaddr, @bitCast(bufferwidth), @intFromEnum(pixelformat), @intFromEnum(sync)) < 0) {
        return error.SetFrameBufFailed;
    }
}

/// Get Display Framebuffer information
/// `topaddr` - pointer to void* to receive address of start of framebuffer
/// `bufferwidth` - pointer to int to receive buffer width (must be power of 2)
/// `pixelformat` - pointer to int to receive one of ::PspDisplayPixelFormats.
/// `sync` - One of ::PspDisplaySetBufSync
/// Returns 0 on success
pub fn get_frame_buf(topaddr: ?*anyopaque, bufferwidth: *u32, pixelformat: *PixelFormats, sync: SetBufSync) !void {
    if(c.sceDisplayGetFrameBuf(topaddr, @ptrCast(bufferwidth), @ptrCast(pixelformat), @intFromEnum(sync)) < 0) {
        return error.GetFrameBufFailed;
    }
}

/// Get whether or not frame buffer is being displayed
pub fn is_foreground() c_int {
    return c.sceDisplayIsForeground();
}

pub fn @"_31C4BAA8"() void {
    return c.sceDisplay_31C4BAA8();
}

/// Number of vertical blank pulses up to now
pub fn get_vcount() c_uint {
    return c.sceDisplayGetVcount();
}

/// Test whether VBLANK is active
pub fn is_vblank() c_int {
    return c.sceDisplayIsVblank();
}

/// Wait for vertical blank
pub fn wait_vblank() c_int {
    return c.sceDisplayWaitVblank();
}

/// Wait for vertical blank with callback
pub fn wait_vblank_cb() c_int {
    return c.sceDisplayWaitVblankCB();
}

/// Wait for vertical blank start
pub fn wait_vblank_start() c_int {
    return c.sceDisplayWaitVblankStart();
}

/// Wait for vertical blank start with callback
pub fn wait_vblank_start_cb() c_int {
    return c.sceDisplayWaitVblankStartCB();
}

/// Get current HSYNC count
pub fn get_current_hcount() c_int {
    return c.sceDisplayGetCurrentHcount();
}

/// Get accumlated HSYNC count
pub fn get_accumulated_hcount() c_int {
    return c.sceDisplayGetAccumulatedHcount();
}
