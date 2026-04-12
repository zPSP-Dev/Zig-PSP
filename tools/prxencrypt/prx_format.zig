// See also: https://www.psdevwiki.com/psp/PRX_File_Format
// Note that the struct layout is incomplete.
// There has been some work from Linblow that improve on this, but it's not integrated here.

const std = @import("std");

// All of those can be found in a PRX file
pub const ELF_MAGIC = "\x7fELF"; // Normally means not encrypted
pub const PSP_MAGIC = "~PSP"; // Encrypted PRX header
pub const SCE_MAGIC = "~SCE"; // Normally followed by a ~PSP header

// ~PSP encrypted PRX header
pub const PSPHeader = extern struct {
    const SCE_KERNEL_MAX_MODULE_SEGMENT = 4;
    const SCE_MODULE_NAME_LEN = 27;

    magic: [4]u8, //0
    modAttribute: u16, //4 The module's attributes. One or more of ::SceModulePrivilegeLevel. */
    compression_attributes: enum(u16) {
        NONE = 0x0, // The file is not compressed
        COMPRESSED = 0x1, // The file is compressed. If SCE_EXEC_FILE_KL4E_COMPRESSED is not set, the file is GZIP compressed. */
        PRX = 0x2, // The file is a static PRX. */
        GZIP_OVERLAP = 0x8, // The file has GZIP overlap. */
        KL4E_COMPRESSED = 0x200, // The file is KL4E compressed. */
    }, // The Compression attributes of the module. One of ::SceExecFileAttr. */
    moduleVerLo: u8, //8 The minor module version. */
    moduleVerHi: u8, //9 The major module version. */
    modName: [SCE_MODULE_NAME_LEN + 1]u8, //10 The module's name. */
    modVersion: u8, //38 Module version. */
    nSegments: u8, //39 The number of segment the module consists of. */
    prx_size: u32, //40 The size of the uncompressed and decrypted module. */
    psp_size: u32, //44 The size of the compressed/encrypted module. */
    boot_entry: u32, //48 The entry address of the module. It is the offset from the start of the TEXT segment to the program's entry point. */
    mod_info_offset: u32, //52 The offset from the start address of the TEXT segment to the SceModuleInfo section. */
    bssSize: u32, //56 The size of the BSS segment. */
    segAlign: [SCE_KERNEL_MAX_MODULE_SEGMENT]u16, //60 An array containing the alignment information of each segment. */
    segAddress: [SCE_KERNEL_MAX_MODULE_SEGMENT]u32, //68 An array containing the start address of each segment. */
    segSize: [SCE_KERNEL_MAX_MODULE_SEGMENT]u32, //84 An array containing the size of each segment. */
    reserved: [5]u32, //100 Reserved. */
    devkitVersion: u32, //120 The development kit version the module was compiled with. */
    decryptMode: u8, //124 The decryption mode. One of ::SceExecFileDecryptMode. */
    padding: u8, //125 Reserved. */
    overlapSize: u16, //126 The overlap size. */
};

pub const PSPFullHeader = extern struct {
    const AES_KEY_SIZE = 16;
    const CMAC_KEY_SIZE = 16;
    const CMAC_HEADER_HASH_SIZE = 16;
    const CMAC_DATA_HASH_SIZE = 16;
    const SHA1_HASH_SIZE = 20;
    const KEY_DATA_SIZE = 16;
    const CHECK_SIZE = 88;

    psp_header: PSPHeader,
    aesKey: [AES_KEY_SIZE]u8, //128 The AES key data. */
    cmacKey: [CMAC_KEY_SIZE]u8, //144 THE CMAC key data. */
    cmacHeaderHash: [CMAC_HEADER_HASH_SIZE]u8, //160 The CMAC header hash. */
    compSize: u32, //176 The size of the compressed PRX. */
    unk180: u32, //180 Unknown. */
    unk184: u32, //184 Unknown. */
    unk188: u32, //188 Unknown. */
    cmacDataHash: [CMAC_DATA_HASH_SIZE]u8, //192 The CMAC Data hash. */
    tag: u32, //208 Tag value. */
    sCheck: [CHECK_SIZE]u8, //212 Check. */
    sha1Hash: [SHA1_HASH_SIZE]u8, //300 The SHA-1 hash. */
    keyData4: [KEY_DATA_SIZE]u8, //320 Key data. */
};

comptime {
    std.debug.assert(@sizeOf(PSPHeader) == 0x80);
    std.debug.assert(@sizeOf(PSPFullHeader) == 0x150);
}
