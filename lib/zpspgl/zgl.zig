// Auto-generated from glad/gl.h (OpenGL 1.1 Compatibility)
// GL function stubs for zpspgl

pub const state = @import("state.zig");

const pspge = @import("pspsdk").c.sceGe_user;
const pspthreadman = @import("pspsdk").c.ThreadManForUser;
const pspdisplay = @import("pspsdk").c.sceDisplay;
const psputils = @import("pspsdk").c.UtilsForUser;
const c_types = @import("pspsdk").c.types;

// =============================================================================
// Lifecycle
// =============================================================================

pub const ZglConfig = struct {
    pixel_format: state.PspDisplayPixelFormats = .Format8888,
    width: u24 = 480,
    height: u24 = 272,
    buf_width: u24 = 512,
};

pub fn zglInit(config: ZglConfig) void {
    // --- One-time GE setup (callbacks, init list) ---
    const callback_data = c_types.PspGeCallbackData{
        .signal_func = state.callbackSig,
        .signal_arg = &state.settings,
        .finish_func = state.callbackFin,
        .finish_arg = &state.settings,
    };

    state.settings.ge_callback_id = pspge.sceGeSetCallback(@constCast(&callback_data));
    state.settings.swap_buffers_behaviour = .NextVSync;

    state.edram_address = pspge.sceGeEdramGetAddr();

    state.ge_list_executed[0] = pspge.sceGeListEnQueue(
        @as(?*const anyopaque, @ptrFromInt(@intFromPtr(&state.ge_init_list) & 0x1f_ff_ff_ff)),
        null,
        state.settings.ge_callback_id,
        null,
    );

    state.resetValues();

    state.settings.kernel_event_flag = pspthreadman.sceKernelCreateEventFlag(
        @ptrCast("ZglSignal"),
        @bitCast(@as(u32, 0x200)), // WaitMultiple
        3,
        null,
    );

    _ = pspge.sceGeListSync(state.ge_list_executed[0], 0);

    // --- Allocate VRAM: two frame buffers + depth buffer ---
    const bpp = state.pixelFormatBpp(config.pixel_format);
    state.vram_offset = 0;
    const fbp0 = state.allocVram(config.buf_width, config.height, bpp);
    const fbp1 = state.allocVram(config.buf_width, config.height, bpp);
    const zbp = state.allocVram(config.buf_width, config.height, 2); // depth is always 16-bit

    // --- Configure draw buffer state ---
    state.draw_buffer = .{
        .pixel_format = config.pixel_format,
        .frame_width = config.buf_width,
        .frame_buffer = fbp0,
        .disp_buffer = fbp1,
        .depth_buffer = zbp,
        .depth_width = config.buf_width,
        .width = config.width,
        .height = config.height,
    };

    // --- Start a display list and emit init commands ---
    // This matches the commands sceGuInit + sceGuStart(first call) + user init emit.
    // The ge_init_list (run above) already zeroed all GE registers.
    state.beginDisplayList();

    // Dither matrix (cmd 226-229) — sceGuStart first-call defaults
    state.sendCommandi(226, 0x001D0C);
    state.sendCommandi(227, 0x00F3E2);
    state.sendCommandi(228, 0x000C1D);
    state.sendCommandi(229, 0x00E2F3);

    // Patch subdivision (cmd 54) — default 16x16
    state.sendCommandi(54, (16 << 8) | 16);

    // Color material (cmd 83) — ambient|diffuse|specular = 7
    state.sendCommandi(83, 7);

    // Specular power (cmd 91) — default 1.0
    state.sendCommandf(91, 1.0);

    // Texture scale (cmd 72/73) — default 1.0
    state.sendCommandf(72, 1.0);
    state.sendCommandf(73, 1.0);

    // Pixel format (cmd 210)
    state.sendCommandi(210, @intCast(@intFromEnum(config.pixel_format)));

    // Frame buffer (cmd 156/157)
    const fb_addr: u32 = @intCast(@intFromPtr(fbp0));
    state.sendCommandi(156, @truncate(fb_addr));
    state.sendCommandi(157, @truncate(((fb_addr & 0xff000000) >> 8) | config.buf_width));

    // Depth buffer (cmd 158/159)
    const zb_addr: u32 = @intCast(@intFromPtr(zbp));
    state.sendCommandi(158, @truncate(zb_addr));
    state.sendCommandi(159, @truncate(((zb_addr & 0xff000000) >> 8) | config.buf_width));

    // Region clipping (cmd 21/22) — set by sceGuDispBuffer in native SDK via drawRegion()
    state.sendCommandi(21, 0);
    state.sendCommandi(22, ((@as(u24, config.height) - 1) << 10) | (@as(u24, config.width) - 1));

    // Viewport offset (cmd 76/77)
    const offset_x: u24 = 2048 - @as(u24, config.width / 2);
    const offset_y: u24 = 2048 - @as(u24, config.height / 2);
    state.sendCommandi(76, offset_x << 4);
    state.sendCommandi(77, offset_y << 4);

    // Viewport scale/center (cmd 66/67/69/70)
    state.sendCommandf(66, @as(f32, @floatFromInt(config.width / 2)));
    state.sendCommandf(67, @as(f32, @floatFromInt(-@as(i32, config.height / 2))));
    state.sendCommandf(69, 2048.0);
    state.sendCommandf(70, 2048.0);

    // Depth range (cmd 68/71) — matches sceGuDepthRange(65535, 0)
    const near: u16 = 65535;
    const far: u16 = 0;
    const max: i32 = @as(i32, near) + @as(i32, far);
    const val_i = ((max >> 31) + max);
    const z: f32 = @floatFromInt(val_i >> 1);

    state.contexts[state.curr_context].near_plane = near;
    state.contexts[state.curr_context].far_plane = far;

    // Note: @bitCast matches native SDK behavior (treats int bits as float ≈ 0)
    state.sendCommandf(68, z - @as(f32, @bitCast(@as(i32, near))));
    state.sendCommandf(71, z + @as(f32, @bitCast(state.contexts[state.curr_context].depth_offset)));

    // Depth clamp (cmd 214/215 = 0xD6/0xD7)
    if (near > far) {
        state.sendCommandi(214, far);
        state.sendCommandi(215, near);
    } else {
        state.sendCommandi(214, near);
        state.sendCommandi(215, far);
    }

    // Scissor (cmd 212/213 = 0xD4/0xD5)
    state.sendCommandi(212, 0);
    state.sendCommandi(213, ((@as(u24, config.height) - 1) << 10) | (@as(u24, config.width) - 1));

    // Scissor state tracking
    state.contexts[0].scissor_enable = 1;
    state.contexts[0].scissor_start = .{ 0, 0 };
    state.contexts[0].scissor_end = .{ config.width - 1, config.height - 1 };

    // Depth func (cmd 222 = 0xDE) — default GEQUAL, GL overrides per-frame
    state.sendCommandi(222, 7);

    // Disable clip planes (cmd 28)
    state.sendCommandi(28, 0);

    state.endDisplayList();

    // Wait for init display list to finish before touching the display
    _ = pspge.sceGeDrawSync(0);

    // DEBUG: dump init display list before it gets overwritten
    {
        const io_mod = @import("pspsdk").c.IoFileMgrForUser;
        // Read from uncached address (zpspgl writes via | 0x40000000)
        const uncached_base: [*]const u32 = @ptrFromInt(@intFromPtr(&state.display_list_buffer) | 0x40000000);
        // Find FINISH+END to determine length
        var len: usize = 0;
        for (0..state.display_list_buffer.len) |i| {
            len = i + 1;
            if ((uncached_base[i] >> 24) == 0x0F) {
                if (i + 1 < state.display_list_buffer.len and (uncached_base[i + 1] >> 24) == 0x0C) {
                    len = i + 2;
                }
                break;
            }
        }
        const fd = io_mod.sceIoOpen(@ptrCast("ms0:/gl_init_dl.bin"), 0x0602, 0o777);
        if (fd >= 0) {
            _ = io_mod.sceIoWrite(fd, uncached_base, @intCast(len * 4));
            _ = io_mod.sceIoClose(fd);
        }
    }

    _ = pspdisplay.sceDisplayWaitVblankStart();

    // --- Set display mode and enable ---
    _ = pspdisplay.sceDisplaySetMode(0, config.width, config.height);
    _ = pspdisplay.sceDisplaySetFrameBuf(
        @ptrFromInt(@intFromPtr(state.edram_address) + @intFromPtr(fbp1)),
        @intCast(config.buf_width),
        @intFromEnum(config.pixel_format),
        1, // NextVSync
    );
    state.display_on = true;

    // --- Start first rendering display list ---
    state.beginDisplayList();

    // Re-emit buffer config at start of first frame
    state.sendCommandi(156, @truncate(fb_addr));
    state.sendCommandi(157, @truncate(((fb_addr & 0xff000000) >> 8) | config.buf_width));
}

pub fn zglExit() void {
    _ = pspthreadman.sceKernelDeleteEventFlag(state.settings.kernel_event_flag);
    _ = pspge.sceGeUnsetCallback(state.settings.ge_callback_id);
}

/// Upload all dirty matrices to the GE display list. Called automatically
/// before draw commands (DrawArrays, DrawElements) once those are implemented.
/// Can also be called manually to force a matrix flush.
pub fn zglUpdateMatrices() void {
    state.uploadMatrices();
}

/// Override automatic VertexType detection. Pass 0 to re-enable auto-detection.
pub fn zglVertexType(vtype: u24) void {
    state.vertex_array.vertex_type_override = vtype;
}

/// Enable/disable the 2D transform bit (bit 23) in the vertex type.
pub fn zglTransform2D(enable: bool) void {
    state.vertex_array.transform_2d = enable;
}

/// Get the display list buffer start and current write position (for debugging).
pub fn zglGetDisplayList() struct { start: [*]const u32, current: [*]const u32 } {
    const ctx = &state.contexts[state.curr_context];
    return .{
        .start = @ptrFromInt(@intFromPtr(ctx.list.start) & ~@as(usize, 0x40000000)),
        .current = @ptrFromInt(@intFromPtr(ctx.list.current) & ~@as(usize, 0x40000000)),
    };
}

/// Finish the current frame, wait for GE, swap buffers, and start a new display list.
pub fn zglSwapBuffers() void {
    state.endDisplayList();
    _ = pspge.sceGeDrawSync(0); // wait for GE to finish rendering
    _ = pspdisplay.sceDisplayWaitVblankStart(); // wait for vsync to avoid tearing
    state.swapBuffers();
    state.beginDisplayList();

    // Re-emit frame buffer address for new draw target
    const fb_addr: u32 = @intCast(@intFromPtr(state.draw_buffer.frame_buffer));
    state.sendCommandi(156, @truncate(fb_addr));
    state.sendCommandi(157, @truncate(((fb_addr & 0xff000000) >> 8) | state.draw_buffer.frame_width));
}

// =============================================================================
// Internal helpers
// =============================================================================

/// Map GL primitive mode to GE primitive value (bits for cmd 4).
fn glPrimToGe(mode: GLenum) u24 {
    return switch (mode) {
        GL_POINTS => 0,
        GL_LINES => 1,
        GL_LINE_STRIP => 2,
        GL_TRIANGLES => 3,
        GL_TRIANGLE_STRIP => 4,
        GL_TRIANGLE_FAN => 5,
        else => @panic("zpspgl: unsupported primitive mode (GL_QUADS/GL_POLYGON/GL_LINE_LOOP not supported on PSP)"),
    };
}

/// Map GL vertex component type to GE position/texcoord/normal bits (1=byte, 2=short, 3=float).
fn glTypeToGeVtn(type_enum: u32) u24 {
    return switch (type_enum) {
        GL_BYTE => 1,
        GL_SHORT => 2,
        GL_FLOAT => 3,
        else => @panic("zpspgl: unsupported vertex type (only GL_BYTE, GL_SHORT, GL_FLOAT supported)"),
    };
}

/// Map GL format + type to GE pixel format (0-3). Panics on unsupported combos.
fn glFormatToGe(format: GLenum, pixel_type: GLenum) u8 {
    return switch (format) {
        GL_RGBA => switch (pixel_type) {
            GL_UNSIGNED_BYTE => 3, // Psm8888
            GL_UNSIGNED_SHORT => 2, // Psm4444 (best fit for 16-bit RGBA)
            else => @panic("zpspgl: unsupported pixel type for GL_RGBA"),
        },
        GL_RGB => switch (pixel_type) {
            GL_UNSIGNED_SHORT => 0, // Psm5650
            else => @panic("zpspgl: unsupported pixel type for GL_RGB"),
        },
        else => @panic("zpspgl: unsupported texture format (only GL_RGBA, GL_RGB supported)"),
    };
}

/// Map GL texture filter enum to GE filter value.
fn glFilterToGe(filter: GLenum) u8 {
    return switch (filter) {
        GL_NEAREST => 0,
        GL_LINEAR => 1,
        GL_NEAREST_MIPMAP_NEAREST => 4,
        GL_LINEAR_MIPMAP_NEAREST => 5,
        GL_NEAREST_MIPMAP_LINEAR => 6,
        GL_LINEAR_MIPMAP_LINEAR => 7,
        else => @panic("zpspgl: unsupported texture filter"),
    };
}

/// Map GL wrap enum to GE wrap value.
fn glWrapToGe(wrap: GLenum) u8 {
    return switch (wrap) {
        GL_REPEAT => 0,
        GL_CLAMP => 1,
        else => @panic("zpspgl: unsupported wrap mode (only GL_REPEAT, GL_CLAMP supported)"),
    };
}

/// Emit the GE filter command from the bound texture.
fn emitTexFilter() void {
    const tex = state.currentTexture();
    state.sendCommandi(198, (@as(u24, tex.mag_filter) << 8) | tex.min_filter);
}

/// Emit the GE wrap command from the bound texture.
fn emitTexWrap() void {
    const tex = state.currentTexture();
    state.sendCommandi(199, (@as(u24, tex.wrap_t) << 8) | tex.wrap_s);
}

/// Emit all GE texture commands for the bound texture object.
fn emitFullTextureState() void {
    const tex = state.currentTexture();
    if (tex.data_ptr == 0) return; // no texture data uploaded yet

    // Texture mode + format
    state.sendCommandi(194, 0); // no mipmaps, no CLUT, linear
    state.sendCommandi(195, tex.ge_format);

    // Texture image (level 0)
    state.sendCommandi(0xa0, @truncate(tex.data_ptr));
    state.sendCommandi(0xa8, @as(u24, @intCast((tex.data_ptr >> 8) & 0x0f0000)) | @as(u24, @intCast(tex.width)));
    state.sendCommandi(0xb8, @as(u24, @intCast(@ctz(tex.width))) | (@as(u24, @intCast(@ctz(tex.height))) << 8));

    // Texture flush
    state.sendCommandf(203, 0.0);

    // Filter + wrap
    state.sendCommandi(198, (@as(u24, tex.mag_filter) << 8) | tex.min_filter);
    state.sendCommandi(199, (@as(u24, tex.wrap_t) << 8) | tex.wrap_s);

    // Texture function
    state.sendCommandi(201, (@as(u24, tex.tex_color_comp) << 8) | tex.tex_func);

    // Scale + offset
    state.sendCommandf(72, 1.0);
    state.sendCommandf(73, 1.0);
    state.sendCommandf(74, 0.0);
    state.sendCommandf(75, 0.0);
}

/// Build a PSP GE VertexType u24 from current GL vertex array state.
/// Panics if the state cannot be mapped to PSP hardware.
fn buildVertexType() u24 {
    const va = &state.vertex_array;

    if (va.vertex_type_override != 0) return va.vertex_type_override;

    if (!va.vertex_enabled) @panic("zpspgl: GL_VERTEX_ARRAY must be enabled for drawing");

    var vtype: u24 = 0;

    // Texcoord: bits [1:0]
    if (va.texcoord_enabled) {
        vtype |= glTypeToGeVtn(va.texcoord.type_enum);
    }

    // Color: bits [4:2]
    if (va.color_enabled) {
        if (va.color.type_enum == GL_UNSIGNED_BYTE) {
            vtype |= @as(u24, 7) << 2; // GE_COLOR_8888
        } else {
            @panic("zpspgl: only GL_UNSIGNED_BYTE supported for color arrays");
        }
    }

    // Normal: bits [6:5]
    if (va.normal_enabled) {
        vtype |= glTypeToGeVtn(va.normal.type_enum) << 5;
    }

    // Position: bits [8:7]
    vtype |= glTypeToGeVtn(va.vertex.type_enum) << 7;

    // Transform 2D: bit 23
    if (va.transform_2d) {
        vtype |= @as(u24, 1) << 23;
    }

    return vtype;
}

// =============================================================================
// Types
// =============================================================================

pub const GLenum = c_uint;
pub const GLboolean = u8;
pub const GLbitfield = c_uint;
pub const GLbyte = i8;
pub const GLubyte = u8;
pub const GLshort = i16;
pub const GLushort = u16;
pub const GLint = c_int;
pub const GLuint = c_uint;
pub const GLsizei = c_int;
pub const GLfloat = f32;
pub const GLclampf = f32;
pub const GLdouble = f64;
pub const GLclampd = f64;

pub const GL_FALSE = 0;
pub const GL_TRUE = 1;

// =============================================================================
// Constants
// =============================================================================

pub const GL_2D: GLenum = 0x0600;
pub const GL_2_BYTES: GLenum = 0x1407;
pub const GL_3D: GLenum = 0x0601;
pub const GL_3D_COLOR: GLenum = 0x0602;
pub const GL_3D_COLOR_TEXTURE: GLenum = 0x0603;
pub const GL_3_BYTES: GLenum = 0x1408;
pub const GL_4D_COLOR_TEXTURE: GLenum = 0x0604;
pub const GL_4_BYTES: GLenum = 0x1409;
pub const GL_ACCUM: GLenum = 0x0100;
pub const GL_ACCUM_ALPHA_BITS: GLenum = 0x0D5B;
pub const GL_ACCUM_BLUE_BITS: GLenum = 0x0D5A;
pub const GL_ACCUM_BUFFER_BIT: GLenum = 0x00000200;
pub const GL_ACCUM_CLEAR_VALUE: GLenum = 0x0B80;
pub const GL_ACCUM_GREEN_BITS: GLenum = 0x0D59;
pub const GL_ACCUM_RED_BITS: GLenum = 0x0D58;
pub const GL_ADD: GLenum = 0x0104;
pub const GL_ALL_ATTRIB_BITS: GLbitfield = 0xFFFFFFFF;
pub const GL_ALPHA: GLenum = 0x1906;
pub const GL_ALPHA12: GLenum = 0x803D;
pub const GL_ALPHA16: GLenum = 0x803E;
pub const GL_ALPHA4: GLenum = 0x803B;
pub const GL_ALPHA8: GLenum = 0x803C;
pub const GL_ALPHA_BIAS: GLenum = 0x0D1D;
pub const GL_ALPHA_BITS: GLenum = 0x0D55;
pub const GL_ALPHA_SCALE: GLenum = 0x0D1C;
pub const GL_ALPHA_TEST: GLenum = 0x0BC0;
pub const GL_ALPHA_TEST_FUNC: GLenum = 0x0BC1;
pub const GL_ALPHA_TEST_REF: GLenum = 0x0BC2;
pub const GL_ALWAYS: GLenum = 0x0207;
pub const GL_AMBIENT: GLenum = 0x1200;
pub const GL_AMBIENT_AND_DIFFUSE: GLenum = 0x1602;
pub const GL_AND: GLenum = 0x1501;
pub const GL_AND_INVERTED: GLenum = 0x1504;
pub const GL_AND_REVERSE: GLenum = 0x1502;
pub const GL_ATTRIB_STACK_DEPTH: GLenum = 0x0BB0;
pub const GL_AUTO_NORMAL: GLenum = 0x0D80;
pub const GL_AUX0: GLenum = 0x0409;
pub const GL_AUX1: GLenum = 0x040A;
pub const GL_AUX2: GLenum = 0x040B;
pub const GL_AUX3: GLenum = 0x040C;
pub const GL_AUX_BUFFERS: GLenum = 0x0C00;
pub const GL_BACK: GLenum = 0x0405;
pub const GL_BACK_LEFT: GLenum = 0x0402;
pub const GL_BACK_RIGHT: GLenum = 0x0403;
pub const GL_BITMAP: GLenum = 0x1A00;
pub const GL_BITMAP_TOKEN: GLenum = 0x0704;
pub const GL_BLEND: GLenum = 0x0BE2;
pub const GL_BLEND_DST: GLenum = 0x0BE0;
pub const GL_BLEND_SRC: GLenum = 0x0BE1;
pub const GL_BLUE: GLenum = 0x1905;
pub const GL_BLUE_BIAS: GLenum = 0x0D1B;
pub const GL_BLUE_BITS: GLenum = 0x0D54;
pub const GL_BLUE_SCALE: GLenum = 0x0D1A;
pub const GL_BYTE: GLenum = 0x1400;
pub const GL_C3F_V3F: GLenum = 0x2A24;
pub const GL_C4F_N3F_V3F: GLenum = 0x2A26;
pub const GL_C4UB_V2F: GLenum = 0x2A22;
pub const GL_C4UB_V3F: GLenum = 0x2A23;
pub const GL_CCW: GLenum = 0x0901;
pub const GL_CLAMP: GLenum = 0x2900;
pub const GL_CLEAR: GLenum = 0x1500;
pub const GL_CLIENT_ALL_ATTRIB_BITS: GLbitfield = 0xFFFFFFFF;
pub const GL_CLIENT_ATTRIB_STACK_DEPTH: GLenum = 0x0BB1;
pub const GL_CLIENT_PIXEL_STORE_BIT: GLenum = 0x00000001;
pub const GL_CLIENT_VERTEX_ARRAY_BIT: GLenum = 0x00000002;
pub const GL_CLIP_PLANE0: GLenum = 0x3000;
pub const GL_CLIP_PLANE1: GLenum = 0x3001;
pub const GL_CLIP_PLANE2: GLenum = 0x3002;
pub const GL_CLIP_PLANE3: GLenum = 0x3003;
pub const GL_CLIP_PLANE4: GLenum = 0x3004;
pub const GL_CLIP_PLANE5: GLenum = 0x3005;
pub const GL_COEFF: GLenum = 0x0A00;
pub const GL_COLOR: GLenum = 0x1800;
pub const GL_COLOR_ARRAY: GLenum = 0x8076;
pub const GL_COLOR_ARRAY_POINTER: GLenum = 0x8090;
pub const GL_COLOR_ARRAY_SIZE: GLenum = 0x8081;
pub const GL_COLOR_ARRAY_STRIDE: GLenum = 0x8083;
pub const GL_COLOR_ARRAY_TYPE: GLenum = 0x8082;
pub const GL_COLOR_BUFFER_BIT: GLenum = 0x00004000;
pub const GL_COLOR_CLEAR_VALUE: GLenum = 0x0C22;
pub const GL_COLOR_INDEX: GLenum = 0x1900;
pub const GL_COLOR_INDEXES: GLenum = 0x1603;
pub const GL_COLOR_LOGIC_OP: GLenum = 0x0BF2;
pub const GL_COLOR_MATERIAL: GLenum = 0x0B57;
pub const GL_COLOR_MATERIAL_FACE: GLenum = 0x0B55;
pub const GL_COLOR_MATERIAL_PARAMETER: GLenum = 0x0B56;
pub const GL_COLOR_WRITEMASK: GLenum = 0x0C23;
pub const GL_COMPILE: GLenum = 0x1300;
pub const GL_COMPILE_AND_EXECUTE: GLenum = 0x1301;
pub const GL_CONSTANT_ATTENUATION: GLenum = 0x1207;
pub const GL_COPY: GLenum = 0x1503;
pub const GL_COPY_INVERTED: GLenum = 0x150C;
pub const GL_COPY_PIXEL_TOKEN: GLenum = 0x0706;
pub const GL_CULL_FACE: GLenum = 0x0B44;
pub const GL_CULL_FACE_MODE: GLenum = 0x0B45;
pub const GL_CURRENT_BIT: GLenum = 0x00000001;
pub const GL_CURRENT_COLOR: GLenum = 0x0B00;
pub const GL_CURRENT_INDEX: GLenum = 0x0B01;
pub const GL_CURRENT_NORMAL: GLenum = 0x0B02;
pub const GL_CURRENT_RASTER_COLOR: GLenum = 0x0B04;
pub const GL_CURRENT_RASTER_DISTANCE: GLenum = 0x0B09;
pub const GL_CURRENT_RASTER_INDEX: GLenum = 0x0B05;
pub const GL_CURRENT_RASTER_POSITION: GLenum = 0x0B07;
pub const GL_CURRENT_RASTER_POSITION_VALID: GLenum = 0x0B08;
pub const GL_CURRENT_RASTER_TEXTURE_COORDS: GLenum = 0x0B06;
pub const GL_CURRENT_TEXTURE_COORDS: GLenum = 0x0B03;
pub const GL_CW: GLenum = 0x0900;
pub const GL_DECAL: GLenum = 0x2101;
pub const GL_DECR: GLenum = 0x1E03;
pub const GL_DEPTH: GLenum = 0x1801;
pub const GL_DEPTH_BIAS: GLenum = 0x0D1F;
pub const GL_DEPTH_BITS: GLenum = 0x0D56;
pub const GL_DEPTH_BUFFER_BIT: GLenum = 0x00000100;
pub const GL_DEPTH_CLEAR_VALUE: GLenum = 0x0B73;
pub const GL_DEPTH_COMPONENT: GLenum = 0x1902;
pub const GL_DEPTH_FUNC: GLenum = 0x0B74;
pub const GL_DEPTH_RANGE: GLenum = 0x0B70;
pub const GL_DEPTH_SCALE: GLenum = 0x0D1E;
pub const GL_DEPTH_TEST: GLenum = 0x0B71;
pub const GL_DEPTH_WRITEMASK: GLenum = 0x0B72;
pub const GL_DIFFUSE: GLenum = 0x1201;
pub const GL_DITHER: GLenum = 0x0BD0;
pub const GL_DOMAIN: GLenum = 0x0A02;
pub const GL_DONT_CARE: GLenum = 0x1100;
pub const GL_DOUBLE: GLenum = 0x140A;
pub const GL_DOUBLEBUFFER: GLenum = 0x0C32;
pub const GL_DRAW_BUFFER: GLenum = 0x0C01;
pub const GL_DRAW_PIXEL_TOKEN: GLenum = 0x0705;
pub const GL_DST_ALPHA: GLenum = 0x0304;
pub const GL_DST_COLOR: GLenum = 0x0306;
pub const GL_EDGE_FLAG: GLenum = 0x0B43;
pub const GL_EDGE_FLAG_ARRAY: GLenum = 0x8079;
pub const GL_EDGE_FLAG_ARRAY_POINTER: GLenum = 0x8093;
pub const GL_EDGE_FLAG_ARRAY_STRIDE: GLenum = 0x808C;
pub const GL_EMISSION: GLenum = 0x1600;
pub const GL_ENABLE_BIT: GLenum = 0x00002000;
pub const GL_EQUAL: GLenum = 0x0202;
pub const GL_EQUIV: GLenum = 0x1509;
pub const GL_EVAL_BIT: GLenum = 0x00010000;
pub const GL_EXP: GLenum = 0x0800;
pub const GL_EXP2: GLenum = 0x0801;
pub const GL_EXTENSIONS: GLenum = 0x1F03;
pub const GL_EYE_LINEAR: GLenum = 0x2400;
pub const GL_EYE_PLANE: GLenum = 0x2502;
pub const GL_FASTEST: GLenum = 0x1101;
pub const GL_FEEDBACK: GLenum = 0x1C01;
pub const GL_FEEDBACK_BUFFER_POINTER: GLenum = 0x0DF0;
pub const GL_FEEDBACK_BUFFER_SIZE: GLenum = 0x0DF1;
pub const GL_FEEDBACK_BUFFER_TYPE: GLenum = 0x0DF2;
pub const GL_FILL: GLenum = 0x1B02;
pub const GL_FLAT: GLenum = 0x1D00;
pub const GL_FLOAT: GLenum = 0x1406;
pub const GL_FOG: GLenum = 0x0B60;
pub const GL_FOG_BIT: GLenum = 0x00000080;
pub const GL_FOG_COLOR: GLenum = 0x0B66;
pub const GL_FOG_DENSITY: GLenum = 0x0B62;
pub const GL_FOG_END: GLenum = 0x0B64;
pub const GL_FOG_HINT: GLenum = 0x0C54;
pub const GL_FOG_INDEX: GLenum = 0x0B61;
pub const GL_FOG_MODE: GLenum = 0x0B65;
pub const GL_FOG_START: GLenum = 0x0B63;
pub const GL_FRONT: GLenum = 0x0404;
pub const GL_FRONT_AND_BACK: GLenum = 0x0408;
pub const GL_FRONT_FACE: GLenum = 0x0B46;
pub const GL_FRONT_LEFT: GLenum = 0x0400;
pub const GL_FRONT_RIGHT: GLenum = 0x0401;
pub const GL_GEQUAL: GLenum = 0x0206;
pub const GL_GREATER: GLenum = 0x0204;
pub const GL_GREEN: GLenum = 0x1904;
pub const GL_GREEN_BIAS: GLenum = 0x0D19;
pub const GL_GREEN_BITS: GLenum = 0x0D53;
pub const GL_GREEN_SCALE: GLenum = 0x0D18;
pub const GL_HINT_BIT: GLenum = 0x00008000;
pub const GL_INCR: GLenum = 0x1E02;
pub const GL_INDEX_ARRAY: GLenum = 0x8077;
pub const GL_INDEX_ARRAY_POINTER: GLenum = 0x8091;
pub const GL_INDEX_ARRAY_STRIDE: GLenum = 0x8086;
pub const GL_INDEX_ARRAY_TYPE: GLenum = 0x8085;
pub const GL_INDEX_BITS: GLenum = 0x0D51;
pub const GL_INDEX_CLEAR_VALUE: GLenum = 0x0C20;
pub const GL_INDEX_LOGIC_OP: GLenum = 0x0BF1;
pub const GL_INDEX_MODE: GLenum = 0x0C30;
pub const GL_INDEX_OFFSET: GLenum = 0x0D13;
pub const GL_INDEX_SHIFT: GLenum = 0x0D12;
pub const GL_INDEX_WRITEMASK: GLenum = 0x0C21;
pub const GL_INT: GLenum = 0x1404;
pub const GL_INTENSITY: GLenum = 0x8049;
pub const GL_INTENSITY12: GLenum = 0x804C;
pub const GL_INTENSITY16: GLenum = 0x804D;
pub const GL_INTENSITY4: GLenum = 0x804A;
pub const GL_INTENSITY8: GLenum = 0x804B;
pub const GL_INVALID_ENUM: GLenum = 0x0500;
pub const GL_INVALID_OPERATION: GLenum = 0x0502;
pub const GL_INVALID_VALUE: GLenum = 0x0501;
pub const GL_INVERT: GLenum = 0x150A;
pub const GL_KEEP: GLenum = 0x1E00;
pub const GL_LEFT: GLenum = 0x0406;
pub const GL_LEQUAL: GLenum = 0x0203;
pub const GL_LESS: GLenum = 0x0201;
pub const GL_LIGHT0: GLenum = 0x4000;
pub const GL_LIGHT1: GLenum = 0x4001;
pub const GL_LIGHT2: GLenum = 0x4002;
pub const GL_LIGHT3: GLenum = 0x4003;
pub const GL_LIGHT4: GLenum = 0x4004;
pub const GL_LIGHT5: GLenum = 0x4005;
pub const GL_LIGHT6: GLenum = 0x4006;
pub const GL_LIGHT7: GLenum = 0x4007;
pub const GL_LIGHTING: GLenum = 0x0B50;
pub const GL_LIGHTING_BIT: GLenum = 0x00000040;
pub const GL_LIGHT_MODEL_AMBIENT: GLenum = 0x0B53;
pub const GL_LIGHT_MODEL_LOCAL_VIEWER: GLenum = 0x0B51;
pub const GL_LIGHT_MODEL_TWO_SIDE: GLenum = 0x0B52;
pub const GL_LINE: GLenum = 0x1B01;
pub const GL_LINEAR: GLenum = 0x2601;
pub const GL_LINEAR_ATTENUATION: GLenum = 0x1208;
pub const GL_LINEAR_MIPMAP_LINEAR: GLenum = 0x2703;
pub const GL_LINEAR_MIPMAP_NEAREST: GLenum = 0x2701;
pub const GL_LINES: GLenum = 0x0001;
pub const GL_LINE_BIT: GLenum = 0x00000004;
pub const GL_LINE_LOOP: GLenum = 0x0002;
pub const GL_LINE_RESET_TOKEN: GLenum = 0x0707;
pub const GL_LINE_SMOOTH: GLenum = 0x0B20;
pub const GL_LINE_SMOOTH_HINT: GLenum = 0x0C52;
pub const GL_LINE_STIPPLE: GLenum = 0x0B24;
pub const GL_LINE_STIPPLE_PATTERN: GLenum = 0x0B25;
pub const GL_LINE_STIPPLE_REPEAT: GLenum = 0x0B26;
pub const GL_LINE_STRIP: GLenum = 0x0003;
pub const GL_LINE_TOKEN: GLenum = 0x0702;
pub const GL_LINE_WIDTH: GLenum = 0x0B21;
pub const GL_LINE_WIDTH_GRANULARITY: GLenum = 0x0B23;
pub const GL_LINE_WIDTH_RANGE: GLenum = 0x0B22;
pub const GL_LIST_BASE: GLenum = 0x0B32;
pub const GL_LIST_BIT: GLenum = 0x00020000;
pub const GL_LIST_INDEX: GLenum = 0x0B33;
pub const GL_LIST_MODE: GLenum = 0x0B30;
pub const GL_LOAD: GLenum = 0x0101;
pub const GL_LOGIC_OP: GLenum = 0x0BF1;
pub const GL_LOGIC_OP_MODE: GLenum = 0x0BF0;
pub const GL_LUMINANCE: GLenum = 0x1909;
pub const GL_LUMINANCE12: GLenum = 0x8041;
pub const GL_LUMINANCE12_ALPHA12: GLenum = 0x8047;
pub const GL_LUMINANCE12_ALPHA4: GLenum = 0x8046;
pub const GL_LUMINANCE16: GLenum = 0x8042;
pub const GL_LUMINANCE16_ALPHA16: GLenum = 0x8048;
pub const GL_LUMINANCE4: GLenum = 0x803F;
pub const GL_LUMINANCE4_ALPHA4: GLenum = 0x8043;
pub const GL_LUMINANCE6_ALPHA2: GLenum = 0x8044;
pub const GL_LUMINANCE8: GLenum = 0x8040;
pub const GL_LUMINANCE8_ALPHA8: GLenum = 0x8045;
pub const GL_LUMINANCE_ALPHA: GLenum = 0x190A;
pub const GL_MAP1_COLOR_4: GLenum = 0x0D90;
pub const GL_MAP1_GRID_DOMAIN: GLenum = 0x0DD0;
pub const GL_MAP1_GRID_SEGMENTS: GLenum = 0x0DD1;
pub const GL_MAP1_INDEX: GLenum = 0x0D91;
pub const GL_MAP1_NORMAL: GLenum = 0x0D92;
pub const GL_MAP1_TEXTURE_COORD_1: GLenum = 0x0D93;
pub const GL_MAP1_TEXTURE_COORD_2: GLenum = 0x0D94;
pub const GL_MAP1_TEXTURE_COORD_3: GLenum = 0x0D95;
pub const GL_MAP1_TEXTURE_COORD_4: GLenum = 0x0D96;
pub const GL_MAP1_VERTEX_3: GLenum = 0x0D97;
pub const GL_MAP1_VERTEX_4: GLenum = 0x0D98;
pub const GL_MAP2_COLOR_4: GLenum = 0x0DB0;
pub const GL_MAP2_GRID_DOMAIN: GLenum = 0x0DD2;
pub const GL_MAP2_GRID_SEGMENTS: GLenum = 0x0DD3;
pub const GL_MAP2_INDEX: GLenum = 0x0DB1;
pub const GL_MAP2_NORMAL: GLenum = 0x0DB2;
pub const GL_MAP2_TEXTURE_COORD_1: GLenum = 0x0DB3;
pub const GL_MAP2_TEXTURE_COORD_2: GLenum = 0x0DB4;
pub const GL_MAP2_TEXTURE_COORD_3: GLenum = 0x0DB5;
pub const GL_MAP2_TEXTURE_COORD_4: GLenum = 0x0DB6;
pub const GL_MAP2_VERTEX_3: GLenum = 0x0DB7;
pub const GL_MAP2_VERTEX_4: GLenum = 0x0DB8;
pub const GL_MAP_COLOR: GLenum = 0x0D10;
pub const GL_MAP_STENCIL: GLenum = 0x0D11;
pub const GL_MATRIX_MODE: GLenum = 0x0BA0;
pub const GL_MAX_ATTRIB_STACK_DEPTH: GLenum = 0x0D35;
pub const GL_MAX_CLIENT_ATTRIB_STACK_DEPTH: GLenum = 0x0D3B;
pub const GL_MAX_CLIP_PLANES: GLenum = 0x0D32;
pub const GL_MAX_EVAL_ORDER: GLenum = 0x0D30;
pub const GL_MAX_LIGHTS: GLenum = 0x0D31;
pub const GL_MAX_LIST_NESTING: GLenum = 0x0B31;
pub const GL_MAX_MODELVIEW_STACK_DEPTH: GLenum = 0x0D36;
pub const GL_MAX_NAME_STACK_DEPTH: GLenum = 0x0D37;
pub const GL_MAX_PIXEL_MAP_TABLE: GLenum = 0x0D34;
pub const GL_MAX_PROJECTION_STACK_DEPTH: GLenum = 0x0D38;
pub const GL_MAX_TEXTURE_SIZE: GLenum = 0x0D33;
pub const GL_MAX_TEXTURE_STACK_DEPTH: GLenum = 0x0D39;
pub const GL_MAX_VIEWPORT_DIMS: GLenum = 0x0D3A;
pub const GL_MODELVIEW: GLenum = 0x1700;
pub const GL_MODELVIEW_MATRIX: GLenum = 0x0BA6;
pub const GL_MODELVIEW_STACK_DEPTH: GLenum = 0x0BA3;
pub const GL_MODULATE: GLenum = 0x2100;
pub const GL_MULT: GLenum = 0x0103;
pub const GL_N3F_V3F: GLenum = 0x2A25;
pub const GL_NAME_STACK_DEPTH: GLenum = 0x0D70;
pub const GL_NAND: GLenum = 0x150E;
pub const GL_NEAREST: GLenum = 0x2600;
pub const GL_NEAREST_MIPMAP_LINEAR: GLenum = 0x2702;
pub const GL_NEAREST_MIPMAP_NEAREST: GLenum = 0x2700;
pub const GL_NEVER: GLenum = 0x0200;
pub const GL_NICEST: GLenum = 0x1102;
pub const GL_NONE: GLenum = 0;
pub const GL_NOOP: GLenum = 0x1505;
pub const GL_NOR: GLenum = 0x1508;
pub const GL_NORMALIZE: GLenum = 0x0BA1;
pub const GL_NORMAL_ARRAY: GLenum = 0x8075;
pub const GL_NORMAL_ARRAY_POINTER: GLenum = 0x808F;
pub const GL_NORMAL_ARRAY_STRIDE: GLenum = 0x807F;
pub const GL_NORMAL_ARRAY_TYPE: GLenum = 0x807E;
pub const GL_NOTEQUAL: GLenum = 0x0205;
pub const GL_NO_ERROR: GLenum = 0;
pub const GL_OBJECT_LINEAR: GLenum = 0x2401;
pub const GL_OBJECT_PLANE: GLenum = 0x2501;
pub const GL_ONE: GLenum = 1;
pub const GL_ONE_MINUS_DST_ALPHA: GLenum = 0x0305;
pub const GL_ONE_MINUS_DST_COLOR: GLenum = 0x0307;
pub const GL_ONE_MINUS_SRC_ALPHA: GLenum = 0x0303;
pub const GL_ONE_MINUS_SRC_COLOR: GLenum = 0x0301;
pub const GL_OR: GLenum = 0x1507;
pub const GL_ORDER: GLenum = 0x0A01;
pub const GL_OR_INVERTED: GLenum = 0x150D;
pub const GL_OR_REVERSE: GLenum = 0x150B;
pub const GL_OUT_OF_MEMORY: GLenum = 0x0505;
pub const GL_PACK_ALIGNMENT: GLenum = 0x0D05;
pub const GL_PACK_LSB_FIRST: GLenum = 0x0D01;
pub const GL_PACK_ROW_LENGTH: GLenum = 0x0D02;
pub const GL_PACK_SKIP_PIXELS: GLenum = 0x0D04;
pub const GL_PACK_SKIP_ROWS: GLenum = 0x0D03;
pub const GL_PACK_SWAP_BYTES: GLenum = 0x0D00;
pub const GL_PASS_THROUGH_TOKEN: GLenum = 0x0700;
pub const GL_PERSPECTIVE_CORRECTION_HINT: GLenum = 0x0C50;
pub const GL_PIXEL_MAP_A_TO_A: GLenum = 0x0C79;
pub const GL_PIXEL_MAP_A_TO_A_SIZE: GLenum = 0x0CB9;
pub const GL_PIXEL_MAP_B_TO_B: GLenum = 0x0C78;
pub const GL_PIXEL_MAP_B_TO_B_SIZE: GLenum = 0x0CB8;
pub const GL_PIXEL_MAP_G_TO_G: GLenum = 0x0C77;
pub const GL_PIXEL_MAP_G_TO_G_SIZE: GLenum = 0x0CB7;
pub const GL_PIXEL_MAP_I_TO_A: GLenum = 0x0C75;
pub const GL_PIXEL_MAP_I_TO_A_SIZE: GLenum = 0x0CB5;
pub const GL_PIXEL_MAP_I_TO_B: GLenum = 0x0C74;
pub const GL_PIXEL_MAP_I_TO_B_SIZE: GLenum = 0x0CB4;
pub const GL_PIXEL_MAP_I_TO_G: GLenum = 0x0C73;
pub const GL_PIXEL_MAP_I_TO_G_SIZE: GLenum = 0x0CB3;
pub const GL_PIXEL_MAP_I_TO_I: GLenum = 0x0C70;
pub const GL_PIXEL_MAP_I_TO_I_SIZE: GLenum = 0x0CB0;
pub const GL_PIXEL_MAP_I_TO_R: GLenum = 0x0C72;
pub const GL_PIXEL_MAP_I_TO_R_SIZE: GLenum = 0x0CB2;
pub const GL_PIXEL_MAP_R_TO_R: GLenum = 0x0C76;
pub const GL_PIXEL_MAP_R_TO_R_SIZE: GLenum = 0x0CB6;
pub const GL_PIXEL_MAP_S_TO_S: GLenum = 0x0C71;
pub const GL_PIXEL_MAP_S_TO_S_SIZE: GLenum = 0x0CB1;
pub const GL_PIXEL_MODE_BIT: GLenum = 0x00000020;
pub const GL_POINT: GLenum = 0x1B00;
pub const GL_POINTS: GLenum = 0x0000;
pub const GL_POINT_BIT: GLenum = 0x00000002;
pub const GL_POINT_SIZE: GLenum = 0x0B11;
pub const GL_POINT_SIZE_GRANULARITY: GLenum = 0x0B13;
pub const GL_POINT_SIZE_RANGE: GLenum = 0x0B12;
pub const GL_POINT_SMOOTH: GLenum = 0x0B10;
pub const GL_POINT_SMOOTH_HINT: GLenum = 0x0C51;
pub const GL_POINT_TOKEN: GLenum = 0x0701;
pub const GL_POLYGON: GLenum = 0x0009;
pub const GL_POLYGON_BIT: GLenum = 0x00000008;
pub const GL_POLYGON_MODE: GLenum = 0x0B40;
pub const GL_POLYGON_OFFSET_FACTOR: GLenum = 0x8038;
pub const GL_POLYGON_OFFSET_FILL: GLenum = 0x8037;
pub const GL_POLYGON_OFFSET_LINE: GLenum = 0x2A02;
pub const GL_POLYGON_OFFSET_POINT: GLenum = 0x2A01;
pub const GL_POLYGON_OFFSET_UNITS: GLenum = 0x2A00;
pub const GL_POLYGON_SMOOTH: GLenum = 0x0B41;
pub const GL_POLYGON_SMOOTH_HINT: GLenum = 0x0C53;
pub const GL_POLYGON_STIPPLE: GLenum = 0x0B42;
pub const GL_POLYGON_STIPPLE_BIT: GLenum = 0x00000010;
pub const GL_POLYGON_TOKEN: GLenum = 0x0703;
pub const GL_POSITION: GLenum = 0x1203;
pub const GL_PROJECTION: GLenum = 0x1701;
pub const GL_PROJECTION_MATRIX: GLenum = 0x0BA7;
pub const GL_PROJECTION_STACK_DEPTH: GLenum = 0x0BA4;
pub const GL_PROXY_TEXTURE_1D: GLenum = 0x8063;
pub const GL_PROXY_TEXTURE_2D: GLenum = 0x8064;
pub const GL_Q: GLenum = 0x2003;
pub const GL_QUADRATIC_ATTENUATION: GLenum = 0x1209;
pub const GL_QUADS: GLenum = 0x0007;
pub const GL_QUAD_STRIP: GLenum = 0x0008;
pub const GL_R: GLenum = 0x2002;
pub const GL_R3_G3_B2: GLenum = 0x2A10;
pub const GL_READ_BUFFER: GLenum = 0x0C02;
pub const GL_RED: GLenum = 0x1903;
pub const GL_RED_BIAS: GLenum = 0x0D15;
pub const GL_RED_BITS: GLenum = 0x0D52;
pub const GL_RED_SCALE: GLenum = 0x0D14;
pub const GL_RENDER: GLenum = 0x1C00;
pub const GL_RENDERER: GLenum = 0x1F01;
pub const GL_RENDER_MODE: GLenum = 0x0C40;
pub const GL_REPEAT: GLenum = 0x2901;
pub const GL_REPLACE: GLenum = 0x1E01;
pub const GL_RETURN: GLenum = 0x0102;
pub const GL_RGB: GLenum = 0x1907;
pub const GL_RGB10: GLenum = 0x8052;
pub const GL_RGB10_A2: GLenum = 0x8059;
pub const GL_RGB12: GLenum = 0x8053;
pub const GL_RGB16: GLenum = 0x8054;
pub const GL_RGB4: GLenum = 0x804F;
pub const GL_RGB5: GLenum = 0x8050;
pub const GL_RGB5_A1: GLenum = 0x8057;
pub const GL_RGB8: GLenum = 0x8051;
pub const GL_RGBA: GLenum = 0x1908;
pub const GL_RGBA12: GLenum = 0x805A;
pub const GL_RGBA16: GLenum = 0x805B;
pub const GL_RGBA2: GLenum = 0x8055;
pub const GL_RGBA4: GLenum = 0x8056;
pub const GL_RGBA8: GLenum = 0x8058;
pub const GL_RGBA_MODE: GLenum = 0x0C31;
pub const GL_RIGHT: GLenum = 0x0407;
pub const GL_S: GLenum = 0x2000;
pub const GL_SCISSOR_BIT: GLenum = 0x00080000;
pub const GL_SCISSOR_BOX: GLenum = 0x0C10;
pub const GL_SCISSOR_TEST: GLenum = 0x0C11;
pub const GL_SELECT: GLenum = 0x1C02;
pub const GL_SELECTION_BUFFER_POINTER: GLenum = 0x0DF3;
pub const GL_SELECTION_BUFFER_SIZE: GLenum = 0x0DF4;
pub const GL_SET: GLenum = 0x150F;
pub const GL_SHADE_MODEL: GLenum = 0x0B54;
pub const GL_SHININESS: GLenum = 0x1601;
pub const GL_SHORT: GLenum = 0x1402;
pub const GL_SMOOTH: GLenum = 0x1D01;
pub const GL_SPECULAR: GLenum = 0x1202;
pub const GL_SPHERE_MAP: GLenum = 0x2402;
pub const GL_SPOT_CUTOFF: GLenum = 0x1206;
pub const GL_SPOT_DIRECTION: GLenum = 0x1204;
pub const GL_SPOT_EXPONENT: GLenum = 0x1205;
pub const GL_SRC_ALPHA: GLenum = 0x0302;
pub const GL_SRC_ALPHA_SATURATE: GLenum = 0x0308;
pub const GL_SRC_COLOR: GLenum = 0x0300;
pub const GL_STACK_OVERFLOW: GLenum = 0x0503;
pub const GL_STACK_UNDERFLOW: GLenum = 0x0504;
pub const GL_STENCIL: GLenum = 0x1802;
pub const GL_STENCIL_BITS: GLenum = 0x0D57;
pub const GL_STENCIL_BUFFER_BIT: GLenum = 0x00000400;
pub const GL_STENCIL_CLEAR_VALUE: GLenum = 0x0B91;
pub const GL_STENCIL_FAIL: GLenum = 0x0B94;
pub const GL_STENCIL_FUNC: GLenum = 0x0B92;
pub const GL_STENCIL_INDEX: GLenum = 0x1901;
pub const GL_STENCIL_PASS_DEPTH_FAIL: GLenum = 0x0B95;
pub const GL_STENCIL_PASS_DEPTH_PASS: GLenum = 0x0B96;
pub const GL_STENCIL_REF: GLenum = 0x0B97;
pub const GL_STENCIL_TEST: GLenum = 0x0B90;
pub const GL_STENCIL_VALUE_MASK: GLenum = 0x0B93;
pub const GL_STENCIL_WRITEMASK: GLenum = 0x0B98;
pub const GL_STEREO: GLenum = 0x0C33;
pub const GL_SUBPIXEL_BITS: GLenum = 0x0D50;
pub const GL_T: GLenum = 0x2001;
pub const GL_T2F_C3F_V3F: GLenum = 0x2A2A;
pub const GL_T2F_C4F_N3F_V3F: GLenum = 0x2A2C;
pub const GL_T2F_C4UB_V3F: GLenum = 0x2A29;
pub const GL_T2F_N3F_V3F: GLenum = 0x2A2B;
pub const GL_T2F_V3F: GLenum = 0x2A27;
pub const GL_T4F_C4F_N3F_V4F: GLenum = 0x2A2D;
pub const GL_T4F_V4F: GLenum = 0x2A28;
pub const GL_TEXTURE: GLenum = 0x1702;
pub const GL_TEXTURE_1D: GLenum = 0x0DE0;
pub const GL_TEXTURE_2D: GLenum = 0x0DE1;
pub const GL_TEXTURE_ALPHA_SIZE: GLenum = 0x805F;
pub const GL_TEXTURE_BINDING_1D: GLenum = 0x8068;
pub const GL_TEXTURE_BINDING_2D: GLenum = 0x8069;
pub const GL_TEXTURE_BIT: GLenum = 0x00040000;
pub const GL_TEXTURE_BLUE_SIZE: GLenum = 0x805E;
pub const GL_TEXTURE_BORDER: GLenum = 0x1005;
pub const GL_TEXTURE_BORDER_COLOR: GLenum = 0x1004;
pub const GL_TEXTURE_COMPONENTS: GLenum = 0x1003;
pub const GL_TEXTURE_COORD_ARRAY: GLenum = 0x8078;
pub const GL_TEXTURE_COORD_ARRAY_POINTER: GLenum = 0x8092;
pub const GL_TEXTURE_COORD_ARRAY_SIZE: GLenum = 0x8088;
pub const GL_TEXTURE_COORD_ARRAY_STRIDE: GLenum = 0x808A;
pub const GL_TEXTURE_COORD_ARRAY_TYPE: GLenum = 0x8089;
pub const GL_TEXTURE_ENV: GLenum = 0x2300;
pub const GL_TEXTURE_ENV_COLOR: GLenum = 0x2201;
pub const GL_TEXTURE_ENV_MODE: GLenum = 0x2200;
pub const GL_TEXTURE_GEN_MODE: GLenum = 0x2500;
pub const GL_TEXTURE_GEN_Q: GLenum = 0x0C63;
pub const GL_TEXTURE_GEN_R: GLenum = 0x0C62;
pub const GL_TEXTURE_GEN_S: GLenum = 0x0C60;
pub const GL_TEXTURE_GEN_T: GLenum = 0x0C61;
pub const GL_TEXTURE_GREEN_SIZE: GLenum = 0x805D;
pub const GL_TEXTURE_HEIGHT: GLenum = 0x1001;
pub const GL_TEXTURE_INTENSITY_SIZE: GLenum = 0x8061;
pub const GL_TEXTURE_INTERNAL_FORMAT: GLenum = 0x1003;
pub const GL_TEXTURE_LUMINANCE_SIZE: GLenum = 0x8060;
pub const GL_TEXTURE_MAG_FILTER: GLenum = 0x2800;
pub const GL_TEXTURE_MATRIX: GLenum = 0x0BA8;
pub const GL_TEXTURE_MIN_FILTER: GLenum = 0x2801;
pub const GL_TEXTURE_PRIORITY: GLenum = 0x8066;
pub const GL_TEXTURE_RED_SIZE: GLenum = 0x805C;
pub const GL_TEXTURE_RESIDENT: GLenum = 0x8067;
pub const GL_TEXTURE_STACK_DEPTH: GLenum = 0x0BA5;
pub const GL_TEXTURE_WIDTH: GLenum = 0x1000;
pub const GL_TEXTURE_WRAP_S: GLenum = 0x2802;
pub const GL_TEXTURE_WRAP_T: GLenum = 0x2803;
pub const GL_TRANSFORM_BIT: GLenum = 0x00001000;
pub const GL_TRIANGLES: GLenum = 0x0004;
pub const GL_TRIANGLE_FAN: GLenum = 0x0006;
pub const GL_TRIANGLE_STRIP: GLenum = 0x0005;
pub const GL_UNPACK_ALIGNMENT: GLenum = 0x0CF5;
pub const GL_UNPACK_LSB_FIRST: GLenum = 0x0CF1;
pub const GL_UNPACK_ROW_LENGTH: GLenum = 0x0CF2;
pub const GL_UNPACK_SKIP_PIXELS: GLenum = 0x0CF4;
pub const GL_UNPACK_SKIP_ROWS: GLenum = 0x0CF3;
pub const GL_UNPACK_SWAP_BYTES: GLenum = 0x0CF0;
pub const GL_UNSIGNED_BYTE: GLenum = 0x1401;
pub const GL_UNSIGNED_INT: GLenum = 0x1405;
pub const GL_UNSIGNED_SHORT: GLenum = 0x1403;
pub const GL_V2F: GLenum = 0x2A20;
pub const GL_V3F: GLenum = 0x2A21;
pub const GL_VENDOR: GLenum = 0x1F00;
pub const GL_VERSION: GLenum = 0x1F02;
pub const GL_VERTEX_ARRAY: GLenum = 0x8074;
pub const GL_VERTEX_ARRAY_POINTER: GLenum = 0x808E;
pub const GL_VERTEX_ARRAY_SIZE: GLenum = 0x807A;
pub const GL_VERTEX_ARRAY_STRIDE: GLenum = 0x807C;
pub const GL_VERTEX_ARRAY_TYPE: GLenum = 0x807B;
pub const GL_VIEWPORT: GLenum = 0x0BA2;
pub const GL_VIEWPORT_BIT: GLenum = 0x00000800;
pub const GL_XOR: GLenum = 0x1506;
pub const GL_ZERO: GLenum = 0;
pub const GL_ZOOM_X: GLenum = 0x0D16;
pub const GL_ZOOM_Y: GLenum = 0x0D17;

// =============================================================================
// Internal Helpers
// =============================================================================

fn glStencilOpToGe(op: GLenum) u24 {
    return switch (op) {
        GL_KEEP => 0,
        GL_ZERO => 1,
        GL_REPLACE => 2,
        GL_INVERT => 3,
        GL_INCR => 4,
        GL_DECR => 5,
        else => 0, // default to keep
    };
}

/// Maps GL blend factor to GE blend factor + fixed color value.
/// GE blend factors: OtherColor=0, 1-OtherColor=1, SrcAlpha=2, 1-SrcAlpha=3,
/// DstAlpha=4, 1-DstAlpha=5, 2xSrcAlpha=6, 1-2xSrcAlpha=7,
/// 2xDstAlpha=8, 1-2xDstAlpha=9, Fix=10
/// For GL_ZERO/GL_ONE we use Fix with fixed_value 0x000000/0xFFFFFF.
const BlendMapping = struct { factor: u24, fixed: u24 };
fn glBlendFactorToGe(factor: GLenum, is_src: bool) BlendMapping {
    return switch (factor) {
        GL_ZERO => .{ .factor = 10, .fixed = 0x000000 },
        GL_ONE => .{ .factor = 10, .fixed = 0xFFFFFF },
        GL_SRC_ALPHA => .{ .factor = 2, .fixed = 0 },
        GL_ONE_MINUS_SRC_ALPHA => .{ .factor = 3, .fixed = 0 },
        GL_DST_ALPHA => .{ .factor = 4, .fixed = 0 },
        GL_ONE_MINUS_DST_ALPHA => .{ .factor = 5, .fixed = 0 },
        GL_SRC_COLOR => .{ .factor = if (is_src) 6 else 0, .fixed = 0 }, // src: 2xSrcAlpha approx, dst: OtherColor
        GL_DST_COLOR => .{ .factor = if (is_src) 0 else 6, .fixed = 0 },
        GL_ONE_MINUS_SRC_COLOR => .{ .factor = if (is_src) 7 else 1, .fixed = 0 },
        GL_ONE_MINUS_DST_COLOR => .{ .factor = if (is_src) 1 else 7, .fixed = 0 },
        GL_SRC_ALPHA_SATURATE => .{ .factor = 2, .fixed = 0 }, // approximate
        else => .{ .factor = 10, .fixed = 0xFFFFFF },
    };
}

fn glCapToGeCmd(cap: GLenum) ?u8 {
    return switch (cap) {
        GL_ALPHA_TEST => 34,
        GL_DEPTH_TEST => 35,
        GL_STENCIL_TEST => 36,
        GL_BLEND => 33,
        GL_CULL_FACE => 29,
        GL_DITHER => 32,
        GL_FOG => 31,
        GL_TEXTURE_2D => 30,
        GL_LIGHTING => 23,
        GL_LIGHT0 => 24,
        GL_LIGHT1 => 25,
        GL_LIGHT2 => 26,
        GL_LIGHT3 => 27,
        GL_LINE_SMOOTH => 37,
        GL_COLOR_LOGIC_OP => 40,
        GL_CLIP_PLANE0,
        GL_CLIP_PLANE1,
        GL_CLIP_PLANE2,
        GL_CLIP_PLANE3,
        GL_CLIP_PLANE4,
        GL_CLIP_PLANE5,
        => 28,
        else => null,
    };
}

// =============================================================================
// Functions
// =============================================================================

pub fn AlphaFunc(_func: GLenum, _ref: GLfloat) void {
    const ge_func: u24 = glTestFuncToGe(_func);
    const ref_val: u24 = @intFromFloat(@min(@max(_ref, 0.0), 1.0) * 255.0);
    state.sendCommandi(219, ge_func | (ref_val << 8) | (0xFF << 16));
}

pub fn ArrayElement(_i: GLint) void {
    _ = .{_i};
    @compileError("Not Yet Implemented");
}

pub fn BindTexture(_target: GLenum, _texture: GLuint) void {
    if (_target != GL_TEXTURE_2D) {
        state.gl_error = GL_INVALID_ENUM;
        return;
    }
    if (_texture >= state.MAX_TEXTURES) {
        state.gl_error = GL_INVALID_VALUE;
        return;
    }
    // Auto-allocate if binding a name that was never GenTextures'd
    // (GL spec: binding a new name creates the object)
    if (!state.textures[_texture].allocated) {
        state.textures[_texture] = .{ .allocated = true };
    }
    state.bound_texture = _texture;
    emitFullTextureState();
}

pub fn BlendFunc(_sfactor: GLenum, _dfactor: GLenum) void {
    const src = glBlendFactorToGe(_sfactor, true);
    const dst = glBlendFactorToGe(_dfactor, false);
    // GE blend equation: cmd 223 = src | (dst << 4) | (op << 8), op=0 is Add
    state.sendCommandi(223, src.factor | (dst.factor << 4) | (0 << 8));
    state.sendCommandi(224, src.fixed);
    state.sendCommandi(225, dst.fixed);
}

pub fn CallList(_list: GLuint) void {
    _ = .{_list};
    @compileError("Not Yet Implemented");
}

pub fn CallLists(_n: GLsizei, _type: GLenum, _lists: ?*const anyopaque) void {
    _ = .{ _n, _type, _lists };
    @compileError("Not Yet Implemented");
}

pub fn Clear(_mask: GLbitfield) void {
    // Map GL clear bits to GE clear flags
    // GE cmd 211: bit 0 = enable clear mode, bits [8:10] = color/stencil/depth flags
    var ge_flags: u24 = 0;
    if (_mask & GL_COLOR_BUFFER_BIT != 0) ge_flags |= 1; // color
    if (_mask & GL_STENCIL_BUFFER_BIT != 0) ge_flags |= 2; // stencil
    if (_mask & GL_DEPTH_BUFFER_BIT != 0) ge_flags |= 4; // depth
    if (ge_flags == 0) return;

    const context = &state.contexts[state.curr_context];

    // Build clear color with stencil packed in based on pixel format
    const filter: u32 = switch (state.draw_buffer.pixel_format) {
        .Format5650 => @as(u32, context.clear_color),
        .Format5551 => @as(u32, context.clear_color) | (context.clear_stencil << 31),
        .Format4444 => @as(u32, context.clear_color) | (context.clear_stencil << 28),
        .Format8888 => @as(u32, context.clear_color) | (context.clear_stencil << 24),
    };

    // Clear is done by drawing 2D sprites across the screen with clear mode enabled.
    // Vertex type: color 8888 + vertex 16-bit + transform 2D
    const clear_vtype: u24 = (@as(u24, 7) << 2) | (@as(u24, 2) << 7) | (@as(u24, 1) << 23);

    // We need to emit vertices inline in the display list using the jump trick
    // (same as sceGuGetMemory). Each strip pair covers 64 pixels wide.
    const count: u24 = @divTrunc(state.draw_buffer.width + 63, 64) * 2;

    // Vertex: color(u32), x(u16), y(u16), z(u16), pad(u16) = 12 bytes each
    const vertex_bytes = @as(u32, count) * 12;
    const alloc_size = (vertex_bytes + 3) & ~@as(u32, 3); // align to 4

    // Allocate from display list (emit jump-over commands)
    const orig_ptr = state.list.?.current;
    const data_start: [*]u8 = @ptrCast(@as([*]u8, @ptrCast(orig_ptr)) + 8);
    const new_current: [*]u32 = @ptrFromInt(@intFromPtr(orig_ptr) + alloc_size + 8);

    // Jump command: cmd 8 = JUMP (low 24 bits of addr), cmd 16 = BASE (high bits)
    // GE addresses must NOT have the uncached bit (0x40000000) — strip it
    const jump_addr = @intFromPtr(new_current) & 0x1fffffff;
    orig_ptr[0] = (@as(u32, 16) << 24) | ((jump_addr >> 8) & 0xf0000);
    orig_ptr[1] = (@as(u32, 8) << 24) | (jump_addr & 0xffffff);
    state.list.?.current = new_current;

    if (state.object_stack_depth == 0 and state.curr_context == 0) {
        _ = pspge.sceGeListUpdateStallAddr(state.ge_list_executed[0], new_current);
    }

    // Fill vertices: pairs of (top-left, bottom-right) for 64-pixel-wide sprite strips
    var i: u16 = 0;
    const count16: u16 = @intCast(count);
    while (i < count16) : (i += 1) {
        const j: u16 = i >> 1;
        const k: u16 = i & 1;
        const offset = @as(usize, i) * 12;
        const ptr = data_start + offset;

        // color (u32)
        @as(*align(1) u32, @ptrCast(ptr)).* = filter;
        // x (u16)
        @as(*align(1) u16, @ptrCast(ptr + 4)).* = (j + k) * 64;
        // y (u16)
        @as(*align(1) u16, @ptrCast(ptr + 6)).* = k * @as(u16, @intCast(state.draw_buffer.height));
        // z (u16)
        @as(*align(1) u16, @ptrCast(ptr + 8)).* = context.clear_depth;
        // pad (u16)
        @as(*align(1) u16, @ptrCast(ptr + 10)).* = 0;
    }

    // Enable clear mode
    state.sendCommandi(211, (ge_flags << 8) | 0x01);

    // Emit vertex type + draw
    state.sendCommandi(18, clear_vtype);
    // GE addresses must NOT have the uncached bit — strip it
    const vert_addr = @intFromPtr(data_start) & 0x1fffffff;
    state.sendCommandi(16, @truncate(@as(u32, @intCast(vert_addr >> 8)) & 0xf0000));
    state.sendCommandi(1, @truncate(@as(u32, @intCast(vert_addr)) & 0xffffff));
    state.sendCommandiStall(4, (@as(u24, 6) << 16) | count); // prim 6 = Sprites

    // Disable clear mode
    state.sendCommandi(211, 0);
}

pub fn ClearColor(_red: GLfloat, _green: GLfloat, _blue: GLfloat, _alpha: GLfloat) void {
    const r: u24 = @intFromFloat(@min(@max(_red, 0.0), 1.0) * 255.0);
    const g: u24 = @intFromFloat(@min(@max(_green, 0.0), 1.0) * 255.0);
    const b: u24 = @intFromFloat(@min(@max(_blue, 0.0), 1.0) * 255.0);
    state.contexts[state.curr_context].clear_color = r | (g << 8) | (b << 16);
    state.contexts[state.curr_context].clear_stencil = @intFromFloat(@min(@max(_alpha, 0.0), 1.0) * 255.0);
}

pub fn ClearDepth(_depth: GLdouble) void {
    // Invert: PSP depth range is (near=65535, far=0), so GL depth 1.0 (far) → PSP 0,
    // and GL depth 0.0 (near) → PSP 65535.
    state.contexts[state.curr_context].clear_depth = @intFromFloat((1.0 - @min(@max(@as(f32, @floatCast(_depth)), 0.0), 1.0)) * 65535.0);
}

pub fn ClearIndex(_c: GLfloat) void {
    _ = .{_c};
    @compileError("Not Yet Implemented");
}

pub fn ClearStencil(_s: GLint) void {
    state.contexts[state.curr_context].clear_stencil = @as(u32, @intCast(_s & 0xff));
}

pub fn ClipPlane(_plane: GLenum, _equation: [*c]const GLdouble) void {
    _ = .{ _plane, _equation };
    @compileError("Not Yet Implemented");
}

pub fn ColorMask(_red: GLboolean, _green: GLboolean, _blue: GLboolean, _alpha: GLboolean) void {
    // GE pixel mask: 0 = write, 0xFF = don't write (inverted from GL)
    const r_mask: u24 = if (_red != 0) 0x00 else 0xFF;
    const g_mask: u24 = if (_green != 0) 0x00 else 0xFF00;
    const b_mask: u24 = if (_blue != 0) 0x00 else 0xFF0000;
    const a_mask: u32 = if (_alpha != 0) 0x00 else 0xFF;
    state.sendCommandi(232, r_mask | g_mask | b_mask);
    state.sendCommandi(233, @truncate(a_mask));
}

pub fn ColorMaterial(_face: GLenum, _mode: GLenum) void {
    // PSP ignores face (no separate front/back materials)
    // GL_EMISSION=0x1600→GE bit nothing, GL_AMBIENT=0x1200→1, GL_DIFFUSE=0x1201→2,
    // GL_SPECULAR=0x1202→4, GL_AMBIENT_AND_DIFFUSE=0x1602→3
    _ = _face;
    const components: u24 = switch (_mode) {
        GL_EMISSION => 0,
        GL_AMBIENT => 1,
        GL_DIFFUSE => 2,
        GL_SPECULAR => 4,
        GL_AMBIENT_AND_DIFFUSE => 3,
        else => 0,
    };
    state.sendCommandi(83, components);
}

pub fn ColorPointer(_size: GLint, _type: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) void {
    state.vertex_array.color = .{
        .size = _size,
        .type_enum = _type,
        .stride = _stride,
        .pointer = _pointer,
    };
}

pub fn CopyTexImage1D(_target: GLenum, _level: GLint, _internalformat: GLenum, _x: GLint, _y: GLint, _width: GLsizei, _border: GLint) void {
    _ = .{ _target, _level, _internalformat, _x, _y, _width, _border };
    @compileError("Not Yet Implemented");
}

pub fn CopyTexImage2D(_target: GLenum, _level: GLint, _internalformat: GLenum, _x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei, _border: GLint) void {
    _ = .{ _target, _level, _internalformat, _x, _y, _width, _height, _border };
    @compileError("Not Yet Implemented");
}

pub fn CopyTexSubImage1D(_target: GLenum, _level: GLint, _xoffset: GLint, _x: GLint, _y: GLint, _width: GLsizei) void {
    _ = .{ _target, _level, _xoffset, _x, _y, _width };
    @compileError("Not Yet Implemented");
}

pub fn CopyTexSubImage2D(_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei) void {
    _ = .{ _target, _level, _xoffset, _yoffset, _x, _y, _width, _height };
    @compileError("Not Yet Implemented");
}

pub fn CullFace(_mode: GLenum) void {
    // PSP GE only has front-face direction (cmd 155) and cull enable (cmd 29).
    // GL_FRONT=0x0404: cull front faces → reverse winding (GE 1 = CW front)
    // GL_BACK=0x0405: cull back faces → normal winding (GE 0 = CCW front)
    // GL_FRONT_AND_BACK not supported on GE hardware
    state.sendCommandi(155, if (_mode == GL_FRONT) @as(u24, 1) else @as(u24, 0));
}

pub fn DeleteLists(_list: GLuint, _range: GLsizei) void {
    _ = .{ _list, _range };
    @compileError("Not Yet Implemented");
}

pub fn DeleteTextures(_n: GLsizei, _textures: [*c]const GLuint) void {
    if (_n <= 0) return;
    const count: usize = @intCast(_n);
    for (0..count) |i| {
        const id = _textures[i];
        if (id == 0 or id >= state.MAX_TEXTURES) continue; // can't delete default
        state.textures[id] = .{}; // reset to defaults, allocated=false
        // If we just deleted the bound texture, rebind to default
        if (state.bound_texture == id) {
            state.bound_texture = 0;
            emitFullTextureState();
        }
    }
}

pub fn DepthFunc(_func: GLenum) void {
    // PSP uses inverted depth range (near=65535, far=0), so depth comparisons
    // must be flipped: GL_LEQUAL → GE GEQUAL, GL_LESS → GE GREATER, etc.
    state.sendCommandi(222, glDepthFuncToGe(_func));
}

/// Map GL depth comparison to GE value, inverting less/greater to match
/// PSP's inverted depth range convention (near=65535 → ge_depth=0).
fn glDepthFuncToGe(func: GLenum) u24 {
    return switch (func) {
        GL_NEVER => 0,
        GL_ALWAYS => 1,
        GL_EQUAL => 2,
        GL_NOTEQUAL => 3,
        GL_LESS => 6, // inverted → GREATER
        GL_LEQUAL => 7, // inverted → GEQUAL
        GL_GREATER => 4, // inverted → LESS
        GL_GEQUAL => 5, // inverted → LEQUAL
        else => @panic("zpspgl: invalid comparison function"),
    };
}

/// Map GL comparison function enums (0x0200-0x0207) to GE test function values (0-7).
/// Used for alpha/stencil tests (NOT depth — depth uses glDepthFuncToGe which inverts).
fn glTestFuncToGe(func: GLenum) u24 {
    return switch (func) {
        GL_NEVER => 0,
        GL_ALWAYS => 1,
        GL_EQUAL => 2,
        GL_NOTEQUAL => 3,
        GL_LESS => 4,
        GL_LEQUAL => 5,
        GL_GREATER => 6,
        GL_GEQUAL => 7,
        else => @panic("zpspgl: invalid comparison function"),
    };
}

pub fn DepthMask(_flag: GLboolean) void {
    // GL_TRUE = write enabled → GE mask 0 (no bits masked), GL_FALSE → GE mask 0xFFFF
    state.sendCommandi(231, if (_flag != 0) 0 else 0xFFFF);
}

pub fn DepthRange(_n: GLdouble, _f: GLdouble) void {
    // GL depth range [0,1] → PSP GE depth range [0,65535]
    const near: u16 = @intFromFloat(@min(@max(@as(f32, @floatCast(_n)), 0.0), 1.0) * 65535.0);
    const far: u16 = @intFromFloat(@min(@max(@as(f32, @floatCast(_f)), 0.0), 1.0) * 65535.0);
    state.contexts[state.curr_context].near_plane = near;
    state.contexts[state.curr_context].far_plane = far;

    const max_val: i32 = @as(i32, near) + @as(i32, far);
    const z: f32 = @floatFromInt(@divTrunc(max_val, 2));
    state.sendCommandf(68, z - @as(f32, @floatFromInt(near)));
    state.sendCommandf(71, z + @as(f32, @bitCast(state.contexts[state.curr_context].depth_offset)));

    if (near > far) {
        state.sendCommandi(214, far);
        state.sendCommandi(215, near);
    } else {
        state.sendCommandi(214, near);
        state.sendCommandi(215, far);
    }
}

pub fn Disable(_cap: GLenum) void {
    if (_cap == GL_SCISSOR_TEST) {
        state.contexts[state.curr_context].scissor_enable = 0;
        // Reset scissor to full screen
        state.sendCommandi(212, 0);
        state.sendCommandi(213, (state.draw_buffer.height << 10) | state.draw_buffer.width);
        return;
    }
    if (glCapToGeCmd(_cap)) |cmd| {
        state.sendCommandi(cmd, 0);
    }
}

pub fn DisableClientState(_array: GLenum) void {
    switch (_array) {
        GL_VERTEX_ARRAY => state.vertex_array.vertex_enabled = false,
        GL_COLOR_ARRAY => state.vertex_array.color_enabled = false,
        GL_TEXTURE_COORD_ARRAY => state.vertex_array.texcoord_enabled = false,
        GL_NORMAL_ARRAY => state.vertex_array.normal_enabled = false,
        else => state.gl_error = GL_INVALID_ENUM,
    }
}

pub fn DrawArrays(_mode: GLenum, _first: GLint, _count: GLsizei) void {
    if (_count <= 0) return;

    const ge_prim = glPrimToGe(_mode);
    const vtype = buildVertexType();

    state.uploadMatrices();

    // Compute vertex base address
    const base_ptr = state.vertex_array.vertex.pointer orelse @panic("zpspgl: vertex pointer is null");
    const base_addr = if (_first > 0) blk: {
        const stride = state.vertex_array.vertex.stride;
        if (stride <= 0) @panic("zpspgl: stride must be set when _first > 0");
        break :blk @intFromPtr(base_ptr) + @as(usize, @intCast(_first)) * @as(usize, @intCast(stride));
    } else @intFromPtr(base_ptr);

    // Flush vertex data from dcache so GE reads current contents
    psputils.sceKernelDcacheWritebackAll();

    // Emit GE commands
    state.sendCommandi(18, vtype);
    state.sendCommandi(16, @truncate(@as(u32, @intCast(base_addr >> 8)) & 0xf0000));
    state.sendCommandi(1, @truncate(@as(u32, @intCast(base_addr)) & 0xffffff));
    state.sendCommandiStall(4, (ge_prim << 16) | @as(u24, @intCast(_count)));
}

pub fn DrawBuffer(_buf: GLenum) void {
    _ = .{_buf};
    @compileError("Not Yet Implemented");
}

pub fn DrawElements(_mode: GLenum, _count: GLsizei, _type: GLenum, _indices: ?*const anyopaque) void {
    if (_count <= 0) return;

    const ge_prim = glPrimToGe(_mode);
    var vtype = buildVertexType();

    // Map index type to GE index bits [13:11]
    const index_bits: u24 = switch (_type) {
        GL_UNSIGNED_BYTE => @as(u24, 1) << 11,
        GL_UNSIGNED_SHORT => @as(u24, 2) << 11,
        else => @panic("zpspgl: only GL_UNSIGNED_BYTE and GL_UNSIGNED_SHORT supported for index type"),
    };
    vtype |= index_bits;

    state.uploadMatrices();

    // Vertex base address
    const vert_ptr = state.vertex_array.vertex.pointer orelse @panic("zpspgl: vertex pointer is null");
    const vert_addr = @intFromPtr(vert_ptr);

    // Index buffer address
    const idx_ptr = _indices orelse @panic("zpspgl: index pointer is null");
    const idx_addr = @intFromPtr(idx_ptr);

    // Flush vertex + index data from dcache so GE reads current contents
    psputils.sceKernelDcacheWritebackAll();

    // Emit GE commands
    state.sendCommandi(18, vtype);
    state.sendCommandi(16, @truncate(@as(u32, @intCast(idx_addr >> 8)) & 0xf0000));
    state.sendCommandi(2, @truncate(@as(u32, @intCast(idx_addr)) & 0xffffff));
    state.sendCommandi(16, @truncate(@as(u32, @intCast(vert_addr >> 8)) & 0xf0000));
    state.sendCommandi(1, @truncate(@as(u32, @intCast(vert_addr)) & 0xffffff));
    state.sendCommandiStall(4, (ge_prim << 16) | @as(u24, @intCast(_count)));
}

pub fn Enable(_cap: GLenum) void {
    if (_cap == GL_SCISSOR_TEST) {
        state.contexts[state.curr_context].scissor_enable = 1;
        state.sendCommandi(212, (@as(u24, state.contexts[state.curr_context].scissor_start[1]) << 10) | state.contexts[state.curr_context].scissor_start[0]);
        state.sendCommandi(213, (@as(u24, state.contexts[state.curr_context].scissor_end[1]) << 10) | state.contexts[state.curr_context].scissor_end[0]);
        return;
    }
    if (glCapToGeCmd(_cap)) |cmd| {
        state.sendCommandi(cmd, 1);
    }
}

pub fn EnableClientState(_array: GLenum) void {
    switch (_array) {
        GL_VERTEX_ARRAY => state.vertex_array.vertex_enabled = true,
        GL_COLOR_ARRAY => state.vertex_array.color_enabled = true,
        GL_TEXTURE_COORD_ARRAY => state.vertex_array.texcoord_enabled = true,
        GL_NORMAL_ARRAY => state.vertex_array.normal_enabled = true,
        else => state.gl_error = GL_INVALID_ENUM,
    }
}

pub fn EndList() void {
    @compileError("Not Yet Implemented");
}

pub fn Finish() void {
    _ = pspge.sceGeDrawSync(0);
}

pub fn Flush() void {
    // In zpspgl, Flush is a no-op — the stall-based display list mechanism
    // already streams commands to the GE. Use zglSwapBuffers() to end the
    // frame and present.
}

pub fn Fogf(_pname: GLenum, _param: GLfloat) void {
    switch (_pname) {
        GL_FOG_DENSITY, GL_FOG_START, GL_FOG_END => {
            // Individual params stored; full fog setup needs all three via Fogfv or sceGuFog-style call
            // GE fog: cmd 205 = far (float), cmd 206 = 1/(far-near) (float)
            // For now, handle the simple case: direct GE command for end/start
            if (_pname == GL_FOG_END) state.sendCommandf(205, _param);
        },
        GL_FOG_COLOR => {
            state.sendCommandi(207, @truncate(@as(u32, @intFromFloat(@min(@max(_param, 0.0), 1.0) * 255.0))));
        },
        else => {},
    }
}

pub fn Fogfv(_pname: GLenum, _params: [*c]const GLfloat) void {
    if (_pname == GL_FOG_COLOR) {
        const r: u24 = @intFromFloat(@min(@max(_params[0], 0.0), 1.0) * 255.0);
        const g: u24 = @intFromFloat(@min(@max(_params[1], 0.0), 1.0) * 255.0);
        const b: u24 = @intFromFloat(@min(@max(_params[2], 0.0), 1.0) * 255.0);
        state.sendCommandi(207, r | (g << 8) | (b << 16));
    } else {
        Fogf(_pname, _params[0]);
    }
}

pub fn Fogi(_pname: GLenum, _param: GLint) void {
    Fogf(_pname, @floatFromInt(_param));
}

pub fn Fogiv(_pname: GLenum, _params: [*c]const GLint) void {
    if (_pname == GL_FOG_COLOR) {
        // Integer color: full intensity = max int value
        const r: u24 = @truncate(@as(u32, @intCast(_params[0])) & 0xFF);
        const g: u24 = @truncate((@as(u32, @intCast(_params[1])) & 0xFF) << 8);
        const b: u24 = @truncate((@as(u32, @intCast(_params[2])) & 0xFF) << 16);
        state.sendCommandi(207, r | g | b);
    } else {
        Fogi(_pname, _params[0]);
    }
}

pub fn FrontFace(_mode: GLenum) void {
    // GL_CCW=0x0901 → GE 0 (default), GL_CW=0x0900 → GE 1
    state.sendCommandi(155, if (_mode == GL_CW) @as(u24, 1) else @as(u24, 0));
}

pub fn Frustum(_left: GLdouble, _right: GLdouble, _bottom: GLdouble, _top: GLdouble, _zNear: GLdouble, _zFar: GLdouble) void {
    const l: f32 = @floatCast(_left);
    const r: f32 = @floatCast(_right);
    const b: f32 = @floatCast(_bottom);
    const t_val: f32 = @floatCast(_top);
    const n: f32 = @floatCast(_zNear);
    const f: f32 = @floatCast(_zFar);
    const dx = r - l;
    const dy = t_val - b;
    const dz = f - n;

    var frust: state.Mat4 = .{
        2.0 * n / dx, 0,                0,                 0,
        0,            2.0 * n / dy,     0,                 0,
        (r + l) / dx, (t_val + b) / dy, -(f + n) / dz,     -1,
        0,            0,                -2.0 * f * n / dz, 0,
    };
    state.mat4Multiply(state.currentMatrix(), state.currentMatrix(), &frust);
    state.matrix_dirty[state.matrix_mode] = true;
}

pub fn GenLists(_range: GLsizei) GLuint {
    _ = .{_range};
    @compileError("Not Yet Implemented");
}

pub fn GenTextures(_n: GLsizei, _textures: [*c]GLuint) void {
    if (_n <= 0) return;
    const count: usize = @intCast(_n);
    var found: usize = 0;
    // Slot 0 is the default texture, start searching from 1
    for (1..state.MAX_TEXTURES) |i| {
        if (!state.textures[i].allocated) {
            state.textures[i] = .{ .allocated = true };
            _textures[found] = @intCast(i);
            found += 1;
            if (found >= count) return;
        }
    }
    // Not enough free slots
    state.gl_error = GL_OUT_OF_MEMORY;
}

pub fn GetBooleanv(_pname: GLenum, _data: [*c]GLboolean) void {
    _ = .{ _pname, _data };
    @compileError("Not Yet Implemented");
}

pub fn GetClipPlane(_plane: GLenum, _equation: [*c]GLdouble) void {
    _ = .{ _plane, _equation };
    @compileError("Not Yet Implemented");
}

pub fn GetDoublev(_pname: GLenum, _data: [*c]GLdouble) void {
    _ = .{ _pname, _data };
    @compileError("Not Yet Implemented");
}

pub fn GetError() GLenum {
    const err = state.gl_error;
    state.gl_error = GL_NO_ERROR;
    return err;
}

pub fn GetFloatv(_pname: GLenum, _data: [*c]GLfloat) void {
    _ = .{ _pname, _data };
    @compileError("Not Yet Implemented");
}

pub fn GetIntegerv(_pname: GLenum, _data: [*c]GLint) void {
    _ = .{ _pname, _data };
    @compileError("Not Yet Implemented");
}

pub fn GetLightfv(_light: GLenum, _pname: GLenum, _params: [*c]GLfloat) void {
    _ = .{ _light, _pname, _params };
    @compileError("Not Yet Implemented");
}

pub fn GetLightiv(_light: GLenum, _pname: GLenum, _params: [*c]GLint) void {
    _ = .{ _light, _pname, _params };
    @compileError("Not Yet Implemented");
}

pub fn GetMapdv(_target: GLenum, _query: GLenum, _v: [*c]GLdouble) void {
    _ = .{ _target, _query, _v };
    @compileError("Not Yet Implemented");
}

pub fn GetMapfv(_target: GLenum, _query: GLenum, _v: [*c]GLfloat) void {
    _ = .{ _target, _query, _v };
    @compileError("Not Yet Implemented");
}

pub fn GetMapiv(_target: GLenum, _query: GLenum, _v: [*c]GLint) void {
    _ = .{ _target, _query, _v };
    @compileError("Not Yet Implemented");
}

pub fn GetMaterialfv(_face: GLenum, _pname: GLenum, _params: [*c]GLfloat) void {
    _ = .{ _face, _pname, _params };
    @compileError("Not Yet Implemented");
}

pub fn GetMaterialiv(_face: GLenum, _pname: GLenum, _params: [*c]GLint) void {
    _ = .{ _face, _pname, _params };
    @compileError("Not Yet Implemented");
}

pub fn GetPointerv(_pname: GLenum, _params: ?*?*anyopaque) void {
    _ = .{ _pname, _params };
    @compileError("Not Yet Implemented");
}

pub fn GetString(_name: GLenum) [*c]const GLubyte {
    _ = .{_name};
    @compileError("Not Yet Implemented");
}

pub fn GetTexEnvfv(_target: GLenum, _pname: GLenum, _params: [*c]GLfloat) void {
    _ = .{ _target, _pname, _params };
    @compileError("Not Yet Implemented");
}

pub fn GetTexEnviv(_target: GLenum, _pname: GLenum, _params: [*c]GLint) void {
    _ = .{ _target, _pname, _params };
    @compileError("Not Yet Implemented");
}

pub fn GetTexGendv(_coord: GLenum, _pname: GLenum, _params: [*c]GLdouble) void {
    _ = .{ _coord, _pname, _params };
    @compileError("Not Yet Implemented");
}

pub fn GetTexGenfv(_coord: GLenum, _pname: GLenum, _params: [*c]GLfloat) void {
    _ = .{ _coord, _pname, _params };
    @compileError("Not Yet Implemented");
}

pub fn GetTexGeniv(_coord: GLenum, _pname: GLenum, _params: [*c]GLint) void {
    _ = .{ _coord, _pname, _params };
    @compileError("Not Yet Implemented");
}

pub fn GetTexImage(_target: GLenum, _level: GLint, _format: GLenum, _type: GLenum, _pixels: ?*anyopaque) void {
    _ = .{ _target, _level, _format, _type, _pixels };
    @compileError("Not Yet Implemented");
}

pub fn GetTexLevelParameterfv(_target: GLenum, _level: GLint, _pname: GLenum, _params: [*c]GLfloat) void {
    _ = .{ _target, _level, _pname, _params };
    @compileError("Not Yet Implemented");
}

pub fn GetTexLevelParameteriv(_target: GLenum, _level: GLint, _pname: GLenum, _params: [*c]GLint) void {
    _ = .{ _target, _level, _pname, _params };
    @compileError("Not Yet Implemented");
}

pub fn GetTexParameterfv(_target: GLenum, _pname: GLenum, _params: [*c]GLfloat) void {
    _ = .{ _target, _pname, _params };
    @compileError("Not Yet Implemented");
}

pub fn GetTexParameteriv(_target: GLenum, _pname: GLenum, _params: [*c]GLint) void {
    _ = .{ _target, _pname, _params };
    @compileError("Not Yet Implemented");
}

pub fn Hint(_target: GLenum, _mode: GLenum) void {
    // PSP GE has no hint mechanism — silently ignore
    _ = .{ _target, _mode };
}

pub fn InterleavedArrays(_format: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) void {
    _ = .{ _format, _stride, _pointer };
    @compileError("Not Yet Implemented");
}

pub fn IsEnabled(_cap: GLenum) GLboolean {
    _ = .{_cap};
    @compileError("Not Yet Implemented");
}

pub fn IsList(_list: GLuint) GLboolean {
    _ = .{_list};
    @compileError("Not Yet Implemented");
}

pub fn IsTexture(_texture: GLuint) GLboolean {
    _ = .{_texture};
    @compileError("Not Yet Implemented");
}

pub fn LightModelf(_pname: GLenum, _param: GLfloat) void {
    if (_pname == GL_LIGHT_MODEL_TWO_SIDE) {
        // GE cmd 94: 0 = single sided, 1 = two sided
        state.sendCommandi(94, if (_param != 0.0) @as(u24, 1) else @as(u24, 0));
    }
}

pub fn LightModelfv(_pname: GLenum, _params: [*c]const GLfloat) void {
    if (_pname == GL_LIGHT_MODEL_AMBIENT) {
        const r: u24 = @intFromFloat(@min(@max(_params[0], 0.0), 1.0) * 255.0);
        const g: u24 = @intFromFloat(@min(@max(_params[1], 0.0), 1.0) * 255.0);
        const b: u24 = @intFromFloat(@min(@max(_params[2], 0.0), 1.0) * 255.0);
        const a: u24 = @intFromFloat(@min(@max(_params[3], 0.0), 1.0) * 255.0);
        state.sendCommandi(92, r | (g << 8) | (b << 16)); // ambient color
        state.sendCommandi(93, a); // ambient alpha
    } else {
        LightModelf(_pname, _params[0]);
    }
}

pub fn LightModeli(_pname: GLenum, _param: GLint) void {
    LightModelf(_pname, @floatFromInt(_param));
}

pub fn LightModeliv(_pname: GLenum, _params: [*c]const GLint) void {
    if (_pname == GL_LIGHT_MODEL_AMBIENT) {
        const col: u24 = @truncate(@as(u32, @intCast(_params[0] & 0xFF)) |
            (@as(u32, @intCast(_params[1] & 0xFF)) << 8) |
            (@as(u32, @intCast(_params[2] & 0xFF)) << 16));
        state.sendCommandi(92, col);
        state.sendCommandi(93, @truncate(@as(u32, @intCast(_params[3] & 0xFF))));
    } else {
        LightModeli(_pname, _params[0]);
    }
}

pub fn Lightf(_light: GLenum, _pname: GLenum, _param: GLfloat) void {
    const idx = _light - GL_LIGHT0;
    if (idx >= 4) return;
    const ls = state.light_settings[idx];
    switch (_pname) {
        GL_SPOT_EXPONENT => state.sendCommandf(ls.exponent, _param),
        GL_SPOT_CUTOFF => state.sendCommandf(ls.cutoff, _param),
        GL_CONSTANT_ATTENUATION => state.sendCommandf(ls.constant, _param),
        GL_LINEAR_ATTENUATION => state.sendCommandf(ls.linear, _param),
        GL_QUADRATIC_ATTENUATION => state.sendCommandf(ls.quadratic, _param),
        else => {},
    }
}

pub fn Lightfv(_light: GLenum, _pname: GLenum, _params: [*c]const GLfloat) void {
    const idx = _light - GL_LIGHT0;
    if (idx >= 4) return;
    const ls = state.light_settings[idx];
    switch (_pname) {
        GL_AMBIENT => {
            const r: u24 = @intFromFloat(@min(@max(_params[0], 0.0), 1.0) * 255.0);
            const g: u24 = @intFromFloat(@min(@max(_params[1], 0.0), 1.0) * 255.0);
            const b: u24 = @intFromFloat(@min(@max(_params[2], 0.0), 1.0) * 255.0);
            state.sendCommandi(ls.ambient, r | (g << 8) | (b << 16));
        },
        GL_DIFFUSE => {
            const r: u24 = @intFromFloat(@min(@max(_params[0], 0.0), 1.0) * 255.0);
            const g: u24 = @intFromFloat(@min(@max(_params[1], 0.0), 1.0) * 255.0);
            const b: u24 = @intFromFloat(@min(@max(_params[2], 0.0), 1.0) * 255.0);
            state.sendCommandi(ls.diffuse, r | (g << 8) | (b << 16));
        },
        GL_SPECULAR => {
            const r: u24 = @intFromFloat(@min(@max(_params[0], 0.0), 1.0) * 255.0);
            const g: u24 = @intFromFloat(@min(@max(_params[1], 0.0), 1.0) * 255.0);
            const b: u24 = @intFromFloat(@min(@max(_params[2], 0.0), 1.0) * 255.0);
            state.sendCommandi(ls.specular, r | (g << 8) | (b << 16));
        },
        GL_POSITION => {
            state.sendCommandf(ls.xpos, _params[0]);
            state.sendCommandf(ls.ypos, _params[1]);
            state.sendCommandf(ls.zpos, _params[2]);
            // w=0 → directional, w=1 → positional; GE type cmd handles this
            const kind: u24 = if (_params[3] == 0.0) 0 else 2; // directional=0, point=2
            state.sendCommandi(ls.typec, kind);
        },
        GL_SPOT_DIRECTION => {
            state.sendCommandf(ls.xdir, _params[0]);
            state.sendCommandf(ls.ydir, _params[1]);
            state.sendCommandf(ls.zdir, _params[2]);
        },
        else => Lightf(_light, _pname, _params[0]),
    }
}

pub fn Lighti(_light: GLenum, _pname: GLenum, _param: GLint) void {
    Lightf(_light, _pname, @floatFromInt(_param));
}

pub fn Lightiv(_light: GLenum, _pname: GLenum, _params: [*c]const GLint) void {
    // For color params, convert int to float and delegate
    const f: [4]GLfloat = .{
        @floatFromInt(_params[0]),
        @floatFromInt(_params[1]),
        @floatFromInt(_params[2]),
        @floatFromInt(_params[3]),
    };
    Lightfv(_light, _pname, &f);
}

pub fn LineWidth(_width: GLfloat) void {
    _ = .{_width};
    @compileError("Not Yet Implemented");
}

pub fn ListBase(_base: GLuint) void {
    _ = .{_base};
    @compileError("Not Yet Implemented");
}

pub fn LoadIdentity() void {
    state.currentMatrix().* = state.identity_matrix;
    state.matrix_dirty[state.matrix_mode] = true;
}

pub fn LoadMatrixd(_m: [*c]const GLdouble) void {
    var f: state.Mat4 = undefined;
    for (0..16) |i| {
        f[i] = @floatCast(_m[i]);
    }
    state.currentMatrix().* = f;
    state.matrix_dirty[state.matrix_mode] = true;
}

pub fn LoadMatrixf(_m: [*c]const GLfloat) void {
    const src: *const [16]f32 = @ptrCast(_m);
    state.currentMatrix().* = src.*;
    state.matrix_dirty[state.matrix_mode] = true;
}

pub fn LogicOp(_opcode: GLenum) void {
    // GL logic ops (0x1500-0x150F) map to GE ops (0-15) by masking low nibble
    state.sendCommandi(230, @truncate(_opcode & 0x0F));
}

pub fn Map1d(_target: GLenum, _u1: GLdouble, _u2: GLdouble, _stride: GLint, _order: GLint, _points: [*c]const GLdouble) void {
    _ = .{ _target, _u1, _u2, _stride, _order, _points };
    @compileError("Not Yet Implemented");
}

pub fn Map1f(_target: GLenum, _u1: GLfloat, _u2: GLfloat, _stride: GLint, _order: GLint, _points: [*c]const GLfloat) void {
    _ = .{ _target, _u1, _u2, _stride, _order, _points };
    @compileError("Not Yet Implemented");
}

pub fn Map2d(_target: GLenum, _u1: GLdouble, _u2: GLdouble, _ustride: GLint, _uorder: GLint, _v1: GLdouble, _v2: GLdouble, _vstride: GLint, _vorder: GLint, _points: [*c]const GLdouble) void {
    _ = .{ _target, _u1, _u2, _ustride, _uorder, _v1, _v2, _vstride, _vorder, _points };
    @compileError("Not Yet Implemented");
}

pub fn Map2f(_target: GLenum, _u1: GLfloat, _u2: GLfloat, _ustride: GLint, _uorder: GLint, _v1: GLfloat, _v2: GLfloat, _vstride: GLint, _vorder: GLint, _points: [*c]const GLfloat) void {
    _ = .{ _target, _u1, _u2, _ustride, _uorder, _v1, _v2, _vstride, _vorder, _points };
    @compileError("Not Yet Implemented");
}

pub fn MapGrid1d(_un: GLint, _u1: GLdouble, _u2: GLdouble) void {
    _ = .{ _un, _u1, _u2 };
    @compileError("Not Yet Implemented");
}

pub fn MapGrid1f(_un: GLint, _u1: GLfloat, _u2: GLfloat) void {
    _ = .{ _un, _u1, _u2 };
    @compileError("Not Yet Implemented");
}

pub fn MapGrid2d(_un: GLint, _u1: GLdouble, _u2: GLdouble, _vn: GLint, _v1: GLdouble, _v2: GLdouble) void {
    _ = .{ _un, _u1, _u2, _vn, _v1, _v2 };
    @compileError("Not Yet Implemented");
}

pub fn MapGrid2f(_un: GLint, _u1: GLfloat, _u2: GLfloat, _vn: GLint, _v1: GLfloat, _v2: GLfloat) void {
    _ = .{ _un, _u1, _u2, _vn, _v1, _v2 };
    @compileError("Not Yet Implemented");
}

pub fn Materialf(_face: GLenum, _pname: GLenum, _param: GLfloat) void {
    // Single-value material param: only GL_SHININESS makes sense
    _ = _face; // PSP has no separate front/back materials
    if (_pname == GL_SHININESS) {
        state.sendCommandf(91, _param); // GE specular power
    }
}

pub fn Materialfv(_face: GLenum, _pname: GLenum, _params: [*c]const GLfloat) void {
    _ = _face;
    const r: u24 = @intFromFloat(@min(@max(_params[0], 0.0), 1.0) * 255.0);
    const g: u24 = @intFromFloat(@min(@max(_params[1], 0.0), 1.0) * 255.0);
    const b: u24 = @intFromFloat(@min(@max(_params[2], 0.0), 1.0) * 255.0);
    const col: u24 = r | (g << 8) | (b << 16);
    switch (_pname) {
        GL_AMBIENT => {
            state.sendCommandi(85, col); // ambient color
            const a: u24 = @intFromFloat(@min(@max(_params[3], 0.0), 1.0) * 255.0);
            state.sendCommandi(88, a); // ambient alpha
        },
        GL_DIFFUSE => state.sendCommandi(86, col),
        GL_SPECULAR => state.sendCommandi(87, col),
        GL_EMISSION => state.sendCommandi(84, col),
        GL_AMBIENT_AND_DIFFUSE => {
            state.sendCommandi(85, col);
            const a: u24 = @intFromFloat(@min(@max(_params[3], 0.0), 1.0) * 255.0);
            state.sendCommandi(88, a);
            state.sendCommandi(86, col);
        },
        GL_SHININESS => state.sendCommandf(91, _params[0]),
        else => {},
    }
}

pub fn Materiali(_face: GLenum, _pname: GLenum, _param: GLint) void {
    Materialf(_face, _pname, @floatFromInt(_param));
}

pub fn Materialiv(_face: GLenum, _pname: GLenum, _params: [*c]const GLint) void {
    _ = _face;
    if (_pname == GL_SHININESS) {
        state.sendCommandf(91, @floatFromInt(_params[0]));
        return;
    }
    // Convert integer RGBA to u24 color
    const col: u24 = @truncate(@as(u32, @intCast(_params[0] & 0xFF)) |
        (@as(u32, @intCast(_params[1] & 0xFF)) << 8) |
        (@as(u32, @intCast(_params[2] & 0xFF)) << 16));
    switch (_pname) {
        GL_AMBIENT => {
            state.sendCommandi(85, col);
            state.sendCommandi(88, @truncate(@as(u32, @intCast(_params[3] & 0xFF))));
        },
        GL_DIFFUSE => state.sendCommandi(86, col),
        GL_SPECULAR => state.sendCommandi(87, col),
        GL_EMISSION => state.sendCommandi(84, col),
        GL_AMBIENT_AND_DIFFUSE => {
            state.sendCommandi(85, col);
            state.sendCommandi(88, @truncate(@as(u32, @intCast(_params[3] & 0xFF))));
            state.sendCommandi(86, col);
        },
        else => {},
    }
}

pub fn MatrixMode(_mode: GLenum) void {
    state.matrix_mode = switch (_mode) {
        GL_MODELVIEW => 0,
        GL_PROJECTION => 1,
        GL_TEXTURE => 2,
        else => return,
    };
}

pub fn MultMatrixd(_m: [*c]const GLdouble) void {
    var f: state.Mat4 = undefined;
    for (0..16) |i| {
        f[i] = @floatCast(_m[i]);
    }
    state.mat4Multiply(state.currentMatrix(), state.currentMatrix(), &f);
    state.matrix_dirty[state.matrix_mode] = true;
}

pub fn MultMatrixf(_m: [*c]const GLfloat) void {
    const src: *const state.Mat4 = @ptrCast(_m);
    state.mat4Multiply(state.currentMatrix(), state.currentMatrix(), src);
    state.matrix_dirty[state.matrix_mode] = true;
}

pub fn NewList(_list: GLuint, _mode: GLenum) void {
    _ = .{ _list, _mode };
    @compileError("Not Yet Implemented");
}

pub fn NormalPointer(_type: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) void {
    state.vertex_array.normal = .{
        .size = 3,
        .type_enum = _type,
        .stride = _stride,
        .pointer = _pointer,
    };
}

pub fn Ortho(_left: GLdouble, _right: GLdouble, _bottom: GLdouble, _top: GLdouble, _zNear: GLdouble, _zFar: GLdouble) void {
    const l: f32 = @floatCast(_left);
    const r: f32 = @floatCast(_right);
    const b: f32 = @floatCast(_bottom);
    const t_val: f32 = @floatCast(_top);
    const n: f32 = @floatCast(_zNear);
    const f: f32 = @floatCast(_zFar);
    const dx = r - l;
    const dy = t_val - b;
    const dz = f - n;

    var ortho: state.Mat4 = .{
        2.0 / dx,      0,                 0,             0,
        0,             2.0 / dy,          0,             0,
        0,             0,                 -2.0 / dz,     0,
        -(r + l) / dx, -(t_val + b) / dy, -(f + n) / dz, 1,
    };
    state.mat4Multiply(state.currentMatrix(), state.currentMatrix(), &ortho);
    state.matrix_dirty[state.matrix_mode] = true;
}

pub fn PointSize(_size: GLfloat) void {
    _ = .{_size};
    @compileError("Not Yet Implemented");
}

pub fn PolygonOffset(_factor: GLfloat, _units: GLfloat) void {
    _ = .{ _factor, _units };
    @compileError("Not Yet Implemented");
}

pub fn PopAttrib() void {
    @compileError("Not Yet Implemented");
}

pub fn PopClientAttrib() void {
    @compileError("Not Yet Implemented");
}

pub fn PopMatrix() void {
    const mode = state.matrix_mode;
    if (state.matrix_stack_depth[mode] > 0) {
        state.matrix_stack_depth[mode] -= 1;
        state.matrix_dirty[mode] = true;
    }
}

pub fn PushAttrib(_mask: GLbitfield) void {
    _ = .{_mask};
    @compileError("Not Yet Implemented");
}

pub fn PushClientAttrib(_mask: GLbitfield) void {
    _ = .{_mask};
    @compileError("Not Yet Implemented");
}

pub fn PushMatrix() void {
    const mode = state.matrix_mode;
    if (state.matrix_stack_depth[mode] < state.MAX_STACK_DEPTH - 1) {
        state.matrix_stacks[mode][state.matrix_stack_depth[mode] + 1] = state.matrix_stacks[mode][state.matrix_stack_depth[mode]];
        state.matrix_stack_depth[mode] += 1;
    }
}

pub fn ReadBuffer(_src: GLenum) void {
    _ = .{_src};
    @compileError("Not Yet Implemented");
}

pub fn Rotated(_angle: GLdouble, _x: GLdouble, _y: GLdouble, _z: GLdouble) void {
    Rotatef(@floatCast(_angle), @floatCast(_x), @floatCast(_y), @floatCast(_z));
}

pub fn Rotatef(_angle: GLfloat, _x: GLfloat, _y: GLfloat, _z: GLfloat) void {
    const rad = _angle * (3.14159265358979323846 / 180.0);
    const c = @cos(rad);
    const s = @sin(rad);
    // Normalize axis
    const len = @sqrt(_x * _x + _y * _y + _z * _z);
    if (len < 1.0e-6) return;
    const nx = _x / len;
    const ny = _y / len;
    const nz = _z / len;
    const nc = 1.0 - c;

    // Column-major rotation matrix (Rodrigues)
    var t: state.Mat4 = .{
        nx * nx * nc + c,      ny * nx * nc + nz * s, nz * nx * nc - ny * s, 0,
        nx * ny * nc - nz * s, ny * ny * nc + c,      nz * ny * nc + nx * s, 0,
        nx * nz * nc + ny * s, ny * nz * nc - nx * s, nz * nz * nc + c,      0,
        0,                     0,                     0,                     1,
    };
    state.mat4Multiply(state.currentMatrix(), state.currentMatrix(), &t);
    state.matrix_dirty[state.matrix_mode] = true;
}

pub fn Scaled(_x: GLdouble, _y: GLdouble, _z: GLdouble) void {
    Scalef(@floatCast(_x), @floatCast(_y), @floatCast(_z));
}

pub fn Scalef(_x: GLfloat, _y: GLfloat, _z: GLfloat) void {
    // Scale directly into the current matrix columns (faster than full multiply)
    const m = state.currentMatrix();
    for (0..4) |row| {
        m[0 * 4 + row] *= _x;
        m[1 * 4 + row] *= _y;
        m[2 * 4 + row] *= _z;
    }
    state.matrix_dirty[state.matrix_mode] = true;
}

pub fn Scissor(_x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei) void {
    const x: u24 = @intCast(@max(_x, 0));
    const y: u24 = @intCast(@max(_y, 0));
    const w: u24 = @intCast(@max(_width - 1, 0));
    const h: u24 = @intCast(@max(_height - 1, 0));
    state.contexts[state.curr_context].scissor_start = .{ x, y };
    state.contexts[state.curr_context].scissor_end = .{ x + w, y + h };
    if (state.contexts[state.curr_context].scissor_enable != 0) {
        state.sendCommandi(212, (y << 10) | x);
        state.sendCommandi(213, ((y + h) << 10) | (x + w));
    }
}

pub fn ShadeModel(_mode: GLenum) void {
    // GL_FLAT=0x1D00 → GE 0, GL_SMOOTH=0x1D01 → GE 1
    state.sendCommandi(80, @truncate(_mode & 0x01));
}

pub fn StencilFunc(_func: GLenum, _ref: GLint, _mask: GLuint) void {
    const ge_func: u24 = glTestFuncToGe(_func);
    const ref_val: u24 = @truncate(@as(u32, @intCast(_ref & 0xFF)) << 8);
    const mask_val: u24 = @truncate((@as(u32, _mask) & 0xFF) << 16);
    state.sendCommandi(220, ge_func | ref_val | mask_val);
}

pub fn StencilMask(_mask: GLuint) void {
    // GE stencil write mask: cmd 232 (low 24 bits of color/stencil mask)
    // Stencil is in the alpha channel bits — set via pixel mask
    state.sendCommandi(232, @truncate(_mask & 0xFF));
}

pub fn StencilOp(_fail: GLenum, _zfail: GLenum, _zpass: GLenum) void {
    // GL stencil ops: KEEP=0x1E00, ZERO=0, REPLACE=0x1E01, INCR=0x1E02, DECR=0x1E03, INVERT=0x150A
    // GE stencil ops: keep=0, zero=1, replace=2, invert=3, incr=4, decr=5
    state.sendCommandi(221, glStencilOpToGe(_fail) | (glStencilOpToGe(_zfail) << 8) | (glStencilOpToGe(_zpass) << 16));
}

pub fn TexCoordPointer(_size: GLint, _type: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) void {
    state.vertex_array.texcoord = .{
        .size = _size,
        .type_enum = _type,
        .stride = _stride,
        .pointer = _pointer,
    };
}

pub fn TexEnvf(_target: GLenum, _pname: GLenum, _param: GLfloat) void {
    TexEnvi(_target, _pname, @intFromFloat(_param));
}

pub fn TexEnvfv(_target: GLenum, _pname: GLenum, _params: [*c]const GLfloat) void {
    _ = .{ _target, _pname, _params };
    @compileError("Not Yet Implemented");
}

pub fn TexEnvi(_target: GLenum, _pname: GLenum, _param: GLint) void {
    _ = _target;
    if (_pname == GL_TEXTURE_ENV_MODE) {
        const ge_func: u8 = switch (@as(GLenum, @intCast(_param))) {
            GL_MODULATE => 0,
            GL_DECAL => 1,
            GL_REPLACE => 3,
            GL_ADD => 4,
            else => {
                state.gl_error = GL_INVALID_ENUM;
                return;
            },
        };
        const tex = state.currentTexture();
        tex.tex_func = ge_func;
        state.sendCommandi(201, (@as(u24, tex.tex_color_comp) << 8) | ge_func);
    } else {
        state.gl_error = GL_INVALID_ENUM;
    }
}

pub fn TexEnviv(_target: GLenum, _pname: GLenum, _params: [*c]const GLint) void {
    _ = .{ _target, _pname, _params };
    @compileError("Not Yet Implemented");
}

pub fn TexGend(_coord: GLenum, _pname: GLenum, _param: GLdouble) void {
    _ = .{ _coord, _pname, _param };
    @compileError("Not Yet Implemented");
}

pub fn TexGendv(_coord: GLenum, _pname: GLenum, _params: [*c]const GLdouble) void {
    _ = .{ _coord, _pname, _params };
    @compileError("Not Yet Implemented");
}

pub fn TexGenf(_coord: GLenum, _pname: GLenum, _param: GLfloat) void {
    _ = .{ _coord, _pname, _param };
    @compileError("Not Yet Implemented");
}

pub fn TexGenfv(_coord: GLenum, _pname: GLenum, _params: [*c]const GLfloat) void {
    _ = .{ _coord, _pname, _params };
    @compileError("Not Yet Implemented");
}

pub fn TexGeni(_coord: GLenum, _pname: GLenum, _param: GLint) void {
    _ = .{ _coord, _pname, _param };
    @compileError("Not Yet Implemented");
}

pub fn TexGeniv(_coord: GLenum, _pname: GLenum, _params: [*c]const GLint) void {
    _ = .{ _coord, _pname, _params };
    @compileError("Not Yet Implemented");
}

pub fn TexImage1D(_target: GLenum, _level: GLint, _internalformat: GLint, _width: GLsizei, _border: GLint, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) void {
    _ = .{ _target, _level, _internalformat, _width, _border, _format, _type, _pixels };
    @compileError("Not Yet Implemented");
}

pub fn TexImage2D(_target: GLenum, _level: GLint, _internalformat: GLint, _width: GLsizei, _height: GLsizei, _border: GLint, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) void {
    _ = _border;
    _ = _internalformat;

    if (_target != GL_TEXTURE_2D) {
        state.gl_error = GL_INVALID_ENUM;
        return;
    }

    if (_width <= 0 or _height <= 0) {
        state.gl_error = GL_INVALID_VALUE;
        return;
    }

    const w: u32 = @intCast(_width);
    const h: u32 = @intCast(_height);

    // PSP requires power-of-2 dimensions
    if (w & (w - 1) != 0 or h & (h - 1) != 0) {
        @panic("zpspgl: texture dimensions must be power-of-2");
    }

    const ge_format = glFormatToGe(_format, _type);
    const mipmap: u8 = @intCast(_level);
    const tbp: u32 = @intFromPtr(_pixels);

    // Flush texture data from dcache so GE sees current contents
    if (_pixels != null) {
        const bpp: u32 = switch (ge_format) {
            0, 1, 2 => 2, // 16-bit formats
            3 => 4, // 8888
            else => 4,
        };
        psputils.sceKernelDcacheWritebackRange(_pixels, w * h * bpp);
    }

    // Store in bound texture object (level 0 only for now)
    if (mipmap == 0) {
        const tex = state.currentTexture();
        tex.data_ptr = tbp;
        tex.width = @intCast(w);
        tex.height = @intCast(h);
        tex.ge_format = ge_format;
    }

    // Emit texture mode (cmd 194): no mipmaps, no CLUT, linear layout
    if (mipmap == 0) {
        state.sendCommandi(194, 0);
        state.sendCommandi(195, ge_format);
    }

    // Emit texture image (cmd 0xa0+level, 0xa8+level, 0xb8+level)
    state.sendCommandi(0xa0 + mipmap, @truncate(tbp));
    state.sendCommandi(0xa8 + mipmap, @as(u24, @intCast((tbp >> 8) & 0x0f0000)) | @as(u24, @intCast(w)));
    state.sendCommandi(0xb8 + mipmap, @as(u24, @intCast(@ctz(w))) | (@as(u24, @intCast(@ctz(h))) << 8));

    // Texture flush
    state.sendCommandf(203, 0.0);

    // Set default texture function on first image upload
    if (mipmap == 0) {
        const tex = state.currentTexture();
        tex.tex_func = 3; // replace
        tex.tex_color_comp = 1; // RGBA
        state.sendCommandi(201, (@as(u24, 1) << 8) | 3);

        state.sendCommandf(72, 1.0);
        state.sendCommandf(73, 1.0);
        state.sendCommandf(74, 0.0);
        state.sendCommandf(75, 0.0);
    }
}

pub fn TexParameterf(_target: GLenum, _pname: GLenum, _param: GLfloat) void {
    TexParameteri(_target, _pname, @intFromFloat(_param));
}

pub fn TexParameterfv(_target: GLenum, _pname: GLenum, _params: [*c]const GLfloat) void {
    _ = .{ _target, _pname, _params };
    @compileError("Not Yet Implemented");
}

pub fn TexParameteri(_target: GLenum, _pname: GLenum, _param: GLint) void {
    _ = _target;
    const tex = state.currentTexture();
    switch (_pname) {
        GL_TEXTURE_MIN_FILTER => {
            tex.min_filter = glFilterToGe(@intCast(_param));
            emitTexFilter();
        },
        GL_TEXTURE_MAG_FILTER => {
            tex.mag_filter = glFilterToGe(@intCast(_param));
            emitTexFilter();
        },
        GL_TEXTURE_WRAP_S => {
            tex.wrap_s = glWrapToGe(@intCast(_param));
            emitTexWrap();
        },
        GL_TEXTURE_WRAP_T => {
            tex.wrap_t = glWrapToGe(@intCast(_param));
            emitTexWrap();
        },
        else => state.gl_error = GL_INVALID_ENUM,
    }
}

pub fn TexParameteriv(_target: GLenum, _pname: GLenum, _params: [*c]const GLint) void {
    _ = .{ _target, _pname, _params };
    @compileError("Not Yet Implemented");
}

pub fn TexSubImage1D(_target: GLenum, _level: GLint, _xoffset: GLint, _width: GLsizei, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) void {
    _ = .{ _target, _level, _xoffset, _width, _format, _type, _pixels };
    @compileError("Not Yet Implemented");
}

pub fn TexSubImage2D(_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _width: GLsizei, _height: GLsizei, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) void {
    _ = .{ _target, _level, _xoffset, _yoffset, _width, _height, _format, _type, _pixels };
    @compileError("Not Yet Implemented");
}

pub fn Translated(_x: GLdouble, _y: GLdouble, _z: GLdouble) void {
    Translatef(@floatCast(_x), @floatCast(_y), @floatCast(_z));
}

pub fn Translatef(_x: GLfloat, _y: GLfloat, _z: GLfloat) void {
    // Column-major translation matrix
    var t = state.identity_matrix;
    t[12] = _x; // w.x
    t[13] = _y; // w.y
    t[14] = _z; // w.z
    state.mat4Multiply(state.currentMatrix(), state.currentMatrix(), &t);
    state.matrix_dirty[state.matrix_mode] = true;
}

pub fn VertexPointer(_size: GLint, _type: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) void {
    state.vertex_array.vertex = .{
        .size = _size,
        .type_enum = _type,
        .stride = _stride,
        .pointer = _pointer,
    };
}

pub fn Viewport(_x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei) void {
    _ = _x;
    _ = _y;

    const hw: u24 = @intCast(@divTrunc(_width, 2));
    const hh: u24 = @intCast(@divTrunc(_height, 2));

    // Viewport scale (cmd 66/67) and center (cmd 69/70)
    state.sendCommandf(66, @floatFromInt(hw));
    state.sendCommandf(67, @as(f32, @floatFromInt(-@as(i32, @intCast(hh)))));
    state.sendCommandf(69, 2048.0);
    state.sendCommandf(70, 2048.0);

    // Viewport offset (cmd 76/77) — PSP screen is centered at 2048
    state.sendCommandi(76, (2048 - hw) << 4);
    state.sendCommandi(77, (2048 - hh) << 4);
}

// =============================================================================
// Immediate Mode Functions
// =============================================================================

pub fn Begin(_mode: GLenum) void {
    _ = .{_mode};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color3b(_red: GLbyte, _green: GLbyte, _blue: GLbyte) void {
    _ = .{ _red, _green, _blue };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color3bv(_v: [*c]const GLbyte) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color3d(_red: GLdouble, _green: GLdouble, _blue: GLdouble) void {
    _ = .{ _red, _green, _blue };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color3dv(_v: [*c]const GLdouble) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color3f(_red: GLfloat, _green: GLfloat, _blue: GLfloat) void {
    _ = .{ _red, _green, _blue };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color3fv(_v: [*c]const GLfloat) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color3i(_red: GLint, _green: GLint, _blue: GLint) void {
    _ = .{ _red, _green, _blue };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color3iv(_v: [*c]const GLint) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color3s(_red: GLshort, _green: GLshort, _blue: GLshort) void {
    _ = .{ _red, _green, _blue };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color3sv(_v: [*c]const GLshort) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color3ub(_red: GLubyte, _green: GLubyte, _blue: GLubyte) void {
    _ = .{ _red, _green, _blue };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color3ubv(_v: [*c]const GLubyte) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color3ui(_red: GLuint, _green: GLuint, _blue: GLuint) void {
    _ = .{ _red, _green, _blue };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color3uiv(_v: [*c]const GLuint) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color3us(_red: GLushort, _green: GLushort, _blue: GLushort) void {
    _ = .{ _red, _green, _blue };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color3usv(_v: [*c]const GLushort) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color4b(_red: GLbyte, _green: GLbyte, _blue: GLbyte, _alpha: GLbyte) void {
    _ = .{ _red, _green, _blue, _alpha };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color4bv(_v: [*c]const GLbyte) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color4d(_red: GLdouble, _green: GLdouble, _blue: GLdouble, _alpha: GLdouble) void {
    _ = .{ _red, _green, _blue, _alpha };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color4dv(_v: [*c]const GLdouble) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color4f(_red: GLfloat, _green: GLfloat, _blue: GLfloat, _alpha: GLfloat) void {
    _ = .{ _red, _green, _blue, _alpha };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color4fv(_v: [*c]const GLfloat) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color4i(_red: GLint, _green: GLint, _blue: GLint, _alpha: GLint) void {
    _ = .{ _red, _green, _blue, _alpha };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color4iv(_v: [*c]const GLint) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color4s(_red: GLshort, _green: GLshort, _blue: GLshort, _alpha: GLshort) void {
    _ = .{ _red, _green, _blue, _alpha };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color4sv(_v: [*c]const GLshort) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color4ub(_red: GLubyte, _green: GLubyte, _blue: GLubyte, _alpha: GLubyte) void {
    _ = .{ _red, _green, _blue, _alpha };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color4ubv(_v: [*c]const GLubyte) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color4ui(_red: GLuint, _green: GLuint, _blue: GLuint, _alpha: GLuint) void {
    _ = .{ _red, _green, _blue, _alpha };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color4uiv(_v: [*c]const GLuint) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color4us(_red: GLushort, _green: GLushort, _blue: GLushort, _alpha: GLushort) void {
    _ = .{ _red, _green, _blue, _alpha };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Color4usv(_v: [*c]const GLushort) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn EdgeFlag(_flag: GLboolean) void {
    _ = .{_flag};
    @compileError("Immediate Mode Not Implemented");
}

pub fn EdgeFlagv(_flag: [*c]const GLboolean) void {
    _ = .{_flag};
    @compileError("Immediate Mode Not Implemented");
}

pub fn End() void {
    @compileError("Immediate Mode Not Implemented");
}

pub fn EvalCoord1d(_u: GLdouble) void {
    _ = .{_u};
    @compileError("Immediate Mode Not Implemented");
}

pub fn EvalCoord1dv(_u: [*c]const GLdouble) void {
    _ = .{_u};
    @compileError("Immediate Mode Not Implemented");
}

pub fn EvalCoord1f(_u: GLfloat) void {
    _ = .{_u};
    @compileError("Immediate Mode Not Implemented");
}

pub fn EvalCoord1fv(_u: [*c]const GLfloat) void {
    _ = .{_u};
    @compileError("Immediate Mode Not Implemented");
}

pub fn EvalCoord2d(_u: GLdouble, _v: GLdouble) void {
    _ = .{ _u, _v };
    @compileError("Immediate Mode Not Implemented");
}

pub fn EvalCoord2dv(_u: [*c]const GLdouble) void {
    _ = .{_u};
    @compileError("Immediate Mode Not Implemented");
}

pub fn EvalCoord2f(_u: GLfloat, _v: GLfloat) void {
    _ = .{ _u, _v };
    @compileError("Immediate Mode Not Implemented");
}

pub fn EvalCoord2fv(_u: [*c]const GLfloat) void {
    _ = .{_u};
    @compileError("Immediate Mode Not Implemented");
}

pub fn EvalMesh1(_mode: GLenum, _i1: GLint, _i2: GLint) void {
    _ = .{ _mode, _i1, _i2 };
    @compileError("Immediate Mode Not Implemented");
}

pub fn EvalMesh2(_mode: GLenum, _i1: GLint, _i2: GLint, _j1: GLint, _j2: GLint) void {
    _ = .{ _mode, _i1, _i2, _j1, _j2 };
    @compileError("Immediate Mode Not Implemented");
}

pub fn EvalPoint1(_i: GLint) void {
    _ = .{_i};
    @compileError("Immediate Mode Not Implemented");
}

pub fn EvalPoint2(_i: GLint, _j: GLint) void {
    _ = .{ _i, _j };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Indexd(_c: GLdouble) void {
    _ = .{_c};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Indexdv(_c: [*c]const GLdouble) void {
    _ = .{_c};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Indexf(_c: GLfloat) void {
    _ = .{_c};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Indexfv(_c: [*c]const GLfloat) void {
    _ = .{_c};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Indexi(_c: GLint) void {
    _ = .{_c};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Indexiv(_c: [*c]const GLint) void {
    _ = .{_c};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Indexs(_c: GLshort) void {
    _ = .{_c};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Indexsv(_c: [*c]const GLshort) void {
    _ = .{_c};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Indexub(_c: GLubyte) void {
    _ = .{_c};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Indexubv(_c: [*c]const GLubyte) void {
    _ = .{_c};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Normal3b(_nx: GLbyte, _ny: GLbyte, _nz: GLbyte) void {
    _ = .{ _nx, _ny, _nz };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Normal3bv(_v: [*c]const GLbyte) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Normal3d(_nx: GLdouble, _ny: GLdouble, _nz: GLdouble) void {
    _ = .{ _nx, _ny, _nz };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Normal3dv(_v: [*c]const GLdouble) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Normal3f(_nx: GLfloat, _ny: GLfloat, _nz: GLfloat) void {
    _ = .{ _nx, _ny, _nz };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Normal3fv(_v: [*c]const GLfloat) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Normal3i(_nx: GLint, _ny: GLint, _nz: GLint) void {
    _ = .{ _nx, _ny, _nz };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Normal3iv(_v: [*c]const GLint) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Normal3s(_nx: GLshort, _ny: GLshort, _nz: GLshort) void {
    _ = .{ _nx, _ny, _nz };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Normal3sv(_v: [*c]const GLshort) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn PassThrough(_token: GLfloat) void {
    _ = .{_token};
    @compileError("Immediate Mode Not Implemented");
}

pub fn RasterPos2d(_x: GLdouble, _y: GLdouble) void {
    _ = .{ _x, _y };
    @compileError("Immediate Mode Not Implemented");
}

pub fn RasterPos2dv(_v: [*c]const GLdouble) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn RasterPos2f(_x: GLfloat, _y: GLfloat) void {
    _ = .{ _x, _y };
    @compileError("Immediate Mode Not Implemented");
}

pub fn RasterPos2fv(_v: [*c]const GLfloat) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn RasterPos2i(_x: GLint, _y: GLint) void {
    _ = .{ _x, _y };
    @compileError("Immediate Mode Not Implemented");
}

pub fn RasterPos2iv(_v: [*c]const GLint) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn RasterPos2s(_x: GLshort, _y: GLshort) void {
    _ = .{ _x, _y };
    @compileError("Immediate Mode Not Implemented");
}

pub fn RasterPos2sv(_v: [*c]const GLshort) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn RasterPos3d(_x: GLdouble, _y: GLdouble, _z: GLdouble) void {
    _ = .{ _x, _y, _z };
    @compileError("Immediate Mode Not Implemented");
}

pub fn RasterPos3dv(_v: [*c]const GLdouble) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn RasterPos3f(_x: GLfloat, _y: GLfloat, _z: GLfloat) void {
    _ = .{ _x, _y, _z };
    @compileError("Immediate Mode Not Implemented");
}

pub fn RasterPos3fv(_v: [*c]const GLfloat) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn RasterPos3i(_x: GLint, _y: GLint, _z: GLint) void {
    _ = .{ _x, _y, _z };
    @compileError("Immediate Mode Not Implemented");
}

pub fn RasterPos3iv(_v: [*c]const GLint) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn RasterPos3s(_x: GLshort, _y: GLshort, _z: GLshort) void {
    _ = .{ _x, _y, _z };
    @compileError("Immediate Mode Not Implemented");
}

pub fn RasterPos3sv(_v: [*c]const GLshort) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn RasterPos4d(_x: GLdouble, _y: GLdouble, _z: GLdouble, _w: GLdouble) void {
    _ = .{ _x, _y, _z, _w };
    @compileError("Immediate Mode Not Implemented");
}

pub fn RasterPos4dv(_v: [*c]const GLdouble) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn RasterPos4f(_x: GLfloat, _y: GLfloat, _z: GLfloat, _w: GLfloat) void {
    _ = .{ _x, _y, _z, _w };
    @compileError("Immediate Mode Not Implemented");
}

pub fn RasterPos4fv(_v: [*c]const GLfloat) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn RasterPos4i(_x: GLint, _y: GLint, _z: GLint, _w: GLint) void {
    _ = .{ _x, _y, _z, _w };
    @compileError("Immediate Mode Not Implemented");
}

pub fn RasterPos4iv(_v: [*c]const GLint) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn RasterPos4s(_x: GLshort, _y: GLshort, _z: GLshort, _w: GLshort) void {
    _ = .{ _x, _y, _z, _w };
    @compileError("Immediate Mode Not Implemented");
}

pub fn RasterPos4sv(_v: [*c]const GLshort) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Rectd(_x1: GLdouble, _y1: GLdouble, _x2: GLdouble, _y2: GLdouble) void {
    _ = .{ _x1, _y1, _x2, _y2 };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Rectdv(_v1: [*c]const GLdouble, _v2: [*c]const GLdouble) void {
    _ = .{ _v1, _v2 };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Rectf(_x1: GLfloat, _y1: GLfloat, _x2: GLfloat, _y2: GLfloat) void {
    _ = .{ _x1, _y1, _x2, _y2 };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Rectfv(_v1: [*c]const GLfloat, _v2: [*c]const GLfloat) void {
    _ = .{ _v1, _v2 };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Recti(_x1: GLint, _y1: GLint, _x2: GLint, _y2: GLint) void {
    _ = .{ _x1, _y1, _x2, _y2 };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Rectiv(_v1: [*c]const GLint, _v2: [*c]const GLint) void {
    _ = .{ _v1, _v2 };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Rects(_x1: GLshort, _y1: GLshort, _x2: GLshort, _y2: GLshort) void {
    _ = .{ _x1, _y1, _x2, _y2 };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Rectsv(_v1: [*c]const GLshort, _v2: [*c]const GLshort) void {
    _ = .{ _v1, _v2 };
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord1d(_s: GLdouble) void {
    _ = .{_s};
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord1dv(_v: [*c]const GLdouble) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord1f(_s: GLfloat) void {
    _ = .{_s};
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord1fv(_v: [*c]const GLfloat) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord1i(_s: GLint) void {
    _ = .{_s};
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord1iv(_v: [*c]const GLint) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord1s(_s: GLshort) void {
    _ = .{_s};
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord1sv(_v: [*c]const GLshort) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord2d(_s: GLdouble, _t: GLdouble) void {
    _ = .{ _s, _t };
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord2dv(_v: [*c]const GLdouble) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord2f(_s: GLfloat, _t: GLfloat) void {
    _ = .{ _s, _t };
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord2fv(_v: [*c]const GLfloat) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord2i(_s: GLint, _t: GLint) void {
    _ = .{ _s, _t };
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord2iv(_v: [*c]const GLint) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord2s(_s: GLshort, _t: GLshort) void {
    _ = .{ _s, _t };
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord2sv(_v: [*c]const GLshort) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord3d(_s: GLdouble, _t: GLdouble, _r: GLdouble) void {
    _ = .{ _s, _t, _r };
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord3dv(_v: [*c]const GLdouble) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord3f(_s: GLfloat, _t: GLfloat, _r: GLfloat) void {
    _ = .{ _s, _t, _r };
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord3fv(_v: [*c]const GLfloat) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord3i(_s: GLint, _t: GLint, _r: GLint) void {
    _ = .{ _s, _t, _r };
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord3iv(_v: [*c]const GLint) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord3s(_s: GLshort, _t: GLshort, _r: GLshort) void {
    _ = .{ _s, _t, _r };
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord3sv(_v: [*c]const GLshort) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord4d(_s: GLdouble, _t: GLdouble, _r: GLdouble, _q: GLdouble) void {
    _ = .{ _s, _t, _r, _q };
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord4dv(_v: [*c]const GLdouble) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord4f(_s: GLfloat, _t: GLfloat, _r: GLfloat, _q: GLfloat) void {
    _ = .{ _s, _t, _r, _q };
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord4fv(_v: [*c]const GLfloat) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord4i(_s: GLint, _t: GLint, _r: GLint, _q: GLint) void {
    _ = .{ _s, _t, _r, _q };
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord4iv(_v: [*c]const GLint) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord4s(_s: GLshort, _t: GLshort, _r: GLshort, _q: GLshort) void {
    _ = .{ _s, _t, _r, _q };
    @compileError("Immediate Mode Not Implemented");
}

pub fn TexCoord4sv(_v: [*c]const GLshort) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Vertex2d(_x: GLdouble, _y: GLdouble) void {
    _ = .{ _x, _y };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Vertex2dv(_v: [*c]const GLdouble) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Vertex2f(_x: GLfloat, _y: GLfloat) void {
    _ = .{ _x, _y };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Vertex2fv(_v: [*c]const GLfloat) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Vertex2i(_x: GLint, _y: GLint) void {
    _ = .{ _x, _y };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Vertex2iv(_v: [*c]const GLint) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Vertex2s(_x: GLshort, _y: GLshort) void {
    _ = .{ _x, _y };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Vertex2sv(_v: [*c]const GLshort) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Vertex3d(_x: GLdouble, _y: GLdouble, _z: GLdouble) void {
    _ = .{ _x, _y, _z };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Vertex3dv(_v: [*c]const GLdouble) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Vertex3f(_x: GLfloat, _y: GLfloat, _z: GLfloat) void {
    _ = .{ _x, _y, _z };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Vertex3fv(_v: [*c]const GLfloat) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Vertex3i(_x: GLint, _y: GLint, _z: GLint) void {
    _ = .{ _x, _y, _z };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Vertex3iv(_v: [*c]const GLint) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Vertex3s(_x: GLshort, _y: GLshort, _z: GLshort) void {
    _ = .{ _x, _y, _z };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Vertex3sv(_v: [*c]const GLshort) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Vertex4d(_x: GLdouble, _y: GLdouble, _z: GLdouble, _w: GLdouble) void {
    _ = .{ _x, _y, _z, _w };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Vertex4dv(_v: [*c]const GLdouble) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Vertex4f(_x: GLfloat, _y: GLfloat, _z: GLfloat, _w: GLfloat) void {
    _ = .{ _x, _y, _z, _w };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Vertex4fv(_v: [*c]const GLfloat) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Vertex4i(_x: GLint, _y: GLint, _z: GLint, _w: GLint) void {
    _ = .{ _x, _y, _z, _w };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Vertex4iv(_v: [*c]const GLint) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

pub fn Vertex4s(_x: GLshort, _y: GLshort, _z: GLshort, _w: GLshort) void {
    _ = .{ _x, _y, _z, _w };
    @compileError("Immediate Mode Not Implemented");
}

pub fn Vertex4sv(_v: [*c]const GLshort) void {
    _ = .{_v};
    @compileError("Immediate Mode Not Implemented");
}

// =============================================================================
// Accumulation Buffer Functions (not supported by hardware)
// =============================================================================

pub fn Accum(_op: GLenum, _value: GLfloat) void {
    _ = .{ _op, _value };
    @compileError("Accumulation Buffer Not Supported By Hardware");
}

pub fn ClearAccum(_red: GLfloat, _green: GLfloat, _blue: GLfloat, _alpha: GLfloat) void {
    _ = .{ _red, _green, _blue, _alpha };
    @compileError("Accumulation Buffer Not Supported By Hardware");
}

// =============================================================================
// Stipple / PolygonMode / EdgeFlag Functions (not supported by hardware)
// =============================================================================

pub fn EdgeFlagPointer(_stride: GLsizei, _pointer: ?*const anyopaque) void {
    _ = .{ _stride, _pointer };
    @compileError("Stipple/PolygonMode/EdgeFlag Not Supported By Hardware");
}

pub fn GetPolygonStipple(_mask: [*c]GLubyte) void {
    _ = .{_mask};
    @compileError("Stipple/PolygonMode/EdgeFlag Not Supported By Hardware");
}

pub fn LineStipple(_factor: GLint, _pattern: GLushort) void {
    _ = .{ _factor, _pattern };
    @compileError("Stipple/PolygonMode/EdgeFlag Not Supported By Hardware");
}

pub fn PolygonMode(_face: GLenum, _mode: GLenum) void {
    _ = .{ _face, _mode };
    @compileError("Stipple/PolygonMode/EdgeFlag Not Supported By Hardware");
}

pub fn PolygonStipple(_mask: [*c]const GLubyte) void {
    _ = .{_mask};
    @compileError("Stipple/PolygonMode/EdgeFlag Not Supported By Hardware");
}

// =============================================================================
// Selection / Feedback Functions (not implemented)
// =============================================================================

pub fn FeedbackBuffer(_size: GLsizei, _type: GLenum, _buffer: [*c]GLfloat) void {
    _ = .{ _size, _type, _buffer };
    @compileError("Selection/Feedback Render Mode Not Implemented");
}

pub fn InitNames() void {
    @compileError("Selection/Feedback Render Mode Not Implemented");
}

pub fn LoadName(_name: GLuint) void {
    _ = .{_name};
    @compileError("Selection/Feedback Render Mode Not Implemented");
}

pub fn PopName() void {
    @compileError("Selection/Feedback Render Mode Not Implemented");
}

pub fn PushName(_name: GLuint) void {
    _ = .{_name};
    @compileError("Selection/Feedback Render Mode Not Implemented");
}

pub fn RenderMode(_mode: GLenum) GLint {
    _ = .{_mode};
    @compileError("Selection/Feedback Render Mode Not Implemented");
}

pub fn SelectBuffer(_size: GLsizei, _buffer: [*c]GLuint) void {
    _ = .{ _size, _buffer };
    @compileError("Selection/Feedback Render Mode Not Implemented");
}

// =============================================================================
// Bitmap / Pixel Transfer Functions (not supported by hardware)
// =============================================================================

pub fn Bitmap(_width: GLsizei, _height: GLsizei, _xorig: GLfloat, _yorig: GLfloat, _xmove: GLfloat, _ymove: GLfloat, _bitmap: [*c]const GLubyte) void {
    _ = .{ _width, _height, _xorig, _yorig, _xmove, _ymove, _bitmap };
    @compileError("Bitmap/Pixel Transfer Not Supported By Hardware");
}

pub fn CopyPixels(_x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei, _type: GLenum) void {
    _ = .{ _x, _y, _width, _height, _type };
    @compileError("Bitmap/Pixel Transfer Not Supported By Hardware");
}

pub fn DrawPixels(_width: GLsizei, _height: GLsizei, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) void {
    _ = .{ _width, _height, _format, _type, _pixels };
    @compileError("Bitmap/Pixel Transfer Not Supported By Hardware");
}

pub fn GetPixelMapfv(_map: GLenum, _values: [*c]GLfloat) void {
    _ = .{ _map, _values };
    @compileError("Bitmap/Pixel Transfer Not Supported By Hardware");
}

pub fn GetPixelMapuiv(_map: GLenum, _values: [*c]GLuint) void {
    _ = .{ _map, _values };
    @compileError("Bitmap/Pixel Transfer Not Supported By Hardware");
}

pub fn GetPixelMapusv(_map: GLenum, _values: [*c]GLushort) void {
    _ = .{ _map, _values };
    @compileError("Bitmap/Pixel Transfer Not Supported By Hardware");
}

pub fn PixelMapfv(_map: GLenum, _mapsize: GLsizei, _values: [*c]const GLfloat) void {
    _ = .{ _map, _mapsize, _values };
    @compileError("Bitmap/Pixel Transfer Not Supported By Hardware");
}

pub fn PixelMapuiv(_map: GLenum, _mapsize: GLsizei, _values: [*c]const GLuint) void {
    _ = .{ _map, _mapsize, _values };
    @compileError("Bitmap/Pixel Transfer Not Supported By Hardware");
}

pub fn PixelMapusv(_map: GLenum, _mapsize: GLsizei, _values: [*c]const GLushort) void {
    _ = .{ _map, _mapsize, _values };
    @compileError("Bitmap/Pixel Transfer Not Supported By Hardware");
}

pub fn PixelStoref(_pname: GLenum, _param: GLfloat) void {
    _ = .{ _pname, _param };
    @compileError("Bitmap/Pixel Transfer Not Supported By Hardware");
}

pub fn PixelStorei(_pname: GLenum, _param: GLint) void {
    _ = .{ _pname, _param };
    @compileError("Bitmap/Pixel Transfer Not Supported By Hardware");
}

pub fn PixelTransferf(_pname: GLenum, _param: GLfloat) void {
    _ = .{ _pname, _param };
    @compileError("Bitmap/Pixel Transfer Not Supported By Hardware");
}

pub fn PixelTransferi(_pname: GLenum, _param: GLint) void {
    _ = .{ _pname, _param };
    @compileError("Bitmap/Pixel Transfer Not Supported By Hardware");
}

pub fn PixelZoom(_xfactor: GLfloat, _yfactor: GLfloat) void {
    _ = .{ _xfactor, _yfactor };
    @compileError("Bitmap/Pixel Transfer Not Supported By Hardware");
}

pub fn ReadPixels(_x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei, _format: GLenum, _type: GLenum, _pixels: ?*anyopaque) void {
    _ = .{ _x, _y, _width, _height, _format, _type, _pixels };
    @compileError("Bitmap/Pixel Transfer Not Supported By Hardware");
}

// =============================================================================
// Miscellaneous Unsupported Functions
// =============================================================================

pub fn AreTexturesResident(_n: GLsizei, _textures: [*c]const GLuint, _residences: [*c]GLboolean) GLboolean {
    _ = .{ _n, _textures, _residences };
    @compileError("Not Supported By Hardware");
}

pub fn IndexMask(_mask: GLuint) void {
    _ = .{_mask};
    @compileError("Not Supported By Hardware");
}

pub fn IndexPointer(_type: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) void {
    _ = .{ _type, _stride, _pointer };
    @compileError("Not Supported By Hardware");
}

pub fn PrioritizeTextures(_n: GLsizei, _textures: [*c]const GLuint, _priorities: [*c]const GLfloat) void {
    _ = .{ _n, _textures, _priorities };
    @compileError("Not Supported By Hardware");
}
