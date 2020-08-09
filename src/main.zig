//A Cube!
const psp = @import("psp/pspsdk.zig");

comptime {
    _ = psp.module_start_struct;
}

var display_list : [0x40000]u32 align(16) = [_]u32{0} ** 0x40000;


pub const Vertex = struct {
    u: f32,
    v: f32,
    x: f32,
    y: f32,
    z: f32,
};

var vertices : [36]Vertex align(16) = [_]Vertex{
    Vertex { .u = 0.0, .v = 0.0, .x = -1.0, .y = -1.0, .z =  1.0}, // 0
    Vertex { .u = 1.0, .v = 0.0, .x = -1.0, .y =  1.0, .z =  1.0}, // 4
    Vertex { .u = 1.0, .v = 1.0, .x =  1.0, .y =  1.0, .z =  1.0}, // 5
    Vertex { .u = 0.0, .v = 0.0, .x = -1.0, .y = -1.0, .z =  1.0}, // 0
    Vertex { .u = 1.0, .v = 1.0, .x =  1.0, .y =  1.0, .z =  1.0}, // 5
    Vertex { .u = 0.0, .v = 1.0, .x =  1.0, .y = -1.0, .z =  1.0}, // 1
    Vertex { .u = 0.0, .v = 0.0, .x = -1.0, .y = -1.0, .z = -1.0}, // 3
    Vertex { .u = 1.0, .v = 0.0, .x =  1.0, .y = -1.0, .z = -1.0}, // 2
    Vertex { .u = 1.0, .v = 1.0, .x =  1.0, .y =  1.0, .z = -1.0}, // 6
    Vertex { .u = 0.0, .v = 0.0, .x = -1.0, .y = -1.0, .z = -1.0}, // 3
    Vertex { .u = 1.0, .v = 1.0, .x =  1.0, .y =  1.0, .z = -1.0}, // 6
    Vertex { .u = 0.0, .v = 1.0, .x = -1.0, .y =  1.0, .z = -1.0}, // 7
    Vertex { .u = 0.0, .v = 0.0, .x =  1.0, .y = -1.0, .z = -1.0}, // 0
    Vertex { .u = 1.0, .v = 0.0, .x =  1.0, .y = -1.0, .z =  1.0}, // 3
    Vertex { .u = 1.0, .v = 1.0, .x =  1.0, .y =  1.0, .z =  1.0}, // 7
    Vertex { .u = 0.0, .v = 0.0, .x =  1.0, .y = -1.0, .z = -1.0}, // 0
    Vertex { .u = 1.0, .v = 1.0, .x =  1.0, .y =  1.0, .z =  1.0}, // 7
    Vertex { .u = 0.0, .v = 1.0, .x =  1.0, .y =  1.0, .z = -1.0}, // 4
    Vertex { .u = 0.0, .v = 0.0, .x = -1.0, .y = -1.0, .z = -1.0}, // 0
    Vertex { .u = 1.0, .v = 0.0, .x = -1.0, .y =  1.0, .z = -1.0}, // 3
    Vertex { .u = 1.0, .v = 1.0, .x = -1.0, .y =  1.0, .z =  1.0}, // 7
    Vertex { .u = 0.0, .v = 0.0, .x = -1.0, .y = -1.0, .z = -1.0}, // 0
    Vertex { .u = 1.0, .v = 1.0, .x = -1.0, .y =  1.0, .z =  1.0}, // 7
    Vertex { .u = 0.0, .v = 1.0, .x = -1.0, .y = -1.0, .z =  1.0}, // 4
    Vertex { .u = 0.0, .v = 0.0, .x = -1.0, .y =  1.0, .z = -1.0}, // 0
    Vertex { .u = 1.0, .v = 0.0, .x =  1.0, .y =  1.0, .z = -1.0}, // 1
    Vertex { .u = 1.0, .v = 1.0, .x =  1.0, .y =  1.0, .z =  1.0}, // 2
    Vertex { .u = 0.0, .v = 0.0, .x = -1.0, .y =  1.0, .z = -1.0}, // 0
    Vertex { .u = 1.0, .v = 1.0, .x =  1.0, .y =  1.0, .z =  1.0}, // 2
    Vertex { .u = 0.0, .v = 1.0, .x = -1.0, .y =  1.0, .z =  1.0}, // 3
    Vertex { .u = 0.0, .v = 0.0, .x = -1.0, .y = -1.0, .z = -1.0}, // 4
    Vertex { .u = 1.0, .v = 0.0, .x = -1.0, .y = -1.0, .z =  1.0}, // 7
    Vertex { .u = 1.0, .v = 1.0, .x =  1.0, .y = -1.0, .z =  1.0}, // 6
    Vertex { .u = 0.0, .v = 0.0, .x = -1.0, .y = -1.0, .z = -1.0}, // 4
    Vertex { .u = 1.0, .v = 1.0, .x =  1.0, .y = -1.0, .z =  1.0}, // 6
    Vertex { .u = 0.0, .v = 1.0, .x =  1.0, .y = -1.0, .z = -1.0}, // 5
};


var logo_start = @embedFile("./ferris.bin");

pub fn main() !void {
    psp.utils.enableHomeButton();
    
    var fbp0 = psp.utils.allocVramRelative(psp.SCR_BUF_WIDTH, psp.SCREEN_HEIGHT, psp.GuPixelMode.Psm8888);
    var fbp1 = psp.utils.allocVramRelative(psp.SCR_BUF_WIDTH, psp.SCREEN_HEIGHT, psp.GuPixelMode.Psm8888);
    var zbp = psp.utils.allocVramRelative(psp.SCR_BUF_WIDTH, psp.SCREEN_HEIGHT, psp.GuPixelMode.Psm4444);
    psp.sceGumLoadIdentity();
    psp.sceGuInit();
    psp.sceGuStart(@enumToInt(psp.GuContextType.Direct), @ptrCast(*c_void, &display_list));
    psp.sceGuDrawBuffer(@enumToInt(psp.GuPixelMode.Psm8888), fbp0, psp.SCR_BUF_WIDTH);
    psp.sceGuDispBuffer(psp.SCREEN_WIDTH, psp.SCREEN_HEIGHT, fbp1, psp.SCR_BUF_WIDTH);
    psp.sceGuDepthBuffer(zbp, psp.SCR_BUF_WIDTH);
    psp.sceGuOffset(2048 - (psp.SCREEN_WIDTH/2), 2048 - (psp.SCREEN_HEIGHT/2));
    psp.sceGuViewport(2048, 2048, psp.SCREEN_WIDTH, psp.SCREEN_HEIGHT);
    psp.sceGuDepthRange(65535, 0);
    psp.sceGuScissor(0, 0, psp.SCREEN_WIDTH, psp.SCREEN_HEIGHT);
    psp.sceGuEnable(@enumToInt(psp.GuState.ScissorTest));

    psp.sceGuDepthFunc(@enumToInt(psp.DepthFunc.GreaterOrEqual));
    psp.sceGuEnable(@enumToInt(psp.GuState.DepthTest));
    psp.sceGuFrontFace(@enumToInt(psp.FrontFaceDirection.Clockwise));
    psp.sceGuShadeModel(@enumToInt(psp.ShadeModel.Smooth));
    psp.sceGuEnable(@enumToInt(psp.GuState.CullFace));
    psp.sceGuEnable(@enumToInt(psp.GuState.Texture2D));
    psp.sceGuEnable(@enumToInt(psp.GuState.ClipPlanes));
    
    var displayListSize = psp.sceGuFinish();
    var unk1 = psp.sceGuSync(@enumToInt(psp.GuSyncMode.Finish), @enumToInt(psp.GuSyncBehavior.Wait));
    var v = psp.sceDisplayWaitVblankStart();
    var lastState = psp.sceGuDisplay(1);

    var i : f32 = 0;
    var x : u32 = 0;
    while(true) : (i += 1) {
        x += 1;
        psp.sceGuStart(@enumToInt(psp.GuContextType.Direct), @ptrCast(*c_void, &display_list));
        
        psp.sceGuClearColor(psp.rgba(0xFF, @truncate(u8,x), 0xFF, 0xFF));
        psp.sceGuClearDepth(0);
        psp.sceGuClear(
            @enumToInt(psp.ClearBitFlags.ColorBuffer) |
            @enumToInt(psp.ClearBitFlags.DepthBuffer) | 
            @enumToInt(psp.ClearBitFlags.FastClear)
        );

        psp.sceGumMatrixMode(@enumToInt(psp.MatrixMode.Projection));
        psp.sceGumLoadIdentity();
        //psp.sceGumPerspective(75.0,16.0/9.0,0.5,1000.0);

        psp.sceGumMatrixMode(@enumToInt(psp.MatrixMode.View));
        psp.sceGumLoadIdentity();

        psp.sceGumMatrixMode(@enumToInt(psp.MatrixMode.Model));
        psp.sceGumLoadIdentity();
        
        {
            //var pos : psp.ScePspFVector3 = psp.ScePspFVector3{ .x = 0, .y = 0, .z = -2.5 };
            //var rot : psp.ScePspFVector3 = psp.ScePspFVector3{ .x = i * 0.79 * (3.14159/180.0), .y = i * 0.98 * (3.14159/180.0), .z = i * 1.32 * (3.14159/180.0) };
            //psp.sceGumTranslate(&pos);
            //psp.sceGumRotateXYZ(&rot);
        }

        // setup texture

        psp.sceGuTexMode(@enumToInt(psp.GuPixelMode.Psm8888),0,0,0);
        psp.sceGuTexImage(0,64,64,64,logo_start);
        psp.sceGuTexFunc(@enumToInt(psp.TextureEffect.Add),@enumToInt(psp.TextureColorComponent.Rgb));
        psp.sceGuTexEnvColor(0xffff00);
        psp.sceGuTexFilter(@enumToInt(psp.TextureFilter.Linear),@enumToInt(psp.TextureFilter.Linear));
        psp.sceGuTexScale(1.0,1.0);
        psp.sceGuTexOffset(0.0,0.0);
        psp.sceGuAmbientColor(0xffffffff);

        // draw cube

        psp.sceGumDrawArray(@enumToInt(psp.GuPrimitive.Triangles),@enumToInt(psp.VertexTypeFlags.Texture32Bitf)|@enumToInt(psp.VertexTypeFlags.Color8888)|@enumToInt(psp.VertexTypeFlags.Vertex32Bitf)|@enumToInt(psp.VertexTypeFlags.Transform3D),12*3,null,@ptrCast(*c_void, &vertices));
        
        
        displayListSize = psp.sceGuFinish();
        unk1 = psp.sceGuSync(@enumToInt(psp.GuSyncMode.Finish), @enumToInt(psp.GuSyncBehavior.Wait));
        v = psp.sceDisplayWaitVblankStart();
        var buf = psp.sceGuSwapBuffers();
    }
}
