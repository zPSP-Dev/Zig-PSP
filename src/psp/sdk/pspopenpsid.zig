pub const struct_PspOpenPSID = extern struct {
    data: [16]u8,
};
pub const PspOpenPSID = struct_PspOpenPSID;
pub extern fn sceOpenPSIDGetOpenPSID(openpsid: [*c]PspOpenPSID) c_int;
