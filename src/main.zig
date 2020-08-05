const psp = @import("psp/pspsdk.zig");

const std = @import("std");
const fmt = std.fmt;



pub export fn main() void {

    const pspAllocator = &psp.utils.PSPAllocator.init().allocator;

    psp.utils.enableHomeButton();

    psp.debug.screenInit();

    const integer : i32 = 1543234544;
    
    var str = fmt.allocPrint(pspAllocator, "{}", .{integer}) catch unreachable;

    psp.debug.print(str);
}
