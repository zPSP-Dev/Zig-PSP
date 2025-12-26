const std = @import("std");
const mem = std.mem;
const debug = std.debug;
const assert = debug.assert;

const psploadexec = @import("../sdk/psploadexec.zig");
const psp = @import("libzpsp");

const SceSize = psp.SceSize;
const SceUID = psp.SceUID;

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
        _ = allocator;
        _ = len_align;
        _ = ra;
        //Assume alignment is less than double aligns
        assert(len > 0);
        assert(alignment <= @alignOf(c_longdouble));

        //If not allocated - allocate!
        if (len > 0) {

            //Gets a block of memory
            const id: SceUID = psp.sceKernelAllocPartitionMemory(2, "block", @intFromEnum(psploadexec.PspSysMemBlockTypes.MemLow), len + @sizeOf(SceUID), null);

            if (id < 0) {
                //TODO: Handle error cases that aren't out of memory...
                return Allocator.Error.OutOfMemory;
            }

            //Get the head address
            const ptr = @as([*]u32, @ptrCast(@alignCast(psp.sceKernelGetBlockHeadAddr(id))));

            //Store our ID to free
            @as(*c_int, @ptrCast(ptr)).* = id;

            //Convert and return
            var ptr2 = @as([*]u8, @ptrCast(ptr));
            ptr2 += @sizeOf(SceUID);

            return ptr2[0..len];
        }

        return Allocator.Error.OutOfMemory;
    }

    //Our de-allocator
    fn psp_shrink(allocator: *Allocator, buf_unaligned: []u8, buf_align: u29, new_size: usize, len_align: u29, return_address: usize) std.mem.Allocator.Error!usize {
        _ = allocator;
        _ = buf_align;
        _ = new_size;
        _ = len_align;
        _ = return_address;

        //Get ptr
        var ptr = @as([*]u8, @ptrCast(buf_unaligned));

        //Go back to our ID
        ptr -= @sizeOf(SceUID);
        const id = @as(*c_int, @ptrCast(@alignCast(ptr))).*;

        //Free the ID
        const s = psp.sceKernelFreePartitionMemory(id);
        _ = s;

        //Return 0
        return 0;
    }
};
