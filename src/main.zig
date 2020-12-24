//A quick graphics example
const psp = @import("psp/pspsdk.zig");
pub const panic = psp.debug.panic;

comptime {
    asm (psp.module_info("Zig PSP App", 0, 1, 0));
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
    psp.utils.enableHBCB();
    psp.debug.screenInit();

    var fbp0 = psp.vram.allocVramRelative(psp.SCR_BUF_WIDTH, psp.SCREEN_HEIGHT, psp.GuPixelMode.Psm8888);
    var fbp1 = psp.vram.allocVramRelative(psp.SCR_BUF_WIDTH, psp.SCREEN_HEIGHT, psp.GuPixelMode.Psm8888);
    var zbp = psp.vram.allocVramRelative(psp.SCR_BUF_WIDTH, psp.SCREEN_HEIGHT, psp.GuPixelMode.Psm4444);

    psp.sceGuInit();
    psp.sceGuStart(psp.GuContextType.Direct, @ptrCast(*c_void, &display_list));
    psp.sceGuDrawBuffer(psp.GuPixelMode.Psm8888, fbp0, psp.SCR_BUF_WIDTH);
    psp.sceGuDispBuffer(psp.SCREEN_WIDTH, psp.SCREEN_HEIGHT, fbp1, psp.SCR_BUF_WIDTH);
    psp.sceGuDepthBuffer(zbp, psp.SCR_BUF_WIDTH);
    psp.sceGuOffset(2048 - (psp.SCREEN_WIDTH / 2), 2048 - (psp.SCREEN_HEIGHT / 2));
    psp.sceGuViewport(2048, 2048, psp.SCREEN_WIDTH, psp.SCREEN_HEIGHT);
    psp.sceGuDepthRange(65535, 0);
    psp.sceGuScissor(0, 0, psp.SCREEN_WIDTH, psp.SCREEN_HEIGHT);
    psp.sceGuEnable(psp.GuState.ScissorTest);
    psp.sceGuDepthFunc(psp.DepthFunc.GreaterOrEqual);
    psp.sceGuEnable(psp.GuState.DepthTest);
    psp.sceGuShadeModel(psp.ShadeModel.Smooth);
    psp.sceGuFrontFace(psp.FrontFaceDirection.Clockwise);
    psp.sceGuEnable(psp.GuState.CullFace);
    psp.sceGuDisable(psp.GuState.ClipPlanes);
    psp.sceGuEnable(psp.GuState.Texture2D);

    psp.guFinish();
    psp.guSync(psp.GuSyncMode.Finish, psp.GuSyncBehavior.Wait);
    psp.displayWaitVblankStart();
    psp.sceGuDisplay(true);

    var i: u32 = 0;
    while (true) : (i += 1) {
        psp.sceGuStart(psp.GuContextType.Direct, @ptrCast(*c_void, &display_list));

        psp.sceGuClearColor(psp.rgba(32, 32, 32, 0xFF));
        psp.sceGuClearDepth(0);
        psp.sceGuClear(@enumToInt(psp.ClearBitFlags.ColorBuffer) |
            @enumToInt(psp.ClearBitFlags.DepthBuffer));

        psp.sceGumMatrixMode(psp.MatrixMode.Projection);
        psp.sceGumLoadIdentity();
        psp.sceGumPerspective(90.0, 16.0 / 9.0, 0.2, 10.0);

        psp.sceGumMatrixMode(psp.MatrixMode.View);
        psp.sceGumLoadIdentity();

        psp.sceGumMatrixMode(psp.MatrixMode.Model);
        psp.sceGumLoadIdentity();

        //Rotate
        var pos: psp.ScePspFVector3 = psp.ScePspFVector3{ .x = 0, .y = 0, .z = -2.5 };
        var rot: psp.ScePspFVector3 = psp.ScePspFVector3{ .x = @intToFloat(f32, i) * 0.79 * (3.14159 / 180.0), .y = @intToFloat(f32, i) * 0.98 * (3.14159 / 180.0), .z = @intToFloat(f32, i) * 1.32 * (3.14159 / 180.0) };
        psp.sceGumTranslate(&pos);
        psp.sceGumRotateXYZ(&rot);

        psp.sceGuTexMode(psp.GuPixelMode.Psm8888, 0, 0, 0);
        psp.sceGuTexImage(0, 128, 128, 128, &logo_start);
        psp.sceGuTexFunc(psp.TextureEffect.Replace, psp.TextureColorComponent.Rgba);
        psp.sceGuTexFilter(psp.TextureFilter.Linear, psp.TextureFilter.Linear);
        psp.sceGuTexScale(1.0, 1.0);
        psp.sceGuTexOffset(0.0, 0.0);
        psp.sceGuAmbientColor(0xffffffff);

        // draw cube

        psp.sceGumDrawArray(psp.GuPrimitive.Triangles, @enumToInt(psp.VertexTypeFlags.Texture32Bitf) | @enumToInt(psp.VertexTypeFlags.Color8888) | @enumToInt(psp.VertexTypeFlags.Vertex32Bitf) | @enumToInt(psp.VertexTypeFlags.Transform3D), 12 * 3, null, @ptrCast(*c_void, &vertices));

        psp.guFinish();
        psp.guSync(psp.GuSyncMode.Finish, psp.GuSyncBehavior.Wait);
        psp.displayWaitVblankStart();
        psp.guSwapBuffers();
    }
}

const logo_start align(16) = @embedFile("ziggy.bin").*;
