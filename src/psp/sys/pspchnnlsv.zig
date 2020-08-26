pub const struct__pspChnnlsvContext1 = extern struct {
    mode: c_int,
    buffer1: [16]u8,
    buffer2: [16]u8,
    unknown: c_int,
};
pub const pspChnnlsvContext1 = struct__pspChnnlsvContext1;
pub const struct__pspChnnlsvContext2 = extern struct {
    unknown: [256]u8,
};
pub const pspChnnlsvContext2 = struct__pspChnnlsvContext2;
pub extern fn sceChnnlsv_E7833020(ctx: [*c]pspChnnlsvContext1, mode: c_int) c_int;
pub extern fn sceChnnlsv_F21A1FCA(ctx: [*c]pspChnnlsvContext1, data: [*c]u8, len: c_int) c_int;
pub extern fn sceChnnlsv_C4C494F8(ctx: [*c]pspChnnlsvContext1, hash: [*c]u8, cryptkey: [*c]u8) c_int;
pub extern fn sceChnnlsv_ABFDFC8B(ctx: [*c]pspChnnlsvContext2, mode1: c_int, mode2: c_int, hashkey: [*c]u8, cipherkey: [*c]u8) c_int;
pub extern fn sceChnnlsv_850A7FA1(ctx: [*c]pspChnnlsvContext2, data: [*c]u8, len: c_int) c_int;
pub extern fn sceChnnlsv_21BE78B4(ctx: [*c]pspChnnlsvContext2) c_int;

pub const _pspChnnlsvContext1 = struct__pspChnnlsvContext1;
pub const _pspChnnlsvContext2 = struct__pspChnnlsvContext2;

const macro = @import("pspmacros.zig");

comptime{
    asm(macro.import_module_start("sceChnnlsv", "0x40010000", "6"));
    asm(macro.import_function("sceChnnlsv", "0xE7833020", "sceChnnlsv_E7833020"));
    asm(macro.import_function("sceChnnlsv", "0xF21A1FCA", "sceChnnlsv_F21A1FCA"));
    asm(macro.import_function("sceChnnlsv", "0xC4C494F8", "sceChnnlsv_C4C494F8"));
    asm(macro.import_function("sceChnnlsv", "0xABFDFC8B", "sceChnnlsv_ABFDFC8B"));
    asm(macro.import_function("sceChnnlsv", "0x850A7FA1", "sceChnnlsv_850A7FA1"));
    asm(macro.import_function("sceChnnlsv", "0x21BE78B4", "sceChnnlsv_21BE78B4"));
}