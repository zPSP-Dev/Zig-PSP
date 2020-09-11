const std = @import("std");
const process = std.process;
const pack = @import("pack.zig");
const analyze = @import("analyze.zig");
const unpack = @import("unpack.zig");

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
        std.debug.warn("Usage: pbptool [pack | unpack | analyze] file <...>\n", .{});
        return;
    });

    if(std.mem.eql(u8, optionSelected, "-h")){
        std.debug.warn("Usage: pbptool [pack | unpack | analyze] file <...>\n", .{});
        return;
    }
    
    if(std.mem.eql(u8, optionSelected, "-v")){
        std.debug.warn("zPBPTool Utility made by zPSP-Dev!\n\n", .{});
        std.debug.warn("Version 1.0\n", .{});
        return;
    }

    if(std.mem.eql(u8, optionSelected, "pack")){
        try pack.packPBP();
    }

    if(std.mem.eql(u8, optionSelected, "analyze")){
        try analyze.analyzePBP();
    }

    if(std.mem.eql(u8, optionSelected, "unpack")){
        try unpack.unpackPBP();
    }

}
