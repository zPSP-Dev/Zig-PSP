const std = @import("std");
const process = std.process;

const write = @import("write.zig");
const parse = @import("parse.zig");
const read = @import("read.zig");

pub fn main() !void {
    //Get args
    var arg_it = process.args();
    // Skip executable
    _ = arg_it.skip();

    //Allocator setup
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var optionSelected = try (arg_it.next(allocator) orelse{
        std.debug.warn("Usage: sfotool [read | write | parse] file <...>\n", .{});
        return;
    });

    if(std.mem.eql(u8, optionSelected, "-h")){
        std.debug.warn("Usage: sfotool [read | write | parse] file <...>\n", .{});
        return;
    }else if(std.mem.eql(u8, optionSelected, "-v")){    
        std.debug.warn("zSFOTool Utility made by zPSP-Dev!\n\n", .{});
        std.debug.warn("Version 1.0\n", .{});
        return;
    }else if(std.mem.eql(u8, optionSelected, "read")){
        try read.readSFO();
    }else if(std.mem.eql(u8, optionSelected, "write")){
        try write.writeSFO();
    }else if(std.mem.eql(u8, optionSelected, "parse")){
        try parse.parseSFO();
    }

}
