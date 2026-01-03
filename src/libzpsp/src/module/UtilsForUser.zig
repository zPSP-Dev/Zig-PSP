// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Invalidate a range of addresses in data cache
pub extern fn sceKernelDcacheInvalidateRange(p: ?*const anyopaque, size: c_uint) callconv(.c) void;

/// Function to perform an MD5 digest of a data block.
/// `data` - Pointer to a data block to make a digest of.
/// `size` - Size of the data block.
/// `digest` - Pointer to a 16byte buffer to store the resulting digest
/// Returns < 0 on error.
pub extern fn sceKernelUtilsMd5Digest(data: [*c]u8, size: u32, digest: [*c]u8) callconv(.c) c_int;

/// Function to initialise a MD5 digest context
/// `ctx` - A context block to initialise
/// Returns < 0 on error.
/// @par Example:
/// `
/// SceKernelUtilsMd5Context ctx;
/// u8 digest[16];
/// sceKernelUtilsMd5BlockInit(&ctx);
/// sceKernelUtilsMd5BlockUpdate(&ctx, (u8*) "Hello", 5);
/// sceKernelUtilsMd5BlockResult(&ctx, digest);
/// `
pub extern fn sceKernelUtilsMd5BlockInit(ctx: [*c]types.SceKernelUtilsMd5Context) callconv(.c) c_int;

/// Function to update the MD5 digest with a block of data.
/// `ctx` - A filled in context block.
/// `data` - The data block to hash.
/// `size` - The size of the data to hash
/// Returns < 0 on error.
pub extern fn sceKernelUtilsMd5BlockUpdate(ctx: [*c]types.SceKernelUtilsMd5Context, data: [*c]u8, size: u32) callconv(.c) c_int;

/// Function to get the digest result of the MD5 hash.
/// `ctx` - A filled in context block.
/// `digest` - A 16 byte array to hold the digest.
/// Returns < 0 on error.
pub extern fn sceKernelUtilsMd5BlockResult(ctx: [*c]types.SceKernelUtilsMd5Context, digest: [*c]u8) callconv(.c) c_int;

/// Function to SHA1 hash a data block.
/// `data` - The data to hash.
/// `size` - The size of the data.
/// `digest` - Pointer to a 20 byte array for storing the digest
/// Returns < 0 on error.
pub extern fn sceKernelUtilsSha1Digest(data: [*c]u8, size: u32, digest: [*c]u8) callconv(.c) c_int;

/// Function to initialise a context for SHA1 hashing.
/// `ctx` - Pointer to a context.
/// Returns < 0 on error.
/// @par Example:
/// `
/// SceKernelUtilsSha1Context ctx;
/// u8 digest[20];
/// sceKernelUtilsSha1BlockInit(&ctx);
/// sceKernelUtilsSha1BlockUpdate(&ctx, (u8*) "Hello", 5);
/// sceKernelUtilsSha1BlockResult(&ctx, digest);
/// `
pub extern fn sceKernelUtilsSha1BlockInit(ctx: [*c]types.SceKernelUtilsSha1Context) callconv(.c) c_int;

/// Function to update the current hash.
/// `ctx` - Pointer to a prefilled context.
/// `data` - The data block to hash.
/// `size` - The size of the data block
/// Returns < 0 on error.
pub extern fn sceKernelUtilsSha1BlockUpdate(ctx: [*c]types.SceKernelUtilsSha1Context, data: [*c]u8, size: u32) callconv(.c) c_int;

/// Function to get the result of the SHA1 hash.
/// `ctx` - Pointer to a prefilled context.
/// `digest` - A pointer to a 20 byte array to contain the digest.
/// Returns < 0 on error.
pub extern fn sceKernelUtilsSha1BlockResult(ctx: [*c]types.SceKernelUtilsSha1Context, digest: [*c]u8) callconv(.c) c_int;

/// Function to initialise a mersenne twister context.
/// `ctx` - Pointer to a context
/// `seed` - A seed for the random function.
/// @par Example:
/// `
/// SceKernelUtilsMt19937Context ctx;
/// sceKernelUtilsMt19937Init(&ctx, time(NULL));
/// u23 rand_val = sceKernelUtilsMt19937UInt(&ctx);
/// `
/// Returns < 0 on error.
pub extern fn sceKernelUtilsMt19937Init(ctx: [*c]types.SceKernelUtilsMt19937Context, seed: u32) callconv(.c) c_int;

/// Function to return a new psuedo random number.
/// `ctx` - Pointer to a pre-initialised context.
/// Returns A pseudo random number (between 0 and MAX_INT).
pub extern fn sceKernelUtilsMt19937UInt(ctx: [*c]types.SceKernelUtilsMt19937Context) callconv(.c) u32;

pub extern fn sceKernelGetGPI() callconv(.c) void;

pub extern fn sceKernelSetGPO() callconv(.c) void;

/// Get the processor clock used since the start of the process
pub extern fn sceKernelLibcClock() callconv(.c) c_int;

/// Get the time in seconds since the epoc (1st Jan 1970)
pub extern fn sceKernelLibcTime(t: [*c]c_int) callconv(.c) c_int;

/// Get the current time of time and time zone information
pub extern fn sceKernelLibcGettimeofday(tp: [*c]c_int, tzp: [*c]c_int) callconv(.c) c_int;

/// Write back the data cache to memory
pub extern fn sceKernelDcacheWritebackAll() callconv(.c) void;

/// Write back and invalidate the data cache
pub extern fn sceKernelDcacheWritebackInvalidateAll() callconv(.c) void;

/// Write back a range of addresses from the data cache to memory
pub extern fn sceKernelDcacheWritebackRange(p: ?*const anyopaque, size: c_uint) callconv(.c) void;

/// Write back and invalidate a range of addresses in the data cache
pub extern fn sceKernelDcacheWritebackInvalidateRange(p: ?*const anyopaque, size: c_uint) callconv(.c) void;

pub extern fn sceKernelDcacheProbe() callconv(.c) void;

pub extern fn sceKernelDcacheReadTag() callconv(.c) void;

pub extern fn sceKernelIcacheProbe() callconv(.c) void;

pub extern fn sceKernelIcacheReadTag() callconv(.c) void;

/// Invalidate the instruction cache
pub extern fn sceKernelIcacheInvalidateAll() callconv(.c) void;

/// Invalidate a range of addresses in the instruction cache
pub extern fn sceKernelIcacheInvalidateRange(p: ?*const anyopaque, size: c_uint) callconv(.c) void;

comptime {
    asm (macro.import_module_start("UtilsForUser", "0x40010000", "26"));
    asm (macro.import_function("UtilsForUser", "0xBFA98062", "sceKernelDcacheInvalidateRange"));
    asm (macro.import_function("UtilsForUser", "0xC8186A58", "sceKernelUtilsMd5Digest"));
    asm (macro.import_function("UtilsForUser", "0x9E5C5086", "sceKernelUtilsMd5BlockInit"));
    asm (macro.import_function("UtilsForUser", "0x61E1E525", "sceKernelUtilsMd5BlockUpdate"));
    asm (macro.import_function("UtilsForUser", "0xB8D24E78", "sceKernelUtilsMd5BlockResult"));
    asm (macro.import_function("UtilsForUser", "0x840259F1", "sceKernelUtilsSha1Digest"));
    asm (macro.import_function("UtilsForUser", "0xF8FCD5BA", "sceKernelUtilsSha1BlockInit"));
    asm (macro.import_function("UtilsForUser", "0x346F6DA8", "sceKernelUtilsSha1BlockUpdate"));
    asm (macro.import_function("UtilsForUser", "0x585F1C09", "sceKernelUtilsSha1BlockResult"));
    asm (macro.import_function("UtilsForUser", "0xE860E75E", "sceKernelUtilsMt19937Init"));
    asm (macro.import_function("UtilsForUser", "0x06FB8A63", "sceKernelUtilsMt19937UInt"));
    asm (macro.import_function("UtilsForUser", "0x37FB5C42", "sceKernelGetGPI"));
    asm (macro.import_function("UtilsForUser", "0x6AD345D7", "sceKernelSetGPO"));
    asm (macro.import_function("UtilsForUser", "0x91E4F6A7", "sceKernelLibcClock"));
    asm (macro.import_function("UtilsForUser", "0x27CC57F0", "sceKernelLibcTime"));
    asm (macro.import_function("UtilsForUser", "0x71EC4271", "sceKernelLibcGettimeofday"));
    asm (macro.import_function("UtilsForUser", "0x79D1C3FA", "sceKernelDcacheWritebackAll"));
    asm (macro.import_function("UtilsForUser", "0xB435DEC5", "sceKernelDcacheWritebackInvalidateAll"));
    asm (macro.import_function("UtilsForUser", "0x3EE30821", "sceKernelDcacheWritebackRange"));
    asm (macro.import_function("UtilsForUser", "0x34B9FA9E", "sceKernelDcacheWritebackInvalidateRange"));
    asm (macro.import_function("UtilsForUser", "0x80001C4C", "sceKernelDcacheProbe"));
    asm (macro.import_function("UtilsForUser", "0x16641D70", "sceKernelDcacheReadTag"));
    asm (macro.import_function("UtilsForUser", "0x4FD31C9D", "sceKernelIcacheProbe"));
    asm (macro.import_function("UtilsForUser", "0xFB05FAD0", "sceKernelIcacheReadTag"));
    asm (macro.import_function("UtilsForUser", "0x920F104A", "sceKernelIcacheInvalidateAll"));
    asm (macro.import_function("UtilsForUser", "0xC2DF770E", "sceKernelIcacheInvalidateRange"));
}
