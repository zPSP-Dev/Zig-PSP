const Builder = @import("std").build.Builder;
const z = @import("std").zig;
const std = @import("std");
const builtin = std.builtin;

pub const PSPBuildInfo = struct{
    //SDK Path
    path_to_sdk: []const u8,
    src_file: []const u8,
    //Title
    title: []const u8,
    //Optional customizations
    icon0: []const u8 = "NULL",
    icon1: []const u8 = "NULL",
    pic0: []const u8 = "NULL",
    pic1: []const u8 = "NULL",
    snd0: []const u8 = "NULL",
};

const append : []const u8 = switch(builtin.os.tag){
    .windows => ".exe",
    else => "",
};

pub fn build_psp(b: *Builder, comptime build_info: PSPBuildInfo) !void {
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

    //Build from your main file!
    const exe = b.addExecutable("main", build_info.src_file);

    //Set mode & target
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.setLinkerScriptPath(build_info.path_to_sdk ++ "tools/linkfile.ld");
    exe.link_eh_frame_hdr = true;
    exe.link_emit_relocs = true;
    exe.strip = true;
    exe.single_threaded = true;
    exe.install();
    exe.setOutputDir("zig-cache/");

    //Post-build actions
    const hostTarget = b.standardTargetOptions(.{});
    const prx = b.addExecutable("prxgen", build_info.path_to_sdk ++ "tools/prxgen/stub.zig");
    prx.setTarget(hostTarget);
    prx.addCSourceFile(build_info.path_to_sdk ++ "tools/prxgen/psp-prxgen.c", &[_][]const u8{"-std=c99", "-Wno-address-of-packed-member", "-D_CRT_SECURE_NO_WARNINGS"});
    prx.linkLibC();
    prx.setBuildMode(builtin.Mode.ReleaseFast);
    prx.setOutputDir(build_info.path_to_sdk ++ "tools/bin");
    prx.install();
    prx.step.dependOn(&exe.step);

    const generate_prx = b.addSystemCommand(&[_][]const u8{
        build_info.path_to_sdk ++ "tools/bin/prxgen" ++ append,
        "zig-cache/main",
        "app.prx"
    });
    generate_prx.step.dependOn(&prx.step);

    //Build SFO
    const sfo = b.addExecutable("sfotool", build_info.path_to_sdk ++ "tools/sfo/src/main.zig");
    sfo.setTarget(hostTarget);
    sfo.setBuildMode(builtin.Mode.ReleaseFast);
    sfo.setOutputDir(build_info.path_to_sdk ++ "tools/bin");
    sfo.install();
    sfo.step.dependOn(&generate_prx.step);

    //Make the SFO file
    const mk_sfo = b.addSystemCommand(&[_][]const u8{
        build_info.path_to_sdk ++ "tools/bin/sfotool" ++ append, "write",
        build_info.title,
        "PARAM.SFO"
    });
    mk_sfo.step.dependOn(&sfo.step);


    //Build PBP
    const PBP = b.addExecutable("pbptool", build_info.path_to_sdk ++ "tools/pbp/src/main.zig");
    PBP.setTarget(hostTarget);
    PBP.setBuildMode(builtin.Mode.ReleaseFast);
    PBP.setOutputDir(build_info.path_to_sdk ++ "tools/bin");
    PBP.install();
    PBP.step.dependOn(&mk_sfo.step);

    //Pack the PBP executable
    const pack_pbp = b.addSystemCommand(&[_][]const u8{
        build_info.path_to_sdk ++ "tools/bin/pbptool" ++ append, "pack",
        "EBOOT.PBP",
        "PARAM.SFO",
        build_info.icon0,
        build_info.icon1,
        build_info.pic0,
        build_info.pic1,
        build_info.snd0,
        "app.prx",
        "NULL" //DATA.PSAR not necessary.
    });
    pack_pbp.step.dependOn(&PBP.step);

    //Enable the build
    b.default_step.dependOn(&pack_pbp.step);
}
