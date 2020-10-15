pub const PspOpenPSID = extern struct {
    data: [16]u8,
};

pub extern fn sceOpenPSIDGetOpenPSID(openpsid: *PspOpenPSID) c_int;
