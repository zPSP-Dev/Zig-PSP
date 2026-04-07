const std = @import("std");
const types = @import("types.zig");

pub const Op = enum(u8) {
    nop = 0x00,
    vaddr = 0x01,
    iaddr = 0x02,
    prim = 0x04,
    bezier = 0x05,
    spline = 0x06,
    bbox = 0x07,
    jump = 0x08,
    bjump = 0x09,
    call = 0x0a,
    ret = 0x0b,
    end = 0x0c,
    signal = 0x0e,
    finish = 0x0f,
    base = 0x10,
    vtype = 0x12,
    region1 = 0x15,
    region2 = 0x16,
    lte = 0x17,
    lte0 = 0x18,
    lte1 = 0x19,
    lte2 = 0x1a,
    lte3 = 0x1b,
    cpe = 0x1c,
    bce = 0x1d,
    tme = 0x1e,
    fge = 0x1f,
    dte = 0x20,
    abe = 0x21,
    ate = 0x22,
    zte = 0x23,
    ste = 0x24,
    aae = 0x25,
    pce = 0x26,
    cte = 0x27,
    loe = 0x28,
    bofs = 0x2a,
    bone = 0x2b,
    mw0 = 0x2c,
    mw1 = 0x2d,
    mw2 = 0x2e,
    mw3 = 0x2f,
    mw4 = 0x30,
    mw5 = 0x31,
    mw6 = 0x32,
    mw7 = 0x33,
    psub = 0x36,
    pprim = 0x37,
    pface = 0x38,
    wms = 0x3a,
    world = 0x3b,
    vms = 0x3c,
    view = 0x3d,
    pms = 0x3e,
    proj = 0x3f,
    tms = 0x40,
    tmatrix = 0x41,
    xscale = 0x42,
    yscale = 0x43,
    zscale = 0x44,
    xpos = 0x45,
    ypos = 0x46,
    zpos = 0x47,
    uscale = 0x48,
    vscale = 0x49,
    uoffset = 0x4a,
    voffset = 0x4b,
    offsetx = 0x4c,
    offsety = 0x4d,
    shade = 0x50,
    rnorm = 0x51,
    cmat = 0x53,
    emc = 0x54,
    amc = 0x55,
    dmc = 0x56,
    smc = 0x57,
    ama = 0x58,
    spow = 0x5b,
    alc = 0x5c,
    ala = 0x5d,
    lmode = 0x5e,
    lt0 = 0x5f,
    lt1 = 0x60,
    lt2 = 0x61,
    lt3 = 0x62,
    lxp0 = 0x63,
    lyp0 = 0x64,
    lzp0 = 0x65,
    lxp1 = 0x66,
    lyp1 = 0x67,
    lzp1 = 0x68,
    lxp2 = 0x69,
    lyp2 = 0x6a,
    lzp2 = 0x6b,
    lxp3 = 0x6c,
    lyp3 = 0x6d,
    lzp3 = 0x6e,
    lxd0 = 0x6f,
    lyd0 = 0x70,
    lzd0 = 0x71,
    lxd1 = 0x72,
    lyd1 = 0x73,
    lzd1 = 0x74,
    lxd2 = 0x75,
    lyd2 = 0x76,
    lzd2 = 0x77,
    lxd3 = 0x78,
    lyd3 = 0x79,
    lzd3 = 0x7a,
    lca0 = 0x7b,
    lla0 = 0x7c,
    lqa0 = 0x7d,
    lca1 = 0x7e,
    lla1 = 0x7f,
    lqa1 = 0x80,
    lca2 = 0x81,
    lla2 = 0x82,
    lqa2 = 0x83,
    lca3 = 0x84,
    lla3 = 0x85,
    lqa3 = 0x86,
    lse0 = 0x87,
    lse1 = 0x88,
    lse2 = 0x89,
    lse3 = 0x8a,
    lsc0 = 0x8b,
    lsc1 = 0x8c,
    lsc2 = 0x8d,
    lsc3 = 0x8e,
    alc0 = 0x8f,
    dlc0 = 0x90,
    slc0 = 0x91,
    alc1 = 0x92,
    dlc1 = 0x93,
    slc1 = 0x94,
    alc2 = 0x95,
    dlc2 = 0x96,
    slc2 = 0x97,
    alc3 = 0x98,
    dlc3 = 0x99,
    slc3 = 0x9a,
    fface = 0x9b,
    fbp = 0x9c,
    fbw = 0x9d,
    zbp = 0x9e,
    zbw = 0x9f,
    tbp0 = 0xa0,
    tbp1 = 0xa1,
    tbp2 = 0xa2,
    tbp3 = 0xa3,
    tbp4 = 0xa4,
    tbp5 = 0xa5,
    tbp6 = 0xa6,
    tbp7 = 0xa7,
    tbw0 = 0xa8,
    tbw1 = 0xa9,
    tbw2 = 0xaa,
    tbw3 = 0xab,
    tbw4 = 0xac,
    tbw5 = 0xad,
    tbw6 = 0xae,
    tbw7 = 0xaf,
    cbp = 0xb0,
    cbph = 0xb1,
    trxsbp = 0xb2,
    trxsbw = 0xb3,
    trxdbp = 0xb4,
    trxdbw = 0xb5,
    tsize0 = 0xb8,
    tsize1 = 0xb9,
    tsize2 = 0xba,
    tsize3 = 0xbb,
    tsize4 = 0xbc,
    tsize5 = 0xbd,
    tsize6 = 0xbe,
    tsize7 = 0xbf,
    tmap = 0xc0,
    tenvmtx = 0xc1,
    tmode = 0xc2,
    tpsm = 0xc3,
    cload = 0xc4,
    cmode = 0xc5,
    tflt = 0xc6,
    twrap = 0xc7,
    tbias = 0xc8,
    tfunc = 0xc9,
    tec = 0xca,
    tflush = 0xcb,
    tsync = 0xcc,
    ffar = 0xcd,
    fdist = 0xce,
    fcol = 0xcf,
    tslope = 0xd0,
    psm = 0xd2,
    clear = 0xd3,
    scissor1 = 0xd4,
    scissor2 = 0xd5,
    nearz = 0xd6,
    farz = 0xd7,
    ctst = 0xd8,
    cref = 0xd9,
    cmsk = 0xda,
    atst = 0xdb,
    stst = 0xdc,
    sop = 0xdd,
    ztst = 0xde,
    alpha = 0xdf,
    sfix = 0xe0,
    dfix = 0xe1,
    dth0 = 0xe2,
    dth1 = 0xe3,
    dth2 = 0xe4,
    dth3 = 0xe5,
    lop = 0xe6,
    zmsk = 0xe7,
    pmskc = 0xe8,
    pmska = 0xe9,
    trxkick = 0xea,
    trxspos = 0xeb,
    trxdpos = 0xec,
    trxsize = 0xee,
};

pub const Primitive = types.Primitive;
pub const EnableRegister = types.EnableRegister;
pub const TextureLevel = types.TextureLevel;
pub const SplineEdges = types.SplineEdges;
pub const ClearFlags = types.ClearFlags;

pub const TruncatedFloat = packed struct(u24) {
    value: u24,

    pub fn make(value: f32) TruncatedFloat {
        return .{ .value = ge_float(value) };
    }
};

pub const EmptyArgument = packed struct(u24) {
    zero: u24 = 0,
};

pub const RawArgument = packed struct(u24) {
    value: u24 = 0,
};

pub const PointerArgument = packed struct(u24) {
    low_bits: u24,
};

pub const BaseArgument = packed struct(u24) {
    zero_b0_15: u16 = 0,
    high_bits: u5,
    zero_b21_23: u3 = 0,
};

pub const CountArgument = packed struct(u24) {
    count: u16,
    zero: u8 = 0,
};

pub const PrimitiveArgument = packed struct(u24) {
    count: u16,
    primitive: Primitive,
    zero: u5 = 0,
};

pub const BezierArgument = packed struct(u24) {
    u_count: u8,
    v_count: u8,
    zero: u8 = 0,
};

pub const SplineArgument = packed struct(u24) {
    u_count: u8,
    v_count: u8,
    u_edges: SplineEdges,
    v_edges: SplineEdges,
    zero: u4 = 0,
};

pub const SignalArgument = packed struct(u24) {
    argument: u16,
    index: u8,
};

pub const EndArgument = packed struct(u24) {
    argument: u16 = 0,
    zero: u8 = 0,
};

pub const FinishArgument = packed struct(u24) {
    id: u16 = 0,
    zero: u8 = 0,
};

pub const CoordinateArgument = packed struct(u24) {
    x: u10,
    y: u10,
    zero: u4 = 0,
};

pub const BufferWidthArgument = packed struct(u24) {
    width: u16,
    high_bits: u8,
};

pub const TextureBufferWidthArgument = packed struct(u24) {
    width: u16,
    high_bits: u5,
    zero: u3 = 0,
};

pub const TextureSizeArgument = packed struct(u24) {
    width_exp: u8,
    height_exp: u8,
    zero: u8 = 0,
};

pub const ClutModeArgument = packed struct(u24) {
    pixel_format: u2,
    shift: u6,
    mask: u8,
    start: u8,
};

pub const RgbArgument = packed struct(u24) {
    red: u8,
    green: u8,
    blue: u8,
};

pub const ClearArgument = packed struct(u24) {
    enable: bool,
    zero_b1_7: u7 = 0,
    flags: ClearFlags,
    zero_b11_23: u13 = 0,
};

pub const Command = union(Op) {
    nop: EmptyArgument,
    vaddr: PointerArgument,
    iaddr: PointerArgument,
    prim: PrimitiveArgument,
    bezier: BezierArgument,
    spline: SplineArgument,
    bbox: CountArgument,
    jump: PointerArgument,
    bjump: PointerArgument,
    call: PointerArgument,
    ret: EmptyArgument,
    end: EndArgument,
    signal: SignalArgument,
    finish: FinishArgument,
    base: BaseArgument,
    vtype: RawArgument,
    region1: CoordinateArgument,
    region2: CoordinateArgument,
    lte: RawArgument,
    lte0: RawArgument,
    lte1: RawArgument,
    lte2: RawArgument,
    lte3: RawArgument,
    cpe: RawArgument,
    bce: RawArgument,
    tme: RawArgument,
    fge: RawArgument,
    dte: RawArgument,
    abe: RawArgument,
    ate: RawArgument,
    zte: RawArgument,
    ste: RawArgument,
    aae: RawArgument,
    pce: RawArgument,
    cte: RawArgument,
    loe: RawArgument,
    bofs: RawArgument,
    bone: TruncatedFloat,
    mw0: TruncatedFloat,
    mw1: TruncatedFloat,
    mw2: TruncatedFloat,
    mw3: TruncatedFloat,
    mw4: TruncatedFloat,
    mw5: TruncatedFloat,
    mw6: TruncatedFloat,
    mw7: TruncatedFloat,
    psub: RawArgument,
    pprim: RawArgument,
    pface: RawArgument,
    wms: RawArgument,
    world: TruncatedFloat,
    vms: RawArgument,
    view: TruncatedFloat,
    pms: RawArgument,
    proj: TruncatedFloat,
    tms: RawArgument,
    tmatrix: TruncatedFloat,
    xscale: TruncatedFloat,
    yscale: TruncatedFloat,
    zscale: TruncatedFloat,
    xpos: TruncatedFloat,
    ypos: TruncatedFloat,
    zpos: TruncatedFloat,
    uscale: TruncatedFloat,
    vscale: TruncatedFloat,
    uoffset: TruncatedFloat,
    voffset: TruncatedFloat,
    offsetx: RawArgument,
    offsety: RawArgument,
    shade: RawArgument,
    rnorm: RawArgument,
    cmat: RawArgument,
    emc: RgbArgument,
    amc: RgbArgument,
    dmc: RgbArgument,
    smc: RgbArgument,
    ama: RawArgument,
    spow: TruncatedFloat,
    alc: RgbArgument,
    ala: RawArgument,
    lmode: RawArgument,
    lt0: RawArgument,
    lt1: RawArgument,
    lt2: RawArgument,
    lt3: RawArgument,
    lxp0: TruncatedFloat,
    lyp0: TruncatedFloat,
    lzp0: TruncatedFloat,
    lxp1: TruncatedFloat,
    lyp1: TruncatedFloat,
    lzp1: TruncatedFloat,
    lxp2: TruncatedFloat,
    lyp2: TruncatedFloat,
    lzp2: TruncatedFloat,
    lxp3: TruncatedFloat,
    lyp3: TruncatedFloat,
    lzp3: TruncatedFloat,
    lxd0: TruncatedFloat,
    lyd0: TruncatedFloat,
    lzd0: TruncatedFloat,
    lxd1: TruncatedFloat,
    lyd1: TruncatedFloat,
    lzd1: TruncatedFloat,
    lxd2: TruncatedFloat,
    lyd2: TruncatedFloat,
    lzd2: TruncatedFloat,
    lxd3: TruncatedFloat,
    lyd3: TruncatedFloat,
    lzd3: TruncatedFloat,
    lca0: TruncatedFloat,
    lla0: TruncatedFloat,
    lqa0: TruncatedFloat,
    lca1: TruncatedFloat,
    lla1: TruncatedFloat,
    lqa1: TruncatedFloat,
    lca2: TruncatedFloat,
    lla2: TruncatedFloat,
    lqa2: TruncatedFloat,
    lca3: TruncatedFloat,
    lla3: TruncatedFloat,
    lqa3: TruncatedFloat,
    lse0: TruncatedFloat,
    lse1: TruncatedFloat,
    lse2: TruncatedFloat,
    lse3: TruncatedFloat,
    lsc0: TruncatedFloat,
    lsc1: TruncatedFloat,
    lsc2: TruncatedFloat,
    lsc3: TruncatedFloat,
    alc0: RgbArgument,
    dlc0: RgbArgument,
    slc0: RgbArgument,
    alc1: RgbArgument,
    dlc1: RgbArgument,
    slc1: RgbArgument,
    alc2: RgbArgument,
    dlc2: RgbArgument,
    slc2: RgbArgument,
    alc3: RgbArgument,
    dlc3: RgbArgument,
    slc3: RgbArgument,
    fface: RawArgument,
    fbp: PointerArgument,
    fbw: BufferWidthArgument,
    zbp: PointerArgument,
    zbw: BufferWidthArgument,
    tbp0: PointerArgument,
    tbp1: PointerArgument,
    tbp2: PointerArgument,
    tbp3: PointerArgument,
    tbp4: PointerArgument,
    tbp5: PointerArgument,
    tbp6: PointerArgument,
    tbp7: PointerArgument,
    tbw0: TextureBufferWidthArgument,
    tbw1: TextureBufferWidthArgument,
    tbw2: TextureBufferWidthArgument,
    tbw3: TextureBufferWidthArgument,
    tbw4: TextureBufferWidthArgument,
    tbw5: TextureBufferWidthArgument,
    tbw6: TextureBufferWidthArgument,
    tbw7: TextureBufferWidthArgument,
    cbp: PointerArgument,
    cbph: BaseArgument,
    trxsbp: PointerArgument,
    trxsbw: BufferWidthArgument,
    trxdbp: PointerArgument,
    trxdbw: BufferWidthArgument,
    tsize0: TextureSizeArgument,
    tsize1: TextureSizeArgument,
    tsize2: TextureSizeArgument,
    tsize3: TextureSizeArgument,
    tsize4: TextureSizeArgument,
    tsize5: TextureSizeArgument,
    tsize6: TextureSizeArgument,
    tsize7: TextureSizeArgument,
    tmap: RawArgument,
    tenvmtx: RawArgument,
    tmode: RawArgument,
    tpsm: RawArgument,
    cload: RawArgument,
    cmode: ClutModeArgument,
    tflt: RawArgument,
    twrap: RawArgument,
    tbias: RawArgument,
    tfunc: RawArgument,
    tec: RgbArgument,
    tflush: EmptyArgument,
    tsync: EmptyArgument,
    ffar: TruncatedFloat,
    fdist: TruncatedFloat,
    fcol: RgbArgument,
    tslope: TruncatedFloat,
    psm: RawArgument,
    clear: ClearArgument,
    scissor1: CoordinateArgument,
    scissor2: CoordinateArgument,
    nearz: CountArgument,
    farz: CountArgument,
    ctst: RawArgument,
    cref: RgbArgument,
    cmsk: RgbArgument,
    atst: RawArgument,
    stst: RawArgument,
    sop: RawArgument,
    ztst: RawArgument,
    alpha: RawArgument,
    sfix: RgbArgument,
    dfix: RgbArgument,
    dth0: RawArgument,
    dth1: RawArgument,
    dth2: RawArgument,
    dth3: RawArgument,
    lop: RawArgument,
    zmsk: CountArgument,
    pmskc: RgbArgument,
    pmska: RawArgument,
    trxkick: RawArgument,
    trxspos: CoordinateArgument,
    trxdpos: CoordinateArgument,
    trxsize: CoordinateArgument,
};

pub const RawCommand = packed struct(u32) {
    argument: u24,
    op: u8,
};

pub fn encode_command(command: Command) u32 {
    return @bitCast(RawCommand{
        .argument = switch (command) {
            inline else => |argument| @bitCast(argument),
        },
        .op = @intFromEnum(command),
    });
}

pub fn CommandArgument(comptime op: Op) type {
    @setEvalBranchQuota(10_000);
    inline for (@typeInfo(Command).@"union".fields) |field| {
        if (std.mem.eql(u8, field.name, @tagName(op))) {
            return field.type;
        }
    }
    @compileError("GE command has no payload type: " ++ @tagName(op));
}

pub fn payload(comptime op: Op, value: u24) CommandArgument(op) {
    return @bitCast(value);
}

pub fn float_arg(comptime op: Op, value: f32) CommandArgument(op) {
    return payload(op, ge_float(value));
}

pub fn command_argument(comptime op: Op, argument: anytype) CommandArgument(op) {
    const Argument = CommandArgument(op);
    const Value = @TypeOf(argument);

    return switch (@typeInfo(Value)) {
        .void => if (Argument == EmptyArgument) .{} else @compileError("empty GE command argument only works with empty commands"),
        .bool => payload(op, @intFromBool(argument)),
        .int, .comptime_int, .@"enum" => payload(op, command_int(argument)),
        .float, .comptime_float => payload(op, ge_float(@as(f32, @floatCast(argument)))),
        .@"struct" => argument,
        else => @compileError("unsupported GE command argument type"),
    };
}

pub fn encode_raw(op: u8, argument: u24) u32 {
    return (@as(u32, op) << 24) | argument;
}

pub fn ge_float(value: f32) u24 {
    return @truncate(@as(u32, @bitCast(value)) >> 8);
}

pub fn low_address_bits(address: usize) u24 {
    return @truncate(address);
}

pub fn high_address_bits(address: usize) u24 {
    return @truncate((address >> 8) & 0x0f0000);
}

pub fn high_buffer_address_bits(address: usize) u24 {
    return @truncate((address & 0xff000000) >> 8);
}

pub fn xy_10(x: u10, y: u10) u24 {
    return (@as(u24, y) << 10) | x;
}

pub fn command_name(op: u8) []const u8 {
    const tag = std.enums.fromInt(Op, op) orelse return "UNKNOWN";
    @setEvalBranchQuota(10_000);
    return switch (tag) {
        inline else => |known_tag| comptime uppercase(@tagName(known_tag)),
    };
}

fn uppercase(comptime name: []const u8) []const u8 {
    comptime {
        var buffer: [name.len]u8 = undefined;
        for (name, 0..) |char, i| {
            buffer[i] = std.ascii.toUpper(char);
        }
        const static = buffer;
        return &static;
    }
}

pub fn ptr_value(pointer: anytype) usize {
    const Pointer = @TypeOf(pointer);
    return switch (@typeInfo(Pointer)) {
        .optional => if (pointer) |ptr| ptr_value(ptr) else 0,
        .pointer => @intFromPtr(pointer),
        .int, .comptime_int => @intCast(pointer),
        else => @compileError("expected a pointer, optional pointer, or address integer"),
    };
}

fn command_int(value: anytype) u24 {
    const Value = @TypeOf(value);
    return switch (@typeInfo(Value)) {
        .@"enum" => @intCast(@intFromEnum(value)),
        .int, .comptime_int => @intCast(value),
        else => @compileError("expected an enum or integer command argument"),
    };
}

test "command_name uses Op membership" {
    try std.testing.expectEqualStrings("NOP", command_name(0x00));
    try std.testing.expectEqualStrings("BOFS", command_name(0x2a));
    try std.testing.expectEqualStrings("BONE", command_name(0x2b));
    try std.testing.expectEqualStrings("UNKNOWN", command_name(0xff));
}
