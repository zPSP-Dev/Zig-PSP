const macro = @import("pspmacros.zig");

comptime {
    asm (macro.import_module_start("sceMpegbase", "0x00090000", "9"));
    asm (macro.import_function("sceMpegbase", "0xBE45C284", "sceMpegBaseYCrCbCopyVme"));
    asm (macro.import_function("sceMpegbase", "0x492B5E4B", "sceMpegBaseCscInit"));
    asm (macro.import_function("sceMpegbase", "0xCE8EB837", "sceMpegBaseCscVme"));
    asm (macro.import_function("sceMpegbase", "0x0530BE4E", "sceMpegbase_0530BE4E"));
    asm (macro.import_function("sceMpegbase", "0x304882E1", "sceMpegbase_304882E1"));
    asm (macro.import_function("sceMpegbase", "0x7AC0321A", "sceMpegBaseYCrCbCopy"));
    asm (macro.import_function("sceMpegbase", "0x91929A21", "sceMpegBaseCscAvc"));
    asm (macro.import_function("sceMpegbase", "0xAC9E717E", "sceMpegbase_AC9E717E"));
    asm (macro.import_function("sceMpegbase", "0xBEA18F91", "sceMpegbase_BEA18F91"));

    asm (macro.import_module_start("sceMpeg", "0x00090000", "38"));
    asm (macro.import_function("sceMpeg", "0x21FF80E4", "sceMpegQueryStreamOffset"));
    asm (macro.import_function("sceMpeg", "0x611E9E11", "sceMpegQueryStreamSize"));
    asm (macro.import_function("sceMpeg", "0x682A619B", "sceMpegInit"));
    asm (macro.import_function("sceMpeg", "0x874624D6", "sceMpegFinish"));
    asm (macro.import_function("sceMpeg", "0xC132E22F", "sceMpegQueryMemSize"));
    asm (macro.import_function("sceMpeg", "0xD8C5F121", "sceMpegCreate_stub"));
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
    asm (macro.import_function("sceMpeg", "0x0F6C18D7", "sceMpegAvcDecodeDetail"));
    asm (macro.import_function("sceMpeg", "0xA11C7026", "sceMpegAvcDecodeMode"));
    asm (macro.import_function("sceMpeg", "0x740FCCD1", "sceMpegAvcDecodeStop"));
    asm (macro.import_function("sceMpeg", "0x800C44DF", "sceMpegAtracDecode"));
    asm (macro.import_function("sceMpeg", "0xD7A29F46", "sceMpegRingbufferQueryMemSize"));
    asm (macro.import_function("sceMpeg", "0x37295ED8", "sceMpegRingbufferConstruct_stub"));
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

    asm (macro.generic_abi_wrapper("sceMpegCreate", 7));
    asm (macro.generic_abi_wrapper("sceMpegRingbufferConstruct", 6));
    asm (macro.generic_abi_wrapper("sceMpegAvcDecode", 5));
}
