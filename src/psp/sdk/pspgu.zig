usingnamespace @import("psptypes.zig");
usingnamespace @import("pspge.zig");
pub usingnamespace @import("pspgutypes.zig");

pub extern fn sceGuDepthBuffer(zbp: ?*c_void, zbw: c_int) void;
pub extern fn sceGuDispBuffer(width: c_int, height: c_int, dispbp: ?*c_void, dispbw: c_int) void;
pub extern fn sceGuDrawBuffer(psm: c_int, fbp: ?*c_void, fbw: c_int) void;
pub extern fn sceGuDrawBufferList(psm: c_int, fbp: ?*c_void, fbw: c_int) void;
pub extern fn sceGuDisplay(state: c_int) c_int;
pub extern fn sceGuDepthFunc(function: c_int) void;
pub extern fn sceGuDepthMask(mask: c_int) void;
pub extern fn sceGuDepthOffset(offset: c_uint) void;
pub extern fn sceGuDepthRange(near: c_int, far: c_int) void;
pub extern fn sceGuFog(near: f32, far: f32, color: c_uint) void;
pub extern fn sceGuInit() void;
pub extern fn sceGuTerm() void;
pub extern fn sceGuBreak(a0: c_int) void;
pub extern fn sceGuContinue() void;
pub extern fn sceGuSetCallback(signal: c_int, callback: ?fn (c_int) callconv(.C) void) ?*c_void;
pub extern fn sceGuSignal(signal: c_int, behavior: c_int) void;
pub extern fn sceGuSendCommandf(cmd: c_int, argument: f32) void;
pub extern fn sceGuSendCommandi(cmd: c_int, argument: c_int) void;
pub extern fn sceGuGetMemory(size: c_int) ?*c_void;
pub extern fn sceGuStart(cid: c_int, list: ?*c_void) void;
pub extern fn sceGuFinish() c_int;
pub extern fn sceGuFinishId(id: c_uint) c_int;
pub extern fn sceGuCallList(list: ?*const c_void) void;
pub extern fn sceGuCallMode(mode: c_int) void;
pub extern fn sceGuCheckList() c_int;
pub extern fn sceGuSendList(mode: c_int, list: ?*const c_void, context: [*c]PspGeContext) void;
pub extern fn sceGuSwapBuffers() ?*c_void;
pub extern fn sceGuSync(mode: c_int, what: c_int) c_int;
pub extern fn sceGuDrawArray(prim: c_int, vtype: c_int, count: c_int, indices: ?*const c_void, vertices: ?*const c_void) void;
pub extern fn sceGuBeginObject(vtype: c_int, count: c_int, indices: ?*const c_void, vertices: ?*const c_void) void;
pub extern fn sceGuEndObject() void;
pub extern fn sceGuSetStatus(state: c_int, status: c_int) void;
pub extern fn sceGuGetStatus(state: c_int) c_int;
pub extern fn sceGuSetAllStatus(status: c_int) void;
pub extern fn sceGuGetAllStatus() c_int;
pub extern fn sceGuEnable(state: c_int) void;
pub extern fn sceGuDisable(state: c_int) void;
pub extern fn sceGuLight(light: c_int, typec: c_int, components: c_int, position: [*c]const ScePspFVector3) void;
pub extern fn sceGuLightAtt(light: c_int, atten0: f32, atten1: f32, atten2: f32) void;
pub extern fn sceGuLightColor(light: c_int, component: c_int, color: c_uint) void;
pub extern fn sceGuLightMode(mode: c_int) void;
pub extern fn sceGuLightSpot(light: c_int, direction: [*c]const ScePspFVector3, exponent: f32, cutoff: f32) void;
pub extern fn sceGuClear(flags: c_int) void;
pub extern fn sceGuClearColor(color: c_uint) void;
pub extern fn sceGuClearDepth(depth: c_uint) void;
pub extern fn sceGuClearStencil(stencil: c_uint) void;
pub extern fn sceGuPixelMask(mask: c_uint) void;
pub extern fn sceGuColor(color: c_uint) void;
pub extern fn sceGuColorFunc(func: c_int, color: c_uint, mask: c_uint) void;
pub extern fn sceGuColorMaterial(components: c_int) void;
pub extern fn sceGuAlphaFunc(func: c_int, value: c_int, mask: c_int) void;
pub extern fn sceGuAmbient(color: c_uint) void;
pub extern fn sceGuAmbientColor(color: c_uint) void;
pub extern fn sceGuBlendFunc(op: c_int, src: c_int, dest: c_int, srcfix: c_uint, destfix: c_uint) void;
pub extern fn sceGuMaterial(mode: c_int, color: c_int) void;
pub extern fn sceGuModelColor(emissive: c_uint, ambient: c_uint, diffuse: c_uint, specular: c_uint) void;
pub extern fn sceGuStencilFunc(func: c_int, ref: c_int, mask: c_int) void;
pub extern fn sceGuStencilOp(fail: c_int, zfail: c_int, zpass: c_int) void;
pub extern fn sceGuSpecular(power: f32) void;
pub extern fn sceGuFrontFace(order: c_int) void;
pub extern fn sceGuLogicalOp(op: c_int) void;
pub extern fn sceGuSetDither(matrix: [*c]const ScePspIMatrix4) void;
pub extern fn sceGuShadeModel(mode: c_int) void;
pub extern fn sceGuCopyImage(psm: c_int, sx: c_int, sy: c_int, width: c_int, height: c_int, srcw: c_int, src: ?*c_void, dx: c_int, dy: c_int, destw: c_int, dest: ?*c_void) void;
pub extern fn sceGuTexEnvColor(color: c_uint) void;
pub extern fn sceGuTexFilter(min: c_int, mag: c_int) void;
pub extern fn sceGuTexFlush() void;
pub extern fn sceGuTexFunc(tfx: c_int, tcc: c_int) void;
pub extern fn sceGuTexImage(mipmap: c_int, width: c_int, height: c_int, tbw: c_int, tbp: ?*const c_void) void;
pub extern fn sceGuTexLevelMode(mode: c_uint, bias: f32) void;
pub extern fn sceGuTexMapMode(mode: c_int, a1: c_uint, a2: c_uint) void;
pub extern fn sceGuTexMode(tpsm: c_int, maxmips: c_int, a2: c_int, swizzle: c_int) void;
pub extern fn sceGuTexOffset(u: f32, v: f32) void;
pub extern fn sceGuTexProjMapMode(mode: c_int) void;
pub extern fn sceGuTexScale(u: f32, v: f32) void;
pub extern fn sceGuTexSlope(slope: f32) void;
pub extern fn sceGuTexSync(...) void;
pub extern fn sceGuTexWrap(u: c_int, v: c_int) void;
pub extern fn sceGuClutLoad(num_blocks: c_int, cbp: ?*const c_void) void;
pub extern fn sceGuClutMode(cpsm: c_uint, shift: c_uint, mask: c_uint, a3: c_uint) void;
pub extern fn sceGuOffset(x: c_uint, y: c_uint) void;
pub extern fn sceGuScissor(x: c_int, y: c_int, w: c_int, h: c_int) void;
pub extern fn sceGuViewport(cx: c_int, cy: c_int, width: c_int, height: c_int) void;
pub extern fn sceGuDrawBezier(vtype: c_int, ucount: c_int, vcount: c_int, indices: ?*const c_void, vertices: ?*const c_void) void;
pub extern fn sceGuPatchDivide(ulevel: c_uint, vlevel: c_uint) void;
pub extern fn sceGuPatchFrontFace(a0: c_uint) void;
pub extern fn sceGuPatchPrim(prim: c_int) void;
pub extern fn sceGuDrawSpline(vtype: c_int, ucount: c_int, vcount: c_int, uedge: c_int, vedge: c_int, indices: ?*const c_void, vertices: ?*const c_void) void;
pub extern fn sceGuSetMatrix(type: c_int, matrix: [*c]const ScePspFMatrix4) void;
pub extern fn sceGuBoneMatrix(index: c_uint, matrix: [*c]const ScePspFMatrix4) void;
pub extern fn sceGuMorphWeight(index: c_int, weight: f32) void;
pub extern fn sceGuDrawArrayN(primitive_type: c_int, vertex_type: c_int, count: c_int, a3: c_int, indices: ?*const c_void, vertices: ?*const c_void) void;
pub extern fn guSwapBuffersBehaviour(behaviour: c_int) void;
pub extern fn guSwapBuffersCallback(callback: GuSwapBuffersCallback) void;

pub fn abgr(a: u8, b: u8, g: u8, r: u8) u32 {
    return @as(u32, r) | (@as(u32, g) << 8) | (@as(u32, b) << 16) | (@as(u32, a) << 24);
}

pub fn argb(a: u8, r: u8, g: u8, b: u8) u32 {
    return abgr(a, b, g, r);
}

pub fn rgba(r: u8, g: u8, b: u8, a: u8) u32 {
    return argb(a, r, g, b);
}

pub fn color(r: f32, g: f32, b: f32, a: f32) u32 {
    return rgba(
        @as(u8, (r * 255.0)),
        @as(u8, (g * 255.0)),
        @as(u8, (b * 255.0)),
        @as(u8, (a * 255.0))
    );
}
