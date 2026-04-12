// Atrac3plus facility error codes (0x80630xxx-0x80631xxx).
// Sourced from PPSSPP ErrorCodes.h and pspsdk pspatrac3.h.

const kernel = @import("kernel.zig");

pub const KernelError = kernel.KernelError;

pub const FacilityError = error{
    ParamFail,
    ApiFail,
    NoAtracId,
    BadCodectype,
    BadAtracId,
    UnknownFormat,
    WrongCodectype,
    BadCodecParams,
    AllDataLoaded,
    NoData,
    SizeTooSmall,
    SecondBufferNeeded,
    IncorrectReadSize,
    BadAlignment,
    BadSample,
    BadFirstResetSize,
    BadSecondResetSize,
    AddDataIsTooBig,
    NotMono,
    NoLoopInformation,
    SecondBufferNotNeeded,
    BufferIsEmpty,
    AllDataDecoded,
    IsLowLevel,
    IsForScesas,
    Aa3OtherFailure,
    Aa3InvalidData,
    Aa3SizeTooSmall,
    Aa3BadCodecParams,
};

pub const Error = FacilityError || KernelError || error{Unexpected};

pub fn fromCode(code: u32) ?FacilityError {
    return switch (code) {
        0x80630001 => error.ParamFail,
        0x80630002 => error.ApiFail,
        0x80630003 => error.NoAtracId,
        0x80630004 => error.BadCodectype,
        0x80630005 => error.BadAtracId,
        0x80630006 => error.UnknownFormat,
        0x80630007 => error.WrongCodectype,
        0x80630008 => error.BadCodecParams,
        0x80630009 => error.AllDataLoaded,
        0x80630010 => error.NoData,
        0x80630011 => error.SizeTooSmall,
        0x80630012 => error.SecondBufferNeeded,
        0x80630013 => error.IncorrectReadSize,
        0x80630014 => error.BadAlignment,
        0x80630015 => error.BadSample,
        0x80630016 => error.BadFirstResetSize,
        0x80630017 => error.BadSecondResetSize,
        0x80630018 => error.AddDataIsTooBig,
        0x80630019 => error.NotMono,
        0x80630021 => error.NoLoopInformation,
        0x80630022 => error.SecondBufferNotNeeded,
        0x80630023 => error.BufferIsEmpty,
        0x80630024 => error.AllDataDecoded,
        0x80630031 => error.IsLowLevel,
        0x80630040 => error.IsForScesas,
        0x80631002 => error.Aa3OtherFailure,
        0x80631003 => error.Aa3InvalidData,
        0x80631004 => error.Aa3SizeTooSmall,
        0x80631005 => error.Aa3BadCodecParams,
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
