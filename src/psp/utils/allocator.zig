const std = @import("std");
const mem = std.mem;
const debug = std.debug;
const assert = debug.assert;

usingnamespace @import("sys/psptypes.zig");
usingnamespace @import("sys/pspsysmem.zig");
usingnamespace @import("sys/psploadexec.zig");

const Allocator = mem.Allocator;

// This Allocator is a very basic allocator for the PSP
// It uses the PSP's kernel to allocate and free memory
// This may not be 100% correct for alignment
pub const PSPAllocator = struct{
    allocator: Allocator,

    //Initialize and send back an allocator object
    pub fn init() PSPAllocator {
        return PSPAllocator {
            .allocator = Allocator{
                .reallocFn = psp_realloc,
                .shrinkFn = psp_shrink
            }
        };
    }

    //Our Allocator
    fn psp_realloc (allocator: *Allocator, old_mem: []u8, old_alignment: u29, new_byte_count: usize, new_alignment: u29) std.mem.Allocator.Error![]u8{
        //Assume alignment is less than double aligns
        assert(new_alignment <= @alignOf(c_longdouble));

        //If not allocated - allocate!
        if(old_mem.len == 0){
            
            //Gets a block of memory
            var id : SceUID = sceKernelAllocPartitionMemory(2, "block", @enumToInt(PspSysMemBlockTypes.MemLow), new_byte_count + @sizeOf(SceUID), null);

            if(id < 0){
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

            return ptr2[0..new_byte_count];
        }

        return Allocator.Error.OutOfMemory;
    }

    //Our de-allocator
    fn psp_shrink(allocator: *Allocator, old_mem: []u8, old_alignment: u29, new_byte_count: usize, new_alignment: u29) []u8{
        
        //Get ptr
        var ptr = @ptrCast([*]u8, old_mem);
        
        //Go back to our ID
        ptr -= @sizeOf(SceUID);
        var id = @ptrCast(*c_int, @alignCast(4, ptr)).*;

        //Free the ID
        var s = sceKernelFreePartitionMemory(id);

        //Return our memory back
        return old_mem[0..new_byte_count];
    }
};
