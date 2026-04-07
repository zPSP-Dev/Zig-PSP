const std = @import("std");
const commands = @import("commands.zig");
const debug = @import("debug.zig");

const Command = commands.Command;
const encode_command = commands.encode_command;
const encode_raw = commands.encode_raw;

pub const WriteError = error{
    BufferOverflow,
    InvalidSeek,
};

pub const DisplayList = struct {
    start: [*]u32,
    base: [*]u32,
    end: ?usize,
    writer: std.Io.Writer,

    pub fn init(words: []u32) DisplayList {
        return init_at(words.ptr, words);
    }

    pub fn init_at(start: [*]u32, remaining_words: []u32) DisplayList {
        return init_bytes(start, remaining_words.ptr, std.mem.sliceAsBytes(remaining_words));
    }

    pub fn init_bytes(start: [*]u32, base: [*]u32, buffer_slice: []u8) DisplayList {
        return .{
            .start = start,
            .base = base,
            .end = @intFromPtr(base) + buffer_slice.len,
            .writer = .fixed(buffer_slice),
        };
    }

    pub fn init_unbounded(start: [*]u32, cursor: [*]u32) DisplayList {
        const bytes: [*]u8 = @ptrCast(cursor);
        return .{
            .start = start,
            .base = cursor,
            .end = null,
            .writer = .fixed(bytes[0 .. std.math.maxInt(usize) - @intFromPtr(cursor)]),
        };
    }

    pub fn seek_to_unbounded(self: *DisplayList, cursor: [*]u32) void {
        const bytes: [*]u8 = @ptrCast(cursor);
        self.base = cursor;
        self.end = null;
        self.writer = .fixed(bytes[0 .. std.math.maxInt(usize) - @intFromPtr(cursor)]);
    }

    pub fn seek_to(self: *DisplayList, cursor: [*]u32) WriteError!void {
        if (self.end) |end| {
            const cursor_addr = @intFromPtr(cursor);
            if (cursor_addr < @intFromPtr(self.start) or cursor_addr > end) return error.InvalidSeek;
            if ((cursor_addr - @intFromPtr(self.start)) % @sizeOf(u32) != 0) return error.InvalidSeek;

            const bytes: [*]u8 = @ptrCast(cursor);
            self.base = cursor;
            self.writer = .fixed(bytes[0 .. end - cursor_addr]);
            return;
        }

        self.seek_to_unbounded(cursor);
    }

    pub fn current(self: *const DisplayList) [*]u32 {
        return @ptrFromInt(@intFromPtr(self.base) + self.writer.end);
    }

    pub fn used_bytes(self: DisplayList) usize {
        return @intFromPtr(self.current()) - @intFromPtr(self.start);
    }

    pub fn used_words(self: DisplayList) usize {
        return self.used_bytes() / @sizeOf(u32);
    }

    pub fn write_command(self: *DisplayList, command: Command) WriteError!void {
        try self.write_word(encode_command(command));
    }

    pub fn write_raw(self: *DisplayList, op: u8, argument: u24) WriteError!void {
        try self.write_word(encode_raw(op, argument));
    }

    pub fn write_word(self: *DisplayList, word: u32) WriteError!void {
        self.writer.writeInt(u32, word, .little) catch return error.BufferOverflow;
        debug.remember_list_end(self.start, self.current());
    }
};

test "DisplayList reports write overflow" {
    var words: [1]u32 = undefined;
    var list = DisplayList.init(words[0..]);

    try list.write_word(encode_raw(0x00, 0));
    try std.testing.expectError(error.BufferOverflow, list.write_word(encode_raw(0x00, 0)));
}

test "DisplayList reports invalid bounded seek" {
    var words: [1]u32 = undefined;
    var list = DisplayList.init(words[0..]);

    try std.testing.expectError(error.InvalidSeek, list.seek_to(words[1..].ptr + 1));
}
