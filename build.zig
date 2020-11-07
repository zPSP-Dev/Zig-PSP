const Builder = @import("std").build.Builder;
const psp = @import("build-psp.zig");

pub fn build(b: *Builder) void {
    try psp.build_psp(b, psp.PSPBuildInfo{.path_to_sdk = "", .title = "PSP App", .src_file = "src/main.zig"});
}
