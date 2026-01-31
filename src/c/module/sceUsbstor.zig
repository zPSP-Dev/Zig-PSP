// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

pub extern fn sceUsbstorGetStatus() callconv(.c) void;

comptime {
    asm (macro.import_module_start("sceUsbstor", "0x40090000", "1"));
    asm (macro.import_function("sceUsbstor", "0x60066CFE", "sceUsbstorGetStatus"));
}
