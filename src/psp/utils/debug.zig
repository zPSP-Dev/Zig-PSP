const psp = @import("psp");
const pspdisplay = @import("../sdk/pspdisplay.zig");
const constants = @import("constants.zig");

const builtin = @import("builtin");

//Internal variables for the screen
var x: u8 = 0;
var y: u8 = 0;
var vram_base: ?[*]u32 = null;

//Gets your "cursor" X position
pub fn screenGetX() u8 {
    return x;
}

//Gets your "cursor" Y position
pub fn screenGetY() u8 {
    return y;
}

//Sets the "cursor" position
pub fn screenSetXY(sX: u8, sY: u8) void {
    x = sX;
    y = sY;
}

//Clears the screen to the clear color (default is black)
pub fn screenClear() void {
    var i: usize = 0;
    while (i < constants.SCR_BUF_WIDTH * constants.SCREEN_HEIGHT) : (i += 1) {
        vram_base.?[i] = cl_col;
    }
}

//Color variables
var cl_col: u32 = 0xFF000000;
var bg_col: u32 = 0x00000000;
var fg_col: u32 = 0xFFFFFFFF;

//Set the background color
pub fn screenSetClearColor(color: u32) void {
    cl_col = color;
}

var back_col_enable: bool = false;

//Enable text highlight
pub fn screenEnableBackColor() void {
    back_col_enable = true;
}

//Disable text highlight
pub fn screenDisableBackColor() void {
    back_col_enable = false;
}

//Set highlight color
pub fn screenSetBackColor(color: u32) void {
    bg_col = color;
}

//Set text color
pub fn screenSetFrontColor(color: u32) void {
    fg_col = color;
}

//Initialize the screen
pub fn screenInit() void {
    x = 0;
    y = 0;

    vram_base = @as(?[*]u32, @ptrFromInt(0x40000000 | @intFromPtr(psp.sceGeEdramGetAddr())));

    _ = psp.sceDisplaySetMode(0, constants.SCREEN_WIDTH, constants.SCREEN_HEIGHT);
    _ = psp.sceDisplaySetFrameBuf(vram_base, constants.SCR_BUF_WIDTH, @intFromEnum(pspdisplay.PspDisplayPixelFormats.Format8888), @intFromEnum(pspdisplay.PspDisplaySetBufSync.Nextframe));

    screenClear();
}

//Print out a constant string
pub fn print(text: []const u8) void {
    var i: usize = 0;
    while (i < text.len) : (i += 1) {
        if (text[i] == '\n') {
            y += 1;
            x = 0;
        } else if (text[i] == '\t') {
            x += 4;
        } else {
            internal_putchar(@as(u32, x) * 8, @as(u32, y) * 8, text[i]);
            x += 1;
        }

        if (x > 60) {
            x = 0;
            y += 1;
            if (y > 34) {
                y = 0;
                screenClear();
            }
        }
    }
}

export fn pspDebugScreenInit() void {
    screenInit();
}

export fn pspDebugScreenClear(color: u32) void {
    screenSetClearColor(color);
    screenClear();
}

export fn pspDebugScreenPrint(text: [*c]const u8) void {
    print(std.mem.span(text));
}

const std = @import("std");

//Print with formatting via the default PSP allocator
pub fn printFormat(comptime fmt: []const u8, args: anytype) !void {
    const alloc = @import("allocator.zig");
    var psp_allocator = &alloc.PSPAllocator.init().allocator;

    const string = try std.fmt.allocPrint(psp_allocator, fmt, args);
    defer psp_allocator.free(string);

    print(string);
}

//Our font
pub const msxFont = @embedFile("./msxfont2.bin");

//Puts a character to screen
fn internal_putchar(cx: u32, cy: u32, ch: u8) void {
    const off: usize = cx + (cy * constants.SCR_BUF_WIDTH);

    var i: usize = 0;
    while (i < 8) : (i += 1) {
        var j: usize = 0;

        while (j < 8) : (j += 1) {
            const mask: u32 = 128;

            const idx: u32 = @as(u32, ch - 32) * 8 + i;
            const glyph: u8 = msxFont[idx];

            if ((glyph & (mask >> @as(@import("std").math.Log2Int(c_int), @intCast(j)))) != 0) {
                vram_base.?[j + i * constants.SCR_BUF_WIDTH + off] = fg_col;
            } else if (back_col_enable) {
                vram_base.?[j + i * constants.SCR_BUF_WIDTH + off] = bg_col;
            }
        }
    }
}

const module = @import("module.zig");

//Meme panic
pub var pancakeMode: bool = false;

//Panic handler
//Import this in main to use!
pub fn panic(message: []const u8, stack_trace: ?*std.builtin.StackTrace, size: ?usize) noreturn {
    _ = size; // autofix
    _ = stack_trace;
    screenInit();

    if (pancakeMode) {
        //For @mrneo240
        print("!!! PSP HAS PANCAKED !!!\n");
    } else {
        print("!!! PSP HAS PANICKED !!!\n");
    }

    print("REASON: ");
    print(message);
    //TODO: Stack Traces after STD.
    //if (@errorReturnTrace()) |trace| {
    //    std.debug.dumpStackTrace(trace.*);
    //}
    print("\nExiting in 10 seconds...");

    module.exitErr();
    while (true) {}
}
