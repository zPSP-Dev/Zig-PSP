usingnamespace @import("sys/pspgu.zig");

var vramOff : usize = 0;

fn getMemSize(width: u32, height: u32, format: GuPixelMode) c_uint {
    switch(format){
        GuPixelMode.PsmT4 => return width * height / 2,

        GuPixelMode.PsmT8 => return width * height,

        GuPixelMode.Psm5650, GuPixelMode.Psm5551, GuPixelMode.Psm4444, GuPixelMode.PsmT16 => return 2 * width * height,
        
        GuPixelMode.Psm8888, GuPixelMode.PsmT32 => return 4 * width * height,
        
        else => return 0
    }
}

pub fn allocVramDirect(width: u32, height: u32, format: GuPixelMode) *c_void {
    var res = vramOff;
    vramOff += getMemSize(width, height, format);

    return @intToPtr(vramOff);
}

pub fn allocVramAbsolute(width: u32, height: u32, format: GuPixelMode) *c_void {
    return @intToPtr(@ptrToInt(allocVramDirect(width, height, format)) + @ptrToInt(sceGeEdramGetAddr));
}