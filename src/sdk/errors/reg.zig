// Registry facility error codes (0x80082xxx).
// Sourced from PPSSPP ErrorCodes.h.

const kernel = @import("kernel.zig");

pub const KernelError = kernel.KernelError;

pub const FacilityError = error{
    MallocFailure,
    RegistryNotFound,
    InvalidPath,
    CategoryNotFound,
    InvalidName,
    PermissionFailure,
};

pub const Error = FacilityError || KernelError || error{Unexpected};

pub fn fromCode(code: u32) ?FacilityError {
    return switch (code) {
        0x80082712 => error.MallocFailure,
        0x80082715 => error.RegistryNotFound,
        0x80082716 => error.InvalidPath,
        0x80082718 => error.CategoryNotFound,
        0x80082738 => error.InvalidName,
        0x8008273b => error.PermissionFailure,
        else => null,
    };
}

pub fn translate(code: u32) Error {
    if (fromCode(code)) |e| return e;
    if (kernel.fromCode(code)) |e| return e;
    return error.Unexpected;
}

pub fn check(ret: c_int) Error!void {
    if (ret < 0) {
        @branchHint(.unlikely);
        return translate(@bitCast(ret));
    }
}

pub fn checkPositive(comptime T: type, ret: c_int) Error!T {
    if (ret < 0) {
        @branchHint(.unlikely);
        return translate(@bitCast(ret));
    }
    const i: i32 = @intCast(ret);
    return @bitCast(i);
}
