const std = @import("std");
const io = std.io;
const mem = std.mem;
const process = std.process;
const fs = std.fs;

const common = @import("common.zig");
const readHeader = common.readHeader;
const default_file_names = common.default_file_names;

pub fn unpackPBP() !void {
    //Allocator setup
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    //Get args
    var arg_it = try process.argsWithAllocator(allocator);

    // Skip executable
    _ = arg_it.skip();
    // Skip command
    _ = arg_it.skip();

    //Get our input file - if it doesn't exist - error out
    const inputName = arg_it.next() orelse {
        std.log.warn("Usage: pbptool unpack <input.pbp> <dir>\n\n", .{});
        return;
    };

    if (std.mem.eql(u8, inputName, "-h")) {
        std.log.warn("Usage: pbptool unpack <input.pbp> <dir>\n", .{});
        return;
    }

    const dirName = arg_it.next() orelse {
        std.log.warn("Usage: pbptool unpack <input.pbp> <dir>\n\n", .{});
        return;
    };

    //Read
    var inFile = try fs.cwd().openFile(inputName, fs.File.OpenFlags{ .mode = .read_only });
    defer inFile.close();

    //Validate header
    const header = try readHeader(inFile);
    const size = try inFile.getEndPos();

    //Read each
    var i: usize = 0;
    while (i < 8) : (i += 1) {
        var calcSize: usize = 0;

        if (i + 1 == 8) {
            calcSize = size - header.offset[7];
        } else {
            calcSize = header.offset[i + 1] - header.offset[i];
        }

        //Make a file!
        if (calcSize != 0) {
            std.log.warn("Creating {s} with {} bytes... ", .{ default_file_names[i], calcSize });

            var result = try allocator.alloc(u8, dirName.len + default_file_names[i].len);
            defer allocator.free(result);
            mem.copyForwards(u8, result[0..], dirName);
            mem.copyForwards(u8, result[dirName.len..], default_file_names[i]);

            //Open
            var outputFile = try fs.cwd().createFile(result, fs.File.CreateFlags{ .truncate = true });
            defer outputFile.close();

            var buf: [1]u8 = undefined;
            try inFile.seekTo(header.offset[i]);

            var bytes_read: usize = 0;

            //Read / Write loop
            while (bytes_read < calcSize) {
                bytes_read += try inFile.read(buf[0..]);

                //Write it now
                var x: usize = 0;
                while (x < buf.len) : (x += 1) {
                    if (bytes_read < calcSize) {
                        try outputFile.writer().writeByte(buf[x]);
                    } else {
                        break;
                    }
                }

                if (bytes_read == calcSize) {
                    break;
                }
            }

            std.log.warn("done.\n", .{});
        }
    }
}
