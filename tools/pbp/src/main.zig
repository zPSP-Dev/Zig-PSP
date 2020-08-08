const std = @import("std");
const io = std.io;
const mem = std.mem;
const process = std.process;


pub fn main() anyerror!void {
    var arg_it = process.args();

    // Skip exec
    _ = arg_it.skip();

    
}
