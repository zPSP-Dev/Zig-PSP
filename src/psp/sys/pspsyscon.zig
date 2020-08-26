usingnamespace @import("psptypes.zig");

pub extern fn sceSysconPowerStandby() void;
pub extern fn sceSysconResetDevice(unk1: c_int, unk2: c_int) void;
pub extern fn sceSysconCtrlLED(led: c_int, state: c_int) c_int;
pub extern fn sceSysconCtrlHRPower(power: c_int) c_int;
pub extern fn sceSysconGetHPConnect() c_int;

pub const SCE_LED_POWER = 1;

pub const LedState = extern enum(c_int){
    On = 1,
    Off = 0
};

const macro = @import("pspmacros.zig");

comptime{
    asm(macro.import_module_start("sceSyscon_driver", "0x00010000", "5"));
    asm(macro.import_function("sceSyscon_driver", "0xC8439C57", "sceSysconPowerStandby"));
    asm(macro.import_function("sceSyscon_driver", "0x8CBC7987", "sceSysconResetDevice"));
    asm(macro.import_function("sceSyscon_driver", "0x18BFBE65", "sceSysconCtrlLED"));
    asm(macro.import_function("sceSyscon_driver", "0x44439604", "sceSysconCtrlHRPower"));
    asm(macro.import_function("sceSyscon_driver", "0xE0DDFE18", "sceSysconGetHPConnect"));
}
