pub const PspCtrlButtons = extern enum(c_uint) {
    Select = 1,
    Start = 8,
    Up = 16,
    Right = 32,
    Down = 64,
    Left = 128,
    LTrigger = 256,
    RTrigger = 512,
    Triangle = 4096,
    Circle = 8192,
    Cross = 16384,
    Square = 32768,
    Home = 65536,
    Hold = 131072,
    Note = 8388608,
    Screen = 4194304,
    VolUp = 1048576,
    VolDown = 2097152,
    WlanUp = 262144,
    Remote = 524288,
    Disc = 16777216,
    Ms = 33554432,
};

pub const PspCtrlMode = extern enum(c_int) {
    Digital = 0,
    Analog = 1,
};

pub const SceCtrlData = extern struct {
    timeStamp: c_uint,
    buttons: c_uint,
    Lx: u8,
    Ly: u8,
    Rsrv: [6]u8,
};

pub const SceCtrlLatch = extern struct {
    uiMake: c_uint,
    uiBreak: c_uint,
    uiPress: c_uint,
    uiRelease: c_uint,
};

// Set the controller cycle setting.
//
// @param cycle - Cycle.  Normally set to 0.
//
// @return The previous cycle setting.
pub extern fn sceCtrlSetSamplingCycle(cycle: c_int) c_int;

// Get the controller current cycle setting.
//
// @param pcycle - Return value.
//
// @return 0.
pub extern fn sceCtrlGetSamplingCycle(pcycle: *c_int) c_int;

// Set the controller mode.
//
// @param mode - One of ::PspCtrlMode.
//
// @return The previous mode.
pub extern fn sceCtrlSetSamplingMode(mode: c_int) c_int;

pub fn ctrlSetSamplingMode(mode: PspCtrlMode) PspCtrlMode {
    @setRuntimeSafety(false);
    var res = sceCtrlSetSamplingMode(@enumToInt(mode));
    return @intToEnum(PspCtrlMode, res);
}

// Get the current controller mode.
//
// @param pmode - Return value.
//
// @return 0.
pub extern fn sceCtrlGetSamplingMode(pmode: *c_int) c_int;

pub extern fn sceCtrlPeekBufferPositive(pad_data: *SceCtrlData, count: c_int) c_int;
pub extern fn sceCtrlPeekBufferNegative(pad_data: *SceCtrlData, count: c_int) c_int;

// Read buffer positive
// C Example:
// SceCtrlData pad;
// sceCtrlSetSamplingCycle(0);
// sceCtrlSetSamplingMode(1);
// sceCtrlReadBufferPositive(&pad, 1);
// @param pad_data - Pointer to a ::SceCtrlData structure used hold the returned pad data.
// @param count - Number of ::SceCtrlData buffers to read.
pub extern fn sceCtrlReadBufferPositive(pad_data: *SceCtrlData, count: c_int) c_int;

pub extern fn sceCtrlReadBufferNegative(pad_data: *SceCtrlData, count: c_int) c_int;
pub extern fn sceCtrlPeekLatch(latch_data: *SceCtrlLatch) c_int;
pub extern fn sceCtrlReadLatch(latch_data: *SceCtrlLatch) c_int;

// Set analog threshold relating to the idle timer.
//
// @param idlereset - Movement needed by the analog to reset the idle timer.
// @param idleback - Movement needed by the analog to bring the PSP back from an idle state.
//
// Set to -1 for analog to not cancel idle timer.
// Set to 0 for idle timer to be cancelled even if the analog is not moved.
// Set between 1 - 128 to specify the movement on either axis needed by the analog to fire the event.
//
// @return < 0 on error.
pub extern fn sceCtrlSetIdleCancelThreshold(idlereset: c_int, idleback: c_int) c_int;
pub fn ctrlSetIdleCancelThreshold(idlereset: c_int, idleback: c_int) !i32 {
    var res = sceCtrlSetIdleCancelThreshold(idlereset, idleback);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Get the idle threshold values.
//
// @param idlerest - Movement needed by the analog to reset the idle timer.
// @param idleback - Movement needed by the analog to bring the PSP back from an idle state.
//
// @return < 0 on error.
pub extern fn sceCtrlGetIdleCancelThreshold(idlerest: *c_int, idleback: *c_int) c_int;
pub fn ctrlGetIdleCancelThreshold(idlerest: *c_int, idleback: *c_int) !i32 {
    var res = sceCtrlGetIdleCancelThreshold(idlereset, idleback);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}
