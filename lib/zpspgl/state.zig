// zpspgl internal state — display list infrastructure, GE command helpers, callbacks
// No dependency on pspgu.zig

const pspsdk = @import("pspsdk");
const c_types = pspsdk.c.types;
const pspge = @import("pspsdk").c.sceGe_user;
const pspthreadman = @import("pspsdk").c.ThreadManForUser;
const pspdisplay = pspsdk.c.sceDisplay;

// =============================================================================
// Types
// =============================================================================

pub const PspGeCallback = c_types.PspGeCallback;
pub const PspGeCallbackData = c_types.PspGeCallbackData;
pub const PspGeListArgs = c_types.PspGeListArgs;

pub const UserCallback = *const fn (c_int) void;

pub const Settings = struct {
    sig: ?UserCallback,
    fin: ?UserCallback,
    signal_history: [16]u16,
    signal_offset: i32,
    kernel_event_flag: i32,
    ge_callback_id: i32,
    swap_buffers_behaviour: PspDisplaySetBufSync,
};

pub const PspDisplaySetBufSync = enum(c_int) {
    NextHSync = 0,
    NextVSync = 1,
};

pub const PspDisplayPixelFormats = enum(c_int) {
    Format5650 = 0,
    Format5551 = 1,
    Format4444 = 2,
    Format8888 = 3,
};

pub const DisplayList = struct {
    start: [*]u32,
    current: [*]u32,
    parent_context: u32,
};

pub const Context = struct {
    list: DisplayList,
    scissor_enable: i32,
    scissor_start: [2]u24,
    scissor_end: [2]u24,
    near_plane: u16,
    far_plane: u16,
    depth_offset: i32,
    fragment_2x: u24,
    texture_function: u24,
    texture_proj_map_mode: u24,
    texture_map_mode: u24,
    sprite_mode: [4]i32,
    clear_color: u24,
    clear_stencil: u32,
    clear_depth: u16,
    texture_mode: i32,
};

pub const DrawBuffer = struct {
    pixel_format: PspDisplayPixelFormats,
    frame_width: u24,
    frame_buffer: ?*anyopaque,
    disp_buffer: ?*anyopaque,
    depth_buffer: ?*anyopaque,
    depth_width: u24,
    width: u24,
    height: u24,
};

// =============================================================================
// Globals
// =============================================================================

pub var settings: Settings = undefined;
pub var contexts: [3]Context = undefined;
pub var ge_list_executed: [2]i32 = undefined;
pub var edram_address: ?*anyopaque = null;
pub var list: ?*DisplayList = null;
pub var curr_context: u32 = 0;
pub var current_frame: u32 = 0;
pub var initialized: bool = false;
pub var display_on: bool = false;
pub var states: u32 = 0;
pub var call_mode: i32 = 0;
pub var object_stack: [256]u32 = undefined;
pub var object_stack_depth: i32 = 0;
pub var draw_buffer: DrawBuffer = undefined;

// =============================================================================
// Display List Buffer
// =============================================================================

/// Static display list buffer — 256K u32 entries, 16-byte aligned.
/// Same size as the native ziggy_cube example.
pub var display_list_buffer: [0x40000]u32 align(16) = [_]u32{0} ** 0x40000;

/// VRAM allocator offset (bytes from EDRAM base). Simple bump allocator.
pub var vram_offset: usize = 0;

/// Allocate VRAM relative to EDRAM base. Returns a VRAM-relative pointer.
pub fn allocVram(stride: u32, height: u32, bytes_per_pixel: u32) ?*anyopaque {
    const offset = vram_offset;
    vram_offset += stride * height * bytes_per_pixel;
    return @ptrFromInt(offset);
}

/// Pixel size in bytes for display pixel formats (0=565, 1=5551, 2=4444, 3=8888).
pub fn pixelFormatBpp(format: PspDisplayPixelFormats) u32 {
    return switch (format) {
        .Format5650, .Format5551, .Format4444 => 2,
        .Format8888 => 4,
    };
}

/// Start (or restart) the display list. Enqueues with the GE.
/// Waits for the GE to finish the previous list before reusing the buffer.
pub fn beginDisplayList() void {
    // Wait for any previous list to finish before we overwrite the buffer.
    // This is a no-op on the very first call (no previous list).
    _ = pspge.sceGeDrawSync(0);

    const list_ptr: [*]u32 = @ptrFromInt(@intFromPtr(&display_list_buffer) | 0x40000000);

    contexts[0].list.start = list_ptr;
    contexts[0].list.current = list_ptr;
    list = &contexts[0].list;
    curr_context = 0;

    ge_list_executed[0] = pspge.sceGeListEnQueue(
        @ptrCast(list_ptr),
        @ptrCast(list_ptr),
        settings.ge_callback_id,
        null,
    );
}

/// Finish the current display list (emit FINISH + END).
pub fn endDisplayList() void {
    sendCommandi(15, 0); // FINISH
    sendCommandiStall(12, 0); // END with stall update
}

/// Swap front/back frame buffers and update the display.
pub fn swapBuffers() void {
    const temp = draw_buffer.disp_buffer;
    draw_buffer.disp_buffer = draw_buffer.frame_buffer;
    draw_buffer.frame_buffer = temp;

    // Update display hardware with new front buffer
    if (display_on) {
        _ = pspdisplay.sceDisplaySetFrameBuf(
            @ptrFromInt(@intFromPtr(edram_address) + @intFromPtr(draw_buffer.disp_buffer)),
            @intCast(draw_buffer.frame_width),
            @intFromEnum(draw_buffer.pixel_format),
            @intFromEnum(settings.swap_buffers_behaviour),
        );
    }

    current_frame ^= 1;
}

// =============================================================================
// Texture State
// =============================================================================

pub const MAX_TEXTURES = 256;

pub const TextureObject = struct {
    allocated: bool = false,
    /// Pointer to texture data (PSP reads from this address at draw time)
    data_ptr: u32 = 0,
    width: u16 = 0,
    height: u16 = 0,
    /// GE pixel format: 0=5650, 1=5551, 2=4444, 3=8888
    ge_format: u8 = 3,
    /// GE filter values: 0=nearest, 1=linear, 4-7=mipmap variants
    min_filter: u8 = 0,
    mag_filter: u8 = 1,
    /// GE wrap values: 0=repeat, 1=clamp
    wrap_s: u8 = 0,
    wrap_t: u8 = 0,
    /// GE texture effect: 0=modulate, 1=decal, 2=blend, 3=replace, 4=add
    tex_func: u8 = 0,
    /// GE texture color component: 0=RGB, 1=RGBA
    tex_color_comp: u8 = 0,
};

/// Texture object table. Slot 0 is the default texture (always valid).
pub var textures: [MAX_TEXTURES]TextureObject = [_]TextureObject{.{}} ** MAX_TEXTURES;
/// Currently bound texture ID (0 = default)
pub var bound_texture: u32 = 0;

/// Convenience: get a pointer to the currently bound texture object.
pub fn currentTexture() *TextureObject {
    return &textures[bound_texture];
}

// =============================================================================
// Vertex Array State
// =============================================================================

pub const VertexArrayPointer = struct {
    size: i32 = 0,
    type_enum: u32 = 0,
    stride: i32 = 0,
    pointer: ?*const anyopaque = null,
};

pub const VertexArrayState = struct {
    vertex_enabled: bool = false,
    color_enabled: bool = false,
    texcoord_enabled: bool = false,
    normal_enabled: bool = false,
    vertex: VertexArrayPointer = .{},
    color: VertexArrayPointer = .{},
    texcoord: VertexArrayPointer = .{},
    normal: VertexArrayPointer = .{},
    vertex_type_override: u24 = 0,
    transform_2d: bool = false,
};

pub var vertex_array: VertexArrayState = .{};
pub var gl_error: u32 = 0;

// =============================================================================
// Matrix State
// =============================================================================

pub const Mat4 = [16]f32;

pub const identity_matrix: Mat4 = .{
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1,
};

/// GL matrix mode → internal index: 0=modelview, 1=projection, 2=texture
/// GL_MODELVIEW=0x1700, GL_PROJECTION=0x1701, GL_TEXTURE=0x1702
pub const MAX_MATRIX_MODES = 3;
pub const MAX_STACK_DEPTH = 32;

pub var matrix_mode: u8 = 0; // 0=modelview, 1=projection, 2=texture
pub var matrix_stacks: [MAX_MATRIX_MODES][MAX_STACK_DEPTH]Mat4 = undefined;
pub var matrix_stack_depth: [MAX_MATRIX_MODES]u8 = .{ 0, 0, 0 };
pub var matrix_dirty: [MAX_MATRIX_MODES]bool = .{ true, true, true };

pub fn currentMatrix() *Mat4 {
    return &matrix_stacks[matrix_mode][matrix_stack_depth[matrix_mode]];
}

/// Multiply two 4x4 matrices: result = a * b (column-major, like GL)
pub fn mat4Multiply(result: *Mat4, a: *const Mat4, b: *const Mat4) void {
    var t: Mat4 = undefined;
    for (0..4) |col| {
        for (0..4) |row| {
            var sum: f32 = 0;
            for (0..4) |k| {
                sum += a[k * 4 + row] * b[col * 4 + k];
            }
            t[col * 4 + row] = sum;
        }
    }
    result.* = t;
}

/// Upload dirty matrices to GE display list. Call before any draw command.
pub fn uploadMatrices() void {
    // Projection: GL mode 1 → GE cmd 62/63, 4x4
    if (matrix_dirty[1]) {
        const m = &matrix_stacks[1][matrix_stack_depth[1]];
        sendCommandf(62, 0);
        for (0..16) |i| {
            sendCommandf(63, m[i]);
        }
        matrix_dirty[1] = false;
    }

    // Modelview → GE model matrix (cmd 58/59, 3x4) + GE view matrix identity (cmd 60/61)
    // The PSP GE may perform frustum culling between MODEL and VIEW transforms,
    // so the modelview must go in the MODEL slot to ensure vertices are transformed
    // before any culling occurs.
    if (matrix_dirty[0]) {
        const m = &matrix_stacks[0][matrix_stack_depth[0]];
        // Upload as GE model matrix (3 rows per column, skip row 3)
        sendCommandf(58, 0);
        for (0..4) |col| {
            for (0..3) |row| {
                sendCommandf(59, m[col * 4 + row]);
            }
        }
        // Set GE view matrix to identity
        sendCommandf(60, 0);
        for (0..4) |col| {
            for (0..3) |row| {
                sendCommandf(61, if (col == row) @as(f32, 1.0) else @as(f32, 0.0));
            }
        }
        matrix_dirty[0] = false;
    }

    // Texture: GL mode 2 → GE cmd 64/65, 3x4
    if (matrix_dirty[2]) {
        const m = &matrix_stacks[2][matrix_stack_depth[2]];
        sendCommandf(64, 0);
        for (0..4) |col| {
            for (0..3) |row| {
                sendCommandf(65, m[col * 4 + row]);
            }
        }
        matrix_dirty[2] = false;
    }
}

pub fn resetMatrices() void {
    for (0..MAX_MATRIX_MODES) |i| {
        matrix_stacks[i][0] = identity_matrix;
        matrix_stack_depth[i] = 0;
        matrix_dirty[i] = true;
    }
    matrix_mode = 0;
}

// =============================================================================
// Light Settings Table
// =============================================================================

pub const LightSettings = struct {
    enable: u8,
    typec: u8,
    xpos: u8, ypos: u8, zpos: u8,
    xdir: u8, ydir: u8, zdir: u8,
    ambient: u8, diffuse: u8, specular: u8,
    constant: u8, linear: u8, quadratic: u8,
    exponent: u8, cutoff: u8,
};

pub const light_settings: [4]LightSettings = .{
    .{ .enable = 0x18, .typec = 0x5f, .xpos = 0x63, .ypos = 0x64, .zpos = 0x65, .xdir = 0x6f, .ydir = 0x70, .zdir = 0x71, .ambient = 0x8f, .diffuse = 0x90, .specular = 0x91, .constant = 0x7b, .linear = 0x7c, .quadratic = 0x7d, .exponent = 0x87, .cutoff = 0x8b },
    .{ .enable = 0x19, .typec = 0x60, .xpos = 0x66, .ypos = 0x67, .zpos = 0x68, .xdir = 0x72, .ydir = 0x73, .zdir = 0x74, .ambient = 0x92, .diffuse = 0x93, .specular = 0x94, .constant = 0x7e, .linear = 0x7f, .quadratic = 0x80, .exponent = 0x88, .cutoff = 0x8c },
    .{ .enable = 0x1a, .typec = 0x61, .xpos = 0x69, .ypos = 0x6a, .zpos = 0x6b, .xdir = 0x75, .ydir = 0x76, .zdir = 0x77, .ambient = 0x95, .diffuse = 0x96, .specular = 0x97, .constant = 0x81, .linear = 0x82, .quadratic = 0x83, .exponent = 0x89, .cutoff = 0x8d },
    .{ .enable = 0x1b, .typec = 0x62, .xpos = 0x6c, .ypos = 0x6d, .zpos = 0x6e, .xdir = 0x78, .ydir = 0x79, .zdir = 0x7a, .ambient = 0x98, .diffuse = 0x99, .specular = 0x9a, .constant = 0x84, .linear = 0x85, .quadratic = 0x86, .exponent = 0x8a, .cutoff = 0x8e },
};

// =============================================================================
// GE Init List
// =============================================================================

pub const ge_init_list = [_]c_uint{
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

// =============================================================================
// GE Command Encoding
// =============================================================================

pub fn sendCommandi(cmd: u8, argument: u24) void {
    list.?.current[0] = (@as(u32, cmd) << 24) | argument;
    list.?.current += 1;
}

pub fn sendCommandf(cmd: u8, argument: f32) void {
    sendCommandi(cmd, @truncate(@as(u32, @bitCast(argument)) >> 8));
}

pub fn sendCommandiStall(cmd: u8, argument: u24) void {
    sendCommandi(cmd, argument);

    if (object_stack_depth == 0 and curr_context == 0) {
        _ = pspge.sceGeListUpdateStallAddr(ge_list_executed[0], list.?.current);
    }
}

// =============================================================================
// GE Callbacks
// =============================================================================

pub export fn callbackSig(id: c_int, arg: ?*anyopaque) callconv(.c) void {
    const s: *Settings = @ptrCast(@alignCast(arg));
    s.signal_history[@as(usize, @intCast(s.signal_offset)) & 15] = @as(u16, @intCast(id)) & 0xffff;
    s.signal_offset += 1;

    if (s.sig) |signal_cb| {
        signal_cb(id & 0xffff);
    }

    _ = pspthreadman.sceKernelSetEventFlag(s.kernel_event_flag, 1);
}

pub export fn callbackFin(id: c_int, arg: ?*anyopaque) callconv(.c) void {
    const s: *Settings = @ptrCast(@alignCast(arg));
    if (s.fin) |finished_cb| {
        finished_cb(id & 0xffff);
    }
}

// =============================================================================
// State Reset
// =============================================================================

pub fn resetValues() void {
    initialized = false;
    states = 0;
    current_frame = 0;
    object_stack_depth = 0;
    display_on = false;
    call_mode = 0;

    draw_buffer = .{
        .pixel_format = .Format5551,
        .frame_width = 0,
        .frame_buffer = null,
        .disp_buffer = null,
        .depth_buffer = null,
        .depth_width = 0,
        .width = 480,
        .height = 272,
    };

    for (&contexts) |*ctx| {
        ctx.scissor_enable = 0;
        ctx.scissor_start = .{ 0, 0 };
        ctx.scissor_end = .{ 0, 0 };
        ctx.near_plane = 0;
        ctx.far_plane = 1;
        ctx.depth_offset = 0;
        ctx.fragment_2x = 0;
        ctx.texture_function = 0;
        ctx.texture_proj_map_mode = 0;
        ctx.texture_map_mode = 0;
        ctx.sprite_mode = .{ 0, 0, 0, 0 };
        ctx.clear_color = 0;
        ctx.clear_stencil = 0;
        ctx.clear_depth = 0xffff;
        ctx.texture_mode = 0;
    }

    vertex_array = .{};
    textures = [_]TextureObject{.{}} ** MAX_TEXTURES;
    textures[0].allocated = true; // default texture always exists
    bound_texture = 0;
    gl_error = 0;

    settings.sig = null;
    settings.fin = null;

    resetMatrices();
}
