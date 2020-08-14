const Builder = @import("std").build.Builder;
const builtin = @import("builtin");

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = builtin.Mode.ReleaseFast;

    const exe = b.addExecutable("pbptool", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.setOutputDir("../bin/");
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
