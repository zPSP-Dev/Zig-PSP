const std = @import("std");
const process = std.process;
usingnamespace @import("common.zig");
const io = std.io;
const mem = std.mem;
const fs = std.fs;

//This reads and validates the header
fn validateHeader(file : fs.File) !SFOHeader {
    var sfoh : SFOHeader = undefined;

    sfoh.magic = try file.reader().readIntNative(u32);
    sfoh.version = try file.reader().readIntNative(u32);
    sfoh.keyofs = try file.reader().readIntNative(u32);
    sfoh.valofs = try file.reader().readIntNative(u32);
    sfoh.count = try file.reader().readIntNative(u32);
    if(sfoh.magic != PSF_MAGIC_NUM){
        return error.BadMagic;
    }
    std.debug.warn("Magic Validated! Version 0x{x}\n", .{sfoh.version});
    std.debug.warn("Found {} key-value pairs!\n\n", .{sfoh.count});
    
    std.debug.warn("Keys at 0x{x}\n", .{sfoh.keyofs});
    std.debug.warn("Data at 0x{x}\n", .{sfoh.valofs});

    return sfoh;
}

pub fn readSFO() !void {
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

    //Get our file - if it doesn't exist - error out
    var inputName = try (arg_it.next(allocator) orelse{
        std.debug.warn("Usage: sfotool read <input.SFO>\n", .{});
        return;
    });

    if(std.mem.eql(u8, inputName, "-h")){
        std.debug.warn("Usage: sfotool read <input.SFO>\n", .{});
        return;
    }

    //File in
    var inFile = try fs.cwd().openFile(inputName, fs.File.OpenFlags{.read = true});
    defer inFile.close();

    //Read the header
    var header : SFOHeader = try validateHeader(inFile);
    var entries : [256]SFOEntry = undefined;

    //Print header
    var i : usize = 0;
    std.debug.warn("\nSFO Header: \tOFF\tALN\tTYPE\tVALS\tTOTS\tDATO\n", .{});
    while(i < header.count) : (i += 1){
        entries[i].nameofs = try inFile.reader().readIntNative(u16);
        entries[i].alignment = try inFile.reader().readIntNative(u8);
        entries[i].typec = try inFile.reader().readIntNative(u8);
        entries[i].valsize = try inFile.reader().readIntNative(u32);
        entries[i].totalsize = try inFile.reader().readIntNative(u32);
        entries[i].dataofs = try inFile.reader().readIntNative(u32);
        
        std.debug.warn("SFO Entry {}: \t{}\t{}\t{}\t{}\t{}\t{}\n", .{i, entries[i].nameofs, entries[i].alignment, entries[i].typec, entries[i].valsize, entries[i].totalsize, entries[i].dataofs});
    }
    std.debug.warn("SFO Header End\n\n", .{});

    //Print key pairs
    i = 0;
    while(i < header.count) : (i += 1){
        var nameStr : [32]u8 = undefined;
        
        //Go to keys table
        try inFile.seekTo(entries[i].nameofs + header.keyofs);

        var size : usize = 0;
        if( (i + 1) < header.count){
            size = entries[i+1].nameofs - entries[i].nameofs;
        }else{
            size = 10;
        }

        //Read the key
        _ = try inFile.reader().read(nameStr[0..size]);
        std.debug.warn("Pair {}: {s} = ", .{i, nameStr[0..size]});

        //Go to the data table
        try inFile.seekTo(entries[i].dataofs + header.valofs);
        if(entries[i].typec == PSP_TYPE_VAL){
            //Read a value
            var val = try inFile.reader().readIntNative(u32);
            std.debug.warn("{}\n", .{val});
        }else{
            //Read a string
            var str : [32]u8 = undefined;
            _ = try inFile.reader().read(str[0..entries[i].valsize]);
            std.debug.warn("\"{s}\"\n", .{str[0..entries[i].valsize]});
        }

    }
}
