// Back-compat hub. New code should import from errors/<facility>.zig directly.

const kernel = @import("errors/kernel.zig");

pub const Error = kernel.Error;
pub const KernelError = kernel.KernelError;
pub const fromCode = kernel.translate;
pub const check = kernel.check;
pub const checkPositive = kernel.checkPositive;

/// Cast u32 to c_int for passing to C functions.
pub fn ci(val: u32) c_int {
    return @intCast(val);
}

/// Cast c_int to u32 for returning from C functions.
pub fn cu(val: c_int) u32 {
    return @intCast(val);
}
