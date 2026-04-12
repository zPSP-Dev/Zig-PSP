// SSL facility error codes (0x80435xxx).
// Sourced from PPSSPP sceHttp.h / ErrorCodes.h.

const kernel = @import("kernel.zig");

pub const KernelError = kernel.KernelError;

pub const FacilityError = error{
    NotInit,
    AlreadyInit,
    OutOfMemory,
    InvalidParameter,
};

pub const Error = FacilityError || KernelError || error{Unexpected};

pub fn fromCode(code: u32) ?FacilityError {
    return switch (code) {
        0x80435001 => error.NotInit,
        0x80435020 => error.AlreadyInit,
        0x80435022 => error.OutOfMemory,
        0x804351fe => error.InvalidParameter,
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
