usingnamespace @import("psptypes.zig");

pub extern fn sceSysregMeResetEnable() c_int;
pub extern fn sceSysregMeResetDisable() c_int;
pub extern fn sceSysregVmeResetEnable() c_int;
pub extern fn sceSysregVmeResetDisable() c_int;
pub extern fn sceSysregMeBusClockEnable() c_int;
pub extern fn sceSysregMeBusClockDisable() c_int;

const macro = @import("pspmacros.zig");

comptime{
    asm(macro.import_module_start("sceSysreg_driver", "0x00010000", "6"));
    asm(macro.import_function("sceSysreg_driver", "0x44F6CDA7", "sceSysregMeBusClockEnable"));
    asm(macro.import_function("sceSysreg_driver", "0x158AD4FC", "sceSysregMeBusClockDisable"));
    asm(macro.import_function("sceSysreg_driver", "0xDE59DACB", "sceSysregMeResetEnable"));
    asm(macro.import_function("sceSysreg_driver", "0x2DB0EB28", "sceSysregMeResetDisable"));
    asm(macro.import_function("sceSysreg_driver", "0xD20581EA", "sceSysregVmeResetEnable"));
    asm(macro.import_function("sceSysreg_driver", "0x7558064A", "sceSysregVmeResetDisable"));
}
