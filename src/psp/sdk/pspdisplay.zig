pub const PspDisplayPixelFormats = extern enum(c_int) {
    Format565 = 0,
    Format5551 = 1,
    Format4444 = 2,
    Format8888 = 3,
};

pub const PspDisplaySetBufSync = extern enum(c_int) {
    Immediate = 0,
    Nextframe = 1,
};

pub const PspDisplayErrorCodes = extern enum(c_int) {
    Ok = 0,
    Pointer = 2147483907,
    Argument = 2147483911,
};

// Set display mode
//
// @param mode - Display mode, normally 0.
// @param width - Width of screen in pixels.
// @param height - Height of screen in pixels.
//
// @return ???
pub extern fn sceDisplaySetMode(mode: c_int, width: c_int, height: c_int) c_int;
pub fn displaySetMode(mode: c_int, width: c_int, height: c_int) void {
    _ = sceDisplaySetMode(mode, width, height);
}

// Get display mode
//
// @param pmode - Pointer to an integer to receive the current mode.
// @param pwidth - Pointer to an integer to receive the current width.
// @param pheight - Pointer to an integer to receive the current height,
//
// @return 0 on success
pub extern fn sceDisplayGetMode(pmode: *c_int, pwidth: *c_int, pheight: *c_int) c_int;
pub fn displayGetMode(pmode: *c_int, pwidth: *c_int, pheight: *c_int) bool {
    var res = sceDisplayGetMode(pmode, pwidth, pheight);
    return res == 0;
}

// Display set framebuf
//
// @param topaddr - address of start of framebuffer
// @param bufferwidth - buffer width (must be power of 2)
// @param pixelformat - One of ::PspDisplayPixelFormats.
// @param sync - One of ::PspDisplaySetBufSync
//
// @return 0 on success
pub extern fn sceDisplaySetFrameBuf(topaddr: ?*c_void, bufferwidth: c_int, pixelformat: c_int, sync: c_int) c_int;
pub fn displaySetFrameBuf(topaddr: ?*c_void, bufferwidth: c_int, pixelformat: c_int, sync: c_int) bool {
    var res = sceDisplaySetFrameBuf(topaddr, bufferwidth, pixelformat, sync);
    return res;
}

// Get Display Framebuffer information
//
// @param topaddr - pointer to void* to receive address of start of framebuffer
// @param bufferwidth - pointer to int to receive buffer width (must be power of 2)
// @param pixelformat - pointer to int to receive one of ::PspDisplayPixelFormats.
// @param sync - One of ::PspDisplaySetBufSync
//
// @return 0 on success
pub extern fn sceDisplayGetFrameBuf(topaddr: **c_void, bufferwidth: *c_int, pixelformat: *c_int, sync: c_int) c_int;
pub fn displayGetFrameBuf(topaddr: **c_void, bufferwidth: *c_int, pixelformat: *c_int, sync: c_int) bool {
    var res = sceDisplayGetFrameBuf(topaddr, bufferwidth, pixelformat, sync);
    return res == 0;
}

//Number of vertical blank pulses up to now
pub extern fn sceDisplayGetVcount() c_uint;

//Wait for vertical blank start
pub extern fn sceDisplayWaitVblankStart() c_int;
pub fn displayWaitVblankStart() void {
    _ = sceDisplayWaitVblankStart();
}

//Wait for vertical blank start with callback
pub extern fn sceDisplayWaitVblankStartCB() c_int;
pub fn displayWaitVblankStartCB() void {
    _ = sceDisplayWaitVblankStartCB();
}

//Wait for vertical blank
pub extern fn sceDisplayWaitVblank() c_int;
pub fn displayWaitVblank() void {
    _ = sceDisplayWaitVblank();
}

//Wait for vertical blank with callback
pub extern fn sceDisplayWaitVblankCB() c_int;
pub fn displayWaitVblankCB() void {
    _ = sceDisplayWaitVblankCB();
}

//Get accumlated HSYNC count
pub extern fn sceDisplayGetAccumulatedHcount() c_int;

//Get current HSYNC count
pub extern fn sceDisplayGetCurrentHcount() c_int;

//Get number of frames per second
pub extern fn sceDisplayGetFramePerSec() f32;

//Get whether or not frame buffer is being displayed
pub extern fn sceDisplayIsForeground() c_int;

//Test whether VBLANK is active
pub extern fn sceDisplayIsVblank() c_int;
