//Types 
pub fn _lb(arg_addr: u32) callconv(.C) u8 {
    var addr = arg_addr;
    return @intToPtr([*c]volatile u8, addr).?.*;
}
pub fn _lh(arg_addr: u32) callconv(.C) u16 {
    var addr = arg_addr;
    return @intToPtr([*c]volatile u16, addr).?.*;
}
pub fn _lw(arg_addr: u32) callconv(.C) u32 {
    var addr = arg_addr;
    return @intToPtr([*c]volatile u32, addr).?.*;
}
pub fn _ld(arg_addr: u32) callconv(.C) u64 {
    var addr = arg_addr;
    return @intToPtr([*c]volatile u64, addr).?.*;
}
pub fn _sb(arg_val: u8, arg_addr: u32) callconv(.C) void {
    var val = arg_val;
    var addr = arg_addr;
    @intToPtr([*c]volatile u8, addr).?.* = val;
}
pub fn _sh(arg_val: u16, arg_addr: u32) callconv(.C) void {
    var val = arg_val;
    var addr = arg_addr;
    @intToPtr([*c]volatile u16, addr).?.* = val;
}
pub fn _sw(arg_val: u32, arg_addr: u32) callconv(.C) void {
    var val = arg_val;
    var addr = arg_addr;
    @intToPtr([*c]volatile u32, addr).?.* = val;
}
pub fn _sd(arg_val: u64, arg_addr: u32) callconv(.C) void {
    var val = arg_val;
    var addr = arg_addr;
    @intToPtr([*c]volatile u64, addr).?.* = val;
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
pub const SceVoid = anyopaque;
pub const ScePVoid = ?*anyopaque;
pub const ScePspSRect = extern struct {
    x: c_short,
    y: c_short,
    w: c_short,
    h: c_short,
};
pub const ScePspIRect = extern struct {
    x: c_int,
    y: c_int,
    w: c_int,
    h: c_int,
};
pub const ScePspL64Rect = extern struct {
    x: SceLong64,
    y: SceLong64,
    w: SceLong64,
    h: SceLong64,
};
pub const ScePspFRect = extern struct {
    x: f32,
    y: f32,
    w: f32,
    h: f32,
};
pub const ScePspSVector2 = extern struct {
    x: c_short,
    y: c_short,
};
pub const ScePspIVector2 = extern struct {
    x: c_int,
    y: c_int,
};
pub const ScePspL64Vector2 = extern struct {
    x: SceLong64,
    y: SceLong64,
};
pub const ScePspFVector2 = extern struct {
    x: f32,
    y: f32,
};
pub const ScePspVector2 = extern union {
    fv: ScePspFVector2,
    iv: ScePspIVector2,
    f: [2]f32,
    i: [2]c_int,
};
pub const ScePspSVector3 = extern struct {
    x: c_short,
    y: c_short,
    z: c_short,
};
pub const ScePspIVector3 = extern struct {
    x: c_int,
    y: c_int,
    z: c_int,
};
pub const ScePspL64Vector3 = extern struct {
    x: SceLong64,
    y: SceLong64,
    z: SceLong64,
};
pub const ScePspFVector3 = extern struct {
    x: f32,
    y: f32,
    z: f32,
};

pub const ScePspVector3 = extern union {
    fv: ScePspFVector3,
    iv: ScePspIVector3,
    f: [3]f32,
    i: [3]c_int,
};
pub const ScePspSVector4 = extern struct {
    x: c_short,
    y: c_short,
    z: c_short,
    w: c_short,
};
pub const ScePspIVector4 = extern struct {
    x: c_int,
    y: c_int,
    z: c_int,
    w: c_int,
};
pub const ScePspL64Vector4 = extern struct {
    x: SceLong64,
    y: SceLong64,
    z: SceLong64,
    w: SceLong64,
};
pub const ScePspFVector4 = extern struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,
};
pub const ScePspFVector4Unaligned = extern struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,
};
pub const ScePspVector4 = extern union {
    fv: ScePspFVector4,
    iv: ScePspIVector4,
    f: [4]f32,
    i: [4]c_int,
};
pub const ScePspIMatrix2 = extern struct {
    x: ScePspIVector2,
    y: ScePspIVector2,
};
pub const ScePspFMatrix2 = extern struct {
    x: ScePspFVector2,
    y: ScePspFVector2,
};
pub const ScePspMatrix2 = extern union {
    fm: ScePspFMatrix2,
    im: ScePspIMatrix2,
    fv: [2]ScePspFVector2,
    iv: [2]ScePspIVector2,
    v: [2]ScePspVector2,
    f: [2][2]f32,
    i: [2][2]c_int,
};
pub const ScePspIMatrix3 = extern struct {
    x: ScePspIVector3,
    y: ScePspIVector3,
    z: ScePspIVector3,
};
pub const ScePspFMatrix3 = extern struct {
    x: ScePspFVector3,
    y: ScePspFVector3,
    z: ScePspFVector3,
};
pub const ScePspMatrix3 = extern union {
    fm: ScePspFMatrix3,
    im: ScePspIMatrix3,
    fv: [3]ScePspFVector3,
    iv: [3]ScePspIVector3,
    v: [3]ScePspVector3,
    f: [3][3]f32,
    i: [3][3]c_int,
};
pub const ScePspIMatrix4 = extern struct {
    x: ScePspIVector4,
    y: ScePspIVector4,
    z: ScePspIVector4,
    w: ScePspIVector4,
};

pub const ScePspIMatrix4Unaligned = extern struct {
    x: ScePspIVector4,
    y: ScePspIVector4,
    z: ScePspIVector4,
    w: ScePspIVector4,
};

pub const ScePspFMatrix4 = extern struct {
    x: ScePspFVector4,
    y: ScePspFVector4,
    z: ScePspFVector4,
    w: ScePspFVector4,
};
pub const ScePspFMatrix4Unaligned = extern struct {
    x: ScePspFVector4,
    y: ScePspFVector4,
    z: ScePspFVector4,
    w: ScePspFVector4,
};

pub const ScePspMatrix4 = extern union {
    fm: ScePspFMatrix4,
    im: ScePspIMatrix4,
    fv: [4]ScePspFVector4,
    iv: [4]ScePspIVector4,
    v: [4]ScePspVector4,
    f: [4][4]f32,
    i: [4][4]c_int,
};
pub const ScePspFQuaternion = extern struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,
};

pub const ScePspFQuaternionUnaligned = extern struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,
};

pub const ScePspFColor = extern struct {
    r: f32,
    g: f32,
    b: f32,
    a: f32,
};
pub const ScePspFColorUnaligned = extern struct {
    r: f32,
    g: f32,
    b: f32,
    a: f32,
};

pub const ScePspRGBA8888 = c_uint;
pub const ScePspRGBA4444 = c_ushort;
pub const ScePspRGBA5551 = c_ushort;
pub const ScePspRGB565 = c_ushort;
pub const ScePspUnion32 = extern union {
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

pub const ScePspUnion64 = extern union {
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

pub const ScePspUnion128 = extern union {
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

pub const ScePspDateTime = extern struct {
    year: c_ushort,
    month: c_ushort,
    day: c_ushort,
    hour: c_ushort,
    minute: c_ushort,
    second: c_ushort,
    microsecond: c_uint,
};

pub const SceUID = c_int;
pub const SceSize = c_uint;
pub const SceSSize = c_int;
pub const SceUChar = u8;
pub const SceUInt = c_uint;
pub const SceMode = c_int;
pub const SceOff = SceInt64;
pub const SceIores = SceInt64;

pub const struct_SceKernelEventFlagOptParam = extern struct {
    size: SceSize,
};
pub const SceKernelEventFlagOptParam = struct_SceKernelEventFlagOptParam;


pub const GuPixelMode = enum(c_int) {
    Psm5650 = 0,
    Psm5551 = 1,
    Psm4444 = 2,
    Psm8888 = 3,
    PsmT4 = 4,
    PsmT8 = 5,
    PsmT16 = 6,
    PsmT32 = 7,
    PsmDXT1 = 8,
    PsmDXT3 = 9,
    PsmDXT5 = 10,
};

pub const GuPrimitive = enum(c_int) {
    Points = 0,
    Lines = 1,
    LineStrip = 2,
    Triangles = 3,
    TriangleStrip = 4,
    TriangleFan = 5,
    Sprites = 6,
};

pub const PatchPrimitive = enum(c_int) {
    Points = 0,
    LineStrip = 2,
    TriangleStrip = 4,
};

pub const GuState = enum(c_int) {
    AlphaTest = 0,
    DepthTest = 1,
    ScissorTest = 2,
    StencilTest = 3,
    Blend = 4,
    CullFace = 5,
    Dither = 6,
    Fog = 7,
    ClipPlanes = 8,
    Texture2D = 9,
    Lighting = 10,
    Light0 = 11,
    Light1 = 12,
    Light2 = 13,
    Light3 = 14,
    LineSmooth = 15,
    PatchCullFace = 16,
    ColorTest = 17,
    ColorLogicOp = 18,
    FaceNormalReverse = 19,
    PatchFace = 20,
    Fragment2X = 21,
};

pub const MatrixMode = enum(c_int) {
    Projection = 0,
    View = 1,
    Model = 2,
    Texture = 3,
};

pub const SplineMode = enum(c_int) {
    FillFill = 0,
    OpenFill = 1,
    FillOpen = 2,
    OpenOpen = 3,
};

pub const ShadeModel = enum(c_int) {
    Flat = 0,
    Smooth = 1,
};

pub const GuLogicalOperation = enum(c_int) {
    Clear = 0,
    And = 1,
    AndReverse = 2,
    Copy = 3,
    AndInverted = 4,
    Noop = 5,
    Xor = 6,
    Or = 7,
    Nor = 8,
    Equiv = 9,
    Inverted = 10,
    OrReverse = 11,
    CopyInverted = 12,
    OrInverted = 13,
    Nand = 14,
    Set = 15,
};

pub const TextureFilter = enum(c_int) {
    Nearest = 0,
    Linear = 1,
    NearestMipmapNearest = 4,
    LinearMipmapNearest = 5,
    NearestMipmapLinear = 6,
    LinearMipmapLinear = 7,
};

pub const TextureMapMode = enum(c_int) {
    Coords = 0,
    Matrix = 1,
    EnvironmentMap = 2,
};

pub const TextureLevelMode = enum(c_int) {
    Auto = 0,
    Const = 1,
    Slope = 2,
};

pub const TextureProjectionMapMode = enum(c_int) {
    Position = 0,
    Uv = 1,
    NormalizedNormal = 2,
    Normal = 3,
};

pub const GuTexWrapMode = enum(c_int) {
    Repeat = 0,
    Clamp = 1,
};

pub const FrontFaceDirection = enum(c_int) {
    Clockwise = 0,
    CounterClockwise = 1,
};

pub const AlphaFunc = enum(c_int) {
    Never = 0,
    Always,
    Equal,
    NotEqual,
    Less,
    LessOrEqual,
    Greater,
    GreaterOrEqual,
};

pub const StencilFunc = enum(c_int) {
    Never = 0,
    Always,
    Equal,
    NotEqual,
    Less,
    LessOrEqual,
    Greater,
    GreaterOrEqual,
};

pub const ColorFunc = enum(c_int) {
    Never = 0,
    Always,
    Equal,
    NotEqual,
};

pub const DepthFunc = enum(c_int) {
    Never = 0,
    Always,
    Equal,
    NotEqual,
    Less,
    LessOrEqual,
    Greater,
    GreaterOrEqual,
};

pub const TextureEffect = enum(c_int) {
    Modulate = 0,
    Decal = 1,
    Blend = 2,
    Replace = 3,
    Add = 4,
};

pub const TextureColorComponent = enum(c_int) {
    Rgb = 0,
    Rgba = 1,
};

pub const MipmapLevel = enum(c_int) {
    None = 0,
    Level1,
    Level2,
    Level3,
    Level4,
    Level5,
    Level6,
    Level7,
};

pub const BlendOp = enum(c_int) {
    Add = 0,
    Subtract = 1,
    ReverseSubtract = 2,
    Min = 3,
    Max = 4,
    Abs = 5,
};

pub const BlendArgSrc = enum(c_int) {
    SrcColor = 0,
    OneMinusSrcColor = 1,
    SrcAlpha = 2,
    OneMinusSrcAlpha = 3,
};

pub const BlendArgDst = enum(c_int) {
    DstColor = 0,
    OneMinusDstColor = 1,
    DstAlpha = 4,
    OneMinusDstAlpha = 5,
    Fix = 10,
};

pub const StencilOperation = enum(c_int) {
    Keep = 0,
    Zero = 1,
    Replace = 2,
    Invert = 3,
    Incr = 4,
    Decr = 5,
};

pub const LightMode = enum(c_int) {
    SingleColor = 0,
    SeparateSpecularColor = 1,
};

pub const GuLightType = enum(c_int) {
    Directional = 0,
    Pointlight = 1,
    Spotlight = 2,
};

pub const GuContextType = enum(c_int) {
    Direct = 0,
    Call = 1,
    Send = 2,
};

pub const GuQueueMode = enum(c_int) {
    Tail = 0,
    Head = 1,
};

pub const GuSyncMode = enum(c_int) {
    Finish = 0,
    Signal = 1,
    Done = 2,
    List = 3,
    Send = 4,
};

pub const GuSyncBehavior = enum(c_int) {
    Wait = 0,
    NoWait = 1,
};

pub const GuCallbackId = enum(c_int) {
    Signal = 1,
    Finish = 4,
};

pub const GuSignalBehavior = enum(c_int) {
    Suspend = 1,
    Continue = 2,
};

pub const ClearBitFlags = enum(c_int) {
    ColorBuffer = 1,
    StencilBuffer = 2,
    DepthBuffer = 4,
};

pub const GuLightBitFlags = enum(c_int) {
    Ambient = 1,
    Diffuse = 2,
    AmbientDiffuse = 3,
    Specular = 4,
    DiffuseSpecular = 6,
    Unknown = 8,
};

pub const VertexTypeFlags = enum(c_int) {
    Texture8Bit = 1,
    Texture16Bit = 2,
    Texture32Bitf = 3,
    Color5650 = 4 << 2,
    Color5551 = 5 << 2,
    Color4444 = 6 << 2,
    Color8888 = 7 << 2,
    Normal8Bit = 1 << 5,
    Normal16Bit = 2 << 5,
    Normal32Bitf = 3 << 5,
    Vertex8Bit = 1 << 7,
    Vertex16Bit = 2 << 7,
    Vertex32Bitf = 3 << 7,
    Weight8Bit = 1 << 9,
    Weight16Bit = 2 << 9,
    Weight32Bitf = 3 << 9,
    Index8Bit = 1 << 11,
    Index16Bit = 2 << 11,
    Transform2D = 1 << 23,
    Transform3D = 0,
};

pub const GuSwapBuffersCallback = ?fn ([*c]?*anyopaque, [*c]?*anyopaque) callconv(.C) void;

//Extern
extern fn sceGeListEnQueue(list: ?*const anyopaque, stall: ?*anyopaque, cbid: c_int, arg: [*c]PspGeListArgs) c_int;
extern fn sceGeListEnQueueHead(list: ?*const anyopaque, stall: ?*anyopaque, cbid: c_int, arg: [*c]PspGeListArgs) c_int;
extern fn sceGeDrawSync(syncType: c_int) c_int;
extern fn sceGeListSync(qid: c_int, syncType: c_int) c_int;
extern fn sceGeListUpdateStallAddr(qid: c_int, stall: ?*anyopaque) c_int;
extern fn sceGeSetCallback(cb: *PspGeCallbackData) c_int;
extern fn sceGeEdramGetAddr() ?*anyopaque;
extern fn sceDisplaySetFrameBuf(topaddr: ?*anyopaque, bufferwidth: c_int, pixelformat: c_int, sync: c_int) c_int;
extern fn sceDisplaySetMode(mode: c_int, width: c_int, height: c_int) c_int;
extern fn sceKernelDeleteEventFlag(evid: c_int) c_int;
extern fn sceKernelCreateEventFlag(name: [*c]const u8, attr: c_int, bits: c_int, opt: [*c]SceKernelEventFlagOptParam) SceUID;
extern fn sceGeUnsetCallback(cbid: c_int) c_int;
extern fn sceKernelSetEventFlag(evid: SceUID, bits: u32) c_int;

pub const PspDisplaySetBufSync = enum(c_int) {
    Immediate = 0,
    Nextframe = 1,
};

pub const PspGeContext = extern struct {
    context: [512]c_uint,
};

pub const SceGeStack = extern struct {
    stack: [8]c_uint,
};

pub const PspGeListArgs = extern struct {
    size: c_uint,
    context: [*c]PspGeContext,
    numStacks: u32,
    stacks: [*c]SceGeStack,
};
pub const PspGeCallback = ?fn (c_int, ?*anyopaque) callconv(.C) void;
pub const PspGeCallbackData = extern struct {
    signal_func: PspGeCallback,
    signal_arg: ?*anyopaque,
    finish_func: PspGeCallback,
    finish_arg: ?*anyopaque,
};


//Internals
pub const GuCallback = ?fn (c_int) callconv(.C) void;

const GuSettings = struct {
    sig: GuCallback,
    fin: GuCallback,
    signal_history: [16]u16,
    signal_offset: i32,
    kernel_event_flag: i32,
    ge_callback_id: i32,

    swapBuffersCallback: GuSwapBuffersCallback,
    swapBuffersBehaviour: i32,
};

const GuDisplayList = struct {
    start: [*]u32,
    current: [*]u32,
    parent_context: i32,
};

const GuContext = struct {
    list: GuDisplayList,
    scissor_enable: i32,
    scissor_start: [2]i32,
    scissor_end: [2]i32,
    near_plane: i32,
    far_plane: i32,
    depth_offset: i32,
    fragment_2x: i32,
    texture_function: i32,
    texture_proj_map_mode: i32,
    texture_map_mode: i32,
    sprite_mode: [4]i32,
    clear_color: u32,
    clear_stencil: u32,
    clear_depth: u32,
    texture_mode: i32,
};

const GuDrawBuffer = struct {
    pixel_size: i32,
    frame_width: i32,
    frame_buffer: ?*anyopaque,
    disp_buffer: ?*anyopaque,
    depth_buffer: ?*anyopaque,
    depth_width: i32,
    width: i32,
    height: i32,
};

const GuLightSettings = struct {
    enable: u8, // Light enable
    typec: u8, // Light type
    xpos: u8, // X position
    ypos: u8, // Y position
    zpos: u8, // Z position
    xdir: u8, // X direction
    ydir: u8, // Y direction
    zdir: u8, // Z direction
    ambient: u8, // Ambient color
    diffuse: u8, // Diffuse color
    specular: u8, // Specular color
    constant: u8, // Constant attenuation
    linear: u8, // Linear attenuation
    quadratic: u8, // Quadratic attenuation
    exponent: u8, // Light exponent
    cutoff: u8, // Light cutoff
};

var gu_current_frame: u32 = 0;
var gu_contexts: [3]GuContext = undefined;
var ge_list_executed: [2]i32 = undefined;
var ge_edram_address: ?*anyopaque = null;
var gu_settings: GuSettings = undefined;
var gu_list: ?*GuDisplayList = null;
var gu_curr_context: i32 = 0;
var gu_init: i32 = 0;
var gu_display_on: i32 = 0;
var gu_call_mode: i32 = 0;
var gu_states: i32 = 0;
var gu_draw_buffer: GuDrawBuffer = undefined;
var gu_object_stack: [256]u32 = undefined;
var gu_object_stack_depth: i32 = 0;

var light_settings: [4]GuLightSettings = [_]GuLightSettings{
    GuLightSettings{
        .enable = 0x18,
        .typec = 0x5f,
        .xpos = 0x63,
        .ypos = 0x64,
        .zpos = 0x65,
        .xdir = 0x6f,
        .ydir = 0x70,
        .zdir = 0x71,
        .ambient = 0x8f,
        .diffuse = 0x90,
        .specular = 0x91,
        .constant = 0x7b,
        .linear = 0x7c,
        .quadratic = 0x7d,
        .exponent = 0x87,
        .cutoff = 0x8b,
    },

    GuLightSettings{
        .enable = 0x19,
        .typec = 0x60,
        .xpos = 0x66,
        .ypos = 0x67,
        .zpos = 0x68,
        .xdir = 0x72,
        .ydir = 0x73,
        .zdir = 0x74,
        .ambient = 0x92,
        .diffuse = 0x93,
        .specular = 0x94,
        .constant = 0x7e,
        .linear = 0x7f,
        .quadratic = 0x80,
        .exponent = 0x88,
        .cutoff = 0x8c,
    },

    GuLightSettings{
        .enable = 0x1a,
        .typec = 0x61,
        .xpos = 0x69,
        .ypos = 0x6a,
        .zpos = 0x6b,
        .xdir = 0x75,
        .ydir = 0x76,
        .zdir = 0x77,
        .ambient = 0x8f,
        .diffuse = 0x90,
        .specular = 0x91,
        .constant = 0x81,
        .linear = 0x82,
        .quadratic = 0x83,
        .exponent = 0x89,
        .cutoff = 0x8d,
    },

    GuLightSettings{
        .enable = 0x1b,
        .typec = 0x62,
        .xpos = 0x6c,
        .ypos = 0x6d,
        .zpos = 0x6e,
        .xdir = 0x78,
        .ydir = 0x79,
        .zdir = 0x7a,
        .ambient = 0x98,
        .diffuse = 0x99,
        .specular = 0x9a,
        .constant = 0x84,
        .linear = 0x85,
        .quadratic = 0x86,
        .exponent = 0x8a,
        .cutoff = 0x8e,
    },
};

export fn callbackSig(id: c_int, arg: ?*anyopaque) void {
    @setRuntimeSafety(false);
    var settings: ?*GuSettings = @intToPtr(?*GuSettings, @ptrToInt(arg));
    settings.?.signal_history[@intCast(usize, (settings.?.signal_offset)) & 15] = @intCast(u16, id) & 0xffff;
    settings.?.signal_offset += 1;

    if (settings.?.sig != null)
        settings.?.sig.?(id & 0xffff);

    _ = sceKernelSetEventFlag(settings.?.kernel_event_flag, 1);
}

export fn callbackFin(id: c_int, arg: ?*anyopaque) void {
    @setRuntimeSafety(false);
    var settings: ?*GuSettings = @intToPtr(?*GuSettings, @ptrToInt(arg));
    if (settings.?.fin != null) {
        settings.?.fin.?(id & 0xffff);
    }
}

export fn resetValues() void {
    @setRuntimeSafety(false);
    var i: usize = 0;

    gu_init = 0;

    gu_states = 0;
    gu_current_frame = 0;
    gu_object_stack_depth = 0;

    gu_display_on = 0;
    gu_call_mode = 0;

    gu_draw_buffer.pixel_size = 1;
    gu_draw_buffer.frame_width = 0;
    gu_draw_buffer.frame_buffer = null;
    gu_draw_buffer.disp_buffer = null;
    gu_draw_buffer.depth_buffer = null;
    gu_draw_buffer.depth_width = 0;
    gu_draw_buffer.width = 480;
    gu_draw_buffer.height = 272;

    while (i < 3) : (i += 1) {
        gu_contexts[i].scissor_enable = 0;
        gu_contexts[i].scissor_start[0] = 0;
        gu_contexts[i].scissor_start[1] = 0;
        gu_contexts[i].scissor_end[0] = 0;
        gu_contexts[i].scissor_end[1] = 0;
        gu_contexts[i].near_plane = 0;
        gu_contexts[i].far_plane = 1;
        gu_contexts[i].depth_offset = 0;
        gu_contexts[i].fragment_2x = 0;
        gu_contexts[i].texture_function = 0;
        gu_contexts[i].texture_proj_map_mode = 0;
        gu_contexts[i].texture_map_mode = 0;
        gu_contexts[i].sprite_mode[0] = 0;
        gu_contexts[i].sprite_mode[1] = 0;
        gu_contexts[i].sprite_mode[2] = 0;
        gu_contexts[i].sprite_mode[3] = 0;
        gu_contexts[i].clear_color = 0;
        gu_contexts[i].clear_stencil = 0;
        gu_contexts[i].clear_depth = 0xffff;
        gu_contexts[i].texture_mode = 0;
    }

    gu_settings.sig = null;
    gu_settings.fin = null;
}

export fn sendCommandi(cmd: c_int, argument: c_int) void {
    @setRuntimeSafety(false);
    gu_list.?.current[0] = (@intCast(u32, cmd) << 24) | (@intCast(u32, argument) & 0xffffff);
    gu_list.?.current += 1;
}

export fn sendCommandiStall(cmd: c_int, argument: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(cmd, argument);
    if (gu_object_stack_depth == 0 and gu_curr_context == 0) {
        _ = sceGeListUpdateStallAddr(ge_list_executed[0], @ptrCast(*anyopaque, gu_list.?.current));
    }
}

export fn sendCommandf(cmd: c_int, argument: f32) void {
    @setRuntimeSafety(false);
    sendCommandi(cmd, @bitCast(c_int, argument) >> 8);
}

//GU IMPLEMENTATION

export fn sceGuAlphaFunc(func: c_int, value: c_int, mask: c_int) void {
    @setRuntimeSafety(false);
    var arg: c_int = (func) | ((value & 0xff) << 8) | ((mask & 0xff) << 16);
    sendCommandi(219, arg);
}
export fn sceGuAmbient(col: u32) void {
    @setRuntimeSafety(false);
    sendCommandi(92, @bitCast(c_int, (col & 0xffffff)));
    sendCommandi(93, @bitCast(c_int, (col >> 24)));
}
export fn sceGuAmbientColor(col: u32) void {
    @setRuntimeSafety(false);
    sendCommandi(85, @intCast(c_int, col) & 0xffffff);
    sendCommandi(88, @intCast(c_int, col) >> 24);
}

export fn sceGuBlendFunc(bop: c_int, sc: c_int, dst: c_int, srcfix: c_int, destfix: c_int) void {
    var op: c_int = (bop);

    var src: c_int = (sc);
    var dest: c_int = (dst);

    @setRuntimeSafety(false);
    sendCommandi(223, src | (dest << 4) | (op << 8));
    sendCommandi(224, srcfix & 0xffffff);
    sendCommandi(225, destfix & 0xffffff);
}

export fn sceGuBreak(a0: c_int) void {
    @setRuntimeSafety(false);
    _ = a0;
    //Does nothing or is broken?
}

export fn sceGuContinue() void {
    @setRuntimeSafety(false);
    //Does nothing or is broken?
}

export fn sceGuCallList(list: ?*const anyopaque) void {
    @setRuntimeSafety(false);
    var list_addr: c_int = @intCast(c_int, @ptrToInt(list));

    if (gu_call_mode == 1) {
        sendCommandi(14, (list_addr >> 16) | 0x110000);
        sendCommandi(12, list_addr & 0xffff);
        sendCommandiStall(0, 0);
    } else {
        sendCommandi(16, (list_addr >> 8) & 0xf0000);
        sendCommandiStall(10, list_addr & 0xffffff);
    }
}

export fn sceGuCallMode(mode: c_int) void {
    @setRuntimeSafety(false);
    gu_call_mode = mode;
}

export fn sceGuCheckList() c_int {
    return @intCast(c_int, (@ptrToInt(gu_list.?.current) - @ptrToInt(gu_list.?.start)));
}

export fn sceGuClearColor(col: c_uint) void {
    @setRuntimeSafety(false);
    gu_contexts[@intCast(usize, gu_curr_context)].clear_color = col;
}

export fn sceGuClearDepth(depth: c_uint) void {
    @setRuntimeSafety(false);
    gu_contexts[@intCast(usize, gu_curr_context)].clear_depth = depth;
}

export fn sceGuClearStencil(stencil: c_uint) void {
    @setRuntimeSafety(false);
    gu_contexts[@intCast(usize, gu_curr_context)].clear_stencil = stencil;
}

export fn sceGuClutLoad(num_blocks: c_int, cbp: ?*const anyopaque) void {
    @setRuntimeSafety(false);
    var a = @intCast(c_int, @ptrToInt(cbp));
    sendCommandi(176, (a) & 0xffffff);
    sendCommandi(177, ((a) >> 8) & 0xf0000);
    sendCommandi(196, num_blocks);
}

export fn sceGuClutMode(cpsm: c_int, shift: c_int, mask: c_int, a3: c_int) void {
    @setRuntimeSafety(false);
    var argument: c_int = (cpsm) | (shift << 2) | (mask << 8) | (a3 << 16);
    sendCommandi(197, argument);
}

export fn sceGuColor(col: c_int) void {
    @setRuntimeSafety(false);
    sceGuMaterial(7, col);
}

export fn sceGuMaterial(mode: c_int, col: c_int) void {
    @setRuntimeSafety(false);
    if (mode & 0x01 != 0) {
        sendCommandi(85, col & 0xffffff);
        sendCommandi(88, col >> 24);
    }

    if (mode & 0x02 != 0)
        sendCommandi(86, col & 0xffffff);

    if (mode & 0x04 != 0)
        sendCommandi(87, col & 0xffffff);
}

export fn sceGuColorFunc(func: c_int, color: c_int, mask: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(216, (func) & 0x03);
    sendCommandi(217, color & 0xffffff);
    sendCommandi(218, mask);
}

export fn sceGuColorMaterial(components: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(83, components);
}

export fn sceGuCopyImage(psm: c_int, sx: c_int, sy: c_int, width: c_int, height: c_int, srcw: c_int, src: ?*anyopaque, dx: c_int, dy: c_int, destw: c_int, dest: ?*anyopaque) void {
    @setRuntimeSafety(false);
    var sr = @intCast(c_uint, @ptrToInt(src));
    var ds = @intCast(c_uint, @ptrToInt(dest));
    sendCommandi(178, @intCast(c_int, (sr) & 0xffffff));
    sendCommandi(179, @intCast(c_int, (((sr) & 0xff000000) >> 8)) | srcw);
    sendCommandi(235, (sy << 10) | sx);
    sendCommandi(180, @intCast(c_int, (ds) & 0xffffff));
    sendCommandi(181, @intCast(c_int, (((ds) & 0xff000000) >> 8)) | destw);
    sendCommandi(236, (dy << 10) | dx);
    sendCommandi(238, ((height - 1) << 10) | (width - 1));
    if ((psm) ^ 0x03 != 0) {
        sendCommandi(234, 0);
    } else {
        sendCommandi(234, 1);
    }
}

export fn sceGuDepthBuffer(zbp: ?*anyopaque, zbw: c_int) void {
    @setRuntimeSafety(false);
    gu_draw_buffer.depth_buffer = zbp;

    if (gu_draw_buffer.depth_width != 0 or (gu_draw_buffer.depth_width != zbw))
        gu_draw_buffer.depth_width = zbw;

    sendCommandi(158, @intCast(c_int, (@ptrToInt(zbp))) & 0xffffff);
    sendCommandi(159, @intCast(c_int, ((@intCast(c_uint, (@ptrToInt(zbp))) & 0xff000000) >> 8)) | zbw);
}

export fn sceGuDepthFunc(function: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(222, (function));
}

export fn sceGuDepthMask(mask: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(231, mask);
}

export fn sceGuDepthOffset(offset: c_uint) void {
    @setRuntimeSafety(false);
    gu_contexts[@intCast(usize, gu_curr_context)].depth_offset = @intCast(i32, offset);
    sceGuDepthRange(gu_contexts[@intCast(usize, gu_curr_context)].near_plane, gu_contexts[@intCast(usize, gu_curr_context)].far_plane);
}

export fn sceGuDepthRange(near: c_int, far: c_int) void {
    @setRuntimeSafety(false);
    var max = near + far;
    var val = ((max >> 31) + max);
    var z: f32 = @bitCast(f32, (val >> 1));

    gu_contexts[@intCast(usize, gu_curr_context)].near_plane = near;
    gu_contexts[@intCast(usize, gu_curr_context)].far_plane = far;

    sendCommandf(68, z - (@bitCast(f32, near)));
    sendCommandf(71, z + (@bitCast(f32, gu_contexts[@intCast(usize, gu_curr_context)].depth_offset)));

    if (near > far) {
        sendCommandi(214, far);
        sendCommandi(215, near);
    } else {
        sendCommandi(214, near);
        sendCommandi(215, far);
    }
}

export fn sceGuDisable(state: c_int) void {
    @setRuntimeSafety(false);
    switch (@intToEnum(GuState,state)) {
        .AlphaTest => {
            sendCommandi(34, 0);
        },
        .DepthTest => {
            sendCommandi(35, 0);
        },
        .ScissorTest => {
            gu_contexts[@intCast(usize, gu_curr_context)].scissor_enable = 0;
            sendCommandi(212, 0);
            sendCommandi(213, ((gu_draw_buffer.height - 1) << 10) | (gu_draw_buffer.width - 1));
        },
        .StencilTest => {
            sendCommandi(36, 0);
        },
        .Blend => {
            sendCommandi(33, 0);
        },
        .CullFace => {
            sendCommandi(29, 0);
        },
        .Dither => {
            sendCommandi(32, 0);
        },
        .Fog => {
            sendCommandi(31, 0);
        },
        .ClipPlanes => {
            sendCommandi(28, 0);
        },
        .Texture2D => {
            sendCommandi(30, 0);
        },
        .Lighting => {
            sendCommandi(23, 0);
        },
        .Light0 => {
            sendCommandi(24, 0);
        },
        .Light1 => {
            sendCommandi(25, 0);
        },
        .Light2 => {
            sendCommandi(26, 0);
        },
        .Light3 => {
            sendCommandi(27, 0);
        },
        .LineSmooth => {
            sendCommandi(37, 0);
        },
        .PatchCullFace => {
            sendCommandi(38, 0);
        },
        .ColorTest => {
            sendCommandi(39, 0);
        },
        .ColorLogicOp => {
            sendCommandi(40, 0);
        },
        .FaceNormalReverse => {
            sendCommandi(81, 0);
        },
        .PatchFace => {
            sendCommandi(56, 0);
        },
        .Fragment2X => {
            gu_contexts[@intCast(usize, gu_curr_context)].fragment_2x = 0;
            sendCommandi(201, gu_contexts[@intCast(usize, gu_curr_context)].texture_function);
        },
    }

    var one: u32 = 1;

    if ((state) < 22)
        gu_states &= @intCast(i32, ~(one << @intCast(u5, (state))));
}

fn drawRegion(x: c_int, y: c_int, width: c_int, height: c_int) void {
    sendCommandi(21, (y << 10) | x);
    sendCommandi(22, (((y + height) - 1) << 10) | ((x + width) - 1));
}

export fn sceGuDispBuffer(width: c_int, height: c_int, dispbp: ?*anyopaque, dispbw: c_int) void {
    @setRuntimeSafety(false);
    gu_draw_buffer.width = width;
    gu_draw_buffer.height = height;
    gu_draw_buffer.disp_buffer = dispbp;

    if ((gu_draw_buffer.frame_width != 0) or (gu_draw_buffer.frame_width != dispbw))
        gu_draw_buffer.frame_width = dispbw;

    drawRegion(0, 0, gu_draw_buffer.width, gu_draw_buffer.height);
    _ = sceDisplaySetMode(0, gu_draw_buffer.width, gu_draw_buffer.height);

    if (gu_display_on != 0)
        _ = sceDisplaySetFrameBuf(@intToPtr(*anyopaque, @ptrToInt(ge_edram_address) + @ptrToInt(gu_draw_buffer.disp_buffer)), dispbw, gu_draw_buffer.pixel_size, 1);
}

export fn sceGuDisplay(state: bool) void {
    if (state) {
        _ = sceDisplaySetFrameBuf(@intToPtr(*anyopaque, @ptrToInt(ge_edram_address) + @ptrToInt(gu_draw_buffer.disp_buffer)), gu_draw_buffer.frame_width, gu_draw_buffer.pixel_size, 1);
    } else {
        _ = sceDisplaySetFrameBuf(null, 0, 0, (1));
    }

    gu_display_on = @boolToInt(state);
}

export fn sceGuDrawArray(prim: c_int, vtype: c_int, count: c_int, indices: ?*const anyopaque, vertices: ?*const anyopaque) void {
    @setRuntimeSafety(false);
    if (vtype != 0)
        sendCommandi(18, vtype);

    if (indices != null) {
        sendCommandi(16, @intCast(c_int, (@ptrToInt(indices) >> 8)) & 0xf0000);
        sendCommandi(2, @intCast(c_int, @ptrToInt(indices)) & 0xffffff);
    }

    if (vertices != null) {
        sendCommandi(16, @intCast(c_int, (@ptrToInt(vertices) >> 8)) & 0xf0000);
        sendCommandi(1, @intCast(c_int, @ptrToInt(vertices)) & 0xffffff);
    }
    sendCommandiStall(4, ((prim) << 16) | count);
}

export fn sceGuDrawArrayN(primitive_type: c_int, vertex_type: c_int, count: c_int, a3: c_int, indices: ?*const anyopaque, vertices: ?*const anyopaque) void {
    @setRuntimeSafety(false);
    if (vertex_type != 0)
        sendCommandi(18, vertex_type);

    if (indices != null) {
        sendCommandi(16, @intCast(c_int, (@ptrToInt(indices) >> 8)) & 0xf0000);
        sendCommandi(2, @intCast(c_int, @ptrToInt(indices)) & 0xffffff);
    }

    if (vertices != null) {
        sendCommandi(16, @intCast(c_int, (@ptrToInt(vertices) >> 8)) & 0xf0000);
        sendCommandi(1, @intCast(c_int, @ptrToInt(vertices)) & 0xffffff);
    }

    if (a3 > 0) {
        var i: usize = @intCast(usize, a3) - 1;
        while (i >= 0) : (i -= 1) {
            sendCommandi(4, ((primitive_type) << 16) | count);
        }
        sendCommandiStall(4, ((primitive_type) << 16) | count);
    }
}

export fn sceGuDrawBezier(vtype: c_int, ucount: c_int, vcount: c_int, indices: ?*const anyopaque, vertices: ?*const anyopaque) void {
    @setRuntimeSafety(false);
    if (vtype != 0)
        sendCommandi(18, vtype);

    if (indices != null) {
        sendCommandi(16, @intCast(c_int, (@ptrToInt(indices) >> 8)) & 0xf0000);
        sendCommandi(2, @intCast(c_int, @ptrToInt(indices)) & 0xffffff);
    }

    if (vertices != null) {
        sendCommandi(16, @intCast(c_int, (@ptrToInt(vertices) >> 8)) & 0xf0000);
        sendCommandi(1, @intCast(c_int, @ptrToInt(vertices)) & 0xffffff);
    }

    sendCommandi(5, (vcount << 8) | ucount);
}

export fn sceGuDrawBuffer(pix: c_int, fbp: ?*anyopaque, fbw: c_int) void {
    @setRuntimeSafety(false);
    var psm = (pix);

    gu_draw_buffer.pixel_size = psm;
    gu_draw_buffer.frame_width = fbw;
    gu_draw_buffer.frame_buffer = fbp;

    if (gu_draw_buffer.depth_buffer != null and gu_draw_buffer.height != 0)
        gu_draw_buffer.depth_buffer = @intToPtr(*anyopaque, (@ptrToInt(fbp) + @intCast(usize, ((gu_draw_buffer.height * fbw) << 2))));

    if (gu_draw_buffer.depth_width != 0)
        gu_draw_buffer.depth_width = fbw;

    sendCommandi(210, psm);
    sendCommandi(156, @intCast(c_int, @intCast(c_uint, @ptrToInt(gu_draw_buffer.frame_buffer)) & 0xffffff));
    sendCommandi(157, @intCast(c_int, ((@intCast(c_uint, @ptrToInt(gu_draw_buffer.frame_buffer)) & 0xff000000) >> 8)) | gu_draw_buffer.frame_width);
    sendCommandi(158, @intCast(c_int, @intCast(c_uint, @ptrToInt(gu_draw_buffer.depth_buffer)) & 0xffffff));
    sendCommandi(159, @intCast(c_int, ((@intCast(c_uint, @ptrToInt(gu_draw_buffer.depth_buffer)) & 0xff000000) >> 8)) | gu_draw_buffer.depth_width);
}

export fn sceGuDrawBufferList(psm: c_int, fbp: ?*anyopaque, fbw: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(210, (psm));
    sendCommandi(156, @intCast(c_int, @ptrToInt(fbp)) & 0xffffff);
    sendCommandi(157, @intCast(c_int, (@intCast(c_uint, @ptrToInt(fbp)) & 0xff000000) >> 8) | fbw);
}

export fn sceGuDrawSpline(vtype: c_int, ucount: c_int, vcount: c_int, uedge: c_int, vedge: c_int, indices: ?*const anyopaque, vertices: ?*const anyopaque) void {
    @setRuntimeSafety(false);
    if (vtype != 0)
        sendCommandi(18, vtype);

    if (indices != null) {
        sendCommandi(16, @intCast(c_int, (@ptrToInt(indices) >> 8)) & 0xf0000);
        sendCommandi(2, @intCast(c_int, @ptrToInt(indices)) & 0xffffff);
    }

    if (vertices != null) {
        sendCommandi(16, @intCast(c_int, (@ptrToInt(vertices) >> 8)) & 0xf0000);
        sendCommandi(1, @intCast(c_int, @ptrToInt(vertices)) & 0xffffff);
    }

    sendCommandi(6, (vedge << 18) | (uedge << 16) | (vcount << 8) | ucount);
}

export fn sceGuEnable(state: c_int) void {
    @setRuntimeSafety(false);
    switch (@intToEnum(GuState,state)) {
        .AlphaTest => {
            sendCommandi(34, 1);
        },
        .DepthTest => {
            sendCommandi(35, 1);
        },
        .ScissorTest => {
            gu_contexts[@intCast(usize, gu_curr_context)].scissor_enable = 1;
            sendCommandi(212, (gu_contexts[@intCast(usize, gu_curr_context)].scissor_start[1] << 10) | gu_contexts[@intCast(usize, gu_curr_context)].scissor_start[0]);
            sendCommandi(213, (gu_contexts[@intCast(usize, gu_curr_context)].scissor_end[1] << 10) | gu_contexts[@intCast(usize, gu_curr_context)].scissor_end[0]);
        },
        .StencilTest => {
            sendCommandi(36, 1);
        },
        .Blend => {
            sendCommandi(33, 1);
        },
        .CullFace => {
            sendCommandi(29, 1);
        },
        .Dither => {
            sendCommandi(32, 1);
        },
        .Fog => {
            sendCommandi(31, 1);
        },
        .ClipPlanes => {
            sendCommandi(28, 1);
        },
        .Texture2D => {
            sendCommandi(30, 1);
        },
        .Lighting => {
            sendCommandi(23, 1);
        },
        .Light0 => {
            sendCommandi(24, 1);
        },
        .Light1 => {
            sendCommandi(25, 1);
        },
        .Light2 => {
            sendCommandi(26, 1);
        },
        .Light3 => {
            sendCommandi(27, 1);
        },
        .LineSmooth => {
            sendCommandi(37, 1);
        },
        .PatchCullFace => {
            sendCommandi(38, 1);
        },
        .ColorTest => {
            sendCommandi(39, 1);
        },
        .ColorLogicOp => {
            sendCommandi(40, 1);
        },
        .FaceNormalReverse => {
            sendCommandi(81, 1);
        },
        .PatchFace => {
            sendCommandi(56, 1);
        },
        .Fragment2X => {
            gu_contexts[@intCast(usize, gu_curr_context)].fragment_2x = 0x10000;
            sendCommandi(201, 0x10000 | gu_contexts[@intCast(usize, gu_curr_context)].texture_function);
        },
    }

    var one: u32 = 1;
    if (state < 22)
        gu_states |= @intCast(i32, (one << @intCast(u5, state)));
}

export fn sceGuEndObject() void {
    @setRuntimeSafety(false);

    var current: [*]u32 = gu_list.?.current;
    gu_list.?.current = @ptrCast([*]u32, &gu_object_stack[@intCast(usize, gu_object_stack_depth) - 1]);

    sendCommandi(16, @intCast(c_int, (@ptrToInt(current) >> 8)) & 0xf0000);
    sendCommandi(9, @intCast(c_int, @ptrToInt(current)) & 0xffffff);

    gu_list.?.current = current;
    gu_object_stack_depth -= 1;
}

export fn sceGuBeginObject(vtype: c_int, count: c_int, indices: ?*const anyopaque, vertices: ?*const anyopaque) void {
    @setRuntimeSafety(false);
    if (vtype != 0)
        sendCommandi(18, vtype);

    if (indices != null) {
        sendCommandi(16, @intCast(c_int, (@ptrToInt(indices) >> 8)) & 0xf0000);
        sendCommandi(2, @intCast(c_int, @ptrToInt(indices)) & 0xffffff);
    }

    if (vertices != null) {
        sendCommandi(16, @intCast(c_int, (@ptrToInt(vertices) >> 8)) & 0xf0000);
        sendCommandi(1, @intCast(c_int, @ptrToInt(vertices)) & 0xffffff);
    }
    sendCommandi(7, count);

    gu_object_stack[@intCast(usize, gu_object_stack_depth)] = @intCast(u32, @ptrToInt(gu_list.?.current));
    gu_object_stack_depth += 1;

    sendCommandi(16, 0);
    sendCommandi(9, 0);
}

export fn sceGuFinish() c_int {
    switch (@intToEnum(GuContextType, gu_curr_context)) {
        .Direct, .Send => {
            sendCommandi(15, 0);
            sendCommandiStall(12, 0);
        },

        .Call => {
            if (gu_call_mode == 1) {
                sendCommandi(14, 0x120000);
                sendCommandi(12, 0);
                sendCommandiStall(0, 0);
            } else {
                sendCommandi(11, 0);
            }
        },
    }

    var size: u32 = @ptrToInt(gu_list.?.current) - @ptrToInt(gu_list.?.start);

    // go to parent list
    gu_curr_context = gu_list.?.parent_context;
    gu_list = &gu_contexts[@intCast(usize, gu_curr_context)].list;
    return @intCast(c_int, size);
}

export fn guFinish() void {
    _ = sceGuFinish();
}

export fn sceGuFinishId(id: c_int) c_int {
    switch (@intToEnum(GuContextType, gu_curr_context)) {
        .Direct, .Send => {
            sendCommandi(15, id & 0xffff);
            sendCommandiStall(12, 0);
        },

        .Call => {
            if (gu_call_mode == 1) {
                sendCommandi(14, 0x120000);
                sendCommandi(12, 0);
                sendCommandiStall(0, 0);
            } else {
                sendCommandi(11, 0);
            }
        },
    }

    var size: u32 = @ptrToInt(gu_list.?.current) - @ptrToInt(gu_list.?.start);

    // go to parent list
    gu_curr_context = gu_list.?.parent_context;
    gu_list = &gu_contexts[@intCast(usize, gu_curr_context)].list;
    return @intCast(c_int, size);
}

export fn sceGuFog(near: f32, far: f32, col: c_uint) void {
    @setRuntimeSafety(false);
    var distance: f32 = far - near;
    if (distance > 0)
        distance = 1.0 / distance;

    sendCommandi(207, @intCast(c_int, col & 0xffffff));
    sendCommandf(205, far);
    sendCommandf(206, distance);
}

export fn sceGuFrontFace(order: FrontFaceDirection) void {
    @setRuntimeSafety(false);
    if (order != FrontFaceDirection.Clockwise) {
        sendCommandi(155, 0);
    } else {
        sendCommandi(155, 1);
    }
}

export fn sceGuGetAllStatus() c_int {
    return gu_states;
}

export fn sceGuGetStatus(state: c_int) c_int {
    if (state < 22)
        return (gu_states >> @intCast(u5, state)) & 1;
    return 0;
}

export fn sceGuLight(light: c_int, typec: c_int, components: c_int, position: [*c]const ScePspFVector3) void {
    @setRuntimeSafety(false);

    var lpos : usize = @intCast(usize, light);

    sendCommandf(light_settings[lpos].xpos, position.*.x);
    sendCommandf(light_settings[lpos].ypos, position.*.y);
    sendCommandf(light_settings[lpos].zpos, position.*.z);

    var kind: c_int = 2;
    if ((components) != 8) {
        if (((components) ^ 6) < 1) {
            kind = 1;
        } else {
            kind = 0;
        }
    }

    sendCommandi(light_settings[lpos].typec, ((typec & 0x03) << 8) | kind);
}

export fn sceGuLightAtt(light: usize, atten0: f32, atten1: f32, atten2: f32) void {
    @setRuntimeSafety(false);

    var lpos : usize = @intCast(usize, light);
    sendCommandf(light_settings[lpos].constant, atten0);
    sendCommandf(light_settings[lpos].linear, atten1);
    sendCommandf(light_settings[lpos].quadratic, atten2);
}

export fn sceGuLightColor(light: usize, component: c_int, col: c_int) void {
    @setRuntimeSafety(false);
    switch (@intToEnum(GuLightBitFlags, component)) {
        .Ambient => {
            sendCommandi(light_settings[light].ambient, col & 0xffffff);
        },
        .Diffuse => {
            sendCommandi(light_settings[light].diffuse, col & 0xffffff);
        },
        .AmbientDiffuse => {
            sendCommandi(light_settings[light].ambient, col & 0xffffff);
            sendCommandi(light_settings[light].diffuse, col & 0xffffff);
        },
        .Specular => {
            sendCommandi(light_settings[light].specular, col & 0xffffff);
        },
        .DiffuseSpecular => {
            sendCommandi(light_settings[light].diffuse, col & 0xffffff);
            sendCommandi(light_settings[light].specular, col & 0xffffff);
        },
        else => {},
    }
}

export fn sceGuLightMode(mode: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(94, mode);
}

export fn sceGuLightSpot(light: usize, direction: [*c]const ScePspFVector3, exponent: f32, cutoff: f32) void {
    @setRuntimeSafety(false);
    sendCommandf(light_settings[light].exponent, exponent);
    sendCommandf(light_settings[light].cutoff, cutoff);
    sendCommandf(light_settings[light].xdir, direction.*.x);
    sendCommandf(light_settings[light].ydir, direction.*.y);
    sendCommandf(light_settings[light].zdir, direction.*.z);
}

export fn sceGuLogicalOp(op: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(230, op & 0x0f);
}

export fn sceGuModelColor(emissive: c_int, ambient: c_int, diffuse: c_int, specular: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(84, emissive & 0xffffff);
    sendCommandi(86, diffuse & 0xffffff);
    sendCommandi(85, ambient & 0xffffff);
    sendCommandi(87, specular & 0xffffff);
}

export fn sceGuMorphWeight(index: c_int, weight: f32) void {
    @setRuntimeSafety(false);
    sendCommandf(44 + index, weight);
}

export fn sceGuOffset(x: c_int, y: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(76, x << 4);
    sendCommandi(77, y << 4);
}

export fn sceGuPatchDivide(ulevel: c_int, vlevel: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(54, (vlevel << 8) | ulevel);
}

export fn sceGuPatchFrontFace(a0: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(56, a0);
}

export fn sceGuPatchPrim(prim: GuPrimitive) void {
    @setRuntimeSafety(false);
    switch (prim) {
        .Points => {
            sendCommandi(55, 2);
        },
        .LineStrip => {
            sendCommandi(55, 1);
        },
        .TriangleStrip => {
            sendCommandi(55, 0);
        },
        else => {},
    }
}

export fn sceGuPixelMask(mask: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(232, mask & 0xffffff);
    sendCommandi(233, mask >> 24);
}

export fn sceGuScissor(x: c_int, y: c_int, w: c_int, h: c_int) void {
    @setRuntimeSafety(false);
    gu_contexts[@intCast(usize, gu_curr_context)].scissor_start[0] = x;
    gu_contexts[@intCast(usize, gu_curr_context)].scissor_start[1] = y;
    gu_contexts[@intCast(usize, gu_curr_context)].scissor_end[0] = w - 1;
    gu_contexts[@intCast(usize, gu_curr_context)].scissor_end[1] = h - 1;

    if (gu_contexts[@intCast(usize, gu_curr_context)].scissor_enable != 0) {
        sendCommandi(212, (gu_contexts[@intCast(usize, gu_curr_context)].scissor_start[1] << 10) | gu_contexts[@intCast(usize, gu_curr_context)].scissor_start[0]);
        sendCommandi(213, (gu_contexts[@intCast(usize, gu_curr_context)].scissor_end[1] << 10) | gu_contexts[@intCast(usize, gu_curr_context)].scissor_end[0]);
    }
}

export fn sceGuSendCommandf(cmd: c_int, argument: f32) void {
    @setRuntimeSafety(false);
    sendCommandf(cmd, argument);
}

export fn sceGuSendCommandi(cmd: c_int, argument: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(cmd, argument);
}

export fn sceGuSendList(mode: c_int, list: ?*const anyopaque, context: [*c]PspGeContext) void {
    @setRuntimeSafety(false);
    gu_settings.signal_offset = 0;
    var args: PspGeListArgs = undefined;
    args.size = 8;
    args.context = context;

    var list_id: i32 = 0;
    var callback = gu_settings.ge_callback_id;

    switch (@intToEnum(GuQueueMode, mode)) {
        .Head => {
            list_id = sceGeListEnQueueHead(list, null, callback, &args);
        },
        .Tail => {
            list_id = sceGeListEnQueue(list, null, callback, &args);
        },
    }

    ge_list_executed[1] = list_id;
}

export fn sceGuSetAllStatus(status: c_int) void {
    @setRuntimeSafety(false);
    var i: c_int = 0;
    while (i < 22) : (i += 1) {
        if ((status >> @intCast(u5, i)) & 1 != 0) {
            sceGuEnable(i);
        } else {
            sceGuDisable(i);
        }
    }
}

export fn sceGuSetCallback(signal: c_int, callback: ?fn (c_int) callconv(.C) void) GuCallback {
    var old_callback: GuCallback = undefined;

    switch (@intToEnum(GuCallbackId, signal)) {
        .Signal => {
            old_callback = gu_settings.sig;
            gu_settings.sig = callback;
        },

        .Finish => {
            old_callback = gu_settings.fin;
            gu_settings.fin = callback;
        },
    }

    return old_callback;
}

export fn sceGuSetDither(matrix: *const ScePspIMatrix4) void {
    @setRuntimeSafety(false);
    sendCommandi(226, (matrix.x.x & 0x0f) | ((matrix.x.y & 0x0f) << 4) | ((matrix.x.z & 0x0f) << 8) | ((matrix.x.w & 0x0f) << 12));
    sendCommandi(227, (matrix.y.x & 0x0f) | ((matrix.y.y & 0x0f) << 4) | ((matrix.y.z & 0x0f) << 8) | ((matrix.y.w & 0x0f) << 12));
    sendCommandi(228, (matrix.z.x & 0x0f) | ((matrix.z.y & 0x0f) << 4) | ((matrix.z.z & 0x0f) << 8) | ((matrix.z.w & 0x0f) << 12));
    sendCommandi(229, (matrix.w.x & 0x0f) | ((matrix.w.y & 0x0f) << 4) | ((matrix.w.z & 0x0f) << 8) | ((matrix.w.w & 0x0f) << 12));
}

export fn sceGuSetMatrix(typec: c_int, matrix: [*c]ScePspFMatrix4) void {
    @setRuntimeSafety(false);

    const fmatrix: [*]f32 = @ptrCast([*]f32, matrix);

    switch (typec) {
        0 => {
            var i: usize = 0;
            sendCommandf(62, 0);
            while (i < 16) : (i += 1) {
                sendCommandf(63, fmatrix[i]);
            }
        },

        1 => {
            var i: usize = 0;
            sendCommandf(60, 0);

            // 4*4 -> 3*4 - view matrix?
            while (i < 4) : (i += 1) {
                var j: usize = 0;
                while (j < 3) : (j += 1) {
                    sendCommandf(61, fmatrix[j + i * 4]);
                }
            }
        },

        2 => {
            var i: usize = 0;
            sendCommandf(58, 0);

            // 4*4 -> 3*4 - view matrix?
            while (i < 4) : (i += 1) {
                var j: usize = 0;
                while (j < 3) : (j += 1) {
                    sendCommandf(59, fmatrix[j + i * 4]);
                }
            }
        },

        3 => {
            var i: usize = 0;
            sendCommandf(64, 0);

            // 4*4 -> 3*4 - view matrix?
            while (i < 4) : (i += 1) {
                var j: usize = 0;
                while (j < 3) : (j += 1) {
                    sendCommandf(65, fmatrix[j + i * 4]);
                }
            }
        },

        else => {},
    }
}

export fn sceGuSetStatus(state: c_int, status: bool) void {
    @setRuntimeSafety(false);
    if (status) {
        sceGuEnable(state);
    } else {
        sceGuDisable(state);
    }
}

export fn sceGuShadeModel(mode: ShadeModel) void {
    @setRuntimeSafety(false);
    if (mode == ShadeModel.Smooth) {
        sendCommandi(80, 1);
    } else {
        sendCommandi(80, 0);
    }
}

export fn sceGuSignal(signal: c_int, behavior: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(14, ((signal & 0xff) << 16) | (behavior & 0xffff));
    sendCommandi(12, 0);

    if (signal == 3) {
        sendCommandi(15, 0);
        sendCommandi(12, 0);
    }

    sendCommandiStall(0, 0);
}

export fn sceGuSpecular(power: f32) void {
    @setRuntimeSafety(false);
    sendCommandf(91, power);
}

export fn sceGuStencilFunc(func: c_int, ref: c_int, mask: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(220, (func) | ((ref & 0xff) << 8) | ((mask & 0xff) << 16));
}

export fn sceGuStencilOp(fail: c_int, zfail: c_int, zpass: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(221, (fail) | ((zfail) << 8) | ((zpass) << 16));
}

export fn sceGuSwapBuffers() ?*anyopaque {
    @setRuntimeSafety(false);
    if (gu_settings.swapBuffersCallback != null) {
        gu_settings.swapBuffersCallback.?(&gu_draw_buffer.disp_buffer, &gu_draw_buffer.frame_buffer);
    } else {
        var temp = gu_draw_buffer.disp_buffer;
        gu_draw_buffer.disp_buffer = gu_draw_buffer.frame_buffer;
        gu_draw_buffer.frame_buffer = temp;
    }

    if (gu_display_on != 0) {
        _ = sceDisplaySetFrameBuf(@intToPtr(*anyopaque, @ptrToInt(ge_edram_address) + @ptrToInt(gu_draw_buffer.disp_buffer)), gu_draw_buffer.frame_width, gu_draw_buffer.pixel_size, gu_settings.swapBuffersBehaviour);
    }

    gu_current_frame ^= 1;
    return gu_draw_buffer.frame_buffer;
}

export fn guSwapBuffers() void {
    _ = sceGuSwapBuffers();
}

export fn guSwapBuffersBehaviour(behaviour: c_int) void {
    @setRuntimeSafety(false);
    gu_settings.swapBuffersBehaviour = behaviour;
}

export fn guSwapBuffersCallback(callback: GuSwapBuffersCallback) void {
    @setRuntimeSafety(false);
    gu_settings.swapBuffersCallback = callback;
}

export fn sceGuSync(mode: c_int, what: c_int) c_int {
    switch (@intToEnum(GuSyncMode,mode)) {
        .Finish => {
            return sceGeDrawSync((what));
        },
        .List => {
            return sceGeListSync(ge_list_executed[0], (what));
        },
        .Send => {
            return sceGeListSync(ge_list_executed[1], (what));
        },
        else => {
            return 0;
        },
    }
}

export fn sceGuTerm() void {
    @setRuntimeSafety(false);
    _ = sceKernelDeleteEventFlag(gu_settings.kernel_event_flag);
    _ = sceGeUnsetCallback(gu_settings.ge_callback_id);
}

export fn sceGuTexEnvColor(color: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(202, color & 0xffffff);
}

export fn sceGuTexFilter(min: c_int, mag: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(198, ((mag) << 8) | (min));
}

export fn sceGuTexFlush() void {
    @setRuntimeSafety(false);
    sendCommandf(203, 0.0);
}

export fn sceGuTexFunc(tfx: c_int, tcc: c_int) void {
    @setRuntimeSafety(false);
    gu_contexts[@intCast(usize, gu_curr_context)].texture_function = ((tcc) << 8) | (tfx);
    sendCommandi(201, (((tcc) << 8) | (tfx)) | gu_contexts[@intCast(usize, gu_curr_context)].fragment_2x);
}

const tbpcmd_tbl = [_]u8{ 0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7 };
const tbwcmd_tbl = [_]u8{ 0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0xae, 0xaf };
const tsizecmd_tbl = [_]u8{ 0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf };

fn getExp(val: c_int) c_int {
    @setRuntimeSafety(false);
    var v: c_uint = @intCast(c_uint, val);
    var r: c_uint = ((0xFFFF - v) >> 31) << 4;
    v >>= @intCast(u5, r);
    var shift: c_uint = ((0xFF - v) >> 31) << 3;
    v >>= @intCast(u5, shift);
    r |= shift;

    shift = ((0xF - v) >> 31) << 2;
    v >>= @intCast(u5, shift);
    r |= shift;
    shift = ((0x3 - v) >> 31) << 1;

    return @intCast(c_int, r) | @intCast(c_int, shift) | @intCast(c_int, (v >> @intCast(u5, (shift + 1))));
}

export fn sceGuTexImage(mipmap: c_int, width: c_int, height: c_int, tbw: c_int, tbp: ?*const anyopaque) void {
    @setRuntimeSafety(false);
    sendCommandi(tbpcmd_tbl[@intCast(usize, mipmap)], @intCast(c_int, @ptrToInt(tbp)) & 0xffffff);
    sendCommandi(tbwcmd_tbl[@intCast(usize, mipmap)], @intCast(c_int, ((@ptrToInt(tbp) >> 8) & 0x0f0000)) | tbw);
    sendCommandi(tsizecmd_tbl[@intCast(usize, mipmap)], getExp(height) << 8 | getExp(width));
    sceGuTexFlush();
}

export fn sceGuTexLevelMode(mode: c_int, bias: f32) void {
    @setRuntimeSafety(false);
    var offset: c_int = @floatToInt(c_int, bias * 16.0);

    if (offset >= 128) {
        offset = 128;
    } else if (offset < -128) {
        offset = -128;
    }
    sendCommandi(200, ((offset) << 16) | (mode));
}

export fn sceGuTexMapMode(mode: c_int, a1: c_int, a2: c_int) void {
    @setRuntimeSafety(false);
    gu_contexts[@intCast(usize, gu_curr_context)].texture_map_mode = mode & 0x03;
    sendCommandi(192, gu_contexts[@intCast(usize, gu_curr_context)].texture_proj_map_mode | (mode & 0x03));
    sendCommandi(193, (a2 << 8) | (a1 & 0x03));
}

export fn sceGuTexMode(tpsm: c_int, maxmips: c_int, a2: c_int, swizzle: c_int) void {
    @setRuntimeSafety(false);
    gu_contexts[@intCast(usize, gu_curr_context)].texture_mode = (tpsm);

    sendCommandi(194, (maxmips << 16) | (a2 << 8) | (swizzle));
    sendCommandi(195, (tpsm));
    sceGuTexFlush();
}

export fn sceGuTexOffset(u: f32, v: f32) void {
    @setRuntimeSafety(false);
    sendCommandf(74, u);
    sendCommandf(75, v);
}

export fn sceGuTexProjMapMode(mode: c_int) void {
    @setRuntimeSafety(false);
    gu_contexts[@intCast(usize, gu_curr_context)].texture_proj_map_mode = ((mode & 0x03) << 8);
    sendCommandi(192, ((mode & 0x03) << 8) | gu_contexts[@intCast(usize, gu_curr_context)].texture_map_mode);
}

export fn sceGuTexScale(u: f32, v: f32) void {
    @setRuntimeSafety(false);
    sendCommandf(72, u);
    sendCommandf(73, v);
}

export fn sceGuTexSlope(slope: f32) void {
    @setRuntimeSafety(false);
    sendCommandf(208, slope);
}

export fn sceGuTexSync() void {
    @setRuntimeSafety(false);
    sendCommandi(204, 0);
}

export fn sceGuTexWrap(u: c_int, v: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(199, ((v) << 8) | ((u)));
}

export fn sceGuViewport(cx: c_int, cy: c_int, width: c_int, height: c_int) void {
    @setRuntimeSafety(false);
    sendCommandf(66, @intToFloat(f32, width >> 1));
    sendCommandf(67, @intToFloat(f32, (-height) >> 1));
    sendCommandf(69, @intToFloat(f32, cx));
    sendCommandf(70, @intToFloat(f32, cy));
}

const ge_init_list = [_]c_uint{
    0x01000000, 0x02000000, 0x10000000, 0x12000000, 0x13000000, 0x15000000, 0x16000000, 0x17000000,
    0x18000000, 0x19000000, 0x1a000000, 0x1b000000, 0x1c000000, 0x1d000000, 0x1e000000, 0x1f000000,
    0x20000000, 0x21000000, 0x22000000, 0x23000000, 0x24000000, 0x25000000, 0x26000000, 0x27000000,
    0x28000000, 0x2a000000, 0x2b000000, 0x2c000000, 0x2d000000, 0x2e000000, 0x2f000000, 0x30000000,
    0x31000000, 0x32000000, 0x33000000, 0x36000000, 0x37000000, 0x38000000, 0x3a000000, 0x3b000000,
    0x3c000000, 0x3d000000, 0x3e000000, 0x3f000000, 0x40000000, 0x41000000, 0x42000000, 0x43000000,
    0x44000000, 0x45000000, 0x46000000, 0x47000000, 0x48000000, 0x49000000, 0x4a000000, 0x4b000000,
    0x4c000000, 0x4d000000, 0x50000000, 0x51000000, 0x53000000, 0x54000000, 0x55000000, 0x56000000,
    0x57000000, 0x58000000, 0x5b000000, 0x5c000000, 0x5d000000, 0x5e000000, 0x5f000000, 0x60000000,
    0x61000000, 0x62000000, 0x63000000, 0x64000000, 0x65000000, 0x66000000, 0x67000000, 0x68000000,
    0x69000000, 0x6a000000, 0x6b000000, 0x6c000000, 0x6d000000, 0x6e000000, 0x6f000000, 0x70000000,
    0x71000000, 0x72000000, 0x73000000, 0x74000000, 0x75000000, 0x76000000, 0x77000000, 0x78000000,
    0x79000000, 0x7a000000, 0x7b000000, 0x7c000000, 0x7d000000, 0x7e000000, 0x7f000000, 0x80000000,
    0x81000000, 0x82000000, 0x83000000, 0x84000000, 0x85000000, 0x86000000, 0x87000000, 0x88000000,
    0x89000000, 0x8a000000, 0x8b000000, 0x8c000000, 0x8d000000, 0x8e000000, 0x8f000000, 0x90000000,
    0x91000000, 0x92000000, 0x93000000, 0x94000000, 0x95000000, 0x96000000, 0x97000000, 0x98000000,
    0x99000000, 0x9a000000, 0x9b000000, 0x9c000000, 0x9d000000, 0x9e000000, 0x9f000000, 0xa0000000,
    0xa1000000, 0xa2000000, 0xa3000000, 0xa4000000, 0xa5000000, 0xa6000000, 0xa7000000, 0xa8040004,
    0xa9000000, 0xaa000000, 0xab000000, 0xac000000, 0xad000000, 0xae000000, 0xaf000000, 0xb0000000,
    0xb1000000, 0xb2000000, 0xb3000000, 0xb4000000, 0xb5000000, 0xb8000101, 0xb9000000, 0xba000000,
    0xbb000000, 0xbc000000, 0xbd000000, 0xbe000000, 0xbf000000, 0xc0000000, 0xc1000000, 0xc2000000,
    0xc3000000, 0xc4000000, 0xc5000000, 0xc6000000, 0xc7000000, 0xc8000000, 0xc9000000, 0xca000000,
    0xcb000000, 0xcc000000, 0xcd000000, 0xce000000, 0xcf000000, 0xd0000000, 0xd2000000, 0xd3000000,
    0xd4000000, 0xd5000000, 0xd6000000, 0xd7000000, 0xd8000000, 0xd9000000, 0xda000000, 0xdb000000,
    0xdc000000, 0xdd000000, 0xde000000, 0xdf000000, 0xe0000000, 0xe1000000, 0xe2000000, 0xe3000000,
    0xe4000000, 0xe5000000, 0xe6000000, 0xe7000000, 0xe8000000, 0xe9000000, 0xeb000000, 0xec000000,
    0xee000000, 0xf0000000, 0xf1000000, 0xf2000000, 0xf3000000, 0xf4000000, 0xf5000000, 0xf6000000,
    0xf7000000, 0xf8000000, 0xf9000000, 0x0f000000, 0x0c000000, 0,          0,
};

export fn sceGuInit() void {
    @setRuntimeSafety(false);
    var callback: PspGeCallbackData = undefined;
    callback.signal_func = callbackSig;
    callback.signal_arg = &gu_settings;
    callback.finish_func = callbackFin;
    callback.finish_arg = &gu_settings;

    gu_settings.ge_callback_id = sceGeSetCallback(&callback);
    gu_settings.swapBuffersCallback = null;
    gu_settings.swapBuffersBehaviour = 1;

    ge_edram_address = sceGeEdramGetAddr();

    ge_list_executed[0] = sceGeListEnQueue((@intToPtr(*anyopaque, @ptrToInt(&ge_init_list) & 0x1fffffff)), null, gu_settings.ge_callback_id, 0);

    resetValues();
    gu_settings.kernel_event_flag = sceKernelCreateEventFlag("SceGuSignal", 512, 3, 0);

    _ = sceGeListSync(ge_list_executed[0], 0);
}

export fn sceGuStart(cont: c_int, list: ?*anyopaque) void {
    @setRuntimeSafety(false);
    var local_list: [*]u32 = @intToPtr([*]u32, (@intCast(usize, @ptrToInt(list)) | 0x40000000));

    var cid: c_int = (cont);

    gu_contexts[@intCast(usize, cid)].list.start = local_list;
    gu_contexts[@intCast(usize, cid)].list.current = local_list;
    gu_contexts[@intCast(usize, cid)].list.parent_context = gu_curr_context;
    gu_list = &gu_contexts[@intCast(usize, cid)].list;

    gu_curr_context = cid;

    if (cid == 0) {
        ge_list_executed[0] = sceGeListEnQueue(local_list, local_list, gu_settings.ge_callback_id, 0);
        gu_settings.signal_offset = 0;
    }

    if (gu_init == 0) {
        var dither_matrix = [_]i32{
            -4, 0,  -3, 1,
            2,  -2, 3,  -1,
            -3, 1,  -4, 0,
            3,  -1, 2,  -2,
        };

        sceGuSetDither(@ptrCast(*ScePspIMatrix4, &dither_matrix));
        sceGuPatchDivide(16, 16);
        sceGuColorMaterial(@enumToInt(GuLightBitFlags.Ambient) | @enumToInt(GuLightBitFlags.Diffuse) | @enumToInt(GuLightBitFlags.Specular));

        sceGuSpecular(1.0);
        sceGuTexScale(1.0, 1.0);
        gu_init = 1;
    }

    if (gu_curr_context == 0) {
        if (gu_draw_buffer.frame_width != 0) {
            sendCommandi(156, @intCast(c_int, @ptrToInt(gu_draw_buffer.frame_buffer)) & 0xffffff);
            sendCommandi(157, (@intCast(c_int, (@ptrToInt(gu_draw_buffer.frame_buffer) & 0xff000000)) >> 8) | gu_draw_buffer.frame_width);
        }
    }
}

const Vertex = packed struct {
    color: u32, x: u16, y: u16, z: u16, pad: u16
};

export fn sceGuClear(flags: c_int) void {
    @setRuntimeSafety(false);
    var context: *GuContext = &gu_contexts[@intCast(usize, gu_curr_context)];

    var filter: u32 = 0;
    switch (gu_draw_buffer.pixel_size) {
        0 => {
            filter = context.clear_color & 0xffffff;
        },
        1 => {
            filter = (context.clear_color & 0xffffff) | (context.clear_stencil << 31);
        },
        2 => {
            filter = (context.clear_color & 0xffffff) | (context.clear_stencil << 28);
        },
        3 => {
            filter = (context.clear_color & 0xffffff) | (context.clear_stencil << 24);
        },
        else => {
            filter = 0;
        },
    }

    var count: i32 = @divTrunc(gu_draw_buffer.width + 63, 64) * 2;
    var vertices: [*]Vertex = @ptrCast([*]Vertex, sceGuGetMemory(@intCast(c_uint, count) * @sizeOf(Vertex)));

    var i: usize = 0;
    var curr: [*]Vertex = vertices;

    while (i < count) : (i += 1) {
        var j: u16 = 0;
        var k: u16 = 0;

        j = @intCast(u16, i) >> 1;
        k = (@intCast(u16, i) & 1);

        curr[i].color = filter;
        curr[i].x = (j + k) * 64;
        curr[i].y = k * @intCast(u16, gu_draw_buffer.height);
        curr[i].z = @intCast(u16, context.clear_depth);
    }

    sendCommandi(211, ((flags & (@enumToInt(ClearBitFlags.ColorBuffer) | @enumToInt(ClearBitFlags.StencilBuffer) | @enumToInt(ClearBitFlags.DepthBuffer))) << 8) | 0x01);
    sceGuDrawArray(@enumToInt(GuPrimitive.Sprites), @enumToInt(VertexTypeFlags.Color8888) | @enumToInt(VertexTypeFlags.Vertex16Bit) | @enumToInt(VertexTypeFlags.Transform2D), @intCast(c_int, count), null, vertices);
    sendCommandi(211, 0);
}

export fn sceGuGetMemory(size: c_uint) *anyopaque {
    @setRuntimeSafety(false);
    var siz = size;

    siz += 3;
    siz += (siz >> 31) >> 30;
    siz = (siz >> 2) << 2;

    var orig_ptr: [*]u32 = @ptrCast([*]u32, gu_list.?.current);
    var new_ptr: [*]u32 = @intToPtr([*]u32, (@intCast(c_uint, @ptrToInt(orig_ptr)) + siz + 8));

    var lo = (8 << 24) | (@ptrToInt(new_ptr) & 0xffffff);
    var hi = (16 << 24) | ((@ptrToInt(new_ptr) >> 8) & 0xf0000);

    orig_ptr[0] = hi;
    orig_ptr[1] = lo;

    gu_list.?.current = new_ptr;

    if (gu_curr_context == 0) {
        _ = sceGeListUpdateStallAddr(ge_list_executed[0], new_ptr);
    }
    return @intToPtr(*anyopaque, @ptrToInt(orig_ptr + 2));
}
