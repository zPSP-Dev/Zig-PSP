const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib_mod = b.addModule("libzpsp", .{
        .root_source_file = b.path("src/libzpsp.zig"),
        .target = target,
        .optimize = optimize,
    });

    _ = lib_mod;
}
