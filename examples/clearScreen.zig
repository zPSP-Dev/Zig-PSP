//A quick graphics initialization
const sdk = @import("pspsdk");
const gu = sdk.gu;
const gum = sdk.gum;

comptime {
    asm (sdk.extra.module.module_info("SDK Clear Screen", 0, 1, 0));
}

var display_list: [0x40000]u32 align(16) = [_]u32{0} ** 0x40000;

pub fn main() !void {
    const SCREEN_WIDTH = sdk.extra.constants.SCREEN_WIDTH;
    const SCREEN_HEIGHT = sdk.extra.constants.SCREEN_HEIGHT;
    const SCR_BUF_WIDTH = sdk.extra.constants.SCR_BUF_WIDTH;

    sdk.extra.utils.enableHBCB();

    const fbp0 = sdk.extra.vram.allocVramRelative(SCR_BUF_WIDTH, SCREEN_HEIGHT, .Psm8888);
    const fbp1 = sdk.extra.vram.allocVramRelative(SCR_BUF_WIDTH, SCREEN_HEIGHT, .Psm8888);
    const zbp = sdk.extra.vram.allocVramRelative(SCR_BUF_WIDTH, SCREEN_HEIGHT, .Psm4444);

    gu.sceGuInit();
    gu.sceGuStart(.Direct, &display_list);
    gu.sceGuDrawBuffer(.Format8888, fbp0, SCR_BUF_WIDTH);
    gu.sceGuDispBuffer(SCREEN_WIDTH, SCREEN_HEIGHT, fbp1, SCR_BUF_WIDTH);
    gu.sceGuDepthBuffer(zbp, SCR_BUF_WIDTH);
    gu.sceGuOffset(2048 - (SCREEN_WIDTH / 2), 2048 - (SCREEN_HEIGHT / 2));
    gu.sceGuViewport(2048, 2048, SCREEN_WIDTH, SCREEN_HEIGHT);
    gu.sceGuDepthRange(65535, 0);
    gu.sceGuScissor(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    gu.sceGuEnable(.ScissorTest);

    gu.guFinish();
    gu.guSync(.Finish, .Wait);
    _ = sdk.display.sceDisplayWaitVblankStart();
    gu.sceGuDisplay(true);

    while (!sdk.extra.utils.isExitRequested()) {
        gu.sceGuStart(.Direct, &display_list);

        gu.sceGuClearColor(gu.rgba(0xff, 0xff, 0, 0xff));
        gu.sceGuClearDepth(0);
        gu.sceGuClear(@intFromEnum(gu.types.ClearBitFlags.ColorBuffer) |
            @intFromEnum(gu.types.ClearBitFlags.DepthBuffer));

        gu.guFinish();
        gu.guSync(.Finish, .Wait);
        _ = sdk.display.sceDisplayWaitVblankStart();
        gu.guSwapBuffers();
    }
}
