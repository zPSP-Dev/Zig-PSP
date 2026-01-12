// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

pub extern fn sceSslGetNameEntryCount() callconv(.c) void;

/// Get the current memory size used by ssl.
/// `memory` - Pointer where the current memory used value will be stored.
/// Returns 0 on success
pub extern fn sceSslGetUsedMemoryCurrent(memory: [*c]c_uint) callconv(.c) c_int;

pub extern fn sceSslGetNotBefore() callconv(.c) void;

/// Terminate the ssl library.
/// Returns 0 on success
pub extern fn sceSslEnd() callconv(.c) c_int;

pub extern fn sceSslGetIssuerName() callconv(.c) void;

pub extern fn sceSslGetSubjectName() callconv(.c) void;

pub extern fn sceSslGetNotAfter() callconv(.c) void;

/// Init the ssl library.
/// `unknown1` - Memory size? Pass 0x28000
/// Returns 0 on success
pub extern fn sceSslInit(unknown1: c_int) callconv(.c) c_int;

/// Get the maximum memory size used by ssl.
/// `memory` - Pointer where the maximum memory used value will be stored.
/// Returns 0 on success
pub extern fn sceSslGetUsedMemoryMax(memory: [*c]c_uint) callconv(.c) c_int;

pub extern fn sceSslGetSerialNumber() callconv(.c) void;

pub extern fn sceSslGetNameEntryInfo() callconv(.c) void;

comptime {
    asm (macro.import_module_start("sceSsl", "0x00090011", "11"));
    asm (macro.import_function("sceSsl", "0x058D21C0", "sceSslGetNameEntryCount"));
    asm (macro.import_function("sceSsl", "0x0EB43B06", "sceSslGetUsedMemoryCurrent"));
    asm (macro.import_function("sceSsl", "0x17A10DCC", "sceSslGetNotBefore"));
    asm (macro.import_function("sceSsl", "0x191CDEFF", "sceSslEnd"));
    asm (macro.import_function("sceSsl", "0x1B7C8191", "sceSslGetIssuerName"));
    asm (macro.import_function("sceSsl", "0x3DD5E023", "sceSslGetSubjectName"));
    asm (macro.import_function("sceSsl", "0x5BFB6B61", "sceSslGetNotAfter"));
    asm (macro.import_function("sceSsl", "0x957ECBE2", "sceSslInit"));
    asm (macro.import_function("sceSsl", "0xB99EDE6A", "sceSslGetUsedMemoryMax"));
    asm (macro.import_function("sceSsl", "0xCC0919B0", "sceSslGetSerialNumber"));
    asm (macro.import_function("sceSsl", "0xD6D097B4", "sceSslGetNameEntryInfo"));
}
