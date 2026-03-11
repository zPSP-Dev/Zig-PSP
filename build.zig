const std = @import("std");
const builtin = std.builtin;

pub fn build(b: *std.Build) void {
    const host_target = b.standardTargetOptions(.{});
    const host_optimize = b.standardOptimizeOption(.{});

    const psp_target = get_psp_target(b);
    const psp_optimize = host_optimize;

    // Build prxgen tool
    const prxgen = b.addExecutable(.{
        .name = "zPRXGen",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tools/prx/main.zig"),
            .target = host_target,
            .optimize = host_optimize,
        }),
    });
    const install_prxgen = b.addInstallArtifact(prxgen, .{});
    b.getInstallStep().dependOn(&install_prxgen.step);

    // Build SFO tool
    const sfo_dependency = b.dependency("zSFOTool", .{
        .target = host_target,
        .optimize = host_optimize,
    });
    const sfo_tool = sfo_dependency.artifact("zSFOTool");
    const install_sfo = b.addInstallArtifact(sfo_tool, .{});
    b.getInstallStep().dependOn(&install_sfo.step);

    // Build PBP tool
    const pbp_dependency = b.dependency("zPBPTool", .{
        .target = host_target,
        .optimize = host_optimize,
    });
    const pbp_tool = pbp_dependency.artifact("zPBPTool");
    const install_pbp = b.addInstallArtifact(pbp_tool, .{});
    b.getInstallStep().dependOn(&install_pbp.step);

    // Buid main pspsdk module
    const pspsdk_module = b.addModule("pspsdk", .{
        .root_source_file = b.path("src/pspsdk.zig"),
        .target = psp_target,
        .optimize = psp_optimize,
    });

    // Docs step
    const docs_obj = b.addObject(.{
        .name = "pspsdk",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/pspsdk.zig"),
            .target = psp_target,
            .optimize = .Debug,
        }),
    });
    const install_docs = b.addInstallDirectory(.{
        .source_dir = docs_obj.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "docs",
    });
    const docs_step = b.step("docs", "Generate documentation");
    docs_step.dependOn(&install_docs.step);

    // Build tools step
    const tools_step = b.step("tools", "Build PSP SDK tools");
    tools_step.dependOn(&install_prxgen.step);
    tools_step.dependOn(&install_sfo.step);
    tools_step.dependOn(&install_pbp.step);

    // Build examples
    const example_step = b.step("examples", "Build examples");

    inline for (.{
        PSPBuildInfo{ .name = "hello_world", .src_file = "examples/hello_world.zig", .title = "SDK HelloWorld" },
        PSPBuildInfo{ .name = "allocator", .src_file = "examples/allocator.zig", .title = "SDK Allocator" },
        PSPBuildInfo{ .name = "arena", .src_file = "examples/arena.zig", .title = "SDK Arena" },
        PSPBuildInfo{ .name = "ziggy_cube", .src_file = "examples/ziggy_cube.zig", .title = "SDK Ziggy Cube" },
        PSPBuildInfo{ .name = "clear_screen", .src_file = "examples/clearScreen.zig", .title = "SDK Clear Screen" },
        PSPBuildInfo{ .name = "error", .src_file = "examples/error.zig", .title = "SDK Error" },
        PSPBuildInfo{ .name = "panic", .src_file = "examples/panic.zig", .title = "SDK Panic" },
        PSPBuildInfo{ .name = "print", .src_file = "examples/print.zig", .title = "SDK Print" },
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

        const install_elf = b.addInstallArtifact(example_exe, .{
            .dest_dir = .{ .override = .{ .custom = "bin/" ++ example.name } },
            .dest_sub_path = "app.elf",
        });
        example_step.dependOn(&install_elf.step);
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
