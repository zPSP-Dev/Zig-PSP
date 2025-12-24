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

pub const Options = struct {
    everything: bool = false,
    scePower: bool = false,
    sceNetInet: bool = false,
    sceNetApctl: bool = false,
    sceHttp: bool = false,
    sceNet: bool = false,
    sceNetResolver: bool = false,
    sceNet_lib: bool = false,
    sceNetAdhocctl: bool = false,
    sceNetAdhocMatching: bool = false,
    sceNetAdhoc: bool = false,
    sceSsl: bool = false,
    sceJpeg: bool = false,
    sceMpegbase: bool = false,
    sceMpeg: bool = false,
    sceHprm: bool = false,
    sceUmdUser: bool = false,
    sceCtrl: bool = false,
    LoadExecForUser: bool = false,
    Kernel_Library: bool = false,
    sceImpose: bool = false,
    SysMemUserForUser: bool = false,
    sceSuspendForUser: bool = false,
    ModuleMgrForUser: bool = false,
    IoFileMgrForUser: bool = false,
    UtilsForUser: bool = false,
    InterruptManager: bool = false,
    ThreadManForUser: bool = false,
    StdioForUser: bool = false,
    sceUsbCam: bool = false,
    sceUsb: bool = false,
    sceDmac: bool = false,
    sceAudio: bool = false,
    sceAudiocodec: bool = false,
    sceGe_user: bool = false,
    sceMp3: bool = false,
    sceRtc: bool = false,
    sceVaudio: bool = false,
    sceReg: bool = false,
    sceWlanDrv_lib: bool = false,
    sceWlanDrv: bool = false,
    sceOpenPSID: bool = false,
    sceDisplay: bool = false,
    sceAtrac3plus: bool = false,
    sceUsbstor: bool = false,
    sceUtility: bool = false,
    sceUtility_netparam_internal: bool = false,
};

pub fn addOptions(b: *std.Build, options: Options) *std.Build.Step.Options {
    const step_options = b.addOptions();

    step_options.addOption(bool, "everything", options.everything);

    step_options.addOption(bool, "scePower", options.scePower);
    step_options.addOption(bool, "sceNetInet", options.sceNetInet);
    step_options.addOption(bool, "sceNetApctl", options.sceNetApctl);
    step_options.addOption(bool, "sceHttp", options.sceHttp);
    step_options.addOption(bool, "sceNet", options.sceNet);
    step_options.addOption(bool, "sceNetResolver", options.sceNetResolver);
    step_options.addOption(bool, "sceNet_lib", options.sceNet_lib);
    step_options.addOption(bool, "sceNetAdhocctl", options.sceNetAdhocctl);
    step_options.addOption(bool, "sceNetAdhocMatching", options.sceNetAdhocMatching);
    step_options.addOption(bool, "sceNetAdhoc", options.sceNetAdhoc);
    step_options.addOption(bool, "sceSsl", options.sceSsl);
    step_options.addOption(bool, "sceJpeg", options.sceJpeg);
    step_options.addOption(bool, "sceMpegbase", options.sceMpegbase);
    step_options.addOption(bool, "sceMpeg", options.sceMpeg);
    step_options.addOption(bool, "sceHprm", options.sceHprm);
    step_options.addOption(bool, "sceUmdUser", options.sceUmdUser);
    step_options.addOption(bool, "sceCtrl", options.sceCtrl);
    step_options.addOption(bool, "LoadExecForUser", options.LoadExecForUser);
    step_options.addOption(bool, "Kernel_Library", options.Kernel_Library);
    step_options.addOption(bool, "sceImpose", options.sceImpose);
    step_options.addOption(bool, "SysMemUserForUser", options.SysMemUserForUser);
    step_options.addOption(bool, "sceSuspendForUser", options.sceSuspendForUser);
    step_options.addOption(bool, "ModuleMgrForUser", options.ModuleMgrForUser);
    step_options.addOption(bool, "IoFileMgrForUser", options.IoFileMgrForUser);
    step_options.addOption(bool, "UtilsForUser", options.UtilsForUser);
    step_options.addOption(bool, "InterruptManager", options.InterruptManager);
    step_options.addOption(bool, "ThreadManForUser", options.ThreadManForUser);
    step_options.addOption(bool, "StdioForUser", options.StdioForUser);
    step_options.addOption(bool, "sceUsbCam", options.sceUsbCam);
    step_options.addOption(bool, "sceUsb", options.sceUsb);
    step_options.addOption(bool, "sceDmac", options.sceDmac);
    step_options.addOption(bool, "sceAudio", options.sceAudio);
    step_options.addOption(bool, "sceAudiocodec", options.sceAudiocodec);
    step_options.addOption(bool, "sceGe_user", options.sceGe_user);
    step_options.addOption(bool, "sceMp3", options.sceMp3);
    step_options.addOption(bool, "sceRtc", options.sceRtc);
    step_options.addOption(bool, "sceVaudio", options.sceVaudio);
    step_options.addOption(bool, "sceReg", options.sceReg);
    step_options.addOption(bool, "sceWlanDrv_lib", options.sceWlanDrv_lib);
    step_options.addOption(bool, "sceWlanDrv", options.sceWlanDrv);
    step_options.addOption(bool, "sceOpenPSID", options.sceOpenPSID);
    step_options.addOption(bool, "sceDisplay", options.sceDisplay);
    step_options.addOption(bool, "sceAtrac3plus", options.sceAtrac3plus);
    step_options.addOption(bool, "sceUsbstor", options.sceUsbstor);
    step_options.addOption(bool, "sceUtility", options.sceUtility);
    step_options.addOption(bool, "sceUtility_netparam_internal", options.sceUtility_netparam_internal);

    return step_options;
}

pub fn build_psp(b: *std.Build, comptime build_info: PSPBuildInfo, comptime build_options: Options) !void {
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

    const options_step = addOptions(b, build_options);
    const options_module = options_step.createModule();

    const libzpsp_module = libzpsp.artifact("libzpsp").root_module;
    libzpsp_module.addImport("libzpsp_option", options_module);

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
    exe.root_module.addImport("psp", libzpsp_module);

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
