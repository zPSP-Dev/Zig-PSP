const std = @import("std");
const io = std.io;
const mem = std.mem;
const process = std.process;
const fs = std.fs;

usingnamespace @import("common.zig");

pub fn analyzePBP() !void {
    //Get args
    var arg_it = process.args();

    // Skip executable
    _ = arg_it.skip();
    // Skip command
    _ = arg_it.skip();

    //Allocator setup
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;

    //Get our input file - if it doesn't exist - error out
    var inputName = try (arg_it.next(allocator) orelse{
        std.debug.warn("Usage: pbptool analyze <input.pbp>\n\n", .{});
        return;
    });

    if(std.mem.eql(u8, inputName, "-h")){
        std.debug.warn("Usage: pbptool analyze <input.pbp>\n", .{});
        return;
    }

    //Open File
    var inFile = try fs.cwd().openFile(inputName, fs.File.OpenFlags{.read = true});
    defer inFile.close();

    //Get header
    var header = try readHeader(inFile);
    var size = try inFile.getEndPos();

    //Print entries
    std.debug.warn("PBP Entry Table: \n",.{});

    var i : usize = 0;
    while(i < 8) : (i += 1){
        var calcSize : usize = 0;

        if(i + 1 == 8){
            calcSize = size - header.offset[7];
        }else{
            calcSize = header.offset[i + 1] - header.offset[i];
        }

        if(calcSize == 0){
            std.debug.warn("\t{s}: \tNOT PRESENT\n", .{default_file_names[i]});
        }else{
            std.debug.warn("\t{s}: \tOFFSET {} \t SIZE {}\n", .{default_file_names[i], header.offset[i], calcSize});
        }
    }
    std.debug.warn("PBP Entry Table End\n\n", .{});

    //Read Version
    try inFile.seekTo(4);
    var ver_maj = inFile.reader().readIntNative(u16);
    var ver_min = inFile.reader().readIntNative(u16);

    //Finish Print
    std.debug.warn("PBP Version: {}.{}\n", .{ver_maj, ver_min});
    std.debug.warn("Size: {} bytes.\n", .{size});
}
