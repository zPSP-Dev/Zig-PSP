usingnamespace @import("psptypes.zig");

const enum_unnamed_5 = extern enum(c_int) {
    PSP_HTTP_VERSION_1_0,
    PSP_HTTP_VERSION_1_1,
    _,
};
pub const PspHttpHttpVersion = enum_unnamed_5;

const enum_unnamed_6 = extern enum(c_int) {
    PSP_HTTP_METHOD_GET,
    PSP_HTTP_METHOD_POST,
    PSP_HTTP_METHOD_HEAD,
    _,
};
pub const PspHttpMethod = enum_unnamed_6;

const enum_unnamed_7 = extern enum(c_int) {
    PSP_HTTP_AUTH_BASIC,
    PSP_HTTP_AUTH_DIGEST,
    _,
};
pub const PspHttpAuthType = enum_unnamed_7;

const enum_unnamed_8 = extern enum(c_int) {
    PSP_HTTP_PROXY_AUTO,
    PSP_HTTP_PROXY_MANUAL,
    _,
};
pub const PspHttpProxyMode = enum_unnamed_8;

const enum_unnamed_9 = extern enum(c_int) {
    PSP_HTTP_HEADER_OVERWRITE,
    PSP_HTTP_HEADER_ADD,
    _,
};
pub const PspHttpAddHeaderMode = enum_unnamed_9;
pub const PspHttpMallocFunction = ?fn (SceSize) callconv(.C) ?*c_void;
pub const PspHttpReallocFunction = ?fn (?*c_void, SceSize) callconv(.C) ?*c_void;
pub const PspHttpFreeFunction = ?fn (?*c_void) callconv(.C) void;
pub const PspHttpPasswordCB = ?fn (c_int, PspHttpAuthType, [*c]const u8, [*c]u8, [*c]u8, SceBool, [*c][*c]u8, [*c]SceSize, [*c]SceBool) callconv(.C) c_int;
pub extern fn sceHttpInit(unknown1: c_uint) c_int;
pub extern fn sceHttpEnd() c_int;
pub extern fn sceHttpCreateTemplate(agent: [*c]u8, unknown1: c_int, unknown2: c_int) c_int;
pub extern fn sceHttpDeleteTemplate(templateid: c_int) c_int;
pub extern fn sceHttpCreateConnection(templateid: c_int, host: [*c]u8, unknown1: [*c]u8, port: c_ushort, unknown2: c_int) c_int;
pub extern fn sceHttpCreateConnectionWithURL(templateid: c_int, url: [*c]const u8, unknown1: c_int) c_int;
pub extern fn sceHttpDeleteConnection(connectionid: c_int) c_int;
pub extern fn sceHttpCreateRequest(connectionid: c_int, method: PspHttpMethod, path: [*c]u8, contentlength: SceULong64) c_int;
pub extern fn sceHttpCreateRequestWithURL(connectionid: c_int, method: PspHttpMethod, url: [*c]u8, contentlength: SceULong64) c_int;
pub extern fn sceHttpDeleteRequest(requestid: c_int) c_int;
pub extern fn sceHttpSendRequest(requestid: c_int, data: ?*c_void, datasize: c_uint) c_int;
pub extern fn sceHttpAbortRequest(requestid: c_int) c_int;
pub extern fn sceHttpReadData(requestid: c_int, data: ?*c_void, datasize: c_uint) c_int;
pub extern fn sceHttpGetContentLength(requestid: c_int, contentlength: [*c]SceULong64) c_int;
pub extern fn sceHttpGetStatusCode(requestid: c_int, statuscode: [*c]c_int) c_int;
pub extern fn sceHttpSetResolveTimeOut(id: c_int, timeout: c_uint) c_int;
pub extern fn sceHttpSetResolveRetry(id: c_int, count: c_int) c_int;
pub extern fn sceHttpSetConnectTimeOut(id: c_int, timeout: c_uint) c_int;
pub extern fn sceHttpSetSendTimeOut(id: c_int, timeout: c_uint) c_int;
pub extern fn sceHttpSetRecvTimeOut(id: c_int, timeout: c_uint) c_int;
pub extern fn sceHttpEnableKeepAlive(id: c_int) c_int;
pub extern fn sceHttpDisableKeepAlive(id: c_int) c_int;
pub extern fn sceHttpEnableRedirect(id: c_int) c_int;
pub extern fn sceHttpDisableRedirect(id: c_int) c_int;
pub extern fn sceHttpEnableCookie(id: c_int) c_int;
pub extern fn sceHttpDisableCookie(id: c_int) c_int;
pub extern fn sceHttpSaveSystemCookie() c_int;
pub extern fn sceHttpLoadSystemCookie() c_int;
pub extern fn sceHttpAddExtraHeader(id: c_int, name: [*c]u8, value: [*c]u8, unknown1: c_int) c_int;
pub extern fn sceHttpDeleteHeader(id: c_int, name: [*c]const u8) c_int;
pub extern fn sceHttpsInit(unknown1: c_int, unknown2: c_int, unknown3: c_int, unknown4: c_int) c_int;
pub extern fn sceHttpsEnd() c_int;
pub extern fn sceHttpsLoadDefaultCert(unknown1: c_int, unknown2: c_int) c_int;
pub extern fn sceHttpDisableAuth(id: c_int) c_int;
pub extern fn sceHttpDisableCache(id: c_int) c_int;
pub extern fn sceHttpEnableAuth(id: c_int) c_int;
pub extern fn sceHttpEnableCache(id: c_int) c_int;
pub extern fn sceHttpEndCache() c_int;
pub extern fn sceHttpGetAllHeader(request: c_int, header: [*c][*c]u8, header_size: [*c]c_uint) c_int;
pub extern fn sceHttpGetNetworkErrno(request: c_int, err_num: [*c]c_int) c_int;
pub extern fn sceHttpGetProxy(id: c_int, activate_flag: [*c]c_int, mode: [*c]c_int, proxy_host: [*c]u8, len: SceSize, proxy_port: [*c]c_ushort) c_int;
pub extern fn sceHttpInitCache(max_size: SceSize) c_int;
pub extern fn sceHttpSetAuthInfoCB(id: c_int, cbfunc: PspHttpPasswordCB) c_int;
pub extern fn sceHttpSetProxy(id: c_int, activate_flag: c_int, mode: c_int, new_proxy_host: [*c]const u8, new_proxy_port: c_ushort) c_int;
pub extern fn sceHttpSetResHeaderMaxSize(id: c_int, header_size: c_uint) c_int;
pub extern fn sceHttpSetMallocFunction(malloc_func: PspHttpMallocFunction, free_func: PspHttpFreeFunction, realloc_func: PspHttpReallocFunction) c_int;
