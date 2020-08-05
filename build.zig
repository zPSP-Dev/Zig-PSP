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
    
    //PSP-Specific Build Options
    const target = z.CrossTarget{
        .cpu_arch = .mipsel,
        .os_tag = .freestanding,
        .cpu_model = .{ .explicit = &std.Target.mips.cpu.mips2 }
    };

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    //Build from your main file!
    const exe = b.addObject("main", "src/main.zig");

    //TODO: Remove Stub.c
    exe.addCSourceFile("src/psp/stub.c", &[_][]const u8{"-DPSP_ZIG_APP_VER_MAJ=1", "-DPSP_ZIG_APP_VER_MIN=0", "-DPSP_ZIG_APP_NAME=" ++ psp_app_name, "-pedantic", "-Wall", "-Werror"});

    //Output to zig cache for now
    exe.setOutputDir("zig-cache/");
    
    //Set mode & target
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.setLinkerScriptPath("lib/linkfile.ld");
    exe.link_eh_frame_hdr = true;
    
    //New step to link the object
    //Hopefully can be removed (https://github.com/ziglang/zig/issues/5986)
    const link_to_elf = b.addSystemCommand(&[_][]const u8{
        "ld.lld", "-L./lib",
        "-Tlib/linkfile.ld",
        "-lpsp",
        exe.getOutputPath(),
        "-o",
        "zig-cache/app.elf",
        "-emit-relocs", "--eh-frame-hdr", "--no-gc-sections"
    });
    link_to_elf.step.dependOn(&exe.step);

    //Post-build actions
    
    var prxgen_path = "lib/tools/linux/prxgen";
    var mksfo_path = "lib/tools/linux/mksfo";
    var pack_pbp_path = "lib/tools/linux/pack-pbp";

    switch (builtin.os.tag) {
        .linux => {
            prxgen_path = "lib/tools/linux/prxgen";
            mksfo_path = "lib/tools/linux/mksfo";
            pack_pbp_path = "lib/tools/linux/pack-pbp";
        },

        .macosx => {
            prxgen_path = "lib/tools/mac/prxgen";
            mksfo_path = "lib/tools/mac/mksfo";
            pack_pbp_path = "lib/tools/mac/pack-pbp";
        },

        .windows => {
            prxgen_path = "lib/tools/win/prxgen";
            mksfo_path = "lib/tools/win/mksfo";
            pack_pbp_path = "lib/tools/win/pack-pbp";
        },

        else => {
            @compileError("No PSP tools for this system!");
        }
    }

    //Generate a PRX
    const generate_prx = b.addSystemCommand(&[_][]const u8{
        prxgen_path,
        "zig-cache/app.elf",
        "app.prx"
    });
    generate_prx.step.dependOn(&link_to_elf.step);

    //Make the SFO file
    const mk_sfo = b.addSystemCommand(&[_][]const u8{
        mksfo_path,
        psp_app_name,
        "zig-cache/PARAM.SFO"
    });
    mk_sfo.step.dependOn(&generate_prx.step);

    //Pack the PBP executable
    const pack_pbp = b.addSystemCommand(&[_][]const u8{
        pack_pbp_path,
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

    //Enable the build
    b.default_step.dependOn(&pack_pbp.step);
}
