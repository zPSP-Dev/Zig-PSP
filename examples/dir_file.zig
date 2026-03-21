// PSP directory and file operations example using the std.Io vtable.
//
// Demonstrates directory creation, file I/O, stat, seek, rename, delete,
// and timestamp operations — all routed through the PSP Io vtable.
//
// Expected output:
//
//   [1] Created dir: ms0:/psp_test
//   [2] Created nested dirs: ms0:/psp_test/a/b/c
//   [3] Created and wrote file (13 bytes)
//   [4] File length: 13
//   [5] File stat size: 13
//   [6] Read back: Hello, World!
//   [7] WritePositional at offset 7 ok
//   [8] Full contents: Hello, PSP!!!
//   [9] dirStatFile size: 13
//   [10] fileIsTty: false
//   [11] fileSync ok
//   [12] Renamed hello.txt -> greeting.txt
//   [13] dirAccess greeting.txt: ok
//   [14] Deleted file: greeting.txt
//   [15] Deleted dirs
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
    std.debug.print("[1] Created dir: ms0:/psp_test\n", .{});

    // [2] Create nested directories with dirCreateDirPath
    const path_status = try cwd.createDirPathStatus(io, "ms0:/psp_test/a/b/c", .default_dir);
    std.debug.print("[2] Created nested dirs: ms0:/psp_test/a/b/c ({s})\n", .{@tagName(path_status)});

    // [3] Create and write a file using streaming write
    var file = try cwd.createFile(io, "ms0:/psp_test/hello.txt", .{ .read = true, .truncate = true });
    const msg = "Hello, World!";
    var write_buf: [256]u8 = undefined;
    var writer = file.writer(io, &write_buf);
    try writer.interface.writeAll(msg);
    try writer.interface.flush();
    std.debug.print("[3] Created and wrote file ({} bytes)\n", .{msg.len});

    // [4] File length
    const len = try file.length(io);
    std.debug.print("[4] File length: {}\n", .{len});

    // [5] File stat
    const fstat = try file.stat(io);
    std.debug.print("[5] File stat size: {}\n", .{fstat.size});

    // [6] Read back from position 0
    var read_buf: [64]u8 = undefined;
    var read_bufs = [_][]u8{&read_buf};
    const n = try file.readPositional(io, &read_bufs, 0);
    std.debug.print("[6] Read back: {s}\n", .{read_buf[0..n]});

    // [7] Write at position 7 (overwrite "World!" with "PSP!!!")
    try file.writePositionalAll(io, "PSP!!!", 7);
    std.debug.print("[7] WritePositional at offset 7 ok\n", .{});

    // [8] Read full contents after positional write
    const n2 = try file.readPositional(io, &read_bufs, 0);
    std.debug.print("[8] Full contents: {s}\n", .{read_buf[0..n2]});

    // [9] dirStatFile
    const dstat = try cwd.statFile(io, "ms0:/psp_test/hello.txt", .{});
    std.debug.print("[9] dirStatFile size: {}\n", .{dstat.size});

    // [10] fileIsTty
    const is_tty = try file.isTty(io);
    std.debug.print("[10] fileIsTty: {}\n", .{is_tty});

    // [11] fileSync
    try file.sync(io);
    std.debug.print("[11] fileSync ok\n", .{});

    // Close the file before rename
    file.close(io);

    // [12] Rename
    try cwd.rename("ms0:/psp_test/hello.txt", cwd, "ms0:/psp_test/greeting.txt", io);
    std.debug.print("[12] Renamed hello.txt -> greeting.txt\n", .{});

    // [13] dirAccess
    try cwd.access(io, "ms0:/psp_test/greeting.txt", .{});
    std.debug.print("[13] dirAccess greeting.txt: ok\n", .{});

    // [14] Delete file
    try cwd.deleteFile(io, "ms0:/psp_test/greeting.txt");
    std.debug.print("[14] Deleted file: greeting.txt\n", .{});

    // [15] Delete directories (deepest first)
    try cwd.deleteDir(io, "ms0:/psp_test/a/b/c");
    try cwd.deleteDir(io, "ms0:/psp_test/a/b");
    try cwd.deleteDir(io, "ms0:/psp_test/a");
    try cwd.deleteDir(io, "ms0:/psp_test");
    std.debug.print("[15] Deleted dirs\n", .{});

    std.debug.print("Done!\n", .{});
}
