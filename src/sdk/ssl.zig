// SSL -- certificate management
//
// Wraps:
//   c/module/sceSsl.zig

const c = @import("../c/modules.zig");
const err = @import("errors/ssl.zig");
const check = err.check;
const Error = err.Error;

const ssl = c.sceSsl;

pub fn init(mem_size: i32) Error!void {
    return check(ssl.sceSslInit(@as(c_int, mem_size)));
}

pub fn end() Error!void {
    return check(ssl.sceSslEnd());
}

pub fn get_used_memory_max(memory: *u32) Error!void {
    return check(ssl.sceSslGetUsedMemoryMax(@ptrCast(memory)));
}

pub fn get_used_memory_current(memory: *u32) Error!void {
    return check(ssl.sceSslGetUsedMemoryCurrent(@ptrCast(memory)));
}

// Undocumented stubs
pub const get_name_entry_count = ssl.sceSslGetNameEntryCount;
pub const get_not_before = ssl.sceSslGetNotBefore;
pub const get_not_after = ssl.sceSslGetNotAfter;
pub const get_issuer_name = ssl.sceSslGetIssuerName;
pub const get_subject_name = ssl.sceSslGetSubjectName;
pub const get_serial_number = ssl.sceSslGetSerialNumber;
pub const get_name_entry_info = ssl.sceSslGetNameEntryInfo;
