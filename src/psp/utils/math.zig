pub extern fn mips_div_mod_u32(dividend: u32, divisor: u32, residue_ptr: *u32) u32;

pub fn format_u8(buf: []u8, value: u8) usize {
    return format_u32(buf, @intCast(value));
}

pub fn format_u16(buf: []u8, value: u16) usize {
    return format_u32(buf, @intCast(value));
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
