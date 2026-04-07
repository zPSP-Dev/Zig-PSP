pub const Primitive = enum(u3) {
    points = 0,
    lines = 1,
    line_strip = 2,
    triangles = 3,
    triangle_strip = 4,
    triangle_fan = 5,
    sprites = 6,
};

pub const EnableRegister = enum(u8) {
    lighting = 0x17,
    light0 = 0x18,
    light1 = 0x19,
    light2 = 0x1a,
    light3 = 0x1b,
    clip_planes = 0x1c,
    cull_face = 0x1d,
    texture_mapping = 0x1e,
    fog = 0x1f,
    dither = 0x20,
    alpha_blend = 0x21,
    alpha_test = 0x22,
    depth_test = 0x23,
    stencil_test = 0x24,
    antialiasing = 0x25,
    patch_cull = 0x26,
    color_test = 0x27,
    logical_op = 0x28,
    reverse_normals = 0x51,
};

pub const TextureLevel = enum(u3) {
    level0 = 0,
    level1 = 1,
    level2 = 2,
    level3 = 3,
    level4 = 4,
    level5 = 5,
    level6 = 6,
    level7 = 7,
};

pub const SplineEdges = enum(u2) {
    close_close = 0,
    open_close = 1,
    close_open = 2,
    open_open = 3,
};

pub const ClearFlags = packed struct(u3) {
    color: bool = false,
    stencil: bool = false,
    depth: bool = false,
};

pub const LightIndex = enum(u2) {
    light0,
    light1,
    light2,
    light3,
};

pub const LightColorComponent = enum {
    ambient,
    diffuse,
    specular,
};

pub const CompareFunc = enum(u3) {
    never = 0,
    always = 1,
    equal = 2,
    not_equal = 3,
    less = 4,
    less_or_equal = 5,
    greater = 6,
    greater_or_equal = 7,
};

pub const ColorTestFunc = enum(u2) {
    never = 0,
    always = 1,
    equal = 2,
    not_equal = 3,
};

pub const BlendOperation = enum(u4) {
    add = 0,
    subtract = 1,
    reverse_subtract = 2,
    min = 3,
    max = 4,
    abs = 5,
};

pub const BlendFactor = enum(u4) {
    other_color = 0,
    one_minus_other_color = 1,
    source_alpha = 2,
    one_minus_source_alpha = 3,
    dest_alpha = 4,
    one_minus_dest_alpha = 5,
    double_source_alpha = 6,
    one_minus_double_source_alpha = 7,
    double_dest_alpha = 8,
    one_minus_double_dest_alpha = 9,
    fixed_value = 10,
};

pub const StencilOperation = enum(u3) {
    keep = 0,
    zero = 1,
    replace = 2,
    invert = 3,
    increment = 4,
    decrement = 5,
};

pub const LogicalOperation = enum(u4) {
    clear = 0,
    @"and" = 1,
    and_reverse = 2,
    copy = 3,
    and_inverted = 4,
    noop = 5,
    xor = 6,
    @"or" = 7,
    nor = 8,
    equivalent = 9,
    inverted = 10,
    or_reverse = 11,
    copy_inverted = 12,
    or_inverted = 13,
    nand = 14,
    set = 15,
};

pub const TextureFilter = enum(u3) {
    nearest = 0,
    linear = 1,
    nearest_mipmap_nearest = 4,
    linear_mipmap_nearest = 5,
    nearest_mipmap_linear = 6,
    linear_mipmap_linear = 7,
};

pub const TextureEffect = enum(u3) {
    modulate = 0,
    decal = 1,
    blend = 2,
    replace = 3,
    add = 4,
};

pub const TextureColorComponent = enum(u1) {
    rgb = 0,
    rgba = 1,
};

pub const TextureFunction = struct {
    effect: TextureEffect = .modulate,
    component: TextureColorComponent = .rgb,
    fragment_2x: bool = false,
};

pub const TextureLevelMode = enum(u2) {
    auto = 0,
    constant = 1,
    slope = 2,
};

pub const TextureMapMode = enum(u2) {
    coordinates = 0,
    matrix = 1,
    environment_map = 2,
    reserved = 3,
};

pub const TextureProjectionMapMode = enum(u2) {
    position = 0,
    uv = 1,
    normalized_normal = 2,
    normal = 3,
};

pub const TextureMapState = struct {
    mode: TextureMapMode = .coordinates,
    projection: TextureProjectionMapMode = .position,
};

pub const TexturePixelFormat = enum(u9) {
    psm5650 = 0,
    psm5551 = 1,
    psm4444 = 2,
    psm8888 = 3,
    psm_t4 = 4,
    psm_t8 = 5,
    psm_t16 = 6,
    psm_t32 = 7,
    psm_dxt1 = 8,
    psm_dxt3 = 9,
    psm_dxt5 = 10,
    psm_dxt1_ext = 8 + 256,
    psm_dxt3_ext = 9 + 256,
    psm_dxt5_ext = 10 + 256,
};

pub const TextureClutMode = enum(u1) {
    single = 0,
    multiple = 1,
};

pub const TextureDataLayout = enum(u1) {
    linear = 0,
    swizzled = 1,
};

pub const TextureWrapMode = enum(u1) {
    repeat = 0,
    clamp = 1,
};

pub const LightType = enum(u2) {
    directional = 0,
    point = 1,
    spot = 2,
};

pub const LightMode = enum(u1) {
    single_color = 0,
    separate_specular_color = 1,
};

pub const ShadeModel = enum(u1) {
    flat = 0,
    smooth = 1,
};

pub const PixelFormat = enum(u2) {
    rgb565 = 0,
    rgba5551 = 1,
    rgba4444 = 2,
    rgba8888 = 3,
};

pub const Vector3 = struct {
    x: f32,
    y: f32,
    z: f32,
};

pub const DitherRow = struct {
    x: i32,
    y: i32,
    z: i32,
    w: i32,
};

pub const DitherMatrix = struct {
    x: DitherRow,
    y: DitherRow,
    z: DitherRow,
    w: DitherRow,
};

pub const MatrixTarget = enum {
    projection,
    view,
    world,
    texture,
};
