// Native GU ziggy cube -- spinning textured cube using the PSP GU/GUM API
const std = @import("std");
const sdk = @import("pspsdk");
const gu = sdk.gu;
const gum = sdk.gum;
const io = sdk.c.IoFileMgrForUser;

pub const panic = sdk.extra.debug.panic;

pub const std_options_debug_threaded_io: ?*std.Io.Threaded = null;
pub const std_options_debug_io: std.Io = sdk.extra.Io.psp_io;
pub fn std_options_cwd() std.Io.Dir {
    return .{ .handle = -1 };
}

comptime {
    asm (sdk.extra.module.module_info("SDK Ziggy Cube", .{ .mode = .User }, 1, 0));
}

var display_list: [0x40000]u32 align(16) = @splat(0);

const Vertex = packed struct {
    u: f32,
    v: f32,
    c: u32,
    x: f32,
    y: f32,
    z: f32,
};

const vertex_type = sdk.VertexType{
    .uv = .Texture32Bitf,
    .color = .Color8888,
    .vertex = .Vertex32Bitf,
    .transform = .Transform3D,
};

var vertices: [36]Vertex = [_]Vertex{
    Vertex{ .u = 0, .v = 0, .c = 0xff7f0000, .x = -1, .y = -1, .z = 1 },
    Vertex{ .u = 1, .v = 0, .c = 0xff7f0000, .x = -1, .y = 1, .z = 1 },
    Vertex{ .u = 1, .v = 1, .c = 0xff7f0000, .x = 1, .y = 1, .z = 1 },
    Vertex{ .u = 0, .v = 0, .c = 0xff7f0000, .x = -1, .y = -1, .z = 1 },
    Vertex{ .u = 1, .v = 1, .c = 0xff7f0000, .x = 1, .y = 1, .z = 1 },
    Vertex{ .u = 0, .v = 1, .c = 0xff7f0000, .x = 1, .y = -1, .z = 1 },
    Vertex{ .u = 0, .v = 0, .c = 0xff7f0000, .x = -1, .y = -1, .z = -1 },
    Vertex{ .u = 1, .v = 0, .c = 0xff7f0000, .x = 1, .y = -1, .z = -1 },
    Vertex{ .u = 1, .v = 1, .c = 0xff7f0000, .x = 1, .y = 1, .z = -1 },
    Vertex{ .u = 0, .v = 0, .c = 0xff7f0000, .x = -1, .y = -1, .z = -1 },
    Vertex{ .u = 1, .v = 1, .c = 0xff7f0000, .x = 1, .y = 1, .z = -1 },
    Vertex{ .u = 0, .v = 1, .c = 0xff7f0000, .x = -1, .y = 1, .z = -1 },
    Vertex{ .u = 0, .v = 0, .c = 0xff007f00, .x = 1, .y = -1, .z = -1 },
    Vertex{ .u = 1, .v = 0, .c = 0xff007f00, .x = 1, .y = -1, .z = 1 },
    Vertex{ .u = 1, .v = 1, .c = 0xff007f00, .x = 1, .y = 1, .z = 1 },
    Vertex{ .u = 0, .v = 0, .c = 0xff007f00, .x = 1, .y = -1, .z = -1 },
    Vertex{ .u = 1, .v = 1, .c = 0xff007f00, .x = 1, .y = 1, .z = 1 },
    Vertex{ .u = 0, .v = 1, .c = 0xff007f00, .x = 1, .y = 1, .z = -1 },
    Vertex{ .u = 0, .v = 0, .c = 0xff007f00, .x = -1, .y = -1, .z = -1 },
    Vertex{ .u = 1, .v = 0, .c = 0xff007f00, .x = -1, .y = 1, .z = -1 },
    Vertex{ .u = 1, .v = 1, .c = 0xff007f00, .x = -1, .y = 1, .z = 1 },
    Vertex{ .u = 0, .v = 0, .c = 0xff007f00, .x = -1, .y = -1, .z = -1 },
    Vertex{ .u = 1, .v = 1, .c = 0xff007f00, .x = -1, .y = 1, .z = 1 },
    Vertex{ .u = 0, .v = 1, .c = 0xff007f00, .x = -1, .y = -1, .z = 1 },
    Vertex{ .u = 0, .v = 0, .c = 0xff00007f, .x = -1, .y = 1, .z = -1 },
    Vertex{ .u = 1, .v = 0, .c = 0xff00007f, .x = 1, .y = 1, .z = -1 },
    Vertex{ .u = 1, .v = 1, .c = 0xff00007f, .x = 1, .y = 1, .z = 1 },
    Vertex{ .u = 0, .v = 0, .c = 0xff00007f, .x = -1, .y = 1, .z = -1 },
    Vertex{ .u = 1, .v = 1, .c = 0xff00007f, .x = 1, .y = 1, .z = 1 },
    Vertex{ .u = 0, .v = 1, .c = 0xff00007f, .x = -1, .y = 1, .z = 1 },
    Vertex{ .u = 0, .v = 0, .c = 0xff00007f, .x = -1, .y = -1, .z = -1 },
    Vertex{ .u = 1, .v = 0, .c = 0xff00007f, .x = -1, .y = -1, .z = 1 },
    Vertex{ .u = 1, .v = 1, .c = 0xff00007f, .x = 1, .y = -1, .z = 1 },
    Vertex{ .u = 0, .v = 0, .c = 0xff00007f, .x = -1, .y = -1, .z = -1 },
    Vertex{ .u = 1, .v = 1, .c = 0xff00007f, .x = 1, .y = -1, .z = 1 },
    Vertex{ .u = 0, .v = 1, .c = 0xff00007f, .x = 1, .y = -1, .z = -1 },
};

pub fn main(_: std.process.Init) !void {
    const SCREEN_WIDTH = sdk.extra.constants.SCREEN_WIDTH;
    const SCREEN_HEIGHT = sdk.extra.constants.SCREEN_HEIGHT;
    const SCR_BUF_WIDTH = sdk.extra.constants.SCR_BUF_WIDTH;

    sdk.extra.utils.enableHBCB();

    const fbp0 = sdk.extra.vram.allocVramRelative(SCR_BUF_WIDTH, SCREEN_HEIGHT, .Psm8888);
    const fbp1 = sdk.extra.vram.allocVramRelative(SCR_BUF_WIDTH, SCREEN_HEIGHT, .Psm8888);
    const zbp = sdk.extra.vram.allocVramRelative(SCR_BUF_WIDTH, SCREEN_HEIGHT, .Psm4444);

    gu.init();
    gu.start(.Direct, &display_list);
    gu.draw_buffer(.rgba8888, fbp0, SCR_BUF_WIDTH);
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

    gu.finish();
    gu.sync(.Finish, .wait);

    try sdk.display.wait_vblank_start();
    gu.display(true);

    // Rotation angles (in radians)
    var val: f32 = 0;

    // Render loop
    while (true) {
        gu.start(.Direct, &display_list);

        gu.clear_color(0x202020);
        gu.clear_depth(0);
        gu.clear(.{ .color = true, .depth = true });

        gum.matrix_mode(.Projection);
        gum.load_identity();
        gum.perspective(90.0, 16.0 / 9.0, 0.2, 10.0);

        gum.matrix_mode(.View);
        gum.load_identity();

        gum.matrix_mode(.Model);
        gum.load_identity();

        gum.translate(&.{ .x = 0, .y = 0, .z = -2.5 });
        gum.rotate_xyz(&.{ .x = val * 0.79, .y = val * 0.98, .z = val * 1.32 });

        gu.tex_mode(.Psm8888, 0, .Single, .Linear);
        gu.tex_image(0, 128, 128, 128, &logo_start);
        gu.tex_func(.Replace, .Rgba);
        gu.tex_filter(.Linear, .Linear);
        gu.tex_scale(1.0, 1.0);
        gu.tex_offset(0.0, 0.0);
        gu.ambient_color(0xffffffff);

        gum.draw_array(.Triangles, vertex_type, 12 * 3, null, @as(*anyopaque, @ptrCast(&vertices)));

        gu.finish();
        gu.sync(.Finish, .wait);

        gu.swap_buffers();

        try sdk.display.wait_vblank_start();

        val += 0.02;
    }
}

const logo_start align(16) = @embedFile("ziggy.bin").*;
