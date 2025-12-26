// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Set the controller cycle setting.
/// `cycle` - Cycle.  Normally set to 0.
/// Returns The previous cycle setting.
pub extern fn sceCtrlSetSamplingCycle(cycle: c_int) callconv(.C) c_int;

/// Get the controller current cycle setting.
/// `pcycle` - Return value.
/// Returns 0.
pub extern fn sceCtrlGetSamplingCycle(pcycle: [*c]c_int) callconv(.C) c_int;

/// Set the controller mode.
/// `mode` - One of ::PspCtrlMode. If this is ::PSP_CTRL_MODE_DIGITAL, no data about the analog stick
/// will be present in the SceCtrlData struct read by SceCtrlReadBuffer.
/// Returns The previous mode.
pub extern fn sceCtrlSetSamplingMode(mode: c_int) callconv(.C) c_int;

/// Get the current controller mode.
/// `pmode` - Return value.
/// Returns 0.
pub extern fn sceCtrlGetSamplingMode(pmode: [*c]c_int) callconv(.C) c_int;

/// @brief Read latest controller data from the controller service.
/// Controller data contains current button and axis state.
/// @note Axis state is present only in ::PSP_CTRL_MODE_ANALOG controller mode.
/// `pad_data` - A pointer to ::SceCtrlData structure that receives controller data.
/// `count` - Number of ::SceCtrlData structures to read.
/// @see ::SceCtrlData
/// @see ::sceCtrlPeekBufferNegative()
/// @see ::sceCtrlReadBufferPositive()
pub extern fn sceCtrlPeekBufferPositive(pad_data: [*c]types.SceCtrlData, count: c_int) callconv(.C) c_int;

pub extern fn sceCtrlPeekBufferNegative(pad_data: [*c]types.SceCtrlData, count: c_int) callconv(.C) c_int;

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
pub extern fn sceCtrlReadBufferPositive(pad_data: [*c]types.SceCtrlData, count: c_int) callconv(.C) c_int;

pub extern fn sceCtrlReadBufferNegative(pad_data: [*c]types.SceCtrlData, count: c_int) callconv(.C) c_int;

/// @brief Read latest latch data from the controller service.
/// Latch data contains information about button state changes between two controller service sampling cycles.
/// `latch_data A pointer to ::SceCtrlLatch structure that receives latch data.`
/// Returns On success, the number of times the controller service performed sampling since the last time
/// ::sceCtrlReadLatch() was called.
/// Returns < 0 on error.
/// @see ::SceCtrlLatch
/// @see ::sceCtrlReadLatch()
pub extern fn sceCtrlPeekLatch(latch_data: [*c]types.SceCtrlLatch) callconv(.C) c_int;

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
pub extern fn sceCtrlReadLatch(latch_data: [*c]types.SceCtrlLatch) callconv(.C) c_int;

pub extern fn sceCtrl_348D99D4() callconv(.C) void;

pub extern fn sceCtrl_AF5960F3() callconv(.C) void;

pub extern fn sceCtrlClearRapidFire() callconv(.C) void;

pub extern fn sceCtrlSetRapidFire() callconv(.C) void;

/// Set analog threshold relating to the idle timer.
/// `idlereset` - Movement needed by the analog to reset the idle timer.
/// `idleback` - Movement needed by the analog to bring the PSP back from an idle state.
/// Set to -1 for analog to not cancel idle timer.
/// Set to 0 for idle timer to be cancelled even if the analog is not moved.
/// Set between 1 - 128 to specify the movement on either axis needed by the analog to fire the event.
/// Returns < 0 on error.
pub extern fn sceCtrlSetIdleCancelThreshold(idlereset: c_int, idleback: c_int) callconv(.C) c_int;

/// Get the idle threshold values.
/// `idlerest` - Movement needed by the analog to reset the idle timer.
/// `idleback` - Movement needed by the analog to bring the PSP back from an idle state.
/// Returns < 0 on error.
pub extern fn sceCtrlGetIdleCancelThreshold(idlerest: [*c]c_int, idleback: [*c]c_int) callconv(.C) c_int;

comptime {
    asm (macro.import_module_start("sceCtrl", "0x40010000", "16"));
    asm (macro.import_function("sceCtrl", "0x6A2774F3", "sceCtrlSetSamplingCycle"));
    asm (macro.import_function("sceCtrl", "0x02BAAD91", "sceCtrlGetSamplingCycle"));
    asm (macro.import_function("sceCtrl", "0x1F4011E6", "sceCtrlSetSamplingMode"));
    asm (macro.import_function("sceCtrl", "0xDA6B76A1", "sceCtrlGetSamplingMode"));
    asm (macro.import_function("sceCtrl", "0x3A622550", "sceCtrlPeekBufferPositive"));
    asm (macro.import_function("sceCtrl", "0xC152080A", "sceCtrlPeekBufferNegative"));
    asm (macro.import_function("sceCtrl", "0x1F803938", "sceCtrlReadBufferPositive"));
    asm (macro.import_function("sceCtrl", "0x60B81F86", "sceCtrlReadBufferNegative"));
    asm (macro.import_function("sceCtrl", "0xB1D0E5CD", "sceCtrlPeekLatch"));
    asm (macro.import_function("sceCtrl", "0x0B588501", "sceCtrlReadLatch"));
    asm (macro.import_function("sceCtrl", "0x348D99D4", "sceCtrl_348D99D4"));
    asm (macro.import_function("sceCtrl", "0xAF5960F3", "sceCtrl_AF5960F3"));
    asm (macro.import_function("sceCtrl", "0xA68FD260", "sceCtrlClearRapidFire"));
    asm (macro.import_function("sceCtrl", "0x6841BE1A", "sceCtrlSetRapidFire"));
    asm (macro.import_function("sceCtrl", "0xA7144800", "sceCtrlSetIdleCancelThreshold"));
    asm (macro.import_function("sceCtrl", "0x687660FA", "sceCtrlGetIdleCancelThreshold"));
}
