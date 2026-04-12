const std = @import("std");
const builtin = std.builtin;

// -- Public API ----------------------------------------------------------------

/// Options for building a PSP EBOOT.PBP.
pub const PspEbootOptions = struct {
    name: []const u8,
    root_source_file: std.Build.LazyPath,
    title: []const u8,
    optimize: std.builtin.OptimizeMode = .Debug,
    // Optional PBP assets (pass null to omit)
    icon0: ?std.Build.LazyPath = null,
    icon1: ?std.Build.LazyPath = null,
    pic0: ?std.Build.LazyPath = null,
    pic1: ?std.Build.LazyPath = null,
    snd0: ?std.Build.LazyPath = null,
    encrypt: bool = false,
};

/// The three artifacts produced by the eboot pipeline.
pub const PspEboot = struct {
    /// MIPS ELF with debug info (useful with PPSSPP/gdb)
    elf: *std.Build.Step.Compile,
    /// PSP PRX - stripped, relocatable executable
    prx: std.Build.LazyPath,
    /// EBOOT.PBP - the file you copy to ms0:/PSP/GAME/<name>/
    eboot: std.Build.LazyPath,
};

/// Controls where buildPspEboot installs its output artifacts.
pub const PspOutputOptions = struct {
    /// Subdirectory under zig-out/bin/ for all artifacts.
    /// Defaults to the app name from PspEbootOptions.
    dir: ?[]const u8 = null,
};

/// Options for `addEbootSteps` — the ELF -> PRX -> SFO -> PBP pipeline.
pub const EbootOptions = struct {
    title: []const u8,
    icon0: ?std.Build.LazyPath = null,
    icon1: ?std.Build.LazyPath = null,
    pic0: ?std.Build.LazyPath = null,
    pic1: ?std.Build.LazyPath = null,
    snd0: ?std.Build.LazyPath = null,
    // This calls zPRXEncrypt. This doesn't cover all usecases yet so it's off by default.
    encrypt: bool = false,
    /// Subdirectory under zig-out/bin/ for installed artifacts.
    /// When null, artifacts are added to the pipeline but not installed.
    output_dir: ?[]const u8 = null,
};

/// Build a PSP EBOOT.PBP from a single Zig source file and install the
/// artifacts under zig-out/bin/<name>/ (or a custom dir via PspOutputOptions).
/// Call this from your own build.zig after adding pspsdk as a dependency.
///
/// This is a convenience wrapper around `configurePspExecutable` +
/// `addEbootSteps`. Use those directly if you need to create and configure
/// the executable yourself (e.g. in an engine or framework).
///
/// Example:
///   const pspsdk = @import("pspsdk");
///   pspsdk.buildPspEboot(b, .{
///       .name             = "my_app",
///       .root_source_file = b.path("src/main.zig"),
///       .title            = "My App",
///       .optimize         = optimize,
///   }, .{});
pub fn buildPspEboot(b: *std.Build, options: PspEbootOptions, output: PspOutputOptions) PspEboot {
    const psp_target = getPspTarget(b);

    const exe = b.addExecutable(.{
        .name = "main",
        .root_module = b.createModule(.{
            .root_source_file = options.root_source_file,
            .target = psp_target,
            .optimize = options.optimize,
            .strip = false,
        }),
    });

    configurePspExecutable(exe);

    return addEbootSteps(b, exe, .{
        .title = options.title,
        .icon0 = options.icon0,
        .icon1 = options.icon1,
        .pic0 = options.pic0,
        .pic1 = options.pic1,
        .snd0 = options.snd0,
        .encrypt = options.encrypt,
        .output_dir = output.dir orelse options.name,
    });
}

/// Applies PSP-specific settings to an existing executable:
/// linker script, entry point, relocation emission, and the pspsdk module import.
///
/// Use this when your build system (e.g. an engine) creates its own executable
/// and needs to configure it for PSP. Pair with `addEbootSteps` to run the
/// ELF -> PRX -> SFO -> PBP packaging pipeline afterwards.
///
/// Example (engine integration):
///   const pspsdk = @import("pspsdk");
///
///   const exe = b.addExecutable(.{ ... });
///   if (targeting_psp) {
///       pspsdk.configurePspExecutable(exe);
///   }
pub fn configurePspExecutable(exe: *std.Build.Step.Compile) void {
    const b = exe.step.owner;
    const self = b.dependencyFromBuildZig(@This(), .{});

    // Reuse an existing pspsdk module if one is reachable (directly or
    // transitively, e.g. via an engine dependency).  If found only
    // transitively, also add it as a direct import so the exe's own
    // source files can @import("pspsdk").
    if (exe.root_module.import_table.get("pspsdk") == null) {
        const pspsdk_mod = findTransitiveImport(exe.root_module, "pspsdk") orelse
            b.createModule(.{
                .root_source_file = self.path("src/pspsdk.zig"),
                .target = getPspTarget(b),
                .optimize = exe.root_module.optimize orelse .Debug,
            });
        exe.root_module.addImport("pspsdk", pspsdk_mod);
    }

    exe.link_eh_frame_hdr = true;
    exe.link_emit_relocs = true;
    exe.entry = .{ .symbol_name = "module_start" };
    exe.setLinkerScript(self.path("tools/linkfile.ld"));
}

/// Walk the import graph breadth-first looking for a module imported as `name`.
fn findTransitiveImport(root: *std.Build.Module, name: []const u8) ?*std.Build.Module {
    const Set = std.AutoArrayHashMapUnmanaged(*std.Build.Module, void);
    var visited: Set = .empty;
    defer visited.deinit(root.owner.allocator);
    // Seed with root's direct imports
    var queue: std.ArrayListUnmanaged(*std.Build.Module) = .empty;
    defer queue.deinit(root.owner.allocator);
    queue.appendSlice(root.owner.allocator, root.import_table.values()) catch @panic("OOM");
    while (queue.items.len > 0) {
        const mod = queue.orderedRemove(0);
        if (visited.contains(mod)) continue;
        visited.put(root.owner.allocator, mod, {}) catch @panic("OOM");
        // Check this module's imports for the target name
        for (mod.import_table.keys(), mod.import_table.values()) |k, v| {
            if (std.mem.eql(u8, k, name)) return v;
            queue.append(root.owner.allocator, v) catch @panic("OOM");
        }
    }
    // Also check root itself (direct import)
    return root.import_table.get(name);
}

/// Runs the ELF -> PRX -> SFO -> PBP pipeline on an existing PSP executable
/// and installs the artifacts under zig-out/bin/<dir>/.
///
/// The executable must already be configured for PSP (via `configurePspExecutable`
/// or equivalent manual setup). Returns handles to all three output artifacts.
///
/// Example:
///   const pspsdk = @import("pspsdk");
///
///   const exe = b.addExecutable(.{ ... });
///   pspsdk.configurePspExecutable(exe);
///   const eboot = pspsdk.addEbootSteps(b, exe, .{
///       .title = "My App",
///       .output_dir = "my_app",
///   });
pub fn addEbootSteps(b: *std.Build, exe: *std.Build.Step.Compile, options: EbootOptions) PspEboot {
    const self = b.dependencyFromBuildZig(@This(), .{});
    return ebootPipeline(
        b,
        exe,
        self.artifact("zPRXGen"),
        self.artifact("zSFOTool"),
        self.artifact("zPBPTool"),
        self.artifact("zPRXEncrypt"),
        options,
    );
}

/// Return the PSP resolved target (mipsel, os=psp, cpu=allegrex).
/// Exposed so downstream projects can query it if needed.
pub fn getPspTarget(b: *std.Build) std.Build.ResolvedTarget {
    return b.resolveTargetQuery(.{
        .cpu_arch = .mipsel,
        .os_tag = .psp,
        .cpu_model = .{ .explicit = &std.Target.mips.cpu.allegrex },
    });
}

// -- Internal helpers ----------------------------------------------------------

/// Applies PSP linker/entry settings and adds the pspsdk module import.
fn configureExe(
    exe: *std.Build.Step.Compile,
    linkfile: std.Build.LazyPath,
    pspsdk_mod: *std.Build.Module,
) void {
    exe.root_module.addImport("pspsdk", pspsdk_mod);
    exe.link_eh_frame_hdr = true;
    exe.link_emit_relocs = true;
    exe.entry = .{ .symbol_name = "module_start" };
    exe.setLinkerScript(linkfile);
}

/// Runs the PRX/SFO/PBP pipeline and optionally installs artifacts.
fn ebootPipeline(
    b: *std.Build,
    exe: *std.Build.Step.Compile,
    prxgen: *std.Build.Step.Compile,
    sfo_tool: *std.Build.Step.Compile,
    pbp_tool: *std.Build.Step.Compile,
    prx_encrypt: *std.Build.Step.Compile,
    options: EbootOptions,
) PspEboot {
    // ELF -> PRX
    const mk_prx = b.addRunArtifact(prxgen);
    mk_prx.addArtifactArg(exe);
    const prx_file = mk_prx.addOutputFileArg("app.prx");

    // ELF -> PSP
    const encrypt_step = b.addRunArtifact(prx_encrypt);
    encrypt_step.addFileArg(prx_file);
    const psp_file = encrypt_step.addOutputFileArg("app.psp");

    // -> PARAM.SFO
    const mk_sfo = b.addRunArtifact(sfo_tool);
    mk_sfo.addArg("write");
    mk_sfo.addArg(options.title);
    const sfo_file = mk_sfo.addOutputFileArg("PARAM.SFO");

    // PRX + SFO -> EBOOT.PBP
    const pack_pbp = b.addRunArtifact(pbp_tool);
    pack_pbp.addArg("pack");
    const eboot_file = pack_pbp.addOutputFileArg("EBOOT.PBP");
    pack_pbp.addFileArg(sfo_file);

    if (options.icon0) |p| pack_pbp.addFileArg(p) else pack_pbp.addArg("NULL");
    if (options.icon1) |p| pack_pbp.addFileArg(p) else pack_pbp.addArg("NULL");
    if (options.pic0) |p| pack_pbp.addFileArg(p) else pack_pbp.addArg("NULL");
    if (options.pic1) |p| pack_pbp.addFileArg(p) else pack_pbp.addArg("NULL");
    if (options.snd0) |p| pack_pbp.addFileArg(p) else pack_pbp.addArg("NULL");

    pack_pbp.addFileArg(if (options.encrypt) psp_file else prx_file);

    pack_pbp.addArg("NULL"); // DATA.PSAR not needed

    const result = PspEboot{
        .elf = exe,
        .prx = prx_file,
        .eboot = eboot_file,
    };

    // Install artifacts under zig-out/bin/<dir>/ if a directory was specified
    if (options.output_dir) |dir| {
        const alloc = b.allocator;

        b.getInstallStep().dependOn(&b.addInstallBinFile(
            result.eboot,
            std.mem.concat(alloc, u8, &.{ dir, "/EBOOT.PBP" }) catch @panic("OOM"),
        ).step);
        b.getInstallStep().dependOn(&b.addInstallBinFile(
            result.prx,
            std.mem.concat(alloc, u8, &.{ dir, "/app.prx" }) catch @panic("OOM"),
        ).step);

        if (options.encrypt) {
            b.getInstallStep().dependOn(&b.addInstallBinFile(
                psp_file,
                std.mem.concat(alloc, u8, &.{ dir, "/app.psp" }) catch @panic("OOM"),
            ).step);
        }

        b.getInstallStep().dependOn(&b.addInstallArtifact(result.elf, .{
            .dest_dir = .{ .override = .{ .custom = std.mem.concat(alloc, u8, &.{ "bin/", dir }) catch @panic("OOM") } },
            .dest_sub_path = "app.elf",
        }).step);
    }

    return result;
}

// -- Root build ----------------------------------------------------------------

pub fn build(b: *std.Build) void {
    const host_target = b.standardTargetOptions(.{});
    const host_optimize = b.standardOptimizeOption(.{});

    const psp_target = getPspTarget(b);
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
    const sfo_tool = b.addExecutable(.{
        .name = "zSFOTool",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tools/sfo/src/main.zig"),
            .target = host_target,
            .optimize = host_optimize,
        }),
    });
    const install_sfo = b.addInstallArtifact(sfo_tool, .{});
    b.getInstallStep().dependOn(&install_sfo.step);

    // Build PBP tool
    const pbp_tool = b.addExecutable(.{
        .name = "zPBPTool",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tools/pbp/src/main.zig"),
            .target = host_target,
            .optimize = host_optimize,
        }),
    });
    const install_pbp = b.addInstallArtifact(pbp_tool, .{});
    b.getInstallStep().dependOn(&install_pbp.step);

    // Build PRX encrypt
    const prx_encrypt = b.addExecutable(.{
        .name = "zPRXEncrypt",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tools/prxencrypt/main.zig"),
            .target = host_target,
            .optimize = host_optimize,
        }),
    });
    const install_prx_encrypt = b.addInstallArtifact(prx_encrypt, .{});
    b.getInstallStep().dependOn(&install_prx_encrypt.step);

    // Build main pspsdk module (used by examples + docs)
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

    // Test step
    const prxencrypt_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("tools/prxencrypt/test.zig"),
            .target = host_target,
            .optimize = host_optimize,
        }),
    });
    const run_prxencrypt_tests = b.addRunArtifact(prxencrypt_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_prxencrypt_tests.step);

    // Build tools step
    const tools_step = b.step("tools", "Build PSP SDK tools");
    tools_step.dependOn(&install_prxgen.step);
    tools_step.dependOn(&install_sfo.step);
    tools_step.dependOn(&install_pbp.step);
    tools_step.dependOn(&install_prx_encrypt.step);

    // Build examples
    const example_step = b.step("examples", "Build examples");
    const linkfile = b.path("tools/linkfile.ld");

    inline for (example_list) |example| {
        const exe = b.addExecutable(.{
            .name = "main",
            .root_module = b.createModule(.{
                .root_source_file = b.path(example.src_file),
                .target = psp_target,
                .optimize = psp_optimize,
                .strip = false,
            }),
        });
        configureExe(exe, linkfile, pspsdk_module);

        const result = ebootPipeline(b, exe, prxgen, sfo_tool, pbp_tool, prx_encrypt, .{
            .title = example.title,
            .icon0 = if (example.icon0) |p| b.path(p) else null,
            .icon1 = if (example.icon1) |p| b.path(p) else null,
            .pic0 = if (example.pic0) |p| b.path(p) else null,
            .pic1 = if (example.pic1) |p| b.path(p) else null,
            .snd0 = if (example.snd0) |p| b.path(p) else null,
            .output_dir = example.name,
        });
        example_step.dependOn(&result.elf.step);
    }

    // Always build examples by default
    b.getInstallStep().dependOn(example_step);
}

// -- Example list --------------------------------------------------------------

const ExampleInfo = struct {
    name: []const u8,
    src_file: []const u8,
    title: []const u8,
    icon0: ?[]const u8 = null,
    icon1: ?[]const u8 = null,
    pic0: ?[]const u8 = null,
    pic1: ?[]const u8 = null,
    snd0: ?[]const u8 = null,
};

const example_list = [_]ExampleInfo{
    .{ .name = "hello_world", .src_file = "examples/hello_world.zig", .title = "SDK HelloWorld" },
    .{ .name = "allocator", .src_file = "examples/allocator.zig", .title = "SDK Allocator" },
    .{ .name = "arena", .src_file = "examples/arena.zig", .title = "SDK Arena" },
    .{ .name = "ziggy_cube", .src_file = "examples/ziggy_cube.zig", .title = "SDK Ziggy Cube" },
    .{ .name = "clear_screen", .src_file = "examples/clearScreen.zig", .title = "SDK Clear Screen" },
    .{ .name = "error", .src_file = "examples/error.zig", .title = "SDK Error" },
    .{ .name = "panic", .src_file = "examples/panic.zig", .title = "SDK Panic" },
    .{ .name = "print", .src_file = "examples/print.zig", .title = "SDK Print" },
    .{ .name = "io", .src_file = "examples/io.zig", .title = "SDK IO" },
    .{ .name = "time_random", .src_file = "examples/time_random.zig", .title = "SDK Time Random" },
    .{ .name = "cwd", .src_file = "examples/cwd.zig", .title = "SDK CWD" },
    .{ .name = "dir_file", .src_file = "examples/dir_file.zig", .title = "SDK Dir File" },
    .{ .name = "network", .src_file = "examples/network.zig", .title = "SDK Network" },
    .{ .name = "http", .src_file = "examples/http.zig", .title = "SDK HTTP" },
    .{ .name = "https", .src_file = "examples/https.zig", .title = "SDK HTTPS" },
    .{ .name = "async_demo", .src_file = "examples/async.zig", .title = "SDK Async" },
};
