// MPEG/PSMF facility error codes (0x8061xxxx-0x8062xxxx).
// Sourced from PPSSPP ErrorCodes.h.

const kernel = @import("kernel.zig");

pub const KernelError = kernel.KernelError;

pub const FacilityError = error{
    // sceMpeg
    BadVersion,
    InvalidAddr,
    NoMemory,
    InvalidValue,
    AlreadyInit,
    NotYetInit,
    NoData,
    AvcInvalidValue,
    AvcDecodeFatal,

    // scePsmf
    PsmfNotInitialized,
    PsmfBadVersion,
    PsmfNotFound,
    PsmfInvalidId,
    PsmfInvalidValue,
    PsmfInvalidTimestamp,
    PsmfInvalidPsmf,

    // scePsmfPlayer
    PlayerInvalidStatus,
    PlayerInvalidStream,
    PlayerBufferSize,
    PlayerInvalidConfig,
    PlayerInvalidParam,
    PlayerNoMoreData,
};

pub const Error = FacilityError || KernelError || error{Unexpected};

pub fn fromCode(code: u32) ?FacilityError {
    return switch (code) {
        // sceMpeg
        0x80610002 => error.BadVersion,
        0x80610022 => error.NoMemory,
        0x80610103 => error.InvalidAddr,
        0x806101fe => error.InvalidValue,
        0x80618001 => error.NoData,
        0x80618005 => error.AlreadyInit,
        0x80618009 => error.NotYetInit,
        0x806201fe => error.AvcInvalidValue,
        0x80628002 => error.AvcDecodeFatal,

        // scePsmf
        0x80615001 => error.PsmfNotInitialized,
        0x80615002 => error.PsmfBadVersion,
        0x80615025 => error.PsmfNotFound,
        0x80615100 => error.PsmfInvalidId,
        0x806151fe => error.PsmfInvalidValue,
        0x80615500 => error.PsmfInvalidTimestamp,
        0x80615501 => error.PsmfInvalidPsmf,

        // scePsmfPlayer
        0x80616001 => error.PlayerInvalidStatus,
        0x80616003 => error.PlayerInvalidStream,
        0x80616005 => error.PlayerBufferSize,
        0x80616006 => error.PlayerInvalidConfig,
        0x80616008 => error.PlayerInvalidParam,
        0x8061600c => error.PlayerNoMoreData,

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
