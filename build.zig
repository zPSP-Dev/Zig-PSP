const Builder = @import("std").build.Builder;
const z = @import("std").zig;
const std = @import("std");
const builtin = @import("builtin");

 //This effects the name of the module (seen in PSPLink) & XMB screen menu
const psp_app_name = "Zig Test App";

//Optional customizations
const icon0 = "NULL"; //REPLACE WITH PATH TO ICON0.PNG 144 x 80 Thumbnail
const icon1 = "NULL"; //REPLACE WITH PATH TO ICON1.PMF 144 x 80 animation
const pic0 = "NULL"; //REPLACE WITH PATH TO PIC0.PNG 480 x 272 Background
const pic1 = "NULL"; //REPLACE WITH PATH TO PIC1.PMF 480 x 272 Animation
const snd0 = "NULL"; //REPLACE WITH PATH TO SND0.AT3 Music

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
    //Debug Mode can cause issues with trap instructions
    const mode = builtin.Mode.ReleaseSafe;

    //Build from your main file!
    const exe = b.addObject("main", "src/main.zig");

    //Output to zig cache for now
    exe.setOutputDir("zig-cache/");

    //Set mode & target
    std.debug.warn("Building PSP ELF...\n", .{});
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.setLinkerScriptPath("tools/linkfile.ld");
    exe.link_eh_frame_hdr = true;
    
    //New step to link the object
    //Hopefully can be removed (https://github.com/ziglang/zig/issues/5986)
    std.debug.warn("Linking...\n", .{});
    const link_to_elf = b.addSystemCommand(&[_][]const u8{
        "ld.lld", "-L./tools",
        "-Ttools/linkfile.ld",
        exe.getOutputPath(),
        "-o",
        "zig-cache/app.elf",
        "-emit-relocs", "--eh-frame-hdr", "--no-gc-sections"
    });
    link_to_elf.step.dependOn(&exe.step);

    //Post-build actions
    
    const hostTarget = b.standardTargetOptions(.{});

    const prx = b.addExecutable("prxgen", "tools/prxgen/stub.zig");
    prx.setTarget(hostTarget);
    prx.addCSourceFile("tools/prxgen/psp-prxgen.c", &[_][]const u8{"-std=c99", "-Wno-address-of-packed-member"});
    prx.linkLibC();
    prx.setBuildMode(builtin.Mode.ReleaseFast);
    prx.setOutputDir("tools/bin");
    prx.install();
    prx.step.dependOn(&link_to_elf.step);

    std.debug.warn("Generating PRX...\n", .{});
    const generate_prx = b.addSystemCommand(&[_][]const u8{
        "tools/bin/prxgen",
        "zig-cache/app.elf",
        "app.prx"
    });
    generate_prx.step.dependOn(&prx.step);

    //Build SFO
    const sfo = b.addExecutable("sfotool", "tools/sfo/src/main.zig");
    sfo.setTarget(hostTarget);
    sfo.setBuildMode(builtin.Mode.ReleaseFast);
    sfo.setOutputDir("tools/bin");
    sfo.install();
    sfo.step.dependOn(&generate_prx.step);

    //Make the SFO file
    const mk_sfo = b.addSystemCommand(&[_][]const u8{
        "tools/bin/sfotool", "write",
        psp_app_name,
        "zig-cache/PARAM.SFO"
    });
    mk_sfo.step.dependOn(&sfo.step);


    //Build PBP
    const PBP = b.addExecutable("pbptool", "tools/pbp/src/main.zig");
    PBP.setTarget(hostTarget);
    PBP.setBuildMode(builtin.Mode.ReleaseFast);
    PBP.setOutputDir("tools/bin");
    PBP.install();
    PBP.step.dependOn(&mk_sfo.step);

    //Pack the PBP executable
    const pack_pbp = b.addSystemCommand(&[_][]const u8{
        "tools/bin/pbptool", "pack",
        "EBOOT.PBP",
        "zig-cache/PARAM.SFO",
        icon0,
        icon1,
        pic0,
        pic1,
        snd0,
        "app.prx",
        "NULL" //DATA.PSAR not necessary.
    });
    pack_pbp.step.dependOn(&PBP.step);

    //Enable the build
    b.default_step.dependOn(&pack_pbp.step);
}
