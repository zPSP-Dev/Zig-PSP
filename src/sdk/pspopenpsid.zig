const c = @import("libzpsp");

pub const PspOpenPSID = c.types.PspOpenPSID;

pub extern fn sceOpenPSIDGetOpenPSID(openpsid: *PspOpenPSID) c_int;
