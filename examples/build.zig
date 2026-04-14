const std = @import("std");
const pspsdk = @import("pspsdk");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});

    inline for (examples) |ex| {
        _ = pspsdk.buildPspEboot(b, .{
            .name = "example_" ++ ex.name,
            .root_source_file = b.path(ex.src),
            .title = ex.title,
            .optimize = optimize,
        }, .{});
    }
}

const Example = struct {
    name: []const u8,
    src: []const u8,
    title: []const u8,
};

const examples = [_]Example{
    .{ .name = "hello_world", .src = "hello_world.zig", .title = "SDK HelloWorld" },
    .{ .name = "allocator", .src = "allocator.zig", .title = "SDK Allocator" },
    .{ .name = "arena", .src = "arena.zig", .title = "SDK Arena" },
    .{ .name = "ziggy_cube", .src = "ziggy_cube.zig", .title = "SDK Ziggy Cube" },
    .{ .name = "clear_screen", .src = "clearScreen.zig", .title = "SDK Clear Screen" },
    .{ .name = "error", .src = "error.zig", .title = "SDK Error" },
    .{ .name = "panic", .src = "panic.zig", .title = "SDK Panic" },
    .{ .name = "print", .src = "print.zig", .title = "SDK Print" },
    .{ .name = "io", .src = "io.zig", .title = "SDK IO" },
    .{ .name = "time_random", .src = "time_random.zig", .title = "SDK Time Random" },
    .{ .name = "cwd", .src = "cwd.zig", .title = "SDK CWD" },
    .{ .name = "dir_file", .src = "dir_file.zig", .title = "SDK Dir File" },
    .{ .name = "network", .src = "network.zig", .title = "SDK Network" },
    .{ .name = "http", .src = "http.zig", .title = "SDK HTTP" },
    .{ .name = "https", .src = "https.zig", .title = "SDK HTTPS" },
};
