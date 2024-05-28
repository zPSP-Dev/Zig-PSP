const std = @import("std");
const process = std.process;

const write = @import("write.zig");
const parse = @import("parse.zig");
const read = @import("read.zig");

pub fn main() !void {
    //Allocator setup
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    //Get args
    var arg_it = try process.argsWithAllocator(allocator);
    // Skip executable
    _ = arg_it.skip();

    const optionSelected = arg_it.next() orelse {
        std.log.warn("Usage: sfotool [read | write | parse] file <...>\n", .{});
        return;
    };

    if (std.mem.eql(u8, optionSelected, "-h")) {
        std.log.warn("Usage: sfotool [read | write | parse] file <...>\n", .{});
        return;
    } else if (std.mem.eql(u8, optionSelected, "-v")) {
        std.log.warn("zSFOTool Utility made by zPSP-Dev!\n\n", .{});
        std.log.warn("Version 1.0\n", .{});
        return;
    } else if (std.mem.eql(u8, optionSelected, "read")) {
        try read.readSFO();
    } else if (std.mem.eql(u8, optionSelected, "write")) {
        try write.writeSFO();
    } else if (std.mem.eql(u8, optionSelected, "parse")) {
        try parse.parseSFO();
    }
}
