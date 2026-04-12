// Audio facility error codes (0x80260xxx).
// Sourced from PPSSPP ErrorCodes.h.

const kernel = @import("kernel.zig");

pub const KernelError = kernel.KernelError;

pub const FacilityError = error{
    ChannelNotInit,
    ChannelBusy,
    InvalidChannel,
    PrivRequired,
    NoChannelsAvailable,
    OutputSampleDataSizeNotAligned,
    InvalidFormat,
    ChannelNotReserved,
    NotOutput,
    InvalidFrequency,
    InvalidVolume,
    InputBusy,
    ChannelAlreadyReserved,
};

pub const Error = FacilityError || KernelError || error{Unexpected};

pub fn fromCode(code: u32) ?FacilityError {
    return switch (code) {
        0x80260001 => error.ChannelNotInit,
        0x80260002 => error.ChannelBusy,
        0x80260003 => error.InvalidChannel,
        0x80260004 => error.PrivRequired,
        0x80260005 => error.NoChannelsAvailable,
        0x80260006 => error.OutputSampleDataSizeNotAligned,
        0x80260007 => error.InvalidFormat,
        0x80260008 => error.ChannelNotReserved,
        0x80260009 => error.NotOutput,
        0x8026000a => error.InvalidFrequency,
        0x8026000b => error.InvalidVolume,
        0x80260010 => error.InputBusy,
        0x80268002 => error.ChannelAlreadyReserved,
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
