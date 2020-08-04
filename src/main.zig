const psp = @import("psp/pspsdk.zig");


pub export fn main() void {
    psp.utils.enableHomeButton();

    psp.debug.screenInit();
    psp.debug.print("Hello from Zig!\n");
}
