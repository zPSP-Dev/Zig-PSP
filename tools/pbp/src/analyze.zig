const std = @import("std");
const io = std.io;
const mem = std.mem;
const process = std.process;
const fs = std.fs;

const common = @import("common.zig");
const readHeader = common.readHeader;
const default_file_names = common.default_file_names;

pub fn analyzePBP() !void {
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
        std.log.warn("Usage: pbptool analyze <input.pbp>\n\n", .{});
        return;
    };

    if (std.mem.eql(u8, inputName, "-h")) {
        std.log.warn("Usage: pbptool analyze <input.pbp>\n", .{});
        return;
    }

    //Open File
    var inFile = try fs.cwd().openFile(inputName, fs.File.OpenFlags{ .mode = .read_only });
    defer inFile.close();

    //Get header
    const header = try readHeader(inFile);
    const size = try inFile.getEndPos();

    //Print entries
    std.log.warn("PBP Entry Table: \n", .{});

    var i: usize = 0;
    while (i < 8) : (i += 1) {
        var calcSize: usize = 0;

        if (i + 1 == 8) {
            calcSize = size - header.offset[7];
        } else {
            calcSize = header.offset[i + 1] - header.offset[i];
        }

        if (calcSize == 0) {
            std.log.warn("\t{s}: \tNOT PRESENT\n", .{default_file_names[i]});
        } else {
            std.log.warn("\t{s}: \tOFFSET {} \t SIZE {}\n", .{ default_file_names[i], header.offset[i], calcSize });
        }
    }
    std.log.warn("PBP Entry Table End\n\n", .{});

    //Read Version
    try inFile.seekTo(4);
    const ver_maj = inFile.reader().readInt(u16, .little);
    const ver_min = inFile.reader().readInt(u16, .little);

    //Finish Print
    std.log.warn("PBP Version: {}.{}\n", .{ ver_maj, ver_min });
    std.log.warn("Size: {} bytes.\n", .{size});
}
