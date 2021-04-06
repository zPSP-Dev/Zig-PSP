const std = @import("std");
const io = std.io;
const mem = std.mem;
const process = std.process;
const fs = std.fs;

usingnamespace @import("common.zig");

//The PBP Header itself consists of a signature starting with NULL, followed by 'PBP'.
//It also contains a version (two shorts), which in this case is v0.1
//Finally, it has an offset table of where things are inside of the file.
//If something has 0 length - it is not included.
//By default we must offset by 40 (the header length).
var header = PbpHeader{
    .signature = .{0x00, 'P', 'B', 'P'},
    .version = .{0x00, 0x00, 0x01, 0x00},
    .offset = .{40, 0, 0, 0, 0, 0, 0, 0}
};

//This function write the PBP header to a file
fn writeHeader(file: fs.File) !void {

    //Get the output stream
    var outputStream = file.writer();

    //Write the signature
    var x : usize = 0;
    while(x < 4) : (x += 1) {
        try outputStream.writeByte(header.signature[x]);
    }
    
    //Write the version
    x = 0;
    while(x < 4) : (x += 1) {
        try outputStream.writeByte(header.version[x]);
    }

    //Write the offset table
    x = 0;
    while(x < 8) : (x += 1) {
        try outputStream.writeIntNative(u32, header.offset[x]);
    }
}

pub fn packPBP() !void {
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

    //Get our output file - if it doesn't exist - error out
    var outputName = try (arg_it.next(allocator) orelse{
        std.debug.warn("Usage: pbptool pack <output.pbp> <param.sfo> <icon0.png> <icon1.pmf> <pic0.png> <pic1.png> <snd0.at3> <data.psp> <data.psar>\n\n", .{});
        return;
    });

    if(std.mem.eql(u8, outputName, "-h")){
        std.debug.warn("Usage: pbptool pack <output.pbp> <param.sfo> <icon0.png> <icon1.pmf> <pic0.png> <pic1.png> <snd0.at3> <data.psp> <data.psar>\n", .{});
        return;
    }

    //File Size Array for Offset table generation
    var filesizes : [8]usize = [_]usize{0} ** 8;
    var fileNames : [8][]const u8 = undefined;
 
    //Read the files from command - get their lengths
    var i : usize = 0;
    while(i < 8) : (i += 1){
        //Get the command arg
        const arg = try (arg_it.next(allocator) orelse {
            std.debug.warn("Usage: pbptool pack <output.pbp> <param.sfo> <icon0.png> <icon1.pmf> <pic0.png> <pic1.png> <snd0.at3> <data.psp> <data.psar>\n\n", .{});
            
            std.debug.warn("Found {} arguments instead of 8!\n", .{i});
            return error.TooFewArgs;
        });

        fileNames[i] = arg;

        //If a file doesn't exist - we skip it.
        if(std.mem.eql(u8, arg, "NULL")){
            continue;
        }

        //Open up the file
        var f = try fs.cwd().openFile(arg, fs.File.OpenFlags{.read = true});
        defer f.close();

        //Read the size - the end position
        var size : u64 = try f.getEndPos();
        filesizes[i] = @truncate(u32, size);
    }


    //Create the file offset table
    std.debug.warn("PBP Entry Table: \n", .{});
    i = 1;
    while(i < 8) : (i += 1){
        //Sets the offset to the previous generated value plus the size of this element
        header.offset[i] = @truncate(u32, header.offset[i - 1] + filesizes[i - 1]);

        if(filesizes[i - 1] != 0){
            std.debug.warn("\tEntry: {s} Added at {} offset.\t\t\t(Size {} bytes)\n", .{fileNames[i - 1], header.offset[i - 1], filesizes[i - 1]});
        }
    }
    std.debug.warn("PBP Entry Table End\n\n", .{});

    //Open File
    var outputFile = try fs.cwd().createFile(outputName, fs.File.CreateFlags {.truncate = true});
    defer outputFile.close();

    //Write the PBP header
    try writeHeader(outputFile);
    
    //Write each file (directly - no formatting) to the PBP after the header
    std.debug.warn("Writing...\n",.{});

    i = 0;
    while(i < 8) : (i += 1){
        //Skip if non-existent
        if(std.mem.eql(u8, fileNames[i], "NULL")){
            continue;
        }

        //Open File
        var f = try fs.cwd().openFile(fileNames[i], fs.File.OpenFlags{.read = true});
        defer f.close();
        
        //Read fragment to buffer
        var buf : [std.mem.page_size]u8 = undefined;
        var bytes_read = try f.read(buf[0..]);

        //Read / Write loop
        while(bytes_read > 0){
            //Write it now
            var x : usize = 0;
            while(x < bytes_read) : (x += 1){
                try outputFile.writer().writeByte(buf[x]);
            }

            //Get the next bytes
            bytes_read = try f.read(buf[0..]);
        }
    }

    std.debug.warn("Saved to {s}! (Wrote {} bytes)\n",.{outputName, header.offset[7] + filesizes[7]});
}
