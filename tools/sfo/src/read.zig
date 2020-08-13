usingnamespace @import("common.zig")

pub fn read() !void {
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
    var inFile = try (arg_it.next(allocator) orelse{
        std.debug.warn("Usage: sfotool read <input.SFO>\n", .{});
        return;
    });

    if(std.mem.eql(u8, inFile, "-h")){
        std.debug.warn("Usage: sfotool read <input.SFO>\n", .{});
        return;
    }

    
}