usingnamespace @import("psptypes.zig");

pub extern fn sceSysconPowerStandby() void;
pub extern fn sceSysconResetDevice(unk1: c_int, unk2: c_int) void;
pub extern fn sceSysconCtrlLED(led: c_int, state: c_int) c_int;
pub extern fn sceSysconCtrlHRPower(power: c_int) c_int;
pub extern fn sceSysconGetHPConnect() c_int;
pub extern fn sceSysconSetHPConnectCallback(?fn (c_int) callconv(.C) void, unk0: c_int) c_int;
pub extern fn sceSysconSetHRPowerCallback(?fn (c_int) callconv(.C) void, unk0: c_int) c_int;

pub const SCE_LED_POWER = 1;

pub const LedState = extern enum(c_int){
    On = 1,
    Off = 0
};