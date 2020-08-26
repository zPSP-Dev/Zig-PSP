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

const macro = @import("pspmacros.zig");

comptime{
    asm(macro.import_module_start("sceMpegbase", "0x00090000", "9"));
    asm(macro.import_function("sceMpegbase", "0xBE45C284", "sceMpegBaseYCrCbCopyVme"));
    asm(macro.import_function("sceMpegbase", "0x492B5E4B", "sceMpegBaseCscInit"));
    asm(macro.import_function("sceMpegbase", "0xCE8EB837", "sceMpegBaseCscVme"));
    asm(macro.import_function("sceMpegbase", "0x0530BE4E", "sceMpegbase_0530BE4E"));
    asm(macro.import_function("sceMpegbase", "0x304882E1", "sceMpegbase_304882E1"));
    asm(macro.import_function("sceMpegbase", "0x7AC0321A", "sceMpegBaseYCrCbCopy"));
    asm(macro.import_function("sceMpegbase", "0x91929A21", "sceMpegBaseCscAvc"));
    asm(macro.import_function("sceMpegbase", "0xAC9E717E", "sceMpegbase_AC9E717E"));
    asm(macro.import_function("sceMpegbase", "0xBEA18F91", "sceMpegbase_BEA18F91"));
    
    asm(macro.import_module_start("sceMpeg", "0x00090000", "38"));
    asm(macro.import_function("sceMpeg", "0x21FF80E4", "sceMpegQueryStreamOffset"));
    asm(macro.import_function("sceMpeg", "0x611E9E11", "sceMpegQueryStreamSize"));
    asm(macro.import_function("sceMpeg", "0x682A619B", "sceMpegInit"));
    asm(macro.import_function("sceMpeg", "0x874624D6", "sceMpegFinish"));
    asm(macro.import_function("sceMpeg", "0xC132E22F", "sceMpegQueryMemSize"));
    asm(macro.import_function("sceMpeg", "0xD8C5F121", "sceMpegCreate_stub"));
    asm(macro.import_function("sceMpeg", "0x606A4649", "sceMpegDelete"));
    asm(macro.import_function("sceMpeg", "0x42560F23", "sceMpegRegistStream"));
    asm(macro.import_function("sceMpeg", "0x591A4AA2", "sceMpegUnRegistStream"));
    asm(macro.import_function("sceMpeg", "0xA780CF7E", "sceMpegMallocAvcEsBuf"));
    asm(macro.import_function("sceMpeg", "0xCEB870B1", "sceMpegFreeAvcEsBuf"));
    asm(macro.import_function("sceMpeg", "0xF8DCB679", "sceMpegQueryAtracEsSize"));
    asm(macro.import_function("sceMpeg", "0xC02CF6B5", "sceMpegQueryPcmEsSize"));
    asm(macro.import_function("sceMpeg", "0x167AFD9E", "sceMpegInitAu"));
    asm(macro.import_function("sceMpeg", "0x234586AE", "sceMpegChangeGetAvcAuMode"));
    asm(macro.import_function("sceMpeg", "0x9DCFB7EA", "sceMpegChangeGetAuMode"));
    asm(macro.import_function("sceMpeg", "0xFE246728", "sceMpegGetAvcAu"));
    asm(macro.import_function("sceMpeg", "0x8C1E027D", "sceMpegGetPcmAu"));
    asm(macro.import_function("sceMpeg", "0xE1CE83A7", "sceMpegGetAtracAu"));
    asm(macro.import_function("sceMpeg", "0x500F0429", "sceMpegFlushStream"));
    asm(macro.import_function("sceMpeg", "0x707B7629", "sceMpegFlushAllStream"));
    asm(macro.import_function("sceMpeg", "0x0E3C2E9D", "sceMpegAvcDecode_stub"));
    asm(macro.import_function("sceMpeg", "0x0F6C18D7", "sceMpegAvcDecodeDetail"));
    asm(macro.import_function("sceMpeg", "0xA11C7026", "sceMpegAvcDecodeMode"));
    asm(macro.import_function("sceMpeg", "0x740FCCD1", "sceMpegAvcDecodeStop"));
    asm(macro.import_function("sceMpeg", "0x800C44DF", "sceMpegAtracDecode"));
    asm(macro.import_function("sceMpeg", "0xD7A29F46", "sceMpegRingbufferQueryMemSize"));
    asm(macro.import_function("sceMpeg", "0x37295ED8", "sceMpegRingbufferConstruct_stub"));
    asm(macro.import_function("sceMpeg", "0x13407F13", "sceMpegRingbufferDestruct"));
    asm(macro.import_function("sceMpeg", "0xB240A59E", "sceMpegRingbufferPut"));
    asm(macro.import_function("sceMpeg", "0xB5F6DC87", "sceMpegRingbufferAvailableSize"));
    asm(macro.import_function("sceMpeg", "0x11CAB459", "sceMpeg_11CAB459"));
    asm(macro.import_function("sceMpeg", "0x3C37A7A6", "sceMpeg_3C37A7A6"));
    asm(macro.import_function("sceMpeg", "0xB27711A8", "sceMpeg_B27711A8"));
    asm(macro.import_function("sceMpeg", "0xD4DD6E75", "sceMpeg_D4DD6E75"));
    asm(macro.import_function("sceMpeg", "0xC345DED2", "sceMpeg_C345DED2"));
    asm(macro.import_function("sceMpeg", "0xCF3547A2", "sceMpegAvcDecodeDetail2"));
    asm(macro.import_function("sceMpeg", "0x988E9E12", "sceMpeg_988E9E12"));

    asm(macro.generic_abi_wrapper("sceMpegCreate", 7));
    asm(macro.generic_abi_wrapper("sceMpegRingbufferConstruct", 6));
    asm(macro.generic_abi_wrapper("sceMpegAvcDecode", 5));
}