// See also: https://github.com/hrydgard/ppsspp/issues/17464
pub const PspCtrlButtons = packed struct(u32) {
    select: u1,
    l3: u1, // Available on devkits when connecting a dualshock controller
    r3: u1,
    start: u1,

    up: u1,
    right: u1,
    down: u1,
    left: u1,

    l_trigger: u1,
    r_trigger: u1,
    l2: u1, // Available on devkits when connecting a dualshock controller
    r2: u1,

    triangle: u1,
    circle: u1,
    cross: u1,
    square: u1,

    home: u1,
    hold: u1,
    wlan_up: u1,
    remote: u1,

    vol_up: u1,
    vol_down: u1,
    screen: u1,
    note: u1,

    disc: u1,
    memory_stick: u1,
    unknown_b26: u1,
    unknown_b27: u1,

    unknown_b28_31: u4,
};

pub const PspCtrlMode = enum(c_int) {
    Digital = 0,
    Analog = 1,
};

pub const SceCtrlData = extern struct {
    timeStamp: c_uint,
    buttons: PspCtrlButtons,
    Lx: u8,
    Ly: u8,
    Rsrv: [6]u8,
};

pub const SceCtrlLatch = extern struct {
    uiMake: PspCtrlButtons,
    uiBreak: PspCtrlButtons,
    uiPress: PspCtrlButtons,
    uiRelease: PspCtrlButtons,
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
    const res = sceCtrlSetSamplingMode(@intFromEnum(mode));
    return @as(PspCtrlMode, @enumFromInt(res));
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
    const res = sceCtrlSetIdleCancelThreshold(idlereset, idleback);
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
    const res = sceCtrlGetIdleCancelThreshold(idlerest, idleback);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}
