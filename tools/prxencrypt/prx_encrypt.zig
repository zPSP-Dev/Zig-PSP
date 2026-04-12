// This tool is mostly based on PrxEncrypter-Mod.
// See: https://github.com/ErikPshat/PrxEncrypter-Mod
//
// It also used struct layouts from a pspdecrypt fork.
// See: https://github.com/Linblow/pspdecrypt
//
// Those resources were also helpful:
// - https://www.psdevwiki.com/psp/Kirk
// - https://www.psdevwiki.com/psp/PRX_File_Format
//
// Thank you all for your hard work!

const std = @import("std");

const header_sets = @import("header_sets.zig");
const prx = @import("prx_format.zig");
const kirk = @import("kirk.zig");

// This takes a PRX file as input and outputs a PSP executable.
// It uses the header of an officially encrypted PRX which we can't edit (see header_sets.ALL_SETS)
// We then encrypt our own PRX payload in such a way that is matches the header's declared PRX size and CMAC hashes.
// This is why there's a size limit on the input PRX. We pad with zeroes in the opposite case.
// Once done we just write the immutable header followed by the encrypted payload, and the PSP loader accepts it as a valid PRX.
//
// NOTES:
// - Little endian is assumed throughout!
// - Possibly there's a bug where we're not reserving enough data for the last 16 bytes to forge the CMAC.
pub fn encrypt(allocator: std.mem.Allocator, prx_reader: *std.Io.Reader, input_prx_size: usize, psp_writer: *std.Io.Writer) !void {
    const magic = prx_reader.peek(4) catch |err| {
        std.debug.print("error: failed to read magic\n", .{});
        return err;
    };

    if (!std.mem.eql(u8, magic, prx.ELF_MAGIC)) {
        std.debug.print("error: invalid magic: got '{s}', expected '{s}'\n", .{ magic, prx.ELF_MAGIC });
        return error.InvalidMagic;
    }

    const headers = for (header_sets.ALL_SETS) |header_set| {
        if (input_prx_size <= header_set.psp_full_header.psp_header.prx_size) {
            break header_set;
        }
    } else {
        // We can't change the header's declared prx_size without breaking the CMAC, so reject large PRXs upfront.
        // Smaller PRX files will fit because we just pad with zeros later!
        std.debug.print("error: invalid PRX size: {} is too big\n", .{input_prx_size});
        return error.PRXTooLarge;
    };

    // Verify the hardcoded header can accommodate the loaded PRX
    const psp_full_header = headers.psp_full_header;
    const psp_header = psp_full_header.psp_header;

    // Override our PRX size with the original header one. We pad with zeros.
    const prx_size = psp_header.prx_size;

    const compressed_prx_buf = try allocator.alloc(u8, prx_size); // Allocate for worst case
    defer allocator.free(compressed_prx_buf);

    @memset(compressed_prx_buf, 0);

    switch (psp_header.compression_attributes) {
        .NONE => {
            // No compression, just copy the PRX as-is.
            const read_bytes = try prx_reader.readSliceShort(compressed_prx_buf);
            std.debug.assert(read_bytes == input_prx_size);
        },
        .COMPRESSED => {
            // Gzip-compress prx using std.compress.
            // std's gzip header is constant, so output is deterministic.

            // Growing output writer backed by the arena; pre-size to prx_size as upper bound
            var gzip_allocating_writer = try std.Io.Writer.Allocating.initCapacity(allocator, input_prx_size);
            defer gzip_allocating_writer.deinit();

            // History window required by the compressor (minimum flate.max_window_len = 65536 bytes)
            const window = try allocator.alloc(u8, std.compress.flate.max_window_len);
            defer allocator.free(window);

            var compressor = try std.compress.flate.Compress.init(
                &gzip_allocating_writer.writer,
                window,
                .gzip,
                .best,
            );

            const input_ingested_bytes = try prx_reader.streamRemaining(&compressor.writer);
            std.debug.assert(input_ingested_bytes == input_prx_size);

            try compressor.writer.splatByteAll(0, prx_size - input_prx_size); // Pad with zeros if PRX is smaller than header's declared size
            try compressor.finish();

            const c_size = gzip_allocating_writer.writer.end;
            const compressed = gzip_allocating_writer.writer.buffer[0..c_size];

            // Copy compressed output back over the original PRX region
            @memcpy(compressed_prx_buf[0..c_size], compressed);
        },
        else => {
            std.debug.print("error: unsupported compression flags: {}\n", .{psp_header.compression_attributes});
            return error.UnsupportedCompressionFlags;
        },
    }

    const kirk_raw = try allocator.alloc(u8, prx_size + 0x110);
    defer allocator.free(kirk_raw);

    const aligned_kirk_data_size = std.mem.alignForward(usize, headers.kirk_header.data_size, 0x10) + 0x110;

    // Build kirk_raw: copy the 0x110-byte kirk header prefix
    @memcpy(kirk_raw[0..0x90], std.mem.asBytes(&headers.kirk_header));
    @memcpy(kirk_raw[0x90..0x110], std.mem.asBytes(&psp_header));
    @memset(kirk_raw[0x110..], 0);

    // Decrypt the AES/CMAC keys embedded at the start of the kirk header.
    // AES-128-CBC with zero IV, 2 blocks: decrypt each block then XOR with previous ciphertext.
    var decrypted_aes_key: [16]u8 = undefined;
    var decrypted_cmac_key: [16]u8 = undefined;

    {
        const dec = std.crypto.core.aes.Aes128.initDec(kirk.KEY1);
        dec.decrypt(&decrypted_aes_key, &headers.kirk_header.aes_key);
        dec.decrypt(&decrypted_cmac_key, &headers.kirk_header.cmac_key);

        for (&decrypted_cmac_key, &headers.kirk_header.aes_key) |*b, prev| {
            b.* ^= prev;
        }
    }

    // Replace the first 32 bytes of kirk_raw with the decrypted keys so
    // kirk_CMD0 can locate them at the expected offset
    @memcpy(kirk_raw[0..16], &decrypted_aes_key);
    @memcpy(kirk_raw[16..32], &decrypted_cmac_key);

    // Append PRX (or compressed PRX) after the 0x110-byte header
    @memcpy(kirk_raw[0x110..], compressed_prx_buf);

    const kirk_enc = try allocator.alloc(u8, aligned_kirk_data_size);
    defer allocator.free(kirk_enc);

    @memset(kirk_enc, 0);

    // Encrypt with KIRK CMD0
    kirk.cmd0(kirk_enc, kirk_raw) catch |err| {
        std.debug.print("error: failed to execute CMD0\n", .{});
        return err;
    };

    // Restore the original (pre-decryption) header into the encrypted buffer
    @memcpy(kirk_enc[0..0x90], std.mem.asBytes(&headers.kirk_header));

    // Forge the CMAC signature
    kirk_forge_cmac(kirk_enc, &decrypted_cmac_key) catch |err| {
        std.debug.print("error: failed to forge CMAC\n", .{});
        return err;
    };

    // Assemble output: PSP header (0x150 bytes) + encrypted payload
    try psp_writer.writeAll(std.mem.asBytes(&headers.psp_full_header)); // 0..0x150
    try psp_writer.writeAll(kirk_enc[0x110..]); // 0x150..rest
    try psp_writer.flush();
}

// Verifies the CMAC header hash and patches the data region so its CMAC
// matches the stored CMAC_data_hash, without needing Sony's signing key.
// Takes the already-decrypted cmac_key (from the AES-CBC decrypt at line 211)
// so there is no redundant key re-derivation.
fn kirk_forge_cmac(buf: []u8, cmac_key: *const [16]u8) !void {
    const kirk_header = std.mem.bytesAsValue(kirk.KirkHeader, buf[0..0x90]);

    if (kirk_header.mode != 1) {
        return error.InvalidMode; // only CMD1 supported
    }

    if (kirk_header.data_size == 0) {
        return error.DataSizeZero;
    }

    // Verify header CMAC (covers bytes 0x60..0x90 of the header)
    var cmac_header_hash: [16]u8 = undefined;
    std.crypto.auth.cmac.CmacAes128.create(&cmac_header_hash, buf[0x60..0x90], cmac_key);

    if (!std.mem.eql(u8, &cmac_header_hash, &kirk_header.cmac_header_hash)) {
        return error.HeaderHashInvalid;
    }

    // 16-align data_size for the CMAC region length
    const chk_size = std.mem.alignForward(u32, kirk_header.data_size + kirk_header.data_offset, 16);
    const data_cmac_offset = 0x90 + chk_size;

    // Compute actual data CMAC and compare with stored CMAC_data_hash
    var cmac_data_hash: [16]u8 = undefined;
    std.crypto.auth.cmac.CmacAes128.create(&cmac_data_hash, buf[0x60..data_cmac_offset], cmac_key);

    if (std.mem.eql(u8, &cmac_data_hash, &kirk_header.cmac_data_hash)) {
        return; // already valid
    }

    // Patch the last 16 bytes of the CMAC region so it produces stored_data_hash
    cmac_forge(cmac_key, buf[0x60..data_cmac_offset], &kirk_header.cmac_data_hash);
}

// Patches the last 16-byte block of `data` so that AES-CMAC(key, data) == target.
// Assumes `data.len` is a multiple of 16 (true for KIRK CMD1 headers).
fn cmac_forge(key: *const [16]u8, data: []u8, target: *const [16]u8) void {
    const Aes128 = std.crypto.core.aes.Aes128;
    const enc = Aes128.initEnc(key.*);
    const dec = Aes128.initDec(key.*);

    // Derive CMAC subkey K1: double(AES(0...0))
    var k1 = [_]u8{0} ** 16;
    enc.encrypt(&k1, &k1);
    k1 = double_block(k1);

    // Run CBC forward over all blocks except the last to get X_{n-1}
    const n = data.len / 16;
    var x = [_]u8{0} ** 16;
    for (0..n - 1) |i| {
        for (&x, data[i * 16 ..][0..16]) |*xb, mb| xb.* ^= mb;
        enc.encrypt(&x, &x);
    }

    // Solve for the last block: M_new = AES_decrypt(target) ^ X_{n-1} ^ K1
    var dec_target: [16]u8 = undefined;
    dec.decrypt(&dec_target, target);
    const last = data[(n - 1) * 16 ..][0..16];
    for (last, dec_target, x, k1) |*b, d, xi, ki| b.* = d ^ xi ^ ki;
}

// Doubles a 128-bit block in GF(2^128) for CMAC subkey derivation.
fn double_block(b: [16]u8) [16]u8 {
    var out: [16]u8 = undefined;
    const msb: u8 = b[0] >> 7;
    for (0..15) |i| out[i] = (b[i] << 1) | (b[i + 1] >> 7);
    out[15] = (b[15] << 1) ^ (0x87 * msb);
    return out;
}

comptime {
    std.debug.assert(@sizeOf(prx.PSPHeader) + @sizeOf(kirk.KirkHeader) == 0x110);
}
