usingnamespace @import("psptypes.zig");

pub extern fn sceSysregMeResetEnable() c_int;
pub extern fn sceSysregMeResetDisable() c_int;
pub extern fn sceSysregVmeResetEnable() c_int;
pub extern fn sceSysregVmeResetDisable() c_int;
pub extern fn sceSysregMeBusClockEnable() c_int;
pub extern fn sceSysregMeBusClockDisable() c_int;
