// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

pub extern fn sceKermitPeripheral_4A26B7C8() callconv(.c) void;

pub extern fn sceKermitPeripheral_C0EBC631() callconv(.c) void;

pub extern fn sceKermitPeripheral_D27C5E03() callconv(.c) void;

comptime {
    asm (macro.import_module_start("sceKermitPeripheral", "0x40090000", "3"));
    asm (macro.import_function("sceKermitPeripheral", "0x4A26B7C8", "sceKermitPeripheral_4A26B7C8"));
    asm (macro.import_function("sceKermitPeripheral", "0xC0EBC631", "sceKermitPeripheral_C0EBC631"));
    asm (macro.import_function("sceKermitPeripheral", "0xD27C5E03", "sceKermitPeripheral_D27C5E03"));
}
