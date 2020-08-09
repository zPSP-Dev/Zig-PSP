const std = @import("std");
const io = std.io;
const mem = std.mem;
const process = std.process;
const fs = std.fs;

const PbpHeader = struct{
    signature: [4]u8,
    version: [4]u8,
    offset: [8]u32,
};

var header = PbpHeader{
    .signature = .{0x00, 'P', 'B', 'P'},
    .version = .{0x00, 0x00, 0x01, 0x00},
    .offset = .{40, 0, 0, 0, 0, 0, 0, 0}
};

const MAX_FILE_SIZE = 16 * 1024 * 1024;

fn writeHeader(file: fs.File) !void {
    var outputStream = file.outStream();

    var x : usize = 0;
    while(x < 4) : (x += 1) {
        try outputStream.writeByte(header.signature[x]);
    }
    
    x = 0;
    while(x < 4) : (x += 1) {
        try outputStream.writeByte(header.version[x]);
    }

    x = 0;
    while(x < 8) : (x += 1) {
        try outputStream.writeIntNative(u32, header.offset[x]);
    }
}

pub fn main() !void {
    var arg_it = process.args();

    // Skip exec
    _ = arg_it.skip();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;
    var i : usize = 0;

    var outputName = try (arg_it.next(allocator) orelse{
        std.debug.warn("Could not find an PBP File Name.", .{});
        return error.NoEBOOT;
    });

    var filesizes : [8]usize = [_]usize{0} ** 8;

    while(i < 8) : (i += 1){
        const arg = try (arg_it.next(allocator) orelse {
            std.debug.warn("Found {} arguments instead of 9!\n", .{i});
            return error.TooFewArgs;
        });

        if(std.mem.eql(u8, arg, "NULL")){
            continue;
        }

        var f = try fs.cwd().openFile(arg, fs.File.OpenFlags{.read = true});
        defer f.close();

        var size : u64 = try f.getEndPos();
        filesizes[i] = @truncate(u32, size);
    }

    //Create the file offset table
    i = 1;
    while(i < 8) : (i += 1){
        header.offset[i] = @truncate(u32, header.offset[i - 1] + filesizes[i - 1]);
    }

    //Open File
    var outputFile = try fs.cwd().createFile(outputName, fs.File.CreateFlags {.truncate = true});
    defer outputFile.close();

    //Write the PBP header
    try writeHeader(outputFile);

    
    //Reset the iterator
    arg_it = process.args();
    //Skip exec
    _ = arg_it.skip();
    //Skip file name
    _ = arg_it.skip();
    

    i = 0;
    while(i < 8) : (i += 1){
        
        const arg = try (arg_it.next(allocator) orelse {
            std.debug.warn("Found {} arguments instead of 9!\n", .{i});
            return error.TooFewArgs;
        });
        
        if(std.mem.eql(u8, arg, "NULL")){
            continue;
        }

        var f = try fs.cwd().openFile(arg, fs.File.OpenFlags{.read = true});
        defer f.close();
        
        var buf : [std.mem.page_size]u8 = undefined;
        var bytes_read = try f.read(buf[0..]);

        while(bytes_read > 0){
            //Write it now
            var x : usize = 0;
            while(x < bytes_read) : (x += 1){
                try outputFile.outStream().writeByte(buf[x]);
            }

            bytes_read = try f.read(buf[0..]);
        }

    }
}