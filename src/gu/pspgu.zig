const std = @import("std");

pub const types = @import("pspgutypes.zig");

const c = @import("../c/modules.zig");
pub const ScePspFVector3 = c.types.ScePspFVector3;
pub const ScePspIMatrix4 = c.types.ScePspIMatrix4;
pub const ScePspFMatrix4 = c.types.ScePspFMatrix4;

const ge = @import("../sdk/ge.zig");
const ge_display_list = @import("../ge/list.zig");
const gu_command_buffer = @import("command_buffer.zig");
const CommandBuffer = gu_command_buffer.AssumeCapacityCommandBuffer;
const LightIndex = ge_display_list.LightIndex;
const MatrixTarget = ge_display_list.MatrixTarget;
pub const GuCommand = ge_display_list.Command;
const display = @import("../sdk/display.zig");
const kernel = @import("../sdk/kernel.zig");

pub const GuSwapBuffersCallback = *const fn ([*c]?*anyopaque, [*c]?*anyopaque) void;
pub const GuCallback = *const fn (c_int) void;

const GuSettings = struct {
    sig: ?GuCallback,
    fin: ?GuCallback,
    signal_history: [16]u16,
    signal_offset: i32,
    kernel_event_flag: i32,
    ge_callback_id: i32,

    swapBuffersCallback: ?GuSwapBuffersCallback,
    swapBuffersBehaviour: display.BufSync,
};

const GupspList = struct {
    buffer: CommandBuffer,
    parent_context: u32,
};

const GuContext = struct {
    list: GupspList,
    scissor_enable: i32,
    scissor_start: [2]u24,
    scissor_end: [2]u24,
    near_plane: u16,
    far_plane: u16,
    depth_offset: i32,
    texture_function: ge_display_list.TextureFunction,
    texture_map: ge_display_list.TextureMapState,
    sprite_mode: [4]i32,
    clear_color: u24,
    clear_stencil: u32,
    clear_depth: u16,
    texture_mode: i32,
};

const GuDrawBuffer = struct {
    pixel_format: display.PixelFormat,
    frame_width: u24,
    frame_buffer: ?*anyopaque,
    disp_buffer: ?*anyopaque,
    depth_buffer: ?*anyopaque,
    depth_width: u24,
    width: u24,
    height: u24,
};

var gu_current_frame: u32 = 0;
var gu_contexts: [3]GuContext = undefined;
var ge_list_executed: [2]i32 = undefined;
var ge_edram_address: ?*anyopaque = null;
var gu_settings: GuSettings = undefined;
var gu_list: ?*GupspList = null;
var gu_curr_context: u32 = 0;
var gu_init: i32 = 0;
var gu_psp_on: i32 = 0;
var gu_call_mode: i32 = 0;
var gu_states: u32 = 0;
var gu_draw_buffer: GuDrawBuffer = undefined;

var first_mode: bool = false;
var gu_object_stack: [256]u32 = undefined;
var gu_object_stack_depth: i32 = 0;

pub export fn callbackSig(id: c_int, arg: ?*anyopaque) void {
    var settings: ?*GuSettings = @as(?*GuSettings, @ptrFromInt(@intFromPtr(arg)));
    settings.?.signal_history[@as(usize, @intCast((settings.?.signal_offset))) & 15] = @as(u16, @intCast(id)) & 0xffff;
    settings.?.signal_offset += 1;

    if (settings.?.sig) |signal_cb| {
        signal_cb(id & 0xffff);
    }

    kernel.set_event_flag(settings.?.kernel_event_flag, 1) catch {};
}

pub export fn callbackFin(id: c_int, arg: ?*anyopaque) void {
    const settings: ?*GuSettings = @as(?*GuSettings, @ptrFromInt(@intFromPtr(arg)));
    if (settings.?.fin) |finished_cb| {
        finished_cb(id & 0xffff);
    }
}

pub fn resetValues() void {
    var i: usize = 0;

    gu_init = 0;

    gu_states = 0;
    gu_current_frame = 0;
    gu_object_stack_depth = 0;

    gu_psp_on = 0;
    gu_call_mode = 0;

    gu_draw_buffer.pixel_format = .rgba5551;
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
        gu_contexts[i].texture_function = .{};
        gu_contexts[i].texture_map = .{};
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

fn command_buffer() *CommandBuffer {
    return &gu_list.?.buffer;
}

fn light_index(light: usize) ?LightIndex {
    const index: usize = @intCast(light);
    if (index > 3) return null;
    return @enumFromInt(@as(u2, @intCast(index)));
}

fn matrix_target(typec: c_int) ?MatrixTarget {
    return switch (typec) {
        0 => .projection,
        1 => .view,
        2 => .world,
        3 => .texture,
        else => null,
    };
}

fn update_stall_addr() void {
    if (gu_object_stack_depth == 0 and gu_curr_context == 0) {
        ge_display_list.list_update_stall_addr(ge_list_executed[0], command_buffer().current()) catch {};
    }
}

fn ge_primitive(primitive: types.GuPrimitive) ge_display_list.Primitive {
    return switch (primitive) {
        .Points => .points,
        .Lines => .lines,
        .LineStrip => .line_strip,
        .Triangles => .triangles,
        .TriangleStrip => .triangle_strip,
        .TriangleFan => .triangle_fan,
        .Sprites => .sprites,
    };
}

fn ge_enum(comptime T: type, value: u32) T {
    return @enumFromInt(value);
}

fn ge_enum_signed(comptime T: type, value: c_int) T {
    return ge_enum(T, @intCast(value));
}

fn ge_vector3(value: ScePspFVector3) ge_display_list.Vector3 {
    return .{ .x = value.x, .y = value.y, .z = value.z };
}

fn ge_dither_matrix(matrix: ScePspIMatrix4) ge_display_list.DitherMatrix {
    return .{
        .x = .{ .x = matrix.x.x, .y = matrix.x.y, .z = matrix.x.z, .w = matrix.x.w },
        .y = .{ .x = matrix.y.x, .y = matrix.y.y, .z = matrix.y.z, .w = matrix.y.w },
        .z = .{ .x = matrix.z.x, .y = matrix.z.y, .z = matrix.z.z, .w = matrix.z.w },
        .w = .{ .x = matrix.w.x, .y = matrix.w.y, .z = matrix.w.z, .w = matrix.w.w },
    };
}

fn ge_clear_flags(flags: types.GuClearFlags) ge_display_list.ClearFlags {
    return @bitCast(flags);
}

fn set_enable_state(state: types.GuState, enabled: bool) bool {
    switch (state) {
        .AlphaTest => command_buffer().enable(.alpha_test, enabled),
        .DepthTest => command_buffer().enable(.depth_test, enabled),
        .StencilTest => command_buffer().enable(.stencil_test, enabled),
        .Blend => command_buffer().enable(.alpha_blend, enabled),
        .CullFace => command_buffer().enable(.cull_face, enabled),
        .Dither => command_buffer().enable(.dither, enabled),
        .Fog => command_buffer().enable(.fog, enabled),
        .ClipPlanes => command_buffer().enable(.clip_planes, enabled),
        .Texture2D => command_buffer().enable(.texture_mapping, enabled),
        .Lighting => command_buffer().enable(.lighting, enabled),
        .Light0 => command_buffer().enable(.light0, enabled),
        .Light1 => command_buffer().enable(.light1, enabled),
        .Light2 => command_buffer().enable(.light2, enabled),
        .Light3 => command_buffer().enable(.light3, enabled),
        .LineSmooth => command_buffer().enable(.antialiasing, enabled),
        .PatchCullFace => command_buffer().enable(.patch_cull, enabled),
        .ColorTest => command_buffer().enable(.color_test, enabled),
        .ColorLogicOp => command_buffer().enable(.logical_op, enabled),
        .FaceNormalReverse => command_buffer().enable(.reverse_normals, enabled),
        else => return false,
    }
    return true;
}

//GU IMPLEMENTATION

pub fn sceGuAlphaFunc(func: types.AlphaFunc, value: c_int, mask: c_int) void {
    command_buffer().alpha_test(ge_enum_signed(ge_display_list.CompareFunc, @intFromEnum(func)), @truncate(@as(c_uint, @bitCast(value))), @truncate(@as(c_uint, @bitCast(mask))));
}

pub fn sceGuAmbient(col: u32) void {
    command_buffer().ambient_rgba(col);
}

pub fn sceGuAmbientColor(col: u32) void {
    GuAmbientColor(@truncate(col));
    GuAmbientAlpha(@truncate(col >> 24));
}

pub fn sceGuBlendFunc(bop: types.BlendOp, src: types.BlendFactor, dst: types.BlendFactor, src_fixed_value: u24, dst_fixed_value: u24) void {
    command_buffer().blend_func(
        ge_enum(ge_display_list.BlendOperation, @intFromEnum(bop)),
        ge_enum(ge_display_list.BlendFactor, @intFromEnum(src)),
        ge_enum(ge_display_list.BlendFactor, @intFromEnum(dst)),
        src_fixed_value,
        dst_fixed_value,
    );
}

pub fn sceGuBreak(a0: c_int) void {
    _ = a0;
    //Does nothing or is broken?
}

pub fn sceGuContinue() void {
    //Does nothing or is broken?
}

pub fn sceGuCallList(list: ?*const anyopaque) void {
    const list_addr = @intFromPtr(list);
    if (gu_call_mode == 1) {
        command_buffer().emit_signal_call(list_addr);
        command_buffer().nop();
        update_stall_addr();
    } else {
        command_buffer().call(list_addr);
        update_stall_addr();
    }
}

pub fn sceGuCallMode(mode: c_int) void {
    gu_call_mode = mode;
}

pub fn sceGuCheckList() c_int {
    return @as(c_int, @intCast(command_buffer().used_bytes()));
}

pub fn sceGuClearColor(col: u24) void {
    gu_contexts[gu_curr_context].clear_color = col;
}

pub fn sceGuClearDepth(depth: u16) void {
    gu_contexts[gu_curr_context].clear_depth = depth;
}

pub fn sceGuClearStencil(stencil: c_uint) void {
    gu_contexts[gu_curr_context].clear_stencil = stencil;
}

pub fn sceGuClutLoad(num_blocks: u24, cbp: ?*align(16) const anyopaque) void {
    command_buffer().clut_load(num_blocks, cbp);
}

// NOTE: u24 is probably too wide for most args here
pub fn sceGuClutMode(cpsm: types.GuPixelFormat, shift: u24, mask: u24, a3: u24) void {
    command_buffer().clut_mode(@truncate(@intFromEnum(cpsm)), @truncate(shift), @truncate(mask), @truncate(a3));
}

pub fn sceGuColor(col: u32) void {
    sceGuMaterial(7, col);
}

// NOTE: not pub!
fn GuAmbientColor(ambient_color: u24) void {
    command_buffer().material_ambient_rgb(ambient_color);
}

// NOTE: not pub!
fn GuAmbientAlpha(ambient_alpha: u8) void {
    command_buffer().material_ambient_alpha(ambient_alpha);
}

// NOTE: not pub!
fn GuDiffuseColor(diffuse_color: u24) void {
    command_buffer().material_diffuse_rgb(diffuse_color);
}

// NOTE: not pub!
fn GuSpecularColor(specular_color: u24) void {
    command_buffer().material_specular_rgb(specular_color);
}

pub fn sceGuMaterial(mode: c_int, col: u32) void {
    if (mode & 0x01 != 0) {
        GuAmbientColor(@truncate(col));
        GuAmbientAlpha(@truncate(col >> 24));
    }

    if (mode & 0x02 != 0) {
        GuDiffuseColor(@truncate(col));
    }

    if (mode & 0x04 != 0) {
        GuSpecularColor(@truncate(col));
    }
}

pub fn sceGuColorFunc(func: types.ColorFunc, color: c_int, mask: c_int) void {
    command_buffer().color_test(ge_enum_signed(ge_display_list.ColorTestFunc, @intFromEnum(func)), @truncate(@as(c_uint, @bitCast(color))), @truncate(@as(c_uint, @bitCast(mask))));
}

pub fn sceGuColorMaterial(components: u24) void {
    command_buffer().color_material(components);
}

// NOTE: u24 is probably too wide for most args here
pub fn sceGuCopyImage(psm: types.GuPixelFormat, sx: u24, sy: u24, width: u24, height: u24, srcw: u24, src: ?*anyopaque, dx: u24, dy: u24, destw: u24, dest: ?*anyopaque) void {
    command_buffer().copy_source(src, @intCast(srcw), sx, sy);
    command_buffer().copy_dest(dest, @intCast(destw), dx, dy);
    command_buffer().copy_size(width, height);
    command_buffer().copy_kick((@intFromEnum(psm) ^ 0x03) == 0);
}

pub fn sceGuDepthBuffer(zbp: ?*anyopaque, zbw: u24) void {
    gu_draw_buffer.depth_buffer = zbp;

    if (gu_draw_buffer.depth_width != 0 or (gu_draw_buffer.depth_width != zbw))
        gu_draw_buffer.depth_width = zbw;

    command_buffer().depth_buffer(zbp, @intCast(zbw));
}

pub fn sceGuDepthFunc(function: types.DepthFunc) void {
    command_buffer().depth_func(ge_enum(ge_display_list.CompareFunc, @intFromEnum(function)));
}

pub fn sceGuDepthMask(mask: c_int) void {
    command_buffer().depth_mask(mask != 0);
}

pub fn sceGuDepthOffset(offset: c_uint) void {
    gu_contexts[gu_curr_context].depth_offset = @as(i32, @intCast(offset));
    sceGuDepthRange(gu_contexts[gu_curr_context].near_plane, gu_contexts[gu_curr_context].far_plane);
}

pub fn sceGuDepthRange(near: u16, far: u16) void {
    const max: i32 = near + far;
    const val = ((max >> 31) + max);
    const z: f32 = @floatFromInt(val >> 1);

    gu_contexts[gu_curr_context].near_plane = near;
    gu_contexts[gu_curr_context].far_plane = far;

    command_buffer().depth_scale_position(
        z - @as(f32, @floatFromInt(@as(i32, near))),
        z + @as(f32, @floatFromInt(gu_contexts[gu_curr_context].depth_offset)),
    );

    command_buffer().depth_bounds(near, far);
}

pub fn sceGuDisable(state: types.GuState) void {
    switch (state) {
        .ScissorTest => {
            gu_contexts[gu_curr_context].scissor_enable = 0;
            command_buffer().scissor(0, 0, gu_draw_buffer.width - 1, gu_draw_buffer.height - 1);
        },
        .PatchFace => {
            command_buffer().patch_face(0);
        },
        .Fragment2X => {
            gu_contexts[gu_curr_context].texture_function.fragment_2x = false;
            command_buffer().texture_function(gu_contexts[gu_curr_context].texture_function);
        },
        else => _ = set_enable_state(state, false),
    }

    const one: u32 = 1;

    if (@intFromEnum(state) < 22) {
        gu_states &= @as(u32, @intCast(~(one << @as(u5, @intCast(@intFromEnum(state))))));
    }
}

fn drawRegion(x: u24, y: u24, width: u24, height: u24) void {
    command_buffer().region(x, y, width, height);
}

pub fn sceGuDispBuffer(width: u24, height: u24, dispbp: ?*anyopaque, dispbw: u24) void {
    gu_draw_buffer.width = width;
    gu_draw_buffer.height = height;
    gu_draw_buffer.disp_buffer = dispbp;

    if ((gu_draw_buffer.frame_width != 0) or (gu_draw_buffer.frame_width != dispbw))
        gu_draw_buffer.frame_width = dispbw;

    if (gu_list != null and @intFromPtr(command_buffer().current()) != 0) {
        drawRegion(0, 0, gu_draw_buffer.width, gu_draw_buffer.height);
    }

    if (!first_mode) {
        display.set_mode(.lcd, gu_draw_buffer.width, gu_draw_buffer.height) catch {};
        first_mode = true;
    }

    if (gu_psp_on != 0)
        display.set_frame_buf(@as(?*anyopaque, @ptrFromInt(@intFromPtr(ge_edram_address) + @intFromPtr(gu_draw_buffer.disp_buffer))), dispbw, gu_draw_buffer.pixel_format, .next_vblank) catch {};
}

pub fn sceGuDisplay(state: bool) void {
    if (state) {
        display.set_frame_buf(@as(?*anyopaque, @ptrFromInt(@intFromPtr(ge_edram_address) + @intFromPtr(gu_draw_buffer.disp_buffer))), gu_draw_buffer.frame_width, gu_draw_buffer.pixel_format, .next_vblank) catch {};
    } else {
        display.set_frame_buf(null, 0, .rgb565, .next_vblank) catch {};
    }

    gu_psp_on = @intFromBool(state);
}

pub fn sceGuDrawArray(prim: types.GuPrimitive, vtype: types.VertexType, count: u24, indices: ?*const anyopaque, vertices: ?*const anyopaque) void {
    const vtype_u24: u24 = @bitCast(vtype);

    if (vtype_u24 != 0)
        command_buffer().vertex_type(vtype_u24);

    if (indices != null) {
        command_buffer().index_address(@intFromPtr(indices));
    }

    if (vertices != null) {
        command_buffer().vertex_address(@intFromPtr(vertices));
    }

    command_buffer().primitive(ge_primitive(prim), @intCast(count));
    update_stall_addr();
}

pub fn sceGuDrawArrayN(primitive_type: types.GuPrimitive, vertex_type: c_int, count: c_int, a3: c_int, indices: ?*const anyopaque, vertices: ?*const anyopaque) void {
    if (vertex_type != 0)
        command_buffer().vertex_type(@truncate(@as(c_uint, @bitCast(vertex_type))));

    if (indices != null) {
        command_buffer().index_address(@intFromPtr(indices));
    }

    if (vertices != null) {
        command_buffer().vertex_address(@intFromPtr(vertices));
    }

    if (a3 > 0) {
        var i: usize = @as(usize, @intCast(a3)) - 1;
        while (i >= 0) : (i -= 1) {
            command_buffer().primitive(ge_primitive(primitive_type), @intCast(count));
        }
        command_buffer().primitive(ge_primitive(primitive_type), @intCast(count));
        update_stall_addr();
    }
}

pub fn sceGuDrawBezier(vtype: u24, ucount: c_int, vcount: c_int, indices: ?*const anyopaque, vertices: ?*const anyopaque) void {
    if (vtype != 0)
        command_buffer().vertex_type(vtype);

    if (indices != null) {
        command_buffer().index_address(@intFromPtr(indices));
    }

    if (vertices != null) {
        command_buffer().vertex_address(@intFromPtr(vertices));
    }

    command_buffer().bezier(@intCast(ucount), @intCast(vcount));
}

pub fn sceGuDrawBuffer(pixel_format: display.PixelFormat, fbp: ?*anyopaque, fbw: u24) void {
    gu_draw_buffer.pixel_format = pixel_format;
    gu_draw_buffer.frame_width = fbw;
    gu_draw_buffer.frame_buffer = fbp;

    if (gu_draw_buffer.depth_buffer != null and gu_draw_buffer.height != 0) {
        gu_draw_buffer.depth_buffer = @as(?*anyopaque, @ptrFromInt((@intFromPtr(fbp) + @as(usize, @intCast(((gu_draw_buffer.height * fbw) << 2))))));
    }

    if (gu_draw_buffer.depth_width != 0) {
        gu_draw_buffer.depth_width = fbw;
    }

    command_buffer().pixel_format(ge_enum(ge_display_list.PixelFormat, @intFromEnum(pixel_format)));
    command_buffer().frame_buffer(gu_draw_buffer.frame_buffer, @intCast(gu_draw_buffer.frame_width));
    command_buffer().depth_buffer(gu_draw_buffer.depth_buffer, @intCast(gu_draw_buffer.depth_width));
}

pub fn sceGuDrawBufferList(pixel_format: display.PixelFormat, fbp: ?*anyopaque, fbw: u32) void {
    command_buffer().pixel_format(ge_enum(ge_display_list.PixelFormat, @intFromEnum(pixel_format)));
    command_buffer().frame_buffer(fbp, @intCast(fbw));
}

pub fn sceGuDrawSpline(vtype: u24, ucount: u24, vcount: u24, uedge: u24, vedge: u24, indices: ?*const anyopaque, vertices: ?*const anyopaque) void {
    if (vtype != 0)
        command_buffer().vertex_type(vtype);

    if (indices != null) {
        command_buffer().index_address(@intFromPtr(indices));
    }

    if (vertices != null) {
        command_buffer().vertex_address(@intFromPtr(vertices));
    }

    command_buffer().spline(@intCast(ucount), @intCast(vcount), @enumFromInt(@as(u2, @truncate(uedge))), @enumFromInt(@as(u2, @truncate(vedge))));
}

pub fn sceGuEnable(state: types.GuState) void {
    switch (state) {
        .ScissorTest => {
            gu_contexts[gu_curr_context].scissor_enable = 1;
            command_buffer().scissor(
                gu_contexts[gu_curr_context].scissor_start[0],
                gu_contexts[gu_curr_context].scissor_start[1],
                gu_contexts[gu_curr_context].scissor_end[0],
                gu_contexts[gu_curr_context].scissor_end[1],
            );
        },
        .PatchFace => {
            command_buffer().patch_face(1);
        },
        .Fragment2X => {
            gu_contexts[gu_curr_context].texture_function.fragment_2x = true;
            command_buffer().texture_function(gu_contexts[gu_curr_context].texture_function);
        },
        else => _ = set_enable_state(state, true),
    }

    const one: u32 = 1;
    if (@intFromEnum(state) < 22)
        gu_states |= @as(u32, @intCast((one << @as(u5, @intCast(@intFromEnum(state))))));
}

pub fn sceGuEndObject() void {
    const buffer = command_buffer();
    const current: [*]u32 = buffer.current();
    buffer.seek_to(@as([*]u32, @ptrCast(&gu_object_stack[@as(usize, @intCast(gu_object_stack_depth)) - 1])));

    buffer.bjump(@intFromPtr(current));

    buffer.seek_to(current);
    gu_object_stack_depth -= 1;
}

pub fn sceGuBeginObject(vtype: u24, count: c_int, indices: ?*const anyopaque, vertices: ?*const anyopaque) void {
    if (vtype != 0)
        command_buffer().vertex_type(vtype);

    if (indices != null) {
        command_buffer().index_address(@intFromPtr(indices));
    }

    if (vertices != null) {
        command_buffer().vertex_address(@intFromPtr(vertices));
    }
    command_buffer().bounding_box(@intCast(count));

    gu_object_stack[@as(usize, @intCast(gu_object_stack_depth))] = @as(u32, @intCast(@intFromPtr(command_buffer().current())));
    gu_object_stack_depth += 1;

    command_buffer().bjump(@as(usize, 0));
}

pub fn sceGuFinish() u32 {
    switch (@as(types.GuContextType, @enumFromInt(gu_curr_context))) {
        .Direct, .Send => {
            command_buffer().finish(0);
            command_buffer().end();
            update_stall_addr();
        },

        .Call => {
            if (gu_call_mode == 1) {
                command_buffer().signal(0x12, 0);
                command_buffer().end();
                command_buffer().nop();
                update_stall_addr();
            } else {
                command_buffer().ret();
            }
        },
    }

    const size: u32 = @intCast(command_buffer().used_bytes());

    // go to parent list
    gu_curr_context = gu_list.?.parent_context;
    gu_list = &gu_contexts[gu_curr_context].list;
    return size;
}

pub fn guFinish() void {
    _ = sceGuFinish();
}

pub fn sceGuFinishId(id: c_int) c_int {
    switch (@as(types.GuContextType, @enumFromInt(gu_curr_context))) {
        .Direct, .Send => {
            command_buffer().finish(@truncate(@as(u32, @bitCast(id)) & 0xffff));
            command_buffer().end();
            update_stall_addr();
        },

        .Call => {
            if (gu_call_mode == 1) {
                command_buffer().signal(0x12, 0);
                command_buffer().end();
                command_buffer().nop();
                update_stall_addr();
            } else {
                command_buffer().ret();
            }
        },
    }

    const size: u32 = @intCast(command_buffer().used_bytes());

    // go to parent list
    gu_curr_context = gu_list.?.parent_context;
    gu_list = &gu_contexts[gu_curr_context].list;
    return @as(c_int, @intCast(size));
}

pub fn sceGuFog(near: f32, far: f32, col: c_uint) void {
    command_buffer().fog(near, far, @truncate(col));
}

pub fn sceGuFrontFace(order: types.FrontFaceDirection) void {
    command_buffer().front_face_clockwise(order == types.FrontFaceDirection.Clockwise);
}

pub fn sceGuGetAllStatus() c_int {
    return gu_states;
}

pub fn sceGuGetStatus(state: types.GuState) c_int {
    if (state < 22)
        return (@intFromEnum(gu_states) >> @as(u5, @intCast(state))) & 1;
    return 0;
}

pub fn sceGuLight(light: u32, light_type: types.GuLightType, components: types.GuLightBitFlags, position: *const ScePspFVector3) void {
    const index = light_index(@intCast(light)) orelse return;
    var kind: u2 = 2;
    if (@intFromEnum(components) != 8) {
        if ((@intFromEnum(components) ^ 6) < 1) {
            kind = 1;
        } else {
            kind = 0;
        }
    }

    command_buffer().light(index, ge_enum(ge_display_list.LightType, @intFromEnum(light_type)), kind, ge_vector3(position.*));
}

pub fn sceGuLightAtt(light: usize, atten0: f32, atten1: f32, atten2: f32) void {
    const index = light_index(light) orelse return;
    command_buffer().light_attenuation(index, atten0, atten1, atten2);
}

pub fn sceGuLightColor(light: usize, component: types.GuLightBitFlags, col: u24) void {
    const index = light_index(light) orelse return;
    switch (component) {
        .Ambient => command_buffer().light_color(index, .ambient, col),
        .Diffuse => command_buffer().light_color(index, .diffuse, col),
        .AmbientDiffuse => {
            command_buffer().light_color(index, .ambient, col);
            command_buffer().light_color(index, .diffuse, col);
        },
        .Specular => command_buffer().light_color(index, .specular, col),
        .DiffuseSpecular => {
            command_buffer().light_color(index, .diffuse, col);
            command_buffer().light_color(index, .specular, col);
        },
    }
}

pub fn sceGuLightMode(mode: c_int) void {
    command_buffer().light_mode(@enumFromInt(@as(u1, @truncate(@as(c_uint, @bitCast(mode))))));
}

pub fn sceGuLightSpot(light: usize, direction: [*c]const ScePspFVector3, exponent: f32, cutoff: f32) void {
    const index = light_index(light) orelse return;
    command_buffer().light_spot(index, ge_vector3(direction.*), exponent, cutoff);
}

pub fn sceGuLogicalOp(op: types.GuLogicalOperation) void {
    command_buffer().logical_op(ge_enum_signed(ge_display_list.LogicalOperation, @intFromEnum(op)));
}

pub fn sceGuModelColor(emissive: c_int, ambient: c_int, diffuse: c_int, specular: c_int) void {
    command_buffer().material_emissive_rgb(@truncate(@as(u32, @bitCast(emissive))));

    GuAmbientColor(@truncate(ambient));
    GuDiffuseColor(@truncate(diffuse));
    GuSpecularColor(@truncate(specular));
}

pub fn sceGuMorphWeight(index: u8, weight: f32) void {
    if (index > 7) return;
    command_buffer().morph_weight(@intCast(index), weight);
}

pub fn sceGuOffset(x: u24, y: u24) void {
    command_buffer().screen_offset(x, y);
}

pub fn sceGuPatchDivide(ulevel: u24, vlevel: u24) void {
    command_buffer().patch_divide(ulevel, vlevel);
}

pub fn sceGuPatchFrontFace(a0: u24) void {
    command_buffer().patch_face(a0);
}

pub fn sceGuPatchPrim(prim: types.GuPrimitive) void {
    switch (prim) {
        .Points => {
            command_buffer().patch_primitive(2);
        },
        .LineStrip => {
            command_buffer().patch_primitive(1);
        },
        .TriangleStrip => {
            command_buffer().patch_primitive(0);
        },
        else => {},
    }
}

pub fn sceGuPixelMask(mask: c_int) void {
    command_buffer().pixel_mask(@bitCast(mask));
}

pub fn sceGuScissor(x: u24, y: u24, w: u24, h: u24) void {
    gu_contexts[gu_curr_context].scissor_start[0] = x;
    gu_contexts[gu_curr_context].scissor_start[1] = y;
    gu_contexts[gu_curr_context].scissor_end[0] = w - 1;
    gu_contexts[gu_curr_context].scissor_end[1] = h - 1;

    if (gu_contexts[gu_curr_context].scissor_enable != 0) {
        command_buffer().scissor(
            gu_contexts[gu_curr_context].scissor_start[0],
            gu_contexts[gu_curr_context].scissor_start[1],
            gu_contexts[gu_curr_context].scissor_end[0],
            gu_contexts[gu_curr_context].scissor_end[1],
        );
    }
}

pub fn sceGuSendCommandf(cmd: u8, argument: f32) void {
    command_buffer().emit_raw(cmd, ge_display_list.ge_float(argument));
}

pub fn sceGuSendCommandi(cmd: u8, argument: u24) void {
    command_buffer().emit_raw(cmd, argument);
}

pub fn sceGuSendCommandiStall(cmd: u8, argument: u24) void {
    command_buffer().emit_raw(cmd, argument);
    update_stall_addr();
}

pub fn sceGuSendList(mode: c_int, list: ?*const anyopaque, context: [*c]types.pspContext) void {
    gu_settings.signal_offset = 0;
    var args: types.pspListArgs = undefined;
    args.size = 8;
    args.context = context;

    var list_id: i32 = 0;
    const callback = gu_settings.ge_callback_id;

    switch (@as(types.GuQueueMode, @enumFromInt(mode))) {
        .Head => {
            list_id = ge_display_list.list_enqueue_head(list, null, callback, &args) catch 0;
        },
        .Tail => {
            list_id = ge_display_list.list_enqueue(list, null, callback, &args) catch 0;
        },
    }

    ge_list_executed[1] = list_id;
}

pub fn sceGuSetAllStatus(status: c_int) void {
    var i: c_int = 0;
    while (i < 22) : (i += 1) {
        if ((status >> @as(u5, @intCast(i))) & 1 != 0) {
            sceGuEnable(i);
        } else {
            sceGuDisable(i);
        }
    }
}

pub fn sceGuSetCallback(signal: c_int, callback: ?GuCallback) ?GuCallback {
    var old_callback: ?GuCallback = null;

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
    command_buffer().dither_matrix(ge_dither_matrix(matrix.*));
}

pub fn sceGuSetMatrix(typec: c_int, matrix: [*c]ScePspFMatrix4) void {
    const target = matrix_target(typec) orelse return;
    const values: *const [16]f32 = @ptrCast(matrix);
    command_buffer().load_matrix(target, values);
}

pub fn sceGuSetStatus(state: types.GuState, status: bool) void {
    if (status) {
        sceGuEnable(state);
    } else {
        sceGuDisable(state);
    }
}

pub fn sceGuShadeModel(mode: types.ShadeModel) void {
    command_buffer().shade_model(ge_enum(ge_display_list.ShadeModel, @intFromEnum(mode)));
}

pub fn sceGuSignal(signal: c_int, behavior: types.GuSignalBehavior) void {
    command_buffer().signal(@truncate(@as(c_uint, @bitCast(signal))), @intCast(@intFromEnum(behavior)));
    command_buffer().end();

    if (signal == 3) {
        command_buffer().finish(0);
        command_buffer().end();
    }

    command_buffer().nop();
    update_stall_addr();
}

pub fn sceGuSpecular(power: f32) void {
    command_buffer().specular_power(power);
}

pub fn sceGuStencilFunc(func: types.StencilFunc, ref: c_int, mask: c_int) void {
    command_buffer().stencil_func(ge_enum_signed(ge_display_list.CompareFunc, @intFromEnum(func)), @truncate(@as(c_uint, @bitCast(ref))), @truncate(@as(c_uint, @bitCast(mask))));
}

pub fn sceGuStencilOp(fail: types.StencilOperation, zfail: types.StencilOperation, zpass: types.StencilOperation) void {
    command_buffer().stencil_op(
        ge_enum_signed(ge_display_list.StencilOperation, @intFromEnum(fail)),
        ge_enum_signed(ge_display_list.StencilOperation, @intFromEnum(zfail)),
        ge_enum_signed(ge_display_list.StencilOperation, @intFromEnum(zpass)),
    );
}

pub fn sceGuSwapBuffers() ?*anyopaque {
    if (gu_settings.swapBuffersCallback) |cb| {
        cb(&gu_draw_buffer.disp_buffer, &gu_draw_buffer.frame_buffer);
    } else {
        const temp = gu_draw_buffer.disp_buffer;
        gu_draw_buffer.disp_buffer = gu_draw_buffer.frame_buffer;
        gu_draw_buffer.frame_buffer = temp;
    }

    if (gu_psp_on != 0) {
        display.set_frame_buf(@as(?*anyopaque, @ptrFromInt(@intFromPtr(ge_edram_address) + @intFromPtr(gu_draw_buffer.disp_buffer))), gu_draw_buffer.frame_width, gu_draw_buffer.pixel_format, gu_settings.swapBuffersBehaviour) catch {};
    }

    gu_current_frame ^= 1;
    return gu_draw_buffer.frame_buffer;
}

pub fn guSwapBuffers() void {
    _ = sceGuSwapBuffers();
}

pub fn guSwapBuffersBehaviour(behaviour: display.BufSync) void {
    gu_settings.swapBuffersBehaviour = behaviour;
}

pub fn guSwapBuffersCallback(callback: GuSwapBuffersCallback) void {
    gu_settings.swapBuffersCallback = callback;
}

pub fn sceGuSync(mode: types.GuSyncMode, sync_type: ge.SyncBehavior) ge.ListState {
    switch (mode) {
        .Finish => {
            return ge_display_list.draw_sync(sync_type);
        },
        .Signal, .Done => {
            return .done;
        },
        .List => {
            return ge_display_list.list_sync(ge_list_executed[0], sync_type);
        },
        .Send => {
            return ge_display_list.list_sync(ge_list_executed[1], sync_type);
        },
    }
}

pub fn guSync(mode: types.GuSyncMode, sync_type: ge.SyncBehavior) void {
    _ = sceGuSync(mode, sync_type);
}

pub fn sceGuTerm() void {
    kernel.delete_event_flag(gu_settings.kernel_event_flag) catch {};
    ge.unset_callback(gu_settings.ge_callback_id) catch {};
}

pub fn sceGuTexEnvColor(color: u24) void {
    command_buffer().texture_env_color(color);
}

pub fn sceGuTexFilter(min: types.TextureFilter, mag: types.TextureFilter) void {
    command_buffer().texture_filter(ge_enum(ge_display_list.TextureFilter, @intFromEnum(min)), ge_enum(ge_display_list.TextureFilter, @intFromEnum(mag)));
}

pub fn sceGuTexFlush() void {
    command_buffer().texture_flush();
}

pub fn sceGuTexFunc(tfx: types.TextureEffect, tcc: types.TextureColorComponent) void {
    gu_contexts[gu_curr_context].texture_function.effect = ge_enum(ge_display_list.TextureEffect, @intFromEnum(tfx));
    gu_contexts[gu_curr_context].texture_function.component = ge_enum(ge_display_list.TextureColorComponent, @intFromEnum(tcc));
    command_buffer().texture_function(gu_contexts[gu_curr_context].texture_function);
}

pub fn sceGuTexImage(mipmap: u3, width: u10, height: u10, tbw: u16, tbp: ?*align(16) const anyopaque) void {
    command_buffer().texture_image(@enumFromInt(mipmap), width, height, tbw, tbp);

    sceGuTexFlush();
}

pub fn sceGuTexLevelMode(mode: types.TextureLevelMode, bias: f32) void {
    command_buffer().texture_level_mode(ge_enum_signed(ge_display_list.TextureLevelMode, @intFromEnum(mode)), bias);
}

pub fn sceGuTexMapMode(mode: c_int, a1: c_int, a2: c_int) void {
    gu_contexts[gu_curr_context].texture_map.mode = @enumFromInt(@as(u2, @intCast(mode & 0x03)));
    command_buffer().texture_map_mode(
        gu_contexts[gu_curr_context].texture_map,
        @truncate(@as(c_uint, @bitCast(a1))),
        @truncate(@as(c_uint, @bitCast(a2))),
    );
}

pub fn sceGuTexMode(tpsm: types.GuPixelFormat, maxmips: u24, clut_mode: types.GuClutMode, data_layout: types.GuTextureDataLayout) void {
    gu_contexts[gu_curr_context].texture_mode = @intFromEnum(tpsm);

    command_buffer().texture_mode(
        ge_enum(ge_display_list.TexturePixelFormat, @intFromEnum(tpsm)),
        maxmips,
        ge_enum(ge_display_list.TextureClutMode, @intFromEnum(clut_mode)),
        ge_enum(ge_display_list.TextureDataLayout, @intFromEnum(data_layout)),
    );
    sceGuTexFlush();
}

pub fn sceGuTexOffset(u: f32, v: f32) void {
    command_buffer().texture_offset(u, v);
}

pub fn sceGuTexProjMapMode(mode: c_int) void {
    gu_contexts[gu_curr_context].texture_map.projection = @enumFromInt(@as(u2, @intCast(mode & 0x03)));
    command_buffer().texture_map_state(gu_contexts[gu_curr_context].texture_map);
}

pub fn sceGuTexScale(u: f32, v: f32) void {
    command_buffer().texture_scale(u, v);
}

pub fn sceGuTexSlope(slope: f32) void {
    command_buffer().texture_slope(slope);
}

pub fn sceGuTexSync() void {
    command_buffer().texture_sync();
}

pub fn sceGuTexWrap(u: types.GuTexWrapMode, v: types.GuTexWrapMode) void {
    command_buffer().texture_wrap(ge_enum_signed(ge_display_list.TextureWrapMode, @intFromEnum(u)), ge_enum_signed(ge_display_list.TextureWrapMode, @intFromEnum(v)));
}

pub fn sceGuViewport(cx: c_int, cy: c_int, width: c_int, height: c_int) void {
    command_buffer().viewport(cx, cy, width, height);
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
    const callback_data = ge.CallbackData{
        .signal_func = callbackSig,
        .signal_arg = &gu_settings,
        .finish_func = callbackFin,
        .finish_arg = &gu_settings,
    };

    gu_settings.ge_callback_id = ge.set_callback(callback_data) catch 0;
    gu_settings.swapBuffersCallback = null;
    gu_settings.swapBuffersBehaviour = .next_vblank;

    ge_edram_address = ge.edram_get_addr();

    ge_list_executed[0] = ge_display_list.list_enqueue((@as(?*anyopaque, @ptrFromInt(@intFromPtr(&ge_init_list) & 0x1f_ff_ff_ff))), null, gu_settings.ge_callback_id, null) catch 0;

    resetValues();
    gu_settings.kernel_event_flag = kernel.create_event_flag("SceGuSignal", .wait_multiple, 3, null) catch 0;

    _ = ge_display_list.list_sync(ge_list_executed[0], .wait);
}

pub fn sceGuStart(context_type: types.GuContextType, list: [*]align(16) u32) void {
    const context_index: u32 = @intFromEnum(context_type);
    const local_list: [*]u32 = @as([*]u32, @ptrFromInt((@as(usize, @intCast(@intFromPtr(list))) | 0x40000000)));

    gu_contexts[context_index].list.buffer = CommandBuffer.init_unbounded(local_list, local_list);
    gu_contexts[context_index].list.parent_context = gu_curr_context;
    gu_list = &gu_contexts[context_index].list;

    gu_curr_context = context_index;

    if (context_index == 0) {
        ge_list_executed[0] = ge_display_list.list_enqueue(local_list, local_list, gu_settings.ge_callback_id, null) catch 0;
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
            command_buffer().frame_buffer(gu_draw_buffer.frame_buffer, @intCast(gu_draw_buffer.frame_width));
        }
    }
}

pub fn sceGuClear(clear_flags: types.GuClearFlags) void {
    const Vertex = extern struct { color: u32, x: u16, y: u16, z: u16, pad: u16 };

    const vertex_type = types.VertexType{
        .color = .Color8888,
        .vertex = .Vertex16Bit,
        .transform = .Transform2D,
    };

    const context: *GuContext = &gu_contexts[gu_curr_context];

    var filter: u32 = 0;
    switch (gu_draw_buffer.pixel_format) {
        .rgb565 => {
            filter = @as(u32, context.clear_color);
        },
        .rgba5551 => {
            filter = @as(u32, context.clear_color) | (context.clear_stencil << 31);
        },
        .rgba4444 => {
            filter = @as(u32, context.clear_color) | (context.clear_stencil << 28);
        },
        .rgba8888 => {
            filter = @as(u32, context.clear_color) | (context.clear_stencil << 24);
        },
    }

    const count: u24 = @divTrunc(gu_draw_buffer.width + 63, 64) * 2;
    const vertices: [*]Vertex = @ptrCast(@alignCast(sceGuGetMemory(count * @sizeOf(Vertex))));

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
        curr[i].z = context.clear_depth;
    }

    command_buffer().emit_clear(true, ge_clear_flags(clear_flags));

    sceGuDrawArray(.Sprites, vertex_type, count, null, vertices);
    command_buffer().emit_clear(false, ge_display_list.ClearFlags{});
}

pub fn sceGuGetMemory(size: u32) *anyopaque {
    var siz = size;

    siz += 3;
    siz += (siz >> 31) >> 30; // This looks like a bug!
    siz = (siz >> 2) << 2;

    const buffer = command_buffer();
    const orig_ptr = buffer.current();
    const new_ptr: [*]u32 = @as([*]u32, @ptrFromInt((@as(usize, @intCast(@intFromPtr(orig_ptr))) + siz + 8)));

    buffer.jump(@intFromPtr(new_ptr));
    buffer.seek_to(new_ptr);

    if (gu_curr_context == 0) {
        ge_display_list.list_update_stall_addr(ge_list_executed[0], new_ptr) catch {};
    }
    return @as(*anyopaque, @ptrFromInt(@intFromPtr(orig_ptr + 2)));
}
