//Shows a working example of allocation and freeing

const psp = @import("psp/utils/psp.zig");
const sysmem = @import("psp/include/pspsysmem.zig");

const std = @import("std");
const fmt = std.fmt;

comptime {
    asm(psp.module_info("Zig PSP App", 0, 1, 0));
}

fn printFreeMem(alloc: *std.mem.Allocator) void {
    var freeMem = sysmem.sceKernelTotalFreeMemSize();
    const fMem = std.fmt.allocPrint(alloc, "{} Bytes Free\n", .{freeMem}) catch unreachable;
    psp.debug.print(fMem);
    alloc.free(fMem);
}

pub fn main() !void {
    psp.utils.enableHBCB();
    psp.debug.screenInit();

    var psp_allocator = &psp.PSPAllocator.init().allocator;

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
