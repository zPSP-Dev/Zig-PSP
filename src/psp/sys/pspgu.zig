usingnamespace @import("psptypes.zig");
usingnamespace @import("pspge.zig");

pub const GuSwapBuffersCallback = ?fn ([*c]?*c_void, [*c]?*c_void) callconv(.C) void;
pub extern fn sceGuDepthBuffer(zbp: ?*c_void, zbw: c_int) void;
pub extern fn sceGuDispBuffer(width: c_int, height: c_int, dispbp: ?*c_void, dispbw: c_int) void;
pub extern fn sceGuDrawBuffer(psm: c_int, fbp: ?*c_void, fbw: c_int) void;
pub extern fn sceGuDrawBufferList(psm: c_int, fbp: ?*c_void, fbw: c_int) void;
pub extern fn sceGuDisplay(state: c_int) c_int;
pub extern fn sceGuDepthFunc(function: c_int) void;
pub extern fn sceGuDepthMask(mask: c_int) void;
pub extern fn sceGuDepthOffset(offset: c_uint) void;
pub extern fn sceGuDepthRange(near: c_int, far: c_int) void;
pub extern fn sceGuFog(near: f32, far: f32, color: c_uint) void;
pub extern fn sceGuInit() void;
pub extern fn sceGuTerm() void;
pub extern fn sceGuBreak(a0: c_int) void;
pub extern fn sceGuContinue() void;
pub extern fn sceGuSetCallback(signal: c_int, callback: ?fn (c_int) callconv(.C) void) ?*c_void;
pub extern fn sceGuSignal(signal: c_int, behavior: c_int) void;
pub extern fn sceGuSendCommandf(cmd: c_int, argument: f32) void;
pub extern fn sceGuSendCommandi(cmd: c_int, argument: c_int) void;
pub extern fn sceGuGetMemory(size: c_int) ?*c_void;
pub extern fn sceGuStart(cid: c_int, list: ?*c_void) void;
pub extern fn sceGuFinish() c_int;
pub extern fn sceGuFinishId(id: c_uint) c_int;
pub extern fn sceGuCallList(list: ?*const c_void) void;
pub extern fn sceGuCallMode(mode: c_int) void;
pub extern fn sceGuCheckList() c_int;
pub extern fn sceGuSendList(mode: c_int, list: ?*const c_void, context: [*c]PspGeContext) void;
pub extern fn sceGuSwapBuffers() ?*c_void;
pub extern fn sceGuSync(mode: c_int, what: c_int) c_int;
pub extern fn sceGuDrawArray(prim: c_int, vtype: c_int, count: c_int, indices: ?*const c_void, vertices: ?*const c_void) void;
pub extern fn sceGuBeginObject(vtype: c_int, count: c_int, indices: ?*const c_void, vertices: ?*const c_void) void;
pub extern fn sceGuEndObject() void;
pub extern fn sceGuSetStatus(state: c_int, status: c_int) void;
pub extern fn sceGuGetStatus(state: c_int) c_int;
pub extern fn sceGuSetAllStatus(status: c_int) void;
pub extern fn sceGuGetAllStatus() c_int;
pub extern fn sceGuEnable(state: c_int) void;
pub extern fn sceGuDisable(state: c_int) void;
pub extern fn sceGuLight(light: c_int, type: c_int, components: c_int, position: [*c]const ScePspFVector3) void;
pub extern fn sceGuLightAtt(light: c_int, atten0: f32, atten1: f32, atten2: f32) void;
pub extern fn sceGuLightColor(light: c_int, component: c_int, color: c_uint) void;
pub extern fn sceGuLightMode(mode: c_int) void;
pub extern fn sceGuLightSpot(light: c_int, direction: [*c]const ScePspFVector3, exponent: f32, cutoff: f32) void;
pub extern fn sceGuClear(flags: c_int) void;
pub extern fn sceGuClearColor(color: c_uint) void;
pub extern fn sceGuClearDepth(depth: c_uint) void;
pub extern fn sceGuClearStencil(stencil: c_uint) void;
pub extern fn sceGuPixelMask(mask: c_uint) void;
pub extern fn sceGuColor(color: c_uint) void;
pub extern fn sceGuColorFunc(func: c_int, color: c_uint, mask: c_uint) void;
pub extern fn sceGuColorMaterial(components: c_int) void;
pub extern fn sceGuAlphaFunc(func: c_int, value: c_int, mask: c_int) void;
pub extern fn sceGuAmbient(color: c_uint) void;
pub extern fn sceGuAmbientColor(color: c_uint) void;
pub extern fn sceGuBlendFunc(op: c_int, src: c_int, dest: c_int, srcfix: c_uint, destfix: c_uint) void;
pub extern fn sceGuMaterial(mode: c_int, color: c_int) void;
pub extern fn sceGuModelColor(emissive: c_uint, ambient: c_uint, diffuse: c_uint, specular: c_uint) void;
pub extern fn sceGuStencilFunc(func: c_int, ref: c_int, mask: c_int) void;
pub extern fn sceGuStencilOp(fail: c_int, zfail: c_int, zpass: c_int) void;
pub extern fn sceGuSpecular(power: f32) void;
pub extern fn sceGuFrontFace(order: c_int) void;
pub extern fn sceGuLogicalOp(op: c_int) void;
pub extern fn sceGuSetDither(matrix: [*c]const ScePspIMatrix4) void;
pub extern fn sceGuShadeModel(mode: c_int) void;
pub extern fn sceGuCopyImage(psm: c_int, sx: c_int, sy: c_int, width: c_int, height: c_int, srcw: c_int, src: ?*c_void, dx: c_int, dy: c_int, destw: c_int, dest: ?*c_void) void;
pub extern fn sceGuTexEnvColor(color: c_uint) void;
pub extern fn sceGuTexFilter(min: c_int, mag: c_int) void;
pub extern fn sceGuTexFlush() void;
pub extern fn sceGuTexFunc(tfx: c_int, tcc: c_int) void;
pub extern fn sceGuTexImage(mipmap: c_int, width: c_int, height: c_int, tbw: c_int, tbp: ?*const c_void) void;
pub extern fn sceGuTexLevelMode(mode: c_uint, bias: f32) void;
pub extern fn sceGuTexMapMode(mode: c_int, a1: c_uint, a2: c_uint) void;
pub extern fn sceGuTexMode(tpsm: c_int, maxmips: c_int, a2: c_int, swizzle: c_int) void;
pub extern fn sceGuTexOffset(u: f32, v: f32) void;
pub extern fn sceGuTexProjMapMode(mode: c_int) void;
pub extern fn sceGuTexScale(u: f32, v: f32) void;
pub extern fn sceGuTexSlope(slope: f32) void;
pub extern fn sceGuTexSync(...) void;
pub extern fn sceGuTexWrap(u: c_int, v: c_int) void;
pub extern fn sceGuClutLoad(num_blocks: c_int, cbp: ?*const c_void) void;
pub extern fn sceGuClutMode(cpsm: c_uint, shift: c_uint, mask: c_uint, a3: c_uint) void;
pub extern fn sceGuOffset(x: c_uint, y: c_uint) void;
pub extern fn sceGuScissor(x: c_int, y: c_int, w: c_int, h: c_int) void;
pub extern fn sceGuViewport(cx: c_int, cy: c_int, width: c_int, height: c_int) void;
pub extern fn sceGuDrawBezier(vtype: c_int, ucount: c_int, vcount: c_int, indices: ?*const c_void, vertices: ?*const c_void) void;
pub extern fn sceGuPatchDivide(ulevel: c_uint, vlevel: c_uint) void;
pub extern fn sceGuPatchFrontFace(a0: c_uint) void;
pub extern fn sceGuPatchPrim(prim: c_int) void;
pub extern fn sceGuDrawSpline(vtype: c_int, ucount: c_int, vcount: c_int, uedge: c_int, vedge: c_int, indices: ?*const c_void, vertices: ?*const c_void) void;
pub extern fn sceGuSetMatrix(type: c_int, matrix: [*c]const ScePspFMatrix4) void;
pub extern fn sceGuBoneMatrix(index: c_uint, matrix: [*c]const ScePspFMatrix4) void;
pub extern fn sceGuMorphWeight(index: c_int, weight: f32) void;
pub extern fn sceGuDrawArrayN(primitive_type: c_int, vertex_type: c_int, count: c_int, a3: c_int, indices: ?*const c_void, vertices: ?*const c_void) void;
pub extern fn guSwapBuffersBehaviour(behaviour: c_int) void;
pub extern fn guSwapBuffersCallback(callback: GuSwapBuffersCallback) void;

pub const GuPixelMode = extern enum(c_int){
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

pub const GuPrimitive = extern enum(c_int) {
    Points = 0,
    Lines = 1,
    LineStrip = 2,
    Triangles = 3,
    TriangleStrip = 4,
    TriangleFan = 5,
    Sprites = 6,
};

pub const PatchPrimitive = extern enum(c_int) {
    Points = 0,
    LineStrip = 2,
    TriangleStrip = 4,
};

pub const GuState = extern enum(c_int) {
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
}

pub const MatrixMode = extern enum(c_int) {
    Projection = 0,
    View = 1,
    Model = 2,
    Texture = 3,
};

pub const SplineMode = extern enum(c_int) {
    FillFill = 0,
    OpenFill = 1,
    FillOpen = 2,
    OpenOpen = 3,
};

pub const ShadeModel = extern enum(c_int) {
    Flat = 0,
    Smooth = 1,
};

pub const LogicalOperation = extern enum(c_int) {
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

pub const TextureFilter = extern enum(c_int) {
    Nearest = 0,
    Linear = 1,
    NearestMipmapNearest = 4,
    LinearMipmapNearest = 5,
    NearestMipmapLinear = 6,
    LinearMipmapLinear = 7,
};

pub const TextureMapMode = extern enum(c_int) {
    TextureCoords = 0,
    TextureMatrix = 1,
    EnvironmentMap = 2,
};

pub const TextureLevelMode = extern enum(c_int) {
    Auto = 0,
    Const = 1,
    Slope = 2,
};

pub const TextureProjectionMapMode = extern enum(c_int) {
    Position = 0,
    Uv = 1,
    NormalizedNormal = 2,
    Normal = 3,
};

pub const GuTexWrapMode = extern enum(c_int) {
    Repeat = 0,
    Clamp = 1,
};

pub const FrontFaceDirection = extern enum(c_int) {
    Clockwise = 0,
    CounterClockwise = 1,
};

pub const AlphaFunc = extern enum(c_int) {
    Never = 0,
    Always,
    Equal,
    NotEqual,
    Less,
    LessOrEqual,
    Greater,
    GreaterOrEqual,
};

pub const StencilFunc = extern enum(c_int) {
    Never = 0,
    Always,
    Equal,
    NotEqual,
    Less,
    LessOrEqual,
    Greater,
    GreaterOrEqual,
};

pub const ColorFunc = extern enum(c_int) {
    Never = 0,
    Always,
    Equal,
    NotEqual,
};

pub const DepthFunc = extern enum(c_int) {
    Never = 0,
    Always,
    Equal,
    NotEqual,
    Less,
    LessOrEqual,
    Greater,
    GreaterOrEqual,
};

pub const TextureEffect = extern enum(c_int) {
    Modulate = 0,
    Decal = 1,
    Blend = 2,
    Replace = 3,
    Add = 4,
};

pub const TextureColorComponent = extern enum(c_int) {
    Rgb = 0,
    Rgba = 1,
};

pub const MipmapLevel = extern enum(c_int) {
    None = 0,
    Level1,
    Level2,
    Level3,
    Level4,
    Level5,
    Level6,
    Level7,
};

pub const BlendOp = extern enum(c_int) {
    Add = 0,
    Subtract = 1,
    ReverseSubtract = 2,
    Min = 3,
    Max = 4,
    Abs = 5,
};

pub const BlendSrc = extern enum(c_int) {
    SrcColor = 0,
    OneMinusSrcColor = 1,
    SrcAlpha = 2,
    OneMinusSrcAlpha = 3,
    Fix = 10,
};

pub const BlendDst = extern enum(c_int) {
    DstColor = 0,
    OneMinusDstColor = 1,
    DstAlpha = 4,
    OneMinusDstAlpha = 5,
    Fix = 10,
};

pub const StencilOperation = extern enum(c_int) {
    Keep = 0,
    Zero = 1,
    Replace = 2,
    Invert = 3,
    Incr = 4,
    Decr = 5,
};

pub const LightMode = extern enum(c_int) {
    SingleColor = 0,
    SeparateSpecularColor = 1,
};

pub const LightType = extern enum(c_int) {
    Directional = 0,
    Pointlight = 1,
    Spotlight = 2,
};

pub const GuContextType = extern enum(c_int) {
    Direct = 0,
    Call = 1,
    Send = 2,
};

pub const GuQueueMode = extern enum(c_int) {
    Tail = 0,
    Head = 1,
};

pub const GuSyncMode = extern enum(c_int) {
    Finish = 0,
    Signal = 1,
    Done = 2,
    List = 3,
    Send = 4,
};

pub const GuSyncBehavior = extern enum(c_int) {
    Wait = 0,
    NoWait = 1,
};

pub const GuCallbackId = extern enum(c_int) {
    Signal = 1,
    Finish = 4,
};

pub enum SignalBehavior = extern enum(c_int) {
    Suspend = 1,
    Continue = 2,
};

pub fn abgr(a: u8, b: u8, g: u8, r: u8) u32 {
    return (r as u32) | ((g as u32) << 8) | ((b as u32) << 16) | ((a as u32) << 24)
}

pub fn argb(a: u8, r: u8, g: u8, b: u8) u32 {
    abgr(a, b, g, r)
}

pub fn rgba(r: u8, g: u8, b: u8, a: u8) u32 {
    argb(a, r, g, b)
}

pub fn color(r: f32, g: f32, b: f32, a: f32) u32 {
    rgba(
        (r * 255.0) as u8,
        (g * 255.0) as u8,
        (b * 255.0) as u8,
        (a * 255.0) as u8,
    )
}

pub const ClearBitFlags = extern enum(c_int){
    ColorBuffer = 1,
    StencilBuffer = 2,
    DepthBuffer = 4,
    FastClear = 16,
};

pub const LightBitFlags = extern enum(c_int){
    Ambient = 1,
    Diffuse = 2,
    Specular = 4,
    Unknown = 8,
};

pub const VertexTypeFlags = extern enum(c_int){
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