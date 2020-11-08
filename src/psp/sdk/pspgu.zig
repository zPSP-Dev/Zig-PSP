usingnamespace @import("psptypes.zig");
usingnamespace @import("pspge.zig");
pub usingnamespace @import("pspgutypes.zig");
pub usingnamespace @import("pspguimpl.zig");

pub fn abgr(a: u8, b: u8, g: u8, r: u8) u32 {
    return @as(u32, r) | (@as(u32, g) << 8) | (@as(u32, b) << 16) | (@as(u32, a) << 24);
}

pub fn argb(a: u8, r: u8, g: u8, b: u8) u32 {
    return abgr(a, b, g, r);
}

pub fn rgba(r: u8, g: u8, b: u8, a: u8) u32 {
    return argb(a, r, g, b);
}

pub fn color(r: f32, g: f32, b: f32, a: f32) u32 {
    return rgba(@as(u8, (r * 255.0)), @as(u8, (g * 255.0)), @as(u8, (b * 255.0)), @as(u8, (a * 255.0)));
}
