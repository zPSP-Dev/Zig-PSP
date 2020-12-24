const Builder = @import("std").build.Builder;
const psp = @import("build-psp.zig");

pub fn build(b: *Builder) void {
    psp.build_psp(b, psp.PSPBuildInfo{
        .path_to_sdk = "",
        .src_file = "src/main.zig",
        .title = "Zig PSP Test",
    }) catch unreachable;
}
