const psp = @import("psp/pspsdk.zig");


pub export fn main() void {
    psp.debug.screenInit();
    psp.debug.screenSetFrontColor(0xFF00FF00);

    var i : u32 = 0;
    const rows : u32 = 60;
    const columns : u32 = 34;

    while(true) : (i += 1) {
        psp.debug.print("Hello from Zig!");
        var s = psp.sceDisplayWaitVblankStart();
    }

    psp.sceKernelExitGame();
}
