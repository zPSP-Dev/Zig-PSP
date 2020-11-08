usingnamespace @import("psptypes.zig");

pub const SceMpegLLI = extern struct {
    pSrc: ScePVoid,
    pDst: ScePVoid,
    Next: ScePVoid,
    iSize: SceInt32,
};

pub const SceMpegYCrCbBuffer = extern struct {
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

pub const SceMpeg = ScePVoid;
pub const SceMpegStream = SceVoid;
pub const sceMpegRingbufferCB = ?fn (ScePVoid, SceInt32, ScePVoid) callconv(.C) SceInt32;

pub const SceMpegRingbuffer = extern struct {
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

pub const SceMpegAu = extern struct {
    iPtsMSB: SceUInt32,
    iPts: SceUInt32,
    iDtsMSB: SceUInt32,
    iDts: SceUInt32,
    iEsBuffer: SceUInt32,
    iAuSize: SceUInt32,
};

pub const SceMpegAvcMode = extern struct {
    iUnk0: SceInt32,
    iPixelFormat: SceInt32,
};

//MpegBase
pub extern fn sceMpegBaseYCrCbCopyVme(YUVBuffer: ScePVoid, Buffer: [*c]SceInt32, Type: SceInt32) SceInt32;
pub extern fn sceMpegBaseCscInit(width: SceInt32) SceInt32;
pub extern fn sceMpegBaseCscVme(pRGBbuffer: ScePVoid, pRGBbuffer2: ScePVoid, width: SceInt32, pYCrCbBuffer: [*c]SceMpegYCrCbBuffer) SceInt32;
pub extern fn sceMpegbase_BEA18F91(pLLI: [*c]SceMpegLLI) SceInt32;

// sceMpegInit
//
// @return 0 if success.
pub extern fn sceMpegInit() SceInt32;

//sceMpegFinish
pub extern fn sceMpegFinish() SceVoid;

// sceMpegRingbufferQueryMemSize
//
// @param iPackets - number of packets in the ringbuffer
//
// @return < 0 if error else ringbuffer data size.
pub extern fn sceMpegRingbufferQueryMemSize(iPackets: SceInt32) SceInt32;

// sceMpegRingbufferConstruct
//
// @param Ringbuffer - pointer to a sceMpegRingbuffer struct
// @param iPackets - number of packets in the ringbuffer
// @param pData - pointer to allocated memory
// @param iSize - size of allocated memory, shoud be sceMpegRingbufferQueryMemSize(iPackets)
// @param Callback - ringbuffer callback
// @param pCBparam - param passed to callback
//
// @return 0 if success.
pub extern fn sceMpegRingbufferConstruct(Ringbuffer: [*c]SceMpegRingbuffer, iPackets: SceInt32, pData: ScePVoid, iSize: SceInt32, Callback: sceMpegRingbufferCB, pCBparam: ScePVoid) SceInt32;

// sceMpegRingbufferDestruct
//
// @param Ringbuffer - pointer to a sceMpegRingbuffer struct
pub extern fn sceMpegRingbufferDestruct(Ringbuffer: [*c]SceMpegRingbuffer) SceVoid;

// sceMpegQueryMemSize
//
// @param Ringbuffer - pointer to a sceMpegRingbuffer struct
//
// @return < 0 if error else number of free packets in the ringbuffer.
pub extern fn sceMpegRingbufferAvailableSize(Ringbuffer: [*c]SceMpegRingbuffer) SceInt32;

// sceMpegRingbufferPut
//
// @param Ringbuffer - pointer to a sceMpegRingbuffer struct
// @param iNumPackets - num packets to put into the ringbuffer
// @param iAvailable - free packets in the ringbuffer, should be sceMpegRingbufferAvailableSize()
//
// @return < 0 if error else number of packets.
pub extern fn sceMpegRingbufferPut(Ringbuffer: [*c]SceMpegRingbuffer, iNumPackets: SceInt32, iAvailable: SceInt32) SceInt32;

// sceMpegQueryMemSize
//
// @param iUnk - Unknown, set to 0
//
// @return < 0 if error else decoder data size.
pub extern fn sceMpegQueryMemSize(iUnk: c_int) SceInt32;

// sceMpegCreate
//
// @param Mpeg - will be filled
// @param pData - pointer to allocated memory of size = sceMpegQueryMemSize()
// @param iSize - size of data, should be = sceMpegQueryMemSize()
// @param Ringbuffer - a ringbuffer
// @param iFrameWidth - display buffer width, set to 512 if writing to framebuffer
// @param iUnk1 - unknown, set to 0
// @param iUnk2 - unknown, set to 0
//
// @return 0 if success.
pub extern fn sceMpegCreate(Mpeg: [*c]SceMpeg, pData: ScePVoid, iSize: SceInt32, Ringbuffer: [*c]SceMpegRingbuffer, iFrameWidth: SceInt32, iUnk1: SceInt32, iUnk2: SceInt32) SceInt32;

// sceMpegDelete
//
// @param Mpeg - SceMpeg handle
pub extern fn sceMpegDelete(Mpeg: [*c]SceMpeg) SceVoid;

// sceMpegQueryStreamOffset
//
// @param Mpeg - SceMpeg handle
// @param pBuffer - pointer to file header
// @param iOffset - will contain stream offset in bytes, usually 2048
//
// @return 0 if success.
pub extern fn sceMpegQueryStreamOffset(Mpeg: [*c]SceMpeg, pBuffer: ScePVoid, iOffset: [*c]SceInt32) SceInt32;

// sceMpegQueryStreamSize
//
// @param pBuffer - pointer to file header
// @param iSize - will contain stream size in bytes
//
// @return 0 if success.
pub extern fn sceMpegQueryStreamSize(pBuffer: ScePVoid, iSize: [*c]SceInt32) SceInt32;

// sceMpegRegistStream
//
// @param Mpeg - SceMpeg handle
// @param iStreamID - stream id, 0 for video, 1 for audio
// @param iUnk - unknown, set to 0
//
// @return 0 if error.
pub extern fn sceMpegRegistStream(Mpeg: [*c]SceMpeg, iStreamID: SceInt32, iUnk: SceInt32) ?*SceMpegStream;

// sceMpegUnRegistStream
//
// @param Mpeg - SceMpeg handle
// @param pStream - pointer to stream
pub extern fn sceMpegUnRegistStream(Mpeg: SceMpeg, pStream: ?*SceMpegStream) SceVoid;

// sceMpegFlushAllStreams
//
// @return 0 if success.
pub extern fn sceMpegFlushAllStream(Mpeg: [*c]SceMpeg) SceInt32;

// sceMpegMallocAvcEsBuf
//
// @return 0 if error else pointer to buffer.
pub extern fn sceMpegMallocAvcEsBuf(Mpeg: [*c]SceMpeg) ScePVoid;

// sceMpegFreeAvcEsBuf
pub extern fn sceMpegFreeAvcEsBuf(Mpeg: [*c]SceMpeg, pBuf: ScePVoid) SceVoid;

// sceMpegQueryAtracEsSize
//
// @param Mpeg - SceMpeg handle
// @param iEsSize - will contain size of Es
// @param iOutSize - will contain size of decoded data
//
// @return 0 if success.
pub extern fn sceMpegQueryAtracEsSize(Mpeg: [*c]SceMpeg, iEsSize: [*c]SceInt32, iOutSize: [*c]SceInt32) SceInt32;

// sceMpegInitAu
//
// @param Mpeg - SceMpeg handle
// @param pEsBuffer - prevously allocated Es buffer
// @param pAu - will contain pointer to Au
//
// @return 0 if success.
pub extern fn sceMpegInitAu(Mpeg: [*c]SceMpeg, pEsBuffer: ScePVoid, pAu: [*c]SceMpegAu) SceInt32;

// sceMpegGetAvcAu
//
// @param Mpeg - SceMpeg handle
// @param pStream - associated stream
// @param pAu - will contain pointer to Au
// @param iUnk - unknown
//
// @return 0 if success.
pub extern fn sceMpegGetAvcAu(Mpeg: [*c]SceMpeg, pStream: ?*SceMpegStream, pAu: [*c]SceMpegAu, iUnk: [*c]SceInt32) SceInt32;

// sceMpegAvcDecodeMode
//
// @param Mpeg - SceMpeg handle
// @param pMode - pointer to SceMpegAvcMode struct defining the decode mode (pixelformat)
// @return 0 if success.
pub extern fn sceMpegAvcDecodeMode(Mpeg: [*c]SceMpeg, pMode: [*c]SceMpegAvcMode) SceInt32;

// sceMpegAvcDecode
//
// @param Mpeg - SceMpeg handle
// @param pAu - video Au
// @param iFrameWidth - output buffer width, set to 512 if writing to framebuffer
// @param pBuffer - buffer that will contain the decoded frame
// @param iInit - will be set to 0 on first call, then 1
//
// @return 0 if success.
pub extern fn sceMpegAvcDecode(Mpeg: [*c]SceMpeg, pAu: [*c]SceMpegAu, iFrameWidth: SceInt32, pBuffer: ScePVoid, iInit: [*c]SceInt32) SceInt32;

// sceMpegAvcDecodeStop
//
// @param Mpeg - SceMpeg handle
// @param iFrameWidth - output buffer width, set to 512 if writing to framebuffer
// @param pBuffer - buffer that will contain the decoded frame
// @param iStatus - frame number
//
// @return 0 if success.
pub extern fn sceMpegAvcDecodeStop(Mpeg: [*c]SceMpeg, iFrameWidth: SceInt32, pBuffer: ScePVoid, iStatus: [*c]SceInt32) SceInt32;

// sceMpegGetAtracAu
//
// @param Mpeg - SceMpeg handle
// @param pStream - associated stream
// @param pAu - will contain pointer to Au
// @param pUnk - unknown
//
// @return 0 if success.
pub extern fn sceMpegGetAtracAu(Mpeg: [*c]SceMpeg, pStream: ?*SceMpegStream, pAu: [*c]SceMpegAu, pUnk: ScePVoid) SceInt32;

// sceMpegAtracDecode
//
// @param Mpeg - SceMpeg handle
// @param pAu - video Au
// @param pBuffer - buffer that will contain the decoded frame
// @param iInit - set this to 1 on first call
//
// @return 0 if success.
pub extern fn sceMpegAtracDecode(Mpeg: [*c]SceMpeg, pAu: [*c]SceMpegAu, pBuffer: ScePVoid, iInit: SceInt32) SceInt32;
