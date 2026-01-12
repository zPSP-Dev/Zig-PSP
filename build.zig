const std = @import("std");
const builtin = std.builtin;

pub fn build(b: *std.Build) void {
    const host_target = b.standardTargetOptions(.{});
    const host_optimize = b.standardOptimizeOption(.{});

    const psp_target = get_psp_target(b);
    const psp_optimize = host_optimize;

    // Build prxgen tool
    const prxgen = b.addExecutable(.{
        .name = "prxgen",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tools/prxgen/stub.zig"),
            .link_libc = true,
            .target = host_target,
            .optimize = host_optimize,
        }),
    });
    prxgen.addCSourceFile(.{
        .file = b.path("tools/prxgen/psp-prxgen.c"),
        .flags = &[_][]const u8{
            "-std=c99",
            "-Wno-address-of-packed-member",
            "-D_CRT_SECURE_NO_WARNINGS",
        },
    });
    b.installArtifact(prxgen);

    // Build SFO tool
    const sfo_dependency = b.dependency("zSFOTool", .{
        .target = host_target,
        .optimize = host_optimize,
    });
    const sfo_tool = sfo_dependency.artifact("zSFOTool");
    b.installArtifact(sfo_tool);

    // Build PBP tool
    const pbp_dependency = b.dependency("zPBPTool", .{
        .target = host_target,
        .optimize = host_optimize,
    });
    const pbp_tool = pbp_dependency.artifact("zPBPTool");
    b.installArtifact(pbp_tool);

    // Buid main pspsdk module
    const pspsdk_module = b.addModule("pspsdk", .{
        .root_source_file = b.path("src/pspsdk.zig"),
        .target = psp_target,
        .optimize = psp_optimize,
    });

    // Build examples
    const example_step = b.step("examples", "Build examples");

    inline for (.{
        PSPBuildInfo{ .name = "hello_world", .src_file = "examples/hello_world.zig", .title = "SDK HelloWorld" },
        PSPBuildInfo{ .name = "allocator", .src_file = "examples/allocator.zig", .title = "SDK Allocator" },
        PSPBuildInfo{ .name = "ziggy_cube", .src_file = "examples/ziggy_cube.zig", .title = "SDK Ziggy Cube" },
        PSPBuildInfo{ .name = "clear_screen", .src_file = "examples/clearScreen.zig", .title = "SDK Clear Screen" },
    }) |example| {
        const example_exe = b.addExecutable(.{
            .name = "main",
            .root_module = b.createModule(.{
                .root_source_file = b.path(example.src_file),
                .target = psp_target,
                .optimize = psp_optimize,
                .strip = false, // disable as cannot be used with "link_emit_relocs = true"
            }),
        });

        example_exe.root_module.addImport("pspsdk", pspsdk_module);

        example_exe.link_eh_frame_hdr = true;
        example_exe.link_emit_relocs = true;
        example_exe.entry = .{ .symbol_name = "module_start" };

        example_exe.setLinkerScript(b.path("tools/linkfile.ld"));

        // Call prxgen
        const mk_prx = b.addRunArtifact(prxgen);
        mk_prx.addArtifactArg(example_exe);
        const prx_file = mk_prx.addOutputFileArg("app.prx");

        // Call zSFOTool
        const mk_sfo = b.addRunArtifact(sfo_tool);
        mk_sfo.addArg("write");
        mk_sfo.addArg(example.title);
        const sfo_file = mk_sfo.addOutputFileArg("PARAM.SFO");

        // Call zPBPTool
        const pack_pbp = b.addRunArtifact(pbp_tool);
        pack_pbp.addArg("pack");
        const eboot_file = pack_pbp.addOutputFileArg("EBOOT.PBP");
        pack_pbp.addFileArg(sfo_file);

        if (example.icon0) |icon0| pack_pbp.addFileArg(b.path(icon0)) else pack_pbp.addArg("NULL");
        if (example.icon1) |icon1| pack_pbp.addFileArg(b.path(icon1)) else pack_pbp.addArg("NULL");
        if (example.pic0) |pic0| pack_pbp.addFileArg(b.path(pic0)) else pack_pbp.addArg("NULL");
        if (example.pic1) |pic1| pack_pbp.addFileArg(b.path(pic1)) else pack_pbp.addArg("NULL");
        if (example.snd0) |snd0| pack_pbp.addFileArg(b.path(snd0)) else pack_pbp.addArg("NULL");
        pack_pbp.addFileArg(prx_file);
        pack_pbp.addArg("NULL"); //DATA.PSAR not necessary.

        const install_file = b.addInstallBinFile(eboot_file, example.name ++ "/EBOOT.PBP");
        example_step.dependOn(&install_file.step);

        const install_prx = b.addInstallBinFile(prx_file, example.name ++ "/app.prx");
        example_step.dependOn(&install_prx.step);
    }

    // Always build examples by default
    b.getInstallStep().dependOn(example_step);
}

fn get_psp_target(b: *std.Build) std.Build.ResolvedTarget {
    var feature_set: std.Target.Cpu.Feature.Set = std.Target.Cpu.Feature.Set.empty;
    feature_set.addFeature(@intFromEnum(std.Target.mips.Feature.single_float));

    const psp_target = b.resolveTargetQuery(.{
        .cpu_arch = .mipsel,
        .os_tag = .freestanding,
        .cpu_model = .{ .explicit = &std.Target.mips.cpu.mips2 },
        .cpu_features_add = feature_set,
    });

    return psp_target;
}

const PSPBuildInfo = struct {
    name: []const u8,
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
