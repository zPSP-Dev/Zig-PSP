usingnamespace @import("psptypes.zig");

pub const struct_SceMpegLLI = extern struct {
    pSrc: ScePVoid,
    pDst: ScePVoid,
    Next: ScePVoid,
    iSize: SceInt32,
};
pub const SceMpegLLI = struct_SceMpegLLI;
pub const struct_SceMpegYCrCbBuffer = extern struct {
    iFrameBufferHeight16: SceInt32,
    iFrameBufferWidth16: SceInt32,
    iUnknown: SceInt32,
    iUnknown2: SceInt32,
    pYBuffer: ScePVoid,
    pYBuffer2: ScePVoid,
    pCrBuffer: ScePVoid,
    pCbBuffer: ScePVoid,
    pCrBuffer2: ScePVoid,
    pCbBuffer2: ScePVoid,
    iFrameHeight: SceInt32,
    iFrameWidth: SceInt32,
    iFrameBufferWidth: SceInt32,
    iUnknown3: [11]SceInt32,
};
pub const SceMpegYCrCbBuffer = struct_SceMpegYCrCbBuffer;
pub extern fn sceMpegBaseYCrCbCopyVme(YUVBuffer: ScePVoid, Buffer: [*c]SceInt32, Type: SceInt32) SceInt32;
pub extern fn sceMpegBaseCscInit(width: SceInt32) SceInt32;
pub extern fn sceMpegBaseCscVme(pRGBbuffer: ScePVoid, pRGBbuffer2: ScePVoid, width: SceInt32, pYCrCbBuffer: [*c]SceMpegYCrCbBuffer) SceInt32;
pub extern fn sceMpegbase_BEA18F91(pLLI: [*c]SceMpegLLI) SceInt32;
pub const SceMpeg = ScePVoid;
pub const SceMpegStream = SceVoid;
pub const sceMpegRingbufferCB = ?fn (ScePVoid, SceInt32, ScePVoid) callconv(.C) SceInt32;
pub const struct_SceMpegRingbuffer = extern struct {
    iPackets: SceInt32,
    iUnk0: SceUInt32,
    iUnk1: SceUInt32,
    iUnk2: SceUInt32,
    iUnk3: SceUInt32,
    pData: ScePVoid,
    Callback: sceMpegRingbufferCB,
    pCBparam: ScePVoid,
    iUnk4: SceUInt32,
    iUnk5: SceUInt32,
    pSceMpeg: SceMpeg,
};
pub const SceMpegRingbuffer = struct_SceMpegRingbuffer;
pub const struct_SceMpegAu = extern struct {
    iPtsMSB: SceUInt32,
    iPts: SceUInt32,
    iDtsMSB: SceUInt32,
    iDts: SceUInt32,
    iEsBuffer: SceUInt32,
    iAuSize: SceUInt32,
};
pub const SceMpegAu = struct_SceMpegAu;
pub const struct_SceMpegAvcMode = extern struct {
    iUnk0: SceInt32,
    iPixelFormat: SceInt32,
};
pub const SceMpegAvcMode = struct_SceMpegAvcMode;
pub extern fn sceMpegInit(...) SceInt32;
pub extern fn sceMpegFinish(...) SceVoid;
pub extern fn sceMpegRingbufferQueryMemSize(iPackets: SceInt32) SceInt32;
pub extern fn sceMpegRingbufferConstruct(Ringbuffer: [*c]SceMpegRingbuffer, iPackets: SceInt32, pData: ScePVoid, iSize: SceInt32, Callback: sceMpegRingbufferCB, pCBparam: ScePVoid) SceInt32;
pub extern fn sceMpegRingbufferDestruct(Ringbuffer: [*c]SceMpegRingbuffer) SceVoid;
pub extern fn sceMpegRingbufferAvailableSize(Ringbuffer: [*c]SceMpegRingbuffer) SceInt32;
pub extern fn sceMpegRingbufferPut(Ringbuffer: [*c]SceMpegRingbuffer, iNumPackets: SceInt32, iAvailable: SceInt32) SceInt32;
pub extern fn sceMpegQueryMemSize(iUnk: c_int) SceInt32;
pub extern fn sceMpegCreate(Mpeg: [*c]SceMpeg, pData: ScePVoid, iSize: SceInt32, Ringbuffer: [*c]SceMpegRingbuffer, iFrameWidth: SceInt32, iUnk1: SceInt32, iUnk2: SceInt32) SceInt32;
pub extern fn sceMpegDelete(Mpeg: [*c]SceMpeg) SceVoid;
pub extern fn sceMpegQueryStreamOffset(Mpeg: [*c]SceMpeg, pBuffer: ScePVoid, iOffset: [*c]SceInt32) SceInt32;
pub extern fn sceMpegQueryStreamSize(pBuffer: ScePVoid, iSize: [*c]SceInt32) SceInt32;
pub extern fn sceMpegRegistStream(Mpeg: [*c]SceMpeg, iStreamID: SceInt32, iUnk: SceInt32) ?*SceMpegStream;
pub extern fn sceMpegUnRegistStream(Mpeg: SceMpeg, pStream: ?*SceMpegStream) SceVoid;
pub extern fn sceMpegFlushAllStream(Mpeg: [*c]SceMpeg) SceInt32;
pub extern fn sceMpegMallocAvcEsBuf(Mpeg: [*c]SceMpeg) ScePVoid;
pub extern fn sceMpegFreeAvcEsBuf(Mpeg: [*c]SceMpeg, pBuf: ScePVoid) SceVoid;
pub extern fn sceMpegQueryAtracEsSize(Mpeg: [*c]SceMpeg, iEsSize: [*c]SceInt32, iOutSize: [*c]SceInt32) SceInt32;
pub extern fn sceMpegInitAu(Mpeg: [*c]SceMpeg, pEsBuffer: ScePVoid, pAu: [*c]SceMpegAu) SceInt32;
pub extern fn sceMpegGetAvcAu(Mpeg: [*c]SceMpeg, pStream: ?*SceMpegStream, pAu: [*c]SceMpegAu, iUnk: [*c]SceInt32) SceInt32;
pub extern fn sceMpegAvcDecodeMode(Mpeg: [*c]SceMpeg, pMode: [*c]SceMpegAvcMode) SceInt32;
pub extern fn sceMpegAvcDecode(Mpeg: [*c]SceMpeg, pAu: [*c]SceMpegAu, iFrameWidth: SceInt32, pBuffer: ScePVoid, iInit: [*c]SceInt32) SceInt32;
pub extern fn sceMpegAvcDecodeStop(Mpeg: [*c]SceMpeg, iFrameWidth: SceInt32, pBuffer: ScePVoid, iStatus: [*c]SceInt32) SceInt32;
pub extern fn sceMpegGetAtracAu(Mpeg: [*c]SceMpeg, pStream: ?*SceMpegStream, pAu: [*c]SceMpegAu, pUnk: ScePVoid) SceInt32;
pub extern fn sceMpegAtracDecode(Mpeg: [*c]SceMpeg, pAu: [*c]SceMpegAu, pBuffer: ScePVoid, iInit: SceInt32) SceInt32;
