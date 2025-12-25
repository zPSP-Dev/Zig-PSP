//A quick graphics example
const psp = @import("psp/pspsdk.zig");
const gu = psp.gu;
const gum = psp.gum;

comptime {
    asm (psp.extra.module.module_info("Zig PSP App", 0, 1, 0));
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
    const SCREEN_WIDTH = psp.extra.constants.SCREEN_WIDTH;
    const SCREEN_HEIGHT = psp.extra.constants.SCREEN_HEIGHT;
    const SCR_BUF_WIDTH = psp.extra.constants.SCR_BUF_WIDTH;

    psp.extra.utils.enableHBCB();
    psp.extra.debug.screenInit();

    const fbp0 = psp.extra.vram.allocVramRelative(SCR_BUF_WIDTH, SCREEN_HEIGHT, .Psm8888);
    const fbp1 = psp.extra.vram.allocVramRelative(SCR_BUF_WIDTH, SCREEN_HEIGHT, .Psm8888);
    const zbp = psp.extra.vram.allocVramRelative(SCR_BUF_WIDTH, SCREEN_HEIGHT, .Psm4444);

    gu.sceGuInit();
    gu.sceGuStart(.Direct, @as(*anyopaque, @ptrCast(&display_list)));
    gu.sceGuDrawBuffer(.Psm8888, fbp0, SCR_BUF_WIDTH);
    gu.sceGuDispBuffer(SCREEN_WIDTH, SCREEN_HEIGHT, fbp1, SCR_BUF_WIDTH);
    gu.sceGuDepthBuffer(zbp, SCR_BUF_WIDTH);
    gu.sceGuOffset(2048 - (SCREEN_WIDTH / 2), 2048 - (SCREEN_HEIGHT / 2));
    gu.sceGuViewport(2048, 2048, SCREEN_WIDTH, SCREEN_HEIGHT);
    gu.sceGuDepthRange(65535, 0);
    gu.sceGuScissor(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    gu.sceGuEnable(.ScissorTest);
    gu.sceGuDepthFunc(.GreaterOrEqual);
    gu.sceGuEnable(.DepthTest);
    gu.sceGuShadeModel(.Smooth);
    gu.sceGuFrontFace(.Clockwise);
    gu.sceGuEnable(.CullFace);
    gu.sceGuDisable(.ClipPlanes);
    gu.sceGuEnable(.Texture2D);

    gu.guFinish();
    gu.guSync(.Finish, .Wait);
    _ = psp.display.sceDisplayWaitVblankStart();
    gu.sceGuDisplay(true);

    var i: u32 = 0;
    while (true) : (i += 1) {
        gu.sceGuStart(.Direct, @as(*anyopaque, @ptrCast(&display_list)));

        gu.sceGuClearColor(gu.rgba(32, 32, 32, 0xFF));
        gu.sceGuClearDepth(0);
        gu.sceGuClear(@intFromEnum(gu.types.ClearBitFlags.ColorBuffer) |
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

        gu.sceGuTexMode(.Psm8888, 0, 0, 0);
        gu.sceGuTexImage(0, 128, 128, 128, &logo_start);
        gu.sceGuTexFunc(.Replace, .Rgba);
        gu.sceGuTexFilter(.Linear, .Linear);
        gu.sceGuTexScale(1.0, 1.0);
        gu.sceGuTexOffset(0.0, 0.0);
        gu.sceGuAmbientColor(0xffffffff);

        // draw cube
        gum.sceGumDrawArray(.Triangles, @intFromEnum(gu.types.VertexTypeFlags.Texture32Bitf) | @intFromEnum(gu.types.VertexTypeFlags.Color8888) | @intFromEnum(gu.types.VertexTypeFlags.Vertex32Bitf) | @intFromEnum(gu.types.VertexTypeFlags.Transform3D), 12 * 3, null, @as(*anyopaque, @ptrCast(&vertices)));

        gu.guFinish();
        gu.guSync(.Finish, .Wait);
        _ = psp.display.sceDisplayWaitVblankStart();
        gu.guSwapBuffers();
    }
}

const logo_start align(16) = @embedFile("ziggy.bin").*;
