pub const struct_PspOpenPSID = extern struct {
    data: [16]u8,
};
pub const PspOpenPSID = struct_PspOpenPSID;
pub extern fn sceOpenPSIDGetOpenPSID(openpsid: [*c]PspOpenPSID) c_int;

const macro = @import("pspmacros.zig");

comptime{
    asm(macro.import_module_start("sceOpenPSID", "0x40010011", "18"));
    asm(macro.import_function("sceOpenPSID", "0xC69BEBCE", "sceOpenPSIDGetOpenPSID"));
}