const c = @import("../c/modules.zig");

pub const PspOpenPSID = c.types.PspOpenPSID;

pub extern fn sceOpenPSIDGetOpenPSID(openpsid: *PspOpenPSID) c_int;
