// MPEG video codec
//
// Wraps:
//   c/module/sceMpeg.zig
//   c/module/sceMpegbase.zig

const c = @import("../c/modules.zig");
const internal = @import("internal.zig");
const check = internal.check;
const checkPositive = internal.checkPositive;
const Error = internal.Error;

const mpeg = c.sceMpeg;
const base = c.sceMpegbase;

// -- Re-exported types -------------------------------------------------

pub const SceMpeg = c.types.SceMpeg;
pub const SceMpegAu = c.types.SceMpegAu;
pub const SceMpegAvcMode = c.types.SceMpegAvcMode;
pub const SceMpegLLI = c.types.SceMpegLLI;
pub const SceMpegRingbuffer = c.types.SceMpegRingbuffer;
pub const RingbufferCB = c.types.sceMpegRingbufferCB;
pub const SceMpegStream = c.types.SceMpegStream;
pub const SceMpegYCrCbBuffer = c.types.SceMpegYCrCbBuffer;

// -- Lifecycle ---------------------------------------------------------

pub fn init() Error!void {
    return check(mpeg.sceMpegInit());
}

pub fn finish() void {
    mpeg.sceMpegFinish();
}

pub fn query_mem_size(unk: i32) Error!i32 {
    const ret = mpeg.sceMpegQueryMemSize(@as(c_int, unk));
    return checkPositive(ret);
}

pub fn create(m: [*c]SceMpeg, data: ?*anyopaque, size: i32, ringbuffer: [*c]SceMpegRingbuffer, frame_width: i32, unk1: i32, unk2: i32) Error!void {
    return check(mpeg.sceMpegCreate(m, data, size, ringbuffer, frame_width, unk1, unk2));
}

pub fn delete(m: [*c]SceMpeg) void {
    mpeg.sceMpegDelete(m);
}

// -- Stream query ------------------------------------------------------

pub fn query_stream_offset(m: [*c]SceMpeg, buf: ?*anyopaque, offset: *i32) Error!void {
    return check(mpeg.sceMpegQueryStreamOffset(m, buf, offset));
}

pub fn query_stream_size(buf: ?*anyopaque, size: *i32) Error!void {
    return check(mpeg.sceMpegQueryStreamSize(buf, size));
}

// -- Stream registration -----------------------------------------------

pub fn regist_stream(m: [*c]SceMpeg, stream_id: i32, unk: i32) [*c]SceMpegStream {
    return mpeg.sceMpegRegistStream(m, stream_id, unk);
}

pub fn unregist_stream(m: SceMpeg, stream: [*c]SceMpegStream) void {
    mpeg.sceMpegUnRegistStream(m, stream);
}

// -- ES buffers --------------------------------------------------------

pub fn malloc_avc_es_buf(m: [*c]SceMpeg) ?*anyopaque {
    return mpeg.sceMpegMallocAvcEsBuf(m);
}

pub fn free_avc_es_buf(m: [*c]SceMpeg, buf: ?*anyopaque) void {
    mpeg.sceMpegFreeAvcEsBuf(m, buf);
}

pub fn query_atrac_es_size(m: [*c]SceMpeg, es_size: *i32, out_size: *i32) Error!void {
    return check(mpeg.sceMpegQueryAtracEsSize(m, es_size, out_size));
}

// -- AU operations -----------------------------------------------------

pub fn init_au(m: [*c]SceMpeg, es_buffer: ?*anyopaque, au: [*c]SceMpegAu) Error!void {
    return check(mpeg.sceMpegInitAu(m, es_buffer, au));
}

pub fn get_avc_au(m: [*c]SceMpeg, stream: [*c]SceMpegStream, au: [*c]SceMpegAu, unk: [*c]i32) Error!void {
    return check(mpeg.sceMpegGetAvcAu(m, stream, au, unk));
}

pub fn get_atrac_au(m: [*c]SceMpeg, stream: [*c]SceMpegStream, au: [*c]SceMpegAu, unk: ?*anyopaque) Error!void {
    return check(mpeg.sceMpegGetAtracAu(m, stream, au, unk));
}

pub fn flush_all_stream(m: [*c]SceMpeg) Error!void {
    return check(mpeg.sceMpegFlushAllStream(m));
}

// -- AVC decode --------------------------------------------------------

pub fn avc_decode(m: [*c]SceMpeg, au: [*c]SceMpegAu, frame_width: i32, buffer: ?*anyopaque, init_flag: [*c]i32) Error!void {
    return check(mpeg.sceMpegAvcDecode(m, au, frame_width, buffer, init_flag));
}

pub fn avc_decode_mode(m: [*c]SceMpeg, mode: [*c]SceMpegAvcMode) Error!void {
    return check(mpeg.sceMpegAvcDecodeMode(m, mode));
}

pub fn avc_decode_stop(m: [*c]SceMpeg, frame_width: i32, buffer: ?*anyopaque, status: [*c]i32) Error!void {
    return check(mpeg.sceMpegAvcDecodeStop(m, frame_width, buffer, status));
}

// -- ATRAC decode ------------------------------------------------------

pub fn atrac_decode(m: [*c]SceMpeg, au: [*c]SceMpegAu, buffer: ?*anyopaque, init_flag: i32) Error!void {
    return check(mpeg.sceMpegAtracDecode(m, au, buffer, init_flag));
}

// -- Ringbuffer --------------------------------------------------------

pub fn ringbuffer_query_mem_size(packets: i32) Error!i32 {
    const ret = mpeg.sceMpegRingbufferQueryMemSize(packets);
    return checkPositive(ret);
}

pub fn ringbuffer_construct(rb: [*c]SceMpegRingbuffer, packets: i32, data: ?*anyopaque, size: i32, callback: RingbufferCB, cb_param: ?*anyopaque) Error!void {
    return check(mpeg.sceMpegRingbufferConstruct(rb, packets, data, size, callback, cb_param));
}

pub fn ringbuffer_destruct(rb: [*c]SceMpegRingbuffer) void {
    mpeg.sceMpegRingbufferDestruct(rb);
}

pub fn ringbuffer_put(rb: [*c]SceMpegRingbuffer, num_packets: i32, available: i32) i32 {
    return mpeg.sceMpegRingbufferPut(rb, num_packets, available);
}

pub fn ringbuffer_available_size(rb: [*c]SceMpegRingbuffer) i32 {
    return mpeg.sceMpegRingbufferAvailableSize(rb);
}

// -- sceMpegbase -------------------------------------------------------

pub fn base_ycrcb_copy_vme(yuv_buffer: ?*anyopaque, buffer: [*c]i32, copy_type: i32) Error!void {
    return check(base.sceMpegBaseYCrCbCopyVme(yuv_buffer, buffer, copy_type));
}

pub fn base_csc_init(width: i32) Error!void {
    return check(base.sceMpegBaseCscInit(width));
}

pub fn base_csc_vme(rgb_buffer: ?*anyopaque, rgb_buffer2: ?*anyopaque, width: i32, ycrcb_buffer: [*c]SceMpegYCrCbBuffer) Error!void {
    return check(base.sceMpegBaseCscVme(rgb_buffer, rgb_buffer2, width, ycrcb_buffer));
}

pub fn base_lli(lli: [*c]SceMpegLLI) Error!void {
    return check(base.sceMpegbase_BEA18F91(lli));
}

// Undocumented stubs
pub const base_ycrcb_copy = base.sceMpegBaseYCrCbCopy;
pub const base_csc_avc = base.sceMpegBaseCscAvc;
pub const query_pcm_es_size = mpeg.sceMpegQueryPcmEsSize;
pub const flush_stream = mpeg.sceMpegFlushStream;
pub const change_get_avc_au_mode = mpeg.sceMpegChangeGetAvcAuMode;
pub const change_get_au_mode = mpeg.sceMpegChangeGetAuMode;
pub const get_pcm_au = mpeg.sceMpegGetPcmAu;
pub const avc_decode_detail = mpeg.sceMpegAvcDecodeDetail;
pub const avc_decode_detail2 = mpeg.sceMpegAvcDecodeDetail2;
