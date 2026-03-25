// HTTP client -- PSP firmware HTTP API
//
// Wraps:
//   c/module/sceHttp.zig

const c = @import("../c/modules.zig");
const internal = @import("internal.zig");
const check = internal.check;
const checkPositive = internal.checkPositive;
const Error = internal.Error;

const http = c.sceHttp;

// -- Re-exported types -------------------------------------------------

pub const Method = c.types.PspHttpMethod;
pub const PasswordCB = c.types.PspHttpPasswordCB;
pub const MallocFunction = c.types.PspHttpMallocFunction;
pub const FreeFunction = c.types.PspHttpFreeFunction;
pub const ReallocFunction = c.types.PspHttpReallocFunction;

// -- Lifecycle ---------------------------------------------------------

pub fn init(pool_size: u32) Error!void {
    return check(http.sceHttpInit(@as(c_uint, pool_size)));
}

pub fn end() Error!void {
    return check(http.sceHttpEnd());
}

pub fn https_init(unk1: i32, unk2: i32, unk3: i32, unk4: i32) Error!void {
    return check(http.sceHttpsInit(@as(c_int, unk1), @as(c_int, unk2), @as(c_int, unk3), @as(c_int, unk4)));
}

pub fn https_end() Error!void {
    return check(http.sceHttpsEnd());
}

pub fn https_load_default_cert(unk1: i32, unk2: i32) Error!void {
    return check(http.sceHttpsLoadDefaultCert(@as(c_int, unk1), @as(c_int, unk2)));
}

// -- Template ----------------------------------------------------------

pub fn create_template(agent: [*:0]const u8, unk1: i32, unk2: i32) Error!i32 {
    const ret = http.sceHttpCreateTemplate(@ptrCast(@constCast(agent)), @as(c_int, unk1), @as(c_int, unk2));
    return checkPositive(ret);
}

pub fn delete_template(template_id: i32) Error!void {
    return check(http.sceHttpDeleteTemplate(@as(c_int, template_id)));
}

// -- Connection --------------------------------------------------------

pub fn create_connection(template_id: i32, host: [*:0]const u8, scheme: [*:0]const u8, port: u16, unk: i32) Error!i32 {
    const ret = http.sceHttpCreateConnection(@as(c_int, template_id), @ptrCast(@constCast(host)), @ptrCast(@constCast(scheme)), @as(c_ushort, port), @as(c_int, unk));
    return checkPositive(ret);
}

pub fn create_connection_with_url(template_id: i32, url: [*:0]const u8, unk: i32) Error!i32 {
    const ret = http.sceHttpCreateConnectionWithURL(@as(c_int, template_id), url, @as(c_int, unk));
    return checkPositive(ret);
}

pub fn delete_connection(connection_id: i32) Error!void {
    return check(http.sceHttpDeleteConnection(@as(c_int, connection_id)));
}

// -- Request -----------------------------------------------------------

pub fn create_request(connection_id: i32, method: Method, path: [*:0]const u8, content_length: u64) Error!i32 {
    const ret = http.sceHttpCreateRequest(@as(c_int, connection_id), method, @ptrCast(@constCast(path)), content_length);
    return checkPositive(ret);
}

pub fn create_request_with_url(connection_id: i32, method: Method, url: [*:0]const u8, content_length: u64) Error!i32 {
    const ret = http.sceHttpCreateRequestWithURL(@as(c_int, connection_id), method, @ptrCast(@constCast(url)), content_length);
    return checkPositive(ret);
}

pub fn delete_request(request_id: i32) Error!void {
    return check(http.sceHttpDeleteRequest(@as(c_int, request_id)));
}

pub fn send_request(request_id: i32, data: ?*anyopaque, datasize: u32) Error!void {
    return check(http.sceHttpSendRequest(@as(c_int, request_id), data, @as(c_uint, datasize)));
}

pub fn abort_request(request_id: i32) Error!void {
    return check(http.sceHttpAbortRequest(@as(c_int, request_id)));
}

pub fn read_data(request_id: i32, data: ?*anyopaque, datasize: u32) Error!i32 {
    const ret = http.sceHttpReadData(@as(c_int, request_id), data, @as(c_uint, datasize));
    return checkPositive(ret);
}

pub fn get_content_length(request_id: i32, content_length: *u64) Error!void {
    return check(http.sceHttpGetContentLength(@as(c_int, request_id), content_length));
}

pub fn get_status_code(request_id: i32, status_code: *i32) Error!void {
    return check(http.sceHttpGetStatusCode(@as(c_int, request_id), @ptrCast(status_code)));
}

pub fn get_all_header(request_id: i32, header: [*c]u8, header_size: *u32) Error!void {
    return check(http.sceHttpGetAllHeader(@as(c_int, request_id), header, @ptrCast(header_size)));
}

pub fn get_network_errno(request_id: i32, err_num: *i32) Error!void {
    return check(http.sceHttpGetNetworkErrno(@as(c_int, request_id), @ptrCast(err_num)));
}

// -- Headers -----------------------------------------------------------

pub fn add_extra_header(id: i32, name: [*:0]const u8, value: [*:0]const u8, unk: i32) Error!void {
    return check(http.sceHttpAddExtraHeader(@as(c_int, id), @ptrCast(@constCast(name)), @ptrCast(@constCast(value)), @as(c_int, unk)));
}

pub fn delete_header(id: i32, name: [*:0]const u8) Error!void {
    return check(http.sceHttpDeleteHeader(@as(c_int, id), @ptrCast(@constCast(name))));
}

pub fn set_res_header_max_size(id: i32, header_size: u32) Error!void {
    return check(http.sceHttpSetResHeaderMaxSize(@as(c_int, id), @as(c_uint, header_size)));
}

// -- Timeouts ----------------------------------------------------------

pub fn set_resolve_timeout(id: i32, timeout: u32) Error!void {
    return check(http.sceHttpSetResolveTimeOut(@as(c_int, id), @as(c_uint, timeout)));
}

pub fn set_resolve_retry(id: i32, count: i32) Error!void {
    return check(http.sceHttpSetResolveRetry(@as(c_int, id), @as(c_int, count)));
}

pub fn set_connect_timeout(id: i32, timeout: u32) Error!void {
    return check(http.sceHttpSetConnectTimeOut(@as(c_int, id), @as(c_uint, timeout)));
}

pub fn set_send_timeout(id: i32, timeout: u32) Error!void {
    return check(http.sceHttpSetSendTimeOut(@as(c_int, id), @as(c_uint, timeout)));
}

pub fn set_recv_timeout(id: i32, timeout: u32) Error!void {
    return check(http.sceHttpSetRecvTimeOut(@as(c_int, id), @as(c_uint, timeout)));
}

// -- Feature toggles --------------------------------------------------

pub fn enable_keep_alive(id: i32) Error!void {
    return check(http.sceHttpEnableKeepAlive(@as(c_int, id)));
}

pub fn disable_keep_alive(id: i32) Error!void {
    return check(http.sceHttpDisableKeepAlive(@as(c_int, id)));
}

pub fn enable_redirect(id: i32) Error!void {
    return check(http.sceHttpEnableRedirect(@as(c_int, id)));
}

pub fn disable_redirect(id: i32) Error!void {
    return check(http.sceHttpDisableRedirect(@as(c_int, id)));
}

pub fn enable_cookie(id: i32) Error!void {
    return check(http.sceHttpEnableCookie(@as(c_int, id)));
}

pub fn disable_cookie(id: i32) Error!void {
    return check(http.sceHttpDisableCookie(@as(c_int, id)));
}

pub fn enable_auth(id: i32) Error!void {
    return check(http.sceHttpEnableAuth(@as(c_int, id)));
}

pub fn disable_auth(id: i32) Error!void {
    return check(http.sceHttpDisableAuth(@as(c_int, id)));
}

pub fn enable_cache(id: i32) Error!void {
    return check(http.sceHttpEnableCache(@as(c_int, id)));
}

pub fn disable_cache(id: i32) Error!void {
    return check(http.sceHttpDisableCache(@as(c_int, id)));
}

// -- Cookie persistence ------------------------------------------------

pub fn save_system_cookie() Error!void {
    return check(http.sceHttpSaveSystemCookie());
}

pub fn load_system_cookie() Error!void {
    return check(http.sceHttpLoadSystemCookie());
}

// -- Cache -------------------------------------------------------------

pub fn init_cache(max_size: usize) Error!void {
    return check(http.sceHttpInitCache(max_size));
}

pub fn end_cache() Error!void {
    return check(http.sceHttpEndCache());
}

// -- Proxy -------------------------------------------------------------

pub fn set_proxy(id: i32, activate_flag: i32, mode: i32, host: [*:0]const u8, port: u16) Error!void {
    return check(http.sceHttpSetProxy(@as(c_int, id), @as(c_int, activate_flag), @as(c_int, mode), host, @as(c_ushort, port)));
}

pub fn get_proxy(id: i32, activate_flag: *i32, mode: *i32, proxy_host: [*]u8, len: usize, proxy_port: *u16) Error!void {
    return check(http.sceHttpGetProxy(@as(c_int, id), @ptrCast(activate_flag), @ptrCast(mode), proxy_host, len, @ptrCast(proxy_port)));
}

// -- Auth / malloc -----------------------------------------------------

pub fn set_auth_info_cb(id: i32, cbfunc: PasswordCB) Error!void {
    return check(http.sceHttpSetAuthInfoCB(@as(c_int, id), cbfunc));
}

pub fn set_malloc_function(malloc_func: MallocFunction, free_func: FreeFunction, realloc_func: ReallocFunction) Error!void {
    return check(http.sceHttpSetMallocFunction(malloc_func, free_func, realloc_func));
}
