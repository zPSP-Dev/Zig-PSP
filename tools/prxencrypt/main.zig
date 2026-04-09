const std = @import("std");

const prx_encrypt = @import("prx_encrypt.zig");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len < 2) {
        std.debug.print("usage: {s} [input.prx] <output.psp>\n", .{args[0]});
        return;
    }

    // Input
    const input_path = args[1];

    const input_file = std.Io.Dir.cwd().openFile(io, input_path, .{}) catch |err| {
        std.debug.print("Error opening input file: {s}\n", .{input_path});
        return err;
    };
    defer input_file.close(io);

    var reader_buffer: [4096]u8 = undefined;
    var reader = input_file.reader(io, &reader_buffer);
    const prx_reader = &reader.interface;
    const prx_size_bytes = try reader.getSize();

    // Output
    const output_path = if (args.len >= 3) args[2] else "encrypted.psp";

    const output_file = std.Io.Dir.cwd().createFile(io, output_path, .{}) catch |err| {
        std.debug.print("Error creating output file: {s}\n", .{output_path});
        return err;
    };
    errdefer std.Io.Dir.cwd().deleteFile(io, output_path) catch {}; // If we encounter an error, just delete the file and ignore failures
    defer output_file.close(io);

    var writer_buffer: [4096]u8 = undefined;
    var writer = output_file.writer(io, &writer_buffer);
    const psp_writer = &writer.interface;

    try prx_encrypt.encrypt(allocator, prx_reader, prx_size_bytes, psp_writer);

    try std.Io.File.stdout().writeStreamingAll(io, try std.fmt.allocPrint(allocator, "Successfully encrypted {s} to {s}\n", .{ input_path, output_path }));
}
