// Kermit peripheral interface (PSP Go internal bus)
//
// Wraps:
//   c/module/sceKermitPeripheral.zig
//
// Note: All functions in this module are undocumented NID-only stubs
// with no known parameters or return values. Re-exported here for
// completeness; wrap as signatures become known.

const c = @import("../c/modules.zig");

const kermit = c.sceKermitPeripheral;

pub const peripheral_4A26B7C8 = kermit.sceKermitPeripheral_4A26B7C8;
pub const peripheral_C0EBC631 = kermit.sceKermitPeripheral_C0EBC631;
pub const peripheral_D27C5E03 = kermit.sceKermitPeripheral_D27C5E03;
