const std = @import("std");
const psp = @import("build-psp.zig");

pub fn build(b: *std.Build) void {
    const sdk = psp.build_sdk(b, "", psp.Options{
        .everything = true,
    });

    const eboot = psp.build_psp(b, psp.PSPBuildInfo{
        .path_to_sdk = "",
        .src_file = "src/main.zig",
        .title = "Zig PSP Test",
    }, sdk);
    eboot.addImport("psp", sdk);
}
