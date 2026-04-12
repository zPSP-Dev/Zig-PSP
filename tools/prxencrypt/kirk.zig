// See also: https://www.psdevwiki.com/psp/Kirk

const std = @import("std");

// Zig port of kirk_CMD0 from kirk_engine.c.
// Reads the decrypted AES/CMAC keys from in[0..32], AES-CBC encrypts the data
// section, computes CMAC hashes, then re-encrypts the key block with KIRK1_KEY.
// Note: main restores raw_header_bk over out[0..0x90] after this call, so
// the CMAC and key-reencrypt writes are cosmetic — only the data encrypt matters.
pub fn cmd0(out: []u8, in: []const u8) !void {
    const in_kirk_header = std.mem.bytesAsValue(KirkHeader, in[0..0x90]);

    if (in_kirk_header.mode != 1) {
        return error.UnsupportedMode;
    }

    const data_size = in_kirk_header.data_size;
    const data_offset = in_kirk_header.data_offset;

    var chk_size = data_size;
    if (chk_size % 16 != 0) chk_size += 16 - (chk_size % 16);

    const data_start = @sizeOf(KirkHeader) + @as(usize, data_offset);

    // Copy header + pre-data region so CMAC reads from out are coherent
    @memcpy(out[0..data_start], in[0..data_start]);

    // Encrypt data: in[data_start..] → out[data_start..] with decrypted AES key
    aes_cbc_encrypt(in_kirk_header.aes_key, in[data_start..][0..chk_size], out[data_start..][0..chk_size]);

    // CMAC header hash over out[0x60..0x90] → out[0x20..0x30]
    var cmac_header_hash: [16]u8 = undefined;
    std.crypto.auth.cmac.CmacAes128.create(&cmac_header_hash, out[0x60..][0..0x30], out[16..32]);
    @memcpy(out[0x20..][0..16], &cmac_header_hash);

    // CMAC data hash over out[0x60..0x60+0x30+data_offset+chk_size] → out[0x30..0x40]
    const data_cmac_len = @as(usize, 0x30) + @as(usize, data_offset) + chk_size;
    var cmac_data_hash: [16]u8 = undefined;
    std.crypto.auth.cmac.CmacAes128.create(&cmac_data_hash, out[0x60..][0..data_cmac_len], out[16..32]);
    @memcpy(out[0x30..][0..16], &cmac_data_hash);

    // Re-encrypt key block (in[0..32]) with KEY1 → out[0..32]
    aes_cbc_encrypt(KEY1, in[0..32], out[0..32]);
}

// AES-128-CBC encryption with zero IV. src and dst must be the same length
// and a multiple of 16. src and dst may be different buffers (no in-place).
fn aes_cbc_encrypt(key: [16]u8, src: []const u8, dst: []u8) void {
    const enc = std.crypto.core.aes.Aes128.initEnc(key);
    var iv = [_]u8{0} ** 16;
    var i: usize = 0;
    while (i < src.len) : (i += 16) {
        var block: [16]u8 = undefined;
        for (&block, src[i..][0..16], iv) |*b, s, v| b.* = s ^ v;
        enc.encrypt(&iv, &block);
        @memcpy(dst[i..][0..16], &iv);
    }
}

pub const KEY1 = [16]u8{ 0x98, 0xC9, 0x40, 0x97, 0x5C, 0x1D, 0x10, 0xE8, 0x7F, 0xE6, 0x0E, 0xA3, 0xFD, 0x03, 0xA8, 0xBA };

// The layout might change depending on the kirk command
pub const KirkHeader = extern struct {
    aes_key: [16]u8, // 0x00
    cmac_key: [16]u8, // 0x10
    cmac_header_hash: [16]u8, // 0x20
    cmac_data_hash: [16]u8, // 0x30
    unused: [32]u8, // 0x40
    mode: u32, // 0x60
    unk3: [12]u8, // 0x64
    data_size: u32, // 0x70
    data_offset: u32, // 0x74
    unk4: [8]u8, // 0x78
    unk5: [16]u8, // 0x80
};

comptime {
    std.debug.assert(@sizeOf(KirkHeader) == 0x90);
}
