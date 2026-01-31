// Allocator example
// FIXME This is still 100% broken at the moment, but it compiles
const std = @import("std");
const fmt = std.fmt;

const sdk = @import("pspsdk");
const sysmem = sdk.sysmem;

fn printFreeMem(alloc: std.mem.Allocator) void {
    const freeMem = sysmem.sceKernelTotalFreeMemSize();
    const fMem = std.fmt.allocPrint(alloc, "{d} Bytes Free\n", .{freeMem}) catch unreachable;
    sdk.extra.debug.print(fMem);
    alloc.free(fMem);
}

pub const panic = sdk.extra.debug.panic; // Import panic handler

comptime {
    asm (sdk.extra.module.module_info("SDK Allocator", .{ .mode = .User }, 1, 0));
}

pub fn main() !void {
    sdk.extra.utils.enableHBCB();
    sdk.extra.debug.screenInit();

    var alloc: sdk.extra.allocator.PSPAllocator = undefined;
    var psp_allocator = alloc.init();

    printFreeMem(psp_allocator);

    const string: []const u8 = try std.fmt.allocPrint(
        psp_allocator,
        "{s} {s} {s}\n",
        .{ "Hello", "from", "Zig!" },
    );

    sdk.extra.debug.print(string);

    printFreeMem(psp_allocator);
    psp_allocator.free(string); //Explicit free

    printFreeMem(psp_allocator);

    sdk.extra.debug.print("\nKTHXBYE!");
}
