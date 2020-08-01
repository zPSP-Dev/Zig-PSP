const psp = @import("psp/pspsdk.zig");

pub export fn main(arg_argc: c_int, arg_argv: [*c][*c]u8) c_int {
    psp.sceKernelExitGame();
    return 0;
}
