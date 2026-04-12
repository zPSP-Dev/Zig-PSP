// JPEG facility error codes (0x80650xxx).
// Sourced from PPSSPP ErrorCodes.h.

const kernel = @import("kernel.zig");

pub const KernelError = kernel.KernelError;

pub const FacilityError = error{
    InvalidData,
    InvalidColorspace,
    InvalidSize,
    NoSoi,
    InvalidState,
    OutOfMemory,
    AlreadyInit,
    InvalidValue,
};

pub const Error = FacilityError || KernelError || error{Unexpected};

pub fn fromCode(code: u32) ?FacilityError {
    return switch (code) {
        0x80650004 => error.InvalidData,
        0x80650013 => error.InvalidColorspace,
        0x80650020 => error.InvalidSize,
        0x80650023 => error.NoSoi,
        0x80650039 => error.InvalidState,
        0x80650041 => error.OutOfMemory,
        0x80650042 => error.AlreadyInit,
        0x80650051 => error.InvalidValue,
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
