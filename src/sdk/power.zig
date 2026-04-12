// Power management -- battery, clock frequency, power callbacks
//
// Wraps:
//   c/module/scePower.zig

const c = @import("../c/modules.zig");
const internal = @import("internal.zig");
const err = @import("errors/power.zig");
const check = err.check;
const checkPositive = err.checkPositive;
const ci = internal.ci;
const cu = internal.cu;
const Error = err.Error;

const pwr = c.scePower;

pub const SceUID = c.types.SceUID;

// -- Power tick ---------------------------------------------------------

pub const TickType = enum(c_int) {
    all = 0,
    @"suspend" = 1,
    display = 6,
};

pub fn tick(tick_type: TickType) Error!void {
    return check(pwr.scePowerTick(@intFromEnum(tick_type)));
}

pub fn get_idle_timer() i32 {
    return pwr.scePowerGetIdleTimer();
}

pub fn idle_timer_enable(unk: u32) Error!void {
    return check(pwr.scePowerIdleTimerEnable(ci(unk)));
}

pub fn idle_timer_disable(unk: u32) Error!void {
    return check(pwr.scePowerIdleTimerDisable(ci(unk)));
}

// -- Battery info -------------------------------------------------------

pub fn is_power_online() bool {
    return pwr.scePowerIsPowerOnline() != 0;
}

pub fn is_battery_exist() bool {
    return pwr.scePowerIsBatteryExist() != 0;
}

pub fn is_battery_charging() bool {
    return pwr.scePowerIsBatteryCharging() != 0;
}

pub fn get_battery_charging_status() i32 {
    return pwr.scePowerGetBatteryChargingStatus();
}

pub fn is_low_battery() bool {
    return pwr.scePowerIsLowBattery() != 0;
}

pub fn is_suspend_required() bool {
    return pwr.scePowerIsSuspendRequired() != 0;
}

pub fn get_battery_remain_capacity() i32 {
    return pwr.scePowerGetBatteryRemainCapacity();
}

pub fn get_battery_full_capacity() i32 {
    return pwr.scePowerGetBatteryFullCapacity();
}

pub fn get_battery_life_percent() i32 {
    return pwr.scePowerGetBatteryLifePercent();
}

pub fn get_battery_life_time() i32 {
    return pwr.scePowerGetBatteryLifeTime();
}

pub fn get_battery_temp() i32 {
    return pwr.scePowerGetBatteryTemp();
}

pub fn get_battery_volt() i32 {
    return pwr.scePowerGetBatteryVolt();
}

// -- Power switch -------------------------------------------------------

pub fn lock(unk: u32) Error!void {
    return check(pwr.scePowerLock(ci(unk)));
}

pub fn unlock(unk: u32) Error!void {
    return check(pwr.scePowerUnlock(ci(unk)));
}

pub fn request_standby() void {
    _ = pwr.scePowerRequestStandby();
}

pub fn request_suspend() void {
    _ = pwr.scePowerRequestSuspend();
}

pub fn request_cold_reset(exitcode: u32) void {
    _ = pwr.scePowerRequestColdReset(ci(exitcode));
}

// -- Callbacks ----------------------------------------------------------

pub fn register_callback(slot: i32, cbid: SceUID) Error!i32 {
    const ret = pwr.scePowerRegisterCallback(@as(c_int, slot), cbid);
    return checkPositive(i32, ret);
}

pub fn unregister_callback(slot: i32) Error!void {
    return check(pwr.scePowerUnregisterCallback(@as(c_int, slot)));
}

// -- Clock frequency ----------------------------------------------------

pub fn set_cpu_clock_frequency(freq: u32) Error!void {
    return check(pwr.scePowerSetCpuClockFrequency(ci(freq)));
}

pub fn set_bus_clock_frequency(freq: u32) Error!void {
    return check(pwr.scePowerSetBusClockFrequency(ci(freq)));
}

pub fn get_cpu_clock_frequency() u32 {
    return cu(pwr.scePowerGetCpuClockFrequency());
}

pub fn get_bus_clock_frequency() u32 {
    return cu(pwr.scePowerGetBusClockFrequency());
}

pub fn get_cpu_clock_frequency_float() f32 {
    return pwr.scePowerGetCpuClockFrequencyFloat();
}

pub fn get_bus_clock_frequency_float() f32 {
    return pwr.scePowerGetBusClockFrequencyFloat();
}

pub fn set_clock_frequency(pll: u32, cpu: u32, bus: u32) Error!void {
    return check(pwr.scePowerSetClockFrequency(ci(pll), ci(cpu), ci(bus)));
}
