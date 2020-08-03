usingnamespace @import("constants.zig");
usingnamespace @import("sys/pspge.zig");
usingnamespace @import("sys/pspdisplay.zig");
usingnamespace @import("sys/pspstdio.zig");
usingnamespace @import("sys/pspiofilemgr.zig");

var x : u8 = 0;
var y : u8 = 0;
var vram_off: i32 = 0;
var vram_base: ?[*]u32 = null;

pub fn screenGetX() u8 {
    return x;
}

pub fn screenGetY() u8 {
    return y;
}

pub fn screenSetXY(sX : u8, sY : u8) void{
    x = sX;
    y = sY;
}

pub fn clearScreen() void{
    var i: usize = 0;
    while (i < SCR_BUF_WIDTH * SCREEN_HEIGHT) : (i += 1) {
        vram_base.?[i] = cl_col;
    }
}

var cl_col : u32 = 0xFF000000;
var bg_col : u32 = 0x00000000;
var fg_col : u32 = 0xFFFFFFFF;

pub fn screenSetClearColor(color: u32) void{
    cl_col = color;
}

pub fn screenSetBackColor(color: u32) void{
    bg_col = color;
}
pub fn screenSetFrontColor(color: u32) void{
    fg_col = color;
}

pub fn screenInit() void {
    x = 0;
    y = 0;
    vram_off = 0;

    vram_base = @intToPtr(?[*]u32, 0x40000000 | @ptrToInt(sceGeEdramGetAddr()));
    
    var stat: i32 = 0;
    stat = sceDisplaySetMode(0, SCREEN_WIDTH, SCREEN_HEIGHT);
    stat = sceDisplaySetFrameBuf(vram_base, SCR_BUF_WIDTH, @enumToInt(PspDisplayPixelFormats.Format8888), 1);

    clearScreen();
}

extern var _acmsxfont: [2049]u8;

extern fn internal_msx_glyph(i: usize) u8;

pub fn internal_putchar(cx: u32, cy: u32, ch: u8) void{
    var off : usize = cx + (cy * SCR_BUF_WIDTH);
    
    var i : usize = 0;
    while (i < 8) : (i += 1){
        
        var j: usize = 0;

        while(j < 8) : (j += 1){

            const mask : u32 = 128;

            var idx : u32 = @as(u32, ch) * 8 + i;
            var glyph : u8 = _acmsxfont[idx];
            
            if( (glyph & (mask >> @intCast(@import("std").math.Log2Int(c_int), j))) != 0 ){
                vram_base.?[j + i * SCR_BUF_WIDTH + off] = fg_col;
            }

        }
    }

}
