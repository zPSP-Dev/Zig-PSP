const Builder = @import("std").build.Builder;
const z = @import("std").zig;
const std = @import("std");

pub fn build(b: *Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = z.CrossTarget{
        .cpu_arch = .mipsel,
        .os_tag = .freestanding,
        .cpu_model = .{ .explicit = &std.Target.mips.cpu.mips2 }
    };

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const psp_app_name = "Zig Test App";

    const exe = b.addObject("main", "src/main.zig");
    exe.addCSourceFile("src/stub.c", &[_][]const u8{"-DPSP_ZIG_APP_VER_MAJ=1", "-DPSP_ZIG_APP_VER_MIN=0", "-DPSP_ZIG_APP_NAME=" ++ psp_app_name, "-pedantic", "-Wall", "-Werror"});
    exe.setOutputDir("zig-cache/");
    
    exe.setTarget(target);
    exe.setBuildMode(mode);
    
    const link_to_elf = b.addSystemCommand(&[_][]const u8{
        "ld.lld", "-L./lib", "-L../psp/lib", //GET RID OF EXTERNAL DEPS
        "-Tlib/linkfile.ld",
        "-lpsp", //GET RID OF C AS SOON AS POSSIBLE
        exe.getOutputPath(),
        "-o",
        "zig-cache/app.elf",
        "-emit-relocs", "--eh-frame-hdr", "--no-gc-sections"
    });

    link_to_elf.step.dependOn(&exe.step);

    const generate_prx = b.addSystemCommand(&[_][]const u8{
        "prxgen",
        "zig-cache/app.elf",
        "app.prx"
    });
    generate_prx.step.dependOn(&link_to_elf.step);

    const mk_sfo = b.addSystemCommand(&[_][]const u8{
        "mksfo",
        psp_app_name,
        "zig-cache/PARAM.SFO"
    });
    mk_sfo.step.dependOn(&generate_prx.step);

    const icon0 = "NULL"; //REPLACE WITH PATH TO ICON0.PNG 144 x 80 Thumbnail
    const icon1 = "NULL"; //REPLACE WITH PATH TO ICON1.PMF 144 x 80 animation
    const pic0 = "NULL"; //REPLACE WITH PATH TO PIC0.PNG 480 x 272 Background
    const pic1 = "NULL"; //REPLACE WITH PATH TO PIC1.PMF 480 x 272 Animation
    const snd0 = "NULL"; //REPLACE WITH PATH TO SND0.AT3 Music

    const pack_pbp = b.addSystemCommand(&[_][]const u8{
        "pack-pbp",
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
    pack_pbp.step.dependOn(&mk_sfo.step);

    b.default_step.dependOn(&pack_pbp.step);

}
