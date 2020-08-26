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

const macro = @import("pspmacros.zig");

comptime{
    asm(macro.import_module_start("sceHttp", "0x00090011", "83"));
    asm(macro.import_function("sceHttp", "0x0282A3BD", "sceHttpGetContentLength"));
    asm(macro.import_function("sceHttp", "0x03D9526F", "sceHttpSetResolveRetry"));
    asm(macro.import_function("sceHttp", "0x06488A1C", "sceHttpSetCookieSendCallback"));
    asm(macro.import_function("sceHttp", "0x0809C831", "sceHttpEnableRedirect"));
    asm(macro.import_function("sceHttp", "0x0B12ABFB", "sceHttpDisableCookie"));
    asm(macro.import_function("sceHttp", "0x0DAFA58F", "sceHttpEnableCookie"));
    asm(macro.import_function("sceHttp", "0x15540184", "sceHttpDeleteHeader"));
    asm(macro.import_function("sceHttp", "0x1A0EBB69", "sceHttpDisableRedirect"));
    asm(macro.import_function("sceHttp", "0x1CEDB9D4", "sceHttpFlushCache"));
    asm(macro.import_function("sceHttp", "0x1F0FC3E3", "sceHttpSetRecvTimeOut"));
    asm(macro.import_function("sceHttp", "0x2255551E", "sceHttpGetNetworkPspError"));
    asm(macro.import_function("sceHttp", "0x267618F4", "sceHttpSetAuthInfoCallback"));
    asm(macro.import_function("sceHttp", "0x2A6C3296", "sceHttpSetAuthInfoCB"));
    asm(macro.import_function("sceHttp", "0x2C3C82CF", "sceHttpFlushAuthList"));
    asm(macro.import_function("sceHttp", "0x3A67F306", "sceHttpSetCookieRecvCallback"));
    asm(macro.import_function("sceHttp", "0x3C478044", "sceHttp_3C478044"));
    asm(macro.import_function("sceHttp", "0x3EABA285", "sceHttpAddExtraHeader"));
    asm(macro.import_function("sceHttp", "0x457D221D", "sceHttp_457D221D"));
    asm(macro.import_function("sceHttp", "0x47347B50", "sceHttpCreateRequest"));
    asm(macro.import_function("sceHttp", "0x47940436", "sceHttpSetResolveTimeOut"));
    asm(macro.import_function("sceHttp", "0x4CC7D78F", "sceHttpGetStatusCode"));
    asm(macro.import_function("sceHttp", "0x4E4A284A", "sceHttp_4E4A284A"));
    asm(macro.import_function("sceHttp", "0x5152773B", "sceHttpDeleteConnection"));
    asm(macro.import_function("sceHttp", "0x54E7DF75", "sceHttpIsRequestInCache"));
    asm(macro.import_function("sceHttp", "0x569A1481", "sceHttpsSetSslCallback"));
    asm(macro.import_function("sceHttp", "0x59E6D16F", "sceHttpEnableCache"));
    asm(macro.import_function("sceHttp", "0x68AB0F86", "sceHttpsInitWithPath"));
    asm(macro.import_function("sceHttp", "0x739C2D79", "sceHttp_739C2D79"));
    asm(macro.import_function("sceHttp", "0x76D1363B", "sceHttpSaveSystemCookie"));
    asm(macro.import_function("sceHttp", "0x7774BF4C", "sceHttpAddCookie"));
    asm(macro.import_function("sceHttp", "0x77EE5319", "sceHttp_77EE5319"));
    asm(macro.import_function("sceHttp", "0x78A0D3EC", "sceHttpEnableKeepAlive"));
    asm(macro.import_function("sceHttp", "0x78B54C09", "sceHttpEndCache"));
    asm(macro.import_function("sceHttp", "0x8046E250", "sceHttp_8046E250"));
    asm(macro.import_function("sceHttp", "0x87797BDD", "sceHttpsLoadDefaultCert"));
    asm(macro.import_function("sceHttp", "0x87F1E666", "sceHttp_87F1E666"));
    asm(macro.import_function("sceHttp", "0x8ACD1F73", "sceHttpSetConnectTimeOut"));
    asm(macro.import_function("sceHttp", "0x8EEFD953", "sceHttpCreateConnection_stub"));
    asm(macro.import_function("sceHttp", "0x951D310E", "sceHttp_951D310E"));
    asm(macro.import_function("sceHttp", "0x9668864C", "sceHttpSetRecvBlockSize"));
    asm(macro.import_function("sceHttp", "0x96F16D3E", "sceHttpGetCookie"));
    asm(macro.import_function("sceHttp", "0x9988172D", "sceHttpSetSendTimeOut"));
    asm(macro.import_function("sceHttp", "0x9AFC98B2", "sceHttpSendRequestInCacheFirstMode"));
    asm(macro.import_function("sceHttp", "0x9B1F1F36", "sceHttpCreateTemplate"));
    asm(macro.import_function("sceHttp", "0x9FC5F10D", "sceHttpEnableAuth"));
    asm(macro.import_function("sceHttp", "0xA4496DE5", "sceHttpSetRedirectCallback"));
    asm(macro.import_function("sceHttp", "0xA461A167", "sceHttp_A461A167"));
    asm(macro.import_function("sceHttp", "0xA5512E01", "sceHttpDeleteRequest"));
    asm(macro.import_function("sceHttp", "0xA6800C34", "sceHttpInitCache"));
    asm(macro.import_function("sceHttp", "0xA909F2AE", "sceHttp_A909F2AE"));
    asm(macro.import_function("sceHttp", "0xAB1540D5", "sceHttpsGetSslError"));
    asm(macro.import_function("sceHttp", "0xAB1ABE07", "sceHttpInit"));
    asm(macro.import_function("sceHttp", "0xAE948FEE", "sceHttpDisableAuth"));
    asm(macro.import_function("sceHttp", "0xB0257723", "sceHttp_B0257723"));
    asm(macro.import_function("sceHttp", "0xB0C34B1D", "sceHttpSetCacheContentLengthMaxSize"));
    asm(macro.import_function("sceHttp", "0xB3FAF831", "sceHttpsDisableOption"));
    asm(macro.import_function("sceHttp", "0xB509B09E", "sceHttpCreateRequestWithURL"));
    asm(macro.import_function("sceHttp", "0xBAC31BF1", "sceHttpsEnableOption"));
    asm(macro.import_function("sceHttp", "0xBB70706F", "sceHttpSendRequest"));
    asm(macro.import_function("sceHttp", "0xC0E69162", "sceHttp_C0E69162"));
    asm(macro.import_function("sceHttp", "0xC10B6BD9", "sceHttpAbortRequest"));
    asm(macro.import_function("sceHttp", "0xC6330B0D", "sceHttp_C6330B0D"));
    asm(macro.import_function("sceHttp", "0xC7EF2559", "sceHttpDisableKeepAlive"));
    asm(macro.import_function("sceHttp", "0xC98CBBA7", "sceHttpSetResHeaderMaxSize"));
    asm(macro.import_function("sceHttp", "0xCC920C12", "sceHttp_CC920C12"));
    asm(macro.import_function("sceHttp", "0xCCBD167A", "sceHttpDisableCache"));
    asm(macro.import_function("sceHttp", "0xCDB0DC58", "sceHttp_CDB0DC58"));
    asm(macro.import_function("sceHttp", "0xCDF8ECB9", "sceHttpCreateConnectionWithURL"));
    asm(macro.import_function("sceHttp", "0xD081EC8F", "sceHttpGetNetworkErrno"));
    asm(macro.import_function("sceHttp", "0xD11DAB01", "sceHttpsGetCaList"));
    asm(macro.import_function("sceHttp", "0xD1C8945E", "sceHttpEnd"));
    asm(macro.import_function("sceHttp", "0xD29163DA", "sceHttp_D29163DA"));
    asm(macro.import_function("sceHttp", "0xD70D4847", "sceHttpGetProxy_stub"));
    asm(macro.import_function("sceHttp", "0xD80BE761", "sceHttp_D80BE761"));
    asm(macro.import_function("sceHttp", "0xDB266CCF", "sceHttpGetAllHeader"));
    asm(macro.import_function("sceHttp", "0xDD6E7857", "sceHttp_DD6E7857"));
    asm(macro.import_function("sceHttp", "0xE4D21302", "sceHttpsInit"));
    asm(macro.import_function("sceHttp", "0xEDEEB999", "sceHttpReadData"));
    asm(macro.import_function("sceHttp", "0xF0F46C62", "sceHttpSetProxy_stub"));
    asm(macro.import_function("sceHttp", "0xF1657B22", "sceHttpLoadSystemCookie"));
    asm(macro.import_function("sceHttp", "0xF49934F6", "sceHttpSetMallocFunction"));
    asm(macro.import_function("sceHttp", "0xF9D8EB63", "sceHttpsEnd"));
    asm(macro.import_function("sceHttp", "0xFCF8C055", "sceHttpDeleteTemplate"));

    asm(macro.generic_abi_wrapper("sceHttpCreateConnection", 5));
    asm(macro.generic_abi_wrapper("sceHttpGetProxy", 6));
    asm(macro.generic_abi_wrapper("sceHttpSetProxy", 5));
}