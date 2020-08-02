usingnamespace @import("psptypes.zig");

pub const struct_sircs_data = extern struct {
    type: u8,
    cmd: u8,
    dev: u16,
};
pub export var __packed__: struct_sircs_data = undefined;
pub extern fn sceSircsSend(sd: [*c]struct_sircs_data, count: c_int) c_int;
pub const sircs_data = struct_sircs_data;
