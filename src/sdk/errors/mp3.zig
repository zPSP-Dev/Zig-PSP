// MP3 facility error codes (0x80671xxx).
// Sourced from PPSSPP ErrorCodes.h.

const kernel = @import("kernel.zig");

pub const KernelError = kernel.KernelError;

pub const FacilityError = error{
    InvalidHandle,
    BadAddr,
    BadSize,
    UnreservedHandle,
    NotYetInitHandle,
    NoResourceAvail,
    BadSampleRate,
    BadResetFrame,
};

pub const Error = FacilityError || KernelError || error{Unexpected};

pub fn fromCode(code: u32) ?FacilityError {
    return switch (code) {
        0x80671001 => error.InvalidHandle,
        0x80671002 => error.BadAddr,
        0x80671003 => error.BadSize,
        0x80671102 => error.UnreservedHandle,
        0x80671103 => error.NotYetInitHandle,
        0x80671201 => error.NoResourceAvail,
        0x80671302 => error.BadSampleRate,
        0x80671501 => error.BadResetFrame,
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
