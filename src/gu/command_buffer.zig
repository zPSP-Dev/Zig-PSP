const ge_commands = @import("../ge/commands.zig");
const ge_command_buffer = @import("../ge/command_buffer.zig");
const ge_types = @import("../ge/types.zig");

const Command = ge_commands.Command;
const Op = ge_commands.Op;

const CommandBuffer = ge_command_buffer.CommandBuffer;
const DisplayList = ge_command_buffer.DisplayList;
const WriteError = ge_command_buffer.WriteError;
const BlendFactor = ge_types.BlendFactor;
const BlendOperation = ge_types.BlendOperation;
const ClearFlags = ge_types.ClearFlags;
const ColorTestFunc = ge_types.ColorTestFunc;
const CompareFunc = ge_types.CompareFunc;
const DitherMatrix = ge_types.DitherMatrix;
const EnableRegister = ge_types.EnableRegister;
const LightColorComponent = ge_types.LightColorComponent;
const LightIndex = ge_types.LightIndex;
const LightMode = ge_types.LightMode;
const LightType = ge_types.LightType;
const LogicalOperation = ge_types.LogicalOperation;
const MatrixTarget = ge_types.MatrixTarget;
const PixelFormat = ge_types.PixelFormat;
const Primitive = ge_types.Primitive;
const ShadeModel = ge_types.ShadeModel;
const SplineEdges = ge_types.SplineEdges;
const StencilOperation = ge_types.StencilOperation;
const TextureClutMode = ge_types.TextureClutMode;
const TextureDataLayout = ge_types.TextureDataLayout;
const TextureFilter = ge_types.TextureFilter;
const TextureFunction = ge_types.TextureFunction;
const TextureLevel = ge_types.TextureLevel;
const TextureLevelMode = ge_types.TextureLevelMode;
const TextureMapState = ge_types.TextureMapState;
const TexturePixelFormat = ge_types.TexturePixelFormat;
const TextureWrapMode = ge_types.TextureWrapMode;
const Vector3 = ge_types.Vector3;

pub const AssumeCapacityCommandBuffer = struct {
    buffer: CommandBuffer,

    pub fn init(words: []u32) AssumeCapacityCommandBuffer {
        return .{ .buffer = CommandBuffer.init(words) };
    }

    pub fn init_at(start: [*]u32, remaining_words: []u32) AssumeCapacityCommandBuffer {
        return .{ .buffer = CommandBuffer.init_at(start, remaining_words) };
    }

    pub fn init_bytes(start: [*]u32, base: [*]u32, buffer_slice: []u8) AssumeCapacityCommandBuffer {
        return .{ .buffer = CommandBuffer.init_bytes(start, base, buffer_slice) };
    }

    pub fn init_unbounded(start: [*]u32, cursor: [*]u32) AssumeCapacityCommandBuffer {
        return .{ .buffer = CommandBuffer.init_unbounded(start, cursor) };
    }

    pub fn fallible(self: *AssumeCapacityCommandBuffer) *CommandBuffer {
        return &self.buffer;
    }

    pub fn raw(self: *AssumeCapacityCommandBuffer) *DisplayList {
        return self.buffer.raw();
    }

    pub fn seek_to(self: *AssumeCapacityCommandBuffer, cursor: [*]u32) void {
        assume_capacity(self.buffer.seek_to(cursor));
    }

    pub fn current(self: *const AssumeCapacityCommandBuffer) [*]u32 {
        return self.buffer.current();
    }

    pub fn used_bytes(self: AssumeCapacityCommandBuffer) usize {
        return self.buffer.used_bytes();
    }

    pub fn used_words(self: AssumeCapacityCommandBuffer) usize {
        return self.buffer.used_words();
    }

    pub fn emit_command(self: *AssumeCapacityCommandBuffer, command: Command) void {
        assume_capacity(self.buffer.emit_command(command));
    }

    pub fn emit_bits(self: *AssumeCapacityCommandBuffer, comptime op: Op, argument: u24) void {
        assume_capacity(self.buffer.emit_bits(op, argument));
    }

    pub fn emit_truncated(self: *AssumeCapacityCommandBuffer, comptime op: Op, argument: u32) void {
        assume_capacity(self.buffer.emit_truncated(op, argument));
    }

    pub fn emit_empty(self: *AssumeCapacityCommandBuffer, comptime op: Op) void {
        assume_capacity(self.buffer.emit_empty(op));
    }

    pub fn emit_word(self: *AssumeCapacityCommandBuffer, word: u32) void {
        assume_capacity(self.buffer.emit_word(word));
    }

    pub fn emit_raw(self: *AssumeCapacityCommandBuffer, op: u8, argument: u24) void {
        assume_capacity(self.buffer.emit_raw(op, argument));
    }

    pub fn emit_float(self: *AssumeCapacityCommandBuffer, comptime op: Op, argument: f32) void {
        assume_capacity(self.buffer.emit_float(op, argument));
    }

    pub fn emit_clear(self: *AssumeCapacityCommandBuffer, enabled: bool, flags: ClearFlags) void {
        assume_capacity(self.buffer.emit_clear(enabled, flags));
    }

    pub fn blend_func(self: *AssumeCapacityCommandBuffer, operation: BlendOperation, source: BlendFactor, dest: BlendFactor, source_fixed_rgb: u24, dest_fixed_rgb: u24) void {
        assume_capacity(self.buffer.blend_func(operation, source, dest, source_fixed_rgb, dest_fixed_rgb));
    }

    pub fn alpha_test(self: *AssumeCapacityCommandBuffer, function: CompareFunc, value: u8, mask: u8) void {
        assume_capacity(self.buffer.alpha_test(function, value, mask));
    }

    pub fn color_test(self: *AssumeCapacityCommandBuffer, function: ColorTestFunc, color_ref: u24, mask: u24) void {
        assume_capacity(self.buffer.color_test(function, color_ref, mask));
    }

    pub fn ambient_rgba(self: *AssumeCapacityCommandBuffer, rgba: u32) void {
        assume_capacity(self.buffer.ambient_rgba(rgba));
    }

    pub fn material_ambient_rgb(self: *AssumeCapacityCommandBuffer, rgb: u24) void {
        assume_capacity(self.buffer.material_ambient_rgb(rgb));
    }

    pub fn material_ambient_alpha(self: *AssumeCapacityCommandBuffer, alpha: u8) void {
        assume_capacity(self.buffer.material_ambient_alpha(alpha));
    }

    pub fn material_diffuse_rgb(self: *AssumeCapacityCommandBuffer, rgb: u24) void {
        assume_capacity(self.buffer.material_diffuse_rgb(rgb));
    }

    pub fn material_specular_rgb(self: *AssumeCapacityCommandBuffer, rgb: u24) void {
        assume_capacity(self.buffer.material_specular_rgb(rgb));
    }

    pub fn material_emissive_rgb(self: *AssumeCapacityCommandBuffer, rgb: u24) void {
        assume_capacity(self.buffer.material_emissive_rgb(rgb));
    }

    pub fn color_material(self: *AssumeCapacityCommandBuffer, components: u24) void {
        assume_capacity(self.buffer.color_material(components));
    }

    pub fn light(self: *AssumeCapacityCommandBuffer, index: LightIndex, light_type_value: LightType, kind: u2, position: Vector3) void {
        assume_capacity(self.buffer.light(index, light_type_value, kind, position));
    }

    pub fn light_type(self: *AssumeCapacityCommandBuffer, index: LightIndex, light_type_value: LightType, kind: u2) void {
        assume_capacity(self.buffer.light_type(index, light_type_value, kind));
    }

    pub fn light_position(self: *AssumeCapacityCommandBuffer, index: LightIndex, position: Vector3) void {
        assume_capacity(self.buffer.light_position(index, position));
    }

    pub fn light_direction(self: *AssumeCapacityCommandBuffer, index: LightIndex, direction: Vector3) void {
        assume_capacity(self.buffer.light_direction(index, direction));
    }

    pub fn light_attenuation(self: *AssumeCapacityCommandBuffer, index: LightIndex, constant: f32, linear: f32, quadratic: f32) void {
        assume_capacity(self.buffer.light_attenuation(index, constant, linear, quadratic));
    }

    pub fn light_color(self: *AssumeCapacityCommandBuffer, index: LightIndex, component: LightColorComponent, rgb: u24) void {
        assume_capacity(self.buffer.light_color(index, component, rgb));
    }

    pub fn light_mode(self: *AssumeCapacityCommandBuffer, mode: LightMode) void {
        assume_capacity(self.buffer.light_mode(mode));
    }

    pub fn light_spot(self: *AssumeCapacityCommandBuffer, index: LightIndex, direction: Vector3, exponent: f32, cutoff: f32) void {
        assume_capacity(self.buffer.light_spot(index, direction, exponent, cutoff));
    }

    pub fn logical_op(self: *AssumeCapacityCommandBuffer, op: LogicalOperation) void {
        assume_capacity(self.buffer.logical_op(op));
    }

    pub fn depth_func(self: *AssumeCapacityCommandBuffer, function: CompareFunc) void {
        assume_capacity(self.buffer.depth_func(function));
    }

    pub fn depth_mask(self: *AssumeCapacityCommandBuffer, mask: bool) void {
        assume_capacity(self.buffer.depth_mask(mask));
    }

    pub fn depth_scale_position(self: *AssumeCapacityCommandBuffer, scale: f32, position: f32) void {
        assume_capacity(self.buffer.depth_scale_position(scale, position));
    }

    pub fn depth_bounds(self: *AssumeCapacityCommandBuffer, near: u16, far: u16) void {
        assume_capacity(self.buffer.depth_bounds(near, far));
    }

    pub fn copy_source(self: *AssumeCapacityCommandBuffer, pointer: ?*const anyopaque, width: u16, x: u24, y: u24) void {
        assume_capacity(self.buffer.copy_source(pointer, width, x, y));
    }

    pub fn copy_dest(self: *AssumeCapacityCommandBuffer, pointer: ?*const anyopaque, width: u16, x: u24, y: u24) void {
        assume_capacity(self.buffer.copy_dest(pointer, width, x, y));
    }

    pub fn copy_size(self: *AssumeCapacityCommandBuffer, width: u24, height: u24) void {
        assume_capacity(self.buffer.copy_size(width, height));
    }

    pub fn copy_kick(self: *AssumeCapacityCommandBuffer, copy_alpha: bool) void {
        assume_capacity(self.buffer.copy_kick(copy_alpha));
    }

    pub fn fog(self: *AssumeCapacityCommandBuffer, near: f32, far: f32, rgb: u24) void {
        assume_capacity(self.buffer.fog(near, far, rgb));
    }

    pub fn dither_matrix(self: *AssumeCapacityCommandBuffer, matrix: DitherMatrix) void {
        assume_capacity(self.buffer.dither_matrix(matrix));
    }

    pub fn pixel_mask(self: *AssumeCapacityCommandBuffer, mask: u32) void {
        assume_capacity(self.buffer.pixel_mask(mask));
    }

    pub fn stencil_func(self: *AssumeCapacityCommandBuffer, function: CompareFunc, reference: u8, mask: u8) void {
        assume_capacity(self.buffer.stencil_func(function, reference, mask));
    }

    pub fn stencil_op(self: *AssumeCapacityCommandBuffer, fail: StencilOperation, depth_fail: StencilOperation, depth_pass: StencilOperation) void {
        assume_capacity(self.buffer.stencil_op(fail, depth_fail, depth_pass));
    }

    pub fn texture_filter(self: *AssumeCapacityCommandBuffer, min: TextureFilter, mag: TextureFilter) void {
        assume_capacity(self.buffer.texture_filter(min, mag));
    }

    pub fn texture_function(self: *AssumeCapacityCommandBuffer, function: TextureFunction) void {
        assume_capacity(self.buffer.texture_function(function));
    }

    pub fn texture_flush(self: *AssumeCapacityCommandBuffer) void {
        assume_capacity(self.buffer.texture_flush());
    }

    pub fn texture_level_mode(self: *AssumeCapacityCommandBuffer, mode: TextureLevelMode, bias: f32) void {
        assume_capacity(self.buffer.texture_level_mode(mode, bias));
    }

    pub fn texture_map_mode(self: *AssumeCapacityCommandBuffer, state: TextureMapState, a1: u2, a2: u8) void {
        assume_capacity(self.buffer.texture_map_mode(state, a1, a2));
    }

    pub fn texture_map_state(self: *AssumeCapacityCommandBuffer, state: TextureMapState) void {
        assume_capacity(self.buffer.texture_map_state(state));
    }

    pub fn texture_mode(self: *AssumeCapacityCommandBuffer, psm: TexturePixelFormat, max_mips: u24, clut_mode_value: TextureClutMode, data_layout: TextureDataLayout) void {
        assume_capacity(self.buffer.texture_mode(psm, max_mips, clut_mode_value, data_layout));
    }

    pub fn texture_sync(self: *AssumeCapacityCommandBuffer) void {
        assume_capacity(self.buffer.texture_sync());
    }

    pub fn texture_wrap(self: *AssumeCapacityCommandBuffer, u: TextureWrapMode, v: TextureWrapMode) void {
        assume_capacity(self.buffer.texture_wrap(u, v));
    }

    pub fn texture_env_color(self: *AssumeCapacityCommandBuffer, rgb: u24) void {
        assume_capacity(self.buffer.texture_env_color(rgb));
    }

    pub fn texture_offset(self: *AssumeCapacityCommandBuffer, u: f32, v: f32) void {
        assume_capacity(self.buffer.texture_offset(u, v));
    }

    pub fn texture_scale(self: *AssumeCapacityCommandBuffer, u: f32, v: f32) void {
        assume_capacity(self.buffer.texture_scale(u, v));
    }

    pub fn texture_slope(self: *AssumeCapacityCommandBuffer, slope: f32) void {
        assume_capacity(self.buffer.texture_slope(slope));
    }

    pub fn shade_model(self: *AssumeCapacityCommandBuffer, mode: ShadeModel) void {
        assume_capacity(self.buffer.shade_model(mode));
    }

    pub fn specular_power(self: *AssumeCapacityCommandBuffer, power: f32) void {
        assume_capacity(self.buffer.specular_power(power));
    }

    pub fn morph_weight(self: *AssumeCapacityCommandBuffer, index: u3, weight: f32) void {
        assume_capacity(self.buffer.morph_weight(index, weight));
    }

    pub fn screen_offset(self: *AssumeCapacityCommandBuffer, x: u24, y: u24) void {
        assume_capacity(self.buffer.screen_offset(x, y));
    }

    pub fn patch_divide(self: *AssumeCapacityCommandBuffer, u_level: u24, v_level: u24) void {
        assume_capacity(self.buffer.patch_divide(u_level, v_level));
    }

    pub fn patch_face(self: *AssumeCapacityCommandBuffer, value: u24) void {
        assume_capacity(self.buffer.patch_face(value));
    }

    pub fn patch_primitive(self: *AssumeCapacityCommandBuffer, value: u2) void {
        assume_capacity(self.buffer.patch_primitive(value));
    }

    pub fn front_face_clockwise(self: *AssumeCapacityCommandBuffer, enabled: bool) void {
        assume_capacity(self.buffer.front_face_clockwise(enabled));
    }

    pub fn viewport(self: *AssumeCapacityCommandBuffer, cx: i32, cy: i32, width: i32, height: i32) void {
        assume_capacity(self.buffer.viewport(cx, cy, width, height));
    }

    pub fn load_matrix(self: *AssumeCapacityCommandBuffer, target: MatrixTarget, values: *const [16]f32) void {
        assume_capacity(self.buffer.load_matrix(target, values));
    }

    pub fn projection_matrix(self: *AssumeCapacityCommandBuffer, values: *const [16]f32) void {
        assume_capacity(self.buffer.projection_matrix(values));
    }

    pub fn view_matrix(self: *AssumeCapacityCommandBuffer, values: *const [16]f32) void {
        assume_capacity(self.buffer.view_matrix(values));
    }

    pub fn world_matrix(self: *AssumeCapacityCommandBuffer, values: *const [16]f32) void {
        assume_capacity(self.buffer.world_matrix(values));
    }

    pub fn texture_matrix(self: *AssumeCapacityCommandBuffer, values: *const [16]f32) void {
        assume_capacity(self.buffer.texture_matrix(values));
    }

    pub fn clut_mode(self: *AssumeCapacityCommandBuffer, format: u2, shift: u6, mask: u8, start: u8) void {
        assume_capacity(self.buffer.clut_mode(format, shift, mask, start));
    }

    pub fn clut_load(self: *AssumeCapacityCommandBuffer, num_blocks: u24, pointer: ?*const anyopaque) void {
        assume_capacity(self.buffer.clut_load(num_blocks, pointer));
    }

    pub fn nop(self: *AssumeCapacityCommandBuffer) void {
        assume_capacity(self.buffer.nop());
    }

    pub fn base_address(self: *AssumeCapacityCommandBuffer, address: usize) void {
        assume_capacity(self.buffer.base_address(address));
    }

    pub fn pointer_base(self: *AssumeCapacityCommandBuffer, address: usize) void {
        assume_capacity(self.buffer.pointer_base(address));
    }

    pub fn vertex_address(self: *AssumeCapacityCommandBuffer, address: usize) void {
        assume_capacity(self.buffer.vertex_address(address));
    }

    pub fn index_address(self: *AssumeCapacityCommandBuffer, address: usize) void {
        assume_capacity(self.buffer.index_address(address));
    }

    pub fn jump(self: *AssumeCapacityCommandBuffer, address: usize) void {
        assume_capacity(self.buffer.jump(address));
    }

    pub fn bjump(self: *AssumeCapacityCommandBuffer, address: usize) void {
        assume_capacity(self.buffer.bjump(address));
    }

    pub fn call(self: *AssumeCapacityCommandBuffer, address: usize) void {
        assume_capacity(self.buffer.call(address));
    }

    pub fn ret(self: *AssumeCapacityCommandBuffer) void {
        assume_capacity(self.buffer.ret());
    }

    pub fn end(self: *AssumeCapacityCommandBuffer) void {
        assume_capacity(self.buffer.end());
    }

    pub fn end_argument(self: *AssumeCapacityCommandBuffer, argument: u16) void {
        assume_capacity(self.buffer.end_argument(argument));
    }

    pub fn signal(self: *AssumeCapacityCommandBuffer, index: u8, argument: u16) void {
        assume_capacity(self.buffer.signal(index, argument));
    }

    pub fn emit_signal_call(self: *AssumeCapacityCommandBuffer, address: usize) void {
        assume_capacity(self.buffer.emit_signal_call(address));
    }

    pub fn finish(self: *AssumeCapacityCommandBuffer, id: u16) void {
        assume_capacity(self.buffer.finish(id));
    }

    pub fn primitive(self: *AssumeCapacityCommandBuffer, primitive_type: Primitive, vertex_count: u16) void {
        assume_capacity(self.buffer.primitive(primitive_type, vertex_count));
    }

    pub fn bezier(self: *AssumeCapacityCommandBuffer, u_count: u8, v_count: u8) void {
        assume_capacity(self.buffer.bezier(u_count, v_count));
    }

    pub fn spline(self: *AssumeCapacityCommandBuffer, u_count: u8, v_count: u8, u_edges: SplineEdges, v_edges: SplineEdges) void {
        assume_capacity(self.buffer.spline(u_count, v_count, u_edges, v_edges));
    }

    pub fn bounding_box(self: *AssumeCapacityCommandBuffer, vertex_count: u16) void {
        assume_capacity(self.buffer.bounding_box(vertex_count));
    }

    pub fn vertex_type(self: *AssumeCapacityCommandBuffer, value: u24) void {
        assume_capacity(self.buffer.vertex_type(value));
    }

    pub fn pixel_format(self: *AssumeCapacityCommandBuffer, value: PixelFormat) void {
        assume_capacity(self.buffer.pixel_format(value));
    }

    pub fn enable(self: *AssumeCapacityCommandBuffer, register: EnableRegister, enabled: bool) void {
        assume_capacity(self.buffer.enable(register, enabled));
    }

    pub fn region_start(self: *AssumeCapacityCommandBuffer, x: u10, y: u10) void {
        assume_capacity(self.buffer.region_start(x, y));
    }

    pub fn region_end(self: *AssumeCapacityCommandBuffer, x: u10, y: u10) void {
        assume_capacity(self.buffer.region_end(x, y));
    }

    pub fn region(self: *AssumeCapacityCommandBuffer, x: u24, y: u24, width: u24, height: u24) void {
        assume_capacity(self.buffer.region(x, y, width, height));
    }

    pub fn scissor_start(self: *AssumeCapacityCommandBuffer, x: u10, y: u10) void {
        assume_capacity(self.buffer.scissor_start(x, y));
    }

    pub fn scissor_end(self: *AssumeCapacityCommandBuffer, x: u10, y: u10) void {
        assume_capacity(self.buffer.scissor_end(x, y));
    }

    pub fn scissor(self: *AssumeCapacityCommandBuffer, start_x: u24, start_y: u24, end_x: u24, end_y: u24) void {
        assume_capacity(self.buffer.scissor(start_x, start_y, end_x, end_y));
    }

    pub fn frame_buffer(self: *AssumeCapacityCommandBuffer, pointer: ?*const anyopaque, width: u16) void {
        assume_capacity(self.buffer.frame_buffer(pointer, width));
    }

    pub fn depth_buffer(self: *AssumeCapacityCommandBuffer, pointer: ?*const anyopaque, width: u16) void {
        assume_capacity(self.buffer.depth_buffer(pointer, width));
    }

    pub fn texture_buffer(self: *AssumeCapacityCommandBuffer, level: TextureLevel, pointer: ?*const anyopaque, width: u16) void {
        assume_capacity(self.buffer.texture_buffer(level, pointer, width));
    }

    pub fn texture_size(self: *AssumeCapacityCommandBuffer, level: TextureLevel, width_exp: u8, height_exp: u8) void {
        assume_capacity(self.buffer.texture_size(level, width_exp, height_exp));
    }

    pub fn texture_image(self: *AssumeCapacityCommandBuffer, level: TextureLevel, width: u10, height: u10, buffer_width: u16, pointer: ?*const anyopaque) void {
        assume_capacity(self.buffer.texture_image(level, width, height, buffer_width, pointer));
    }
};

fn assume_capacity(result: WriteError!void) void {
    result catch |err| panic_write_error(err);
}

fn panic_write_error(err: WriteError) noreturn {
    switch (err) {
        error.BufferOverflow => @panic("GE command buffer overflow"),
        error.InvalidSeek => @panic("GE command buffer invalid seek"),
    }
}
