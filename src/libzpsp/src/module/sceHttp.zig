// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Get http request response length.
/// `requestid` - ID of the request created by sceHttpCreateRequest or sceHttpCreateRequestWithURL
/// `contentlength` - The size of the content
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpGetContentLength(requestid: c_int, contentlength: [*c]types.SceULong64) callconv(.C) c_int;

/// Set resolver retry
/// `id` - ID of the template or connection
/// `count` - Number of retries
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpSetResolveRetry(id: c_int, count: c_int) callconv(.C) c_int;

pub extern fn sceHttpSetCookieSendCallback() callconv(.C) void;

/// Enable redirect
/// `id` - ID of the template or connection
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpEnableRedirect(id: c_int) callconv(.C) c_int;

/// Disable cookie
/// `id` - ID of the template or connection
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpDisableCookie(id: c_int) callconv(.C) c_int;

/// Enable cookie
/// `id` - ID of the template or connection
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpEnableCookie(id: c_int) callconv(.C) c_int;

/// Delete content header
/// `id` - ID of the template, connection or request
/// `name` - Name of the content
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpDeleteHeader(id: c_int, name: [*c]const c_char) callconv(.C) c_int;

/// Disable redirect
/// `id` - ID of the template or connection
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpDisableRedirect(id: c_int) callconv(.C) c_int;

pub extern fn sceHttpFlushCache() callconv(.C) void;

/// Set receive timeout
/// `id` - ID of the template or connection
/// `timeout` - Timeout value in microseconds
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpSetRecvTimeOut(id: c_int, timeout: c_uint) callconv(.C) c_int;

pub extern fn sceHttpGetNetworkPspError() callconv(.C) void;

pub extern fn sceHttpSetAuthInfoCallback() callconv(.C) void;

pub extern fn sceHttpSetAuthInfoCB(id: c_int, cbfunc: c_int) callconv(.C) c_int;

pub extern fn sceHttpFlushAuthList() callconv(.C) void;

pub extern fn sceHttpSetCookieRecvCallback() callconv(.C) void;

pub extern fn sceHttp_3C478044() callconv(.C) void;

/// Add content header
/// `id` - ID of the template, connection or request
/// `name` - Name of the content
/// `value` - Value of the content
/// `unknown1` - Pass 0
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpAddExtraHeader(id: c_int, name: [*c]c_char, value: [*c]c_char, unknown1: c_int) callconv(.C) c_int;

pub extern fn sceHttp_457D221D() callconv(.C) void;

/// Create a http request.
/// `connectionid` - ID of the connection created by sceHttpCreateConnection or sceHttpCreateConnectionWithURL
/// `method` - One of ::PspHttpMethod
/// `path` - Path to access
/// `contentlength` - Length of the content (POST method only)
/// Returns A request ID on success, < 0 on error.
pub extern fn sceHttpCreateRequest(connectionid: c_int, method: c_int, path: [*c]c_char, contentlength: types.SceULong64) callconv(.C) c_int;

/// Set resolver timeout
/// `id` - ID of the template or connection
/// `timeout` - Timeout value in microseconds
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpSetResolveTimeOut(id: c_int, timeout: c_uint) callconv(.C) c_int;

/// Get http request status code.
/// `requestid` - ID of the request created by sceHttpCreateRequest or sceHttpCreateRequestWithURL
/// `statuscode` - The status code from the host (200 is ok, 404 is not found etc)
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpGetStatusCode(requestid: c_int, statuscode: [*c]c_int) callconv(.C) c_int;

pub extern fn sceHttp_4E4A284A() callconv(.C) void;

/// Delete a http connection.
/// `connectionid` - ID of the connection created by sceHttpCreateConnection or sceHttpCreateConnectionWithURL
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpDeleteConnection(connectionid: c_int) callconv(.C) c_int;

pub extern fn sceHttpIsRequestInCache() callconv(.C) void;

pub extern fn sceHttpsSetSslCallback() callconv(.C) void;

pub extern fn sceHttpEnableCache(id: c_int) callconv(.C) c_int;

pub extern fn sceHttpsInitWithPath() callconv(.C) void;

pub extern fn sceHttp_739C2D79() callconv(.C) void;

/// Save cookie
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpSaveSystemCookie() callconv(.C) c_int;

pub extern fn sceHttpAddCookie() callconv(.C) void;

pub extern fn sceHttp_77EE5319() callconv(.C) void;

/// Enable keep alive
/// `id` - ID of the template or connection
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpEnableKeepAlive(id: c_int) callconv(.C) c_int;

pub extern fn sceHttpEndCache() callconv(.C) c_int;

pub extern fn sceHttp_8046E250() callconv(.C) void;

/// Load default certificate
/// `unknown1` - Pass 0
/// `unknown2` - Pass 0
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpsLoadDefaultCert(unknown1: c_int, unknown2: c_int) callconv(.C) c_int;

pub extern fn sceHttp_87F1E666() callconv(.C) void;

/// Set connect timeout
/// `id` - ID of the template, connection or request
/// `timeout` - Timeout value in microseconds
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpSetConnectTimeOut(id: c_int, timeout: c_uint) callconv(.C) c_int;

/// Create a http connection.
/// `templateid` - ID of the template created by sceHttpCreateTemplate
/// `host` - Host to connect to
/// `unknown1` - Pass "http"
/// `port` - Port to connect on
/// `unknown2` - Pass 0
/// Returns A connection ID on success, < 0 on error.
pub extern fn sceHttpCreateConnection(templateid: c_int, host: [*c]c_char, unknown1: [*c]c_char, port: c_ushort, unknown2: c_int) callconv(.C) c_int;

pub extern fn sceHttp_951D310E() callconv(.C) void;

pub extern fn sceHttpSetRecvBlockSize() callconv(.C) void;

pub extern fn sceHttpGetCookie() callconv(.C) void;

/// Set send timeout
/// `id` - ID of the template, connection or request
/// `timeout` - Timeout value in microseconds
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpSetSendTimeOut(id: c_int, timeout: c_uint) callconv(.C) c_int;

pub extern fn sceHttpSendRequestInCacheFirstMode() callconv(.C) void;

/// Create a http template.
/// `agent` - User agent
/// `unknown1` - Pass 1
/// `unknown2` - Pass 0
/// Returns A template ID on success, < 0 on error.
pub extern fn sceHttpCreateTemplate(agent: [*c]c_char, unknown1: c_int, unknown2: c_int) callconv(.C) c_int;

pub extern fn sceHttpEnableAuth(id: c_int) callconv(.C) c_int;

pub extern fn sceHttpSetRedirectCallback() callconv(.C) void;

pub extern fn sceHttp_A461A167() callconv(.C) void;

/// Delete a http request.
/// `requestid` - ID of the request created by sceHttpCreateRequest or sceHttpCreateRequestWithURL
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpDeleteRequest(requestid: c_int) callconv(.C) c_int;

pub extern fn sceHttpInitCache(max_size: types.SceSize) callconv(.C) c_int;

pub extern fn sceHttp_A909F2AE() callconv(.C) void;

pub extern fn sceHttpsGetSslError() callconv(.C) void;

/// Init the http library.
/// `unknown1` - Memory pool size? Pass 20000
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpInit(unknown1: c_uint) callconv(.C) c_int;

pub extern fn sceHttpDisableAuth(id: c_int) callconv(.C) c_int;

pub extern fn sceHttp_B0257723() callconv(.C) void;

pub extern fn sceHttpSetCacheContentLengthMaxSize() callconv(.C) void;

pub extern fn sceHttpsDisableOption() callconv(.C) void;

/// Create a http request with url.
/// `connectionid` - ID of the connection created by sceHttpCreateConnection or sceHttpCreateConnectionWithURL
/// `method` - One of ::PspHttpMethod
/// `url` - url to access
/// `contentlength` - Length of the content (POST method only)
/// Returns A request ID on success, < 0 on error.
pub extern fn sceHttpCreateRequestWithURL(connectionid: c_int, method: c_int, url: [*c]c_char, contentlength: types.SceULong64) callconv(.C) c_int;

pub extern fn sceHttpsEnableOption() callconv(.C) void;

/// Send a http request.
/// `requestid` - ID of the request created by sceHttpCreateRequest or sceHttpCreateRequestWithURL
/// `data` - For POST methods specify a pointer to the post data, otherwise pass NULL
/// `datasize` - For POST methods specify the size of the post data, otherwise pass 0
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpSendRequest(requestid: c_int, data: ?*anyopaque, datasize: c_uint) callconv(.C) c_int;

pub extern fn sceHttp_C0E69162() callconv(.C) void;

/// Abort a http request.
/// `requestid` - ID of the request created by sceHttpCreateRequest or sceHttpCreateRequestWithURL
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpAbortRequest(requestid: c_int) callconv(.C) c_int;

pub extern fn sceHttp_C6330B0D() callconv(.C) void;

/// Disable keep alive
/// `id` - ID of the template or connection
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpDisableKeepAlive(id: c_int) callconv(.C) c_int;

pub extern fn sceHttpSetResHeaderMaxSize(id: c_int, header_size: c_uint) callconv(.C) c_int;

pub extern fn sceHttp_CC920C12() callconv(.C) void;

pub extern fn sceHttpDisableCache(id: c_int) callconv(.C) c_int;

pub extern fn sceHttp_CDB0DC58() callconv(.C) void;

/// Create a http connection to a url.
/// `templateid` - ID of the template created by sceHttpCreateTemplate
/// `url` - url to connect to
/// `unknown1` - Pass 0
/// Returns A connection ID on success, < 0 on error.
pub extern fn sceHttpCreateConnectionWithURL(templateid: c_int, url: [*c]const c_char, unknown1: c_int) callconv(.C) c_int;

pub extern fn sceHttpGetNetworkErrno(request: c_int, err_num: [*c]c_int) callconv(.C) c_int;

pub extern fn sceHttpsGetCaList() callconv(.C) void;

/// Terminate the http library.
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpEnd() callconv(.C) c_int;

pub extern fn sceHttp_D29163DA() callconv(.C) void;

pub extern fn sceHttpGetProxy(id: c_int, activate_flag: [*c]c_int, mode: [*c]c_int, proxy_host: [*c]u8, len: types.SceSize, proxy_port: [*c]c_ushort) callconv(.C) c_int;

pub extern fn sceHttp_D80BE761() callconv(.C) void;

pub extern fn sceHttpGetAllHeader(request: c_int, header: [*c]u8, header_size: [*c]c_uint) callconv(.C) c_int;

pub extern fn sceHttp_DD6E7857() callconv(.C) void;

/// Init the https library.
/// `unknown1` - Pass 0
/// `unknown2` - Pass 0
/// `unknown3` - Pass 0
/// `unknown4` - Pass 0
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpsInit(unknown1: c_int, unknown2: c_int, unknown3: c_int, unknown4: c_int) callconv(.C) c_int;

/// Read a http request response.
/// `requestid` - ID of the request created by sceHttpCreateRequest or sceHttpCreateRequestWithURL
/// `data` - Buffer for the response data to be stored
/// `datasize` - Size of the buffer
/// Returns The size read into the data buffer, 0 if there is no more data, < 0 on error.
pub extern fn sceHttpReadData(requestid: c_int, data: ?*anyopaque, datasize: c_uint) callconv(.C) c_int;

pub extern fn sceHttpSetProxy(id: c_int, activate_flag: c_int, mode: c_int, new_proxy_host: [*c]const u8, new_proxy_port: c_ushort) callconv(.C) c_int;

/// Load cookie
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpLoadSystemCookie() callconv(.C) c_int;

pub extern fn sceHttpSetMallocFunction(malloc_func: c_int, free_func: c_int, realloc_func: c_int) callconv(.C) c_int;

/// Terminate the https library
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpsEnd() callconv(.C) c_int;

/// Delete a http template.
/// `templateid` - ID of the template created by sceHttpCreateTemplate
/// Returns 0 on success, < 0 on error.
pub extern fn sceHttpDeleteTemplate(templateid: c_int) callconv(.C) c_int;

comptime {
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
    asm(macro.generic_abi_wrapper("sceHttpCreateConnection", 5));
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
    asm(macro.generic_abi_wrapper("sceHttpGetProxy", 6));
    asm(macro.import_function("sceHttp", "0xD80BE761", "sceHttp_D80BE761"));
    asm(macro.import_function("sceHttp", "0xDB266CCF", "sceHttpGetAllHeader"));
    asm(macro.import_function("sceHttp", "0xDD6E7857", "sceHttp_DD6E7857"));
    asm(macro.import_function("sceHttp", "0xE4D21302", "sceHttpsInit"));
    asm(macro.import_function("sceHttp", "0xEDEEB999", "sceHttpReadData"));
    asm(macro.import_function("sceHttp", "0xF0F46C62", "sceHttpSetProxy_stub"));
    asm(macro.generic_abi_wrapper("sceHttpSetProxy", 5));
    asm(macro.import_function("sceHttp", "0xF1657B22", "sceHttpLoadSystemCookie"));
    asm(macro.import_function("sceHttp", "0xF49934F6", "sceHttpSetMallocFunction"));
    asm(macro.import_function("sceHttp", "0xF9D8EB63", "sceHttpsEnd"));
    asm(macro.import_function("sceHttp", "0xFCF8C055", "sceHttpDeleteTemplate"));
}
