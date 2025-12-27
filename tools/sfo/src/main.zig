const std = @import("std");

pub const SFOHeader = extern struct {
    magic: [4]u8 = [_]u8{ '\x00', 'P', 'S', 'F' },
    version: [4]u8 = [_]u8{ 1, 1, 0, 0 },
    key_start: u32,
    data_start: u32,
    entry_count: u32,

    comptime {
        std.debug.assert(@sizeOf(SFOHeader) == 20);
    }
};

pub const TableDataType = enum(u16) {
    Bin = 0x0004,
    UTF8 = 0x0204,
    Int32 = 0x0404,
};

pub const TableEntry = extern struct {
    key_offset: u16,
    data_fmt: TableDataType,
    data_len: u32,
    data_max_len: u32,
    data_offset: u32,

    comptime {
        std.debug.assert(@sizeOf(TableEntry) == 16);
        std.debug.assert(@offsetOf(TableEntry, "data_fmt") == 2);
    }
};

pub const SFOStructure = struct {
    header: SFOHeader,
    table: []TableEntry,
    key_pool: []u8,
    data_pool: []u8,
};

const InternalEntry = struct {
    name: [:0]const u8,
    type: TableDataType,
    value: ?i32,
    data: ?[]const u8,
    maxsize: u32,
};

const DefaultTable = [_]InternalEntry{
    .{ .name = "MEMSIZE", .type = .Int32, .value = 1, .data = null, .maxsize = 4 },
    .{ .name = "BOOTABLE", .type = .Int32, .value = 1, .data = null, .maxsize = 4 },
    .{ .name = "CATEGORY", .type = .UTF8, .value = 0, .data = "MG", .maxsize = 4 },
    .{ .name = "DISC_ID", .type = .UTF8, .value = 0, .data = "UCJS10041", .maxsize = 12 },
    .{ .name = "DISC_VERSION", .type = .UTF8, .value = 0, .data = "1.00", .maxsize = 8 },
    .{ .name = "PARENTAL_LEVEL", .type = .Int32, .value = 1, .data = null, .maxsize = 4 },
    .{ .name = "PSP_SYSTEM_VER", .type = .UTF8, .value = 0, .data = "1.00", .maxsize = 8 },
    .{ .name = "REGION", .type = .Int32, .value = 0x8000, .data = null, .maxsize = 4 },
};

fn readSFO(allocator: std.mem.Allocator, path: []const u8) !SFOStructure {
    var file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    var buffer: [4096]u8 = undefined;
    var reader = file.reader(&buffer);
    const io_reader = &reader.interface;

    const header = try io_reader.takeStruct(SFOHeader, .little);
    var entries = try allocator.alloc(TableEntry, header.entry_count);
    for (0..header.entry_count) |i| {
        entries[i] = try io_reader.takeStruct(TableEntry, .little);
    }

    const currPos = try file.getPos();
    std.debug.assert(currPos == header.key_start);

    const keyLen = header.data_start - header.key_start;
    const key_pool = try allocator.alloc(u8, keyLen);
    _ = try io_reader.readSliceAll(key_pool);

    const data_pool = try file.readToEndAlloc(allocator, std.math.maxInt(u24));

    return SFOStructure{
        .header = header,
        .table = entries,
        .key_pool = key_pool,
        .data_pool = data_pool,
    };
}

fn get_arg_list(allocator: std.mem.Allocator, iterator: *std.process.ArgIterator) ![]const []const u8 {
    var list = std.array_list.Managed([]const u8).init(allocator);
    while (iterator.next()) |arg| {
        try list.append(arg);
    }
    return list.toOwnedSlice();
}

pub fn prettyPrintSFO(allocator: std.mem.Allocator, path: []const u8) !void {
    const sfo = try readSFO(allocator, path);
    std.debug.print("Header:\n", .{});
    std.debug.print("\tMagic: {s}\n", .{sfo.header.magic});
    std.debug.print("\tVersion: {d}.{d}\n", .{ sfo.header.version[0], sfo.header.version[1] });
    std.debug.print("\tKey Start: 0x{X}\n", .{sfo.header.key_start});
    std.debug.print("\tData Start: 0x{X}\n", .{sfo.header.data_start});
    std.debug.print("\tEntries: {d}\n", .{sfo.header.entry_count});

    std.debug.print("\nEntries:\n", .{});
    for (sfo.table, 0..) |entry, index| {
        std.debug.print("Index: {d}\n", .{index});

        // Slice to Zero
        const keyslice = sfo.key_pool[entry.key_offset..];
        const keyname = std.mem.span(@as([*:0]u8, @ptrCast(keyslice.ptr)));

        std.debug.print("\tKey: {s}\n", .{keyname});
        std.debug.print("\tType: {s}\n", .{@tagName(entry.data_fmt)});
        std.debug.print("\tOffset: 0x{X}\n", .{entry.data_offset});
        std.debug.print("\tSize: {d}\n", .{entry.data_len});
        std.debug.print("\tMax Size: {d}\n", .{entry.data_max_len});

        switch (entry.data_fmt) {
            .UTF8 => {
                const data = sfo.data_pool[entry.data_offset .. entry.data_offset + entry.data_len];
                std.debug.print("\tValue: {s}\n", .{std.mem.span(@as([*:0]u8, @ptrCast(data.ptr)))});
            },
            .Int32 => {
                const data = sfo.data_pool[entry.data_offset .. entry.data_offset + entry.data_len];
                std.debug.print("\tValue: 0x{X}\n", .{std.mem.bytesAsValue(i32, data).*});
            },
            .Bin => {
                const data = sfo.data_pool[entry.data_offset .. entry.data_offset + entry.data_len];
                std.debug.print("\tValue: {X}\n", .{data});
            },
        }
    }
}

pub fn writeSFO(allocator: std.mem.Allocator, path: []const u8, entries: []InternalEntry) !void {
    var data_segment = std.array_list.Managed(u8).init(allocator);
    var key_segment = std.array_list.Managed(u8).init(allocator);

    var table_entries = std.array_list.Managed(TableEntry).init(allocator);
    const PAD = [_]u8{0} ** 4;
    for (entries) |entry| {
        const data_len = if (entry.type == .Int32) @sizeOf(i32) else if (entry.type == .Bin) entry.data.?.len else entry.data.?.len + 1;
        const data_max_len = if (data_len % 4 == 0) data_len else data_len + 4 - (data_len % 4);

        const data_padding = PAD[0..(4 - data_len % 4)];

        try table_entries.append(.{
            .key_offset = @intCast(key_segment.items.len),
            .data_offset = @intCast(data_segment.items.len),
            .data_fmt = entry.type,
            .data_len = @intCast(data_len),
            .data_max_len = @intCast(data_max_len),
        });

        try key_segment.insertSlice(key_segment.items.len, entry.name);
        try key_segment.insertSlice(key_segment.items.len, "\x00");

        if (entry.type == .Int32) {
            try data_segment.insertSlice(data_segment.items.len, std.mem.asBytes(&entry.value.?));
        } else {
            try data_segment.insertSlice(data_segment.items.len, entry.data.?);
        }

        if (data_len % 4 != 0) {
            try data_segment.insertSlice(data_segment.items.len, data_padding);
            if (entry.type == .UTF8) {
                try data_segment.insertSlice(data_segment.items.len, "\x00");
            }
        }
    }

    if (key_segment.items.len % 4 != 0) {
        try key_segment.insertSlice(key_segment.items.len, PAD[0..(4 - key_segment.items.len % 4)]);
    }

    const sfo = SFOStructure{
        .header = SFOHeader{
            .key_start = @intCast(@sizeOf(SFOHeader) + @sizeOf(TableEntry) * entries.len),
            .entry_count = @intCast(entries.len),
            .data_start = @intCast(@sizeOf(SFOHeader) + @sizeOf(TableEntry) * entries.len + key_segment.items.len),
        },
        .table = try table_entries.toOwnedSlice(),
        .key_pool = try key_segment.toOwnedSlice(),
        .data_pool = try data_segment.toOwnedSlice(),
    };

    const file = try std.fs.cwd().createFile(path, .{});
    defer file.close();

    var buffer_writer: [4096]u8 = undefined;
    var writer = file.writer(&buffer_writer);
    var io_writer = &writer.interface;

    try io_writer.writeStruct(sfo.header, .little);
    for (sfo.table) |entry| {
        try io_writer.writeStruct(entry, .little);
    }
    try io_writer.writeAll(sfo.key_pool);
    try io_writer.writeAll(sfo.data_pool);
    try io_writer.flush();
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    var arena = std.heap.ArenaAllocator.init(gpa.allocator());
    defer arena.deinit();

    const allocator = arena.allocator();

    var arg_it = try std.process.argsWithAllocator(allocator);
    _ = arg_it.skip();

    const commands = try get_arg_list(allocator, &arg_it);

    if (commands.len == 0) {
        std.debug.print("Usage: sfotool <read | write>\n", .{});
        std.posix.exit(1);
    }

    const com = commands[0];
    if (std.mem.eql(u8, com, "read")) {
        if (commands.len < 2) {
            std.debug.print("Usage: sfotool read <file>\n", .{});
            std.posix.exit(1);
        }
        try prettyPrintSFO(allocator, commands[1]);
    } else if (std.mem.eql(u8, com, "write")) {
        if (commands.len < 3) {
            std.debug.print("Usage: sfotool write <TITLE> <out.sfo>\n", .{});
            std.posix.exit(1);
        }
        const entries = try allocator.alloc(InternalEntry, 1 + DefaultTable.len);
        entries[DefaultTable.len] = .{
            .name = "TITLE",
            .type = .UTF8,
            .value = null,
            .data = commands[1],
            .maxsize = @intCast(commands[1].len + if (commands[1].len % 4 != 0) 4 - (commands[1].len % 4) else 0),
        };

        for (0..DefaultTable.len) |i| {
            entries[i] = DefaultTable[i];
        }

        try writeSFO(allocator, commands[2], entries);
    } else {
        std.debug.print("Usage: sfotool <read | write>\n", .{});
        std.posix.exit(1);
    }
}
