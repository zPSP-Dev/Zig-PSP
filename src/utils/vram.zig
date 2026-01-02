//This is probably broken
const gu = @import("../sdk/pspgu.zig");
const ge = @import("../sdk/pspge.zig");

//This isn't an actual "allocator" per se
//It allocates static chunks of VRAM
//TODO: Replace with dynamic VRAM allocator
var CurrentVramAllocatorOffset: usize = 0;

//Allocate a buffer of VRAM in VRAM-Relative pointers (0 is 0x04000000)
pub fn allocVramRelative(stride: u32, height: u32, format: gu.types.GuPixelFormat) ?*align(16) anyopaque {
    const resource_offset = CurrentVramAllocatorOffset;
    const size_bytes = texture_buffer_size_bytes(stride, height, format);

    CurrentVramAllocatorOffset += size_bytes;

    return @ptrFromInt(resource_offset);
}

pub fn allocVramAbsolute(stride: u32, height: u32, format: gu.types.GuPixelFormat) ?*align(16) anyopaque {
    const relative_offset = allocVramRelative(stride, height, format);

    return @ptrFromInt(@intFromPtr(relative_offset) + @intFromPtr(ge.sceGeEdramGetAddr()));
}

fn texture_buffer_size_bytes(stride_elements: u32, height: u32, format: gu.types.GuPixelFormat) usize {
    const pixel_bits = pixel_format_size_bits(format);
    const buffer_size_bytes = (stride_elements * height * pixel_bits) / 8;

    return buffer_size_bytes;
}

// For block-compressed types, this function returns the theoretical size of a pixel inside of a 4x4 block
pub fn pixel_format_size_bits(pixel_format: gu.types.GuPixelFormat) usize {
    return switch (pixel_format) {
        .Psm5650 => 16,
        .Psm5551 => 16,
        .Psm4444 => 16,
        .Psm8888 => 32,
        .PsmT4 => 4,
        .PsmT8 => 8,
        .PsmT16 => 16,
        .PsmT32 => 32,
        .PsmDxt1, .PsmDxt1Ext => 4,
        .PsmDxt3, .PsmDxt3Ext => 8,
        .PsmDxt5, .PsmDxt5Ext => 8,
    };
}
