const psp = @import("psp/pspsdk.zig");


pub export fn main() void {
    psp.debug.screenInit();
    psp.debug.screenSetFrontColor(0xFF00FF00);

    var i : u32 = 0;
    const rows : u32 = 60;
    const columns : u32 = 34;

    while(true) : (i += 1) {
        psp.debug.internal_putchar(@mod(i,rows) * 8, @mod(i / rows, columns) * 8, @truncate(u8, i));
        var s = psp.sceDisplayWaitVblankStart();
    }

    psp.sceKernelExitGame();
}
