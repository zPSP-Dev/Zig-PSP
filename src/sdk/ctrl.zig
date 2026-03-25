// Controller -- gamepad button/analog input
//
// Wraps:
//   c/module/sceCtrl.zig

const int = @import("internal.zig");
const check = int.check;
const checkPositive = int.checkPositive;
const ci = int.ci;
const cu = int.cu;
const c = @import("../c/modules.zig");
const module = c.sceCtrl;

pub const Buttons = c.types.PspCtrlButtons;
pub const Data = c.types.SceCtrlData;
pub const Latch = c.types.SceCtrlLatch;

pub const Mode = enum(u32) {
    /// No analog stick data in `Data`.
    digital = 0,
    /// Analog stick data is present in `Data`.
    analog = 1,
};

pub const Error = int.Error;

/// Set the controller sampling cycle.
/// Normally set to 0.
/// Returns the previous cycle setting.
pub fn set_sampling_cycle(cycle: u32) u32 {
    return cu(module.sceCtrlSetSamplingCycle(ci(cycle)));
}

/// Get the current controller sampling cycle.
pub fn get_sampling_cycle() u32 {
    var pcycle: c_int = undefined;
    _ = module.sceCtrlGetSamplingCycle(&pcycle);
    return cu(pcycle);
}

/// Set the controller mode.
/// In digital mode, no analog stick data is present in `Data`.
/// Returns the previous mode.
pub fn set_sampling_mode(mode: Mode) Mode {
    return @enumFromInt(cu(module.sceCtrlSetSamplingMode(ci(@intFromEnum(mode)))));
}

/// Get the current controller mode.
pub fn get_sampling_mode() Mode {
    var pmode: c_int = undefined;
    _ = module.sceCtrlGetSamplingMode(&pmode);
    return @enumFromInt(cu(pmode));
}

/// Read the latest controller data without waiting.
/// `pad_data` receives button and axis state for each sample.
pub fn peek_buffer_positive(pad_data: []Data) Error!void {
    try check(module.sceCtrlPeekBufferPositive(pad_data.ptr, @intCast(pad_data.len)));
}

/// Read the latest controller data (negative logic) without waiting.
pub fn peek_buffer_negative(pad_data: []Data) Error!void {
    try check(module.sceCtrlPeekBufferNegative(pad_data.ptr, @intCast(pad_data.len)));
}

/// Read new controller data, blocking until the next sampling cycle if needed.
/// `pad_data` receives button and axis state for each sample.
pub fn read_buffer_positive(pad_data: []Data) Error!void {
    try check(module.sceCtrlReadBufferPositive(pad_data.ptr, @intCast(pad_data.len)));
}

/// Read new controller data (negative logic), blocking until the next sampling cycle if needed.
pub fn read_buffer_negative(pad_data: []Data) Error!void {
    try check(module.sceCtrlReadBufferNegative(pad_data.ptr, @intCast(pad_data.len)));
}

/// Peek at the latest latch data without consuming it.
/// Returns the number of sampling cycles since the last `read_latch` call.
pub fn peek_latch(latch_data: *Latch) Error!u32 {
    return checkPositive(u32, module.sceCtrlPeekLatch(latch_data));
}

/// Read new latch data, consuming it. Blocks until the next sampling cycle if needed.
/// Latch data tracks button state transitions between sampling cycles.
/// Returns the number of sampling cycles since the last `read_latch` call.
pub fn read_latch(latch_data: *Latch) Error!u32 {
    return checkPositive(u32, module.sceCtrlReadLatch(latch_data));
}

pub fn set_suspending_extra_samples() void {
    module.sceCtrlSetSuspendingExtraSamples();
}

pub fn get_suspending_extra_samples() void {
    module.sceCtrlGetSuspendingExtraSamples();
}

pub fn clear_rapid_fire() void {
    module.sceCtrlClearRapidFire();
}

pub fn set_rapid_fire() void {
    module.sceCtrlSetRapidFire();
}

/// Set analog threshold relating to the idle timer.
/// `idlereset` - Movement needed by the analog to reset the idle timer.
/// `idleback` - Movement needed by the analog to bring the PSP back from idle.
/// Set to -1 for analog to not cancel idle timer.
/// Set to 0 for idle timer to be cancelled even if the analog is not moved.
/// Set between 1-128 to specify the movement needed on either axis.
pub fn set_idle_cancel_threshold(idlereset: i32, idleback: i32) Error!void {
    try check(module.sceCtrlSetIdleCancelThreshold(idlereset, idleback));
}

/// Get the idle threshold values.
pub fn get_idle_cancel_threshold() Error!struct { idlereset: i32, idleback: i32 } {
    var idlereset: c_int = undefined;
    var idleback: c_int = undefined;
    try check(module.sceCtrlGetIdleCancelThreshold(&idlereset, &idleback));
    return .{ .idlereset = idlereset, .idleback = idleback };
}
