// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// sceMpegQueryStreamOffset
/// `Mpeg` - SceMpeg handle
/// `pBuffer` - pointer to file header
/// `iOffset` - will contain stream offset in bytes, usually 2048
/// Returns 0 if success.
pub extern fn sceMpegQueryStreamOffset(Mpeg: [*c]c_int, pBuffer: types.ScePVoid, iOffset: [*c]types.SceInt32) callconv(.c) types.SceInt32;

/// sceMpegQueryStreamSize
/// `pBuffer` - pointer to file header
/// `iSize` - will contain stream size in bytes
/// Returns 0 if success.
pub extern fn sceMpegQueryStreamSize(pBuffer: types.ScePVoid, iSize: [*c]types.SceInt32) callconv(.c) types.SceInt32;

/// sceMpegInit
/// Returns 0 if success.
pub extern fn sceMpegInit() callconv(.c) types.SceInt32;

/// sceMpegFinish
pub extern fn sceMpegFinish() callconv(.c) types.SceVoid;

/// sceMpegQueryMemSize
/// `iUnk` - Unknown, set to 0
/// Returns < 0 if error else decoder data size.
pub extern fn sceMpegQueryMemSize(iUnk: c_int) callconv(.c) types.SceInt32;

/// sceMpegCreate
/// `Mpeg` - will be filled
/// `pData` - pointer to allocated memory of size = sceMpegQueryMemSize()
/// `iSize` - size of data, should be = sceMpegQueryMemSize()
/// `Ringbuffer` - a ringbuffer
/// `iFrameWidth` - display buffer width, set to 512 if writing to framebuffer
/// `iUnk1` - unknown, set to 0
/// `iUnk2` - unknown, set to 0
/// Returns 0 if success.
pub extern fn sceMpegCreate(Mpeg: [*c]c_int, pData: types.ScePVoid, iSize: types.SceInt32, Ringbuffer: [*c]c_int, iFrameWidth: types.SceInt32, iUnk1: types.SceInt32, iUnk2: types.SceInt32) callconv(.c) types.SceInt32;

/// sceMpegDelete
/// `Mpeg` - SceMpeg handle
pub extern fn sceMpegDelete(Mpeg: [*c]c_int) callconv(.c) types.SceVoid;

/// sceMpegRegistStream
/// `Mpeg` - SceMpeg handle
/// `iStreamID` - stream id, 0 for video, 1 for audio
/// `iUnk` - unknown, set to 0
/// Returns 0 if error.
pub extern fn sceMpegRegistStream(Mpeg: [*c]c_int, iStreamID: types.SceInt32, iUnk: types.SceInt32) callconv(.c) [*c]c_int;

/// sceMpegUnRegistStream
/// `Mpeg` - SceMpeg handle
/// `pStream` - pointer to stream
pub extern fn sceMpegUnRegistStream(Mpeg: c_int, pStream: [*c]c_int) callconv(.c) types.SceVoid;

/// sceMpegMallocAvcEsBuf
/// Returns 0 if error else pointer to buffer.
pub extern fn sceMpegMallocAvcEsBuf(Mpeg: [*c]c_int) callconv(.c) types.ScePVoid;

/// sceMpegFreeAvcEsBuf
pub extern fn sceMpegFreeAvcEsBuf(Mpeg: [*c]c_int, pBuf: types.ScePVoid) callconv(.c) types.SceVoid;

/// sceMpegQueryAtracEsSize
/// `Mpeg` - SceMpeg handle
/// `iEsSize` - will contain size of Es
/// `iOutSize` - will contain size of decoded data
/// Returns 0 if success.
pub extern fn sceMpegQueryAtracEsSize(Mpeg: [*c]c_int, iEsSize: [*c]types.SceInt32, iOutSize: [*c]types.SceInt32) callconv(.c) types.SceInt32;

pub extern fn sceMpegQueryPcmEsSize() callconv(.c) void;

/// sceMpegInitAu
/// `Mpeg` - SceMpeg handle
/// `pEsBuffer` - prevously allocated Es buffer
/// `pAu` - will contain pointer to Au
/// Returns 0 if success.
pub extern fn sceMpegInitAu(Mpeg: [*c]c_int, pEsBuffer: types.ScePVoid, pAu: [*c]c_int) callconv(.c) types.SceInt32;

pub extern fn sceMpegChangeGetAvcAuMode() callconv(.c) void;

pub extern fn sceMpegChangeGetAuMode() callconv(.c) void;

/// sceMpegGetAvcAu
/// `Mpeg` - SceMpeg handle
/// `pStream` - associated stream
/// `pAu` - will contain pointer to Au
/// `iUnk` - unknown
/// Returns 0 if success.
pub extern fn sceMpegGetAvcAu(Mpeg: [*c]c_int, pStream: [*c]c_int, pAu: [*c]c_int, iUnk: [*c]types.SceInt32) callconv(.c) types.SceInt32;

pub extern fn sceMpegGetPcmAu() callconv(.c) void;

/// sceMpegGetAtracAu
/// `Mpeg` - SceMpeg handle
/// `pStream` - associated stream
/// `pAu` - will contain pointer to Au
/// `pUnk` - unknown
/// Returns 0 if success.
pub extern fn sceMpegGetAtracAu(Mpeg: [*c]c_int, pStream: [*c]c_int, pAu: [*c]c_int, pUnk: types.ScePVoid) callconv(.c) types.SceInt32;

pub extern fn sceMpegFlushStream() callconv(.c) void;

/// sceMpegFlushAllStreams
/// Returns 0 if success.
pub extern fn sceMpegFlushAllStream(Mpeg: [*c]c_int) callconv(.c) types.SceInt32;

/// sceMpegAvcDecode
/// `Mpeg` - SceMpeg handle
/// `pAu` - video Au
/// `iFrameWidth` - output buffer width, set to 512 if writing to framebuffer
/// `pBuffer` - buffer that will contain the decoded frame
/// `iInit` - will be set to 0 on first call, then 1
/// Returns 0 if success.
/// sceMpegAvcDecodeMode
/// `Mpeg` - SceMpeg handle
/// `pMode` - pointer to SceMpegAvcMode struct defining the decode mode (pixelformat)
/// Returns 0 if success.
pub extern fn sceMpegAvcDecode(Mpeg: [*c]c_int, pAu: [*c]c_int, iFrameWidth: types.SceInt32, pBuffer: types.ScePVoid, iInit: [*c]types.SceInt32) callconv(.c) types.SceInt32;

pub extern fn sceMpegAvcDecodeDetail() callconv(.c) void;

/// sceMpegAvcDecodeMode
/// `Mpeg` - SceMpeg handle
/// `pMode` - pointer to SceMpegAvcMode struct defining the decode mode (pixelformat)
/// Returns 0 if success.
pub extern fn sceMpegAvcDecodeMode(Mpeg: [*c]c_int, pMode: [*c]c_int) callconv(.c) types.SceInt32;

/// sceMpegAvcDecodeStop
/// `Mpeg` - SceMpeg handle
/// `iFrameWidth` - output buffer width, set to 512 if writing to framebuffer
/// `pBuffer` - buffer that will contain the decoded frame
/// `iStatus` - frame number
/// Returns 0 if success.
pub extern fn sceMpegAvcDecodeStop(Mpeg: [*c]c_int, iFrameWidth: types.SceInt32, pBuffer: types.ScePVoid, iStatus: [*c]types.SceInt32) callconv(.c) types.SceInt32;

/// sceMpegAtracDecode
/// `Mpeg` - SceMpeg handle
/// `pAu` - video Au
/// `pBuffer` - buffer that will contain the decoded frame
/// `iInit` - set this to 1 on first call
/// Returns 0 if success.
pub extern fn sceMpegAtracDecode(Mpeg: [*c]c_int, pAu: [*c]c_int, pBuffer: types.ScePVoid, iInit: types.SceInt32) callconv(.c) types.SceInt32;

/// sceMpegRingbufferQueryMemSize
/// `iPackets` - number of packets in the ringbuffer
/// Returns < 0 if error else ringbuffer data size.
pub extern fn sceMpegRingbufferQueryMemSize(iPackets: types.SceInt32) callconv(.c) types.SceInt32;

/// sceMpegRingbufferConstruct
/// `Ringbuffer` - pointer to a sceMpegRingbuffer struct
/// `iPackets` - number of packets in the ringbuffer
/// `pData` - pointer to allocated memory
/// `iSize` - size of allocated memory, shoud be sceMpegRingbufferQueryMemSize(iPackets)
/// `Callback` - ringbuffer callback
/// `pCBparam` - param passed to callback
/// Returns 0 if success.
pub extern fn sceMpegRingbufferConstruct(Ringbuffer: [*c]c_int, iPackets: types.SceInt32, pData: types.ScePVoid, iSize: types.SceInt32, Callback: c_int, pCBparam: types.ScePVoid) callconv(.c) types.SceInt32;

/// sceMpegRingbufferDestruct
/// `Ringbuffer` - pointer to a sceMpegRingbuffer struct
pub extern fn sceMpegRingbufferDestruct(Ringbuffer: [*c]c_int) callconv(.c) types.SceVoid;

/// sceMpegRingbufferPut
/// `Ringbuffer` - pointer to a sceMpegRingbuffer struct
/// `iNumPackets` - num packets to put into the ringbuffer
/// `iAvailable` - free packets in the ringbuffer, should be sceMpegRingbufferAvailableSize()
/// Returns < 0 if error else number of packets.
pub extern fn sceMpegRingbufferPut(Ringbuffer: [*c]c_int, iNumPackets: types.SceInt32, iAvailable: types.SceInt32) callconv(.c) types.SceInt32;

/// sceMpegQueryMemSize
/// `Ringbuffer` - pointer to a sceMpegRingbuffer struct
/// Returns < 0 if error else number of free packets in the ringbuffer.
pub extern fn sceMpegRingbufferAvailableSize(Ringbuffer: [*c]c_int) callconv(.c) types.SceInt32;

pub extern fn sceMpeg_11CAB459() callconv(.c) void;

pub extern fn sceMpeg_3C37A7A6() callconv(.c) void;

pub extern fn sceMpeg_B27711A8() callconv(.c) void;

pub extern fn sceMpeg_D4DD6E75() callconv(.c) void;

pub extern fn sceMpeg_C345DED2() callconv(.c) void;

pub extern fn sceMpegAvcDecodeDetail2() callconv(.c) void;

pub extern fn sceMpeg_988E9E12() callconv(.c) void;

comptime {
    asm (macro.import_module_start("sceMpeg", "0x00090000", "38"));
    asm (macro.import_function("sceMpeg", "0x21FF80E4", "sceMpegQueryStreamOffset"));
    asm (macro.import_function("sceMpeg", "0x611E9E11", "sceMpegQueryStreamSize"));
    asm (macro.import_function("sceMpeg", "0x682A619B", "sceMpegInit"));
    asm (macro.import_function("sceMpeg", "0x874624D6", "sceMpegFinish"));
    asm (macro.import_function("sceMpeg", "0xC132E22F", "sceMpegQueryMemSize"));
    asm (macro.import_function("sceMpeg", "0xD8C5F121", "sceMpegCreate_stub"));
    asm (macro.generic_abi_wrapper("sceMpegCreate", 7));
    asm (macro.import_function("sceMpeg", "0x606A4649", "sceMpegDelete"));
    asm (macro.import_function("sceMpeg", "0x42560F23", "sceMpegRegistStream"));
    asm (macro.import_function("sceMpeg", "0x591A4AA2", "sceMpegUnRegistStream"));
    asm (macro.import_function("sceMpeg", "0xA780CF7E", "sceMpegMallocAvcEsBuf"));
    asm (macro.import_function("sceMpeg", "0xCEB870B1", "sceMpegFreeAvcEsBuf"));
    asm (macro.import_function("sceMpeg", "0xF8DCB679", "sceMpegQueryAtracEsSize"));
    asm (macro.import_function("sceMpeg", "0xC02CF6B5", "sceMpegQueryPcmEsSize"));
    asm (macro.import_function("sceMpeg", "0x167AFD9E", "sceMpegInitAu"));
    asm (macro.import_function("sceMpeg", "0x234586AE", "sceMpegChangeGetAvcAuMode"));
    asm (macro.import_function("sceMpeg", "0x9DCFB7EA", "sceMpegChangeGetAuMode"));
    asm (macro.import_function("sceMpeg", "0xFE246728", "sceMpegGetAvcAu"));
    asm (macro.import_function("sceMpeg", "0x8C1E027D", "sceMpegGetPcmAu"));
    asm (macro.import_function("sceMpeg", "0xE1CE83A7", "sceMpegGetAtracAu"));
    asm (macro.import_function("sceMpeg", "0x500F0429", "sceMpegFlushStream"));
    asm (macro.import_function("sceMpeg", "0x707B7629", "sceMpegFlushAllStream"));
    asm (macro.import_function("sceMpeg", "0x0E3C2E9D", "sceMpegAvcDecode_stub"));
    asm (macro.generic_abi_wrapper("sceMpegAvcDecode", 5));
    asm (macro.import_function("sceMpeg", "0x0F6C18D7", "sceMpegAvcDecodeDetail"));
    asm (macro.import_function("sceMpeg", "0xA11C7026", "sceMpegAvcDecodeMode"));
    asm (macro.import_function("sceMpeg", "0x740FCCD1", "sceMpegAvcDecodeStop"));
    asm (macro.import_function("sceMpeg", "0x800C44DF", "sceMpegAtracDecode"));
    asm (macro.import_function("sceMpeg", "0xD7A29F46", "sceMpegRingbufferQueryMemSize"));
    asm (macro.import_function("sceMpeg", "0x37295ED8", "sceMpegRingbufferConstruct_stub"));
    asm (macro.generic_abi_wrapper("sceMpegRingbufferConstruct", 6));
    asm (macro.import_function("sceMpeg", "0x13407F13", "sceMpegRingbufferDestruct"));
    asm (macro.import_function("sceMpeg", "0xB240A59E", "sceMpegRingbufferPut"));
    asm (macro.import_function("sceMpeg", "0xB5F6DC87", "sceMpegRingbufferAvailableSize"));
    asm (macro.import_function("sceMpeg", "0x11CAB459", "sceMpeg_11CAB459"));
    asm (macro.import_function("sceMpeg", "0x3C37A7A6", "sceMpeg_3C37A7A6"));
    asm (macro.import_function("sceMpeg", "0xB27711A8", "sceMpeg_B27711A8"));
    asm (macro.import_function("sceMpeg", "0xD4DD6E75", "sceMpeg_D4DD6E75"));
    asm (macro.import_function("sceMpeg", "0xC345DED2", "sceMpeg_C345DED2"));
    asm (macro.import_function("sceMpeg", "0xCF3547A2", "sceMpegAvcDecodeDetail2"));
    asm (macro.import_function("sceMpeg", "0x988E9E12", "sceMpeg_988E9E12"));
}
