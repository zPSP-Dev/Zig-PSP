usingnamespace @import("pspge.zig");
usingnamespace @import("pspgutypes.zig");
usingnamespace @import("psptypes.zig");
usingnamespace @import("pspdisplay.zig");

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

var gu_object_stack : [256]u32 = undefined;
var gu_object_stack_depth : i32 = 0;

var light_settings : [4]GuLightSettings = [_]GuLightSettings{
    GuLightSettings{.enable = 0x18, .typec = 0x5f, .xpos = 0x63, .ypos = 0x64, 
    .zpos = 0x65, .xdir = 0x6f, .ydir = 0x70, .zdir = 0x71,
    .ambient = 0x8f, .diffuse = 0x90, .specular = 0x91, .constant = 0x7b,
    .linear = 0x7c, .quadratic = 0x7d, .exponent = 0x87, .cutoff = 0x8b},
    
    GuLightSettings{.enable = 0x19, .typec = 0x60, .xpos = 0x66, .ypos = 0x67, 
    .zpos = 0x68, .xdir = 0x72, .ydir = 0x73, .zdir = 0x74,
    .ambient = 0x92, .diffuse = 0x93, .specular = 0x94, .constant = 0x7e,
    .linear = 0x7f, .quadratic = 0x80, .exponent = 0x88, .cutoff = 0x8c},
    
    GuLightSettings{.enable = 0x1a, .typec = 0x61, .xpos = 0x69, .ypos = 0x6a, 
    .zpos = 0x6b, .xdir = 0x75, .ydir = 0x76, .zdir = 0x77,
    .ambient = 0x8f, .diffuse = 0x90, .specular = 0x91, .constant = 0x81,
    .linear = 0x82, .quadratic = 0x83, .exponent = 0x89, .cutoff = 0x8d},
    
    GuLightSettings{.enable = 0x1b, .typec = 0x62, .xpos = 0x6c, .ypos = 0x6d, 
    .zpos = 0x6e, .xdir = 0x78, .ydir = 0x79, .zdir = 0x7a,
    .ambient = 0x98, .diffuse = 0x99, .specular = 0x9a, .constant = 0x84,
    .linear = 0x85, .quadratic = 0x86, .exponent = 0x8a, .cutoff = 0x8e},
};

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


//GU IMPLEMENTATION

export fn sceGuAlphaFunc(func: c_int, value: c_int, mask: c_int) void{
    var arg : c_int = func | ((value & 0xff) << 8) | ((mask & 0xff) << 16);
    sendCommandi(219,arg);
}
export fn sceGuAmbient(col: c_int) void{
    sendCommandi(92,(col & 0xffffff));
    sendCommandi(93,(col >> 24));
}
export fn sceGuAmbientColor(col: c_int) void{
    sendCommandi(85,col & 0xffffff);
    sendCommandi(88,col >> 24);
}

export fn sceGuBlendFunc(op: c_int, src: c_int, dest: c_int, srcfix: c_int, destfix: c_int) void{
    sendCommandi(223,src | (dest << 4) | (op << 8));
    sendCommandi(224,srcfix & 0xffffff);
    sendCommandi(225,destfix & 0xffffff);
}

export fn sceGuBreak(a0: c_int) void{
    //Does nothing or is broken?
}

export fn sceGuContinue() void{
    //Does nothing or is broken?   
}

export fn sceGuCallList(list: ?*const c_void) void{
    var list_addr : c_int = @intCast(c_int, @ptrToInt(list));

    if (gu_call_mode == 1)
    {
        sendCommandi(14,(list_addr >> 16) | 0x110000);
        sendCommandi(12,list_addr & 0xffff);
        sendCommandiStall(0,0);
    }
    else
    {
        sendCommandi(16,(list_addr >> 8) & 0xf0000);
        sendCommandiStall(10,list_addr & 0xffffff);
    }
}

export fn sceGuCallMode(mode: c_int) void{
    gu_call_mode = mode;
}

export fn sceGuCheckList() c_int{
   return @intCast(c_int, (@ptrToInt(gu_list.?.current)- @ptrToInt(gu_list.?.start))); 
}

export fn sceGuClearColor(col: c_uint) void{
    gu_contexts[@intCast(usize, gu_curr_context)].clear_color = col;
}

export fn sceGuClearDepth(depth: c_uint) void{
    gu_contexts[@intCast(usize, gu_curr_context)].clear_depth = depth;
}

export fn sceGuClearStencil(stencil: c_uint) void{
    gu_contexts[@intCast(usize, gu_curr_context)].clear_stencil = stencil;
}

export fn sceGuClutLoad(num_blocks: c_int, cbp: ?*const c_void) void{
    var a = @intCast(c_int, @ptrToInt(cbp));
    sendCommandi(176,(a) & 0xffffff);
    sendCommandi(177,((a) >> 8) & 0xf0000);
    sendCommandi(196,num_blocks);
}

export fn sceGuClutMode(cpsm: c_int, shift: c_int, mask: c_int, a3: c_int) void{
    var argument : c_int = (cpsm) | (shift << 2) | (mask << 8) | (a3 << 16);
    sendCommandi(197,argument);
}

export fn sceGuColor(col: c_int) void{
    sceGuMaterial(7,col);
}

export fn sceGuMaterial(mode: c_int, col: c_int) void{
    if (mode & 0x01 != 0){
        sendCommandi(85, col & 0xffffff);
        sendCommandi(88, col >> 24);
    }

    if (mode & 0x02 != 0)
        sendCommandi(86, col & 0xffffff);

    if (mode & 0x04 != 0)
        sendCommandi(87, col & 0xffffff);
}

export fn sceGuColorFunc(func: c_int, color: c_int, mask: c_int) void{
    sendCommandi(216,func & 0x03);
    sendCommandi(217,color & 0xffffff);
    sendCommandi(218,mask);
}

export fn sceGuColorMaterial(components: c_int) void{
    sendCommandi(83,components);
}

export fn sceGuCopyImage(psm: c_int, sx: c_int, sy: c_int, width: c_int, height: c_int, srcw: c_int, src: ?*c_void, dx: c_int, dy: c_int, destw: c_int, dest: ?*c_void) void{
    var sr = @intCast(c_uint, @ptrToInt(src));
    var ds = @intCast(c_uint, @ptrToInt(dest));
    sendCommandi(178, @intCast(c_int, (sr) & 0xffffff));
    sendCommandi(179, @intCast(c_int, (((sr) & 0xff000000) >> 8))|srcw);
    sendCommandi(235, (sy << 10)|sx);
    sendCommandi(180, @intCast(c_int, (ds) & 0xffffff));
    sendCommandi(181, @intCast(c_int, (((ds) & 0xff000000) >> 8))|destw);
    sendCommandi(236, (dy << 10)|dx);
    sendCommandi(238, ((height-1) << 10)|(width-1));
    if(psm ^ 0x03 != 0){
        sendCommandi(234, 0);
    }else{
        sendCommandi(234, 1);
    }
}

export fn sceGuDepthBuffer(zbp: ?*c_void, zbw: c_int) void{
    gu_draw_buffer.depth_buffer = zbp;

    if (gu_draw_buffer.depth_width != 0 or (gu_draw_buffer.depth_width != zbw))
        gu_draw_buffer.depth_width = zbw;

    sendCommandi(158, @intCast(c_int, (@ptrToInt(zbp))) & 0xffffff);
    sendCommandi(159,@intCast(c_int, ((@intCast(c_uint, (@ptrToInt(zbp))) & 0xff000000) >> 8))|zbw);
}

export fn sceGuDepthFunc(function: c_int) void{
    sendCommandi(222,function);
}

export fn sceGuDepthMask(mask: c_int) void{
    sendCommandi(231,mask);
}

export fn sceGuDepthOffset(offset: c_uint) void{
    gu_contexts[@intCast(usize, gu_curr_context)].depth_offset = @intCast(i32, offset);
    sceGuDepthRange(gu_contexts[@intCast(usize, gu_curr_context)].near_plane,gu_contexts[@intCast(usize, gu_curr_context)].far_plane);
}

export fn sceGuDepthRange(near: c_int, far: c_int) void{
    var max = near + far;
    var val = ((max >> 31) + max);
    var z : f32 = @bitCast(f32, (val >> 1));

    gu_contexts[@intCast(usize, gu_curr_context)].near_plane = near;
    gu_contexts[@intCast(usize, gu_curr_context)].far_plane = far;

    sendCommandf(68,z - (@bitCast(f32, near)));
    sendCommandf(71,z + (@bitCast(f32, gu_contexts[@intCast(usize, gu_curr_context)].depth_offset)));

    if (near > far){
        sendCommandi(214,far);
        sendCommandi(215,near);
    }else{
        sendCommandi(214,near);
        sendCommandi(215,far);
    }
}

export fn sceGuDisable(state: c_int) void{
    switch(@intToEnum(GuState, state)){
        .AlphaTest => {
            sendCommandi(34,0);
        },
        .DepthTest => {
            sendCommandi(35,0);
        },
        .ScissorTest => {
            gu_contexts[@intCast(usize, gu_curr_context)].scissor_enable = 0;
            sendCommandi(212,0);
            sendCommandi(213,((gu_draw_buffer.height-1) << 10)|(gu_draw_buffer.width-1));
        },
        .StencilTest => {
            sendCommandi(36,0);
        },
        .Blend => {
            sendCommandi(33,0);
        },
        .CullFace => {
            sendCommandi(29,0);
        },
        .Dither => {
            sendCommandi(32,0);
        },
        .Fog => {
            sendCommandi(31,0);
        },
        .ClipPlanes => {
            sendCommandi(28,0);
        },
        .Texture2D => {
            sendCommandi(30,0);
        },
        .Lighting => {
            sendCommandi(23,0);
        },
        .Light0 => {
            sendCommandi(24,0);
        },
        .Light1 => {
            sendCommandi(25,0);
        },
        .Light2 => {
            sendCommandi(26,0);
        },
        .Light3 => {
            sendCommandi(27,0);
        },
        .LineSmooth => {
            sendCommandi(37,0);
        },
        .PatchCullFace => {
            sendCommandi(38,0);
        },
        .ColorTest => {
            sendCommandi(39,0);
        },
        .ColorLogicOp => {
            sendCommandi(40,0);
        },
        .FaceNormalReverse => {
            sendCommandi(81,0);
        },
        .PatchFace => {
            sendCommandi(56,0);
        },
        .Fragment2X => {
            gu_contexts[@intCast(usize, gu_curr_context)].fragment_2x = 0;
            sendCommandi(201,gu_contexts[@intCast(usize, gu_curr_context)].texture_function);
        }
    }

    var one : u32 = 1;

    if (state < 22)
        gu_states &= @intCast(i32, ~(one << @intCast(u5, state)));
}

fn drawRegion(x: c_int, y: c_int, width: c_int, height: c_int) void
{
  sendCommandi(21,(y << 10) | x);
  sendCommandi(22,(((y + height)-1) << 10) | ((x + width)-1));
}

export fn sceGuDispBuffer(width: c_int, height: c_int, dispbp: ?*c_void, dispbw: c_int) void{
    gu_draw_buffer.width = width;
    gu_draw_buffer.height = height;
    gu_draw_buffer.disp_buffer = dispbp;

    if ( (gu_draw_buffer.frame_width != 0) or (gu_draw_buffer.frame_width != dispbw))
        gu_draw_buffer.frame_width = dispbw;

    drawRegion(0,0,gu_draw_buffer.width,gu_draw_buffer.height);
    _ = sceDisplaySetMode(0,gu_draw_buffer.width,gu_draw_buffer.height);

    if (gu_display_on != 0)
        _ = sceDisplaySetFrameBuf( @intToPtr(*c_void, @ptrToInt(ge_edram_address) + @ptrToInt(gu_draw_buffer.disp_buffer)), dispbw, gu_draw_buffer.pixel_size, @enumToInt(PspDisplaySetBufSync.Nextframe));
}

export fn sceGuDisplay(state: c_int) c_int{
    if (state != 0){
        _ = sceDisplaySetFrameBuf( @intToPtr(*c_void, @ptrToInt(ge_edram_address) + @ptrToInt(gu_draw_buffer.disp_buffer)), gu_draw_buffer.frame_width, gu_draw_buffer.pixel_size, @enumToInt(PspDisplaySetBufSync.Nextframe));
    }else{
        _ = sceDisplaySetFrameBuf(null,0,0,@enumToInt(PspDisplaySetBufSync.Nextframe));
    }
    
    gu_display_on = state;
    return state;
}

export fn sceGuDrawArray(prim: c_int, vtype: c_int, count: c_int, indices: ?*const c_void, vertices: ?*const c_void) void{
    if (vtype != 0)
        sendCommandi(18,vtype);

    if (indices != null){
        sendCommandi(16,@intCast(c_int, (@ptrToInt(indices) >> 8)) & 0xf0000);
        sendCommandi(2,@intCast(c_int, @ptrToInt(indices)) & 0xffffff);
    }

    if (vertices != null){
        sendCommandi(16,@intCast(c_int, (@ptrToInt(vertices) >> 8)) & 0xf0000);
        sendCommandi(1,@intCast(c_int, @ptrToInt(vertices)) & 0xffffff);
    }
    sendCommandiStall(4,(prim << 16)|count);
}

export fn sceGuDrawArrayN(primitive_type: c_int, vertex_type: c_int, count: c_int, a3: c_int, indices: ?*const c_void, vertices: ?*const c_void) void{
    if (vertex_type != 0)
        sendCommandi(18,vertex_type);

    if (indices != null){
        sendCommandi(16,@intCast(c_int, (@ptrToInt(indices) >> 8)) & 0xf0000);
        sendCommandi(2,@intCast(c_int, @ptrToInt(indices)) & 0xffffff);
    }

    if (vertices != null){
        sendCommandi(16,@intCast(c_int, (@ptrToInt(vertices) >> 8)) & 0xf0000);
        sendCommandi(1,@intCast(c_int, @ptrToInt(vertices)) & 0xffffff);
    }

    if (a3 > 0){
        var i : usize = @intCast(usize, a3) - 1;
        while(i >= 0) : (i -= 1){
            sendCommandi(4,(primitive_type << 16)|count);
        }
        sendCommandiStall(4,(primitive_type << 16)|count);
    }
}

export fn sceGuDrawBezier(vtype: c_int, ucount: c_int, vcount: c_int, indices: ?*const c_void, vertices: ?*const c_void) void{
    if (vtype != 0)
        sendCommandi(18,vtype);

    if (indices != null){
        sendCommandi(16,@intCast(c_int, (@ptrToInt(indices) >> 8)) & 0xf0000);
        sendCommandi(2,@intCast(c_int, @ptrToInt(indices)) & 0xffffff);
    }

    if (vertices != null){
        sendCommandi(16,@intCast(c_int, (@ptrToInt(vertices) >> 8)) & 0xf0000);
        sendCommandi(1,@intCast(c_int, @ptrToInt(vertices)) & 0xffffff);
    }
    
    sendCommandi(5,(vcount << 8)|ucount);
}

export fn sceGuDrawBuffer(psm: c_int, fbp: ?*c_void, fbw: c_int) void{
    gu_draw_buffer.pixel_size = psm;
    gu_draw_buffer.frame_width = fbw;
    gu_draw_buffer.frame_buffer = fbp;

    if (gu_draw_buffer.depth_buffer != null and gu_draw_buffer.height != 0)
        gu_draw_buffer.depth_buffer = @intToPtr(*c_void, (@ptrToInt(fbp) + @intCast(usize, ((gu_draw_buffer.height * fbw) << 2))));

    if (gu_draw_buffer.depth_width != 0)
        gu_draw_buffer.depth_width = fbw;

    sendCommandi(210,psm);
    sendCommandi(156,@intCast(c_int, @intCast(c_uint, @ptrToInt(gu_draw_buffer.frame_buffer)) & 0xffffff));
    sendCommandi(157,@intCast(c_int, ((@intCast(c_uint, @ptrToInt(gu_draw_buffer.frame_buffer)) & 0xff000000) >> 8))|gu_draw_buffer.frame_width);
    sendCommandi(158,@intCast(c_int, @intCast(c_uint, @ptrToInt(gu_draw_buffer.depth_buffer)) & 0xffffff));
    sendCommandi(159,@intCast(c_int, ((@intCast(c_uint, @ptrToInt(gu_draw_buffer.depth_buffer)) & 0xff000000) >> 8))|gu_draw_buffer.depth_width);
}

export fn sceGuDrawBufferList(psm: c_int, fbp: ?*c_void, fbw: c_int) void{
    sendCommandi(210,psm);
    sendCommandi(156, @intCast(c_int, @ptrToInt(fbp) ) & 0xffffff);
    sendCommandi(157, @intCast(c_int, (@intCast(c_uint, @ptrToInt(fbp)) & 0xff000000) >> 8) | fbw);
}

export fn sceGuDrawSpline(vtype: c_int, ucount: c_int, vcount: c_int, uedge: c_int, vedge: c_int, indices: ?*const c_void, vertices: ?*const c_void) void{
    if (vtype != 0)
        sendCommandi(18,vtype);

    if (indices != null){
        sendCommandi(16,@intCast(c_int, (@ptrToInt(indices) >> 8)) & 0xf0000);
        sendCommandi(2,@intCast(c_int, @ptrToInt(indices)) & 0xffffff);
    }

    if (vertices != null){
        sendCommandi(16,@intCast(c_int, (@ptrToInt(vertices) >> 8)) & 0xf0000);
        sendCommandi(1,@intCast(c_int, @ptrToInt(vertices)) & 0xffffff);
    }
    
    sendCommandi(6,(vedge << 18)|(uedge << 16)|(vcount << 8)|ucount);
}

export fn sceGuEnable(state: c_int) void{
    switch(@intToEnum(GuState, state)){
        .AlphaTest => {
            sendCommandi(34,1);
        },
        .DepthTest => {
            sendCommandi(35,1);
        },
        .ScissorTest => {
            gu_contexts[@intCast(usize, gu_curr_context)].scissor_enable = 1;
            sendCommandi(212,(gu_contexts[@intCast(usize, gu_curr_context)].scissor_start[1]<<10)|gu_contexts[@intCast(usize, gu_curr_context)].scissor_start[0]);
            sendCommandi(213,(gu_contexts[@intCast(usize, gu_curr_context)].scissor_end[1]<<10)|gu_contexts[@intCast(usize, gu_curr_context)].scissor_end[0]);
        },
        .StencilTest => {
            sendCommandi(36,1);
        },
        .Blend => {
            sendCommandi(33,1);
        },
        .CullFace => {
            sendCommandi(29,1);
        },
        .Dither => {
            sendCommandi(32,1);
        },
        .Fog => {
            sendCommandi(31,1);
        },
        .ClipPlanes => {
            sendCommandi(28,1);
        },
        .Texture2D => {
            sendCommandi(30,1);
        },
        .Lighting => {
            sendCommandi(23,1);
        },
        .Light0 => {
            sendCommandi(24,1);
        },
        .Light1 => {
            sendCommandi(25,1);
        },
        .Light2 => {
            sendCommandi(26,1);
        },
        .Light3 => {
            sendCommandi(27,1);
        },
        .LineSmooth => {
            sendCommandi(37,1);
        },
        .PatchCullFace => {
            sendCommandi(38,1);
        },
        .ColorTest => {
            sendCommandi(39,1);
        },
        .ColorLogicOp => {
            sendCommandi(40,1);
        },
        .FaceNormalReverse => {
            sendCommandi(81,1);
        },
        .PatchFace => {
            sendCommandi(56,1);
        },
        .Fragment2X => {
            gu_contexts[@intCast(usize, gu_curr_context)].fragment_2x = 0x10000;
            sendCommandi(201, 0x10000|gu_contexts[@intCast(usize, gu_curr_context)].texture_function);
        }
    }

    var one : u32 = 1;
    if (state < 22)
        gu_states |= @intCast(i32, (one << @intCast(u5, state)));
}

export fn sceGuEndObject() void{

    var current : [*]u32 = gu_list.?.current;
    gu_list.?.current = @ptrCast([*]u32, &gu_object_stack[@intCast(usize, gu_object_stack_depth)-1]);

    sendCommandi(16, @intCast(c_int, (@ptrToInt(current) >> 8)) & 0xf0000);
    sendCommandi(9, @intCast(c_int, @ptrToInt(current)) & 0xffffff);

    gu_list.?.current = current;
    gu_object_stack_depth -= 1;
}

export fn sceGuBeginObject(vtype: c_int, count: c_int, indices: ?*const c_void, vertices: ?*const c_void) void{
    if (vtype != 0)
        sendCommandi(18,vtype);

    if (indices != null){
        sendCommandi(16,@intCast(c_int, (@ptrToInt(indices) >> 8)) & 0xf0000);
        sendCommandi(2,@intCast(c_int, @ptrToInt(indices)) & 0xffffff);
    }

    if (vertices != null){
        sendCommandi(16,@intCast(c_int, (@ptrToInt(vertices) >> 8)) & 0xf0000);
        sendCommandi(1,@intCast(c_int, @ptrToInt(vertices)) & 0xffffff);
    }
    sendCommandi(7,count);

    gu_object_stack[@intCast(usize, gu_object_stack_depth)] = @intCast(u32, @ptrToInt(gu_list.?.current));
    gu_object_stack_depth += 1;

    sendCommandi(16,0);
    sendCommandi(9,0);
}

export fn sceGuFinish() c_int{
    switch (@intToEnum(GuContextType, gu_curr_context)){
        .Direct, .Send =>{
            sendCommandi(15,0);
            sendCommandiStall(12,0);
        },
        
        .Call =>{
            if (gu_call_mode == 1){
                sendCommandi(14,0x120000);
                sendCommandi(12,0);
                sendCommandiStall(0,0);
            }else{
                sendCommandi(11,0);
            }
        }
    }

    var size : u32 = @ptrToInt(gu_list.?.current) - @ptrToInt(gu_list.?.start);

    // go to parent list    
    gu_curr_context = gu_list.?.parent_context;
    gu_list = &gu_contexts[@intCast(usize, gu_curr_context)].list;
    return @intCast(c_int, size);
}

export fn sceGuFinishId(id: c_int) c_int{
    switch (@intToEnum(GuContextType, gu_curr_context)){
        .Direct, .Send =>{
            sendCommandi(15, id & 0xffff);
            sendCommandiStall(12,0);
        },
        
        .Call =>{
            if (gu_call_mode == 1){
                sendCommandi(14,0x120000);
                sendCommandi(12,0);
                sendCommandiStall(0,0);
            }else{
                sendCommandi(11,0);
            }
        }
    }

    var size : u32 = @ptrToInt(gu_list.?.current) - @ptrToInt(gu_list.?.start);

    // go to parent list    
    gu_curr_context = gu_list.?.parent_context;
    gu_list = &gu_contexts[@intCast(usize, gu_curr_context)].list;
    return @intCast(c_int, size);
}

export fn sceGuFog(near: f32, far: f32, col: c_uint) void{
    var distance : f32 = far-near;
    if (distance > 0)
        distance = 1.0 / distance;
    
    sendCommandi(207,@intCast(c_int, col & 0xffffff));
    sendCommandf(205,far);
    sendCommandf(206,distance);
}

export fn sceGuFrontFace(order: c_int) void{
    if (order != 0){
        sendCommandi(155,0);
    }else{
        sendCommandi(155,1);
    }
}

export fn sceGuGetAllStatus() c_int{
    return gu_states;
}

export fn sceGuGetStatus(state: c_int) c_int{
    if (state < 22)
        return (gu_states >> @intCast(u5, state)) & 1;
    return 0;
}

export fn sceGuLight(light: usize, typec: c_int, components: c_int, position: [*c]const ScePspFVector3) void{
    
    sendCommandf(light_settings[light].xpos,position.*.x);
    sendCommandf(light_settings[light].ypos,position.*.y);
    sendCommandf(light_settings[light].zpos,position.*.z);

    var kind : c_int = 2;
    if (components != 8){
        if((components^6) < 1){
            kind = 1;
        }else{
            kind = 0;
        }
    }

    sendCommandi(light_settings[light].typec,((typec & 0x03) << 8)|kind);
}

export fn sceGuLightAtt(light: usize, atten0: f32, atten1: f32, atten2: f32) void{
    sendCommandf(light_settings[light].constant,atten0);
    sendCommandf(light_settings[light].linear,atten1);
    sendCommandf(light_settings[light].quadratic,atten2);
}

export fn sceGuLightColor(light: usize, component: c_int, col: c_int) void{
    switch(@intToEnum(LightBitFlags, component)){
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
        else => {
        }
    }
}

export fn sceGuLightMode(mode: c_int) void{
    sendCommandi(94,mode);
}

export fn sceGuLightSpot(light: usize, direction: [*c]const ScePspFVector3, exponent: f32, cutoff: f32) void{
    sendCommandf(light_settings[light].exponent,exponent);
    sendCommandf(light_settings[light].cutoff,cutoff);
    sendCommandf(light_settings[light].xdir,direction.*.x);
    sendCommandf(light_settings[light].ydir,direction.*.y);
    sendCommandf(light_settings[light].zdir,direction.*.z);
}

export fn sceGuLogicalOp(op: c_int) void{
    sendCommandi(230,op & 0x0f);
}

export fn sceGuModelColor(emissive: c_int, ambient: c_int, diffuse: c_int, specular: c_int) void{
    sendCommandi(84, emissive & 0xffffff);
    sendCommandi(86, diffuse & 0xffffff);
    sendCommandi(85, ambient & 0xffffff);
    sendCommandi(87, specular & 0xffffff);
}

export fn sceGuMorphWeight(index: c_int, weight: f32) void{
    sendCommandf(44 + index,weight);
}

export fn sceGuOffset(x: c_int, y: c_int) void{
    sendCommandi(76,x << 4);
    sendCommandi(77,y << 4);
}

export fn sceGuPatchDivide(ulevel: c_int, vlevel: c_int) void{
    sendCommandi(54,(vlevel << 8)|ulevel);
}

export fn sceGuPatchFrontFace(a0: c_int) void{
    sendCommandi(56,a0);
}

export fn sceGuPatchPrim(prim: c_int) void{
    switch(@intToEnum(GuPrimitive, prim)){
        .Points => {
            sendCommandi(55,2);
        },
        .LineStrip => {
            sendCommandi(55,1);
        }, 
        .TriangleStrip => {
            sendCommandi(55,0);
        },
        else => {

        }
    }
}

export fn sceGuPixelMask(mask: c_int) void{
    sendCommandi(232,mask & 0xffffff);
    sendCommandi(233,mask >> 24);
}

export fn sceGuScissor(x: c_int, y: c_int, w: c_int, h: c_int) void{
    gu_contexts[@intCast(usize, gu_curr_context)].scissor_start[0] = x;
    gu_contexts[@intCast(usize, gu_curr_context)].scissor_start[1] = y;
    gu_contexts[@intCast(usize, gu_curr_context)].scissor_end[0] = w-1;
    gu_contexts[@intCast(usize, gu_curr_context)].scissor_end[1] = h-1;

    if (gu_contexts[@intCast(usize, gu_curr_context)].scissor_enable != 0){
        sendCommandi(212,(gu_contexts[@intCast(usize, gu_curr_context)].scissor_start[1] << 10)|gu_contexts[@intCast(usize, gu_curr_context)].scissor_start[0]);
        sendCommandi(213,(gu_contexts[@intCast(usize, gu_curr_context)].scissor_end[1] << 10)|gu_contexts[@intCast(usize, gu_curr_context)].scissor_end[0]);
    }
}


export fn sceGuSendCommandf(cmd: c_int, argument: f32) void{
    sendCommandf(cmd,argument);
}

export fn sceGuSendCommandi(cmd: c_int, argument: c_int) void{
    sendCommandi(cmd,argument);
}

export fn sceGuSendList(mode: c_int, list: ?*const c_void, context: [*c]PspGeContext) void{
    gu_settings.signal_offset = 0;
    var args : PspGeListArgs = undefined;
    args.size = 8;
    args.context = context;

    var list_id : i32 = 0;
    var callback = gu_settings.ge_callback_id;

    switch (@intToEnum(GuQueueMode, mode)){
        .Head => {
            list_id = sceGeListEnQueueHead(list,null,callback,&args);
        },
        .Tail => {
            list_id = sceGeListEnQueue(list,null,callback,&args);
        }
    }

    ge_list_executed[1] = list_id;
}
