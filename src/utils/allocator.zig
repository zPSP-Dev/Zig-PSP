// FIXME This file is all sorts of broken ATM, a proper rework is needed
const std = @import("std");

const loadexec = @import("../sdk/psploadexec.zig");
const sysmem = @import("../sdk/pspsysmem.zig");
const SceUID = sysmem.SceUID;

// This Allocator is a very basic allocator for the PSP
// It uses the PSP's kernel to allocate and free memory
// This may not be 100% correct for alignment
pub const PSPAllocator = struct {
    pub fn init(self: *@This()) std.mem.Allocator {
        const vtable = std.mem.Allocator.VTable{
            .alloc = PSPAllocator.alloc,
            .resize = PSPAllocator.resize,
            .remap = unreachable, // FIXME
            .free = unreachable, // FIXME
        };

        return std.mem.Allocator{
            .ptr = self,
            .vtable = &vtable,
        };
    }

    //Our Allocator
    fn alloc(allocator: *anyopaque, len: usize, alignment: std.mem.Alignment, ret_addr: usize) ?[*]u8 {
        _ = allocator;
        _ = ret_addr;

        //Assume alignment is less than double aligns
        std.debug.assert(len > 0);
        std.debug.assert(alignment.compare(.gte, .@"64"));

        //If not allocated - allocate!
        if (len > 0) {
            //Gets a block of memory
            const id = sysmem.sceKernelAllocPartitionMemory(.User, "block", .MemLow, len + @sizeOf(SceUID), null);

            if (id < 0) {
                //TODO: Handle error cases that aren't out of memory...
                return std.mem.Allocator.Error.OutOfMemory;
            }

            //Get the head address
            const ptr = @as([*]u32, @ptrCast(@alignCast(sysmem.sceKernelGetBlockHeadAddr(id))));

            //Store our ID to free
            @as(*c_int, @ptrCast(ptr)).* = id;

            //Convert and return
            var ptr2 = @as([*]u8, @ptrCast(ptr));
            ptr2 += @sizeOf(SceUID);

            return ptr2[0..len];
        }

        return null; // FIXME what about errors?
    }

    fn resize(allocator: *anyopaque, memory: []u8, alignment: std.mem.Alignment, new_len: usize, ret_addr: usize) bool {
        _ = allocator;
        _ = new_len;
        _ = ret_addr;

        std.debug.assert(alignment.compare(.gte, .@"64"));

        // Get ptr
        var ptr = @as([*]u8, @ptrCast(memory));

        // Go back to our ID
        ptr -= @sizeOf(SceUID);
        const id = @as(*c_int, @ptrCast(@alignCast(ptr))).*;

        // Free the ID
        const s = sysmem.sceKernelFreePartitionMemory(id);
        _ = s;

        return true;
    }
};
