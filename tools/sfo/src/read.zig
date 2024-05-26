const std = @import("std");
const process = std.process;
const io = std.io;
const mem = std.mem;
const fs = std.fs;

const common = @import("common.zig");
const SFOHeader = common.SFOHeader;
const SFOEntry = common.SFOEntry;
const PSF_MAGIC_NUM = common.PSF_MAGIC_NUM;
const PSP_TYPE_VAL = common.PSP_TYPE_VAL;

//This reads and validates the header
fn validateHeader(file: fs.File) !SFOHeader {
    var sfoh: SFOHeader = undefined;

    sfoh.magic = try file.reader().readInt(u32, .little);
    sfoh.version = try file.reader().readInt(u32, .little);
    sfoh.keyofs = try file.reader().readInt(u32, .little);
    sfoh.valofs = try file.reader().readInt(u32, .little);
    sfoh.count = try file.reader().readInt(u32, .little);
    if (sfoh.magic != PSF_MAGIC_NUM) {
        return error.BadMagic;
    }
    std.log.warn("Magic Validated! Version 0x{x}\n", .{sfoh.version});
    std.log.warn("Found {} key-value pairs!\n\n", .{sfoh.count});

    std.log.warn("Keys at 0x{x}\n", .{sfoh.keyofs});
    std.log.warn("Data at 0x{x}\n", .{sfoh.valofs});

    return sfoh;
}

pub fn readSFO() !void {
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

    //Get our file - if it doesn't exist - error out
    const inputName = arg_it.next() orelse {
        std.log.warn("Usage: sfotool read <input.SFO>\n", .{});
        return;
    };

    if (std.mem.eql(u8, inputName, "-h")) {
        std.log.warn("Usage: sfotool read <input.SFO>\n", .{});
        return;
    }

    //File in
    var inFile = try fs.cwd().openFile(inputName, fs.File.OpenFlags{ .mode = .read_only });
    defer inFile.close();

    //Read the header
    const header: SFOHeader = try validateHeader(inFile);
    var entries: [256]SFOEntry = undefined;

    //Print header
    var i: usize = 0;
    std.log.warn("\nSFO Header: \tOFF\tALN\tTYPE\tVALS\tTOTS\tDATO\n", .{});
    while (i < header.count) : (i += 1) {
        entries[i].nameofs = try inFile.reader().readInt(u16, .little);
        entries[i].alignment = try inFile.reader().readByte();
        entries[i].typec = try inFile.reader().readByte();
        entries[i].valsize = try inFile.reader().readInt(u32, .little);
        entries[i].totalsize = try inFile.reader().readInt(u32, .little);
        entries[i].dataofs = try inFile.reader().readInt(u32, .little);

        std.log.warn("SFO Entry {}: \t{}\t{}\t{}\t{}\t{}\t{}\n", .{ i, entries[i].nameofs, entries[i].alignment, entries[i].typec, entries[i].valsize, entries[i].totalsize, entries[i].dataofs });
    }
    std.log.warn("SFO Header End\n\n", .{});

    //Print key pairs
    i = 0;
    while (i < header.count) : (i += 1) {
        var nameStr: [32]u8 = undefined;

        //Go to keys table
        try inFile.seekTo(entries[i].nameofs + header.keyofs);

        var size: usize = 0;
        if ((i + 1) < header.count) {
            size = entries[i + 1].nameofs - entries[i].nameofs;
        } else {
            size = 10;
        }

        //Read the key
        _ = try inFile.reader().read(nameStr[0..size]);
        std.log.warn("Pair {}: {s} = ", .{ i, nameStr[0..size] });

        //Go to the data table
        try inFile.seekTo(entries[i].dataofs + header.valofs);
        if (entries[i].typec == PSP_TYPE_VAL) {
            //Read a value
            const val = try inFile.reader().readInt(u32, .little);
            std.log.warn("{}\n", .{val});
        } else {
            //Read a string
            var str: [32]u8 = undefined;
            _ = try inFile.reader().read(str[0..entries[i].valsize]);
            std.log.warn("\"{s}\"\n", .{str[0..entries[i].valsize]});
        }
    }
}
