const std = @import("std");

const prx_encrypt = @import("prx_encrypt.zig");
const prx_file = @embedFile("test/hello_world.prx");

test "encrypt hello_world.prx produces known hash" {
    const allocator = std.testing.allocator;

    var reader = std.Io.Reader.fixed(prx_file);

    var hash_buffer: [4096]u8 = undefined;
    var hashing = std.Io.Writer.Hashing(std.crypto.hash.Md5).init(&hash_buffer);

    try prx_encrypt.encrypt(allocator, &reader, prx_file.len, &hashing.writer);

    var digest: [std.crypto.hash.Md5.digest_length]u8 = undefined;
    hashing.hasher.final(&digest);

    const expected: u128 = 0x22778aa4c96b8150c796bad56d91eca6;

    try std.testing.expectEqual(expected, std.mem.readInt(u128, &digest, .big));
}
