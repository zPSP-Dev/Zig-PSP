const std = @import("std");
const mem = std.mem;
const debug = std.debug;
const assert = debug.assert;

usingnamespace @import("../include/psptypes.zig");
usingnamespace @import("../include/pspsysmem.zig");
usingnamespace @import("../include/psploadexec.zig");

const Allocator = mem.Allocator;

// This Allocator is a very basic allocator for the PSP
// It uses the PSP's kernel to allocate and free memory
// This may not be 100% correct for alignment
pub const PSPAllocator = struct {
    allocator: Allocator,

    //Initialize and send back an allocator object
    pub fn init() PSPAllocator {
        return PSPAllocator{
            .allocator = Allocator{
                .allocFn = psp_realloc,
                .resizeFn = psp_shrink,
            },
        };
    }

    //Our Allocator
    fn psp_realloc(allocator: *Allocator, len: usize, alignment: u29, len_align: u29, ra: usize) std.mem.Allocator.Error![]u8 {
        //Assume alignment is less than double aligns
        assert(len > 0);
        assert(alignment <= @alignOf(c_longdouble));

        //If not allocated - allocate!
        if (len > 0) {

            //Gets a block of memory
            var id: SceUID = sceKernelAllocPartitionMemory(2, "block", @enumToInt(PspSysMemBlockTypes.MemLow), len + @sizeOf(SceUID), null);

            if (id < 0) {
                //TODO: Handle error cases that aren't out of memory...
                return Allocator.Error.OutOfMemory;
            }

            //Get the head address
            var ptr = @ptrCast([*]u32, @alignCast(4, sceKernelGetBlockHeadAddr(id)));

            //Store our ID to free
            @ptrCast(*c_int, ptr).* = id;

            //Convert and return
            var ptr2 = @ptrCast([*]u8, ptr);
            ptr2 += @sizeOf(SceUID);

            return ptr2[0..len];
        }

        return Allocator.Error.OutOfMemory;
    }

    //Our de-allocator
    fn psp_shrink(allocator: *Allocator, buf_unaligned: []u8, buf_align: u29, new_size: usize, len_align: u29, return_address: usize) std.mem.Allocator.Error!usize {

        //Get ptr
        var ptr = @ptrCast([*]u8, buf_unaligned);

        //Go back to our ID
        ptr -= @sizeOf(SceUID);
        var id = @ptrCast(*c_int, @alignCast(4, ptr)).*;

        //Free the ID
        var s = sceKernelFreePartitionMemory(id);

        //Return 0
        return 0;
    }
};
