const Build = @import("std").Build;
const std = @import("std");

pub fn build(b: *Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{}); // was: std.builtin.Mode.ReleaseFast;

    const exe = b.addExecutable(.{
        .name = "pbptool",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(exe);
    // b.getInstallStep().dependOn(&b.addInstallArtifact(
    //     exe,
    //     .{
    //         .dest_dir = .{ .override = .{
    //             .custom = "../bin/",
    //         } },
    //     },
    // ).step);

    const run = b.step("run", "Run the application");
    const run_cmd = b.addRunArtifact(exe);
    run.dependOn(&run_cmd.step);
}
