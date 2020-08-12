const std = @import("std");
const process = std.process;

pub fn main() !void {
    std.debug.warn("zSFOTool Utility made by zPSP-Dev!\n\n", .{});

    //Get args
    var arg_it = process.args();
    // Skip executable
    _ = arg_it.skip();

    //Allocator setup
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var optionSelected = try (arg_it.next(allocator) orelse{
        std.debug.warn("Usage: sfotool [read | write] file <...>\n", .{});
        return;
    });

    if(std.mem.eql(u8, optionSelected, "-h")){
        std.debug.warn("Usage: sfotool [read | write] file <...>\n", .{});
        return;
    }
    
    if(std.mem.eql(u8, optionSelected, "-v")){
        std.debug.warn("Version 1.0\n", .{});
        return;
    }

    if(std.mem.eql(u8, optionSelected, "read")){
        
    }

    if(std.mem.eql(u8, optionSelected, "write")){
        
    }

}