const std = @import("std");
const commands = @import("commands.zig");
const display_list = @import("display_list.zig");
const types = @import("types.zig");

const Op = commands.Op;
const Command = commands.Command;
const CommandArgument = commands.CommandArgument;
pub const ClearFlags = types.ClearFlags;
const ClearArgument = commands.ClearArgument;
const ClutModeArgument = commands.ClutModeArgument;
pub const EnableRegister = types.EnableRegister;
const EndArgument = commands.EndArgument;
const EmptyArgument = commands.EmptyArgument;
const FinishArgument = commands.FinishArgument;
const SignalArgument = commands.SignalArgument;
const TruncatedFloat = commands.TruncatedFloat;
pub const Primitive = types.Primitive;
const PrimitiveArgument = commands.PrimitiveArgument;
const BezierArgument = commands.BezierArgument;
const SplineArgument = commands.SplineArgument;
pub const SplineEdges = types.SplineEdges;
const CountArgument = commands.CountArgument;
const CoordinateArgument = commands.CoordinateArgument;
pub const TextureLevel = types.TextureLevel;
const TextureSizeArgument = commands.TextureSizeArgument;
pub const BlendFactor = types.BlendFactor;
pub const BlendOperation = types.BlendOperation;
pub const ColorTestFunc = types.ColorTestFunc;
pub const CompareFunc = types.CompareFunc;
pub const DitherMatrix = types.DitherMatrix;
pub const DitherRow = types.DitherRow;
pub const LightColorComponent = types.LightColorComponent;
pub const LightIndex = types.LightIndex;
pub const LightMode = types.LightMode;
pub const LightType = types.LightType;
pub const LogicalOperation = types.LogicalOperation;
pub const MatrixTarget = types.MatrixTarget;
pub const PixelFormat = types.PixelFormat;
pub const ShadeModel = types.ShadeModel;
pub const StencilOperation = types.StencilOperation;
pub const TextureClutMode = types.TextureClutMode;
pub const TextureColorComponent = types.TextureColorComponent;
pub const TextureDataLayout = types.TextureDataLayout;
pub const TextureEffect = types.TextureEffect;
pub const TextureFilter = types.TextureFilter;
pub const TextureFunction = types.TextureFunction;
pub const TextureLevelMode = types.TextureLevelMode;
pub const TextureMapState = types.TextureMapState;
pub const TextureMapMode = types.TextureMapMode;
pub const TexturePixelFormat = types.TexturePixelFormat;
pub const TextureProjectionMapMode = types.TextureProjectionMapMode;
pub const TextureWrapMode = types.TextureWrapMode;
pub const Vector3 = types.Vector3;

const encode_raw = commands.encode_raw;
const command_argument = commands.command_argument;
const ptr_value = commands.ptr_value;
const low_address_bits = commands.low_address_bits;
const high_address_bits = commands.high_address_bits;
const high_buffer_address_bits = commands.high_buffer_address_bits;

pub const WriteError = display_list.WriteError;
pub const DisplayList = display_list.DisplayList;

pub const CommandBuffer = struct {
    list: DisplayList,

    pub fn init(words: []u32) CommandBuffer {
        return .{ .list = DisplayList.init(words) };
    }

    pub fn init_at(start: [*]u32, remaining_words: []u32) CommandBuffer {
        return .{ .list = DisplayList.init_at(start, remaining_words) };
    }

    pub fn init_bytes(start: [*]u32, base: [*]u32, buffer_slice: []u8) CommandBuffer {
        return .{ .list = DisplayList.init_bytes(start, base, buffer_slice) };
    }

    pub fn init_unbounded(start: [*]u32, cursor: [*]u32) CommandBuffer {
        return .{ .list = DisplayList.init_unbounded(start, cursor) };
    }

    pub fn raw(self: *CommandBuffer) *DisplayList {
        return &self.list;
    }

    pub fn seek_to(self: *CommandBuffer, cursor: [*]u32) WriteError!void {
        try self.list.seek_to(cursor);
    }

    pub fn current(self: *const CommandBuffer) [*]u32 {
        return self.list.current();
    }

    pub fn used_bytes(self: CommandBuffer) usize {
        return self.list.used_bytes();
    }

    pub fn used_words(self: CommandBuffer) usize {
        return self.list.used_words();
    }

    pub fn emit_command(self: *CommandBuffer, command: Command) WriteError!void {
        try self.list.write_command(command);
    }

    pub fn emit_bits(self: *CommandBuffer, comptime op: Op, argument: u24) WriteError!void {
        assert_bits_command(op);
        try self.emit_command(@unionInit(Command, @tagName(op), commands.payload(op, argument)));
    }

    pub fn emit_truncated(self: *CommandBuffer, comptime op: Op, argument: u32) WriteError!void {
        try self.emit_bits(op, @truncate(argument));
    }

    pub fn emit_empty(self: *CommandBuffer, comptime op: Op) WriteError!void {
        if (CommandArgument(op) != EmptyArgument) {
            @compileError("GE command " ++ @tagName(op) ++ " does not take an empty argument");
        }
        try self.emit_command(@unionInit(Command, @tagName(op), EmptyArgument{}));
    }

    pub fn emit_word(self: *CommandBuffer, word: u32) WriteError!void {
        try self.list.write_word(word);
    }

    pub fn emit_raw(self: *CommandBuffer, op: u8, argument: u24) WriteError!void {
        try self.list.write_raw(op, argument);
    }

    pub fn emit_float(self: *CommandBuffer, comptime op: Op, argument: f32) WriteError!void {
        if (CommandArgument(op) != TruncatedFloat) {
            @compileError("GE command " ++ @tagName(op) ++ " does not take a float argument");
        }
        try self.emit_command(@unionInit(Command, @tagName(op), command_argument(op, argument)));
    }

    pub fn emit_clear(self: *CommandBuffer, enabled: bool, flags: ClearFlags) WriteError!void {
        try self.emit_command(.{ .clear = ClearArgument{ .enable = enabled, .flags = flags } });
    }

    pub fn blend_func(self: *CommandBuffer, operation: BlendOperation, source: BlendFactor, dest: BlendFactor, source_fixed_rgb: u24, dest_fixed_rgb: u24) WriteError!void {
        const argument = @as(u24, @intFromEnum(source)) | (@as(u24, @intFromEnum(dest)) << 4) | (@as(u24, @intFromEnum(operation)) << 8);
        try self.emit_bits(.alpha, argument);
        try self.emit_bits(.sfix, source_fixed_rgb);
        try self.emit_bits(.dfix, dest_fixed_rgb);
    }

    pub fn alpha_test(self: *CommandBuffer, function: CompareFunc, value: u8, mask: u8) WriteError!void {
        const argument = @as(u24, @intFromEnum(function)) | (@as(u24, value) << 8) | (@as(u24, mask) << 16);
        try self.emit_bits(.atst, argument);
    }

    pub fn color_test(self: *CommandBuffer, function: ColorTestFunc, color_ref: u24, mask: u24) WriteError!void {
        try self.emit_bits(.ctst, @intFromEnum(function));
        try self.emit_bits(.cref, color_ref);
        try self.emit_bits(.cmsk, mask);
    }

    pub fn ambient_rgba(self: *CommandBuffer, rgba: u32) WriteError!void {
        try self.emit_bits(.alc, @truncate(rgba));
        try self.emit_bits(.ala, @truncate(rgba >> 24));
    }

    pub fn material_ambient_rgb(self: *CommandBuffer, rgb: u24) WriteError!void {
        try self.emit_bits(.amc, rgb);
    }

    pub fn material_ambient_alpha(self: *CommandBuffer, alpha: u8) WriteError!void {
        try self.emit_bits(.ama, alpha);
    }

    pub fn material_diffuse_rgb(self: *CommandBuffer, rgb: u24) WriteError!void {
        try self.emit_bits(.dmc, rgb);
    }

    pub fn material_specular_rgb(self: *CommandBuffer, rgb: u24) WriteError!void {
        try self.emit_bits(.smc, rgb);
    }

    pub fn material_emissive_rgb(self: *CommandBuffer, rgb: u24) WriteError!void {
        try self.emit_bits(.emc, rgb);
    }

    pub fn color_material(self: *CommandBuffer, components: u24) WriteError!void {
        try self.emit_bits(.cmat, components);
    }

    pub fn light(self: *CommandBuffer, index: LightIndex, light_type_value: LightType, kind: u2, position: Vector3) WriteError!void {
        try self.light_position(index, position);
        try self.light_type(index, light_type_value, kind);
    }

    pub fn light_type(self: *CommandBuffer, index: LightIndex, light_type_value: LightType, kind: u2) WriteError!void {
        const argument = (@as(u24, @intFromEnum(light_type_value)) << 8) | kind;
        switch (index) {
            .light0 => try self.emit_bits(.lt0, argument),
            .light1 => try self.emit_bits(.lt1, argument),
            .light2 => try self.emit_bits(.lt2, argument),
            .light3 => try self.emit_bits(.lt3, argument),
        }
    }

    pub fn light_position(self: *CommandBuffer, index: LightIndex, position: Vector3) WriteError!void {
        switch (index) {
            .light0 => {
                try self.emit_float(.lxp0, position.x);
                try self.emit_float(.lyp0, position.y);
                try self.emit_float(.lzp0, position.z);
            },
            .light1 => {
                try self.emit_float(.lxp1, position.x);
                try self.emit_float(.lyp1, position.y);
                try self.emit_float(.lzp1, position.z);
            },
            .light2 => {
                try self.emit_float(.lxp2, position.x);
                try self.emit_float(.lyp2, position.y);
                try self.emit_float(.lzp2, position.z);
            },
            .light3 => {
                try self.emit_float(.lxp3, position.x);
                try self.emit_float(.lyp3, position.y);
                try self.emit_float(.lzp3, position.z);
            },
        }
    }

    pub fn light_direction(self: *CommandBuffer, index: LightIndex, direction: Vector3) WriteError!void {
        switch (index) {
            .light0 => {
                try self.emit_float(.lxd0, direction.x);
                try self.emit_float(.lyd0, direction.y);
                try self.emit_float(.lzd0, direction.z);
            },
            .light1 => {
                try self.emit_float(.lxd1, direction.x);
                try self.emit_float(.lyd1, direction.y);
                try self.emit_float(.lzd1, direction.z);
            },
            .light2 => {
                try self.emit_float(.lxd2, direction.x);
                try self.emit_float(.lyd2, direction.y);
                try self.emit_float(.lzd2, direction.z);
            },
            .light3 => {
                try self.emit_float(.lxd3, direction.x);
                try self.emit_float(.lyd3, direction.y);
                try self.emit_float(.lzd3, direction.z);
            },
        }
    }

    pub fn light_attenuation(self: *CommandBuffer, index: LightIndex, constant: f32, linear: f32, quadratic: f32) WriteError!void {
        switch (index) {
            .light0 => {
                try self.emit_float(.lca0, constant);
                try self.emit_float(.lla0, linear);
                try self.emit_float(.lqa0, quadratic);
            },
            .light1 => {
                try self.emit_float(.lca1, constant);
                try self.emit_float(.lla1, linear);
                try self.emit_float(.lqa1, quadratic);
            },
            .light2 => {
                try self.emit_float(.lca2, constant);
                try self.emit_float(.lla2, linear);
                try self.emit_float(.lqa2, quadratic);
            },
            .light3 => {
                try self.emit_float(.lca3, constant);
                try self.emit_float(.lla3, linear);
                try self.emit_float(.lqa3, quadratic);
            },
        }
    }

    pub fn light_color(self: *CommandBuffer, index: LightIndex, component: LightColorComponent, rgb: u24) WriteError!void {
        switch (index) {
            .light0 => switch (component) {
                .ambient => try self.emit_bits(.alc0, rgb),
                .diffuse => try self.emit_bits(.dlc0, rgb),
                .specular => try self.emit_bits(.slc0, rgb),
            },
            .light1 => switch (component) {
                .ambient => try self.emit_bits(.alc1, rgb),
                .diffuse => try self.emit_bits(.dlc1, rgb),
                .specular => try self.emit_bits(.slc1, rgb),
            },
            .light2 => switch (component) {
                .ambient => try self.emit_bits(.alc2, rgb),
                .diffuse => try self.emit_bits(.dlc2, rgb),
                .specular => try self.emit_bits(.slc2, rgb),
            },
            .light3 => switch (component) {
                .ambient => try self.emit_bits(.alc3, rgb),
                .diffuse => try self.emit_bits(.dlc3, rgb),
                .specular => try self.emit_bits(.slc3, rgb),
            },
        }
    }

    pub fn light_mode(self: *CommandBuffer, mode: LightMode) WriteError!void {
        try self.emit_bits(.lmode, @intFromEnum(mode));
    }

    pub fn light_spot(self: *CommandBuffer, index: LightIndex, direction: Vector3, exponent: f32, cutoff: f32) WriteError!void {
        switch (index) {
            .light0 => {
                try self.emit_float(.lse0, exponent);
                try self.emit_float(.lsc0, cutoff);
            },
            .light1 => {
                try self.emit_float(.lse1, exponent);
                try self.emit_float(.lsc1, cutoff);
            },
            .light2 => {
                try self.emit_float(.lse2, exponent);
                try self.emit_float(.lsc2, cutoff);
            },
            .light3 => {
                try self.emit_float(.lse3, exponent);
                try self.emit_float(.lsc3, cutoff);
            },
        }
        try self.light_direction(index, direction);
    }

    pub fn logical_op(self: *CommandBuffer, op: LogicalOperation) WriteError!void {
        try self.emit_bits(.lop, @intFromEnum(op));
    }

    pub fn depth_func(self: *CommandBuffer, function: CompareFunc) WriteError!void {
        try self.emit_bits(.ztst, @intFromEnum(function));
    }

    pub fn depth_mask(self: *CommandBuffer, mask: bool) WriteError!void {
        try self.emit_bits(.zmsk, @intFromBool(mask));
    }

    pub fn depth_scale_position(self: *CommandBuffer, scale: f32, position: f32) WriteError!void {
        try self.emit_float(.zscale, scale);
        try self.emit_float(.zpos, position);
    }

    pub fn depth_bounds(self: *CommandBuffer, near: u16, far: u16) WriteError!void {
        if (near > far) {
            try self.emit_bits(.nearz, far);
            try self.emit_bits(.farz, near);
        } else {
            try self.emit_bits(.nearz, near);
            try self.emit_bits(.farz, far);
        }
    }

    pub fn copy_source(self: *CommandBuffer, pointer: ?*const anyopaque, width: u16, x: u24, y: u24) WriteError!void {
        const address = ptr_value(pointer);
        try self.emit_bits(.trxsbp, low_address_bits(address));
        try self.emit_bits(.trxsbw, high_buffer_address_bits(address) | @as(u24, width));
        try self.emit_command(.{ .trxspos = CoordinateArgument{ .x = @intCast(x), .y = @intCast(y) } });
    }

    pub fn copy_dest(self: *CommandBuffer, pointer: ?*const anyopaque, width: u16, x: u24, y: u24) WriteError!void {
        const address = ptr_value(pointer);
        try self.emit_bits(.trxdbp, low_address_bits(address));
        try self.emit_bits(.trxdbw, high_buffer_address_bits(address) | @as(u24, width));
        try self.emit_command(.{ .trxdpos = CoordinateArgument{ .x = @intCast(x), .y = @intCast(y) } });
    }

    pub fn copy_size(self: *CommandBuffer, width: u24, height: u24) WriteError!void {
        try self.emit_command(.{ .trxsize = CoordinateArgument{ .x = @intCast(width - 1), .y = @intCast(height - 1) } });
    }

    pub fn copy_kick(self: *CommandBuffer, copy_alpha: bool) WriteError!void {
        try self.emit_bits(.trxkick, @intFromBool(copy_alpha));
    }

    pub fn fog(self: *CommandBuffer, near: f32, far: f32, rgb: u24) WriteError!void {
        var distance = far - near;
        if (distance > 0) {
            distance = 1.0 / distance;
        }

        try self.emit_bits(.fcol, rgb);
        try self.emit_float(.ffar, far);
        try self.emit_float(.fdist, distance);
    }

    pub fn dither_matrix(self: *CommandBuffer, matrix: DitherMatrix) WriteError!void {
        try self.emit_bits(.dth0, dither_row_argument(matrix.x));
        try self.emit_bits(.dth1, dither_row_argument(matrix.y));
        try self.emit_bits(.dth2, dither_row_argument(matrix.z));
        try self.emit_bits(.dth3, dither_row_argument(matrix.w));
    }

    pub fn pixel_mask(self: *CommandBuffer, mask: u32) WriteError!void {
        try self.emit_bits(.pmskc, @truncate(mask));
        try self.emit_bits(.pmska, @truncate(mask >> 24));
    }

    pub fn stencil_func(self: *CommandBuffer, function: CompareFunc, reference: u8, mask: u8) WriteError!void {
        const argument = @as(u24, @intFromEnum(function)) | (@as(u24, reference) << 8) | (@as(u24, mask) << 16);
        try self.emit_bits(.stst, argument);
    }

    pub fn stencil_op(self: *CommandBuffer, fail: StencilOperation, depth_fail: StencilOperation, depth_pass: StencilOperation) WriteError!void {
        const argument = @as(u24, @intFromEnum(fail)) | (@as(u24, @intFromEnum(depth_fail)) << 8) | (@as(u24, @intFromEnum(depth_pass)) << 16);
        try self.emit_bits(.sop, argument);
    }

    pub fn texture_filter(self: *CommandBuffer, min: TextureFilter, mag: TextureFilter) WriteError!void {
        try self.emit_bits(.tflt, (@as(u24, @intFromEnum(mag)) << 8) | @intFromEnum(min));
    }

    pub fn texture_function(self: *CommandBuffer, function: TextureFunction) WriteError!void {
        try self.emit_bits(.tfunc, texture_function_argument(function));
    }

    pub fn texture_flush(self: *CommandBuffer) WriteError!void {
        try self.emit_empty(.tflush);
    }

    pub fn texture_level_mode(self: *CommandBuffer, mode: TextureLevelMode, bias: f32) WriteError!void {
        var offset: i32 = @intFromFloat(bias * 16.0);
        if (offset >= 128) {
            offset = 128;
        } else if (offset < -128) {
            offset = -128;
        }

        try self.emit_bits(.tbias, (@as(u24, @as(u8, @truncate(@as(u32, @bitCast(offset))))) << 16) | @intFromEnum(mode));
    }

    pub fn texture_map_mode(self: *CommandBuffer, state: TextureMapState, a1: u2, a2: u8) WriteError!void {
        try self.texture_map_state(state);
        try self.emit_bits(.tenvmtx, (@as(u24, a2) << 8) | a1);
    }

    pub fn texture_map_state(self: *CommandBuffer, state: TextureMapState) WriteError!void {
        try self.emit_bits(.tmap, texture_map_argument(state));
    }

    pub fn texture_mode(self: *CommandBuffer, psm: TexturePixelFormat, max_mips: u24, clut_mode_value: TextureClutMode, data_layout: TextureDataLayout) WriteError!void {
        try self.emit_bits(.tmode, (max_mips << 16) | (@as(u24, @intFromEnum(clut_mode_value)) << 8) | @intFromEnum(data_layout));
        try self.emit_bits(.tpsm, @intFromEnum(psm));
    }

    pub fn texture_sync(self: *CommandBuffer) WriteError!void {
        try self.emit_empty(.tsync);
    }

    pub fn texture_wrap(self: *CommandBuffer, u: TextureWrapMode, v: TextureWrapMode) WriteError!void {
        try self.emit_bits(.twrap, (@as(u24, @intFromEnum(v)) << 8) | @intFromEnum(u));
    }

    pub fn texture_env_color(self: *CommandBuffer, rgb: u24) WriteError!void {
        try self.emit_bits(.tec, rgb);
    }

    pub fn texture_offset(self: *CommandBuffer, u: f32, v: f32) WriteError!void {
        try self.emit_float(.uoffset, u);
        try self.emit_float(.voffset, v);
    }

    pub fn texture_scale(self: *CommandBuffer, u: f32, v: f32) WriteError!void {
        try self.emit_float(.uscale, u);
        try self.emit_float(.vscale, v);
    }

    pub fn texture_slope(self: *CommandBuffer, slope: f32) WriteError!void {
        try self.emit_float(.tslope, slope);
    }

    pub fn shade_model(self: *CommandBuffer, mode: ShadeModel) WriteError!void {
        try self.emit_bits(.shade, @intFromEnum(mode));
    }

    pub fn specular_power(self: *CommandBuffer, power: f32) WriteError!void {
        try self.emit_float(.spow, power);
    }

    pub fn morph_weight(self: *CommandBuffer, index: u3, weight: f32) WriteError!void {
        switch (index) {
            0 => try self.emit_float(.mw0, weight),
            1 => try self.emit_float(.mw1, weight),
            2 => try self.emit_float(.mw2, weight),
            3 => try self.emit_float(.mw3, weight),
            4 => try self.emit_float(.mw4, weight),
            5 => try self.emit_float(.mw5, weight),
            6 => try self.emit_float(.mw6, weight),
            7 => try self.emit_float(.mw7, weight),
        }
    }

    pub fn screen_offset(self: *CommandBuffer, x: u24, y: u24) WriteError!void {
        try self.emit_bits(.offsetx, x << 4);
        try self.emit_bits(.offsety, y << 4);
    }

    pub fn patch_divide(self: *CommandBuffer, u_level: u24, v_level: u24) WriteError!void {
        try self.emit_bits(.psub, (v_level << 8) | u_level);
    }

    pub fn patch_face(self: *CommandBuffer, value: u24) WriteError!void {
        try self.emit_bits(.pface, value);
    }

    pub fn patch_primitive(self: *CommandBuffer, value: u2) WriteError!void {
        try self.emit_bits(.pprim, value);
    }

    pub fn front_face_clockwise(self: *CommandBuffer, enabled: bool) WriteError!void {
        try self.emit_bits(.fface, @intFromBool(enabled));
    }

    pub fn viewport(self: *CommandBuffer, cx: i32, cy: i32, width: i32, height: i32) WriteError!void {
        try self.emit_float(.xscale, @as(f32, @floatFromInt(width >> 1)));
        try self.emit_float(.yscale, @as(f32, @floatFromInt((-height) >> 1)));
        try self.emit_float(.xpos, @as(f32, @floatFromInt(cx)));
        try self.emit_float(.ypos, @as(f32, @floatFromInt(cy)));
    }

    pub fn load_matrix(self: *CommandBuffer, target: MatrixTarget, values: *const [16]f32) WriteError!void {
        switch (target) {
            .projection => try self.projection_matrix(values),
            .view => try self.view_matrix(values),
            .world => try self.world_matrix(values),
            .texture => try self.texture_matrix(values),
        }
    }

    pub fn projection_matrix(self: *CommandBuffer, values: *const [16]f32) WriteError!void {
        try self.emit_bits(.pms, 0);
        for (values) |value| {
            try self.emit_float(.proj, value);
        }
    }

    pub fn view_matrix(self: *CommandBuffer, values: *const [16]f32) WriteError!void {
        try self.emit_bits(.vms, 0);
        try self.emit_3x4_matrix(.view, values);
    }

    pub fn world_matrix(self: *CommandBuffer, values: *const [16]f32) WriteError!void {
        try self.emit_bits(.wms, 0);
        try self.emit_3x4_matrix(.world, values);
    }

    pub fn texture_matrix(self: *CommandBuffer, values: *const [16]f32) WriteError!void {
        try self.emit_bits(.tms, 0);
        try self.emit_3x4_matrix(.tmatrix, values);
    }

    fn emit_3x4_matrix(self: *CommandBuffer, comptime op: Op, values: *const [16]f32) WriteError!void {
        var row: usize = 0;
        while (row < 4) : (row += 1) {
            var column: usize = 0;
            while (column < 3) : (column += 1) {
                try self.emit_float(op, values[column + row * 4]);
            }
        }
    }

    pub fn clut_mode(self: *CommandBuffer, format: u2, shift: u6, mask: u8, start: u8) WriteError!void {
        try self.emit_command(.{ .cmode = ClutModeArgument{
            .pixel_format = format,
            .shift = shift,
            .mask = mask,
            .start = start,
        } });
    }

    pub fn clut_load(self: *CommandBuffer, num_blocks: u24, pointer: ?*const anyopaque) WriteError!void {
        const address = ptr_value(pointer);
        try self.emit_bits(.cbp, low_address_bits(address));
        try self.emit_bits(.cbph, high_address_bits(address));
        try self.emit_bits(.cload, num_blocks);
    }

    pub fn nop(self: *CommandBuffer) WriteError!void {
        try self.emit_empty(.nop);
    }

    pub fn base_address(self: *CommandBuffer, address: usize) WriteError!void {
        try self.emit_bits(.base, high_address_bits(address));
    }

    pub fn pointer_base(self: *CommandBuffer, address: usize) WriteError!void {
        try self.base_address(address);
    }

    pub fn vertex_address(self: *CommandBuffer, address: usize) WriteError!void {
        try self.pointer_base(address);
        try self.emit_bits(.vaddr, low_address_bits(address));
    }

    pub fn index_address(self: *CommandBuffer, address: usize) WriteError!void {
        try self.pointer_base(address);
        try self.emit_bits(.iaddr, low_address_bits(address));
    }

    pub fn jump(self: *CommandBuffer, address: usize) WriteError!void {
        try self.pointer_base(address);
        try self.emit_bits(.jump, low_address_bits(address));
    }

    pub fn bjump(self: *CommandBuffer, address: usize) WriteError!void {
        try self.pointer_base(address);
        try self.emit_bits(.bjump, low_address_bits(address));
    }

    pub fn call(self: *CommandBuffer, address: usize) WriteError!void {
        try self.pointer_base(address);
        try self.emit_bits(.call, low_address_bits(address));
    }

    pub fn ret(self: *CommandBuffer) WriteError!void {
        try self.emit_empty(.ret);
    }

    pub fn end(self: *CommandBuffer) WriteError!void {
        try self.emit_command(.{ .end = EndArgument{} });
    }

    pub fn end_argument(self: *CommandBuffer, argument: u16) WriteError!void {
        try self.emit_command(.{ .end = EndArgument{ .argument = argument } });
    }

    pub fn signal(self: *CommandBuffer, index: u8, argument: u16) WriteError!void {
        try self.emit_command(.{ .signal = SignalArgument{ .index = index, .argument = argument } });
    }

    pub fn emit_signal_call(self: *CommandBuffer, address: usize) WriteError!void {
        try self.signal(0x11, @truncate(address >> 16));
        try self.end_argument(@truncate(address));
    }

    pub fn finish(self: *CommandBuffer, id: u16) WriteError!void {
        try self.emit_command(.{ .finish = FinishArgument{ .id = id } });
    }

    pub fn primitive(self: *CommandBuffer, primitive_type: Primitive, vertex_count: u16) WriteError!void {
        try self.emit_command(.{ .prim = PrimitiveArgument{ .primitive = primitive_type, .count = vertex_count } });
    }

    pub fn bezier(self: *CommandBuffer, u_count: u8, v_count: u8) WriteError!void {
        try self.emit_command(.{ .bezier = BezierArgument{ .u_count = u_count, .v_count = v_count } });
    }

    pub fn spline(self: *CommandBuffer, u_count: u8, v_count: u8, u_edges: SplineEdges, v_edges: SplineEdges) WriteError!void {
        try self.emit_command(.{ .spline = SplineArgument{ .u_count = u_count, .v_count = v_count, .u_edges = u_edges, .v_edges = v_edges } });
    }

    pub fn bounding_box(self: *CommandBuffer, vertex_count: u16) WriteError!void {
        try self.emit_command(.{ .bbox = CountArgument{ .count = vertex_count } });
    }

    pub fn vertex_type(self: *CommandBuffer, value: u24) WriteError!void {
        try self.emit_bits(.vtype, value);
    }

    pub fn pixel_format(self: *CommandBuffer, value: PixelFormat) WriteError!void {
        try self.emit_bits(.psm, @intFromEnum(value));
    }

    pub fn enable(self: *CommandBuffer, register: EnableRegister, enabled: bool) WriteError!void {
        const enabled_arg: u24 = @intFromBool(enabled);
        switch (register) {
            .lighting => try self.emit_bits(.lte, enabled_arg),
            .light0 => try self.emit_bits(.lte0, enabled_arg),
            .light1 => try self.emit_bits(.lte1, enabled_arg),
            .light2 => try self.emit_bits(.lte2, enabled_arg),
            .light3 => try self.emit_bits(.lte3, enabled_arg),
            .clip_planes => try self.emit_bits(.cpe, enabled_arg),
            .cull_face => try self.emit_bits(.bce, enabled_arg),
            .texture_mapping => try self.emit_bits(.tme, enabled_arg),
            .fog => try self.emit_bits(.fge, enabled_arg),
            .dither => try self.emit_bits(.dte, enabled_arg),
            .alpha_blend => try self.emit_bits(.abe, enabled_arg),
            .alpha_test => try self.emit_bits(.ate, enabled_arg),
            .depth_test => try self.emit_bits(.zte, enabled_arg),
            .stencil_test => try self.emit_bits(.ste, enabled_arg),
            .antialiasing => try self.emit_bits(.aae, enabled_arg),
            .patch_cull => try self.emit_bits(.pce, enabled_arg),
            .color_test => try self.emit_bits(.cte, enabled_arg),
            .logical_op => try self.emit_bits(.loe, enabled_arg),
            .reverse_normals => try self.emit_bits(.rnorm, enabled_arg),
        }
    }

    pub fn region_start(self: *CommandBuffer, x: u10, y: u10) WriteError!void {
        try self.emit_command(.{ .region1 = CoordinateArgument{ .x = x, .y = y } });
    }

    pub fn region_end(self: *CommandBuffer, x: u10, y: u10) WriteError!void {
        try self.emit_command(.{ .region2 = CoordinateArgument{ .x = x, .y = y } });
    }

    pub fn region(self: *CommandBuffer, x: u24, y: u24, width: u24, height: u24) WriteError!void {
        try self.region_start(@intCast(x), @intCast(y));
        try self.region_end(@intCast((x + width) - 1), @intCast((y + height) - 1));
    }

    pub fn scissor_start(self: *CommandBuffer, x: u10, y: u10) WriteError!void {
        try self.emit_command(.{ .scissor1 = CoordinateArgument{ .x = x, .y = y } });
    }

    pub fn scissor_end(self: *CommandBuffer, x: u10, y: u10) WriteError!void {
        try self.emit_command(.{ .scissor2 = CoordinateArgument{ .x = x, .y = y } });
    }

    pub fn scissor(self: *CommandBuffer, start_x: u24, start_y: u24, end_x: u24, end_y: u24) WriteError!void {
        try self.scissor_start(@intCast(start_x), @intCast(start_y));
        try self.scissor_end(@intCast(end_x), @intCast(end_y));
    }

    pub fn frame_buffer(self: *CommandBuffer, pointer: ?*const anyopaque, width: u16) WriteError!void {
        const address = ptr_value(pointer);
        const buffer_width = width;
        try self.emit_bits(.fbp, low_address_bits(address));
        try self.emit_bits(.fbw, high_buffer_address_bits(address) | @as(u24, buffer_width));
    }

    pub fn depth_buffer(self: *CommandBuffer, pointer: ?*const anyopaque, width: u16) WriteError!void {
        const address = ptr_value(pointer);
        const buffer_width = width;
        try self.emit_bits(.zbp, low_address_bits(address));
        try self.emit_bits(.zbw, high_buffer_address_bits(address) | @as(u24, buffer_width));
    }

    pub fn texture_buffer(self: *CommandBuffer, level: TextureLevel, pointer: ?*const anyopaque, width: u16) WriteError!void {
        const address = ptr_value(pointer);
        const buffer_width = width;
        const tbp = low_address_bits(address);
        const tbw = high_address_bits(address) | @as(u24, buffer_width);

        switch (level) {
            .level0 => {
                try self.emit_bits(.tbp0, tbp);
                try self.emit_bits(.tbw0, tbw);
            },
            .level1 => {
                try self.emit_bits(.tbp1, tbp);
                try self.emit_bits(.tbw1, tbw);
            },
            .level2 => {
                try self.emit_bits(.tbp2, tbp);
                try self.emit_bits(.tbw2, tbw);
            },
            .level3 => {
                try self.emit_bits(.tbp3, tbp);
                try self.emit_bits(.tbw3, tbw);
            },
            .level4 => {
                try self.emit_bits(.tbp4, tbp);
                try self.emit_bits(.tbw4, tbw);
            },
            .level5 => {
                try self.emit_bits(.tbp5, tbp);
                try self.emit_bits(.tbw5, tbw);
            },
            .level6 => {
                try self.emit_bits(.tbp6, tbp);
                try self.emit_bits(.tbw6, tbw);
            },
            .level7 => {
                try self.emit_bits(.tbp7, tbp);
                try self.emit_bits(.tbw7, tbw);
            },
        }
    }

    pub fn texture_size(self: *CommandBuffer, level: TextureLevel, width_exp: u8, height_exp: u8) WriteError!void {
        const argument = TextureSizeArgument{ .width_exp = width_exp, .height_exp = height_exp };
        switch (level) {
            .level0 => try self.emit_command(.{ .tsize0 = argument }),
            .level1 => try self.emit_command(.{ .tsize1 = argument }),
            .level2 => try self.emit_command(.{ .tsize2 = argument }),
            .level3 => try self.emit_command(.{ .tsize3 = argument }),
            .level4 => try self.emit_command(.{ .tsize4 = argument }),
            .level5 => try self.emit_command(.{ .tsize5 = argument }),
            .level6 => try self.emit_command(.{ .tsize6 = argument }),
            .level7 => try self.emit_command(.{ .tsize7 = argument }),
        }
    }

    pub fn texture_image(self: *CommandBuffer, level: TextureLevel, width: u10, height: u10, buffer_width: u16, pointer: ?*const anyopaque) WriteError!void {
        std.debug.assert(std.math.isPowerOfTwo(width));
        std.debug.assert(std.math.isPowerOfTwo(height));

        try self.texture_buffer(level, pointer, buffer_width);
        try self.texture_size(level, @ctz(width), @ctz(height));
    }
};

fn dither_row_argument(row: DitherRow) u24 {
    return @as(u24, dither_component(row.x)) |
        (@as(u24, dither_component(row.y)) << 4) |
        (@as(u24, dither_component(row.z)) << 8) |
        (@as(u24, dither_component(row.w)) << 12);
}

fn dither_component(value: i32) u4 {
    return @truncate(@as(u32, @bitCast(value)));
}

fn texture_function_argument(function: TextureFunction) u24 {
    const fragment_2x = if (function.fragment_2x) @as(u24, 0x10000) else 0;
    return (@as(u24, @intFromEnum(function.component)) << 8) |
        @intFromEnum(function.effect) |
        fragment_2x;
}

fn texture_map_argument(state: TextureMapState) u24 {
    return (@as(u24, @intFromEnum(state.projection)) << 8) |
        @intFromEnum(state.mode);
}

fn assert_bits_command(comptime op: Op) void {
    const Argument = CommandArgument(op);
    if (Argument == EmptyArgument) {
        @compileError("GE command " ++ @tagName(op) ++ " does not take a raw argument");
    }
    if (Argument == TruncatedFloat) {
        @compileError("GE command " ++ @tagName(op) ++ " takes a float argument");
    }
}

test "CommandBuffer encodes typed commands" {
    var words: [8]u32 = undefined;
    var buffer = CommandBuffer.init(words[0..]);

    try buffer.primitive(.triangles, 3);
    try buffer.emit_command(.{ .signal = SignalArgument{ .index = 2, .argument = 0x1234 } });
    try buffer.frame_buffer(@as(*const anyopaque, @ptrFromInt(0x04123450)), 512);
    try buffer.end();

    try std.testing.expectEqual(encode_raw(0x04, 0x030003), words[0]);
    try std.testing.expectEqual(encode_raw(0x0e, 0x021234), words[1]);
    try std.testing.expectEqual(encode_raw(0x9c, 0x123450), words[2]);
    try std.testing.expectEqual(encode_raw(0x9d, 0x040200), words[3]);
    try std.testing.expectEqual(encode_raw(0x0c, 0), words[4]);
    try std.testing.expectEqual(@as(usize, 5), buffer.used_words());
}

test "CommandBuffer emits low-level escape hatches explicitly" {
    var words: [3]u32 = undefined;
    var buffer = CommandBuffer.init(words[0..]);

    try buffer.emit_truncated(.atst, @as(u32, 0xff123456));
    try buffer.emit_truncated(.pmskc, @as(u32, 0xffffffff));
    try buffer.emit_empty(.tflush);

    try std.testing.expectEqual(encode_raw(0xdb, 0x123456), words[0]);
    try std.testing.expectEqual(encode_raw(0xe8, 0xffffff), words[1]);
    try std.testing.expectEqual(encode_raw(0xcb, 0), words[2]);
}

test "CommandBuffer exposes named methods for common packed commands" {
    var words: [10]u32 = undefined;
    var buffer = CommandBuffer.init(words[0..]);

    try buffer.alpha_test(.greater, 0x34, 0x12);
    try buffer.ambient_rgba(@as(u32, 0xaa123456));
    try buffer.copy_source(@as(*const anyopaque, @ptrFromInt(0x04123450)), 512, 2, 3);
    try buffer.pixel_mask(@bitCast(@as(i32, -1)));
    try buffer.texture_sync();

    try std.testing.expectEqual(encode_raw(0xdb, 0x123406), words[0]);
    try std.testing.expectEqual(encode_raw(0x5c, 0x123456), words[1]);
    try std.testing.expectEqual(encode_raw(0x5d, 0xaa), words[2]);
    try std.testing.expectEqual(encode_raw(0xb2, 0x123450), words[3]);
    try std.testing.expectEqual(encode_raw(0xb3, 0x040200), words[4]);
    try std.testing.expectEqual(encode_raw(0xeb, 0x000c02), words[5]);
    try std.testing.expectEqual(encode_raw(0xe8, 0xffffff), words[6]);
    try std.testing.expectEqual(encode_raw(0xe9, 0xff), words[7]);
    try std.testing.expectEqual(encode_raw(0xcc, 0), words[8]);
}

test "CommandBuffer exposes named methods for state packing" {
    var words: [32]u32 = undefined;
    var buffer = CommandBuffer.init(words[0..]);

    try buffer.blend_func(.add, .source_alpha, .one_minus_source_alpha, 0x112233, 0x445566);
    try buffer.color_test(.equal, 0x112233, 0xffffff);
    try buffer.depth_func(.less);
    try buffer.depth_bounds(7, 2);
    try buffer.dither_matrix(DitherMatrix{
        .x = .{ .x = 1, .y = 2, .z = 3, .w = 4 },
        .y = .{ .x = 5, .y = 6, .z = 7, .w = 8 },
        .z = .{ .x = 9, .y = 10, .z = 11, .w = 12 },
        .w = .{ .x = 13, .y = 14, .z = 15, .w = 16 },
    });
    try buffer.stencil_func(.greater, 0x34, 0x12);
    try buffer.stencil_op(.zero, .replace, .invert);
    try buffer.texture_filter(.nearest, .linear);
    try buffer.texture_function(.{ .effect = .add, .component = .rgba, .fragment_2x = true });
    try buffer.texture_level_mode(.constant, -1.25);
    try buffer.texture_map_mode(.{ .projection = .normalized_normal, .mode = .reserved }, 2, 1);
    try buffer.texture_map_state(.{ .projection = .uv, .mode = .environment_map });
    try buffer.texture_mode(.psm8888, 2, .multiple, .swizzled);
    try buffer.texture_wrap(.clamp, .repeat);

    const expected = [_]u32{
        encode_raw(0xdf, 0x000032),
        encode_raw(0xe0, 0x112233),
        encode_raw(0xe1, 0x445566),
        encode_raw(0xd8, 0x000002),
        encode_raw(0xd9, 0x112233),
        encode_raw(0xda, 0xffffff),
        encode_raw(0xde, 0x000004),
        encode_raw(0xd6, 0x000002),
        encode_raw(0xd7, 0x000007),
        encode_raw(0xe2, 0x004321),
        encode_raw(0xe3, 0x008765),
        encode_raw(0xe4, 0x00cba9),
        encode_raw(0xe5, 0x000fed),
        encode_raw(0xdc, 0x123406),
        encode_raw(0xdd, 0x030201),
        encode_raw(0xc6, 0x000100),
        encode_raw(0xc9, 0x010104),
        encode_raw(0xc8, 0xec0001),
        encode_raw(0xc0, 0x000203),
        encode_raw(0xc1, 0x000102),
        encode_raw(0xc0, 0x000102),
        encode_raw(0xc2, 0x020101),
        encode_raw(0xc3, 0x000003),
        encode_raw(0xc7, 0x000001),
    };

    for (expected, 0..) |word, i| {
        try std.testing.expectEqual(word, words[i]);
    }
}

test "CommandBuffer exposes named methods for light state" {
    var words: [16]u32 = undefined;
    var buffer = CommandBuffer.init(words[0..]);

    try buffer.light(.light2, .point, 2, Vector3{ .x = 1.0, .y = 2.0, .z = 3.0 });
    try buffer.light_attenuation(.light1, 4.0, 5.0, 6.0);
    try buffer.light_color(.light3, .specular, 0x123456);
    try buffer.light_mode(.separate_specular_color);
    try buffer.light_spot(.light0, Vector3{ .x = 7.0, .y = 8.0, .z = 9.0 }, 10.0, 11.0);

    const expected = [_]u32{
        encode_raw(0x69, commands.ge_float(1.0)),
        encode_raw(0x6a, commands.ge_float(2.0)),
        encode_raw(0x6b, commands.ge_float(3.0)),
        encode_raw(0x61, 0x000102),
        encode_raw(0x7e, commands.ge_float(4.0)),
        encode_raw(0x7f, commands.ge_float(5.0)),
        encode_raw(0x80, commands.ge_float(6.0)),
        encode_raw(0x9a, 0x123456),
        encode_raw(0x5e, 0x000001),
        encode_raw(0x87, commands.ge_float(10.0)),
        encode_raw(0x8b, commands.ge_float(11.0)),
        encode_raw(0x6f, commands.ge_float(7.0)),
        encode_raw(0x70, commands.ge_float(8.0)),
        encode_raw(0x71, commands.ge_float(9.0)),
    };

    for (expected, 0..) |word, i| {
        try std.testing.expectEqual(word, words[i]);
    }
}

test "CommandBuffer exposes named methods for one-register state and viewport" {
    var words: [32]u32 = undefined;
    var buffer = CommandBuffer.init(words[0..]);

    try buffer.material_ambient_rgb(0x112233);
    try buffer.material_ambient_alpha(0xaa);
    try buffer.material_diffuse_rgb(0x223344);
    try buffer.material_specular_rgb(0x334455);
    try buffer.material_emissive_rgb(0xffffff);
    try buffer.color_material(7);
    try buffer.logical_op(.set);
    try buffer.depth_mask(true);
    try buffer.depth_scale_position(1.0, 2.0);
    try buffer.morph_weight(3, 1.0);
    try buffer.screen_offset(2, 3);
    try buffer.patch_divide(4, 5);
    try buffer.patch_face(1);
    try buffer.patch_primitive(2);
    try buffer.front_face_clockwise(true);
    try buffer.shade_model(.smooth);
    try buffer.specular_power(2.0);
    try buffer.texture_env_color(0x445566);
    try buffer.texture_offset(1.0, 2.0);
    try buffer.texture_scale(3.0, 4.0);
    try buffer.texture_slope(5.0);
    try buffer.viewport(10, 20, 480, 272);

    const expected = [_]u32{
        encode_raw(@intFromEnum(Op.amc), 0x112233),
        encode_raw(@intFromEnum(Op.ama), 0x0000aa),
        encode_raw(@intFromEnum(Op.dmc), 0x223344),
        encode_raw(@intFromEnum(Op.smc), 0x334455),
        encode_raw(@intFromEnum(Op.emc), 0xffffff),
        encode_raw(@intFromEnum(Op.cmat), 0x000007),
        encode_raw(@intFromEnum(Op.lop), 0x00000f),
        encode_raw(@intFromEnum(Op.zmsk), 0x000001),
        encode_raw(@intFromEnum(Op.zscale), commands.ge_float(1.0)),
        encode_raw(@intFromEnum(Op.zpos), commands.ge_float(2.0)),
        encode_raw(@intFromEnum(Op.mw3), commands.ge_float(1.0)),
        encode_raw(@intFromEnum(Op.offsetx), 0x000020),
        encode_raw(@intFromEnum(Op.offsety), 0x000030),
        encode_raw(@intFromEnum(Op.psub), 0x000504),
        encode_raw(@intFromEnum(Op.pface), 0x000001),
        encode_raw(@intFromEnum(Op.pprim), 0x000002),
        encode_raw(@intFromEnum(Op.fface), 0x000001),
        encode_raw(@intFromEnum(Op.shade), 0x000001),
        encode_raw(@intFromEnum(Op.spow), commands.ge_float(2.0)),
        encode_raw(@intFromEnum(Op.tec), 0x445566),
        encode_raw(@intFromEnum(Op.uoffset), commands.ge_float(1.0)),
        encode_raw(@intFromEnum(Op.voffset), commands.ge_float(2.0)),
        encode_raw(@intFromEnum(Op.uscale), commands.ge_float(3.0)),
        encode_raw(@intFromEnum(Op.vscale), commands.ge_float(4.0)),
        encode_raw(@intFromEnum(Op.tslope), commands.ge_float(5.0)),
        encode_raw(@intFromEnum(Op.xscale), commands.ge_float(240.0)),
        encode_raw(@intFromEnum(Op.yscale), commands.ge_float(-136.0)),
        encode_raw(@intFromEnum(Op.xpos), commands.ge_float(10.0)),
        encode_raw(@intFromEnum(Op.ypos), commands.ge_float(20.0)),
    };

    for (expected, 0..) |word, i| {
        try std.testing.expectEqual(word, words[i]);
    }
}

test "CommandBuffer exposes named methods for matrix uploads" {
    const matrix_values = [_]f32{
        0.0,  1.0,  2.0,  3.0,
        4.0,  5.0,  6.0,  7.0,
        8.0,  9.0,  10.0, 11.0,
        12.0, 13.0, 14.0, 15.0,
    };

    var words: [64]u32 = undefined;
    var buffer = CommandBuffer.init(words[0..]);

    try buffer.load_matrix(.projection, &matrix_values);
    try buffer.load_matrix(.view, &matrix_values);
    try buffer.load_matrix(.world, &matrix_values);
    try buffer.load_matrix(.texture, &matrix_values);

    var expected: [56]u32 = undefined;
    var index: usize = 0;

    expected[index] = encode_raw(@intFromEnum(Op.pms), 0);
    index += 1;
    for (matrix_values) |value| {
        expected[index] = encode_raw(@intFromEnum(Op.proj), commands.ge_float(value));
        index += 1;
    }

    expected[index] = encode_raw(@intFromEnum(Op.vms), 0);
    index += 1;
    for (0..4) |row| {
        for (0..3) |column| {
            expected[index] = encode_raw(@intFromEnum(Op.view), commands.ge_float(matrix_values[column + row * 4]));
            index += 1;
        }
    }

    expected[index] = encode_raw(@intFromEnum(Op.wms), 0);
    index += 1;
    for (0..4) |row| {
        for (0..3) |column| {
            expected[index] = encode_raw(@intFromEnum(Op.world), commands.ge_float(matrix_values[column + row * 4]));
            index += 1;
        }
    }

    expected[index] = encode_raw(@intFromEnum(Op.tms), 0);
    index += 1;
    for (0..4) |row| {
        for (0..3) |column| {
            expected[index] = encode_raw(@intFromEnum(Op.tmatrix), commands.ge_float(matrix_values[column + row * 4]));
            index += 1;
        }
    }

    try std.testing.expectEqual(@as(usize, expected.len), index);
    for (expected, 0..) |word, i| {
        try std.testing.expectEqual(word, words[i]);
    }
}
