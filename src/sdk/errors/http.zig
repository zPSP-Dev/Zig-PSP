// HTTP facility error codes (0x80431xxx-0x80436xxx).
// Sourced from PPSSPP sceHttp.h.

const kernel = @import("kernel.zig");

pub const KernelError = kernel.KernelError;

pub const FacilityError = error{
    BeforeInit,
    NotSupported,
    AlreadyInited,
    Busy,
    OutOfMemory,
    NotFound,
    UnknownScheme,
    Network,
    BadResponse,
    BeforeSend,
    AfterSend,
    Timeout,
    UnknownAuthType,
    InvalidVersion,
    UnknownMethod,
    ReadByHeadMethod,
    NotInCom,
    NoContentLength,
    ChunkEnc,
    TooLargeResponseHeader,
    Ssl,
    InsufficientHeapsize,
    BeforeCookieLoad,
    Aborted,
    Unknown,
    InvalidId,
    OutOfSize,
    InvalidValue,
    ParseHttpNotFound,
    ParseHttpInvalidResponse,
    ParseHttpInvalidValue,
    InvalidUrl,
    ResolverEpacket,
    ResolverEnodns,
    ResolverEtimedout,
    ResolverEnosupport,
    ResolverEformat,
    ResolverEserverfailure,
    ResolverEnohost,
    ResolverEnotimplemented,
    ResolverEserverrefused,
    ResolverEnorecord,
    HttpsOutOfMemory,
    HttpsCert,
    HttpsHandshake,
    HttpsIo,
    HttpsInternal,
    HttpsProxy,
};

pub const Error = FacilityError || KernelError || error{Unexpected};

pub fn fromCode(code: u32) ?FacilityError {
    return switch (code) {
        0x80431001 => error.BeforeInit,
        0x80431004 => error.NotSupported,
        0x80431020 => error.AlreadyInited,
        0x80431021 => error.Busy,
        0x80431022 => error.OutOfMemory,
        0x80431025 => error.NotFound,
        0x80431061 => error.UnknownScheme,
        0x80431063 => error.Network,
        0x80431064 => error.BadResponse,
        0x80431065 => error.BeforeSend,
        0x80431066 => error.AfterSend,
        0x80431068 => error.Timeout,
        0x80431069 => error.UnknownAuthType,
        0x8043106a => error.InvalidVersion,
        0x8043106b => error.UnknownMethod,
        0x8043106f => error.ReadByHeadMethod,
        0x80431070 => error.NotInCom,
        0x80431071 => error.NoContentLength,
        0x80431072 => error.ChunkEnc,
        0x80431073 => error.TooLargeResponseHeader,
        0x80431075 => error.Ssl,
        0x80431077 => error.InsufficientHeapsize,
        0x80431078 => error.BeforeCookieLoad,
        0x80431080 => error.Aborted,
        0x80431081 => error.Unknown,
        0x80431100 => error.InvalidId,
        0x80431104 => error.OutOfSize,
        0x804311fe => error.InvalidValue,
        0x80432025 => error.ParseHttpNotFound,
        0x80432060 => error.ParseHttpInvalidResponse,
        0x804321fe => error.ParseHttpInvalidValue,
        0x80433060 => error.InvalidUrl,
        0x80436001 => error.ResolverEpacket,
        0x80436002 => error.ResolverEnodns,
        0x80436003 => error.ResolverEtimedout,
        0x80436004 => error.ResolverEnosupport,
        0x80436005 => error.ResolverEformat,
        0x80436006 => error.ResolverEserverfailure,
        0x80436007 => error.ResolverEnohost,
        0x80436008 => error.ResolverEnotimplemented,
        0x80436009 => error.ResolverEserverrefused,
        0x8043600a => error.ResolverEnorecord,
        0x80435022 => error.HttpsOutOfMemory,
        0x80435060 => error.HttpsCert,
        0x80435061 => error.HttpsHandshake,
        0x80435062 => error.HttpsIo,
        0x80435063 => error.HttpsInternal,
        0x80435064 => error.HttpsProxy,
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
