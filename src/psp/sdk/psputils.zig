usingnamespace @import("psptypes.zig");

pub const clock_t = u32;
pub const suseconds_t = u32;
pub const timeval = extern struct {
    tv_sec: time_t,
    tv_usec: suseconds_t,
};
pub const timezone = extern struct {
    tz_minuteswest: c_int,
    tz_dsttime: c_int,
};

pub const SceKernelUtilsMt19937Context = extern struct {
    count: c_uint,
    state: [624]c_uint,
};

pub const SceKernelUtilsMd5Context = extern struct {
    h: [4]c_uint,
    pad: c_uint,
    usRemains: SceUShort16,
    usComputed: SceUShort16,
    ullTotalLen: SceULong64,
    buf: [64]u8,
};

pub const SceKernelUtilsSha1Context = extern struct {
    h: [5]c_uint,
    usRemains: SceUShort16,
    usComputed: SceUShort16,
    ullTotalLen: SceULong64,
    buf: [64]u8,
};

// Function to initialise a mersenne twister context.
//
// @param ctx - Pointer to a context
// @param seed - A seed for the random function.
//
// @par Example:
// @code
// SceKernelUtilsMt19937Context ctx;
// sceKernelUtilsMt19937Init(&ctx, time(NULL));
// u23 rand_val = sceKernelUtilsMt19937UInt(&ctx);
// @endcode
//
// @return < 0 on error.
pub extern fn sceKernelUtilsMt19937Init(ctx: *SceKernelUtilsMt19937Context, seed: u32) c_int;
pub fn kernelUtilsMt19937Init(ctx: *SceKernelUtilsMt19937Context, seed: u32) !i32 {
    var res = sceKernelUtilsMt19937Init(ctx, seed);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Function to return a new psuedo random number.
//
// @param ctx - Pointer to a pre-initialised context.
// @return A pseudo random number (between 0 and MAX_INT).
pub extern fn sceKernelUtilsMt19937UInt(ctx: *SceKernelUtilsMt19937Context) u32;

// Function to perform an MD5 digest of a data block.
//
// @param data - Pointer to a data block to make a digest of.
// @param size - Size of the data block.
// @param digest - Pointer to a 16byte buffer to store the resulting digest
//
// @return < 0 on error.
pub extern fn sceKernelUtilsMd5Digest(data: [*]u8, size: u32, digest: [*]u8) c_int;
pub fn kernelUtilsMd5Digest(data: [*]u8, size: u32, digest: [*]u8) !i32 {
    var res = sceKernelUtilsMd5Digest(data, size, digest);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Function to initialise a MD5 digest context
//
// @param ctx - A context block to initialise
//
// @return < 0 on error.

// C Example
// SceKernelUtilsMd5Context ctx;
// u8 digest[16];
// sceKernelUtilsMd5BlockInit(&ctx);
// sceKernelUtilsMd5BlockUpdate(&ctx, (u8*) "Hello", 5);
// sceKernelUtilsMd5BlockResult(&ctx, digest);
pub extern fn sceKernelUtilsMd5BlockInit(ctx: *SceKernelUtilsMd5Context) c_int;
pub fn kernelUtilsMd5BlockInit(ctx: *SceKernelUtilsMd5Context) !i32 {
    var res = sceKernelUtilsMd5BlockInit(ctx);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Function to update the MD5 digest with a block of data.
//
// @param ctx - A filled in context block.
// @param data - The data block to hash.
// @param size - The size of the data to hash
//
// @return < 0 on error.
pub extern fn sceKernelUtilsMd5BlockUpdate(ctx: *SceKernelUtilsMd5Context, data: [*]u8, size: u32) c_int;
pub fn kernelUtilsMd5BlockUpdate(ctx: *SceKernelUtilsMd5Context, data: [*]u8, size: u32) !i32 {
    var res = sceKernelUtilsMd5BlockUpdate(ctx, data, size);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Function to get the digest result of the MD5 hash.
//
// @param ctx - A filled in context block.
// @param digest - A 16 byte array to hold the digest.
//
// @return < 0 on error.
pub extern fn sceKernelUtilsMd5BlockResult(ctx: *SceKernelUtilsMd5Context, digest: [*]u8) c_int;
pub fn kernelUtilsMd5BlockResult(ctx: *SceKernelUtilsMd5Context, digest: [*]u8) !i32 {
    var res = sceKernelUtilsMd5BlockResult(ctx, digest);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Function to SHA1 hash a data block.
//
// @param data - The data to hash.
// @param size - The size of the data.
// @param digest - Pointer to a 20 byte array for storing the digest
//
// @return < 0 on error.
pub extern fn sceKernelUtilsSha1Digest(data: [*]u8, size: u32, digest: [*]u8) c_int;
pub fn kernelUtilsSha1Digest(data: [*]u8, size: u32, digest: [*]u8) !i32 {
    var res = sceKernelUtilsSha1Digest(data, size, digest);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Function to initialise a context for SHA1 hashing.
//
// @param ctx - Pointer to a context.
//
// @return < 0 on error.

// C Code Example
// SceKernelUtilsSha1Context ctx;
// u8 digest[20];
// sceKernelUtilsSha1BlockInit(&ctx);
// sceKernelUtilsSha1BlockUpdate(&ctx, (u8*) "Hello", 5);
// sceKernelUtilsSha1BlockResult(&ctx, digest);
pub extern fn sceKernelUtilsSha1BlockInit(ctx: *SceKernelUtilsSha1Context) c_int;
pub fn kernelUtilsSha1BlockInit(ctx: *SceKernelUtilsSha1Context) !i32 {
    var res = sceKernelUtilsSha1BlockInit(ctx);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Function to update the current hash.
//
// @param ctx - Pointer to a prefilled context.
// @param data - The data block to hash.
// @param size - The size of the data block
//
// @return < 0 on error.
pub extern fn sceKernelUtilsSha1BlockUpdate(ctx: *SceKernelUtilsSha1Context, data: [*]u8, size: u32) c_int;
pub fn kernelUtilsSha1BlockUpdate(ctx: *SceKernelUtilsSha1Context, data: [*]u8, size: u32) !i32 {
    var res = sceKernelUtilsSha1BlockUpdate(ctx, data, size);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Function to get the result of the SHA1 hash.
//
// @param ctx - Pointer to a prefilled context.
// @param digest - A pointer to a 20 byte array to contain the digest.
//
// @return < 0 on error.
pub extern fn sceKernelUtilsSha1BlockResult(ctx: *SceKernelUtilsSha1Context, digest: [*]u8) c_int;
pub fn kernelUtilsSha1BlockResult(ctx: *SceKernelUtilsSha1Context, digest: [*]u8) !i32 {
    var res = sceKernelUtilsSha1BlockResult(ctx, digest);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Get the time in seconds since the epoc (1st Jan 1970)
pub extern fn sceKernelLibcTime(t: *time_t) time_t;

// Get the processor clock used since the start of the process
pub extern fn sceKernelLibcClock() clock_t;

// Get the current time of time and time zone information
pub extern fn sceKernelLibcGettimeofday(tp: *timeval, tzp: *timezone) c_int;

//Write back the data cache to memory
pub extern fn sceKernelDcacheWritebackAll() void;

//Write back and invalidate the data cache
pub extern fn sceKernelDcacheWritebackInvalidateAll() void;

//Write back a range of addresses from the data cache to memory
pub extern fn sceKernelDcacheWritebackRange(p: ?*const c_void, size: c_uint) void;

//Write back and invalidate a range of addresses in the data cache
pub extern fn sceKernelDcacheWritebackInvalidateRange(p: ?*const c_void, size: c_uint) void;

//Invalidate a range of addresses in data cache
pub extern fn sceKernelDcacheInvalidateRange(p: ?*const c_void, size: c_uint) void;

//Invalidate the instruction cache
pub extern fn sceKernelIcacheInvalidateAll() void;

//Invalidate a range of addresses in the instruction cache
pub extern fn sceKernelIcacheInvalidateRange(p: ?*const c_void, size: c_uint) void;
