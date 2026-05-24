// PSP directory and file operations example using the std.Io vtable.
//
// Demonstrates directory creation, file I/O, stat, seek, rename, delete,
// and timestamp operations -- all routed through the PSP Io vtable.
//
// Expected output:
//
//   [1] Created dir: ms0:/psp_test
//   [2] Created nested dirs: ms0:/psp_test/a/b/c
//   [3] Dir-relative file stat size: 8
//   [4] Created and wrote file (13 bytes)
//   [5] File length: 13
//   [6] File stat size: 13
//   [7] Read back: Hello, World!
//   [8] WritePositional at offset 7 ok
//   [9] Full contents: Hello, PSP!!!
//   [10] dirStatFile size: 13
//   [11] fileIsTty: false
//   [12] fileSync ok
//   [13] Renamed hello.txt -> greeting.txt
//   [14] dirAccess greeting.txt: ok
//   [15] Deleted file: greeting.txt
//   [16] Deleted dirs
//   Done!
const std = @import("std");
const sdk = @import("pspsdk");

pub const panic = sdk.extra.debug.panic;

pub const std_options_debug_threaded_io: ?*std.Io.Threaded = null;
pub const std_options_debug_io: std.Io = sdk.extra.Io.psp_io;

pub fn std_options_cwd() std.Io.Dir {
    return .{ .handle = -1 };
}

comptime {
    asm (sdk.extra.module.module_info("SDK Dir File", .{ .mode = .User }, 1, 0));
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    sdk.extra.utils.enableHBCB();
    sdk.extra.debug.screenInit();

    const cwd = std.Io.Dir{ .handle = -1 };

    // [1] Create a test directory
    try cwd.createDir(io, "ms0:/psp_test", .default_dir);
    sdk.extra.debug.print("[1] Created dir: ms0:/psp_test\n", .{});

    // [2] Create nested directories with dirCreateDirPath
    const path_status = try cwd.createDirPathStatus(io, "ms0:/psp_test/a/b/c", .default_dir);
    sdk.extra.debug.print("[2] Created nested dirs: ms0:/psp_test/a/b/c ({s})\n", .{@tagName(path_status)});

    // [3] Create/stat/delete a file relative to an opened directory
    {
        var test_dir = try cwd.openDir(io, "ms0:/psp_test", .{});
        defer test_dir.close(io);

        {
            var rel_file = try test_dir.createFile(io, "relative.txt", .{ .read = true, .truncate = true });
            defer rel_file.close(io);

            const rel_msg = "relative";
            var rel_write_buf: [64]u8 = undefined;
            var rel_writer = rel_file.writer(io, &rel_write_buf);
            try rel_writer.interface.writeAll(rel_msg);
            try rel_writer.interface.flush();
        }

        const rel_stat = try cwd.statFile(io, "ms0:/psp_test/relative.txt", .{});
        try test_dir.deleteFile(io, "relative.txt");
        sdk.extra.debug.print("[3] Dir-relative file stat size: {}\n", .{rel_stat.size});
    }

    // [4] Create and write a file using streaming write
    var file = try cwd.createFile(io, "ms0:/psp_test/hello.txt", .{ .read = true, .truncate = true });
    const msg = "Hello, World!";
    var write_buf: [256]u8 = undefined;
    var writer = file.writer(io, &write_buf);
    try writer.interface.writeAll(msg);
    try writer.interface.flush();
    sdk.extra.debug.print("[4] Created and wrote file ({} bytes)\n", .{msg.len});

    // [5] File length
    const len = try file.length(io);
    sdk.extra.debug.print("[5] File length: {}\n", .{len});

    // [6] File stat
    const fstat = try file.stat(io);
    sdk.extra.debug.print("[6] File stat size: {}\n", .{fstat.size});

    // [7] Read back from position 0
    var read_buf: [64]u8 = undefined;
    var read_bufs = [_][]u8{&read_buf};
    const n = try file.readPositional(io, &read_bufs, 0);
    sdk.extra.debug.print("[7] Read back: {s}\n", .{read_buf[0..n]});

    // [8] Write at position 7 (overwrite "World!" with "PSP!!!")
    try file.writePositionalAll(io, "PSP!!!", 7);
    sdk.extra.debug.print("[8] WritePositional at offset 7 ok\n", .{});

    // [9] Read full contents after positional write
    const n2 = try file.readPositional(io, &read_bufs, 0);
    sdk.extra.debug.print("[9] Full contents: {s}\n", .{read_buf[0..n2]});

    // [10] dirStatFile
    const dstat = try cwd.statFile(io, "ms0:/psp_test/hello.txt", .{});
    sdk.extra.debug.print("[10] dirStatFile size: {}\n", .{dstat.size});

    // [11] fileIsTty
    const is_tty = try file.isTty(io);
    sdk.extra.debug.print("[11] fileIsTty: {}\n", .{is_tty});

    // [12] fileSync
    try file.sync(io);
    sdk.extra.debug.print("[12] fileSync ok\n", .{});

    // Close the file before rename
    file.close(io);

    // [13] Rename
    try cwd.rename("ms0:/psp_test/hello.txt", cwd, "ms0:/psp_test/greeting.txt", io);
    sdk.extra.debug.print("[13] Renamed hello.txt -> greeting.txt\n", .{});

    // [14] dirAccess
    try cwd.access(io, "ms0:/psp_test/greeting.txt", .{});
    sdk.extra.debug.print("[14] dirAccess greeting.txt: ok\n", .{});

    // [15] Delete file
    try cwd.deleteFile(io, "ms0:/psp_test/greeting.txt");
    sdk.extra.debug.print("[15] Deleted file: greeting.txt\n", .{});

    // [16] Delete directories (deepest first)
    try cwd.deleteDir(io, "ms0:/psp_test/a/b/c");
    try cwd.deleteDir(io, "ms0:/psp_test/a/b");
    try cwd.deleteDir(io, "ms0:/psp_test/a");
    try cwd.deleteDir(io, "ms0:/psp_test");
    sdk.extra.debug.print("[16] Deleted dirs\n", .{});

    sdk.extra.debug.print("Done!\n", .{});
}
