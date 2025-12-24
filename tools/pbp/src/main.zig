const std = @import("std");

const PBPHeader = extern struct {
    signature: [4]u8 = [_]u8{ 0x00, 'P', 'B', 'P' },
    version: [2]u16 = [_]u16{ 0x00, 0x01 },
    offset: [8]u32 = [_]u32{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },

    comptime {
        std.debug.assert(@sizeOf(PBPHeader) == 40);
    }
};

const default_file_names: [8][]const u8 = [8][]const u8{
    "PARAM.SFO",
    "ICON0.PNG",
    "ICON1.PMF",
    "PIC0.PNG",
    "PIC1.PNG",
    "SND0.AT3",
    "DATA.PSP",
    "DATA.PSAR",
};

fn read_header(reader: std.io.AnyReader) !PBPHeader {
    return try reader.readStruct(PBPHeader);
}

fn validate_header(header: PBPHeader) !void {
    if (!std.mem.eql(u8, header.signature[1..], "PBP")) {
        return error.InvalidSignature;
    }
    if (header.version[1] != 1 and header.version[0] != 0) {
        std.debug.print("Invalid version: {d}.{d}\n", .{ header.version[0], header.version[1] });
        return error.InvalidVersion;
    }
}

pub fn analyze_file(file_path: []const u8) !void {
    var file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    const header = try read_header(file.reader().any());
    try validate_header(header);

    std.debug.print("PBP Header:\n", .{});
    std.debug.print("\tSignature:\t{s}\n", .{header.signature});
    std.debug.print("\tVersion:\t{d}.{d}\n", .{ header.version[1], header.version[0] });
    std.debug.print("Offsets:\n", .{});
    for (header.offset, 0..) |offset, i| {
        if (i + 1 < header.offset.len and header.offset[i + 1] - offset > 0) {
            std.debug.print("\t{s}:\t{d}\n", .{ default_file_names[i], offset });
        } else {
            std.debug.print("\t{s}:\tNULL\n", .{default_file_names[i]});
        }
    }
}

// TODO: Optionally disable validation
pub fn unpack_pbp(allocator: std.mem.Allocator, file_path: []const u8, dir_path: []const u8) !void {
    var file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    const header = try read_header(file.reader().any());
    try validate_header(header);

    try std.fs.cwd().makePath(dir_path);

    // I don't think any PBPs are bigger than 16MB
    const content = try file.reader().readAllAlloc(allocator, std.math.maxInt(u24));

    for (header.offset, 0..) |offset, i| {
        const file_size = if (i + 1 < header.offset.len) header.offset[i + 1] -| offset else content.len -| offset;

        if (file_size == 0) continue;

        const file_name = default_file_names[i];

        const filename = try std.fmt.allocPrint(allocator, "{s}/{s}", .{ dir_path, file_name });
        const out_file = try std.fs.cwd().createFile(filename, .{});
        defer out_file.close();

        const corrected_offset = offset - @sizeOf(PBPHeader);
        try out_file.writer().writeAll(content[corrected_offset .. corrected_offset + file_size]);
    }
}

pub fn pack_pbp(allocator: std.mem.Allocator, paths: []const []const u8) !void {
    const output_path = paths[0];

    const input_paths = paths[1..];
    std.debug.assert(input_paths.len == default_file_names.len);

    const Files = struct {
        file_content: []const u8,
        file_size: u32,
    };

    var files = std.ArrayList(Files).init(allocator);
    defer files.deinit();

    // Gather all files and initialize offsets
    var curr_offset: u32 = @sizeOf(PBPHeader);
    var header: PBPHeader = .{};
    for (input_paths, 0..) |path, i| {
        header.offset[i] = curr_offset;

        if (std.mem.eql(u8, path, "NULL")) {
            try files.append(.{
                .file_content = undefined,
                .file_size = 0,
            });
            continue;
        }

        const in_file = try std.fs.cwd().openFile(path, .{});
        defer in_file.close();

        const file_content = try in_file.readToEndAlloc(allocator, std.math.maxInt(u24));
        try files.append(.{
            .file_content = file_content,
            .file_size = @intCast(file_content.len),
        });

        curr_offset += @intCast(file_content.len);
    }

    var output_file = try std.fs.cwd().createFile(output_path, .{});
    defer output_file.close();

    try output_file.writeAll(std.mem.asBytes(&header));
    for (files.items) |file| {
        if (file.file_size == 0) continue;

        try output_file.writeAll(file.file_content);
    }
}

fn get_arg_list(allocator: std.mem.Allocator, iterator: *std.process.ArgIterator) ![]const []const u8 {
    var list = std.ArrayList([]const u8).init(allocator);
    while (iterator.next()) |arg| {
        try list.append(arg);
    }
    return list.toOwnedSlice();
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
        std.debug.print("Usage: pbptool <pack | unpack | analyze | help>\n", .{});
        std.posix.exit(1);
    }

    const com = commands[0];
    if (std.mem.eql(u8, com, "pack")) {
        if (commands.len < 10) {
            std.debug.print("Usage: pbptool pack <output.pbp> <param.sfo> <icon0.png> <icon1.pmf> <pic0.png> <pic1.png> <snd0.at3> <data.psp> <data.psar>\n", .{});
            std.posix.exit(1);
        }

        try pack_pbp(allocator, commands[1..]);
    } else if (std.mem.eql(u8, com, "unpack")) {
        if (commands.len < 3) {
            std.debug.print("Usage: pbptool unpack <input.pbp> <output_dir>\n", .{});
            std.posix.exit(1);
        }

        try unpack_pbp(allocator, commands[1], commands[2]);
    } else if (std.mem.eql(u8, com, "analyze")) {
        if (commands.len < 2) {
            std.debug.print("Usage: pbptool analyze <input.pbp>\n", .{});
            std.posix.exit(1);
        }

        try analyze_file(commands[1]);
    } else if (std.mem.eql(u8, com, "help")) {
        std.debug.print("Usage: pbptool <pack | unpack | analyze | help>\n", .{});
        std.posix.exit(0);
    } else {
        std.debug.print("Error: Invalid argument '{s}'\n", .{commands[0]});
        std.posix.exit(1);
    }
}
