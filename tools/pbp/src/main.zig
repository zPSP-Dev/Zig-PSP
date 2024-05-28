const std = @import("std");
const process = std.process;
const pack = @import("pack.zig");
const analyze = @import("analyze.zig");
const unpack = @import("unpack.zig");

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
        std.log.warn("Usage: pbptool [pack | unpack | analyze] file <...>\n", .{});
        return;
    };

    if (std.mem.eql(u8, optionSelected, "-h")) {
        std.log.warn("Usage: pbptool [pack | unpack | analyze] file <...>\n", .{});
        return;
    }

    if (std.mem.eql(u8, optionSelected, "-v")) {
        std.log.warn("zPBPTool Utility made by zPSP-Dev!\n\n", .{});
        std.log.warn("Version 1.0\n", .{});
        return;
    }

    if (std.mem.eql(u8, optionSelected, "pack")) {
        try pack.packPBP();
    }

    if (std.mem.eql(u8, optionSelected, "analyze")) {
        try analyze.analyzePBP();
    }

    if (std.mem.eql(u8, optionSelected, "unpack")) {
        try unpack.unpackPBP();
    }
}
