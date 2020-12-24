//A quick graphics initialization
const psp = @import("psp/pspsdk.zig");

comptime {
    asm(psp.module_info("Zig PSP App", 0, 1, 0));
}

var display_list : [0x40000]u32 align(16) = [_]u32{0} ** 0x40000;

pub fn main() !void {
    psp.utils.enableHBCB();
    
    var fbp0 = psp.vram.allocVramRelative(psp.SCR_BUF_WIDTH, psp.SCREEN_HEIGHT, psp.GuPixelMode.Psm8888);
    var fbp1 = psp.vram.allocVramRelative(psp.SCR_BUF_WIDTH, psp.SCREEN_HEIGHT, psp.GuPixelMode.Psm8888);
    var zbp = psp.vram.allocVramRelative(psp.SCR_BUF_WIDTH, psp.SCREEN_HEIGHT, psp.GuPixelMode.Psm4444);

    psp.sceGuInit();
    psp.sceGuStart(psp.GuContextType.Direct, @ptrCast(*c_void, &display_list));
    psp.sceGuDrawBuffer(psp.GuPixelMode.Psm8888, fbp0, psp.SCR_BUF_WIDTH);
    psp.sceGuDispBuffer(psp.SCREEN_WIDTH, psp.SCREEN_HEIGHT, fbp1, psp.SCR_BUF_WIDTH);
    psp.sceGuDepthBuffer(zbp, psp.SCR_BUF_WIDTH);
    psp.sceGuOffset(2048 - (psp.SCREEN_WIDTH/2), 2048 - (psp.SCREEN_HEIGHT/2));
    psp.sceGuViewport(2048, 2048, psp.SCREEN_WIDTH, psp.SCREEN_HEIGHT);
    psp.sceGuDepthRange(65535, 0);
    psp.sceGuScissor(0, 0, psp.SCREEN_WIDTH, psp.SCREEN_HEIGHT);
    psp.sceGuEnable(psp.GuState.ScissorTest);
    
    psp.guFinish();
    psp.guSync(psp.GuSyncMode.Finish, psp.GuSyncBehavior.Wait);
    psp.displayWaitVblankStart();
    psp.sceGuDisplay(true);

    var i : u32 = 0;
    while(true) : (i += 1) {
        psp.sceGuStart(psp.GuContextType.Direct, @ptrCast(*c_void, &display_list));
        
        psp.sceGuClearColor(psp.rgba(0xFF, 0xFF, 0, 0xFF));
        psp.sceGuClearDepth(0);
        psp.sceGuClear(
            @enumToInt(psp.ClearBitFlags.ColorBuffer) |
            @enumToInt(psp.ClearBitFlags.DepthBuffer)
        );
        
        

        psp.guFinish();
        psp.guSync(psp.GuSyncMode.Finish, psp.GuSyncBehavior.Wait);
        psp.displayWaitVblankStart();
        psp.sceGuSwapBuffers();
    }
}
