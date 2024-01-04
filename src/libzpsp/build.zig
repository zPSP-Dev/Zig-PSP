const std = @import("std");

pub fn build(b: *std.Build) void {
    var feature_set: std.Target.Cpu.Feature.Set = std.Target.Cpu.Feature.Set.empty;
    feature_set.addFeature(@intFromEnum(std.Target.mips.Feature.single_float));

    const target = .{
        .cpu_arch = .mipsel,
        .os_tag = .freestanding,
        .cpu_model = .{ .explicit = &std.Target.mips.cpu.mips2 },
        .cpu_features_add = feature_set,
    };

    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "zpsp",
        .root_source_file = .{ .path = "libzpsp.zig" },
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(lib);
}
