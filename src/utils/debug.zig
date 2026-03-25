const std = @import("std");
const display = @import("../sdk/display.zig");
const pspge = @import("../sdk/ge.zig");
const constants = @import("constants.zig");
const module = @import("module.zig");

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

    vram_base = @as(?[*]u32, @ptrFromInt(0x40000000 | @intFromPtr(pspge.edram_get_addr())));

    display.set_mode(.lcd, constants.SCREEN_WIDTH, constants.SCREEN_HEIGHT) catch {};
    display.set_frame_buf(vram_base, constants.SCR_BUF_WIDTH, .rgba8888, .next_vblank) catch {};

    screenClear();
}

// Print a string directly to screen only (no formatting, no std.debug.print).
pub fn screenPrint(text: []const u8) void {
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

// Format and print to both screen and std.debug.print. No allocation — uses a
// 512-byte stack buffer; output is truncated if the formatted string exceeds it.
pub fn print(comptime fmt: []const u8, args: anytype) void {
    std.debug.print(fmt, args);
    var buf: [512]u8 = undefined;
    const text = std.fmt.bufPrint(&buf, fmt, args) catch &buf;
    screenPrint(text);
}

export fn pspDebugScreenInit() void {
    screenInit();
}

export fn pspDebugScreenClear(color: u32) void {
    screenSetClearColor(color);
    screenClear();
}

export fn pspDebugScreenPrint(text: [*c]const u8) void {
    screenPrint(std.mem.span(text));
}

//Our font
pub const msxFont = @embedFile("./msxfont.bin");

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

            if ((glyph & (mask >> @as(std.math.Log2Int(c_int), @intCast(j)))) != 0) {
                vram_base.?[j + i * constants.SCR_BUF_WIDTH + off] = fg_col;
            } else if (back_col_enable) {
                vram_base.?[j + i * constants.SCR_BUF_WIDTH + off] = bg_col;
            }
        }
    }
}

pub fn printTrace(trace: *std.builtin.StackTrace) void {
    if (trace.index == 0) return;
    print("Stack trace:\n", .{});
    const addrs = trace.instruction_addresses;
    const count = @min(trace.index, addrs.len);
    var i: usize = 0;
    while (i < count) : (i += 1) {
        print("  [{d}] 0x{x:0>8}\n", .{ i, addrs[i] });
    }
}

// Panic handler — import in main via: pub const panic = sdk.extra.debug.panic;
pub fn panic(message: []const u8, stack_trace: ?*std.builtin.StackTrace, size: ?usize) noreturn {
    _ = size;
    screenInit();

    print("!!! PSP HAS PANICKED !!!\n", .{});
    print("REASON: {s}\n", .{message});

    if (stack_trace) |trace| {
        printTrace(trace);
    } else if (@errorReturnTrace()) |trace| {
        printTrace(trace);
    } else {
        print("(no return trace available)\n", .{});
    }

    print("Exiting...", .{});

    module.exitErr();
    while (true) {}
}
