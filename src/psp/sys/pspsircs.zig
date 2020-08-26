usingnamespace @import("psptypes.zig");

pub const struct_sircs_data = extern struct {
    type: u8,
    cmd: u8,
    dev: u16,
};
pub export var __packed__: struct_sircs_data = undefined;
pub extern fn sceSircsSend(sd: [*c]struct_sircs_data, count: c_int) c_int;
pub const sircs_data = struct_sircs_data;

const macro = @import("pspmacros.zig");

comptime{
    asm(macro.import_module_start("sceSircs", "0x40010000", "1"));
    asm(macro.import_function("sceSircs", "0x71EEF62D", "sceSircsSend"));
}