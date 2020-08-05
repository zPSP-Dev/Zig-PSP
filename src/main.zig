const psp = @import("psp/pspsdk.zig");

const std = @import("std");
const fmt = std.fmt;

fn printFreeMem(alloc: *std.mem.Allocator) void {
    var freeMem = psp.sceKernelTotalFreeMemSize();
    const fMem = std.fmt.allocPrint(alloc, "{} Bytes Free\n", .{freeMem}) catch unreachable;
    psp.debug.print(fMem);
    alloc.free(fMem);
}

pub export fn main() void {
    psp.utils.enableHomeButton();
    psp.debug.screenInit();

    var psp_allocator = &psp.utils.PSPAllocator.init().allocator;
    printFreeMem(psp_allocator);

    const string = std.fmt.allocPrint(
        psp_allocator,
        "{} {} {}\n",
        .{ "Hello", "from", "Zig!" },
    ) catch unreachable;
    psp.debug.print(string);

    printFreeMem(psp_allocator);
    psp_allocator.free(string); //Explicit free
    
    printFreeMem(psp_allocator);

    psp.debug.print("\nKTHXBYE!");
}
