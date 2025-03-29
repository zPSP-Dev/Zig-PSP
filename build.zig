const std = @import("std");
const psp = @import("build-psp.zig");

pub fn build(b: *std.Build) void {
    psp.build_psp(b, psp.PSPBuildInfo{
        .path_to_sdk = "",
        .src_file = "src/main.zig",
        .title = "Zig PSP Test",
    }, psp.Options{
        .everything = true,
    }) catch unreachable;
}
