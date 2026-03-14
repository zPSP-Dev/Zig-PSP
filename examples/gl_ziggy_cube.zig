// OpenGL-style ziggy cube using zpspgl (GL 1.1 compatibility layer on PSP GE)
const std = @import("std");
const sdk = @import("pspsdk");
const gl = @import("zpspgl");
const io = sdk.c.IoFileMgrForUser;

pub const panic = sdk.extra.debug.panic;

comptime {
    asm (sdk.extra.module.module_info("GL Ziggy Cube", .{ .mode = .User }, 1, 0));
}

const Vertex = packed struct {
    u: f32,
    v: f32,
    color: u32,
    x: f32,
    y: f32,
    z: f32,
};

fn rgba(r: u8, g: u8, b: u8, a: u8) u32 {
    return @as(u32, a) << 24 | @as(u32, b) << 16 | @as(u32, g) << 8 | r;
}

const red = rgba(0x7f, 0x00, 0x00, 0xff);
const green = rgba(0x00, 0x7f, 0x00, 0xff);
const blue = rgba(0x00, 0x00, 0x7f, 0xff);

var vertices: [36]Vertex = [_]Vertex{
    .{ .u = 0, .v = 0, .color = red, .x = -1, .y = -1, .z = 1 },
    .{ .u = 1, .v = 0, .color = red, .x = -1, .y = 1, .z = 1 },
    .{ .u = 1, .v = 1, .color = red, .x = 1, .y = 1, .z = 1 },
    .{ .u = 0, .v = 0, .color = red, .x = -1, .y = -1, .z = 1 },
    .{ .u = 1, .v = 1, .color = red, .x = 1, .y = 1, .z = 1 },
    .{ .u = 0, .v = 1, .color = red, .x = 1, .y = -1, .z = 1 },
    .{ .u = 0, .v = 0, .color = red, .x = -1, .y = -1, .z = -1 },
    .{ .u = 1, .v = 0, .color = red, .x = 1, .y = -1, .z = -1 },
    .{ .u = 1, .v = 1, .color = red, .x = 1, .y = 1, .z = -1 },
    .{ .u = 0, .v = 0, .color = red, .x = -1, .y = -1, .z = -1 },
    .{ .u = 1, .v = 1, .color = red, .x = 1, .y = 1, .z = -1 },
    .{ .u = 0, .v = 1, .color = red, .x = -1, .y = 1, .z = -1 },
    .{ .u = 0, .v = 0, .color = green, .x = 1, .y = -1, .z = -1 },
    .{ .u = 1, .v = 0, .color = green, .x = 1, .y = -1, .z = 1 },
    .{ .u = 1, .v = 1, .color = green, .x = 1, .y = 1, .z = 1 },
    .{ .u = 0, .v = 0, .color = green, .x = 1, .y = -1, .z = -1 },
    .{ .u = 1, .v = 1, .color = green, .x = 1, .y = 1, .z = 1 },
    .{ .u = 0, .v = 1, .color = green, .x = 1, .y = 1, .z = -1 },
    .{ .u = 0, .v = 0, .color = green, .x = -1, .y = -1, .z = -1 },
    .{ .u = 1, .v = 0, .color = green, .x = -1, .y = 1, .z = -1 },
    .{ .u = 1, .v = 1, .color = green, .x = -1, .y = 1, .z = 1 },
    .{ .u = 0, .v = 0, .color = green, .x = -1, .y = -1, .z = -1 },
    .{ .u = 1, .v = 1, .color = green, .x = -1, .y = 1, .z = 1 },
    .{ .u = 0, .v = 1, .color = green, .x = -1, .y = -1, .z = 1 },
    .{ .u = 0, .v = 0, .color = blue, .x = -1, .y = 1, .z = -1 },
    .{ .u = 1, .v = 0, .color = blue, .x = 1, .y = 1, .z = -1 },
    .{ .u = 1, .v = 1, .color = blue, .x = 1, .y = 1, .z = 1 },
    .{ .u = 0, .v = 0, .color = blue, .x = -1, .y = 1, .z = -1 },
    .{ .u = 1, .v = 1, .color = blue, .x = 1, .y = 1, .z = 1 },
    .{ .u = 0, .v = 1, .color = blue, .x = -1, .y = 1, .z = 1 },
    .{ .u = 0, .v = 0, .color = blue, .x = -1, .y = -1, .z = -1 },
    .{ .u = 1, .v = 0, .color = blue, .x = -1, .y = -1, .z = 1 },
    .{ .u = 1, .v = 1, .color = blue, .x = 1, .y = -1, .z = 1 },
    .{ .u = 0, .v = 0, .color = blue, .x = -1, .y = -1, .z = -1 },
    .{ .u = 1, .v = 1, .color = blue, .x = 1, .y = -1, .z = 1 },
    .{ .u = 0, .v = 1, .color = blue, .x = 1, .y = -1, .z = -1 },
};

pub fn main(_: std.process.Init) !void {
    sdk.extra.utils.enableHBCB();

    gl.zglInit(.{});

    // GL state setup
    gl.Enable(gl.GL_DEPTH_TEST);
    gl.DepthFunc(gl.GL_LEQUAL);
    gl.Enable(gl.GL_CULL_FACE);
    gl.FrontFace(gl.GL_CW);
    gl.ShadeModel(gl.GL_SMOOTH);
    gl.Enable(gl.GL_TEXTURE_2D);

    gl.ClearColor(0.125, 0.125, 0.125, 1.0);
    gl.ClearDepth(1.0);

    // Set up projection
    gl.MatrixMode(gl.GL_PROJECTION);
    gl.LoadIdentity();
    const fovy: f32 = 90.0;
    const aspect: f32 = 16.0 / 9.0;
    const znear: f32 = 0.2;
    const zfar: f32 = 10.0;
    const angle_val = (fovy / 2.0) * (3.14159265 / 180.0);
    const f_val = @cos(angle_val) / @sin(angle_val);
    const top = znear / f_val;
    const right = top * aspect;
    gl.Frustum(-right, right, -top, top, znear, zfar);

    // Vertex arrays
    const stride: gl.GLsizei = @sizeOf(Vertex);
    gl.EnableClientState(gl.GL_VERTEX_ARRAY);
    gl.EnableClientState(gl.GL_COLOR_ARRAY);
    gl.EnableClientState(gl.GL_TEXTURE_COORD_ARRAY);
    gl.VertexPointer(3, gl.GL_FLOAT, stride, @ptrCast(&vertices));
    gl.ColorPointer(4, gl.GL_UNSIGNED_BYTE, stride, @ptrCast(&vertices));
    gl.TexCoordPointer(2, gl.GL_FLOAT, stride, @ptrCast(&vertices));

    // Texture
    gl.TexImage2D(gl.GL_TEXTURE_2D, 0, gl.GL_RGBA, 128, 128, 0, gl.GL_RGBA, gl.GL_UNSIGNED_BYTE, @ptrCast(&logo_start));
    gl.TexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MIN_FILTER, gl.GL_LINEAR);
    gl.TexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAG_FILTER, gl.GL_LINEAR);

    // Rotation angles (in radians)
    var val: f32 = 0;

    // Render loop
    while (true) {
        gl.Clear(gl.GL_COLOR_BUFFER_BIT | gl.GL_DEPTH_BUFFER_BIT);

        gl.MatrixMode(gl.GL_MODELVIEW);
        gl.LoadIdentity();
        gl.Translatef(0, 0, -2.5);
        gl.Rotatef(val * 0.79 * (180.0 / 3.14159265), 1, 0, 0);
        gl.Rotatef(val * 0.98 * (180.0 / 3.14159265), 0, 1, 0);
        gl.Rotatef(val * 1.32 * (180.0 / 3.14159265), 0, 0, 1);

        gl.DrawArrays(gl.GL_TRIANGLES, 0, 36);

        // Dump display list after first frame (before swap resets it)
        if (val == 0) {
            const dl = gl.zglGetDisplayList();
            const start: [*]const u8 = @ptrCast(dl.start);
            const len = (@intFromPtr(dl.current) - @intFromPtr(dl.start));
            const fd = io.sceIoOpen(@ptrCast("ms0:/gl_dl.bin"), 0x0602, 0o777);
            if (fd >= 0) {
                _ = io.sceIoWrite(fd, start, @intCast(len));
                _ = io.sceIoClose(fd);
            }
        }

        gl.zglSwapBuffers();

        val += 0.02;
    }
}

const logo_start align(16) = @embedFile("ziggy.bin").*;
