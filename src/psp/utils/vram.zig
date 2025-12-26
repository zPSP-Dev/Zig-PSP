//This is probably broken
const gu = @import("../sdk/pspgu.zig");
const ge = @import("../sdk/pspge.zig");
const display = @import("../sdk/pspdisplay.zig");

const libzpsp = @import("libzpsp");
const libzpsp_ge = libzpsp.sceGe_user;

//This isn't an actual "allocator" per se
//It allocates static chunks of VRAM
//TODO: Replace with dynamic VRAM allocator

var vramOff: usize = 0;

//Get the amount of memory needed
fn getMemSize(width: u32, height: u32, format: gu.types.GuPixelMode) c_uint {
    switch (format) {
        .PsmT4 => {
            return width * height / 2;
        },

        .PsmT8 => {
            return width * height;
        },

        .Psm5650, .Psm5551, .Psm4444, .PsmT16 => {
            return width * height * 2;
        },

        .Psm8888, .PsmT32 => {
            return width * height * 4;
        },

        else => return 0,
    }
}

//Allocate a buffer of VRAM in VRAM-Relative pointers (0 is 0x04000000)
pub fn allocVramRelative(width: u32, height: u32, format: gu.types.GuPixelMode) ?*anyopaque {
    const res = vramOff;
    vramOff += getMemSize(width, height, format);
    return @as(?*anyopaque, @ptrFromInt(res));
}

pub fn allocVramAbsolute(width: u32, height: u32, format: gu.types.GuPixelMode) *align(16) anyopaque {
    const relative_offset = allocVramRelative(width, height, format);
    return @ptrFromInt(@intFromPtr(relative_offset) + @intFromPtr(libzpsp_ge.sceGeEdramGetAddr()));
}
