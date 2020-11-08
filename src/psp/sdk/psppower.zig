usingnamespace @import("psptypes.zig");

pub const PSPPowerCB = extern enum(u32) {
    Battpower = 0x0000007f,
    BatteryExist = 0x00000080,
    BatteryLow = 0x00000100,
    ACPower = 0x00001000,
    Suspending = 0x00010000,
    Resuming = 0x00020000,
    ResumeComplete = 0x00040000,
    Standby = 0x00080000,
    HoldSwitch = 0x40000000,
    PowerSwitch = 0x80000000,
};

pub const PSPPowerTick = extern enum(u32) {
    All = 0, Suspend = 1, Display = 6
};

pub const powerCallback_t = ?fn (c_int, c_int) callconv(.C) void;

// Register Power Callback Function
//
// @param slot - slot of the callback in the list, 0 to 15, pass -1 to get an auto assignment.
// @param cbid - callback id from calling sceKernelCreateCallback
//
// @return 0 on success, the slot number if -1 is passed, < 0 on error.
pub extern fn scePowerRegisterCallback(slot: c_int, cbid: SceUID) c_int;
pub fn powerRegisterCallback(slot: c_int, cbid: SceUID) !i32 {
    var res = scePowerRegisterCallback(slot, cbid);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Unregister Power Callback Function
//
// @param slot - slot of the callback
//
// @return 0 on success, < 0 on error.
pub extern fn scePowerUnregisterCallback(slot: c_int) c_int;
pub fn powerUnregisterCallback(slot: c_int) !void {
    var res = scePowerUnregisterCallback(slot);
    if (res < 0) {
        return error.Unexpected;
    }
}

// Check if unit is plugged in
//
// @return 1 if plugged in, 0 if not plugged in, < 0 on error.
pub extern fn scePowerIsPowerOnline() c_int;
pub fn powerIsPowerOnline() !bool {
    var res = scePowerIsPowerOnline();
    if (res < 0) {
        return error.Unexpected;
    }
    return res == 1;
}

// Check if a battery is present
//
// @return 1 if battery present, 0 if battery not present, < 0 on error.
pub extern fn scePowerIsBatteryExist() c_int;
pub fn powerIsBatteryExist() !bool {
    var res = scePowerIsBatteryExist();
    if (res < 0) {
        return error.Unexpected;
    }
    return res == 1;
}

// Check if the battery is charging
//
// @return 1 if battery charging, 0 if battery not charging, < 0 on error.
pub extern fn scePowerIsBatteryCharging() c_int;
pub fn powerIsBatteryCharging() !bool {
    var res = scePowerIsBatteryCharging();
    if (res < 0) {
        return error.Unexpected;
    }
    return res == 1;
}

// Get the status of the battery charging
pub extern fn scePowerGetBatteryChargingStatus() c_int;

// Check if the battery is low
//
// @return 1 if the battery is low, 0 if the battery is not low, < 0 on error.
pub extern fn scePowerIsLowBattery() c_int;
pub fn powerIsLowBattery() !bool {
    var res = scePowerIsLowBattery();
    if (res < 0) {
        return error.Unexpected;
    }
    return res == 1;
}

// Get battery life as integer percent
//
// @return Battery charge percentage (0-100), < 0 on error.
pub extern fn scePowerGetBatteryLifePercent() c_int;
pub fn powerGetBatteryLifePercent() !i32 {
    var res = scePowerGetBatteryLifePercent();
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Get battery life as time
//
// @return Battery life in minutes, < 0 on error.
pub extern fn scePowerGetBatteryLifeTime() c_int;
pub fn powerGetBatteryLifeTime() !i32 {
    var res = scePowerGetBatteryLifeTime();
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Get temperature of the battery
pub extern fn scePowerGetBatteryTemp() c_int;

// Get battery volt level
pub extern fn scePowerGetBatteryVolt() c_int;

// Set CPU Frequency
// @param cpufreq - new CPU frequency, valid values are 1 - 333
pub extern fn scePowerSetCpuClockFrequency(cpufreq: c_int) c_int;

// Set Bus Frequency
// @param busfreq - new BUS frequency, valid values are 1 - 167
pub extern fn scePowerSetBusClockFrequency(busfreq: c_int) c_int;

// Alias for scePowerGetCpuClockFrequencyInt
// @return frequency as int
pub extern fn scePowerGetCpuClockFrequency() c_int;

// Get CPU Frequency as Integer
// @return frequency as int
pub extern fn scePowerGetCpuClockFrequencyInt() c_int;

// Get CPU Frequency as Float
// @return frequency as float
pub extern fn scePowerGetCpuClockFrequencyFloat() f32;

// Alias for scePowerGetBusClockFrequencyInt
// @return frequency as int
pub extern fn scePowerGetBusClockFrequency() c_int;

// Get Bus fequency as Integer
// @return frequency as int
pub extern fn scePowerGetBusClockFrequencyInt() c_int;

// Get Bus frequency as Float
// @return frequency as float
pub extern fn scePowerGetBusClockFrequencyFloat() f32;

// Set Clock Frequencies
//
// @param pllfreq - pll frequency, valid from 19-333
// @param cpufreq - cpu frequency, valid from 1-333
// @param busfreq - bus frequency, valid from 1-167
//
// and:
//
// cpufreq <= pllfreq
// busfreq*2 <= pllfreq
//
pub extern fn scePowerSetClockFrequency(pllfreq: c_int, cpufreq: c_int, busfreq: c_int) c_int;

// Lock power switch
//
// Note: if the power switch is toggled while locked
// it will fire immediately after being unlocked.
//
// @param unknown - pass 0
//
// @return 0 on success, < 0 on error.
pub extern fn scePowerLock(unknown: c_int) c_int;
pub fn powerLock(unknown: c_int) !void {
    var res = scePowerLock(unknown);
    if (res < 0) {
        return error.Unexpected;
    }
}

// Unlock power switch
//
// @param unknown - pass 0
//
// @return 0 on success, < 0 on error.
pub extern fn scePowerUnlock(unknown: c_int) c_int;
pub fn powerUnlock(unknown: c_int) !void {
    var res = scePowerUnlock(unknown);
    if (res < 0) {
        return error.Unexpected;
    }
}

// Generate a power tick, preventing unit from
// powering off and turning off display.
//
// @param type - Either PSP_POWER_TICK_ALL, PSP_POWER_TICK_SUSPEND or PSP_POWER_TICK_DISPLAY
//
// @return 0 on success, < 0 on error.
pub extern fn scePowerTick(typec: c_int) c_int;
pub fn powerTick(typec: PSPPowerTick) !void {
    var res = scePowerTick(@enumToInt(typec));
    if (res < 0) {
        return error.Unexpected;
    }
}

// Get Idle timer
pub extern fn scePowerGetIdleTimer() c_int;

// Enable Idle timer
//
// @param unknown - pass 0
pub extern fn scePowerIdleTimerEnable(unknown: c_int) c_int;

// Disable Idle timer
//
// @param unknown - pass 0
pub extern fn scePowerIdleTimerDisable(unknown: c_int) c_int;

// Request the PSP to go into standby
//
// @return 0 always
pub extern fn scePowerRequestStandby() c_int;

// Request the PSP to go into suspend
//
// @return 0 always
pub extern fn scePowerRequestSuspend() c_int;
