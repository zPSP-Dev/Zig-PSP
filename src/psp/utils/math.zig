pub const std = @import("std");

pub extern fn mips_div_mod_u32(dividend: u32, divisor: u32, residue_ptr: *u32) u32;

pub fn format_u8(buf: []u8, value: u8) usize {
    return format_u32(buf, @intCast(value));
}

pub fn write_u8(writer: anytype, value: u8) !void {
    var tmp: [3]u8 = undefined; // max "255"
    const len = format_u8(tmp[0..], value);
    if (len == 0) return;
    try writer.writeAll(tmp[0..len]);
}

pub fn format_u16(buf: []u8, value: u16) usize {
    return format_u32(buf, @intCast(value));
}

pub fn write_u16(writer: anytype, value: u16) !void {
    var tmp: [5]u8 = undefined; // max "65535"
    const len = format_u16(tmp[0..], value);
    if (len == 0) return;
    try writer.writeAll(tmp[0..len]);
}

pub fn format_u32(buf: []u8, value: u32) usize {
    if (buf.len == 0) return 0;
    if (value == 0) {
        if (buf.len >= 1) {
            buf[0] = '0';
            return 1;
        }
    }

    var v: u32 = value;
    var digits: [11]u8 = undefined;
    var idx: usize = 0;

    while (v != 0) : (idx += 1) {
        var rem: u32 = 0;
        const q = mips_div_mod_u32(v, 10, &rem);
        const residue: u8 = @intCast(rem);
        digits[idx] = 0x30 + residue;
        v = q;
    }

    if (buf.len < idx) {
        return 0;
    }

    var i: usize = 0;
    while (i < idx) : (i += 1) {
        buf[i] = digits[idx - 1 - i];
    }
    return idx;
}

pub fn write_u32(writer: anytype, value: u32) !void {
    var tmp: [11]u8 = undefined; // max 10 digits + '\0' safety
    const len = format_u32(tmp[0..], value);
    if (len == 0) return; // or return error if you prefer
    try writer.writeAll(tmp[0..len]);
}