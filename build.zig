const Builder = @import("std").build.Builder;
const psp = @import("build-psp.zig");

const std = @import("std");
const z = @import("std").zig;
const builtin = @import("builtin");

pub fn build(b: *Builder) void {
    var feature_set : std.Target.Cpu.Feature.Set = std.Target.Cpu.Feature.Set.empty;
    feature_set.addFeature(@enumToInt(std.Target.mips.Feature.single_float));

    //PSP-Specific Build Options
    const target = z.CrossTarget{
        .cpu_arch = .mipsel,
        .os_tag = .freestanding,
        .cpu_model = .{ .explicit = &std.Target.mips.cpu.mips2 },
        .cpu_features_add = feature_set
    };

    //All of the release modes work
    //Debug Mode can cause issues with trap instructions - use ReleaseSafe for "Debug" builds
    const mode = builtin.Mode.ReleaseSmall;
    
    const lib = b.addStaticLibrary("zpsp", "src/psp/libzpsp.zig");
    lib.setTarget(target);
    lib.setBuildMode(mode);
    lib.setOutputDir("zig-cache/");

    b.default_step.dependOn(&lib.step);
}
