usingnamespace @import("psptypes.zig");

pub const clock_t = u32;
pub const suseconds_t = u32;
pub const struct_timeval = extern struct {
    tv_sec: time_t,
    tv_usec: suseconds_t,
};
pub const struct_timezone = extern struct {
    tz_minuteswest: c_int,
    tz_dsttime: c_int,
};
pub extern fn sceKernelLibcTime(t: [*c]time_t) time_t;
pub extern fn sceKernelLibcClock() clock_t;
pub extern fn sceKernelLibcGettimeofday(tp: [*c]struct_timeval, tzp: [*c]struct_timezone) c_int;
pub extern fn sceKernelDcacheWritebackAll() void;
pub extern fn sceKernelDcacheWritebackInvalidateAll() void;
pub extern fn sceKernelDcacheWritebackRange(p: ?*const c_void, size: c_uint) void;
pub extern fn sceKernelDcacheWritebackInvalidateRange(p: ?*const c_void, size: c_uint) void;
pub extern fn sceKernelDcacheInvalidateRange(p: ?*const c_void, size: c_uint) void;
pub extern fn sceKernelIcacheInvalidateAll() void;
pub extern fn sceKernelIcacheInvalidateRange(p: ?*const c_void, size: c_uint) void;
pub const struct__SceKernelUtilsMt19937Context = extern struct {
    count: c_uint,
    state: [624]c_uint,
};
pub const SceKernelUtilsMt19937Context = struct__SceKernelUtilsMt19937Context;
pub extern fn sceKernelUtilsMt19937Init(ctx: [*c]SceKernelUtilsMt19937Context, seed: u32) c_int;
pub extern fn sceKernelUtilsMt19937UInt(ctx: [*c]SceKernelUtilsMt19937Context) u32;
pub const struct__SceKernelUtilsMd5Context = extern struct {
    h: [4]c_uint,
    pad: c_uint,
    usRemains: SceUShort16,
    usComputed: SceUShort16,
    ullTotalLen: SceULong64,
    buf: [64]u8,
};
pub const SceKernelUtilsMd5Context = struct__SceKernelUtilsMd5Context;
pub extern fn sceKernelUtilsMd5Digest(data: [*c]u8, size: u32, digest: [*c]u8) c_int;
pub extern fn sceKernelUtilsMd5BlockInit(ctx: [*c]SceKernelUtilsMd5Context) c_int;
pub extern fn sceKernelUtilsMd5BlockUpdate(ctx: [*c]SceKernelUtilsMd5Context, data: [*c]u8, size: u32) c_int;
pub extern fn sceKernelUtilsMd5BlockResult(ctx: [*c]SceKernelUtilsMd5Context, digest: [*c]u8) c_int;
pub const struct__SceKernelUtilsSha1Context = extern struct {
    h: [5]c_uint,
    usRemains: SceUShort16,
    usComputed: SceUShort16,
    ullTotalLen: SceULong64,
    buf: [64]u8,
};
pub const SceKernelUtilsSha1Context = struct__SceKernelUtilsSha1Context;
pub extern fn sceKernelUtilsSha1Digest(data: [*c]u8, size: u32, digest: [*c]u8) c_int;
pub extern fn sceKernelUtilsSha1BlockInit(ctx: [*c]SceKernelUtilsSha1Context) c_int;
pub extern fn sceKernelUtilsSha1BlockUpdate(ctx: [*c]SceKernelUtilsSha1Context, data: [*c]u8, size: u32) c_int;
pub extern fn sceKernelUtilsSha1BlockResult(ctx: [*c]SceKernelUtilsSha1Context, digest: [*c]u8) c_int;
pub const timeval = struct_timeval;
pub const timezone = struct_timezone;
pub const _SceKernelUtilsMt19937Context = struct__SceKernelUtilsMt19937Context;
pub const _SceKernelUtilsMd5Context = struct__SceKernelUtilsMd5Context;
pub const _SceKernelUtilsSha1Context = struct__SceKernelUtilsSha1Context;

const macro = @import("pspmacros.zig");

comptime{
    asm(macro.import_module_start("UtilsForUser", "0x40010000", "26"));
    asm(macro.import_function("UtilsForUser", "0xBFA98062", "sceKernelDcacheInvalidateRange"));
    asm(macro.import_function("UtilsForUser", "0xC8186A58", "sceKernelUtilsMd5Digest"));
    asm(macro.import_function("UtilsForUser", "0x9E5C5086", "sceKernelUtilsMd5BlockInit"));
    asm(macro.import_function("UtilsForUser", "0x61E1E525", "sceKernelUtilsMd5BlockUpdate"));
    asm(macro.import_function("UtilsForUser", "0xB8D24E78", "sceKernelUtilsMd5BlockResult"));
    asm(macro.import_function("UtilsForUser", "0x840259F1", "sceKernelUtilsSha1Digest"));
    asm(macro.import_function("UtilsForUser", "0xF8FCD5BA", "sceKernelUtilsSha1BlockInit"));
    asm(macro.import_function("UtilsForUser", "0x346F6DA8", "sceKernelUtilsSha1BlockUpdate"));
    asm(macro.import_function("UtilsForUser", "0x585F1C09", "sceKernelUtilsSha1BlockResult"));
    asm(macro.import_function("UtilsForUser", "0xE860E75E", "sceKernelUtilsMt19937Init"));
    asm(macro.import_function("UtilsForUser", "0x06FB8A63", "sceKernelUtilsMt19937UInt"));
    asm(macro.import_function("UtilsForUser", "0x37FB5C42", "sceKernelGetGPI"));
    asm(macro.import_function("UtilsForUser", "0x6AD345D7", "sceKernelSetGPO"));
    asm(macro.import_function("UtilsForUser", "0x91E4F6A7", "sceKernelLibcClock"));
    asm(macro.import_function("UtilsForUser", "0x27CC57F0", "sceKernelLibcTime"));
    asm(macro.import_function("UtilsForUser", "0x71EC4271", "sceKernelLibcGettimeofday"));
    asm(macro.import_function("UtilsForUser", "0x79D1C3FA", "sceKernelDcacheWritebackAll"));
    asm(macro.import_function("UtilsForUser", "0xB435DEC5", "sceKernelDcacheWritebackInvalidateAll"));
    asm(macro.import_function("UtilsForUser", "0x3EE30821", "sceKernelDcacheWritebackRange"));
    asm(macro.import_function("UtilsForUser", "0x34B9FA9E", "sceKernelDcacheWritebackInvalidateRange"));
    asm(macro.import_function("UtilsForUser", "0x80001C4C", "sceKernelDcacheProbe"));
    asm(macro.import_function("UtilsForUser", "0x16641D70", "sceKernelDcacheReadTag"));
    asm(macro.import_function("UtilsForUser", "0x4FD31C9D", "sceKernelIcacheProbe"));
    asm(macro.import_function("UtilsForUser", "0xFB05FAD0", "sceKernelIcacheReadTag"));
    asm(macro.import_function("UtilsForUser", "0x920F104A", "sceKernelIcacheInvalidateAll"));
    asm(macro.import_function("UtilsForUser", "0xC2DF770E", "sceKernelIcacheInvalidateRange"));
}