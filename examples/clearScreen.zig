//A quick graphics initialization
const psp = @import("pspsdk");
const gu = psp.gu;
const gum = psp.gum;

pub const panic = psp.extra.debug.panic; // Import panic handler

comptime {
    asm (psp.extra.module.module_info("SDK Clear Screen", 0, 1, 0));
}

var display_list: [0x40000]u32 align(16) = [_]u32{0} ** 0x40000;

pub fn main() !void {
    const SCREEN_WIDTH = psp.extra.constants.SCREEN_WIDTH;
    const SCREEN_HEIGHT = psp.extra.constants.SCREEN_HEIGHT;
    const SCR_BUF_WIDTH = psp.extra.constants.SCR_BUF_WIDTH;

    psp.extra.utils.enableHBCB();
    try psp.extra.debug.screenInit();

    const fbp0 = psp.extra.vram.allocVramRelative(SCR_BUF_WIDTH, SCREEN_HEIGHT, .Psm8888);
    const fbp1 = psp.extra.vram.allocVramRelative(SCR_BUF_WIDTH, SCREEN_HEIGHT, .Psm8888);
    const zbp = psp.extra.vram.allocVramRelative(SCR_BUF_WIDTH, SCREEN_HEIGHT, .Psm4444);

    gu.init();
    gu.start(.Direct, &display_list);
    gu.draw_buffer(.Format8888, fbp0, SCR_BUF_WIDTH);
    gu.disp_buffer(SCREEN_WIDTH, SCREEN_HEIGHT, fbp1, SCR_BUF_WIDTH);
    gu.depth_buffer(zbp, SCR_BUF_WIDTH);
    gu.offset(2048 - (SCREEN_WIDTH / 2), 2048 - (SCREEN_HEIGHT / 2));
    gu.viewport(2048, 2048, SCREEN_WIDTH, SCREEN_HEIGHT);
    gu.depth_range(65535, 0);
    gu.scissor(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    gu.enable(.ScissorTest);

    _ = gu.finish();
    _ = gu.sync(.Finish, .Wait);
    _ = psp.display.wait_vblank_start();
    gu.display(true);

    while (!psp.extra.utils.isExitRequested()) {
        gu.start(.Direct, &display_list);

        gu.clear_color(0x00ffff);
        gu.clear_depth(0);
        gu.clear(@intFromEnum(gu.types.ClearBitFlags.ColorBuffer) |
            @intFromEnum(gu.types.ClearBitFlags.DepthBuffer));

        _ = gu.finish();
        _ = gu.sync(.Finish, .Wait);
        _ = psp.display.wait_vblank_start();
        _ = gu.swap_buffers();
    }
}
