//Shows a working example of allocation and freeing

const psp = @import("psp/pspsdk.zig");

const std = @import("std");
const fmt = std.fmt;

comptime {
    _ = psp.module_start_struct;
}

fn printFreeMem(alloc: *std.mem.Allocator) void {
    var freeMem = psp.sceKernelTotalFreeMemSize();
    const fMem = std.fmt.allocPrint(alloc, "{} Bytes Free\n", .{freeMem}) catch unreachable;
    psp.debug.print(fMem);
    alloc.free(fMem);
}

pub fn main() !void {
    psp.utils.enable_home_callback();
    psp.debug.screenInit();

    var psp_allocator = &psp.utils.PSPAllocator.init().allocator;

    printFreeMem(psp_allocator);

    const string : []const u8 = try std.fmt.allocPrint(
        psp_allocator,
        "{} {} {}\n",
        .{ "Hello", "from", "Zig!" },
    );
    
    psp.debug.print(string);
    
    printFreeMem(psp_allocator);
    psp_allocator.free(string); //Explicit free
    
    printFreeMem(psp_allocator);

    psp.debug.print("\nKTHXBYE!");
}