// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

pub extern fn scePowerGetWlanActivity() callconv(.c) void;

pub extern fn scePowerGetBacklightMaximum() callconv(.c) void;

/// Generate a power tick, preventing unit from
/// powering off and turning off display.
/// `type` - Either PSP_POWER_TICK_ALL, PSP_POWER_TICK_SUSPEND or PSP_POWER_TICK_DISPLAY
/// Returns 0 on success, < 0 on error.
pub extern fn scePowerTick(type: c_int) callconv(.c) c_int;

/// Get Idle timer
pub extern fn scePowerGetIdleTimer() callconv(.c) c_int;

/// Enable Idle timer
/// `unknown` - pass 0
pub extern fn scePowerIdleTimerEnable(unknown: c_int) callconv(.c) c_int;

/// Disable Idle timer
/// `unknown` - pass 0
pub extern fn scePowerIdleTimerDisable(unknown: c_int) callconv(.c) c_int;

pub extern fn scePowerBatteryUpdateInfo() callconv(.c) void;

pub extern fn scePowerGetForceSuspendCapacity() callconv(.c) void;

pub extern fn scePowerGetLowBatteryCapacity() callconv(.c) void;

/// Check if unit is plugged in
/// Returns 1 if plugged in, 0 if not plugged in, < 0 on error.
pub extern fn scePowerIsPowerOnline() callconv(.c) c_int;

/// Check if a battery is present
/// Returns 1 if battery present, 0 if battery not present, < 0 on error.
pub extern fn scePowerIsBatteryExist() callconv(.c) c_int;

/// Check if the battery is charging
/// Returns 1 if battery charging, 0 if battery not charging, < 0 on error.
pub extern fn scePowerIsBatteryCharging() callconv(.c) c_int;

/// Get the status of the battery charging
pub extern fn scePowerGetBatteryChargingStatus() callconv(.c) c_int;

/// Check if the battery is low
/// Returns 1 if the battery is low, 0 if the battery is not low, < 0 on error.
pub extern fn scePowerIsLowBattery() callconv(.c) c_int;

/// Check if a suspend is required
/// Returns 1 if suspend is required, 0 otherwise
pub extern fn scePowerIsSuspendRequired() callconv(.c) c_int;

/// Returns battery remaining capacity
/// Returns battery remaining capacity in mAh (milliampere hour)
pub extern fn scePowerGetBatteryRemainCapacity() callconv(.c) c_int;

/// Returns battery full capacity
/// Returns battery full capacity in mAh (milliampere hour)
pub extern fn scePowerGetBatteryFullCapacity() callconv(.c) c_int;

/// Get battery life as integer percent
/// Returns Battery charge percentage (0-100), < 0 on error.
pub extern fn scePowerGetBatteryLifePercent() callconv(.c) c_int;

/// Get battery life as time
/// Returns Battery life in minutes, < 0 on error.
pub extern fn scePowerGetBatteryLifeTime() callconv(.c) c_int;

/// Get temperature of the battery
pub extern fn scePowerGetBatteryTemp() callconv(.c) c_int;

/// unknown? - crashes PSP in usermode
pub extern fn scePowerGetBatteryElec() callconv(.c) c_int;

/// Get battery volt level
pub extern fn scePowerGetBatteryVolt() callconv(.c) c_int;

pub extern fn scePowerGetInnerTemp() callconv(.c) void;

pub extern fn scePowerSetPowerSwMode() callconv(.c) void;

pub extern fn scePowerGetPowerSwMode() callconv(.c) void;

/// Lock power switch
/// Note: if the power switch is toggled while locked
/// it will fire immediately after being unlocked.
/// `unknown` - pass 0
/// Returns 0 on success, < 0 on error.
pub extern fn scePowerLock(unknown: c_int) callconv(.c) c_int;

/// Unlock power switch
/// `unknown` - pass 0
/// Returns 0 on success, < 0 on error.
pub extern fn scePowerUnlock(unknown: c_int) callconv(.c) c_int;

pub extern fn scePowerCancelRequest() callconv(.c) void;

pub extern fn scePowerIsRequest() callconv(.c) void;

/// Request the PSP to go into standby
/// Returns 0 always
pub extern fn scePowerRequestStandby() callconv(.c) c_int;

/// Request the PSP to go into suspend
/// Returns 0 always
pub extern fn scePowerRequestSuspend() callconv(.c) c_int;

pub extern fn scePowerRequestSuspendTouchAndGo() callconv(.c) void;

pub extern fn scePowerEncodeUBattery() callconv(.c) void;

pub extern fn scePowerGetResumeCount() callconv(.c) void;

/// Register Power Callback Function
/// `slot` - slot of the callback in the list, 0 to 15, pass -1 to get an auto assignment.
/// `cbid` - callback id from calling sceKernelCreateCallback
/// Returns 0 on success, the slot number if -1 is passed, < 0 on error.
pub extern fn scePowerRegisterCallback(slot: c_int, cbid: types.SceUID) callconv(.c) c_int;

/// Unregister Power Callback Function
/// `slot` - slot of the callback
/// Returns 0 on success, < 0 on error.
pub extern fn scePowerUnregisterCallback(slot: c_int) callconv(.c) c_int;

pub extern fn scePowerUnregitserCallback() callconv(.c) void;

/// Set CPU Frequency
/// `cpufreq` - new CPU frequency, valid values are 1 - 333
pub extern fn scePowerSetCpuClockFrequency(cpufreq: c_int) callconv(.c) c_int;

/// Set Bus Frequency
/// `busfreq` - new BUS frequency, valid values are 1 - 167
pub extern fn scePowerSetBusClockFrequency(busfreq: c_int) callconv(.c) c_int;

/// Alias for scePowerGetCpuClockFrequencyInt
/// Returns frequency as int
pub extern fn scePowerGetCpuClockFrequency() callconv(.c) c_int;

/// Alias for scePowerGetBusClockFrequencyInt
/// Returns frequency as int
pub extern fn scePowerGetBusClockFrequency() callconv(.c) c_int;

/// Get CPU Frequency as Integer
/// Returns frequency as int
pub extern fn scePowerGetCpuClockFrequencyInt() callconv(.c) c_int;

/// Get Bus fequency as Integer
/// Returns frequency as int
pub extern fn scePowerGetBusClockFrequencyInt() callconv(.c) c_int;

/// Get CPU Frequency as Float
/// Returns frequency as float
pub extern fn scePowerGetCpuClockFrequencyFloat() callconv(.c) f32;

/// Get Bus frequency as Float
/// Returns frequency as float
pub extern fn scePowerGetBusClockFrequencyFloat() callconv(.c) f32;

/// Set Clock Frequencies
/// `pllfreq` - pll frequency, valid from 19-333
/// `cpufreq` - cpu frequency, valid from 1-333
/// `busfreq` - bus frequency, valid from 1-167
/// and:
/// cpufreq <= pllfreq
/// busfreq*2 <= pllfreq
pub extern fn scePowerSetClockFrequency(pllfreq: c_int, cpufreq: c_int, busfreq: c_int) callconv(.c) c_int;

/// Request the PSP to do a cold reboot.
/// `exitcode pass 0`
/// Returns 0 always
pub extern fn scePowerRequestColdReset(exitcode: c_int) callconv(.c) c_int;

comptime {
    asm (macro.import_module_start("scePower", "0x40010000", "47"));
    asm (macro.import_function("scePower", "0x2B51FE2F", "scePowerGetWlanActivity"));
    asm (macro.import_function("scePower", "0x442BFBAC", "scePowerGetBacklightMaximum"));
    asm (macro.import_function("scePower", "0xEFD3C963", "scePowerTick"));
    asm (macro.import_function("scePower", "0xEDC13FE5", "scePowerGetIdleTimer"));
    asm (macro.import_function("scePower", "0x7F30B3B1", "scePowerIdleTimerEnable"));
    asm (macro.import_function("scePower", "0x972CE941", "scePowerIdleTimerDisable"));
    asm (macro.import_function("scePower", "0x27F3292C", "scePowerBatteryUpdateInfo"));
    asm (macro.import_function("scePower", "0xE8E4E204", "scePowerGetForceSuspendCapacity"));
    asm (macro.import_function("scePower", "0xB999184C", "scePowerGetLowBatteryCapacity"));
    asm (macro.import_function("scePower", "0x87440F5E", "scePowerIsPowerOnline"));
    asm (macro.import_function("scePower", "0x0AFD0D8B", "scePowerIsBatteryExist"));
    asm (macro.import_function("scePower", "0x1E490401", "scePowerIsBatteryCharging"));
    asm (macro.import_function("scePower", "0xB4432BC8", "scePowerGetBatteryChargingStatus"));
    asm (macro.import_function("scePower", "0xD3075926", "scePowerIsLowBattery"));
    asm (macro.import_function("scePower", "0x78A1A796", "scePowerIsSuspendRequired"));
    asm (macro.import_function("scePower", "0x94F5A53F", "scePowerGetBatteryRemainCapacity"));
    asm (macro.import_function("scePower", "0xFD18A0FF", "scePowerGetBatteryFullCapacity"));
    asm (macro.import_function("scePower", "0x2085D15D", "scePowerGetBatteryLifePercent"));
    asm (macro.import_function("scePower", "0x8EFB3FA2", "scePowerGetBatteryLifeTime"));
    asm (macro.import_function("scePower", "0x28E12023", "scePowerGetBatteryTemp"));
    asm (macro.import_function("scePower", "0x862AE1A6", "scePowerGetBatteryElec"));
    asm (macro.import_function("scePower", "0x483CE86B", "scePowerGetBatteryVolt"));
    asm (macro.import_function("scePower", "0x23436A4A", "scePowerGetInnerTemp"));
    asm (macro.import_function("scePower", "0x0CD21B1F", "scePowerSetPowerSwMode"));
    asm (macro.import_function("scePower", "0x165CE085", "scePowerGetPowerSwMode"));
    asm (macro.import_function("scePower", "0xD6D016EF", "scePowerLock"));
    asm (macro.import_function("scePower", "0xCA3D34C1", "scePowerUnlock"));
    asm (macro.import_function("scePower", "0xDB62C9CF", "scePowerCancelRequest"));
    asm (macro.import_function("scePower", "0x7FA406DD", "scePowerIsRequest"));
    asm (macro.import_function("scePower", "0x2B7C7CF4", "scePowerRequestStandby"));
    asm (macro.import_function("scePower", "0xAC32C9CC", "scePowerRequestSuspend"));
    asm (macro.import_function("scePower", "0x2875994B", "scePowerRequestSuspendTouchAndGo"));
    asm (macro.import_function("scePower", "0x3951AF53", "scePowerEncodeUBattery"));
    asm (macro.import_function("scePower", "0x0074EF9B", "scePowerGetResumeCount"));
    asm (macro.import_function("scePower", "0x04B7766E", "scePowerRegisterCallback"));
    asm (macro.import_function("scePower", "0xDFA8BAF8", "scePowerUnregisterCallback"));
    asm (macro.import_function("scePower", "0xDB9D28DD", "scePowerUnregitserCallback"));
    asm (macro.import_function("scePower", "0x843FBF43", "scePowerSetCpuClockFrequency"));
    asm (macro.import_function("scePower", "0xB8D7B3FB", "scePowerSetBusClockFrequency"));
    asm (macro.import_function("scePower", "0xFEE03A2F", "scePowerGetCpuClockFrequency"));
    asm (macro.import_function("scePower", "0x478FE6F5", "scePowerGetBusClockFrequency"));
    asm (macro.import_function("scePower", "0xFDB5BFE9", "scePowerGetCpuClockFrequencyInt"));
    asm (macro.import_function("scePower", "0xBD681969", "scePowerGetBusClockFrequencyInt"));
    asm (macro.import_function("scePower", "0xB1A52C83", "scePowerGetCpuClockFrequencyFloat"));
    asm (macro.import_function("scePower", "0x9BADB3EB", "scePowerGetBusClockFrequencyFloat"));
    asm (macro.import_function("scePower", "0x737486F2", "scePowerSetClockFrequency"));
    asm (macro.import_function("scePower", "0x0442D852", "scePowerRequestColdReset"));
}
