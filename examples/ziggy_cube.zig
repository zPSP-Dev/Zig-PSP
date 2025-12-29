//A quick graphics example
const sdk = @import("pspsdk");
const gu = sdk.psp.gu;
const gum = sdk.psp.gum;

pub const panic = sdk.extra.debug.panic; // Import panic handler

comptime {
    asm (sdk.extra.module.module_info("SDK Ziggy Cube", 0, 1, 0));
}

var display_list: [0x40000]u32 align(16) = [_]u32{0} ** 0x40000;

const Vertex = packed struct {
    u: f32,
    v: f32,
    c: u32,
    x: f32,
    y: f32,
    z: f32,
};

const vertex_type = gu.types.VertexType{
    .uv = .Texture32Bitf,
    .color = .Color8888,
    .vertex = .Vertex32Bitf,
    .transform = .Transform3D,
};

var vertices: [36]Vertex = [_]Vertex{
    Vertex{ .u = 0, .v = 0, .c = 0xff7f0000, .x = -1, .y = -1, .z = 1 }, // 0
    Vertex{ .u = 1, .v = 0, .c = 0xff7f0000, .x = -1, .y = 1, .z = 1 }, // 4
    Vertex{ .u = 1, .v = 1, .c = 0xff7f0000, .x = 1, .y = 1, .z = 1 }, // 5
    Vertex{ .u = 0, .v = 0, .c = 0xff7f0000, .x = -1, .y = -1, .z = 1 }, // 0
    Vertex{ .u = 1, .v = 1, .c = 0xff7f0000, .x = 1, .y = 1, .z = 1 }, // 5
    Vertex{ .u = 0, .v = 1, .c = 0xff7f0000, .x = 1, .y = -1, .z = 1 }, // 1
    Vertex{ .u = 0, .v = 0, .c = 0xff7f0000, .x = -1, .y = -1, .z = -1 }, // 3
    Vertex{ .u = 1, .v = 0, .c = 0xff7f0000, .x = 1, .y = -1, .z = -1 }, // 2
    Vertex{ .u = 1, .v = 1, .c = 0xff7f0000, .x = 1, .y = 1, .z = -1 }, // 6
    Vertex{ .u = 0, .v = 0, .c = 0xff7f0000, .x = -1, .y = -1, .z = -1 }, // 3
    Vertex{ .u = 1, .v = 1, .c = 0xff7f0000, .x = 1, .y = 1, .z = -1 }, // 6
    Vertex{ .u = 0, .v = 1, .c = 0xff7f0000, .x = -1, .y = 1, .z = -1 }, // 7
    Vertex{ .u = 0, .v = 0, .c = 0xff007f00, .x = 1, .y = -1, .z = -1 }, // 0
    Vertex{ .u = 1, .v = 0, .c = 0xff007f00, .x = 1, .y = -1, .z = 1 }, // 3
    Vertex{ .u = 1, .v = 1, .c = 0xff007f00, .x = 1, .y = 1, .z = 1 }, // 7
    Vertex{ .u = 0, .v = 0, .c = 0xff007f00, .x = 1, .y = -1, .z = -1 }, // 0
    Vertex{ .u = 1, .v = 1, .c = 0xff007f00, .x = 1, .y = 1, .z = 1 }, // 7
    Vertex{ .u = 0, .v = 1, .c = 0xff007f00, .x = 1, .y = 1, .z = -1 }, // 4
    Vertex{ .u = 0, .v = 0, .c = 0xff007f00, .x = -1, .y = -1, .z = -1 }, // 0
    Vertex{ .u = 1, .v = 0, .c = 0xff007f00, .x = -1, .y = 1, .z = -1 }, // 3
    Vertex{ .u = 1, .v = 1, .c = 0xff007f00, .x = -1, .y = 1, .z = 1 }, // 7
    Vertex{ .u = 0, .v = 0, .c = 0xff007f00, .x = -1, .y = -1, .z = -1 }, // 0
    Vertex{ .u = 1, .v = 1, .c = 0xff007f00, .x = -1, .y = 1, .z = 1 }, // 7
    Vertex{ .u = 0, .v = 1, .c = 0xff007f00, .x = -1, .y = -1, .z = 1 }, // 4
    Vertex{ .u = 0, .v = 0, .c = 0xff00007f, .x = -1, .y = 1, .z = -1 }, // 0
    Vertex{ .u = 1, .v = 0, .c = 0xff00007f, .x = 1, .y = 1, .z = -1 }, // 1
    Vertex{ .u = 1, .v = 1, .c = 0xff00007f, .x = 1, .y = 1, .z = 1 }, // 2
    Vertex{ .u = 0, .v = 0, .c = 0xff00007f, .x = -1, .y = 1, .z = -1 }, // 0
    Vertex{ .u = 1, .v = 1, .c = 0xff00007f, .x = 1, .y = 1, .z = 1 }, // 2
    Vertex{ .u = 0, .v = 1, .c = 0xff00007f, .x = -1, .y = 1, .z = 1 }, // 3
    Vertex{ .u = 0, .v = 0, .c = 0xff00007f, .x = -1, .y = -1, .z = -1 }, // 4
    Vertex{ .u = 1, .v = 0, .c = 0xff00007f, .x = -1, .y = -1, .z = 1 }, // 7
    Vertex{ .u = 1, .v = 1, .c = 0xff00007f, .x = 1, .y = -1, .z = 1 }, // 6
    Vertex{ .u = 0, .v = 0, .c = 0xff00007f, .x = -1, .y = -1, .z = -1 }, // 4
    Vertex{ .u = 1, .v = 1, .c = 0xff00007f, .x = 1, .y = -1, .z = 1 }, // 6
    Vertex{ .u = 0, .v = 1, .c = 0xff00007f, .x = 1, .y = -1, .z = -1 }, // 5
};

pub fn main() !void {
    const SCREEN_WIDTH = sdk.extra.constants.SCREEN_WIDTH;
    const SCREEN_HEIGHT = sdk.extra.constants.SCREEN_HEIGHT;
    const SCR_BUF_WIDTH = sdk.extra.constants.SCR_BUF_WIDTH;

    sdk.extra.utils.enableHBCB();
    try sdk.extra.debug.screenInit();

    const fbp0 = sdk.extra.vram.allocVramRelative(SCR_BUF_WIDTH, SCREEN_HEIGHT, .Psm8888);
    const fbp1 = sdk.extra.vram.allocVramRelative(SCR_BUF_WIDTH, SCREEN_HEIGHT, .Psm8888);
    const zbp = sdk.extra.vram.allocVramRelative(SCR_BUF_WIDTH, SCREEN_HEIGHT, .Psm4444);

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
    gu.depth_func(.GreaterOrEqual);
    gu.enable(.DepthTest);
    gu.shade_model(.Smooth);
    gu.front_face(.Clockwise);
    gu.enable(.CullFace);
    gu.disable(.ClipPlanes);
    gu.enable(.Texture2D);

    _ = gu.finish();
    _ = gu.sync(.Finish, .Wait);
    _ = sdk.psp.display.wait_vblank_start();
    gu.display(true);

    var i: u32 = 0;
    while (!sdk.extra.utils.isExitRequested()) : (i += 1) {
        gu.start(.Direct, &display_list);

        gu.clear_color(0x202020);
        gu.clear_depth(0);
        gu.clear(@intFromEnum(gu.types.ClearBitFlags.ColorBuffer) |
            @intFromEnum(gu.types.ClearBitFlags.DepthBuffer));

        gum.sceGumMatrixMode(.Projection);
        gum.sceGumLoadIdentity();
        gum.sceGumPerspective(90.0, 16.0 / 9.0, 0.2, 10.0);

        gum.sceGumMatrixMode(.View);
        gum.sceGumLoadIdentity();

        gum.sceGumMatrixMode(.Model);
        gum.sceGumLoadIdentity();

        gum.sceGumTranslate(&.{ .x = 0, .y = 0, .z = -2.5 });
        gum.sceGumRotateXYZ(&.{ .x = @as(f32, @floatFromInt(i)) * 0.79 * (3.14159 / 180.0), .y = @as(f32, @floatFromInt(i)) * 0.98 * (3.14159 / 180.0), .z = @as(f32, @floatFromInt(i)) * 1.32 * (3.14159 / 180.0) });

        gu.tex_mode(.Psm8888, 0, 0, 0);
        gu.tex_image(0, 128, 128, 128, &logo_start);
        gu.tex_func(.Replace, .Rgba);
        gu.tex_filter(.Linear, .Linear);
        gu.tex_scale(1.0, 1.0);
        gu.tex_offset(0.0, 0.0);
        gu.ambient_color(0xffffffff);

        // draw cube
        gum.sceGumDrawArray(.Triangles, vertex_type, 12 * 3, null, @as(*anyopaque, @ptrCast(&vertices)));

        _ = gu.finish();
        _ = gu.sync(.Finish, .Wait);
        _ = sdk.psp.display.wait_vblank_start();
        _ = gu.swap_buffers();
    }
}

const logo_start align(16) = @embedFile("ziggy.bin").*;
