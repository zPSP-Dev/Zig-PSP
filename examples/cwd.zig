// PSP current working directory example using the std.Io vtable.
//
// Demonstrates processCurrentPath and processSetCurrentPath backed
// by sceIoChdir and a tracked cwd buffer in the PSP Io vtable.
//
// Expected output:
//
//   [1] Initial cwd: ms0:/
//   [2] Changed cwd to: ms0:/PSP
//   [3] Current cwd: ms0:/PSP
//   [4] Changed cwd back to: ms0:/
//   [5] Current cwd: ms0:/
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
    asm (sdk.extra.module.module_info("SDK CWD", .{ .mode = .User }, 1, 0));
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    sdk.extra.utils.enableHBCB();
    sdk.extra.debug.screenInit();

    // [1] Get initial cwd
    var buf: [256]u8 = undefined;
    const len1 = try std.process.currentPath(io, &buf);
    sdk.extra.debug.print("[1] Initial cwd: {s}\n", .{buf[0..len1]});

    // [2] Change cwd to ms0:/PSP
    try std.process.setCurrentPath(io, "ms0:/PSP");
    sdk.extra.debug.print("[2] Changed cwd to: ms0:/PSP\n", .{});

    // [3] Verify new cwd
    const len2 = try std.process.currentPath(io, &buf);
    sdk.extra.debug.print("[3] Current cwd: {s}\n", .{buf[0..len2]});

    // [4] Change back to root
    try std.process.setCurrentPath(io, "ms0:/");
    sdk.extra.debug.print("[4] Changed cwd back to: ms0:/\n", .{});

    // [5] Verify restored cwd
    const len3 = try std.process.currentPath(io, &buf);
    sdk.extra.debug.print("[5] Current cwd: {s}\n", .{buf[0..len3]});

    sdk.extra.debug.print("Done!\n", .{});
}
