// PSP file I/O example using the std.Io vtable.
//
// Demonstrates createDir, createFile, writeStreamingAll, readStreaming,
// and directory iteration — all routed through the PSP Io vtable
// backed by sceIo* syscalls.
//
// Expected output:
//
//   [1] Created directory: ms0:/psp_io_test
//   [2] Wrote hello.txt
//   [3] Wrote numbers.txt
//   [4] Read hello.txt: Hello from Zig on PSP!
//   [5] Read numbers.txt: 0 1 2 3 4 5 6 7 8 9
//   [6] Directory listing of ms0:/psp_io_test:
//     - hello.txt
//     - numbers.txt
//   Done!
const std = @import("std");
const sdk = @import("pspsdk");

pub const panic = sdk.extra.debug.panic;

// Provide std.Io debug hooks for the PSP
pub const std_options_debug_threaded_io: ?*std.Io.Threaded = null;
pub const std_options_debug_io: std.Io = sdk.extra.Io.psp_io;

// PSP doesn't define PATH_MAX / NAME_MAX in std — provide them via root `os`.
pub const os = struct {
    pub const PATH_MAX: usize = 256;
    pub const NAME_MAX: usize = 256;
};

// Override cwd() since PSP has no AT_FDCWD. We use a sentinel handle;
// the vtable ignores the Dir handle and works with absolute paths.
pub fn std_options_cwd() std.Io.Dir {
    return .{ .handle = -1 };
}

comptime {
    asm(sdk.extra.module.module_info("SDK IO", .{ .mode = .User }, 1, 0));
}

const base_dir = "ms0:/psp_io_test";

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    sdk.extra.utils.enableHBCB();
    sdk.extra.debug.screenInit();

    const cwd = std.Io.Dir.cwd();

    // [1] Create directory
    cwd.createDir(io, base_dir, .default_dir) catch {};
    std.debug.print("[1] Created directory: " ++ base_dir ++ "\n", .{});

    // [2] Write hello.txt
    {
        const file = try cwd.createFile(io, base_dir ++ "/hello.txt", .{});
        defer file.close(io);

        try file.writeStreamingAll(io, "Hello from Zig on PSP!");
        std.debug.print("[2] Wrote hello.txt\n", .{});
    }

    // [3] Write numbers.txt
    {
        const file = try cwd.createFile(io, base_dir ++ "/numbers.txt", .{});
        defer file.close(io);

        try file.writeStreamingAll(io, "0 1 2 3 4 5 6 7 8 9");
        std.debug.print("[3] Wrote numbers.txt\n", .{});
    }

    // [4] Read back hello.txt
    {
        const file = try cwd.openFile(io, base_dir ++ "/hello.txt", .{});
        defer file.close(io);

        var buf: [256]u8 = undefined;
        const n = try file.readStreaming(io, &.{&buf});
        std.debug.print("[4] Read hello.txt: {s}\n", .{buf[0..n]});
    }

    // [5] Read back numbers.txt
    {
        const file = try cwd.openFile(io, base_dir ++ "/numbers.txt", .{});
        defer file.close(io);

        var buf: [256]u8 = undefined;
        const n = try file.readStreaming(io, &.{&buf});
        std.debug.print("[5] Read numbers.txt: {s}\n", .{buf[0..n]});
    }

    // [6] Directory listing
    {
        const dir = try cwd.openDir(io, base_dir, .{ .iterate = true });
        defer dir.close(io);

        std.debug.print("[6] Directory listing of " ++ base_dir ++ ":\n", .{});

        var iter = dir.iterate();
        while (try iter.next(io)) |entry| {
            std.debug.print("  - {s}\n", .{entry.name});
        }
    }

    std.debug.print("Done!\n", .{});
}
