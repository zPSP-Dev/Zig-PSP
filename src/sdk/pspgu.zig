pub const types = @import("pspgutypes.zig");

const libzpsp = @import("libzpsp");
const libzpsp_threadman = libzpsp.ThreadManForUser;

const ScePspFVector3 = libzpsp.types.ScePspFVector3;
const ScePspIMatrix4 = libzpsp.types.ScePspIMatrix4;
const ScePspFMatrix4 = libzpsp.types.ScePspFMatrix4;

const pspge = @import("pspge.zig");
const pspdisplay = @import("pspdisplay.zig");

// DEPRECATED Use packed structs for this
pub fn abgr(a: u8, b: u8, g: u8, r: u8) u32 {
    return @as(u32, r) | (@as(u32, g) << 8) | (@as(u32, b) << 16) | (@as(u32, a) << 24);
}

pub fn argb(a: u8, r: u8, g: u8, b: u8) u32 {
    return abgr(a, b, g, r);
}

pub fn rgba(r: u8, g: u8, b: u8, a: u8) u32 {
    return argb(a, r, g, b);
}

//Internals
pub const GuCallback = ?*const fn (c_int) callconv(.C) void;

const GuSettings = struct {
    sig: GuCallback,
    fin: GuCallback,
    signal_history: [16]u16,
    signal_offset: i32,
    kernel_event_flag: i32,
    ge_callback_id: i32,

    swapBuffersCallback: types.GuSwapBuffersCallback,
    swapBuffersBehaviour: pspdisplay.PspDisplaySetBufSync,
};

const GupspList = struct {
    start: [*]u32,
    current: [*]u32,
    parent_context: i32,
};

const GuContext = struct {
    list: GupspList,
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
    pixel_format: pspdisplay.PspDisplayPixelFormats,
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
var gu_list: ?*GupspList = null;
var gu_curr_context: i32 = 0;
var gu_init: i32 = 0;
var gu_psp_on: i32 = 0;
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

const pspthreadman = @import("pspthreadman.zig");
pub export fn callbackSig(id: c_int, arg: ?*anyopaque) void {
    @setRuntimeSafety(false);
    var settings: ?*GuSettings = @as(?*GuSettings, @ptrFromInt(@intFromPtr(arg)));
    settings.?.signal_history[@as(usize, @intCast((settings.?.signal_offset))) & 15] = @as(u16, @intCast(id)) & 0xffff;
    settings.?.signal_offset += 1;

    if (settings.?.sig != null)
        settings.?.sig.?(id & 0xffff);

    _ = pspthreadman.sceKernelSetEventFlag(settings.?.kernel_event_flag, 1);
}

pub export fn callbackFin(id: c_int, arg: ?*anyopaque) void {
    @setRuntimeSafety(false);
    const settings: ?*GuSettings = @as(?*GuSettings, @ptrFromInt(@intFromPtr(arg)));
    if (settings.?.fin != null) {
        settings.?.fin.?(id & 0xffff);
    }
}

pub fn resetValues() void {
    @setRuntimeSafety(false);
    var i: usize = 0;

    gu_init = 0;

    gu_states = 0;
    gu_current_frame = 0;
    gu_object_stack_depth = 0;

    gu_psp_on = 0;
    gu_call_mode = 0;

    gu_draw_buffer.pixel_format = .Format5551;
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

pub fn sendCommandi(cmd: c_int, argument: c_int) void {
    @setRuntimeSafety(false);
    gu_list.?.current[0] = (@as(u32, @intCast(cmd)) << 24) | (@as(u32, @intCast(argument)) & 0xffffff);
    gu_list.?.current += 1;
}

pub fn sendCommandiStall(cmd: c_int, argument: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(cmd, argument);
    if (gu_object_stack_depth == 0 and gu_curr_context == 0) {
        _ = pspge.sceGeListUpdateStallAddr(ge_list_executed[0], @as(*anyopaque, @ptrCast(gu_list.?.current)));
    }
}

pub fn sendCommandf(cmd: c_int, argument: f32) void {
    @setRuntimeSafety(false);
    sendCommandi(cmd, @as(c_int, @bitCast(argument)) >> 8);
}

//GU IMPLEMENTATION

pub fn sceGuAlphaFunc(func: types.AlphaFunc, value: c_int, mask: c_int) void {
    @setRuntimeSafety(false);
    const arg: c_int = @intFromEnum(func) | ((value & 0xff) << 8) | ((mask & 0xff) << 16);
    sendCommandi(219, arg);
}
pub fn sceGuAmbient(col: u32) void {
    @setRuntimeSafety(false);
    sendCommandi(92, (col & 0xffffff));
    sendCommandi(93, (col >> 24));
}
pub fn sceGuAmbientColor(col: u32) void {
    @setRuntimeSafety(false);
    sendCommandi(85, @as(c_int, @intCast(col)) & 0xffffff);
    sendCommandi(88, @as(c_int, @intCast(col)) >> 24);
}

pub fn sceGuBlendFunc(bop: types.BlendOp, sc: types.BlendArg, dst: types.BlendArg, srcfix: c_int, destfix: c_int) void {
    const op: c_int = @intFromEnum(bop);

    const src: c_int = @intFromEnum(sc);
    const dest: c_int = @intFromEnum(dst);

    @setRuntimeSafety(false);
    sendCommandi(223, src | (dest << 4) | (op << 8));
    sendCommandi(224, srcfix & 0xffffff);
    sendCommandi(225, destfix & 0xffffff);
}

pub fn sceGuBreak(a0: c_int) void {
    _ = a0;
    @setRuntimeSafety(false);
    //Does nothing or is broken?
}

pub fn sceGuContinue() void {
    @setRuntimeSafety(false);
    //Does nothing or is broken?
}

pub fn sceGuCallList(list: ?*const anyopaque) void {
    @setRuntimeSafety(false);
    const list_addr: c_int = @as(c_int, @intCast(@intFromPtr(list)));

    if (gu_call_mode == 1) {
        sendCommandi(14, (list_addr >> 16) | 0x110000);
        sendCommandi(12, list_addr & 0xffff);
        sendCommandiStall(0, 0);
    } else {
        sendCommandi(16, (list_addr >> 8) & 0xf0000);
        sendCommandiStall(10, list_addr & 0xffffff);
    }
}

pub fn sceGuCallMode(mode: c_int) void {
    @setRuntimeSafety(false);
    gu_call_mode = mode;
}

pub fn sceGuCheckList() c_int {
    return @as(c_int, @intCast((@intFromPtr(gu_list.?.current) - @intFromPtr(gu_list.?.start))));
}

pub fn sceGuClearColor(col: c_uint) void {
    @setRuntimeSafety(false);
    gu_contexts[@as(usize, @intCast(gu_curr_context))].clear_color = col;
}

pub fn sceGuClearDepth(depth: c_uint) void {
    @setRuntimeSafety(false);
    gu_contexts[@as(usize, @intCast(gu_curr_context))].clear_depth = depth;
}

pub fn sceGuClearStencil(stencil: c_uint) void {
    @setRuntimeSafety(false);
    gu_contexts[@as(usize, @intCast(gu_curr_context))].clear_stencil = stencil;
}

pub fn sceGuClutLoad(num_blocks: c_int, cbp: ?*const anyopaque) void {
    @setRuntimeSafety(false);
    const a = @as(c_int, @intCast(@intFromPtr(cbp)));
    sendCommandi(176, (a) & 0xffffff);
    sendCommandi(177, ((a) >> 8) & 0xf0000);
    sendCommandi(196, num_blocks);
}

pub fn sceGuClutMode(cpsm: types.GuPixelMode, shift: c_int, mask: c_int, a3: c_int) void {
    @setRuntimeSafety(false);
    const argument: c_int = @intFromEnum(cpsm) | (shift << 2) | (mask << 8) | (a3 << 16);
    sendCommandi(197, argument);
}

pub fn sceGuColor(col: c_int) void {
    @setRuntimeSafety(false);
    sceGuMaterial(7, col);
}

pub fn sceGuMaterial(mode: c_int, col: c_int) void {
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

pub fn sceGuColorFunc(func: types.ColorFunc, color: c_int, mask: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(216, @intFromEnum(func) & 0x03);
    sendCommandi(217, color & 0xffffff);
    sendCommandi(218, mask);
}

pub fn sceGuColorMaterial(components: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(83, components);
}

pub fn sceGuCopyImage(psm: types.GuPixelMode, sx: c_int, sy: c_int, width: c_int, height: c_int, srcw: c_int, src: ?*anyopaque, dx: c_int, dy: c_int, destw: c_int, dest: ?*anyopaque) void {
    @setRuntimeSafety(false);
    const sr = @as(c_uint, @intCast(@intFromPtr(src)));
    const ds = @as(c_uint, @intCast(@intFromPtr(dest)));
    sendCommandi(178, @as(c_int, @intCast((sr) & 0xffffff)));
    sendCommandi(179, @as(c_int, @intCast((((sr) & 0xff000000) >> 8))) | srcw);
    sendCommandi(235, (sy << 10) | sx);
    sendCommandi(180, @as(c_int, @intCast((ds) & 0xffffff)));
    sendCommandi(181, @as(c_int, @intCast((((ds) & 0xff000000) >> 8))) | destw);
    sendCommandi(236, (dy << 10) | dx);
    sendCommandi(238, ((height - 1) << 10) | (width - 1));
    if (@intFromEnum(psm) ^ 0x03 != 0) {
        sendCommandi(234, 0);
    } else {
        sendCommandi(234, 1);
    }
}

pub fn sceGuDepthBuffer(zbp: ?*anyopaque, zbw: c_int) void {
    @setRuntimeSafety(false);
    gu_draw_buffer.depth_buffer = zbp;

    if (gu_draw_buffer.depth_width != 0 or (gu_draw_buffer.depth_width != zbw))
        gu_draw_buffer.depth_width = zbw;

    sendCommandi(158, @as(c_int, @intCast((@intFromPtr(zbp)))) & 0xffffff);
    sendCommandi(159, @as(c_int, @intCast(((@as(c_uint, @intCast((@intFromPtr(zbp)))) & 0xff000000) >> 8))) | zbw);
}

pub fn sceGuDepthFunc(function: types.DepthFunc) void {
    @setRuntimeSafety(false);
    sendCommandi(222, @intFromEnum(function));
}

pub fn sceGuDepthMask(mask: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(231, mask);
}

pub fn sceGuDepthOffset(offset: c_uint) void {
    @setRuntimeSafety(false);
    gu_contexts[@as(usize, @intCast(gu_curr_context))].depth_offset = @as(i32, @intCast(offset));
    sceGuDepthRange(gu_contexts[@as(usize, @intCast(gu_curr_context))].near_plane, gu_contexts[@as(usize, @intCast(gu_curr_context))].far_plane);
}

pub fn sceGuDepthRange(near: c_int, far: c_int) void {
    @setRuntimeSafety(false);
    const max = near + far;
    const val = ((max >> 31) + max);
    const z: f32 = @floatFromInt(val >> 1);

    gu_contexts[@as(usize, @intCast(gu_curr_context))].near_plane = near;
    gu_contexts[@as(usize, @intCast(gu_curr_context))].far_plane = far;

    sendCommandf(68, z - (@as(f32, @bitCast(near))));
    sendCommandf(71, z + (@as(f32, @bitCast(gu_contexts[@as(usize, @intCast(gu_curr_context))].depth_offset))));

    if (near > far) {
        sendCommandi(214, far);
        sendCommandi(215, near);
    } else {
        sendCommandi(214, near);
        sendCommandi(215, far);
    }
}

pub fn sceGuDisable(state: types.GuState) void {
    @setRuntimeSafety(false);
    switch (state) {
        .AlphaTest => {
            sendCommandi(34, 0);
        },
        .DepthTest => {
            sendCommandi(35, 0);
        },
        .ScissorTest => {
            gu_contexts[@as(usize, @intCast(gu_curr_context))].scissor_enable = 0;
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
            gu_contexts[@as(usize, @intCast(gu_curr_context))].fragment_2x = 0;
            sendCommandi(201, gu_contexts[@as(usize, @intCast(gu_curr_context))].texture_function);
        },
    }

    const one: u32 = 1;

    if (@intFromEnum(state) < 22)
        gu_states &= @as(i32, @intCast(~(one << @as(u5, @intCast(@intFromEnum(state))))));
}

fn drawRegion(x: c_int, y: c_int, width: c_int, height: c_int) void {
    sendCommandi(21, (y << 10) | x);
    sendCommandi(22, (((y + height) - 1) << 10) | ((x + width) - 1));
}

pub fn sceGuDispBuffer(width: c_int, height: c_int, dispbp: ?*anyopaque, dispbw: c_int) void {
    @setRuntimeSafety(false);
    gu_draw_buffer.width = width;
    gu_draw_buffer.height = height;
    gu_draw_buffer.disp_buffer = dispbp;

    if ((gu_draw_buffer.frame_width != 0) or (gu_draw_buffer.frame_width != dispbw))
        gu_draw_buffer.frame_width = dispbw;

    drawRegion(0, 0, gu_draw_buffer.width, gu_draw_buffer.height);
    _ = pspdisplay.sceDisplaySetMode(.LCD, gu_draw_buffer.width, gu_draw_buffer.height);

    if (gu_psp_on != 0)
        _ = pspdisplay.sceDisplaySetFrameBuf(@as(*anyopaque, @ptrFromInt(@intFromPtr(ge_edram_address) + @intFromPtr(gu_draw_buffer.disp_buffer))), dispbw, gu_draw_buffer.pixel_format, .NextVSync);
}

pub fn sceGuDisplay(state: bool) void {
    if (state) {
        _ = pspdisplay.sceDisplaySetFrameBuf(@as(*anyopaque, @ptrFromInt(@intFromPtr(ge_edram_address) + @intFromPtr(gu_draw_buffer.disp_buffer))), gu_draw_buffer.frame_width, gu_draw_buffer.pixel_format, .NextVSync);
    } else {
        _ = pspdisplay.sceDisplaySetFrameBuf(null, 0, .Format565, .NextVSync);
    }

    gu_psp_on = @intFromBool(state);
}

pub fn sceGuDrawArray(prim: types.GuPrimitive, vtype: types.VertexType, count: c_int, indices: ?*const anyopaque, vertices: ?*const anyopaque) void {
    const vtype_u24: u24 = @bitCast(vtype);

    if (vtype_u24 != 0)
        sendCommandi(18, vtype_u24);

    if (indices != null) {
        sendCommandi(16, @as(c_int, @intCast((@intFromPtr(indices) >> 8))) & 0xf0000);
        sendCommandi(2, @as(c_int, @intCast(@intFromPtr(indices))) & 0xffffff);
    }

    if (vertices != null) {
        sendCommandi(16, @as(c_int, @intCast((@intFromPtr(vertices) >> 8))) & 0xf0000);
        sendCommandi(1, @as(c_int, @intCast(@intFromPtr(vertices))) & 0xffffff);
    }
    sendCommandiStall(4, (@intFromEnum(prim) << 16) | count);
}

pub fn sceGuDrawArrayN(primitive_type: types.GuPrimitive, vertex_type: c_int, count: c_int, a3: c_int, indices: ?*const anyopaque, vertices: ?*const anyopaque) void {
    @setRuntimeSafety(false);
    if (vertex_type != 0)
        sendCommandi(18, vertex_type);

    if (indices != null) {
        sendCommandi(16, @as(c_int, @intCast((@intFromPtr(indices) >> 8))) & 0xf0000);
        sendCommandi(2, @as(c_int, @intCast(@intFromPtr(indices))) & 0xffffff);
    }

    if (vertices != null) {
        sendCommandi(16, @as(c_int, @intCast((@intFromPtr(vertices) >> 8))) & 0xf0000);
        sendCommandi(1, @as(c_int, @intCast(@intFromPtr(vertices))) & 0xffffff);
    }

    if (a3 > 0) {
        var i: usize = @as(usize, @intCast(a3)) - 1;
        while (i >= 0) : (i -= 1) {
            sendCommandi(4, (@intFromEnum(primitive_type) << 16) | count);
        }
        sendCommandiStall(4, (@intFromEnum(primitive_type) << 16) | count);
    }
}

pub fn sceGuDrawBezier(vtype: c_int, ucount: c_int, vcount: c_int, indices: ?*const anyopaque, vertices: ?*const anyopaque) void {
    @setRuntimeSafety(false);
    if (vtype != 0)
        sendCommandi(18, vtype);

    if (indices != null) {
        sendCommandi(16, @as(c_int, @intCast((@intFromPtr(indices) >> 8))) & 0xf0000);
        sendCommandi(2, @as(c_int, @intCast(@intFromPtr(indices))) & 0xffffff);
    }

    if (vertices != null) {
        sendCommandi(16, @as(c_int, @intCast((@intFromPtr(vertices) >> 8))) & 0xf0000);
        sendCommandi(1, @as(c_int, @intCast(@intFromPtr(vertices))) & 0xffffff);
    }

    sendCommandi(5, (vcount << 8) | ucount);
}

pub fn sceGuDrawBuffer(pixel_format: pspdisplay.PspDisplayPixelFormats, fbp: ?*anyopaque, fbw: c_int) void {
    gu_draw_buffer.pixel_format = pixel_format;
    gu_draw_buffer.frame_width = fbw;
    gu_draw_buffer.frame_buffer = fbp;

    if (gu_draw_buffer.depth_buffer != null and gu_draw_buffer.height != 0)
        gu_draw_buffer.depth_buffer = @as(*anyopaque, @ptrFromInt((@intFromPtr(fbp) + @as(usize, @intCast(((gu_draw_buffer.height * fbw) << 2))))));

    if (gu_draw_buffer.depth_width != 0)
        gu_draw_buffer.depth_width = fbw;

    sendCommandi(210, @intFromEnum(pixel_format));
    sendCommandi(156, @as(c_int, @intCast(@as(c_uint, @intCast(@intFromPtr(gu_draw_buffer.frame_buffer))) & 0xffffff)));
    sendCommandi(157, @as(c_int, @intCast(((@as(c_uint, @intCast(@intFromPtr(gu_draw_buffer.frame_buffer))) & 0xff000000) >> 8))) | gu_draw_buffer.frame_width);
    sendCommandi(158, @as(c_int, @intCast(@as(c_uint, @intCast(@intFromPtr(gu_draw_buffer.depth_buffer))) & 0xffffff)));
    sendCommandi(159, @as(c_int, @intCast(((@as(c_uint, @intCast(@intFromPtr(gu_draw_buffer.depth_buffer))) & 0xff000000) >> 8))) | gu_draw_buffer.depth_width);
}

pub fn sceGuDrawBufferList(pixel_format: pspdisplay.PspDisplayPixelFormats, fbp: ?*anyopaque, fbw: c_int) void {
    sendCommandi(210, @intFromEnum(pixel_format));
    sendCommandi(156, @as(c_int, @intCast(@intFromPtr(fbp))) & 0xffffff);
    sendCommandi(157, @as(c_int, @intCast((@as(c_uint, @intCast(@intFromPtr(fbp))) & 0xff000000) >> 8)) | fbw);
}

pub fn sceGuDrawSpline(vtype: c_int, ucount: c_int, vcount: c_int, uedge: c_int, vedge: c_int, indices: ?*const anyopaque, vertices: ?*const anyopaque) void {
    @setRuntimeSafety(false);
    if (vtype != 0)
        sendCommandi(18, vtype);

    if (indices != null) {
        sendCommandi(16, @as(c_int, @intCast((@intFromPtr(indices) >> 8))) & 0xf0000);
        sendCommandi(2, @as(c_int, @intCast(@intFromPtr(indices))) & 0xffffff);
    }

    if (vertices != null) {
        sendCommandi(16, @as(c_int, @intCast((@intFromPtr(vertices) >> 8))) & 0xf0000);
        sendCommandi(1, @as(c_int, @intCast(@intFromPtr(vertices))) & 0xffffff);
    }

    sendCommandi(6, (vedge << 18) | (uedge << 16) | (vcount << 8) | ucount);
}

pub fn sceGuEnable(state: types.GuState) void {
    @setRuntimeSafety(false);
    switch (state) {
        .AlphaTest => {
            sendCommandi(34, 1);
        },
        .DepthTest => {
            sendCommandi(35, 1);
        },
        .ScissorTest => {
            gu_contexts[@as(usize, @intCast(gu_curr_context))].scissor_enable = 1;
            sendCommandi(212, (gu_contexts[@as(usize, @intCast(gu_curr_context))].scissor_start[1] << 10) | gu_contexts[@as(usize, @intCast(gu_curr_context))].scissor_start[0]);
            sendCommandi(213, (gu_contexts[@as(usize, @intCast(gu_curr_context))].scissor_end[1] << 10) | gu_contexts[@as(usize, @intCast(gu_curr_context))].scissor_end[0]);
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
            gu_contexts[@as(usize, @intCast(gu_curr_context))].fragment_2x = 0x10000;
            sendCommandi(201, 0x10000 | gu_contexts[@as(usize, @intCast(gu_curr_context))].texture_function);
        },
    }

    const one: u32 = 1;
    if (@intFromEnum(state) < 22)
        gu_states |= @as(i32, @intCast((one << @as(u5, @intCast(@intFromEnum(state))))));
}

pub fn sceGuEndObject() void {
    @setRuntimeSafety(false);

    const current: [*]u32 = gu_list.?.current;
    gu_list.?.current = @as([*]u32, @ptrCast(&gu_object_stack[@as(usize, @intCast(gu_object_stack_depth)) - 1]));

    sendCommandi(16, @as(c_int, @intCast((@intFromPtr(current) >> 8))) & 0xf0000);
    sendCommandi(9, @as(c_int, @intCast(@intFromPtr(current))) & 0xffffff);

    gu_list.?.current = current;
    gu_object_stack_depth -= 1;
}

pub fn sceGuBeginObject(vtype: c_int, count: c_int, indices: ?*const anyopaque, vertices: ?*const anyopaque) void {
    @setRuntimeSafety(false);
    if (vtype != 0)
        sendCommandi(18, vtype);

    if (indices != null) {
        sendCommandi(16, @as(c_int, @intCast((@intFromPtr(indices) >> 8))) & 0xf0000);
        sendCommandi(2, @as(c_int, @intCast(@intFromPtr(indices))) & 0xffffff);
    }

    if (vertices != null) {
        sendCommandi(16, @as(c_int, @intCast((@intFromPtr(vertices) >> 8))) & 0xf0000);
        sendCommandi(1, @as(c_int, @intCast(@intFromPtr(vertices))) & 0xffffff);
    }
    sendCommandi(7, count);

    gu_object_stack[@as(usize, @intCast(gu_object_stack_depth))] = @as(u32, @intCast(@intFromPtr(gu_list.?.current)));
    gu_object_stack_depth += 1;

    sendCommandi(16, 0);
    sendCommandi(9, 0);
}

pub fn sceGuFinish() c_int {
    switch (@as(types.GuContextType, @enumFromInt(gu_curr_context))) {
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

    const size: u32 = @intFromPtr(gu_list.?.current) - @intFromPtr(gu_list.?.start);

    // go to parent list
    gu_curr_context = gu_list.?.parent_context;
    gu_list = &gu_contexts[@as(usize, @intCast(gu_curr_context))].list;
    return @as(c_int, @intCast(size));
}

pub fn guFinish() void {
    _ = sceGuFinish();
}

pub fn sceGuFinishId(id: c_int) c_int {
    switch (@as(types.GuContextType, @enumFromInt(gu_curr_context))) {
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

    const size: u32 = @intFromPtr(gu_list.?.current) - @intFromPtr(gu_list.?.start);

    // go to parent list
    gu_curr_context = gu_list.?.parent_context;
    gu_list = &gu_contexts[@as(usize, @intCast(gu_curr_context))].list;
    return @as(c_int, @intCast(size));
}

pub fn sceGuFog(near: f32, far: f32, col: c_uint) void {
    @setRuntimeSafety(false);
    var distance: f32 = far - near;
    if (distance > 0)
        distance = 1.0 / distance;

    sendCommandi(207, @as(c_int, @intCast(col & 0xffffff)));
    sendCommandf(205, far);
    sendCommandf(206, distance);
}

pub fn sceGuFrontFace(order: types.FrontFaceDirection) void {
    @setRuntimeSafety(false);
    if (order != types.FrontFaceDirection.Clockwise) {
        sendCommandi(155, 0);
    } else {
        sendCommandi(155, 1);
    }
}

pub fn sceGuGetAllStatus() c_int {
    return gu_states;
}

pub fn sceGuGetStatus(state: types.GuState) c_int {
    if (state < 22)
        return (@intFromEnum(gu_states) >> @as(u5, @intCast(state))) & 1;
    return 0;
}

pub fn sceGuLight(light: u32, light_type: types.GuLightType, components: types.GuLightBitFlags, position: [*c]const ScePspFVector3) void {
    @setRuntimeSafety(false);

    sendCommandf(light_settings[light].xpos, position.*.x);
    sendCommandf(light_settings[light].ypos, position.*.y);
    sendCommandf(light_settings[light].zpos, position.*.z);

    var kind: u24 = 2;
    if (@intFromEnum(components) != 8) {
        if ((@intFromEnum(components) ^ 6) < 1) {
            kind = 1;
        } else {
            kind = 0;
        }
    }

    sendCommandi(light_settings[light].typec, (@as(u24, @intFromEnum(light_type)) << 8) | kind);
}

pub fn sceGuLightAtt(light: usize, atten0: f32, atten1: f32, atten2: f32) void {
    @setRuntimeSafety(false);
    sendCommandf(light_settings[light].constant, atten0);
    sendCommandf(light_settings[light].linear, atten1);
    sendCommandf(light_settings[light].quadratic, atten2);
}

pub fn sceGuLightColor(light: usize, component: types.GuLightBitFlags, col: c_int) void {
    @setRuntimeSafety(false);
    switch (component) {
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
    }
}

pub fn sceGuLightMode(mode: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(94, mode);
}

pub fn sceGuLightSpot(light: usize, direction: [*c]const ScePspFVector3, exponent: f32, cutoff: f32) void {
    @setRuntimeSafety(false);
    sendCommandf(light_settings[light].exponent, exponent);
    sendCommandf(light_settings[light].cutoff, cutoff);
    sendCommandf(light_settings[light].xdir, direction.*.x);
    sendCommandf(light_settings[light].ydir, direction.*.y);
    sendCommandf(light_settings[light].zdir, direction.*.z);
}

pub fn sceGuLogicalOp(op: types.GuLogicalOperation) void {
    @setRuntimeSafety(false);
    sendCommandi(230, @intFromEnum(op) & 0x0f);
}

pub fn sceGuModelColor(emissive: c_int, ambient: c_int, diffuse: c_int, specular: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(84, emissive & 0xffffff);
    sendCommandi(86, diffuse & 0xffffff);
    sendCommandi(85, ambient & 0xffffff);
    sendCommandi(87, specular & 0xffffff);
}

pub fn sceGuMorphWeight(index: c_int, weight: f32) void {
    @setRuntimeSafety(false);
    sendCommandf(44 + index, weight);
}

pub fn sceGuOffset(x: c_int, y: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(76, x << 4);
    sendCommandi(77, y << 4);
}

pub fn sceGuPatchDivide(ulevel: c_int, vlevel: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(54, (vlevel << 8) | ulevel);
}

pub fn sceGuPatchFrontFace(a0: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(56, a0);
}

pub fn sceGuPatchPrim(prim: types.GuPrimitive) void {
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

pub fn sceGuPixelMask(mask: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(232, mask & 0xffffff);
    sendCommandi(233, mask >> 24);
}

pub fn sceGuScissor(x: c_int, y: c_int, w: c_int, h: c_int) void {
    @setRuntimeSafety(false);
    gu_contexts[@as(usize, @intCast(gu_curr_context))].scissor_start[0] = x;
    gu_contexts[@as(usize, @intCast(gu_curr_context))].scissor_start[1] = y;
    gu_contexts[@as(usize, @intCast(gu_curr_context))].scissor_end[0] = w - 1;
    gu_contexts[@as(usize, @intCast(gu_curr_context))].scissor_end[1] = h - 1;

    if (gu_contexts[@as(usize, @intCast(gu_curr_context))].scissor_enable != 0) {
        sendCommandi(212, (gu_contexts[@as(usize, @intCast(gu_curr_context))].scissor_start[1] << 10) | gu_contexts[@as(usize, @intCast(gu_curr_context))].scissor_start[0]);
        sendCommandi(213, (gu_contexts[@as(usize, @intCast(gu_curr_context))].scissor_end[1] << 10) | gu_contexts[@as(usize, @intCast(gu_curr_context))].scissor_end[0]);
    }
}

pub fn sceGuSendCommandf(cmd: c_int, argument: f32) void {
    @setRuntimeSafety(false);
    sendCommandf(cmd, argument);
}

pub fn sceGuSendCommandi(cmd: c_int, argument: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(cmd, argument);
}

pub fn sceGuSendList(mode: c_int, list: ?*const anyopaque, context: [*c]types.pspContext) void {
    @setRuntimeSafety(false);
    gu_settings.signal_offset = 0;
    var args: types.pspListArgs = undefined;
    args.size = 8;
    args.context = context;

    var list_id: i32 = 0;
    const callback = gu_settings.ge_callback_id;

    switch (@as(types.GuQueueMode, @enumFromInt(mode))) {
        .Head => {
            list_id = pspge.sceGeListEnQueueHead(list, null, callback, &args);
        },
        .Tail => {
            list_id = pspge.sceGeListEnQueue(list, null, callback, &args);
        },
    }

    ge_list_executed[1] = list_id;
}

pub fn sceGuSetAllStatus(status: c_int) void {
    @setRuntimeSafety(false);
    var i: c_int = 0;
    while (i < 22) : (i += 1) {
        if ((status >> @as(u5, @intCast(i))) & 1 != 0) {
            sceGuEnable(i);
        } else {
            sceGuDisable(i);
        }
    }
}

pub fn sceGuSetCallback(signal: c_int, callback: ?*const fn (c_int) callconv(.C) void) GuCallback {
    var old_callback: GuCallback = undefined;

    switch (@as(types.GuCallbackId, @enumFromInt(signal))) {
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

pub fn sceGuSetDither(matrix: *const ScePspIMatrix4) void {
    @setRuntimeSafety(false);
    sendCommandi(226, (matrix.x.x & 0x0f) | ((matrix.x.y & 0x0f) << 4) | ((matrix.x.z & 0x0f) << 8) | ((matrix.x.w & 0x0f) << 12));
    sendCommandi(227, (matrix.y.x & 0x0f) | ((matrix.y.y & 0x0f) << 4) | ((matrix.y.z & 0x0f) << 8) | ((matrix.y.w & 0x0f) << 12));
    sendCommandi(228, (matrix.z.x & 0x0f) | ((matrix.z.y & 0x0f) << 4) | ((matrix.z.z & 0x0f) << 8) | ((matrix.z.w & 0x0f) << 12));
    sendCommandi(229, (matrix.w.x & 0x0f) | ((matrix.w.y & 0x0f) << 4) | ((matrix.w.z & 0x0f) << 8) | ((matrix.w.w & 0x0f) << 12));
}

pub fn sceGuSetMatrix(typec: c_int, matrix: [*c]ScePspFMatrix4) void {
    @setRuntimeSafety(false);

    const fmatrix: [*]f32 = @as([*]f32, @ptrCast(matrix));

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

pub fn sceGuSetStatus(state: types.GuState, status: bool) void {
    @setRuntimeSafety(false);
    if (status) {
        sceGuEnable(@intFromEnum(state));
    } else {
        sceGuDisable(@intFromEnum(state));
    }
}

pub fn sceGuShadeModel(mode: types.ShadeModel) void {
    @setRuntimeSafety(false);
    if (mode == types.ShadeModel.Smooth) {
        sendCommandi(80, 1);
    } else {
        sendCommandi(80, 0);
    }
}

pub fn sceGuSignal(signal: c_int, behavior: types.GuSignalBehavior) void {
    @setRuntimeSafety(false);
    sendCommandi(14, ((signal & 0xff) << 16) | (@intFromEnum(behavior) & 0xffff));
    sendCommandi(12, 0);

    if (signal == 3) {
        sendCommandi(15, 0);
        sendCommandi(12, 0);
    }

    sendCommandiStall(0, 0);
}

pub fn sceGuSpecular(power: f32) void {
    @setRuntimeSafety(false);
    sendCommandf(91, power);
}

pub fn sceGuStencilFunc(func: types.StencilFunc, ref: c_int, mask: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(220, @intFromEnum(func) | ((ref & 0xff) << 8) | ((mask & 0xff) << 16));
}

pub fn sceGuStencilOp(fail: types.StencilOperation, zfail: types.StencilOperation, zpass: types.StencilOperation) void {
    @setRuntimeSafety(false);
    sendCommandi(221, @intFromEnum(fail) | (@intFromEnum(zfail) << 8) | (@intFromEnum(zpass) << 16));
}

pub fn sceGuSwapBuffers() ?*anyopaque {
    @setRuntimeSafety(false);
    if (gu_settings.swapBuffersCallback != null) {
        gu_settings.swapBuffersCallback.?(&gu_draw_buffer.disp_buffer, &gu_draw_buffer.frame_buffer);
    } else {
        const temp = gu_draw_buffer.disp_buffer;
        gu_draw_buffer.disp_buffer = gu_draw_buffer.frame_buffer;
        gu_draw_buffer.frame_buffer = temp;
    }

    if (gu_psp_on != 0) {
        _ = pspdisplay.sceDisplaySetFrameBuf(@as(*anyopaque, @ptrFromInt(@intFromPtr(ge_edram_address) + @intFromPtr(gu_draw_buffer.disp_buffer))), gu_draw_buffer.frame_width, gu_draw_buffer.pixel_format, gu_settings.swapBuffersBehaviour);
    }

    gu_current_frame ^= 1;
    return gu_draw_buffer.frame_buffer;
}

pub fn guSwapBuffers() void {
    _ = sceGuSwapBuffers();
}

pub fn guSwapBuffersBehaviour(behaviour: pspdisplay.PspDisplaySetBufSync) void {
    gu_settings.swapBuffersBehaviour = behaviour;
}

pub fn guSwapBuffersCallback(callback: types.GuSwapBuffersCallback) void {
    gu_settings.swapBuffersCallback = callback;
}

pub fn sceGuSync(mode: types.GuSyncMode, sync_type: pspge.PspGeSyncBehavior) pspge.PspGeListState {
    switch (mode) {
        .Finish => {
            return pspge.sceGeDrawSync(sync_type);
        },
        .Signal, .Done => {
            return .Done;
        },
        .List => {
            return pspge.sceGeListSync(ge_list_executed[0], sync_type);
        },
        .Send => {
            return pspge.sceGeListSync(ge_list_executed[1], sync_type);
        },
    }
}

pub fn guSync(mode: types.GuSyncMode, sync_type: pspge.PspGeSyncBehavior) void {
    _ = sceGuSync(mode, sync_type);
}

pub fn sceGuTerm() void {
    @setRuntimeSafety(false);
    _ = libzpsp_threadman.sceKernelDeleteEventFlag(gu_settings.kernel_event_flag);
    _ = pspge.sceGeUnsetCallback(gu_settings.ge_callback_id);
}

pub fn sceGuTexEnvColor(color: c_int) void {
    @setRuntimeSafety(false);
    sendCommandi(202, color & 0xffffff);
}

pub fn sceGuTexFilter(min: types.TextureFilter, mag: types.TextureFilter) void {
    @setRuntimeSafety(false);
    sendCommandi(198, (@intFromEnum(mag) << 8) | @intFromEnum(min));
}

pub fn sceGuTexFlush() void {
    @setRuntimeSafety(false);
    sendCommandf(203, 0.0);
}

pub fn sceGuTexFunc(tfx: types.TextureEffect, tcc: types.TextureColorComponent) void {
    @setRuntimeSafety(false);
    gu_contexts[@as(usize, @intCast(gu_curr_context))].texture_function = (@intFromEnum(tcc) << 8) | @intFromEnum(tfx);
    sendCommandi(201, ((@intFromEnum(tcc) << 8) | @intFromEnum(tfx)) | gu_contexts[@as(usize, @intCast(gu_curr_context))].fragment_2x);
}

const tbpcmd_tbl = [_]u8{ 0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7 };
const tbwcmd_tbl = [_]u8{ 0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0xae, 0xaf };
const tsizecmd_tbl = [_]u8{ 0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf };

fn getExp(val: c_int) c_int {
    @setRuntimeSafety(false);
    var v: c_uint = @as(c_uint, @intCast(val));
    var r: c_uint = ((0xFFFF - v) >> 31) << 4;
    v >>= @as(u5, @intCast(r));
    var shift: c_uint = ((0xFF - v) >> 31) << 3;
    v >>= @as(u5, @intCast(shift));
    r |= shift;

    shift = ((0xF - v) >> 31) << 2;
    v >>= @as(u5, @intCast(shift));
    r |= shift;
    shift = ((0x3 - v) >> 31) << 1;

    return @as(c_int, @intCast(r)) | @as(c_int, @intCast(shift)) | @as(c_int, @intCast((v >> @as(u5, @intCast((shift + 1))))));
}

pub fn sceGuTexImage(mipmap: c_int, width: c_int, height: c_int, tbw: c_int, tbp: ?*const anyopaque) void {
    @setRuntimeSafety(false);
    sendCommandi(tbpcmd_tbl[@as(usize, @intCast(mipmap))], @as(c_int, @intCast(@intFromPtr(tbp))) & 0xffffff);
    sendCommandi(tbwcmd_tbl[@as(usize, @intCast(mipmap))], @as(c_int, @intCast(((@intFromPtr(tbp) >> 8) & 0x0f0000))) | tbw);
    sendCommandi(tsizecmd_tbl[@as(usize, @intCast(mipmap))], getExp(height) << 8 | getExp(width));
    sceGuTexFlush();
}

pub fn sceGuTexLevelMode(mode: types.TextureLevelMode, bias: f32) void {
    @setRuntimeSafety(false);
    var offset: c_int = @as(c_int, @intFromFloat(bias * 16.0));

    if (offset >= 128) {
        offset = 128;
    } else if (offset < -128) {
        offset = -128;
    }
    sendCommandi(200, ((offset) << 16) | @intFromEnum(mode));
}

pub fn sceGuTexMapMode(mode: c_int, a1: c_int, a2: c_int) void {
    @setRuntimeSafety(false);
    gu_contexts[@as(usize, @intCast(gu_curr_context))].texture_map_mode = mode & 0x03;
    sendCommandi(192, gu_contexts[@as(usize, @intCast(gu_curr_context))].texture_proj_map_mode | (mode & 0x03));
    sendCommandi(193, (a2 << 8) | (a1 & 0x03));
}

pub fn sceGuTexMode(tpsm: types.GuPixelMode, maxmips: c_int, a2: c_int, swizzle: c_int) void {
    @setRuntimeSafety(false);
    gu_contexts[@as(usize, @intCast(gu_curr_context))].texture_mode = @intFromEnum(tpsm);

    sendCommandi(194, (maxmips << 16) | (a2 << 8) | (swizzle));
    sendCommandi(195, @intFromEnum(tpsm));
    sceGuTexFlush();
}

pub fn sceGuTexOffset(u: f32, v: f32) void {
    @setRuntimeSafety(false);
    sendCommandf(74, u);
    sendCommandf(75, v);
}

pub fn sceGuTexProjMapMode(mode: c_int) void {
    @setRuntimeSafety(false);
    gu_contexts[@as(usize, @intCast(gu_curr_context))].texture_proj_map_mode = ((mode & 0x03) << 8);
    sendCommandi(192, ((mode & 0x03) << 8) | gu_contexts[@as(usize, @intCast(gu_curr_context))].texture_map_mode);
}

pub fn sceGuTexScale(u: f32, v: f32) void {
    @setRuntimeSafety(false);
    sendCommandf(72, u);
    sendCommandf(73, v);
}

pub fn sceGuTexSlope(slope: f32) void {
    @setRuntimeSafety(false);
    sendCommandf(208, slope);
}

pub fn sceGuTexSync() void {
    @setRuntimeSafety(false);
    sendCommandi(204, 0);
}

pub fn sceGuTexWrap(u: types.GuTexWrapMode, v: types.GuTexWrapMode) void {
    @setRuntimeSafety(false);
    sendCommandi(199, (@intFromEnum(v) << 8) | (@intFromEnum(u)));
}

pub fn sceGuViewport(cx: c_int, cy: c_int, width: c_int, height: c_int) void {
    @setRuntimeSafety(false);
    sendCommandf(66, @as(f32, @floatFromInt(width >> 1)));
    sendCommandf(67, @as(f32, @floatFromInt((-height) >> 1)));
    sendCommandf(69, @as(f32, @floatFromInt(cx)));
    sendCommandf(70, @as(f32, @floatFromInt(cy)));
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

pub fn sceGuInit() void {
    @setRuntimeSafety(false);
    var callback: pspge.PspGeCallbackData = undefined;
    callback.signal_func = callbackSig;
    callback.signal_arg = &gu_settings;
    callback.finish_func = callbackFin;
    callback.finish_arg = &gu_settings;

    gu_settings.ge_callback_id = pspge.sceGeSetCallback(@ptrCast(&callback));
    gu_settings.swapBuffersCallback = null;
    gu_settings.swapBuffersBehaviour = .NextVSync;

    ge_edram_address = pspge.sceGeEdramGetAddr();

    ge_list_executed[0] = pspge.sceGeListEnQueue((@as(*anyopaque, @ptrFromInt(@intFromPtr(&ge_init_list) & 0x1fffffff))), null, gu_settings.ge_callback_id, 0);

    resetValues();
    gu_settings.kernel_event_flag = pspthreadman.sceKernelCreateEventFlag("SceGuSignal", 512, 3, 0);

    _ = pspge.sceGeListSync(ge_list_executed[0], .Wait);
}

pub fn sceGuStart(cont: types.GuContextType, list: ?*anyopaque) void {
    @setRuntimeSafety(false);
    const local_list: [*]u32 = @as([*]u32, @ptrFromInt((@as(usize, @intCast(@intFromPtr(list))) | 0x40000000)));

    const cid: c_int = @intFromEnum(cont);

    gu_contexts[@as(usize, @intCast(cid))].list.start = local_list;
    gu_contexts[@as(usize, @intCast(cid))].list.current = local_list;
    gu_contexts[@as(usize, @intCast(cid))].list.parent_context = gu_curr_context;
    gu_list = &gu_contexts[@as(usize, @intCast(cid))].list;

    gu_curr_context = cid;

    if (cid == 0) {
        ge_list_executed[0] = pspge.sceGeListEnQueue(local_list, local_list, gu_settings.ge_callback_id, 0);
        gu_settings.signal_offset = 0;
    }

    if (gu_init == 0) {
        var dither_matrix = [_]i32{
            -4, 0,  -3, 1,
            2,  -2, 3,  -1,
            -3, 1,  -4, 0,
            3,  -1, 2,  -2,
        };

        sceGuSetDither(@as(*ScePspIMatrix4, @ptrCast(&dither_matrix)));
        sceGuPatchDivide(16, 16);
        sceGuColorMaterial(@intFromEnum(types.GuLightBitFlags.Ambient) | @intFromEnum(types.GuLightBitFlags.Diffuse) | @intFromEnum(types.GuLightBitFlags.Specular));

        sceGuSpecular(1.0);
        sceGuTexScale(1.0, 1.0);
        gu_init = 1;
    }

    if (gu_curr_context == 0) {
        if (gu_draw_buffer.frame_width != 0) {
            sendCommandi(156, @as(c_int, @intCast(@intFromPtr(gu_draw_buffer.frame_buffer))) & 0xffffff);
            sendCommandi(157, (@as(c_int, @intCast((@intFromPtr(gu_draw_buffer.frame_buffer) & 0xff000000))) >> 8) | gu_draw_buffer.frame_width);
        }
    }
}

pub fn sceGuClear(flags: c_int) void {
    const Vertex = extern struct { color: u32, x: u16, y: u16, z: u16, pad: u16 };

    const vertex_type = types.VertexType{
        .color = .Color8888,
        .vertex = .Vertex16Bit,
        .transform = .Transform2D,
    };

    const context: *GuContext = &gu_contexts[@as(usize, @intCast(gu_curr_context))];

    var filter: u32 = 0;
    switch (gu_draw_buffer.pixel_format) {
        .Format565 => {
            filter = context.clear_color & 0xffffff;
        },
        .Format5551 => {
            filter = (context.clear_color & 0xffffff) | (context.clear_stencil << 31);
        },
        .Format4444 => {
            filter = (context.clear_color & 0xffffff) | (context.clear_stencil << 28);
        },
        .Format8888 => {
            filter = (context.clear_color & 0xffffff) | (context.clear_stencil << 24);
        },
    }

    const count: i32 = @divTrunc(gu_draw_buffer.width + 63, 64) * 2;
    const vertices: [*]Vertex = @ptrCast(@alignCast(sceGuGetMemory(@as(c_uint, @intCast(count)) * @sizeOf(Vertex))));

    var i: usize = 0;
    var curr: [*]Vertex = vertices;

    while (i < count) : (i += 1) {
        var j: u16 = 0;
        var k: u16 = 0;

        j = @as(u16, @intCast(i)) >> 1;
        k = (@as(u16, @intCast(i)) & 1);

        curr[i].color = filter;
        curr[i].x = (j + k) * 64;
        curr[i].y = k * @as(u16, @intCast(gu_draw_buffer.height));
        curr[i].z = @as(u16, @intCast(context.clear_depth));
    }

    sendCommandi(211, ((flags & (@intFromEnum(types.ClearBitFlags.ColorBuffer) | @intFromEnum(types.ClearBitFlags.StencilBuffer) | @intFromEnum(types.ClearBitFlags.DepthBuffer))) << 8) | 0x01);

    sceGuDrawArray(.Sprites, vertex_type, @as(c_int, @intCast(count)), null, vertices);
    sendCommandi(211, 0);
}

pub fn sceGuGetMemory(size: c_uint) *anyopaque {
    @setRuntimeSafety(false);
    var siz = size;

    siz += 3;
    siz += (siz >> 31) >> 30;
    siz = (siz >> 2) << 2;

    var orig_ptr: [*]u32 = @as([*]u32, @ptrCast(gu_list.?.current));
    const new_ptr: [*]u32 = @as([*]u32, @ptrFromInt((@as(c_uint, @intCast(@intFromPtr(orig_ptr))) + siz + 8)));

    const lo = (8 << 24) | (@intFromPtr(new_ptr) & 0xffffff);
    const hi = (16 << 24) | ((@intFromPtr(new_ptr) >> 8) & 0xf0000);

    orig_ptr[0] = hi;
    orig_ptr[1] = lo;

    gu_list.?.current = new_ptr;

    if (gu_curr_context == 0) {
        _ = pspge.sceGeListUpdateStallAddr(ge_list_executed[0], new_ptr);
    }
    return @as(*anyopaque, @ptrFromInt(@intFromPtr(orig_ptr + 2)));
}
