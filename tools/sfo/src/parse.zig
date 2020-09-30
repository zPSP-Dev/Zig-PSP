const std = @import("std");
const process = std.process;
usingnamespace @import("common.zig");
const io = std.io;
const mem = std.mem;
const fs = std.fs;

pub fn parseSFO() !void {
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

    var inputName = try (arg_it.next(allocator) orelse{
        std.debug.warn("Usage: sfotool parse <input.json>\n", .{});
        return;
    });

    if(std.mem.eql(u8, inputName, "-h")){
        std.debug.warn("Usage: sfotool parse <input.json>\n", .{});
        return;
    }
}
