pub fn _lb(arg_addr: u32) callconv(.C) u8 {
    var addr = arg_addr;
    return @intToPtr([*c]volatile vu8, addr).?.*;
}
pub fn _lh(arg_addr: u32) callconv(.C) u16 {
    var addr = arg_addr;
    return @intToPtr([*c]volatile vu16, addr).?.*;
}
pub fn _lw(arg_addr: u32) callconv(.C) u32 {
    var addr = arg_addr;
    return @intToPtr([*c]volatile vu32, addr).?.*;
}
pub fn _ld(arg_addr: u32) callconv(.C) u64 {
    var addr = arg_addr;
    return @intToPtr([*c]volatile vu64, addr).?.*;
}
pub fn _sb(arg_val: u8, arg_addr: u32) callconv(.C) void {
    var val = arg_val;
    var addr = arg_addr;
    @intToPtr([*c]volatile vu8, addr).?.* = val;
}
pub fn _sh(arg_val: u16, arg_addr: u32) callconv(.C) void {
    var val = arg_val;
    var addr = arg_addr;
    @intToPtr([*c]volatile vu16, addr).?.* = val;
}
pub fn _sw(arg_val: u32, arg_addr: u32) callconv(.C) void {
    var val = arg_val;
    var addr = arg_addr;
    @intToPtr([*c]volatile vu32, addr).?.* = val;
}
pub fn _sd(arg_val: u64, arg_addr: u32) callconv(.C) void {
    var val = arg_val;
    var addr = arg_addr;
    @intToPtr([*c]volatile vu64, addr).?.* = val;
}

pub const SceUChar8 = u8;
pub const SceUShort16 = u16;
pub const SceUInt32 = u32;
pub const SceUInt64 = u64;
pub const SceULong64 = u64;
pub const SceChar8 = u8;
pub const SceShort16 = i16;
pub const SceInt32 = i32;
pub const SceInt64 = i64;
pub const SceLong64 = i64;
pub const SceFloat = f32;
pub const SceFloat32 = f32;
pub const SceWChar16 = c_ushort;
pub const SceWChar32 = c_uint;
pub const SceBool = c_int;
pub const SceVoid = c_void;
pub const ScePVoid = ?*c_void;
const struct_ScePspSRect = extern struct {
    x: c_short,
    y: c_short,
    w: c_short,
    h: c_short,
};
pub const ScePspSRect = struct_ScePspSRect;
const struct_ScePspIRect = extern struct {
    x: c_int,
    y: c_int,
    w: c_int,
    h: c_int,
};
pub const ScePspIRect = struct_ScePspIRect;
const struct_ScePspL64Rect = extern struct {
    x: SceLong64,
    y: SceLong64,
    w: SceLong64,
    h: SceLong64,
};
pub const ScePspL64Rect = struct_ScePspL64Rect;
const struct_ScePspFRect = extern struct {
    x: f32,
    y: f32,
    w: f32,
    h: f32,
};
pub const ScePspFRect = struct_ScePspFRect;
const struct_ScePspSVector2 = extern struct {
    x: c_short,
    y: c_short,
};
pub const ScePspSVector2 = struct_ScePspSVector2;
const struct_ScePspIVector2 = extern struct {
    x: c_int,
    y: c_int,
};
pub const ScePspIVector2 = struct_ScePspIVector2;
const struct_ScePspL64Vector2 = extern struct {
    x: SceLong64,
    y: SceLong64,
};
pub const ScePspL64Vector2 = struct_ScePspL64Vector2;
const struct_ScePspFVector2 = extern struct {
    x: f32,
    y: f32,
};
pub const ScePspFVector2 = struct_ScePspFVector2;
const union_ScePspVector2 = extern union {
    fv: ScePspFVector2,
    iv: ScePspIVector2,
    f: [2]f32,
    i: [2]c_int,
};
pub const ScePspVector2 = union_ScePspVector2;
const struct_ScePspSVector3 = extern struct {
    x: c_short,
    y: c_short,
    z: c_short,
};
pub const ScePspSVector3 = struct_ScePspSVector3;
const struct_ScePspIVector3 = extern struct {
    x: c_int,
    y: c_int,
    z: c_int,
};
pub const ScePspIVector3 = struct_ScePspIVector3;
const struct_ScePspL64Vector3 = extern struct {
    x: SceLong64,
    y: SceLong64,
    z: SceLong64,
};
pub const ScePspL64Vector3 = struct_ScePspL64Vector3;
const struct_ScePspFVector3 = extern struct {
    x: f32,
    y: f32,
    z: f32,
};
pub const ScePspFVector3 = struct_ScePspFVector3;
const union_ScePspVector3 = extern union {
    fv: ScePspFVector3,
    iv: ScePspIVector3,
    f: [3]f32,
    i: [3]c_int,
};
pub const ScePspVector3 = union_ScePspVector3;
const struct_ScePspSVector4 = extern struct {
    x: c_short,
    y: c_short,
    z: c_short,
    w: c_short,
};
pub const ScePspSVector4 = struct_ScePspSVector4;
const struct_ScePspIVector4 = extern struct {
    x: c_int,
    y: c_int,
    z: c_int,
    w: c_int,
};
pub const ScePspIVector4 = struct_ScePspIVector4;
const struct_ScePspL64Vector4 = extern struct {
    x: SceLong64,
    y: SceLong64,
    z: SceLong64,
    w: SceLong64,
};
pub const ScePspL64Vector4 = struct_ScePspL64Vector4;
const struct_ScePspFVector4 = extern struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,
};
pub const ScePspFVector4 = struct_ScePspFVector4;
const struct_ScePspFVector4Unaligned = extern struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,
};
pub const ScePspFVector4Unaligned = struct_ScePspFVector4Unaligned;
const union_ScePspVector4 = extern union {
    fv: ScePspFVector4,
    iv: ScePspIVector4,
    f: [4]f32,
    i: [4]c_int,
};
pub const ScePspVector4 = union_ScePspVector4;
const struct_ScePspIMatrix2 = extern struct {
    x: ScePspIVector2,
    y: ScePspIVector2,
};
pub const ScePspIMatrix2 = struct_ScePspIMatrix2;
const struct_ScePspFMatrix2 = extern struct {
    x: ScePspFVector2,
    y: ScePspFVector2,
};
pub const ScePspFMatrix2 = struct_ScePspFMatrix2;
const union_ScePspMatrix2 = extern union {
    fm: ScePspFMatrix2,
    im: ScePspIMatrix2,
    fv: [2]ScePspFVector2,
    iv: [2]ScePspIVector2,
    v: [2]ScePspVector2,
    f: [2][2]f32,
    i: [2][2]c_int,
};
pub const ScePspMatrix2 = union_ScePspMatrix2;
const struct_ScePspIMatrix3 = extern struct {
    x: ScePspIVector3,
    y: ScePspIVector3,
    z: ScePspIVector3,
};
pub const ScePspIMatrix3 = struct_ScePspIMatrix3;
const struct_ScePspFMatrix3 = extern struct {
    x: ScePspFVector3,
    y: ScePspFVector3,
    z: ScePspFVector3,
};
pub const ScePspFMatrix3 = struct_ScePspFMatrix3;
const union_ScePspMatrix3 = extern union {
    fm: ScePspFMatrix3,
    im: ScePspIMatrix3,
    fv: [3]ScePspFVector3,
    iv: [3]ScePspIVector3,
    v: [3]ScePspVector3,
    f: [3][3]f32,
    i: [3][3]c_int,
};
pub const ScePspMatrix3 = union_ScePspMatrix3;
const struct_ScePspIMatrix4 = extern struct {
    x: ScePspIVector4,
    y: ScePspIVector4,
    z: ScePspIVector4,
    w: ScePspIVector4,
};
pub const ScePspIMatrix4 = struct_ScePspIMatrix4;
const struct_ScePspIMatrix4Unaligned = extern struct {
    x: ScePspIVector4,
    y: ScePspIVector4,
    z: ScePspIVector4,
    w: ScePspIVector4,
};
pub const ScePspIMatrix4Unaligned = struct_ScePspIMatrix4Unaligned;
const struct_ScePspFMatrix4 = extern struct {
    x: ScePspFVector4,
    y: ScePspFVector4,
    z: ScePspFVector4,
    w: ScePspFVector4,
};
pub const ScePspFMatrix4 = struct_ScePspFMatrix4;
const struct_ScePspFMatrix4Unaligned = extern struct {
    x: ScePspFVector4,
    y: ScePspFVector4,
    z: ScePspFVector4,
    w: ScePspFVector4,
};
pub const ScePspFMatrix4Unaligned = struct_ScePspFMatrix4Unaligned;
const union_ScePspMatrix4 = extern union {
    fm: ScePspFMatrix4,
    im: ScePspIMatrix4,
    fv: [4]ScePspFVector4,
    iv: [4]ScePspIVector4,
    v: [4]ScePspVector4,
    f: [4][4]f32,
    i: [4][4]c_int,
};
pub const ScePspMatrix4 = union_ScePspMatrix4;
const struct_ScePspFQuaternion = extern struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,
};
pub const ScePspFQuaternion = struct_ScePspFQuaternion;
const struct_ScePspFQuaternionUnaligned = extern struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,
};
pub const ScePspFQuaternionUnaligned = struct_ScePspFQuaternionUnaligned;
const struct_ScePspFColor = extern struct {
    r: f32,
    g: f32,
    b: f32,
    a: f32,
};
pub const ScePspFColor = struct_ScePspFColor;
const struct_ScePspFColorUnaligned = extern struct {
    r: f32,
    g: f32,
    b: f32,
    a: f32,
};
pub const ScePspFColorUnaligned = struct_ScePspFColorUnaligned;
pub const ScePspRGBA8888 = c_uint;
pub const ScePspRGBA4444 = c_ushort;
pub const ScePspRGBA5551 = c_ushort;
pub const ScePspRGB565 = c_ushort;
const union_ScePspUnion32 = extern union {
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
pub const ScePspUnion32 = union_ScePspUnion32;
const union_ScePspUnion64 = extern union {
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
pub const ScePspUnion64 = union_ScePspUnion64;
const union_ScePspUnion128 = extern union {
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
pub const ScePspUnion128 = union_ScePspUnion128;
const struct_ScePspDateTime = extern struct {
    year: c_ushort,
    month: c_ushort,
    day: c_ushort,
    hour: c_ushort,
    minute: c_ushort,
    second: c_ushort,
    microsecond: c_uint,
};
pub const ScePspDateTime = struct_ScePspDateTime;

pub const SceUID = c_int;
pub const SceSize = c_uint;
pub const SceSSize = c_int;
pub const SceUChar = u8;
pub const SceUInt = c_uint;
pub const SceMode = c_int;
pub const SceOff = SceInt64;
pub const SceIores = SceInt64;
