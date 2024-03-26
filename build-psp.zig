const z = @import("std").zig;
const std = @import("std");
const builtin = std.builtin;

pub const PSPBuildInfo = struct {
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

const append: []const u8 = switch (builtin.os.tag) {
    .windows => ".exe",
    else => "",
};

pub fn build_psp(b: *std.Build, comptime build_info: PSPBuildInfo) !void {
    var feature_set: std.Target.Cpu.Feature.Set = std.Target.Cpu.Feature.Set.empty;
    feature_set.addFeature(@intFromEnum(std.Target.mips.Feature.single_float));

    //PSP-Specific Build Options
    // const target = z.CrossTarget{};
    // const target = b.standardTargetOptions(.{ .whitelist = &.{.{
    // }} });
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .mipsel,
        .os_tag = .freestanding,
        .cpu_model = .{ .explicit = &std.Target.mips.cpu.mips2 },
        .cpu_features_add = feature_set,
    });

    //All of the release modes work
    //Debug Mode can cause issues with trap instructions - use ReleaseSafe for "Debug" builds
    const optimize = builtin.Mode.ReleaseSmall;

    //Build from your main file!
    const exe = b.addExecutable(.{
        .name = "main",
        .root_source_file = .{ .path = build_info.src_file },
        .target = target,
        .optimize = optimize,
    });

    exe.setLinkerScriptPath(.{ .path = build_info.path_to_sdk ++ "tools/linkfile.ld" });

    exe.link_eh_frame_hdr = true;
    exe.link_emit_relocs = true;
    // exe.strip = true;
    // exe.single_threaded = true;
    // exe.install();
    // b.installArtifact(exe);

    // exe.setOutputDir("zig-cache/");

    //Post-build actions
    const hostTarget = b.standardTargetOptions(.{});
    const prx = b.addExecutable(.{
        .name = "prxgen",
        .root_source_file = .{ .path = build_info.path_to_sdk ++ "tools/prxgen/stub.zig" },
        .link_libc = true,
        .target = hostTarget,
        .optimize = .ReleaseFast,
    });
    prx.addCSourceFile(.{
        .file = .{ .path = build_info.path_to_sdk ++ "tools/prxgen/psp-prxgen.c" },
        .flags = &[_][]const u8{
            "-std=c99",
            "-Wno-address-of-packed-member",
            "-D_CRT_SECURE_NO_WARNINGS",
        },
    });
    b.installArtifact(prx);
    // prx.setOutputDir(build_info.path_to_sdk ++ "tools/bin");
    // prx.install();
    // prx.step.dependOn(&exe.step);

    // const generate_prx = b.addSystemCommand(&[_][]const u8{ build_info.path_to_sdk ++ "tools/bin/prxgen" ++ append, "zig-cache/main", "app.prx" });
    // generate_prx.step.dependOn(&prx.step);

    const generate_prx_step = b.addRunArtifact(prx);
    generate_prx_step.addArtifactArg(exe);
    const prx_file = generate_prx_step.addOutputFileArg("app.prx");

    //Build SFO
    const sfo = b.addExecutable(.{
        .name = "sfotool",
        .root_source_file = .{ .path = build_info.path_to_sdk ++ "tools/sfo/src/main.zig" },
        .target = hostTarget,
        .optimize = optimize,
    });
    // sfo.setOutputDir(build_info.path_to_sdk ++ "tools/bin");
    b.installArtifact(sfo);

    //Make the SFO file
    // const mk_sfo = b.addSystemCommand(&[_][]const u8{ build_info.path_to_sdk ++ "tools/bin/sfotool" ++ append, "write", build_info.title, "PARAM.SFO" });
    const mk_sfo = b.addRunArtifact(sfo);
    mk_sfo.addArg("write");
    mk_sfo.addArg(build_info.title);
    const sfo_file = mk_sfo.addOutputFileArg("PARAM.SFO");
    // mk_sfo.step.dependOn(&sfo.step);

    //Build PBP
    const PBP = b.addExecutable(.{
        .name = "pbptool",
        .root_source_file = .{ .path = build_info.path_to_sdk ++ "tools/pbp/src/main.zig" },
        .target = hostTarget,
        .optimize = .ReleaseFast,
    });
    // PBP.setOutputDir(build_info.path_to_sdk ++ "tools/bin");

    //Pack the PBP executable
    const pack_pbp = b.addRunArtifact(PBP);
    pack_pbp.addArg("pack");
    const eboot_file = pack_pbp.addOutputFileArg("EBOOT.PBP");
    pack_pbp.addFileArg(sfo_file);
    pack_pbp.addFileArg(.{ .path = build_info.icon0 });
    pack_pbp.addFileArg(.{ .path = build_info.icon1 });
    pack_pbp.addFileArg(.{ .path = build_info.pic0 });
    pack_pbp.addFileArg(.{ .path = build_info.pic1 });
    pack_pbp.addFileArg(.{ .path = build_info.snd0 });
    pack_pbp.addFileArg(prx_file);
    pack_pbp.addArg("NULL");

    const install_file = b.addInstallBinFile(eboot_file, "EBOOT.PBP");
    b.getInstallStep().dependOn(&install_file.step);

    //Enable the build
    // const install = b.getInstallStep();
    // install.dependOn(&pack_pbp.step);
    //b.default_step.dependOn(&pack_pbp.step);
}
