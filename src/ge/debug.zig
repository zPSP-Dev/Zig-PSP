const std = @import("std");
const commands = @import("commands.zig");

const Op = commands.Op;
const command_name = commands.command_name;
const ptr_value = commands.ptr_value;

const max_records = 32;
const max_dump_commands = 256;

const Record = struct {
    qid: i32 = -1,
    start: usize = 0,
    end: usize = 0,
};

pub var enabled: bool = false;
var writer: ?*std.Io.Writer = null;
var records: [max_records]Record = @splat(.{});

pub fn set_enabled(value: bool) void {
    enabled = value;
}

pub fn set_writer(new_writer: ?*std.Io.Writer) void {
    writer = new_writer;
    enabled = new_writer != null;
}

pub fn log(comptime fmt: []const u8, args: anytype) void {
    if (!enabled) return;
    if (writer) |out| {
        out.print(fmt, args) catch {};
    } else {
        std.debug.print(fmt, args);
    }
}

pub fn log_list_call(comptime name: []const u8, list: ?*const anyopaque, stall: ?*anyopaque) void {
    log("{s}(list=0x{X}, stall=0x{X})\n", .{ name, ptr_value(list), ptr_value(stall) });
    dump_list(list, stall);
}

pub fn remember_queue(qid: i32, list: ?*const anyopaque, stall: ?*anyopaque) void {
    if (!enabled) return;
    const start = ptr_value(list);
    const record = find_record(qid) orelse find_free_record() orelse return;
    record.* = .{ .qid = qid, .start = start, .end = ptr_value(stall) };
}

pub fn remember_queue_end(qid: i32, stall: ?*anyopaque) void {
    if (!enabled) return;
    const record = find_record(qid) orelse return;
    record.end = ptr_value(stall);
    if (record.start != 0 and record.end != 0) {
        dump_address_range(record.start, record.end);
    }
}

pub fn remember_list_end(start: [*]const u32, current: [*]const u32) void {
    if (!enabled) return;
    const start_addr = @intFromPtr(start);
    for (&records) |*record| {
        if (record.start == start_addr) {
            record.end = @intFromPtr(current);
            return;
        }
    }
}

fn dump_list(list: ?*const anyopaque, end: ?*const anyopaque) void {
    const start = ptr_value(list);
    if (start == 0) return;
    dump_address_range(start, ptr_value(end));
}

fn dump_address_range(start_addr: usize, end_addr: usize) void {
    if (!enabled) return;
    const start: [*]const u32 = @ptrFromInt(start_addr);
    var count: usize = 0;

    if (end_addr > start_addr) {
        count = @min((end_addr - start_addr) / @sizeOf(u32), max_dump_commands);
    } else {
        while (count < max_dump_commands) : (count += 1) {
            if (@as(u8, @truncate(start[count] >> 24)) == @intFromEnum(Op.end)) {
                count += 1;
                break;
            }
        }
    }

    if (count == 0) {
        log("  <empty command range>\n", .{});
        return;
    }

    var i: usize = 0;
    while (i < count) : (i += 1) {
        const word = start[i];
        const op: u8 = @truncate(word >> 24);
        const argument: u24 = @truncate(word);
        log("  [{d}] {s}(arg=0x{X:0>6}) raw=0x{X:0>8}\n", .{ i, command_name(op), @as(u32, argument), word });
    }

    if (count == max_dump_commands) {
        log("  <dump truncated at {d} commands>\n", .{max_dump_commands});
    }
}

fn find_record(qid: i32) ?*Record {
    for (&records) |*record| {
        if (record.qid == qid) return record;
    }
    return null;
}

fn find_free_record() ?*Record {
    for (&records) |*record| {
        if (record.qid == -1) return record;
    }
    return null;
}
