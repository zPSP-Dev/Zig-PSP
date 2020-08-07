usingnamespace @import("sys/pspgu.zig");

//This isn't an actual "allocator" per se
//It allocates static chunks of VRAM
//TODO: Replace with dynamic VRAM allocator

var vramOff : usize = 0;

//Get the amount of memory needed
fn getMemSize(width: u32, height: u32, format: GuPixelMode) c_uint {
    switch(format){
        GuPixelMode.PsmT4 => return width * height / 2,

        GuPixelMode.PsmT8 => return width * height,

        GuPixelMode.Psm5650, GuPixelMode.Psm5551, GuPixelMode.Psm4444, GuPixelMode.PsmT16 => return 2 * width * height,
        
        GuPixelMode.Psm8888, GuPixelMode.PsmT32 => return 4 * width * height,
        
        else => return 0
    }
}

//Allocate a buffer of VRAM in VRAM-Relative pointers (0 is 0x04000000)
pub fn allocVramRelative(width: u32, height: u32, format: GuPixelMode) *c_void {
    var res = vramOff;
    vramOff += getMemSize(width, height, format);

    return @intToPtr(vramOff);
}

//Allocate a buffer of VRAM in VRAM-Absolute pointers (0x04000000 start)
pub fn allocVramAbsolute(width: u32, height: u32, format: GuPixelMode) *c_void {
    return @intToPtr(@ptrToInt(allocVramDirect(width, height, format)) + @ptrToInt(sceGeEdramGetAddr));
}