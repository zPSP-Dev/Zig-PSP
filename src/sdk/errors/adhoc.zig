// Ad-hoc networking error codes (sceNetAdhoc, sceNetAdhocctl, sceNetAdhocMatching).
// Sourced from PPSSPP ErrorCodes.h.

const kernel = @import("kernel.zig");

pub const KernelError = kernel.KernelError;

pub const FacilityError = error{
    // sceNetAdhoc (0x80410701-0x8041071C)
    InvalidSocketId,
    InvalidAddr,
    InvalidPort,
    InvalidBuflen,
    InvalidDatalen,
    NotEnoughSpace,
    SocketDeleted,
    SocketAlerted,
    WouldBlock,
    PortInUse,
    NotConnected,
    Disconnected,
    NotOpened,
    NotListened,
    SocketIdNotAvail,
    PortNotAvail,
    InvalidArg,
    NotInitialized,
    AlreadyInitialized,
    Busy,
    Timeout,
    NoEntry,
    ExceptionEvent,
    ConnectionRefused,
    ThreadAborted,
    AlreadyCreated,
    NotInGamemode,
    NotCreated,

    // sceNetAdhocMatching (0x80410801-0x80410818)
    MatchingInvalidMode,
    MatchingInvalidPort,
    MatchingInvalidMaxnum,
    MatchingRxbufTooShort,
    MatchingInvalidOptlen,
    MatchingInvalidArg,
    MatchingInvalidId,
    MatchingIdNotAvail,
    MatchingNoSpace,
    MatchingIsRunning,
    MatchingNotRunning,
    MatchingUnknownTarget,
    MatchingTargetNotReady,
    MatchingExceedMaxnum,
    MatchingRequestInProgress,
    MatchingAlreadyEstablished,
    MatchingBusy,
    MatchingAlreadyInitialized,
    MatchingNotInitialized,
    MatchingPortInUse,
    MatchingStacksizeTooShort,
    MatchingInvalidDatalen,
    MatchingNotEstablished,
    MatchingDataBusy,

    // sceNetAdhocctl (0x80410b01-0x80410b13)
    CtlNotLeftIbss,
    CtlAlreadyConnected,
    CtlWlanSwitchOff,
    CtlInvalidArg,
    CtlTimeout,
    CtlIdNotFound,
    CtlAlreadyInitialized,
    CtlNotInitialized,
    CtlDisconnected,
    CtlNoScanInfo,
    CtlInvalidIbss,
    CtlNotEnterGamemode,
    CtlChannelNotAvailable,
    CtlWlanBeaconLost,
    CtlWlanSuspended,
    CtlBusy,
    CtlChannelNotMatch,
    CtlTooManyHandlers,
    CtlStacksizeTooShort,

    // Auth
    AuthAlreadyInitialized,
};

pub const Error = FacilityError || KernelError || error{Unexpected};

pub fn fromCode(code: u32) ?FacilityError {
    return switch (code) {
        // sceNetAdhoc
        0x80410701 => error.InvalidSocketId,
        0x80410702 => error.InvalidAddr,
        0x80410703 => error.InvalidPort,
        0x80410704 => error.InvalidBuflen,
        0x80410705 => error.InvalidDatalen,
        0x80400706 => error.NotEnoughSpace,
        0x80410707 => error.SocketDeleted,
        0x80410708 => error.SocketAlerted,
        0x80410709 => error.WouldBlock,
        0x8041070a => error.PortInUse,
        0x8041070b => error.NotConnected,
        0x8041070c => error.Disconnected,
        0x8040070d => error.NotOpened,
        0x8040070e => error.NotListened,
        0x8041070f => error.SocketIdNotAvail,
        0x80410710 => error.PortNotAvail,
        0x80410711 => error.InvalidArg,
        0x80410712 => error.NotInitialized,
        0x80410713 => error.AlreadyInitialized,
        0x80410714 => error.Busy,
        0x80410715 => error.Timeout,
        0x80410716 => error.NoEntry,
        0x80410717 => error.ExceptionEvent,
        0x80410718 => error.ConnectionRefused,
        0x80410719 => error.ThreadAborted,
        0x8041071a => error.AlreadyCreated,
        0x8041071b => error.NotInGamemode,
        0x8041071c => error.NotCreated,

        // sceNetAdhocMatching
        0x80410801 => error.MatchingInvalidMode,
        0x80410802 => error.MatchingInvalidPort,
        0x80410803 => error.MatchingInvalidMaxnum,
        0x80410804 => error.MatchingRxbufTooShort,
        0x80410805 => error.MatchingInvalidOptlen,
        0x80410806 => error.MatchingInvalidArg,
        0x80410807 => error.MatchingInvalidId,
        0x80410808 => error.MatchingIdNotAvail,
        0x80410809 => error.MatchingNoSpace,
        0x8041080a => error.MatchingIsRunning,
        0x8041080b => error.MatchingNotRunning,
        0x8041080c => error.MatchingUnknownTarget,
        0x8041080d => error.MatchingTargetNotReady,
        0x8041080e => error.MatchingExceedMaxnum,
        0x8041080f => error.MatchingRequestInProgress,
        0x80410810 => error.MatchingAlreadyEstablished,
        0x80410811 => error.MatchingBusy,
        0x80410812 => error.MatchingAlreadyInitialized,
        0x80410813 => error.MatchingNotInitialized,
        0x80410814 => error.MatchingPortInUse,
        0x80410815 => error.MatchingStacksizeTooShort,
        0x80410816 => error.MatchingInvalidDatalen,
        0x80410817 => error.MatchingNotEstablished,
        0x80410818 => error.MatchingDataBusy,

        // sceNetAdhocctl
        0x80410b01 => error.CtlNotLeftIbss,
        0x80410b02 => error.CtlAlreadyConnected,
        0x80410b03 => error.CtlWlanSwitchOff,
        0x80410b04 => error.CtlInvalidArg,
        0x80410b05 => error.CtlTimeout,
        0x80410b06 => error.CtlIdNotFound,
        0x80410b07 => error.CtlAlreadyInitialized,
        0x80410b08 => error.CtlNotInitialized,
        0x80410b09 => error.CtlDisconnected,
        0x80410b0a => error.CtlNoScanInfo,
        0x80410b0b => error.CtlInvalidIbss,
        0x80410b0c => error.CtlNotEnterGamemode,
        0x80410b0d => error.CtlChannelNotAvailable,
        0x80410b0e => error.CtlWlanBeaconLost,
        0x80410b0f => error.CtlWlanSuspended,
        0x80410b10 => error.CtlBusy,
        0x80410b11 => error.CtlChannelNotMatch,
        0x80410b12 => error.CtlTooManyHandlers,
        0x80410b13 => error.CtlStacksizeTooShort,

        // Auth
        0x80410601 => error.AuthAlreadyInitialized,

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
