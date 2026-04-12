// Network facility error codes (sceNet, sceNetInet, sceNetApctl, sceNetResolver).
// Sourced from PPSSPP ErrorCodes.h.

const kernel = @import("kernel.zig");

pub const KernelError = kernel.KernelError;

pub const FacilityError = error{
    // sceNetInet (0x80410201-0x8041020b)
    InetAlreadyInitialized,
    InetSocketBusy,
    InetConfigInvalidArg,
    InetGetIfaddr,
    InetSetIfaddr,
    InetDelIfaddr,
    InetNoDefaultRoute,
    InetGetRoute,
    InetSetRoute,
    InetFlushRoute,
    InetInvalidArg,

    // sceNetResolver (0x80410401-0x80410417)
    ResolverNotTerminated,
    ResolverNoDnsServer,
    ResolverInvalidPtr,
    ResolverInvalidBuflen,
    ResolverInvalidId,
    ResolverIdMax,
    ResolverNoMem,
    ResolverBadId,
    ResolverCtxBusy,
    ResolverAlreadyStopped,
    ResolverNotSupported,
    ResolverBufNoSpace,
    ResolverInvalidPacket,
    ResolverStopped,
    ResolverSocket,
    ResolverTimeout,
    ResolverNoRecord,
    ResolverResPacketFormat,
    ResolverResServerFailure,
    ResolverInvalidHost,
    ResolverResNotImplemented,
    ResolverResServerRefused,
    ResolverInternal,

    // sceNetApctl (0x80410a01-0x80410a0b)
    ApctlAlreadyInitialized,
    ApctlInvalidCode,
    ApctlInvalidIp,
    ApctlNotDisconnected,
    ApctlNotInBss,
    ApctlWlanSwitchOff,
    ApctlWlanBeaconLost,
    ApctlWlanDisassociation,
    ApctlInvalidId,
    ApctlWlanSuspended,
    ApctlTimeout,
};

pub const Error = FacilityError || KernelError || error{Unexpected};

pub fn fromCode(code: u32) ?FacilityError {
    return switch (code) {
        // sceNetInet
        0x80410201 => error.InetAlreadyInitialized,
        0x80410202 => error.InetSocketBusy,
        0x80410203 => error.InetConfigInvalidArg,
        0x80410204 => error.InetGetIfaddr,
        0x80410205 => error.InetSetIfaddr,
        0x80410206 => error.InetDelIfaddr,
        0x80410207 => error.InetNoDefaultRoute,
        0x80410208 => error.InetGetRoute,
        0x80410209 => error.InetSetRoute,
        0x8041020a => error.InetFlushRoute,
        0x8041020b => error.InetInvalidArg,

        // sceNetResolver
        0x80410401 => error.ResolverNotTerminated,
        0x80410402 => error.ResolverNoDnsServer,
        0x80410403 => error.ResolverInvalidPtr,
        0x80410404 => error.ResolverInvalidBuflen,
        0x80410405 => error.ResolverInvalidId,
        0x80410406 => error.ResolverIdMax,
        0x80410407 => error.ResolverNoMem,
        0x80410408 => error.ResolverBadId,
        0x80410409 => error.ResolverCtxBusy,
        0x8041040a => error.ResolverAlreadyStopped,
        0x8041040b => error.ResolverNotSupported,
        0x8041040c => error.ResolverBufNoSpace,
        0x8041040d => error.ResolverInvalidPacket,
        0x8041040e => error.ResolverStopped,
        0x8041040f => error.ResolverSocket,
        0x80410410 => error.ResolverTimeout,
        0x80410411 => error.ResolverNoRecord,
        0x80410412 => error.ResolverResPacketFormat,
        0x80410413 => error.ResolverResServerFailure,
        0x80410414 => error.ResolverInvalidHost,
        0x80410415 => error.ResolverResNotImplemented,
        0x80410416 => error.ResolverResServerRefused,
        0x80410417 => error.ResolverInternal,

        // sceNetApctl
        0x80410a01 => error.ApctlAlreadyInitialized,
        0x80410a02 => error.ApctlInvalidCode,
        0x80410a03 => error.ApctlInvalidIp,
        0x80410a04 => error.ApctlNotDisconnected,
        0x80410a05 => error.ApctlNotInBss,
        0x80410a06 => error.ApctlWlanSwitchOff,
        0x80410a07 => error.ApctlWlanBeaconLost,
        0x80410a08 => error.ApctlWlanDisassociation,
        0x80410a09 => error.ApctlInvalidId,
        0x80410a0a => error.ApctlWlanSuspended,
        0x80410a0b => error.ApctlTimeout,

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
