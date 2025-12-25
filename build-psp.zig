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
    icon0: ?[]const u8 = null,
    icon1: ?[]const u8 = null,
    pic0: ?[]const u8 = null,
    pic1: ?[]const u8 = null,
    snd0: ?[]const u8 = null,
};

const append: []const u8 = switch (builtin.os.tag) {
    .windows => ".exe",
    else => "",
};

pub fn build_psp(b: *std.Build, comptime build_info: PSPBuildInfo) !void {
    var feature_set: std.Target.Cpu.Feature.Set = std.Target.Cpu.Feature.Set.empty;
    feature_set.addFeature(@intFromEnum(std.Target.mips.Feature.single_float));

    //PSP-Specific Build Options
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .mipsel,
        .os_tag = .freestanding,
        .cpu_model = .{ .explicit = &std.Target.mips.cpu.mips2 },
        .cpu_features_add = feature_set,
    });

    //All of the release modes work
    //Debug Mode can cause issues with trap instructions - use ReleaseSafe for "Debug" builds
    const optimize = builtin.Mode.ReleaseSmall;

    const libzpsp = b.dependency("libzpsp", .{
        .target = target,
        .optimize = optimize,
    });

    //Build from your main file!
    const exe = b.addExecutable(.{
        .name = "main",
        .root_module = b.createModule(.{
            .root_source_file = b.path(build_info.src_file),
            .target = target,
            .optimize = optimize,
            .strip = false, // disable as cannot be used with "link_emit_relocs = true"
        }),
    });
    exe.root_module.addImport("psp", libzpsp.artifact("libzpsp").root_module);

    exe.setLinkerScript(b.path(build_info.path_to_sdk ++ "tools/linkfile.ld"));

    exe.link_eh_frame_hdr = true;
    exe.link_emit_relocs = true;

    //Post-build actions
    const hostTarget = b.standardTargetOptions(.{});
    const hostOptimize = b.standardOptimizeOption(.{});
    const prx = b.addExecutable(.{
        .name = "prxgen",
        .root_module = b.createModule(.{
            .root_source_file = b.path(build_info.path_to_sdk ++ "tools/prxgen/stub.zig"),
            .link_libc = true,
            .target = hostTarget,
            .optimize = .ReleaseFast,
        }),
    });
    prx.addCSourceFile(.{
        .file = b.path(build_info.path_to_sdk ++ "tools/prxgen/psp-prxgen.c"),
        .flags = &[_][]const u8{
            "-std=c99",
            "-Wno-address-of-packed-member",
            "-D_CRT_SECURE_NO_WARNINGS",
        },
    });
    b.installArtifact(prx);

    const generate_prx_step = b.addRunArtifact(prx);
    generate_prx_step.addArtifactArg(exe);
    const prx_file = generate_prx_step.addOutputFileArg("app.prx");

    const sfo = b.dependency("zSFOTool", .{
        .target = hostTarget,
        .optimize = hostOptimize,
    });

    const mk_sfo = b.addRunArtifact(sfo.artifact("zSFOTool"));
    mk_sfo.addArg("write");
    mk_sfo.addArg(build_info.title);
    const sfo_file = mk_sfo.addOutputFileArg("PARAM.SFO");

    //Build PBP
    const pbp = b.dependency("zPBPTool", .{
        .target = hostTarget,
        .optimize = hostOptimize,
    });

    const pack_pbp = b.addRunArtifact(pbp.artifact("zPBPTool"));
    pack_pbp.addArg("pack");
    const eboot_file = pack_pbp.addOutputFileArg("EBOOT.PBP");
    pack_pbp.addFileArg(sfo_file);
    if (build_info.icon0) |icon0| pack_pbp.addFileArg(b.path(icon0)) else pack_pbp.addArg("NULL");
    if (build_info.icon1) |icon1| pack_pbp.addFileArg(b.path(icon1)) else pack_pbp.addArg("NULL");
    if (build_info.pic0) |pic0| pack_pbp.addFileArg(b.path(pic0)) else pack_pbp.addArg("NULL");
    if (build_info.pic1) |pic1| pack_pbp.addFileArg(b.path(pic1)) else pack_pbp.addArg("NULL");
    if (build_info.snd0) |snd0| pack_pbp.addFileArg(b.path(snd0)) else pack_pbp.addArg("NULL");
    pack_pbp.addFileArg(prx_file);
    pack_pbp.addArg("NULL"); //DATA.PSAR not necessary.

    const install_file = b.addInstallBinFile(eboot_file, "EBOOT.PBP");
    b.getInstallStep().dependOn(&install_file.step);

    const install_prx = b.addInstallBinFile(prx_file, "app.prx");
    b.getInstallStep().dependOn(&install_prx.step);
}
