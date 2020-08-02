usingnamespace @import("psptypes.zig");

pub const powerCallback_t = ?fn (c_int, c_int) callconv(.C) void;
pub extern fn scePowerRegisterCallback(slot: c_int, cbid: SceUID) c_int;
pub extern fn scePowerUnregisterCallback(slot: c_int) c_int;
pub extern fn scePowerIsPowerOnline() c_int;
pub extern fn scePowerIsBatteryExist() c_int;
pub extern fn scePowerIsBatteryCharging() c_int;
pub extern fn scePowerGetBatteryChargingStatus() c_int;
pub extern fn scePowerIsLowBattery() c_int;
pub extern fn scePowerGetBatteryLifePercent() c_int;
pub extern fn scePowerGetBatteryLifeTime() c_int;
pub extern fn scePowerGetBatteryTemp() c_int;
pub extern fn scePowerGetBatteryElec() c_int;
pub extern fn scePowerGetBatteryVolt() c_int;
pub extern fn scePowerSetCpuClockFrequency(cpufreq: c_int) c_int;
pub extern fn scePowerSetBusClockFrequency(busfreq: c_int) c_int;
pub extern fn scePowerGetCpuClockFrequency() c_int;
pub extern fn scePowerGetCpuClockFrequencyInt() c_int;
pub extern fn scePowerGetCpuClockFrequencyFloat() f32;
pub extern fn scePowerGetBusClockFrequency() c_int;
pub extern fn scePowerGetBusClockFrequencyInt() c_int;
pub extern fn scePowerGetBusClockFrequencyFloat() f32;
pub extern fn scePowerSetClockFrequency(pllfreq: c_int, cpufreq: c_int, busfreq: c_int) c_int;
pub extern fn scePowerLock(unknown: c_int) c_int;
pub extern fn scePowerUnlock(unknown: c_int) c_int;
pub extern fn scePowerTick(type: c_int) c_int;
pub extern fn scePowerGetIdleTimer() c_int;
pub extern fn scePowerIdleTimerEnable(unknown: c_int) c_int;
pub extern fn scePowerIdleTimerDisable(unknown: c_int) c_int;
pub extern fn scePowerRequestStandby() c_int;
pub extern fn scePowerRequestSuspend() c_int;

pub const PSPPowerCB = extern enum(u32){
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

pub const PSPPowerTick = extern enum(u32){
    All = 0,
    Suspend = 1,
    Display = 6
};