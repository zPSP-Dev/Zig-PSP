usingnamespace @import("pspgu.zig");
usingnamespace @import("pspge.zig");

//Internals
pub const GuCallback = ?fn (c_int) callconv(.C) void;

const GuSettings = struct {
    sig : GuCallback,
    fin : GuCallback,
    signal_history : [16]u16,
    signal_offset : i32,
    kernel_event_flag : i32,
    ge_callback_id : i32,

    swapBuffersCallback : GuSwapBuffersCallback,
    swapBuffersBehaviour : i32,
};

const GuDisplayList = struct
{
    start : [*]u32,
    current : [*]u32,
    parent_context : i32,
};

const GuContext = struct
{
    list : GuDisplayList,
    scissor_enable : i32,
    scissor_start : [2]i32,
    scissor_end : [2]i32,
    near_plane : i32,
    far_plane : i32,
    depth_offset : i32,
    fragment_2x : i32,
    texture_function : i32,
    texture_proj_map_mode : i32,
    texture_map_mode : i32,
    sprite_mode : [4]i32,
    clear_color : u32,
    clear_stencil : u32,
    clear_depth : u32,
    texture_mode : i32,
};

const GuDrawBuffer = struct
{
    pixel_size : i32,
    frame_width : i32,
    frame_buffer : ?*c_void,
    disp_buffer : ?*c_void,
    depth_buffer : ?*c_void,
    depth_width : i32,
    width : i32,
    height : i32,
};

const GuLightSettings = struct
{
    enable : u8,// Light enable
    typec : u8,// Light type
    xpos : u8,// X position
    ypos : u8,// Y position
    zpos : u8,// Z position
    xdir : u8,// X direction
    ydir : u8,// Y direction
    zdir : u8,// Z direction
    ambient : u8,// Ambient color
    diffuse : u8,// Diffuse color
    specular : u8,// Specular color
    constant : u8,// Constant attenuation
    linear : u8,// Linear attenuation
    quadratic : u8,// Quadratic attenuation
    exponent : u8,// Light exponent
    cutoff : u8,// Light cutoff
};

var gu_current_frame : u32 = 0;
var gu_contexts : [3]GuContext = undefined;
var ge_list_executed : [2]i32 = undefined;
var ge_edram_address : ?*c_void = null;
var gu_settings : GuSettings = undefined;
var gu_list : ?*GuDisplayList = null;
var gu_curr_context : i32 = 0;
var gu_init : i32 = 0;
var gu_display_on : i32 = 0;
var gu_call_mode : i32 = 0;
var gu_states : i32 = 0;
var gu_draw_buffer : GuDrawBuffer = undefined;

var gu_object_stack : []*u32;
var gu_object_stack_depth : i32 = 0;

var light_settings : [4]GuLightSettings;

usingnamespace @import("pspthreadman.zig");
export fn callbackSig(id : c_int, arg : ?*c_void) void{
    var settings : ?*GuSettings = @intToPtr(?*GuSettings, @ptrToInt(arg));
    settings.?.signal_history[ @intCast(usize, (settings.?.signal_offset)) & 15] = @intCast(u16, id) & 0xffff;
    settings.?.signal_offset += 1;

    if (settings.?.sig != null)
        settings.?.sig.?(id & 0xffff);

    _ = sceKernelSetEventFlag(settings.?.kernel_event_flag,1);
}

export fn callbackFin(id : c_int, arg : ?*c_void) void{
    var settings : ?*GuSettings = @intToPtr(?*GuSettings, @ptrToInt(arg));
    if (settings.?.fin != null){
        settings.?.fin.?(id & 0xffff);
    }
}

export fn resetValues() void {
    var i : usize = 0;

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

    while (i < 3) : (i += 1)
    {
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


export fn sendCommandi(cmd : c_int, argument : c_int) void {
    gu_list.?.current[0] = (@intCast(u32, cmd) << 24) | (@intCast(u32, argument) & 0xffffff);
    gu_list.?.current += 1;
}

export fn sendCommandiStall(cmd : c_int, argument : c_int) void {
    sendCommandi(cmd, argument);
    if (gu_object_stack_depth == 0 and gu_curr_context == 0){
        _ = sceGeListUpdateStallAddr(ge_list_executed[0], @ptrCast(*c_void, gu_list.?.current));
    }
}

export fn sendCommandf(cmd : c_int, argument : f32) void {
    sendCommandi(cmd, @bitCast(c_int, argument) >> 8);
}