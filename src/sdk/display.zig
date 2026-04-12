// Display -- framebuffer, vsync, display mode
//
// Wraps:
//   c/module/sceDisplay.zig

const int = @import("errors/display.zig");
const internal = @import("internal.zig");
const check = int.check;
const ci = internal.ci;
const cu = internal.cu;
const c = @import("../c/modules.zig");
const module = c.sceDisplay;

/// Framebuffer pixel storage format.
pub const PixelFormat = enum(u32) {
    /// 16-bit, 5 red / 6 green / 5 blue
    rgb565 = 0,
    /// 16-bit, 5 red / 5 green / 5 blue / 1 alpha
    rgba5551 = 1,
    /// 16-bit, 4 red / 4 green / 4 blue / 4 alpha
    rgba4444 = 2,
    /// 32-bit, 8 red / 8 green / 8 blue / 8 alpha
    rgba8888 = 3,
};

/// Controls when a framebuffer swap takes effect.
pub const BufSync = enum(u32) {
    /// Apply on the next horizontal sync (immediate)
    immediate = 0,
    /// Apply on the next vertical blank
    next_vblank = 1,
};

/// Display output mode.
pub const Mode = enum(u32) {
    /// LCD 480x272 @ 59.94 Hz
    lcd = 0,
    /// VESA VGA 640x480 @ 59.94 Hz
    vesa_1a = 0x1A,
    /// Pseudo VGA 640x480 @ 59.94 Hz
    pseudo_vga = 0x60,
};

/// Returned by `get_mode`.
pub const ModeInfo = struct {
    mode: Mode,
    width: u32,
    height: u32,
};

/// Returned by `get_frame_buf`.
pub const FrameBufInfo = struct {
    topaddr: ?*anyopaque,
    bufferwidth: u32,
    pixelformat: PixelFormat,
};

pub const Error = int.Error;

/// Configure the display output mode.
///
/// Standard PSP LCD mode is `.lcd` at 480x272.
pub fn set_mode(mode: Mode, width: u32, height: u32) Error!void {
    return check(module.sceDisplaySetMode(ci(@intFromEnum(mode)), ci(width), ci(height)));
}

/// Query the current display mode, width, and height.
pub fn get_mode() Error!ModeInfo {
    var mode: c_int = undefined;
    var width: c_int = undefined;
    var height: c_int = undefined;
    try check(module.sceDisplayGetMode(&mode, &width, &height));
    return .{
        .mode = @enumFromInt(cu(mode)),
        .width = cu(width),
        .height = cu(height),
    };
}

/// Return the display refresh rate in frames per second (typically ~59.94).
pub fn get_frame_per_sec() f32 {
    return module.sceDisplayGetFramePerSec();
}

pub fn set_hold_mode() void {
    module.sceDisplaySetHoldMode();
}

pub fn set_resume_mode() void {
    module.sceDisplaySetResumeMode();
}

/// Set the framebuffer address, stride, and pixel format for display output.
///
/// `bufferwidth` is the buffer stride in pixels and must be a power of 2
/// (typically 512 for the standard 480-pixel wide screen).
pub fn set_frame_buf(topaddr: ?*anyopaque, bufferwidth: u32, pixelformat: PixelFormat, sync: BufSync) Error!void {
    return check(module.sceDisplaySetFrameBuf(topaddr, ci(bufferwidth), ci(@intFromEnum(pixelformat)), ci(@intFromEnum(sync))));
}

/// Query the current framebuffer address, stride, and pixel format.
pub fn get_frame_buf(sync: BufSync) Error!FrameBufInfo {
    var topaddr: ?*anyopaque = null;
    var bufferwidth: c_int = undefined;
    var pixelformat: c_int = undefined;
    try check(module.sceDisplayGetFrameBuf(&topaddr, &bufferwidth, &pixelformat, ci(@intFromEnum(sync))));
    return .{
        .topaddr = topaddr,
        .bufferwidth = cu(bufferwidth),
        .pixelformat = @enumFromInt(cu(pixelformat)),
    };
}

/// Returns `true` if this application's framebuffer is currently being displayed
/// (i.e. the app is in the foreground).
pub fn is_foreground() bool {
    return module.sceDisplayIsForeground() != 0;
}

/// Return the total number of vertical blanks since the system started.
pub fn get_vcount() u32 {
    return module.sceDisplayGetVcount();
}

/// Returns `true` if the display is currently in the vertical blank period.
pub fn is_vblank() bool {
    return module.sceDisplayIsVblank() != 0;
}

/// Block until the current vertical blank period ends.
pub fn wait_vblank() Error!void {
    return check(module.sceDisplayWaitVblank());
}

/// Block until the current vertical blank period ends.
/// Allows registered kernel callbacks to run while waiting.
pub fn wait_vblank_cb() Error!void {
    return check(module.sceDisplayWaitVblankCB());
}

/// Block until the next vertical blank period begins.
pub fn wait_vblank_start() Error!void {
    return check(module.sceDisplayWaitVblankStart());
}

/// Block until the next vertical blank period begins.
/// Allows registered kernel callbacks to run while waiting.
pub fn wait_vblank_start_cb() Error!void {
    return check(module.sceDisplayWaitVblankStartCB());
}

/// Return the current horizontal scanline count within the current frame.
pub fn get_current_hcount() u32 {
    return @intCast(module.sceDisplayGetCurrentHcount());
}

/// Return the total number of horizontal scanlines rendered since the system started.
pub fn get_accumulated_hcount() u32 {
    return @intCast(module.sceDisplayGetAccumulatedHcount());
}
