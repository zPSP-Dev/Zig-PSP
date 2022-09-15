fn _lb(arg_addr: u32) callconv(.C) u8 {
    var addr = arg_addr;
    return @intToPtr([*c]volatile u8, addr).?.*;
}
fn _lh(arg_addr: u32) callconv(.C) u16 {
    var addr = arg_addr;
    return @intToPtr([*c]volatile u16, addr).?.*;
}
fn _lw(arg_addr: u32) callconv(.C) u32 {
    var addr = arg_addr;
    return @intToPtr([*c]volatile u32, addr).?.*;
}
fn _ld(arg_addr: u32) callconv(.C) u64 {
    var addr = arg_addr;
    return @intToPtr([*c]volatile u64, addr).?.*;
}
fn _sb(arg_val: u8, arg_addr: u32) callconv(.C) void {
    var val = arg_val;
    var addr = arg_addr;
    @intToPtr([*c]volatile u8, addr).?.* = val;
}
fn _sh(arg_val: u16, arg_addr: u32) callconv(.C) void {
    var val = arg_val;
    var addr = arg_addr;
    @intToPtr([*c]volatile u16, addr).?.* = val;
}
fn _sw(arg_val: u32, arg_addr: u32) callconv(.C) void {
    var val = arg_val;
    var addr = arg_addr;
    @intToPtr([*c]volatile u32, addr).?.* = val;
}
fn _sd(arg_val: u64, arg_addr: u32) callconv(.C) void {
    var val = arg_val;
    var addr = arg_addr;
    @intToPtr([*c]volatile u64, addr).?.* = val;
}

const SceUChar8 = u8;
const SceUShort16 = u16;
const SceUInt32 = u32;
const SceUInt64 = u64;
const SceULong64 = u64;
const SceChar8 = u8;
const SceShort16 = i16;
const SceInt32 = i32;
const SceInt64 = i64;
const SceLong64 = i64;
const SceFloat = f32;
const SceFloat32 = f32;
const SceWChar16 = c_ushort;
const SceWChar32 = c_uint;
const SceBool = c_int;
const SceVoid = anyopaque;
const ScePVoid = ?*anyopaque;
const ScePspSRect = extern struct {
    x: c_short,
    y: c_short,
    w: c_short,
    h: c_short,
};
const ScePspIRect = extern struct {
    x: c_int,
    y: c_int,
    w: c_int,
    h: c_int,
};
const ScePspL64Rect = extern struct {
    x: SceLong64,
    y: SceLong64,
    w: SceLong64,
    h: SceLong64,
};
const ScePspFRect = extern struct {
    x: f32,
    y: f32,
    w: f32,
    h: f32,
};
 const ScePspSVector2 = extern struct {
    x: c_short,
    y: c_short,
};
 const ScePspIVector2 = extern struct {
    x: c_int,
    y: c_int,
};
 const ScePspL64Vector2 = extern struct {
    x: SceLong64,
    y: SceLong64,
};
 const ScePspFVector2 = extern struct {
    x: f32,
    y: f32,
};
 const ScePspVector2 = extern union {
    fv: ScePspFVector2,
    iv: ScePspIVector2,
    f: [2]f32,
    i: [2]c_int,
};
 const ScePspSVector3 = extern struct {
    x: c_short,
    y: c_short,
    z: c_short,
};
 const ScePspIVector3 = extern struct {
    x: c_int,
    y: c_int,
    z: c_int,
};
 const ScePspL64Vector3 = extern struct {
    x: SceLong64,
    y: SceLong64,
    z: SceLong64,
};
 const ScePspFVector3 = extern struct {
    x: f32,
    y: f32,
    z: f32,
};

 const ScePspVector3 = extern union {
    fv: ScePspFVector3,
    iv: ScePspIVector3,
    f: [3]f32,
    i: [3]c_int,
};
 const ScePspSVector4 = extern struct {
    x: c_short,
    y: c_short,
    z: c_short,
    w: c_short,
};
 const ScePspIVector4 = extern struct {
    x: c_int,
    y: c_int,
    z: c_int,
    w: c_int,
};
 const ScePspL64Vector4 = extern struct {
    x: SceLong64,
    y: SceLong64,
    z: SceLong64,
    w: SceLong64,
};
 const ScePspFVector4 = extern struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,
};
 const ScePspFVector4Unaligned = extern struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,
};
 const ScePspVector4 = extern union {
    fv: ScePspFVector4,
    iv: ScePspIVector4,
    f: [4]f32,
    i: [4]c_int,
};
 const ScePspIMatrix2 = extern struct {
    x: ScePspIVector2,
    y: ScePspIVector2,
};
 const ScePspFMatrix2 = extern struct {
    x: ScePspFVector2,
    y: ScePspFVector2,
};
 const ScePspMatrix2 = extern union {
    fm: ScePspFMatrix2,
    im: ScePspIMatrix2,
    fv: [2]ScePspFVector2,
    iv: [2]ScePspIVector2,
    v: [2]ScePspVector2,
    f: [2][2]f32,
    i: [2][2]c_int,
};
 const ScePspIMatrix3 = extern struct {
    x: ScePspIVector3,
    y: ScePspIVector3,
    z: ScePspIVector3,
};
 const ScePspFMatrix3 = extern struct {
    x: ScePspFVector3,
    y: ScePspFVector3,
    z: ScePspFVector3,
};
 const ScePspMatrix3 = extern union {
    fm: ScePspFMatrix3,
    im: ScePspIMatrix3,
    fv: [3]ScePspFVector3,
    iv: [3]ScePspIVector3,
    v: [3]ScePspVector3,
    f: [3][3]f32,
    i: [3][3]c_int,
};
 const ScePspIMatrix4 = extern struct {
    x: ScePspIVector4,
    y: ScePspIVector4,
    z: ScePspIVector4,
    w: ScePspIVector4,
};

 const ScePspIMatrix4Unaligned = extern struct {
    x: ScePspIVector4,
    y: ScePspIVector4,
    z: ScePspIVector4,
    w: ScePspIVector4,
};

 const ScePspFMatrix4 = extern struct {
    x: ScePspFVector4,
    y: ScePspFVector4,
    z: ScePspFVector4,
    w: ScePspFVector4,
};
 const ScePspFMatrix4Unaligned = extern struct {
    x: ScePspFVector4,
    y: ScePspFVector4,
    z: ScePspFVector4,
    w: ScePspFVector4,
};

 const ScePspMatrix4 = extern union {
    fm: ScePspFMatrix4,
    im: ScePspIMatrix4,
    fv: [4]ScePspFVector4,
    iv: [4]ScePspIVector4,
    v: [4]ScePspVector4,
    f: [4][4]f32,
    i: [4][4]c_int,
};
 const ScePspFQuaternion = extern struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,
};

 const ScePspFQuaternionUnaligned = extern struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,
};

 const ScePspFColor = extern struct {
    r: f32,
    g: f32,
    b: f32,
    a: f32,
};
 const ScePspFColorUnaligned = extern struct {
    r: f32,
    g: f32,
    b: f32,
    a: f32,
};

 const ScePspRGBA8888 = c_uint;
 const ScePspRGBA4444 = c_ushort;
 const ScePspRGBA5551 = c_ushort;
 const ScePspRGB565 = c_ushort;
 const ScePspUnion32 = extern union {
    ui: c_uint,
    i: c_int,
    us: [2]c_ushort,
    s: [2]c_short,
    uc: [4]u8,
    c: [4]u8,
    f: f32,
    rgba8888: ScePspRGBA8888,
    rgba4444: [2]ScePspRGBA4444,
    rgba5551: [2]ScePspRGBA5551,
    rgb565: [2]ScePspRGB565,
};

 const ScePspUnion64 = extern union {
    ul: SceULong64,
    l: SceLong64,
    ui: [2]c_uint,
    i: [2]c_int,
    us: [4]c_ushort,
    s: [4]c_short,
    uc: [8]u8,
    c: [8]u8,
    f: [2]f32,
    sr: ScePspSRect,
    sv: ScePspSVector4,
    rgba8888: [2]ScePspRGBA8888,
    rgba4444: [4]ScePspRGBA4444,
    rgba5551: [4]ScePspRGBA5551,
    rgb565: [4]ScePspRGB565,
};

 const ScePspUnion128 = extern union {
    ul: [2]SceULong64,
    l: [2]SceLong64,
    ui: [4]c_uint,
    i: [4]c_int,
    us: [8]c_ushort,
    s: [8]c_short,
    uc: [16]u8,
    c: [16]u8,
    f: [4]f32,
    fr: ScePspFRect,
    ir: ScePspIRect,
    fv: ScePspFVector4,
    iv: ScePspIVector4,
    fq: ScePspFQuaternion,
    fc: ScePspFColor,
    rgba8888: [4]ScePspRGBA8888,
    rgba4444: [8]ScePspRGBA4444,
    rgba5551: [8]ScePspRGBA5551,
    rgb565: [8]ScePspRGB565,
};

 const ScePspDateTime = extern struct {
    year: c_ushort,
    month: c_ushort,
    day: c_ushort,
    hour: c_ushort,
    minute: c_ushort,
    second: c_ushort,
    microsecond: c_uint,
};

 const SceUID = c_int;
 const SceSize = c_uint;
 const SceSSize = c_int;
 const SceUChar = u8;
 const SceUInt = c_uint;
 const SceMode = c_int;
 const SceOff = SceInt64;
 const SceIores = SceInt64;


 const MatrixMode = enum(c_int) {
    Projection = 0,
    View = 1,
    Model = 2,
    Texture = 3,
};

 const GuPrimitive = enum(c_int) {
    Points = 0,
    Lines = 1,
    LineStrip = 2,
    Triangles = 3,
    TriangleStrip = 4,
    TriangleFan = 5,
    Sprites = 6,
};

 const struct_SceKernelEventFlagOptParam = extern struct {
    size: SceSize,
};
 const SceKernelEventFlagOptParam = struct_SceKernelEventFlagOptParam;

extern fn sceGuDrawArray(prim: c_int, vtype: c_int, count: c_int, indices: ?*const anyopaque, vertices: ?*const anyopaque) void;
extern fn sceGuDrawArrayN(primitive_type: c_int, vertex_type: c_int, count: c_int, a3: c_int, indices: ?*const anyopaque, vertices: ?*const anyopaque) void;
extern fn sceGuDrawBezier(vtype: c_int, ucount: c_int, vcount: c_int, indices: ?*const anyopaque, vertices: ?*const anyopaque) void;
extern fn sceGuDrawSpline(vtype: c_int, ucount: c_int, vcount: c_int, uedge: c_int, vedge: c_int, indices: ?*const anyopaque, vertices: ?*const anyopaque) void;
extern fn sceGuSetMatrix(typec: c_int, matrix: [*c]ScePspFMatrix4) void;

//Internal
var gum_current_mode: u8 = 0;
var gum_matrix_update: [4]u8 = [_]u8{0} ** 4;
var gum_current_matrix_update: u8 = 0;

var gum_current_matrix: *ScePspFMatrix4 = @ptrCast(*ScePspFMatrix4, &gum_matrix_stack[0]);
var gum_stack_depth: [4][*]ScePspFMatrix4 = [_][*]ScePspFMatrix4{ @ptrCast([*]ScePspFMatrix4, &gum_matrix_stack[0]), @ptrCast([*]ScePspFMatrix4, &gum_matrix_stack[1]), @ptrCast([*]ScePspFMatrix4, &gum_matrix_stack[2]), @ptrCast([*]ScePspFMatrix4, &gum_matrix_stack[3]) };

var gum_matrix_stack: [4][32]ScePspFMatrix4 = undefined;

export fn sceGumDrawArray(prim: c_int, vtype: c_int, count: c_int, indices: ?*const anyopaque, vertices: ?*const anyopaque) void {
    sceGumUpdateMatrix();
    sceGuDrawArray(prim, vtype, count, indices, vertices);
}

export fn sceGumDrawArrayN(prim: c_int, vtype: c_int, count: c_int, a3: c_int, indices: ?*const anyopaque, vertices: ?*const anyopaque) void {
    sceGumUpdateMatrix();
    sceGuDrawArrayN(prim, vtype, count, a3, indices, vertices);
}

export fn sceGumDrawBezier(vtype: c_int, ucount: c_int, vcount: c_int, indices: ?*const anyopaque, vertices: ?*const anyopaque) void {
    sceGumUpdateMatrix();
    sceGuDrawBezier(vtype, ucount, vcount, indices, vertices);
}

export fn sceGumDrawSpline(vtype: c_int, ucount: c_int, vcount: c_int, uedge: c_int, vedge: c_int, indices: ?*const anyopaque, vertices: ?*const anyopaque) void {
    sceGumUpdateMatrix();
    sceGuDrawSpline(vtype, ucount, vcount, uedge, vedge, indices, vertices);
}

extern fn memset(ptr: [*]u8, value: u32, num: usize) [*]u8;
extern fn memcpy(dst: [*]u8, src: [*]const u8, num: isize) [*]u8;
extern fn memcmp(ptr1: [*]u8, ptr2: [*]u8, num: isize) i32;

export fn sceGumLoadIdentity() void {
    _ = memset(@ptrCast([*]u8, gum_current_matrix), 0, @sizeOf(ScePspFMatrix4));

    var i: usize = 0;
    while (i < 4) : (i += 1) {
        @ptrCast([*]f32, gum_current_matrix)[(i << 2) + i] = 1.0;
    }

    gum_current_matrix_update = 1;
}

export fn sceGumLoadMatrix(m: [*c]ScePspFMatrix4) void {
    _ = memcpy(@ptrCast([*]u8, gum_current_matrix), @ptrCast([*]u8, m), @sizeOf(ScePspFMatrix4));
    gum_current_matrix_update = 1;
}

export fn sceGumUpdateMatrix() void {
    gum_stack_depth[gum_current_mode] = @ptrCast([*]ScePspFMatrix4, gum_current_matrix);
    gum_matrix_update[gum_current_mode] = gum_current_matrix_update;
    gum_current_matrix_update = 0;

    var i: usize = 0;
    while (i < 4) : (i += 1) {
        if (gum_matrix_update[i] != 0) {
            sceGuSetMatrix(@intCast(c_int, i), gum_stack_depth[i]);
            gum_matrix_update[i] = 0;
        }
    }
}

export fn sceGumPopMatrix() void {
    var t = @ptrCast([*]ScePspFMatrix4, gum_current_matrix);
    t -= 1;
    gum_current_matrix = @ptrCast(*ScePspFMatrix4, t);
    gum_current_matrix_update = 1;
}

export fn sceGumPushMatrix() void {
    _ = memcpy(@ptrCast([*]u8, @ptrCast([*]ScePspFMatrix4, gum_current_matrix) + 1), @ptrCast([*]u8, @ptrCast([*]ScePspFMatrix4, gum_current_matrix)), @sizeOf(ScePspFMatrix4));
    var t = @ptrCast([*]ScePspFMatrix4, gum_current_matrix);
    t += 1;
    gum_current_matrix = @ptrCast(*ScePspFMatrix4, t);
}

export fn sceGumRotateXYZ(v: *ScePspFVector3) void {
    sceGumRotateX(v.x);
    sceGumRotateY(v.y);
    sceGumRotateZ(v.z);
}
export fn sceGumRotateZYX(v: *ScePspFVector3) void {
    sceGumRotateZ(v.z);
    sceGumRotateY(v.y);
    sceGumRotateX(v.x);
}

export fn sceGumStoreMatrix(m: [*c]ScePspFMatrix4) void {
    _ = memcpy(@ptrCast([*]u8, m), @ptrCast([*]u8, gum_current_matrix), @sizeOf(ScePspFMatrix4));
}

const std = @import("std");

export fn sceGumRotateX(angle: f32) void {
    var t: ScePspFMatrix4 = undefined;

    _ = memset(@ptrCast([*]u8, &t), 0, @sizeOf(ScePspFMatrix4));

    var i: usize = 0;
    while (i < 4) : (i += 1) {
        @ptrCast([*]f32, &t)[(i << 2) + i] = 1.0;
    }

    var c: f32 = @import("cos.zig").cos(angle);
    var s: f32 = @import("sin.zig").sin(angle);

    t.y.y = c;
    t.y.z = s;
    t.z.y = -s;
    t.z.z = c;

    gumMultMatrix(gum_current_matrix, gum_current_matrix, &t);
}

export fn sceGumRotateY(angle: f32) void {
    var t: ScePspFMatrix4 = undefined;

    _ = memset(@ptrCast([*]u8, &t), 0, @sizeOf(ScePspFMatrix4));

    var i: usize = 0;
    while (i < 4) : (i += 1) {
        @ptrCast([*]f32, &t)[(i << 2) + i] = 1.0;
    }

    var c: f32 = @import("cos.zig").cos(angle);
    var s: f32 = @import("sin.zig").sin(angle);

    t.x.x = c;
    t.x.z = -s;
    t.z.x = s;
    t.z.z = c;

    gumMultMatrix(gum_current_matrix, gum_current_matrix, &t);
}

export fn sceGumRotateZ(angle: f32) void {
    var t: ScePspFMatrix4 = undefined;

    _ = memset(@ptrCast([*]u8, &t), 0, @sizeOf(ScePspFMatrix4));

    var i: usize = 0;
    while (i < 4) : (i += 1) {
        @ptrCast([*]f32, &t)[(i << 2) + i] = 1.0;
    }

    var c: f32 = @import("cos.zig").cos(angle);
    var s: f32 = @import("sin.zig").sin(angle);

    t.x.x = c;
    t.x.y = s;
    t.y.x = -s;
    t.y.y = c;

    gumMultMatrix(gum_current_matrix, gum_current_matrix, &t);
}

fn gumMultMatrix(result: [*c]ScePspFMatrix4, a: [*c]const ScePspFMatrix4, b: [*c]const ScePspFMatrix4) void {
    var t: ScePspFMatrix4 = undefined;

    const ma: [*]const f32 = @ptrCast([*]const f32, a);
    const mb: [*]const f32 = @ptrCast([*]const f32, b);
    var mr: [*]f32 = @ptrCast([*]f32, &t);

    var i: usize = 0;
    while (i < 4) : (i += 1) {
        var j: usize = 0;
        while (j < 4) : (j += 1) {
            var v: f32 = 0.0;

            var k: usize = 0;
            while (k < 4) : (k += 1) {
                v += ma[(k << 2) + j] * mb[(i << 2) + k];
                mr[(i << 2) + j] = v;
            }
        }
    }

    _ = memcpy(@ptrCast([*]u8, result), @ptrCast([*]u8, &t), @sizeOf(ScePspFMatrix4));
}

export fn sceGumMatrixMode(mm: MatrixMode) void {
    @setRuntimeSafety(false);
    var mode: c_int = @enumToInt(mm);
    gum_matrix_update[gum_current_mode] = gum_current_matrix_update;
    gum_stack_depth[gum_current_mode] = @ptrCast([*]ScePspFMatrix4, gum_current_matrix);
    var t = @ptrCast([*]ScePspFMatrix4, gum_current_matrix);
    t = gum_stack_depth[@intCast(usize, mode)];
    gum_current_matrix = @ptrCast(*ScePspFMatrix4, t);
    gum_current_mode = @intCast(u8, mode);
    gum_current_matrix_update = gum_matrix_update[gum_current_mode];
}

export fn sceGumMultMatrix(m: [*c]const ScePspFMatrix4) void {
    gumMultMatrix(gum_current_matrix, gum_current_matrix, m);
    gum_current_matrix_update = 1;
}

export fn sceGumScale(v: *const ScePspFVector3) void {
    var x: f32 = 0;
    var y: f32 = 0;
    var z: f32 = 0;

    x = v.x;
    y = v.y;
    z = v.z;
    gum_current_matrix.x.x *= x;
    gum_current_matrix.x.y *= x;
    gum_current_matrix.x.z *= x;
    gum_current_matrix.y.x *= y;
    gum_current_matrix.y.y *= y;
    gum_current_matrix.y.z *= y;
    gum_current_matrix.z.x *= z;
    gum_current_matrix.z.y *= z;
    gum_current_matrix.z.z *= z;

    gum_current_matrix_update = 1;
}

export fn sceGumTranslate(v: *const ScePspFVector3) void {
    var t: ScePspFMatrix4 = undefined;
    _ = memset(@ptrCast([*]u8, &t), 0, @sizeOf(ScePspFMatrix4));

    var i: usize = 0;
    while (i < 4) : (i += 1) {
        @ptrCast([*]f32, &t)[(i << 2) + i] = 1.0;
    }

    t.w.x = v.x;
    t.w.y = v.y;
    t.w.z = v.z;
    gumMultMatrix(gum_current_matrix, gum_current_matrix, &t);
    gum_current_matrix_update = 1;
}

export fn sceGumOrtho(left: f32, right: f32, bottom: f32, top: f32, near: f32, far: f32) void {
    var dx: f32 = right - left;
    var dy: f32 = top - bottom;
    var dz: f32 = far - near;

    var t: ScePspFMatrix4 = undefined;
    _ = memset(@ptrCast([*]u8, &t), 0, @sizeOf(ScePspFMatrix4));

    t.x.x = 2.0 / dx;
    t.w.x = -(right + left) / dx;
    t.y.y = 2.0 / dy;
    t.w.y = -(top + bottom) / dy;
    t.z.z = -2.0 / dz;
    t.w.z = -(far + near) / dz;
    t.w.w = 1.0;

    sceGumMultMatrix(&t);
}

export fn sceGumPerspective(fovy: f32, aspect: f32, near: f32, far: f32) void {
    var angle: f32 = (fovy / 2) * (3.14159 / 180.0);
    var cotangent: f32 = std.math.cos(angle) / std.math.sin(angle);
    var delta_z: f32 = near - far;

    var t: ScePspFMatrix4 = undefined;
    _ = memset(@ptrCast([*]u8, &t), 0, @sizeOf(ScePspFMatrix4));

    t.x.x = cotangent / aspect;
    t.y.y = cotangent;
    t.z.z = (far + near) / delta_z; // -(far + near) / delta_z
    t.w.z = 2.0 * (far * near) / delta_z; // -2 * (far * near) / delta_z
    t.z.w = -1.0;
    t.w.w = 0.0;

    sceGumMultMatrix(&t);
}

//Maybe... I kinda just hate this function... it's pointless in most apps
//Feel free to make a PR
//export fn sceGumLookAt(eye: *ScePspFVector3, center: *ScePspFVector3, up: *ScePspFVector3) void{
//
//    var forward : ScePspFVector3 = undefined;
//    forward.x = center.x - eye.x;
//    forward.y = center.y - eye.y;
//    forward.z = center.z - eye.z;
//
//    var l : f32 = std.math.sqrt((forward.x*forward.x) + (forward.y*forward.y) + (forward.z*forward.z));
//    if (l > 0.00001)
//    {
//        var il : f32 = 1.0 / l;
//        forward.x *= il; forward.y *= il; forward.z *= il;
//    }
//
//    var side : ScePspFVector3 = undefined;
//    var lup : ScePspFVector3 = undefined;
//    var ieye : ScePspFVector3 = undefined;
//    var t : ScePspFMatrix4 = undefined;
//
//    gumCrossProduct(&side,&forward,up);
//    gumNormalize(&side);
//
//    gumCrossProduct(&lup,&side,&forward);
//    gumLoadIdentity(&t);
//
//    t.x.x = side.x;
//    t.y.x = side.y;
//    t.z.x = side.z;
//
//    t.x.y = lup.x;
//    t.y.y = lup.y;
//    t.z.y = lup.z;
//
//    t.x.z = -forward.x;
//    t.y.z = -forward.y;
//    t.z.z = -forward.z;
//
//    ieye.x = -eye.x; ieye.y = -eye.y; ieye.z = -eye.z;
//
//    gumMultMatrix(gum_current_matrix,gum_current_matrix,&t);
//    gumTranslate(gum_current_matrix,&ieye);
//
//    gum_current_matrix_update = 1;
//}

export fn sceGumFullInverse() void {
    var t: ScePspFMatrix4 = undefined;
    var d0: f32 = 0;
    var d1: f32 = 0;
    var d2: f32 = 0;
    var d3: f32 = 0;
    var d: f32 = 0;

    d0 = gum_current_matrix.y.y * gum_current_matrix.z.z * gum_current_matrix.w.w + gum_current_matrix.y.z * gum_current_matrix.z.w * gum_current_matrix.w.y + gum_current_matrix.y.w * gum_current_matrix.z.y * gum_current_matrix.w.z - gum_current_matrix.w.y * gum_current_matrix.z.z * gum_current_matrix.y.w - gum_current_matrix.w.z * gum_current_matrix.z.w * gum_current_matrix.y.y - gum_current_matrix.w.w * gum_current_matrix.z.y * gum_current_matrix.y.z;
    d1 = gum_current_matrix.y.x * gum_current_matrix.z.z * gum_current_matrix.w.w + gum_current_matrix.y.z * gum_current_matrix.z.w * gum_current_matrix.w.x + gum_current_matrix.y.w * gum_current_matrix.z.x * gum_current_matrix.w.z - gum_current_matrix.w.x * gum_current_matrix.z.z * gum_current_matrix.y.w - gum_current_matrix.w.z * gum_current_matrix.z.w * gum_current_matrix.y.x - gum_current_matrix.w.w * gum_current_matrix.z.x * gum_current_matrix.y.z;
    d2 = gum_current_matrix.y.x * gum_current_matrix.z.y * gum_current_matrix.w.w + gum_current_matrix.y.y * gum_current_matrix.z.w * gum_current_matrix.w.x + gum_current_matrix.y.w * gum_current_matrix.z.x * gum_current_matrix.w.y - gum_current_matrix.w.x * gum_current_matrix.z.y * gum_current_matrix.y.w - gum_current_matrix.w.y * gum_current_matrix.z.w * gum_current_matrix.y.x - gum_current_matrix.w.w * gum_current_matrix.z.x * gum_current_matrix.y.y;
    d3 = gum_current_matrix.y.x * gum_current_matrix.z.y * gum_current_matrix.w.z + gum_current_matrix.y.y * gum_current_matrix.z.z * gum_current_matrix.w.x + gum_current_matrix.y.z * gum_current_matrix.z.x * gum_current_matrix.w.y - gum_current_matrix.w.x * gum_current_matrix.z.y * gum_current_matrix.y.z - gum_current_matrix.w.y * gum_current_matrix.z.z * gum_current_matrix.y.x - gum_current_matrix.w.z * gum_current_matrix.z.x * gum_current_matrix.y.y;
    d = gum_current_matrix.x.x * d0 - gum_current_matrix.x.y * d1 + gum_current_matrix.x.z * d2 - gum_current_matrix.x.w * d3;

    if (std.math.fabs(d) < 0.000001) {
        _ = memset(@ptrCast([*]u8, gum_current_matrix), 0, @sizeOf(ScePspFMatrix4));

        var i: usize = 0;
        while (i < 4) : (i += 1) {
            @ptrCast([*]f32, gum_current_matrix)[(i << 2) + i] = 1.0;
        }
        return;
    }

    d = 1.0 / d;

    t.x.x = d * d0;
    t.x.y = -d * (gum_current_matrix.x.y * gum_current_matrix.z.z * gum_current_matrix.w.w + gum_current_matrix.x.z * gum_current_matrix.z.w * gum_current_matrix.w.y + gum_current_matrix.x.w * gum_current_matrix.z.y * gum_current_matrix.w.z - gum_current_matrix.w.y * gum_current_matrix.z.z * gum_current_matrix.x.w - gum_current_matrix.w.z * gum_current_matrix.z.w * gum_current_matrix.x.y - gum_current_matrix.w.w * gum_current_matrix.z.y * gum_current_matrix.x.z);
    t.x.z = d * (gum_current_matrix.x.y * gum_current_matrix.y.z * gum_current_matrix.w.w + gum_current_matrix.x.z * gum_current_matrix.y.w * gum_current_matrix.w.y + gum_current_matrix.x.w * gum_current_matrix.y.y * gum_current_matrix.w.z - gum_current_matrix.w.y * gum_current_matrix.y.z * gum_current_matrix.x.w - gum_current_matrix.w.z * gum_current_matrix.y.w * gum_current_matrix.x.y - gum_current_matrix.w.w * gum_current_matrix.y.y * gum_current_matrix.x.z);
    t.x.w = -d * (gum_current_matrix.x.y * gum_current_matrix.y.z * gum_current_matrix.z.w + gum_current_matrix.x.z * gum_current_matrix.y.w * gum_current_matrix.z.y + gum_current_matrix.x.w * gum_current_matrix.y.y * gum_current_matrix.z.z - gum_current_matrix.z.y * gum_current_matrix.y.z * gum_current_matrix.x.w - gum_current_matrix.z.z * gum_current_matrix.y.w * gum_current_matrix.x.y - gum_current_matrix.z.w * gum_current_matrix.y.y * gum_current_matrix.x.z);

    t.y.x = -d * d1;
    t.y.y = d * (gum_current_matrix.x.x * gum_current_matrix.z.z * gum_current_matrix.w.w + gum_current_matrix.x.z * gum_current_matrix.z.w * gum_current_matrix.w.x + gum_current_matrix.x.w * gum_current_matrix.z.x * gum_current_matrix.w.z - gum_current_matrix.w.x * gum_current_matrix.z.z * gum_current_matrix.x.w - gum_current_matrix.w.z * gum_current_matrix.z.w * gum_current_matrix.x.x - gum_current_matrix.w.w * gum_current_matrix.z.x * gum_current_matrix.x.z);
    t.y.z = -d * (gum_current_matrix.x.x * gum_current_matrix.y.z * gum_current_matrix.w.w + gum_current_matrix.x.z * gum_current_matrix.y.w * gum_current_matrix.w.x + gum_current_matrix.x.w * gum_current_matrix.y.x * gum_current_matrix.w.z - gum_current_matrix.w.x * gum_current_matrix.y.z * gum_current_matrix.x.w - gum_current_matrix.w.z * gum_current_matrix.y.w * gum_current_matrix.x.x - gum_current_matrix.w.w * gum_current_matrix.y.x * gum_current_matrix.x.z);
    t.y.w = d * (gum_current_matrix.x.x * gum_current_matrix.y.z * gum_current_matrix.z.w + gum_current_matrix.x.z * gum_current_matrix.y.w * gum_current_matrix.z.x + gum_current_matrix.x.w * gum_current_matrix.y.x * gum_current_matrix.z.z - gum_current_matrix.z.x * gum_current_matrix.y.z * gum_current_matrix.x.w - gum_current_matrix.z.z * gum_current_matrix.y.w * gum_current_matrix.x.x - gum_current_matrix.z.w * gum_current_matrix.y.x * gum_current_matrix.x.z);

    t.z.x = d * d2;
    t.z.y = -d * (gum_current_matrix.x.x * gum_current_matrix.z.y * gum_current_matrix.w.w + gum_current_matrix.x.y * gum_current_matrix.z.w * gum_current_matrix.w.x + gum_current_matrix.x.w * gum_current_matrix.z.x * gum_current_matrix.w.y - gum_current_matrix.w.x * gum_current_matrix.z.y * gum_current_matrix.x.w - gum_current_matrix.w.y * gum_current_matrix.z.w * gum_current_matrix.x.x - gum_current_matrix.w.w * gum_current_matrix.z.x * gum_current_matrix.x.y);
    t.z.z = d * (gum_current_matrix.x.x * gum_current_matrix.y.y * gum_current_matrix.w.w + gum_current_matrix.x.y * gum_current_matrix.y.w * gum_current_matrix.w.x + gum_current_matrix.x.w * gum_current_matrix.y.x * gum_current_matrix.w.y - gum_current_matrix.w.x * gum_current_matrix.y.y * gum_current_matrix.x.w - gum_current_matrix.w.y * gum_current_matrix.y.w * gum_current_matrix.x.x - gum_current_matrix.w.w * gum_current_matrix.y.x * gum_current_matrix.x.y);
    t.z.w = -d * (gum_current_matrix.x.x * gum_current_matrix.y.y * gum_current_matrix.z.w + gum_current_matrix.x.y * gum_current_matrix.y.w * gum_current_matrix.z.x + gum_current_matrix.x.w * gum_current_matrix.y.x * gum_current_matrix.z.y - gum_current_matrix.z.x * gum_current_matrix.y.y * gum_current_matrix.x.w - gum_current_matrix.z.y * gum_current_matrix.y.w * gum_current_matrix.x.x - gum_current_matrix.z.w * gum_current_matrix.y.x * gum_current_matrix.x.y);

    t.w.x = -d * d3;
    t.w.y = d * (gum_current_matrix.x.x * gum_current_matrix.z.y * gum_current_matrix.w.z + gum_current_matrix.x.y * gum_current_matrix.z.z * gum_current_matrix.w.x + gum_current_matrix.x.z * gum_current_matrix.z.x * gum_current_matrix.w.y - gum_current_matrix.w.x * gum_current_matrix.z.y * gum_current_matrix.x.z - gum_current_matrix.w.y * gum_current_matrix.z.z * gum_current_matrix.x.x - gum_current_matrix.w.z * gum_current_matrix.z.x * gum_current_matrix.x.y);
    t.w.z = -d * (gum_current_matrix.x.x * gum_current_matrix.y.y * gum_current_matrix.w.z + gum_current_matrix.x.y * gum_current_matrix.y.z * gum_current_matrix.w.x + gum_current_matrix.x.z * gum_current_matrix.y.x * gum_current_matrix.w.y - gum_current_matrix.w.x * gum_current_matrix.y.y * gum_current_matrix.x.z - gum_current_matrix.w.y * gum_current_matrix.y.z * gum_current_matrix.x.x - gum_current_matrix.w.z * gum_current_matrix.y.x * gum_current_matrix.x.y);
    t.w.w = d * (gum_current_matrix.x.x * gum_current_matrix.y.y * gum_current_matrix.z.z + gum_current_matrix.x.y * gum_current_matrix.y.z * gum_current_matrix.z.x + gum_current_matrix.x.z * gum_current_matrix.y.x * gum_current_matrix.z.y - gum_current_matrix.z.x * gum_current_matrix.y.y * gum_current_matrix.x.z - gum_current_matrix.z.y * gum_current_matrix.y.z * gum_current_matrix.x.x - gum_current_matrix.z.z * gum_current_matrix.y.x * gum_current_matrix.x.y);

    _ = memcpy(@ptrCast([*]u8, gum_current_matrix), @ptrCast([*]u8, &t), @sizeOf(ScePspFMatrix4));

    gum_current_matrix_update = 1;
}

fn gumDotProduct(a: *ScePspFVector3, b: *ScePspFVector3) f32 {
    return (a.x * b.x) + (a.y * b.y) + (a.z * b.z);
}

export fn sceGumFastInverse() void {
    var t: ScePspFMatrix4 = undefined;
    var negPos: ScePspFVector3 = ScePspFVector3{ .x = -gum_current_matrix.w.x, .y = -gum_current_matrix.w.y, .z = -gum_current_matrix.w.z };

    // transpose rotation
    t.x.x = gum_current_matrix.x.x;
    t.x.y = gum_current_matrix.y.x;
    t.x.z = gum_current_matrix.z.x;
    t.x.w = 0;

    t.y.x = gum_current_matrix.x.y;
    t.y.y = gum_current_matrix.y.y;
    t.y.z = gum_current_matrix.z.y;
    t.y.w = 0;

    t.z.x = gum_current_matrix.x.z;
    t.z.y = gum_current_matrix.y.z;
    t.z.z = gum_current_matrix.z.z;
    t.z.w = 0;

    // compute inverse position
    t.w.x = gumDotProduct(&negPos, @ptrCast(*ScePspFVector3, &gum_current_matrix.x));
    t.w.y = gumDotProduct(&negPos, @ptrCast(*ScePspFVector3, &gum_current_matrix.y));
    t.w.z = gumDotProduct(&negPos, @ptrCast(*ScePspFVector3, &gum_current_matrix.z));
    t.w.w = 1;

    _ = memcpy(@ptrCast([*]u8, gum_current_matrix), @ptrCast([*]u8, &t), @sizeOf(ScePspFMatrix4));
    gum_current_matrix_update = 1;
}
