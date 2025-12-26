const libzpsp = @import("libzpsp");

const module = libzpsp.sceCtrl;

pub const PspCtrlButtons = libzpsp.types.PspCtrlButtons;
pub const SceCtrlData = libzpsp.types.SceCtrlData;
pub const SceCtrlLatch = libzpsp.types.SceCtrlLatch;
pub const PspCtrlMode = enum(c_int) {
    Digital = 0,
    Analog = 1,
};

/// Set the controller cycle setting.
/// `cycle` - Cycle.  Normally set to 0.
/// Returns The previous cycle setting.
pub fn sceCtrlSetSamplingCycle(cycle: c_int) c_int {
    return module.sceCtrlSetSamplingCycle(cycle);
}

/// Get the controller current cycle setting.
/// `pcycle` - Return value.
/// Returns 0.
pub fn sceCtrlGetSamplingCycle(pcycle: [*c]c_int) c_int {
    return module.sceCtrlGetSamplingCycle(pcycle);
}

/// Set the controller mode.
/// `mode` - One of ::PspCtrlMode. If this is ::PSP_CTRL_MODE_DIGITAL, no data about the analog stick
/// will be present in the SceCtrlData struct read by SceCtrlReadBuffer.
/// Returns The previous mode.
pub fn sceCtrlSetSamplingMode(mode: PspCtrlMode) c_int {
    return module.sceCtrlSetSamplingMode(@intFromEnum(mode));
}

/// Get the current controller mode.
/// `pmode` - Return value.
/// Returns 0.
pub fn sceCtrlGetSamplingMode(pmode: [*c]c_int) c_int {
    return module.sceCtrlGetSamplingMode(pmode);
}

/// @brief Read latest controller data from the controller service.
/// Controller data contains current button and axis state.
/// @note Axis state is present only in ::PSP_CTRL_MODE_ANALOG controller mode.
/// `pad_data` - A pointer to ::SceCtrlData structure that receives controller data.
/// `count` - Number of ::SceCtrlData structures to read.
/// @see ::SceCtrlData
/// @see ::sceCtrlPeekBufferNegative()
/// @see ::sceCtrlReadBufferPositive()
pub fn sceCtrlPeekBufferPositive(pad_data: []SceCtrlData) c_int {
    return module.sceCtrlPeekBufferPositive(pad_data.ptr, @intCast(pad_data.len));
}

pub fn sceCtrlPeekBufferNegative(pad_data: []SceCtrlData) c_int {
    return module.sceCtrlPeekBufferNegative(pad_data.ptr, @intCast(pad_data.len));
}

/// @brief Read new controller data from the controller service.
/// Controller data contains current button and axis state.
/// **Example:**
/// `
/// SceCtrlData pad;
/// sceCtrlSetSamplingCycle(0);
/// sceCtrlSetSamplingMode(1);
/// sceCtrlReadBufferPositive(&pad, 1);
/// // Do something with the read controller data
/// `
/// @note Axis state is present only in ::PSP_CTRL_MODE_ANALOG controller mode.
/// @warning Controller data is collected once every controller sampling cycle.
/// If controller data was already read during a cycle, trying to read it again
/// will block the execution until the next one.
/// `pad_data` - A pointer to ::SceCtrlData structure that receives controller data.
/// `count` - Number of ::SceCtrlData structures to read.
/// @see ::SceCtrlData
/// @see ::sceCtrlReadBufferNegative()
/// @see ::sceCtrlPeekBufferPositive()
pub fn sceCtrlReadBufferPositive(pad_data: []SceCtrlData) c_int {
    return module.sceCtrlReadBufferPositive(pad_data.ptr, @intCast(pad_data.len));
}

pub fn sceCtrlReadBufferNegative(pad_data: []SceCtrlData) c_int {
    return module.sceCtrlReadBufferNegative(pad_data.ptr, @intCast(pad_data.len));
}

/// @brief Read latest latch data from the controller service.
/// Latch data contains information about button state changes between two controller service sampling cycles.
/// `latch_data A pointer to ::SceCtrlLatch structure that receives latch data.`
/// Returns On success, the number of times the controller service performed sampling since the last time
/// ::sceCtrlReadLatch() was called.
/// Returns < 0 on error.
/// @see ::SceCtrlLatch
/// @see ::sceCtrlReadLatch()
pub fn sceCtrlPeekLatch(latch_data: *SceCtrlLatch) c_int {
    return module.sceCtrlPeekLatch(latch_data);
}

/// @brief Read new latch data from the controller service.
/// Latch data contains information about button state changes between two controller service sampling cycles.
/// **Example:**
/// `
/// SceCtrlLatch latchData;
/// while (1) {
/// // Obtain latch data
/// sceCtrlReadLatch(&latchData);
/// if (latchData.uiMake & PSP_CTRL_CROSS)
/// {
/// // The Cross button has just been pressed (transition from 'released' state to 'pressed' state)
/// }
/// if (latchData.uiPress & PSP_CTRL_SQUARE)
/// {
/// // The Square button is currently in the 'pressed' state
/// }
/// if (latchData.uiBreak & PSP_CTRL_TRIANGLE)
/// {
/// // The Triangle button has just been released (transition from 'pressed' state to 'released' state)
/// }
/// if (latchData.uiRelease & PSP_CTRL_CIRCLE)
/// {
/// // The Circle button is currently in the 'released' state
/// }
/// // As we clear the internal latch data with the ReadLatch() call, we can explicitly wait for the VBLANK interval
/// // to give the controller service the time it needs to collect new latch data again. This guarantees the next call
/// // to sceCtrlReadLatch() will return collected data again.
/// //
/// // Note: The sceCtrlReadBuffer*() APIs are implicitly waiting for a VBLANK interval if necessary.
/// sceDisplayWaitVBlank();
/// }
/// `
/// @warning Latch data is produced once every controller sampling cycle. If latch data was already read
/// during a cycle, trying to read it again will block the execution until the next one.
/// `latch_data A pointer to ::SceCtrlLatch structure that receives latch data.`
/// Returns On success, the number of times the controller service performed sampling since the last time
/// ::sceCtrlReadLatch() was called.
/// Returns < 0 on error.
/// @see ::SceCtrlLatch
/// @see ::sceCtrlPeekLatch()
pub fn sceCtrlReadLatch(latch_data: *SceCtrlLatch) c_int {
    return module.sceCtrlReadLatch(latch_data);
}

pub fn sceCtrl_348D99D4() void {
    module.sceCtrl_348D99D4();
}

pub fn sceCtrl_AF5960F3() void {
    module.sceCtrl_AF5960F3();
}

pub fn sceCtrlClearRapidFire() void {
    module.sceCtrlClearRapidFire();
}

pub fn sceCtrlSetRapidFire() void {
    module.sceCtrlSetRapidFire();
}

/// Set analog threshold relating to the idle timer.
/// `idlereset` - Movement needed by the analog to reset the idle timer.
/// `idleback` - Movement needed by the analog to bring the PSP back from an idle state.
/// Set to -1 for analog to not cancel idle timer.
/// Set to 0 for idle timer to be cancelled even if the analog is not moved.
/// Set between 1 - 128 to specify the movement on either axis needed by the analog to fire the event.
/// Returns < 0 on error.
pub fn sceCtrlSetIdleCancelThreshold(idlereset: c_int, idleback: c_int) c_int {
    return module.sceCtrlSetIdleCancelThreshold(idlereset, idleback);
}

/// Get the idle threshold values.
/// `idlerest` - Movement needed by the analog to reset the idle timer.
/// `idleback` - Movement needed by the analog to bring the PSP back from an idle state.
/// Returns < 0 on error.
pub fn sceCtrlGetIdleCancelThreshold(idlerest: [*c]c_int, idleback: [*c]c_int) c_int {
    return module.sceCtrlGetIdleCancelThreshold(idlerest, idleback);
}
