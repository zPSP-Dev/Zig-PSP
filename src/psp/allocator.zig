const std = @import("std");
const mem = std.mem;
const debug = std.debug;
const assert = debug.assert;

usingnamespace @import("sys/psptypes.zig");
usingnamespace @import("sys/pspsysmem.zig");
usingnamespace @import("sys/psploadexec.zig");

const Allocator = mem.Allocator;

pub const PSPAllocator = struct{
    allocator: Allocator,

    pub fn init() PSPAllocator {
        return PSPAllocator {
            .allocator = Allocator{
                .reallocFn = psp_realloc,
                .shrinkFn = psp_shrink
            }
        };
    }

    fn psp_realloc (allocator: *Allocator, old_mem: []u8, old_alignment: u29, new_byte_count: usize, new_alignment: u29) std.mem.Allocator.Error![]u8{
        assert(new_alignment <= @alignOf(c_longdouble));

        if(old_mem.len == 0){
            //Malloc

            var id : SceUID = sceKernelAllocPartitionMemory(2, "block", @enumToInt(PspSysMemBlockTypes.MemLow), new_byte_count + @sizeOf(SceUID) + new_alignment + 1, null);

            if(id < 0){
                return Allocator.Error.OutOfMemory;
            }

            var ptr = @ptrCast([*]u32, @alignCast(4, sceKernelGetBlockHeadAddr(id)));

            @ptrCast(*c_int, ptr).* = id;

            var ptr2 = @ptrCast([*]u8, ptr);

            ptr2 += @sizeOf(SceUID);

            var padding : u32 = 1 + new_alignment;
            ptr2[padding - 1] = @truncate(u8, padding);

            return ptr2[padding..new_byte_count];
        }

        return Allocator.Error.OutOfMemory;
    }

    fn psp_shrink(allocator: *Allocator, old_mem: []u8, old_alignment: u29, new_byte_count: usize, new_alignment: u29) []u8{
        var ptr = @ptrCast([*]u8, old_mem);

        ptr -= 1;
        var padding = ptr[0];
        ptr += 1 - padding - @sizeOf(SceUID);

        var id = ptr[0];

        var s = sceKernelFreePartitionMemory(id);
        return old_mem[0..new_byte_count];
    }
};
