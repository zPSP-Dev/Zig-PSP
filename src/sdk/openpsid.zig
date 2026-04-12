// PSP Open PSID (unique console identifier)
//
// Wraps:
//   c/module/sceOpenPSID.zig

const c = @import("../c/modules.zig");
const err = @import("errors/openpsid.zig");
const check = err.check;
const Error = err.Error;

pub const OpenPSID = c.types.PspOpenPSID;

/// Get the console's unique OpenPSID.
pub fn get_open_psid(psid: *OpenPSID) Error!void {
    return check(c.sceOpenPSID.sceOpenPSIDGetOpenPSID(psid));
}
