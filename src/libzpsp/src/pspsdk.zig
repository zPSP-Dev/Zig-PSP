const options = @import("libzpsp_option");
const types = @import("psptypes.zig");

pub const SceUID = types.SceUID;
pub const SceSize = types.SceSize;
pub const SceSSize = types.SceSSize;
pub const SceUChar = types.SceUChar;
pub const SceUInt = types.SceUInt;
pub const SceMode = types.SceMode;
pub const SceOff = types.SceOff;
pub const SceIores = types.SceIores;
pub const SceUChar8 = types.SceUChar8;
pub const SceUShort16 = types.SceUShort16;
pub const SceUInt32 = types.SceUInt32;
pub const SceUInt64 = types.SceUInt64;
pub const SceULong64 = types.SceULong64;
pub const SceChar8 = types.SceChar8;
pub const SceShort16 = types.SceShort16;
pub const SceInt32 = types.SceInt32;
pub const SceInt64 = types.SceInt64;
pub const SceLong64 = types.SceLong64;
pub const SceFloat = types.SceFloat;
pub const SceFloat32 = types.SceFloat32;
pub const SceWChar16 = types.SceWChar16;
pub const SceWChar32 = types.SceWChar32;
pub const SceBool = types.SceBool;
pub const SceVoid = types.SceVoid;
pub const ScePVoid = types.ScePVoid;

pub const ScePspSRect = types.ScePspSRect;
pub const ScePspIRect = types.ScePspIRect;
pub const ScePspL64Rect = types.ScePspL64Rect;
pub const ScePspFRect = types.ScePspFRect;
pub const ScePspSVector2 = types.ScePspSVector2;
pub const ScePspIVector2 = types.ScePspIVector2;
pub const ScePspL64Vector2 = types.ScePspL64Vector2;
pub const ScePspFVector2 = types.ScePspFVector2;
pub const ScePspVector2 = types.ScePspVector2;
pub const ScePspSVector3 = types.ScePspSVector3;
pub const ScePspIVector3 = types.ScePspIVector3;
pub const ScePspL64Vector3 = types.ScePspL64Vector3;
pub const ScePspFVector3 = types.ScePspFVector3;
pub const ScePspVector3 = types.ScePspVector3;
pub const ScePspSVector4 = types.ScePspSVector4;
pub const ScePspIVector4 = types.ScePspIVector4;
pub const ScePspL64Vector4 = types.ScePspL64Vector4;
pub const ScePspFVector4 = types.ScePspFVector4;
pub const ScePspFVector4Unaligned = types.ScePspFVector4Unaligned;
pub const ScePspVector4 = types.ScePspVector4;
pub const ScePspIMatrix2 = types.ScePspIMatrix2;
pub const ScePspFMatrix2 = types.ScePspFMatrix2;
pub const ScePspMatrix2 = types.ScePspMatrix2;
pub const ScePspIMatrix3 = types.ScePspIMatrix3;
pub const ScePspFMatrix3 = types.ScePspFMatrix3;
pub const ScePspMatrix3 = types.ScePspMatrix3;
pub const ScePspIMatrix4 = types.ScePspIMatrix4;
pub const ScePspIMatrix4Unaligned = types.ScePspIMatrix4Unaligned;
pub const ScePspFMatrix4 = types.ScePspFMatrix4;
pub const ScePspFMatrix4Unaligned = types.ScePspFMatrix4Unaligned;
pub const ScePspMatrix4 = types.ScePspMatrix4;
pub const ScePspFQuaternion = types.ScePspFQuaternion;
pub const ScePspFQuaternionUnaligned = types.ScePspFQuaternionUnaligned;
pub const ScePspFColor = types.ScePspFColor;
pub const ScePspFColorUnaligned = types.ScePspFColorUnaligned;
pub const ScePspRGBA8888 = types.ScePspRGBA8888;
pub const ScePspRGBA4444 = types.ScePspRGBA4444;
pub const ScePspRGBA5551 = types.ScePspRGBA5551;
pub const ScePspRGB565 = types.ScePspRGB565;
pub const ScePspUnion32 = types.ScePspUnion32;
pub const ScePspUnion64 = types.ScePspUnion64;
pub const ScePspUnion128 = types.ScePspUnion128;
pub const ScePspDateTime = types.ScePspDateTime;

const EMPTY = struct {};

const scePower = struct {
    pub extern fn scePowerGetWlanActivity() callconv(.C) void;

    pub extern fn scePowerGetBacklightMaximum() callconv(.C) void;

    /// Generate a power tick, preventing unit from
    /// powering off and turning off display.
    /// `type` - Either PSP_POWER_TICK_ALL, PSP_POWER_TICK_SUSPEND or PSP_POWER_TICK_DISPLAY
    /// Returns 0 on success, < 0 on error.
    pub extern fn scePowerTick(type: c_int) callconv(.C) c_int;

    /// Get Idle timer
    pub extern fn scePowerGetIdleTimer() callconv(.C) c_int;

    /// Enable Idle timer
    /// `unknown` - pass 0
    pub extern fn scePowerIdleTimerEnable(unknown: c_int) callconv(.C) c_int;

    /// Disable Idle timer
    /// `unknown` - pass 0
    pub extern fn scePowerIdleTimerDisable(unknown: c_int) callconv(.C) c_int;

    pub extern fn scePowerBatteryUpdateInfo() callconv(.C) void;

    pub extern fn scePowerGetForceSuspendCapacity() callconv(.C) void;

    pub extern fn scePowerGetLowBatteryCapacity() callconv(.C) void;

    /// Check if unit is plugged in
    /// Returns 1 if plugged in, 0 if not plugged in, < 0 on error.
    pub extern fn scePowerIsPowerOnline() callconv(.C) c_int;

    /// Check if a battery is present
    /// Returns 1 if battery present, 0 if battery not present, < 0 on error.
    pub extern fn scePowerIsBatteryExist() callconv(.C) c_int;

    /// Check if the battery is charging
    /// Returns 1 if battery charging, 0 if battery not charging, < 0 on error.
    pub extern fn scePowerIsBatteryCharging() callconv(.C) c_int;

    /// Get the status of the battery charging
    pub extern fn scePowerGetBatteryChargingStatus() callconv(.C) c_int;

    /// Check if the battery is low
    /// Returns 1 if the battery is low, 0 if the battery is not low, < 0 on error.
    pub extern fn scePowerIsLowBattery() callconv(.C) c_int;

    /// Check if a suspend is required
    /// Returns 1 if suspend is required, 0 otherwise
    pub extern fn scePowerIsSuspendRequired() callconv(.C) c_int;

    /// Returns battery remaining capacity
    /// Returns battery remaining capacity in mAh (milliampere hour)
    pub extern fn scePowerGetBatteryRemainCapacity() callconv(.C) c_int;

    /// Returns battery full capacity
    /// Returns battery full capacity in mAh (milliampere hour)
    pub extern fn scePowerGetBatteryFullCapacity() callconv(.C) c_int;

    /// Get battery life as integer percent
    /// Returns Battery charge percentage (0-100), < 0 on error.
    pub extern fn scePowerGetBatteryLifePercent() callconv(.C) c_int;

    /// Get battery life as time
    /// Returns Battery life in minutes, < 0 on error.
    pub extern fn scePowerGetBatteryLifeTime() callconv(.C) c_int;

    /// Get temperature of the battery
    pub extern fn scePowerGetBatteryTemp() callconv(.C) c_int;

    /// unknown? - crashes PSP in usermode
    pub extern fn scePowerGetBatteryElec() callconv(.C) c_int;

    /// Get battery volt level
    pub extern fn scePowerGetBatteryVolt() callconv(.C) c_int;

    pub extern fn scePowerGetInnerTemp() callconv(.C) void;

    pub extern fn scePowerSetPowerSwMode() callconv(.C) void;

    pub extern fn scePowerGetPowerSwMode() callconv(.C) void;

    /// Lock power switch
    /// Note: if the power switch is toggled while locked
    /// it will fire immediately after being unlocked.
    /// `unknown` - pass 0
    /// Returns 0 on success, < 0 on error.
    pub extern fn scePowerLock(unknown: c_int) callconv(.C) c_int;

    /// Unlock power switch
    /// `unknown` - pass 0
    /// Returns 0 on success, < 0 on error.
    pub extern fn scePowerUnlock(unknown: c_int) callconv(.C) c_int;

    pub extern fn scePowerCancelRequest() callconv(.C) void;

    pub extern fn scePowerIsRequest() callconv(.C) void;

    /// Request the PSP to go into standby
    /// Returns 0 always
    pub extern fn scePowerRequestStandby() callconv(.C) c_int;

    /// Request the PSP to go into suspend
    /// Returns 0 always
    pub extern fn scePowerRequestSuspend() callconv(.C) c_int;

    pub extern fn scePowerRequestSuspendTouchAndGo() callconv(.C) void;

    pub extern fn scePowerEncodeUBattery() callconv(.C) void;

    pub extern fn scePowerGetResumeCount() callconv(.C) void;

    /// Register Power Callback Function
    /// `slot` - slot of the callback in the list, 0 to 15, pass -1 to get an auto assignment.
    /// `cbid` - callback id from calling sceKernelCreateCallback
    /// Returns 0 on success, the slot number if -1 is passed, < 0 on error.
    pub extern fn scePowerRegisterCallback(slot: c_int, cbid: SceUID) callconv(.C) c_int;

    /// Unregister Power Callback Function
    /// `slot` - slot of the callback
    /// Returns 0 on success, < 0 on error.
    pub extern fn scePowerUnregisterCallback(slot: c_int) callconv(.C) c_int;

    pub extern fn scePowerUnregitserCallback() callconv(.C) void;

    /// Set CPU Frequency
    /// `cpufreq` - new CPU frequency, valid values are 1 - 333
    pub extern fn scePowerSetCpuClockFrequency(cpufreq: c_int) callconv(.C) c_int;

    /// Set Bus Frequency
    /// `busfreq` - new BUS frequency, valid values are 1 - 167
    pub extern fn scePowerSetBusClockFrequency(busfreq: c_int) callconv(.C) c_int;

    /// Alias for scePowerGetCpuClockFrequencyInt
    /// Returns frequency as int
    pub extern fn scePowerGetCpuClockFrequency() callconv(.C) c_int;

    /// Alias for scePowerGetBusClockFrequencyInt
    /// Returns frequency as int
    pub extern fn scePowerGetBusClockFrequency() callconv(.C) c_int;

    /// Get CPU Frequency as Integer
    /// Returns frequency as int
    pub extern fn scePowerGetCpuClockFrequencyInt() callconv(.C) c_int;

    /// Get Bus fequency as Integer
    /// Returns frequency as int
    pub extern fn scePowerGetBusClockFrequencyInt() callconv(.C) c_int;

    /// Get CPU Frequency as Float
    /// Returns frequency as float
    pub extern fn scePowerGetCpuClockFrequencyFloat() callconv(.C) f32;

    /// Get Bus frequency as Float
    /// Returns frequency as float
    pub extern fn scePowerGetBusClockFrequencyFloat() callconv(.C) f32;

    /// Set Clock Frequencies
    /// `pllfreq` - pll frequency, valid from 19-333
    /// `cpufreq` - cpu frequency, valid from 1-333
    /// `busfreq` - bus frequency, valid from 1-167
    /// and:
    /// cpufreq <= pllfreq
    /// busfreq*2 <= pllfreq
    pub extern fn scePowerSetClockFrequency(pllfreq: c_int, cpufreq: c_int, busfreq: c_int) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "scePower") and options.scePower)) scePower else EMPTY;

const sceNetInet = struct {
    pub extern fn sceNetInetInit() callconv(.C) c_int;

    pub extern fn sceNetInetTerm() callconv(.C) c_int;

    pub extern fn sceNetInetAccept() callconv(.C) void;

    pub extern fn sceNetInetBind() callconv(.C) void;

    pub extern fn sceNetInetClose(s: c_int) callconv(.C) c_int;

    pub extern fn sceNetInetCloseWithRST() callconv(.C) void;

    pub extern fn sceNetInetConnect() callconv(.C) void;

    pub extern fn sceNetInetGetpeername() callconv(.C) void;

    pub extern fn sceNetInetGetsockname() callconv(.C) void;

    pub extern fn sceNetInetGetsockopt() callconv(.C) void;

    pub extern fn sceNetInetListen() callconv(.C) void;

    pub extern fn sceNetInetPoll() callconv(.C) void;

    pub extern fn sceNetInetRecv() callconv(.C) void;

    pub extern fn sceNetInetRecvfrom() callconv(.C) void;

    pub extern fn sceNetInetRecvmsg(s: c_int, msg: [*c]c_int, flags: c_int) callconv(.C) isize;

    pub extern fn sceNetInetSelect(n: c_int, readfds: [*c]c_int, writefds: [*c]c_int, exceptfds: [*c]c_int, timeout: [*c]c_int) callconv(.C) c_int;

    pub extern fn sceNetInetSend() callconv(.C) void;

    pub extern fn sceNetInetSendto() callconv(.C) void;

    pub extern fn sceNetInetSendmsg(s: c_int, msg: [*c]const c_int, flags: c_int) callconv(.C) isize;

    pub extern fn sceNetInetSetsockopt() callconv(.C) void;

    pub extern fn sceNetInetShutdown() callconv(.C) void;

    pub extern fn sceNetInetSocket() callconv(.C) void;

    pub extern fn sceNetInetSocketAbort() callconv(.C) void;

    pub extern fn sceNetInetGetErrno() callconv(.C) c_int;

    pub extern fn sceNetInetGetTcpcbstat() callconv(.C) void;

    pub extern fn sceNetInetGetUdpcbstat() callconv(.C) void;

    pub extern fn sceNetInetInetAddr() callconv(.C) void;

    pub extern fn sceNetInetInetAton() callconv(.C) void;

    pub extern fn sceNetInetInetNtop() callconv(.C) void;

    pub extern fn sceNetInetInetPton() callconv(.C) void;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceNetInet") and options.sceNetInet)) sceNetInet else EMPTY;

const sceNetApctl = struct {
    /// Init the apctl.
    /// `stackSize` - The stack size of the internal thread.
    /// `initPriority` - The priority of the internal thread.
    /// Returns < 0 on error.
    pub extern fn sceNetApctlInit(stackSize: c_int, initPriority: c_int) callconv(.C) c_int;

    /// Terminate the apctl.
    /// Returns < 0 on error.
    pub extern fn sceNetApctlTerm() callconv(.C) c_int;

    /// Get the apctl information.
    /// `code` - One of the PSP_NET_APCTL_INFO_* defines.
    /// `pInfo` - Pointer to a ::SceNetApctlInfo.
    /// Returns < 0 on error.
    pub extern fn sceNetApctlGetInfo(code: c_int, pInfo: [*c]c_int) callconv(.C) c_int;

    /// Add an apctl event handler.
    /// `handler` - Pointer to the event handler function.
    /// `pArg` - Value to be passed to the pArg parameter of the handler function.
    /// Returns A handler id or < 0 on error.
    pub extern fn sceNetApctlAddHandler(handler: c_int, pArg: ?*anyopaque) callconv(.C) c_int;

    /// Delete an apctl event handler.
    /// `handlerId` - A handler as created returned from sceNetApctlAddHandler.
    /// Returns < 0 on error.
    pub extern fn sceNetApctlDelHandler(handlerId: c_int) callconv(.C) c_int;

    /// Connect to an access point.
    /// `connIndex` - The index of the connection.
    /// Returns < 0 on error.
    pub extern fn sceNetApctlConnect(connIndex: c_int) callconv(.C) c_int;

    /// Disconnect from an access point.
    /// Returns < 0 on error.
    pub extern fn sceNetApctlDisconnect() callconv(.C) c_int;

    /// Get the state of the access point connection.
    /// `pState` - Pointer to receive the current state (one of the PSP_NET_APCTL_STATE_* defines).
    /// Returns < 0 on error.
    pub extern fn sceNetApctlGetState(pState: [*c]c_int) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceNetApctl") and options.sceNetApctl)) sceNetApctl else EMPTY;

const sceHttp = struct {
    /// Get http request response length.
    /// `requestid` - ID of the request created by sceHttpCreateRequest or sceHttpCreateRequestWithURL
    /// `contentlength` - The size of the content
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceHttpGetContentLength(requestid: c_int, contentlength: [*c]SceULong64) callconv(.C) c_int;

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
    pub extern fn sceHttpCreateRequest(connectionid: c_int, method: c_int, path: [*c]c_char, contentlength: SceULong64) callconv(.C) c_int;

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

    pub extern fn sceHttpInitCache(max_size: SceSize) callconv(.C) c_int;

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
    pub extern fn sceHttpCreateRequestWithURL(connectionid: c_int, method: c_int, url: [*c]c_char, contentlength: SceULong64) callconv(.C) c_int;

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

    pub extern fn sceHttpGetProxy(id: c_int, activate_flag: [*c]c_int, mode: [*c]c_int, proxy_host: [*c]u8, len: SceSize, proxy_port: [*c]c_ushort) callconv(.C) c_int;

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

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceHttp") and options.sceHttp)) sceHttp else EMPTY;

const sceNet = struct {
    /// Initialise the networking library
    /// `poolsize` - Memory pool size (appears to be for the whole of the networking library).
    /// `calloutprio` - Priority of the SceNetCallout thread.
    /// `calloutstack` - Stack size of the SceNetCallout thread (defaults to 4096 on non 1.5 firmware regardless of what value is passed).
    /// `netintrprio` - Priority of the SceNetNetintr thread.
    /// `netintrstack` - Stack size of the SceNetNetintr thread (defaults to 4096 on non 1.5 firmware regardless of what value is passed).
    /// Returns 0 on success, < 0 on error
    pub extern fn sceNetInit(poolsize: c_int, calloutprio: c_int, calloutstack: c_int, netintrprio: c_int, netintrstack: c_int) callconv(.C) c_int;

    /// Terminate the networking library
    /// Returns 0 on success, < 0 on error
    pub extern fn sceNetTerm() callconv(.C) c_int;

    /// Free (delete) thread info/data
    /// `thid` - The thread id.
    /// Returns 0 on success, < 0 on error
    pub extern fn sceNetFreeThreadinfo(thid: c_int) callconv(.C) c_int;

    /// Abort a thread
    /// `thid` - The thread id.
    /// Returns 0 on success, < 0 on error
    pub extern fn sceNetThreadAbort(thid: c_int) callconv(.C) c_int;

    /// Convert Mac address to a string
    /// `mac` - The Mac address to convert.
    /// `name` - Pointer to a buffer to store the result.
    pub extern fn sceNetEtherNtostr(mac: [*c]u8, name: [*c]c_char) callconv(.C) void;

    /// Convert string to a Mac address
    /// `name` - The string to convert.
    /// `mac` - Pointer to a buffer to store the result.
    pub extern fn sceNetEtherStrton(name: [*c]c_char, mac: [*c]u8) callconv(.C) void;

    /// Retrieve the local Mac address
    /// `mac` - Pointer to a buffer to store the result.
    /// Returns 0 on success, < 0 on error
    pub extern fn sceNetGetLocalEtherAddr(mac: [*c]u8) callconv(.C) c_int;

    /// Retrieve the networking library memory usage
    /// `stat` - Pointer to a ::SceNetMallocStat type to store the result.
    /// Returns 0 on success, < 0 on error
    pub extern fn sceNetGetMallocStat(stat: [*c]c_int) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceNet") and options.sceNet)) sceNet else EMPTY;

const sceNetResolver = struct {
    /// Inititalise the resolver library
    /// Returns 0 on sucess, < 0 on error.
    pub extern fn sceNetResolverInit() callconv(.C) c_int;

    /// Terminate the resolver library
    /// Returns 0 on success, < 0 on error
    pub extern fn sceNetResolverTerm() callconv(.C) c_int;

    /// Create a resolver object
    /// `rid` - Pointer to receive the resolver id
    /// `buf` - Temporary buffer
    /// `buflen` - Length of the temporary buffer
    /// Returns 0 on success, < 0 on error
    pub extern fn sceNetResolverCreate(rid: [*c]c_int, buf: ?*anyopaque, buflen: SceSize) callconv(.C) c_int;

    /// Delete a resolver
    /// `rid` - The resolver to delete
    /// Returns 0 on success, < 0 on error
    pub extern fn sceNetResolverDelete(rid: c_int) callconv(.C) c_int;

    /// Begin a name to address lookup
    /// `rid` - Resolver id
    /// `hostname` - Name to resolve
    /// `addr` - Pointer to in_addr structure to receive the address
    /// `timeout` - Number of seconds before timeout
    /// `retry` - Number of retires
    /// Returns 0 on success, < 0 on error
    pub extern fn sceNetResolverStartNtoA(rid: c_int, hostname: [*c]const c_char, addr: [*c]c_int, timeout: c_uint, retry: c_int) callconv(.C) c_int;

    /// Begin a address to name lookup
    /// `rid -Resolver id`
    /// `addr` - Pointer to the address to resolve
    /// `hostname` - Buffer to receive the name
    /// `hostname_len` - Length of the buffer
    /// `timeout` - Number of seconds before timeout
    /// `retry` - Number of retries
    /// Returns 0 on success, < 0 on error
    pub extern fn sceNetResolverStartAtoN(rid: c_int, addr: [*c]const c_int, hostname: [*c]c_char, hostname_len: SceSize, timeout: c_uint, retry: c_int) callconv(.C) c_int;

    /// Stop a resolver operation
    /// `rid` - Resolver id
    /// Returns 0 on success, < 0 on error
    pub extern fn sceNetResolverStop(rid: c_int) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceNetResolver") and options.sceNetResolver)) sceNetResolver else EMPTY;

const sceNet_lib = struct {
    pub extern fn sceNet_lib_3B617AA0() callconv(.C) void;

    pub extern fn sceNet_lib_DB88F458() callconv(.C) void;

    pub extern fn sceNet_lib_B6FC0A5B() callconv(.C) void;

    pub extern fn sceNet_lib_C431A214() callconv(.C) void;

    pub extern fn sceNet_lib_BFCFEFF6() callconv(.C) void;

    pub extern fn sceNet_lib_E1F4696F() callconv(.C) void;

    pub extern fn sceNet_lib_5216CBF5() callconv(.C) void;

    pub extern fn sceNet_lib_D2422E4D() callconv(.C) void;

    pub extern fn sceNet_lib_D1BE2CE9() callconv(.C) void;

    pub extern fn sceNet_lib_AB7DD9A5() callconv(.C) void;

    pub extern fn sceNet_lib_80E1933E() callconv(.C) void;

    pub extern fn sceNet_lib_7BA3ED91() callconv(.C) void;

    pub extern fn sceNet_lib_03164B12() callconv(.C) void;

    pub extern fn sceNet_lib_389728AB() callconv(.C) void;

    pub extern fn sceNet_lib_4BF9E1DE() callconv(.C) void;

    pub extern fn sceNet_lib_D5B64E37() callconv(.C) void;

    pub extern fn sceNet_lib_DA02F383() callconv(.C) void;

    pub extern fn sceNet_lib_AFA11338() callconv(.C) void;

    pub extern fn sceNet_lib_B20F84F8() callconv(.C) void;

    pub extern fn sceNet_lib_83FE280A() callconv(.C) void;

    pub extern fn sceNet_lib_4F8F3808() callconv(.C) void;

    pub extern fn sceNet_lib_891723D5() callconv(.C) void;

    pub extern fn sceNet_lib_0DFF67F9() callconv(.C) void;

    pub extern fn sceNet_lib_F355C73B() callconv(.C) void;

    pub extern fn sceNet_lib_A55C914F() callconv(.C) void;

    pub extern fn sceNet_lib_0D633F53() callconv(.C) void;

    pub extern fn sceNetConfigGetEtherAddr() callconv(.C) void;

    pub extern fn sceNet_lib_522A971B() callconv(.C) void;

    pub extern fn sceNetRand() callconv(.C) void;

    pub extern fn sceNet_lib_75D9985C() callconv(.C) void;

    pub extern fn sceNet_lib_25CC373A() callconv(.C) void;

    pub extern fn sceNet_lib_DCBC596E() callconv(.C) void;

    pub extern fn sceNet_lib_7C86FBA4() callconv(.C) void;

    pub extern fn sceNet_lib_A8B6205A() callconv(.C) void;

    pub extern fn sceNet_lib_A93A93E9() callconv(.C) void;

    pub extern fn sceNet_lib_6B294EE4() callconv(.C) void;

    pub extern fn sceNet_lib_51C209B2() callconv(.C) void;

    pub extern fn sceNet_lib_C9C97945() callconv(.C) void;

    pub extern fn sceNet_lib_B8C4A858() callconv(.C) void;

    pub extern fn sceNet_lib_205E8D17() callconv(.C) void;

    pub extern fn sceNet_lib_F6DB0A0B() callconv(.C) void;

    pub extern fn sceNet_lib_7574FDA1() callconv(.C) void;

    pub extern fn sceNet_lib_CA3CF5EB() callconv(.C) void;

    pub extern fn sceNet_lib_757085B0() callconv(.C) void;

    pub extern fn sceNet_lib_435843CB() callconv(.C) void;

    pub extern fn sceNet_lib_D861EF33() callconv(.C) void;

    pub extern fn sceNet_lib_BB2B3DDB() callconv(.C) void;

    pub extern fn sceNet_lib_6D5D42D7() callconv(.C) void;

    pub extern fn sceNet_lib_C21E18B2() callconv(.C) void;

    pub extern fn sceNet_lib_45452B7B() callconv(.C) void;

    pub extern fn sceNet_lib_94B44F26() callconv(.C) void;

    pub extern fn sceNet_lib_515B2F33() callconv(.C) void;

    pub extern fn sceNet_lib_6DC71518() callconv(.C) void;

    pub extern fn sceNet_lib_7C3B86C5() callconv(.C) void;

    pub extern fn sceNet_lib_05D525E4() callconv(.C) void;

    pub extern fn sceNet_lib_1D10419C() callconv(.C) void;

    pub extern fn sceNet_lib_C2EC2EEA() callconv(.C) void;

    pub extern fn sceNet_lib_710BD467() callconv(.C) void;

    pub extern fn sceNet_lib_701DDDC3() callconv(.C) void;

    pub extern fn sceNet_lib_D5A03BC0() callconv(.C) void;

    pub extern fn sceNet_lib_FA6DE6A6() callconv(.C) void;

    pub extern fn sceNet_lib_EDB11CB4() callconv(.C) void;

    pub extern fn sceNet_lib_8C55B410() callconv(.C) void;

    pub extern fn sceNet_lib_13A8B98A() callconv(.C) void;

    pub extern fn sceNet_lib_EA42B353() callconv(.C) void;

    pub extern fn sceNet_lib_45945E8D() callconv(.C) void;

    pub extern fn sceNet_lib_D60225A3() callconv(.C) void;

    pub extern fn sceNet_lib_EB6DE71A() callconv(.C) void;

    pub extern fn sceNet_lib_EDCC871E() callconv(.C) void;

    pub extern fn sceNet_lib_4B2B3416() callconv(.C) void;

    pub extern fn sceNet_lib_2B42872F() callconv(.C) void;

    pub extern fn sceNet_lib_C4261339() callconv(.C) void;

    pub extern fn sceNet_lib_41FD8B5C() callconv(.C) void;

    pub extern fn sceNet_lib_92633D8D() callconv(.C) void;

    pub extern fn sceNet_lib_B9C780C7() callconv(.C) void;

    pub extern fn sceNet_lib_B68E1EEA() callconv(.C) void;

    pub extern fn sceNet_lib_E155112D() callconv(.C) void;

    pub extern fn sceNet_lib_41621EB0() callconv(.C) void;

    pub extern fn sceNet_lib_2E005032() callconv(.C) void;

    pub extern fn sceNet_lib_33B230BD() callconv(.C) void;

    pub extern fn sceNet_lib_976AB1E9() callconv(.C) void;

    pub extern fn sceNet_lib_4C8FD452() callconv(.C) void;

    pub extern fn sceNet_lib_5ED457BE() callconv(.C) void;

    pub extern fn sceNet_lib_31F3CDA1() callconv(.C) void;

    pub extern fn sceNet_lib_1F94AFD9() callconv(.C) void;

    pub extern fn sceNet_lib_0A5A8751() callconv(.C) void;

    pub extern fn sceNet_lib_B3A48B7F() callconv(.C) void;

    pub extern fn sceNet_lib_949F1FBB() callconv(.C) void;

    pub extern fn sceNet_lib_13672F83() callconv(.C) void;

    pub extern fn sceNet_lib_5C7C7381() callconv(.C) void;

    pub extern fn sceNet_lib_86B6DCD9() callconv(.C) void;

    pub extern fn sceNet_lib_7AE91FB4() callconv(.C) void;

    pub extern fn sceNet_lib_572AD6ED() callconv(.C) void;

    pub extern fn sceNet_lib_87DC7A7E() callconv(.C) void;

    pub extern fn sceNet_lib_991FF86D() callconv(.C) void;

    pub extern fn sceNet_lib_5505D820() callconv(.C) void;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceNet_lib") and options.sceNet_lib)) sceNet_lib else EMPTY;

const sceNetAdhocctl = struct {
    /// Initialise the Adhoc control library
    /// `stacksize` - Stack size of the adhocctl thread. Set to 0x2000
    /// `priority` - Priority of the adhocctl thread. Set to 0x30
    /// `product` - Pass a filled in ::productStruct
    /// Returns 0 on success, < 0 on error
    pub extern fn sceNetAdhocctlInit(stacksize: c_int, priority: c_int, product: [*c]c_int) callconv(.C) c_int;

    /// Terminate the Adhoc control library
    /// Returns 0 on success, < on error.
    pub extern fn sceNetAdhocctlTerm() callconv(.C) c_int;

    /// Connect to the Adhoc control
    /// `name` - The name of the connection (maximum 8 alphanumeric characters).
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocctlConnect(name: [*c]const c_char) callconv(.C) c_int;

    /// Connect to the Adhoc control (as a host)
    /// `name` - The name of the connection (maximum 8 alphanumeric characters).
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocctlCreate(name: [*c]const c_char) callconv(.C) c_int;

    /// Connect to the Adhoc control (as a client)
    /// `scaninfo` - A valid ::SceNetAdhocctlScanInfo struct that has been filled by sceNetAchocctlGetScanInfo
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocctlJoin(scaninfo: [*c]c_int) callconv(.C) c_int;

    /// Scan the adhoc channels
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocctlScan() callconv(.C) c_int;

    /// Disconnect from the Adhoc control
    /// Returns 0 on success, < 0 on error
    pub extern fn sceNetAdhocctlDisconnect() callconv(.C) c_int;

    /// Register an adhoc event handler
    /// `handler` - The event handler.
    /// `unknown` - Pass NULL.
    /// Returns Handler id on success, < 0 on error.
    pub extern fn sceNetAdhocctlAddHandler(handler: c_int, unknown: ?*anyopaque) callconv(.C) c_int;

    /// Delete an adhoc event handler
    /// `id` - The handler id as returned by sceNetAdhocctlAddHandler.
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocctlDelHandler(id: c_int) callconv(.C) c_int;

    /// Get the state of the Adhoc control
    /// `event` - Pointer to an integer to receive the status. Can continue when it becomes 1.
    /// Returns 0 on success, < 0 on error
    pub extern fn sceNetAdhocctlGetState(event: [*c]c_int) callconv(.C) c_int;

    /// Get the adhoc ID
    /// `product` - A pointer to a  ::productStruct
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocctlGetAdhocId(product: [*c]c_int) callconv(.C) c_int;

    /// Get a list of peers
    /// `length` - The length of the list.
    /// `buf` - An allocated area of size length.
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocctlGetPeerList(length: [*c]c_int, buf: ?*anyopaque) callconv(.C) c_int;

    /// Get mac address from nickname
    /// `nickname` - The nickname.
    /// `length` - The length of the list.
    /// `buf` - An allocated area of size length.
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocctlGetAddrByName(nickname: [*c]c_char, length: [*c]c_int, buf: ?*anyopaque) callconv(.C) c_int;

    /// Get nickname from a mac address
    /// `mac` - The mac address.
    /// `nickname` - Pointer to a char buffer where the nickname will be stored.
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocctlGetNameByAddr(mac: [*c]u8, nickname: [*c]c_char) callconv(.C) c_int;

    /// Get Adhocctl parameter
    /// `params` - Pointer to a ::SceNetAdhocctlParams
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocctlGetParameter(params: [*c]c_int) callconv(.C) c_int;

    /// Get the results of a scan
    /// `length` - The length of the list.
    /// `buf` - An allocated area of size length.
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocctlGetScanInfo(length: [*c]c_int, buf: ?*anyopaque) callconv(.C) c_int;

    /// Connect to the Adhoc control game mode (as a host)
    /// `name` - The name of the connection (maximum 8 alphanumeric characters).
    /// `unknown` - Pass 1.
    /// `num` - The total number of players (including the host).
    /// `macs` - A pointer to a list of the participating mac addresses, host first, then clients.
    /// `timeout` - Timeout in microseconds.
    /// `unknown2` - pass 0.
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocctlCreateEnterGameMode(name: [*c]const c_char, unknown: c_int, num: c_int, macs: [*c]u8, timeout: c_uint, unknown2: c_int) callconv(.C) c_int;

    /// Connect to the Adhoc control game mode (as a client)
    /// `name` - The name of the connection (maximum 8 alphanumeric characters).
    /// `hostmac` - The mac address of the host.
    /// `timeout` - Timeout in microseconds.
    /// `unknown` - pass 0.
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocctlJoinEnterGameMode(name: [*c]const c_char, hostmac: [*c]u8, timeout: c_uint, unknown: c_int) callconv(.C) c_int;

    /// Exit game mode.
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocctlExitGameMode() callconv(.C) c_int;

    /// Get game mode information
    /// `gamemodeinfo` - Pointer to store the info.
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocctlGetGameModeInfo(gamemodeinfo: [*c]c_int) callconv(.C) c_int;

    /// Get peer information
    /// `mac` - The mac address of the peer.
    /// `size` - Size of peerinfo.
    /// `peerinfo` - Pointer to store the information.
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocctlGetPeerInfo(mac: [*c]u8, size: c_int, peerinfo: [*c]c_int) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceNetAdhocctl") and options.sceNetAdhocctl)) sceNetAdhocctl else EMPTY;

const sceNetAdhocMatching = struct {
    /// Initialise the Adhoc matching library
    /// `memsize` - Internal memory pool size. Lumines uses 0x20000
    /// Returns 0 on success, < 0 on error
    pub extern fn sceNetAdhocMatchingInit(memsize: c_int) callconv(.C) c_int;

    /// Terminate the Adhoc matching library
    /// Returns 0 on success, < 0 on error
    pub extern fn sceNetAdhocMatchingTerm() callconv(.C) c_int;

    /// Create an Adhoc matching object
    /// `mode` - One of ::pspAdhocMatchingModes
    /// `maxpeers` - Maximum number of peers to match (only used when mode is PSP_ADHOC_MATCHING_MODE_HOST)
    /// `port` - Port. Lumines uses 0x22B
    /// `bufsize` - Receiving buffer size
    /// `hellodelay` - Hello message send delay in microseconds (only used when mode is PSP_ADHOC_MATCHING_MODE_HOST or PSP_ADHOC_MATCHING_MODE_PTP)
    /// `pingdelay` - Ping send delay in microseconds. Lumines uses 0x5B8D80 (only used when mode is PSP_ADHOC_MATCHING_MODE_HOST or PSP_ADHOC_MATCHING_MODE_PTP)
    /// `initcount` - Initial count of the of the resend counter. Lumines uses 3
    /// `msgdelay` - Message send delay in microseconds
    /// `callback` - Callback to be called for matching
    /// Returns ID of object on success, < 0 on error.
    pub extern fn sceNetAdhocMatchingCreate(mode: c_int, maxpeers: c_int, port: c_ushort, bufsize: c_int, hellodelay: c_uint, pingdelay: c_uint, initcount: c_int, msgdelay: c_uint, callback: c_int) callconv(.C) c_int;

    /// Start a matching object
    /// `matchingid` - The ID returned from ::sceNetAdhocMatchingCreate
    /// `evthpri` - Priority of the event handler thread. Lumines uses 0x10
    /// `evthstack` - Stack size of the event handler thread. Lumines uses 0x2000
    /// `inthpri` - Priority of the input handler thread. Lumines uses 0x10
    /// `inthstack` - Stack size of the input handler thread. Lumines uses 0x2000
    /// `optlen` - Size of hellodata
    /// `optdata` - Pointer to block of data passed to callback
    /// Returns 0 on success, < 0 on error
    pub extern fn sceNetAdhocMatchingStart(matchingid: c_int, evthpri: c_int, evthstack: c_int, inthpri: c_int, inthstack: c_int, optlen: c_int, optdata: ?*anyopaque) callconv(.C) c_int;

    /// Stop a matching object
    /// `matchingid` - The ID returned from ::sceNetAdhocMatchingCreate
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocMatchingStop(matchingid: c_int) callconv(.C) c_int;

    /// Delete an Adhoc matching object
    /// `matchingid` - The ID returned from ::sceNetAdhocMatchingCreate
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocMatchingDelete(matchingid: c_int) callconv(.C) c_int;

    /// Select a matching target
    /// `matchingid` - The ID returned from ::sceNetAdhocMatchingCreate
    /// `mac` - MAC address to select
    /// `optlen` - Optional data length
    /// `optdata` - Pointer to the optional data
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocMatchingSelectTarget(matchingid: c_int, mac: [*c]u8, optlen: c_int, optdata: ?*anyopaque) callconv(.C) c_int;

    /// Cancel a matching target
    /// `matchingid` - The ID returned from ::sceNetAdhocMatchingCreate
    /// `mac` - The MAC address to cancel
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocMatchingCancelTarget(matchingid: c_int, mac: [*c]u8) callconv(.C) c_int;

    /// Set the optional hello message
    /// `matchingid` - The ID returned from ::sceNetAdhocMatchingCreate
    /// `optlen` - Length of the hello data
    /// `optdata` - Pointer to the hello data
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocMatchingSetHelloOpt(matchingid: c_int, optlen: c_int, optdata: ?*anyopaque) callconv(.C) c_int;

    /// Get the optional hello message
    /// `matchingid` - The ID returned from ::sceNetAdhocMatchingCreate
    /// `optlen` - Length of the hello data
    /// `optdata` - Pointer to the hello data
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocMatchingGetHelloOpt(matchingid: c_int, optlen: [*c]c_int, optdata: ?*anyopaque) callconv(.C) c_int;

    /// Get a list of matching members
    /// `matchingid` - The ID returned from ::sceNetAdhocMatchingCreate
    /// `length` - The length of the list.
    /// `buf` - An allocated area of size length.
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocMatchingGetMembers(matchingid: c_int, length: [*c]c_int, buf: ?*anyopaque) callconv(.C) c_int;

    /// Get the maximum memory usage by the matching library
    /// Returns The memory usage on success, < 0 on error.
    pub extern fn sceNetAdhocMatchingGetPoolMaxAlloc() callconv(.C) c_int;

    /// Cancel a matching target (with optional data)
    /// `matchingid` - The ID returned from ::sceNetAdhocMatchingCreate
    /// `mac` - The MAC address to cancel
    /// `optlen` - Optional data length
    /// `optdata` - Pointer to the optional data
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocMatchingCancelTargetWithOpt(matchingid: c_int, mac: [*c]u8, optlen: c_int, optdata: ?*anyopaque) callconv(.C) c_int;

    /// Get the status of the memory pool used by the matching library
    /// `poolstat` - A ::pspAdhocPoolStat.
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocMatchingGetPoolStat(poolstat: [*c]c_int) callconv(.C) c_int;

    /// Send data to a matching target
    /// `matchingid` - The ID returned from ::sceNetAdhocMatchingCreate
    /// `mac` - The MAC address to send the data to
    /// `datalen` - Length of the data
    /// `data` - Pointer to the data
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocMatchingSendData(matchingid: c_int, mac: [*c]u8, datalen: c_int, data: ?*anyopaque) callconv(.C) c_int;

    /// Abort a data send to a matching target
    /// `matchingid` - The ID returned from ::sceNetAdhocMatchingCreate
    /// `mac` - The MAC address to send the data to
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocMatchingAbortSendData(matchingid: c_int, mac: [*c]u8) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceNetAdhocMatching") and options.sceNetAdhocMatching)) sceNetAdhocMatching else EMPTY;

const sceNetAdhoc = struct {
    /// Initialise the adhoc library.
    /// Returns 0 on success, < 0 on error
    pub extern fn sceNetAdhocInit() callconv(.C) c_int;

    /// Terminate the adhoc library
    /// Returns 0 on success, < 0 on error
    pub extern fn sceNetAdhocTerm() callconv(.C) c_int;

    pub extern fn sceNetAdhocPollSocket() callconv(.C) void;

    pub extern fn sceNetAdhocSetSocketAlert() callconv(.C) void;

    pub extern fn sceNetAdhocGetSocketAlert() callconv(.C) void;

    /// Create a PDP object.
    /// `mac` - Your MAC address (from sceWlanGetEtherAddr)
    /// `port` - Port to use, lumines uses 0x309
    /// `bufsize` - Socket buffer size, lumines sets to 0x400
    /// `unk1` - Unknown, lumines sets to 0
    /// Returns The ID of the PDP object (< 0 on error)
    pub extern fn sceNetAdhocPdpCreate(mac: [*c]u8, port: c_ushort, bufsize: c_uint, unk1: c_int) callconv(.C) c_int;

    /// Set a PDP packet to a destination
    /// `id` - The ID as returned by ::sceNetAdhocPdpCreate
    /// `destMacAddr` - The destination MAC address, can be set to all 0xFF for broadcast
    /// `port` - The port to send to
    /// `data` - The data to send
    /// `len` - The length of the data.
    /// `timeout` - Timeout in microseconds.
    /// `nonblock` - Set to 0 to block, 1 for non-blocking.
    /// Returns Bytes sent, < 0 on error
    pub extern fn sceNetAdhocPdpSend(id: c_int, destMacAddr: [*c]u8, port: c_ushort, data: ?*anyopaque, len: c_uint, timeout: c_uint, nonblock: c_int) callconv(.C) c_int;

    /// Receive a PDP packet
    /// `id` - The ID of the PDP object, as returned by ::sceNetAdhocPdpCreate
    /// `srcMacAddr` - Buffer to hold the source mac address of the sender
    /// `port` - Buffer to hold the port number of he received data
    /// `data` - Data buffer
    /// `dataLength` - The length of the data buffer
    /// `timeout` - Timeout in microseconds.
    /// `nonblock` - Set to 0 to block, 1 for non-blocking.
    /// Returns Number of bytes received, < 0 on error.
    pub extern fn sceNetAdhocPdpRecv(id: c_int, srcMacAddr: [*c]u8, port: [*c]c_ushort, data: ?*anyopaque, dataLength: ?*anyopaque, timeout: c_uint, nonblock: c_int) callconv(.C) c_int;

    /// Delete a PDP object.
    /// `id` - The ID returned from ::sceNetAdhocPdpCreate
    /// `unk1` - Unknown, set to 0
    /// Returns 0 on success, < 0 on error
    pub extern fn sceNetAdhocPdpDelete(id: c_int, unk1: c_int) callconv(.C) c_int;

    /// Get the status of all PDP objects
    /// `size` - Pointer to the size of the stat array (e.g 20 for one structure)
    /// `stat` - Pointer to a list of ::pdpStatStruct structures.
    /// Returns 0 on success, < 0 on error
    pub extern fn sceNetAdhocGetPdpStat(size: [*c]c_int, stat: [*c]c_int) callconv(.C) c_int;

    /// Open a PTP connection
    /// `srcmac` - Local mac address.
    /// `srcport` - Local port.
    /// `destmac` - Destination mac.
    /// `destport` - Destination port
    /// `bufsize` - Socket buffer size
    /// `delay` - Interval between retrying (microseconds).
    /// `count` - Number of retries.
    /// `unk1` - Pass 0.
    /// Returns A socket ID on success, < 0 on error.
    pub extern fn sceNetAdhocPtpOpen(srcmac: [*c]u8, srcport: c_ushort, destmac: [*c]u8, destport: c_ushort, bufsize: c_uint, delay: c_uint, count: c_int, unk1: c_int) callconv(.C) c_int;

    /// Wait for connection created by sceNetAdhocPtpOpen()
    /// `id` - A socket ID.
    /// `timeout` - Timeout in microseconds.
    /// `nonblock` - Set to 0 to block, 1 for non-blocking.
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocPtpConnect(id: c_int, timeout: c_uint, nonblock: c_int) callconv(.C) c_int;

    /// Wait for an incoming PTP connection
    /// `srcmac` - Local mac address.
    /// `srcport` - Local port.
    /// `bufsize` - Socket buffer size
    /// `delay` - Interval between retrying (microseconds).
    /// `count` - Number of retries.
    /// `queue` - Connection queue length.
    /// `unk1` - Pass 0.
    /// Returns A socket ID on success, < 0 on error.
    pub extern fn sceNetAdhocPtpListen(srcmac: [*c]u8, srcport: c_ushort, bufsize: c_uint, delay: c_uint, count: c_int, queue: c_int, unk1: c_int) callconv(.C) c_int;

    /// Accept an incoming PTP connection
    /// `id` - A socket ID.
    /// `mac` - Connecting peers mac.
    /// `port` - Connecting peers port.
    /// `timeout` - Timeout in microseconds.
    /// `nonblock` - Set to 0 to block, 1 for non-blocking.
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocPtpAccept(id: c_int, mac: [*c]u8, port: [*c]c_ushort, timeout: c_uint, nonblock: c_int) callconv(.C) c_int;

    /// Send data
    /// `id` - A socket ID.
    /// `data` - Data to send.
    /// `datasize` - Size of the data.
    /// `timeout` - Timeout in microseconds.
    /// `nonblock` - Set to 0 to block, 1 for non-blocking.
    /// Returns 0 success, < 0 on error.
    pub extern fn sceNetAdhocPtpSend(id: c_int, data: ?*anyopaque, datasize: [*c]c_int, timeout: c_uint, nonblock: c_int) callconv(.C) c_int;

    /// Receive data
    /// `id` - A socket ID.
    /// `data` - Buffer for the received data.
    /// `datasize` - Size of the data received.
    /// `timeout` - Timeout in microseconds.
    /// `nonblock` - Set to 0 to block, 1 for non-blocking.
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocPtpRecv(id: c_int, data: ?*anyopaque, datasize: [*c]c_int, timeout: c_uint, nonblock: c_int) callconv(.C) c_int;

    /// Wait for data in the buffer to be sent
    /// `id` - A socket ID.
    /// `timeout` - Timeout in microseconds.
    /// `nonblock` - Set to 0 to block, 1 for non-blocking.
    /// Returns A socket ID on success, < 0 on error.
    pub extern fn sceNetAdhocPtpFlush(id: c_int, timeout: c_uint, nonblock: c_int) callconv(.C) c_int;

    /// Close a socket
    /// `id` - A socket ID.
    /// `unk1` - Pass 0.
    /// Returns A socket ID on success, < 0 on error.
    pub extern fn sceNetAdhocPtpClose(id: c_int, unk1: c_int) callconv(.C) c_int;

    /// Get the status of all PTP objects
    /// `size` - Pointer to the size of the stat array (e.g 20 for one structure)
    /// `stat` - Pointer to a list of ::ptpStatStruct structures.
    /// Returns 0 on success, < 0 on error
    pub extern fn sceNetAdhocGetPtpStat(size: [*c]c_int, stat: [*c]c_int) callconv(.C) c_int;

    /// Create own game object type data.
    /// `data` - A pointer to the game object data.
    /// `size` - Size of the game data.
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocGameModeCreateMaster(data: ?*anyopaque, size: c_int) callconv(.C) c_int;

    /// Create peer game object type data.
    /// `mac` - The mac address of the peer.
    /// `data` - A pointer to the game object data.
    /// `size` - Size of the game data.
    /// Returns The id of the replica on success, < 0 on error.
    pub extern fn sceNetAdhocGameModeCreateReplica(mac: [*c]u8, data: ?*anyopaque, size: c_int) callconv(.C) c_int;

    /// Update own game object type data.
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocGameModeUpdateMaster() callconv(.C) c_int;

    /// Update peer game object type data.
    /// `id` - The id of the replica returned by sceNetAdhocGameModeCreateReplica.
    /// `unk1` - Pass 0.
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocGameModeUpdateReplica(id: c_int, unk1: c_int) callconv(.C) c_int;

    /// Delete own game object type data.
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocGameModeDeleteMaster() callconv(.C) c_int;

    /// Delete peer game object type data.
    /// `id` - The id of the replica.
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceNetAdhocGameModeDeleteReplica(id: c_int) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceNetAdhoc") and options.sceNetAdhoc)) sceNetAdhoc else EMPTY;

const sceSsl = struct {
    pub extern fn sceSslGetNameEntryCount() callconv(.C) void;

    /// Get the current memory size used by ssl.
    /// `memory` - Pointer where the current memory used value will be stored.
    /// Returns 0 on success
    pub extern fn sceSslGetUsedMemoryCurrent(memory: [*c]c_uint) callconv(.C) c_int;

    pub extern fn sceSslGetNotBefore() callconv(.C) void;

    /// Terminate the ssl library.
    /// Returns 0 on success
    pub extern fn sceSslEnd() callconv(.C) c_int;

    pub extern fn sceSslGetIssuerName() callconv(.C) void;

    pub extern fn sceSslGetSubjectName() callconv(.C) void;

    pub extern fn sceSslGetNotAfter() callconv(.C) void;

    /// Init the ssl library.
    /// `unknown1` - Memory size? Pass 0x28000
    /// Returns 0 on success
    pub extern fn sceSslInit(unknown1: c_int) callconv(.C) c_int;

    /// Get the maximum memory size used by ssl.
    /// `memory` - Pointer where the maximum memory used value will be stored.
    /// Returns 0 on success
    pub extern fn sceSslGetUsedMemoryMax(memory: [*c]c_uint) callconv(.C) c_int;

    pub extern fn sceSslGetSerialNumber() callconv(.C) void;

    pub extern fn sceSslGetNameEntryInfo() callconv(.C) void;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceSsl") and options.sceSsl)) sceSsl else EMPTY;

const sceJpeg = struct {
    pub extern fn sceJpeg_0425B986() callconv(.C) void;

    pub extern fn sceJpegMJpegCsc() callconv(.C) void;

    /// Decodes a mjpeg frame.
    /// `jpegbuf` - the buffer with the mjpeg frame
    /// `size` - size of the buffer pointed by jpegbuf
    /// `rgba` - buffer where the decoded data in RGBA format will be stored.
    /// It should have a size of (width * height * 4).
    /// `unk` - Unknown, pass 0
    /// Returns (width * 65536) + height on success, < 0 on error
    pub extern fn sceJpegDecodeMJpeg(jpegbuf: [*c]u8, size: SceSize, rgba: ?*anyopaque, unk: u32) callconv(.C) c_int;

    pub extern fn sceJpeg_227662D7() callconv(.C) void;

    /// Deletes the current decoder context.
    /// Returns 0 on success, < 0 on error
    pub extern fn sceJpegDeleteMJpeg() callconv(.C) c_int;

    pub extern fn sceJpeg_64B6F978() callconv(.C) void;

    pub extern fn sceJpeg_67F0ED84() callconv(.C) void;

    /// Finishes the MJpeg library
    /// Returns 0 on success, < 0 on error
    pub extern fn sceJpegFinishMJpeg() callconv(.C) c_int;

    pub extern fn sceJpegGetOutputInfo() callconv(.C) void;

    pub extern fn sceJpegDecodeMJpegYCbCr() callconv(.C) void;

    pub extern fn sceJpeg_9B36444C() callconv(.C) void;

    /// Creates the decoder context.
    /// `width` - The width of the frame
    /// `height` - The height of the frame
    /// Returns 0 on success, < 0 on error
    pub extern fn sceJpegCreateMJpeg(width: c_int, height: c_int) callconv(.C) c_int;

    /// Inits the MJpeg library
    /// Returns 0 on success, < 0 on error
    pub extern fn sceJpegInitMJpeg() callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceJpeg") and options.sceJpeg)) sceJpeg else EMPTY;

const sceMpegbase = struct {
    pub extern fn sceMpegBaseYCrCbCopyVme(YUVBuffer: ScePVoid, Buffer: [*c]SceInt32, Type: SceInt32) callconv(.C) SceInt32;

    pub extern fn sceMpegBaseCscInit(width: SceInt32) callconv(.C) SceInt32;

    pub extern fn sceMpegBaseCscVme(pRGBbuffer: ScePVoid, pRGBbuffer2: ScePVoid, width: SceInt32, pYCrCbBuffer: [*c]c_int) callconv(.C) SceInt32;

    pub extern fn sceMpegbase_0530BE4E() callconv(.C) void;

    pub extern fn sceMpegbase_304882E1() callconv(.C) void;

    pub extern fn sceMpegBaseYCrCbCopy() callconv(.C) void;

    pub extern fn sceMpegBaseCscAvc() callconv(.C) void;

    pub extern fn sceMpegbase_AC9E717E() callconv(.C) void;

    pub extern fn sceMpegbase_BEA18F91(pLLI: [*c]c_int) callconv(.C) SceInt32;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceMpegbase") and options.sceMpegbase)) sceMpegbase else EMPTY;

const sceMpeg = struct {
    /// sceMpegQueryStreamOffset
    /// `Mpeg` - SceMpeg handle
    /// `pBuffer` - pointer to file header
    /// `iOffset` - will contain stream offset in bytes, usually 2048
    /// Returns 0 if success.
    pub extern fn sceMpegQueryStreamOffset(Mpeg: [*c]c_int, pBuffer: ScePVoid, iOffset: [*c]SceInt32) callconv(.C) SceInt32;

    /// sceMpegQueryStreamSize
    /// `pBuffer` - pointer to file header
    /// `iSize` - will contain stream size in bytes
    /// Returns 0 if success.
    pub extern fn sceMpegQueryStreamSize(pBuffer: ScePVoid, iSize: [*c]SceInt32) callconv(.C) SceInt32;

    /// sceMpegInit
    /// Returns 0 if success.
    pub extern fn sceMpegInit() callconv(.C) SceInt32;

    /// sceMpegFinish
    pub extern fn sceMpegFinish() callconv(.C) SceVoid;

    /// sceMpegQueryMemSize
    /// `iUnk` - Unknown, set to 0
    /// Returns < 0 if error else decoder data size.
    pub extern fn sceMpegQueryMemSize(iUnk: c_int) callconv(.C) SceInt32;

    /// sceMpegCreate
    /// `Mpeg` - will be filled
    /// `pData` - pointer to allocated memory of size = sceMpegQueryMemSize()
    /// `iSize` - size of data, should be = sceMpegQueryMemSize()
    /// `Ringbuffer` - a ringbuffer
    /// `iFrameWidth` - display buffer width, set to 512 if writing to framebuffer
    /// `iUnk1` - unknown, set to 0
    /// `iUnk2` - unknown, set to 0
    /// Returns 0 if success.
    pub extern fn sceMpegCreate(Mpeg: [*c]c_int, pData: ScePVoid, iSize: SceInt32, Ringbuffer: [*c]c_int, iFrameWidth: SceInt32, iUnk1: SceInt32, iUnk2: SceInt32) callconv(.C) SceInt32;

    /// sceMpegDelete
    /// `Mpeg` - SceMpeg handle
    pub extern fn sceMpegDelete(Mpeg: [*c]c_int) callconv(.C) SceVoid;

    /// sceMpegRegistStream
    /// `Mpeg` - SceMpeg handle
    /// `iStreamID` - stream id, 0 for video, 1 for audio
    /// `iUnk` - unknown, set to 0
    /// Returns 0 if error.
    pub extern fn sceMpegRegistStream(Mpeg: [*c]c_int, iStreamID: SceInt32, iUnk: SceInt32) callconv(.C) [*c]c_int;

    /// sceMpegUnRegistStream
    /// `Mpeg` - SceMpeg handle
    /// `pStream` - pointer to stream
    pub extern fn sceMpegUnRegistStream(Mpeg: c_int, pStream: [*c]c_int) callconv(.C) SceVoid;

    /// sceMpegMallocAvcEsBuf
    /// Returns 0 if error else pointer to buffer.
    pub extern fn sceMpegMallocAvcEsBuf(Mpeg: [*c]c_int) callconv(.C) ScePVoid;

    /// sceMpegFreeAvcEsBuf
    pub extern fn sceMpegFreeAvcEsBuf(Mpeg: [*c]c_int, pBuf: ScePVoid) callconv(.C) SceVoid;

    /// sceMpegQueryAtracEsSize
    /// `Mpeg` - SceMpeg handle
    /// `iEsSize` - will contain size of Es
    /// `iOutSize` - will contain size of decoded data
    /// Returns 0 if success.
    pub extern fn sceMpegQueryAtracEsSize(Mpeg: [*c]c_int, iEsSize: [*c]SceInt32, iOutSize: [*c]SceInt32) callconv(.C) SceInt32;

    pub extern fn sceMpegQueryPcmEsSize() callconv(.C) void;

    /// sceMpegInitAu
    /// `Mpeg` - SceMpeg handle
    /// `pEsBuffer` - prevously allocated Es buffer
    /// `pAu` - will contain pointer to Au
    /// Returns 0 if success.
    pub extern fn sceMpegInitAu(Mpeg: [*c]c_int, pEsBuffer: ScePVoid, pAu: [*c]c_int) callconv(.C) SceInt32;

    pub extern fn sceMpegChangeGetAvcAuMode() callconv(.C) void;

    pub extern fn sceMpegChangeGetAuMode() callconv(.C) void;

    /// sceMpegGetAvcAu
    /// `Mpeg` - SceMpeg handle
    /// `pStream` - associated stream
    /// `pAu` - will contain pointer to Au
    /// `iUnk` - unknown
    /// Returns 0 if success.
    pub extern fn sceMpegGetAvcAu(Mpeg: [*c]c_int, pStream: [*c]c_int, pAu: [*c]c_int, iUnk: [*c]SceInt32) callconv(.C) SceInt32;

    pub extern fn sceMpegGetPcmAu() callconv(.C) void;

    /// sceMpegGetAtracAu
    /// `Mpeg` - SceMpeg handle
    /// `pStream` - associated stream
    /// `pAu` - will contain pointer to Au
    /// `pUnk` - unknown
    /// Returns 0 if success.
    pub extern fn sceMpegGetAtracAu(Mpeg: [*c]c_int, pStream: [*c]c_int, pAu: [*c]c_int, pUnk: ScePVoid) callconv(.C) SceInt32;

    pub extern fn sceMpegFlushStream() callconv(.C) void;

    /// sceMpegFlushAllStreams
    /// Returns 0 if success.
    pub extern fn sceMpegFlushAllStream(Mpeg: [*c]c_int) callconv(.C) SceInt32;

    /// sceMpegAvcDecode
    /// `Mpeg` - SceMpeg handle
    /// `pAu` - video Au
    /// `iFrameWidth` - output buffer width, set to 512 if writing to framebuffer
    /// `pBuffer` - buffer that will contain the decoded frame
    /// `iInit` - will be set to 0 on first call, then 1
    /// Returns 0 if success.
    /// sceMpegAvcDecodeMode
    /// `Mpeg` - SceMpeg handle
    /// `pMode` - pointer to SceMpegAvcMode struct defining the decode mode (pixelformat)
    /// Returns 0 if success.
    pub extern fn sceMpegAvcDecode(Mpeg: [*c]c_int, pAu: [*c]c_int, iFrameWidth: SceInt32, pBuffer: ScePVoid, iInit: [*c]SceInt32) callconv(.C) SceInt32;

    pub extern fn sceMpegAvcDecodeDetail() callconv(.C) void;

    /// sceMpegAvcDecodeMode
    /// `Mpeg` - SceMpeg handle
    /// `pMode` - pointer to SceMpegAvcMode struct defining the decode mode (pixelformat)
    /// Returns 0 if success.
    pub extern fn sceMpegAvcDecodeMode(Mpeg: [*c]c_int, pMode: [*c]c_int) callconv(.C) SceInt32;

    /// sceMpegAvcDecodeStop
    /// `Mpeg` - SceMpeg handle
    /// `iFrameWidth` - output buffer width, set to 512 if writing to framebuffer
    /// `pBuffer` - buffer that will contain the decoded frame
    /// `iStatus` - frame number
    /// Returns 0 if success.
    pub extern fn sceMpegAvcDecodeStop(Mpeg: [*c]c_int, iFrameWidth: SceInt32, pBuffer: ScePVoid, iStatus: [*c]SceInt32) callconv(.C) SceInt32;

    /// sceMpegAtracDecode
    /// `Mpeg` - SceMpeg handle
    /// `pAu` - video Au
    /// `pBuffer` - buffer that will contain the decoded frame
    /// `iInit` - set this to 1 on first call
    /// Returns 0 if success.
    pub extern fn sceMpegAtracDecode(Mpeg: [*c]c_int, pAu: [*c]c_int, pBuffer: ScePVoid, iInit: SceInt32) callconv(.C) SceInt32;

    /// sceMpegRingbufferQueryMemSize
    /// `iPackets` - number of packets in the ringbuffer
    /// Returns < 0 if error else ringbuffer data size.
    pub extern fn sceMpegRingbufferQueryMemSize(iPackets: SceInt32) callconv(.C) SceInt32;

    /// sceMpegRingbufferConstruct
    /// `Ringbuffer` - pointer to a sceMpegRingbuffer struct
    /// `iPackets` - number of packets in the ringbuffer
    /// `pData` - pointer to allocated memory
    /// `iSize` - size of allocated memory, shoud be sceMpegRingbufferQueryMemSize(iPackets)
    /// `Callback` - ringbuffer callback
    /// `pCBparam` - param passed to callback
    /// Returns 0 if success.
    pub extern fn sceMpegRingbufferConstruct(Ringbuffer: [*c]c_int, iPackets: SceInt32, pData: ScePVoid, iSize: SceInt32, Callback: c_int, pCBparam: ScePVoid) callconv(.C) SceInt32;

    /// sceMpegRingbufferDestruct
    /// `Ringbuffer` - pointer to a sceMpegRingbuffer struct
    pub extern fn sceMpegRingbufferDestruct(Ringbuffer: [*c]c_int) callconv(.C) SceVoid;

    /// sceMpegRingbufferPut
    /// `Ringbuffer` - pointer to a sceMpegRingbuffer struct
    /// `iNumPackets` - num packets to put into the ringbuffer
    /// `iAvailable` - free packets in the ringbuffer, should be sceMpegRingbufferAvailableSize()
    /// Returns < 0 if error else number of packets.
    pub extern fn sceMpegRingbufferPut(Ringbuffer: [*c]c_int, iNumPackets: SceInt32, iAvailable: SceInt32) callconv(.C) SceInt32;

    /// sceMpegQueryMemSize
    /// `Ringbuffer` - pointer to a sceMpegRingbuffer struct
    /// Returns < 0 if error else number of free packets in the ringbuffer.
    pub extern fn sceMpegRingbufferAvailableSize(Ringbuffer: [*c]c_int) callconv(.C) SceInt32;

    pub extern fn sceMpeg_11CAB459() callconv(.C) void;

    pub extern fn sceMpeg_3C37A7A6() callconv(.C) void;

    pub extern fn sceMpeg_B27711A8() callconv(.C) void;

    pub extern fn sceMpeg_D4DD6E75() callconv(.C) void;

    pub extern fn sceMpeg_C345DED2() callconv(.C) void;

    pub extern fn sceMpegAvcDecodeDetail2() callconv(.C) void;

    pub extern fn sceMpeg_988E9E12() callconv(.C) void;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceMpeg") and options.sceMpeg)) sceMpeg else EMPTY;

const sceHprm = struct {
    pub extern fn sceHprmRegisterCallback() callconv(.C) void;

    pub extern fn sceHprmUnregisterCallback() callconv(.C) void;

    /// Determines whether the remote is plugged in.
    /// Returns 1 if the remote is plugged in, else 0.
    pub extern fn sceHprmIsRemoteExist() callconv(.C) c_int;

    /// Determines whether the headphones are plugged in.
    /// Returns 1 if the headphones are plugged in, else 0.
    pub extern fn sceHprmIsHeadphoneExist() callconv(.C) c_int;

    /// Determines whether the microphone is plugged in.
    /// Returns 1 if the microphone is plugged in, else 0.
    pub extern fn sceHprmIsMicrophoneExist() callconv(.C) c_int;

    /// Peek at the current being pressed on the remote.
    /// `key` - Pointer to the u32 to receive the key bitmap, should be one or
    /// more of ::PspHprmKeys
    /// Returns < 0 on error
    pub extern fn sceHprmPeekCurrentKey(key: [*c]u32) callconv(.C) c_int;

    /// Peek at the current latch data.
    /// `latch` - Pointer a to a 4 dword array to contain the latch data.
    /// Returns < 0 on error.
    pub extern fn sceHprmPeekLatch(latch: [*c]u32) callconv(.C) c_int;

    /// Read the current latch data.
    /// `latch` - Pointer a to a 4 dword array to contain the latch data.
    /// Returns < 0 on error.
    pub extern fn sceHprmReadLatch(latch: [*c]u32) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceHprm") and options.sceHprm)) sceHprm else EMPTY;

const sceUmdUser = struct {
    /// Get the error code associated with a failed event
    /// Returns < 0 on error, the error code on success
    pub extern fn sceUmdGetErrorStat() callconv(.C) c_int;

    /// Get the disc info
    /// `info` - A pointer to a ::pspUmdInfo struct
    /// Returns < 0 on error
    pub extern fn sceUmdGetDiscInfo(info: [*c]c_int) callconv(.C) c_int;

    /// Check whether there is a disc in the UMD drive
    /// Returns 0 if no disc present, anything else indicates a disc is inserted.
    pub extern fn sceUmdCheckMedium() callconv(.C) c_int;

    /// Wait for the UMD drive to reach a certain state (plus callback)
    /// `stat` - One or more of ::pspUmdState
    /// `timeout` - Timeout value in microseconds
    /// Returns < 0 on error
    pub extern fn sceUmdWaitDriveStatCB(stat: c_int, timeout: c_uint) callconv(.C) c_int;

    /// Wait for the UMD drive to reach a certain state
    /// `stat` - One or more of ::pspUmdState
    /// `timeout` - Timeout value in microseconds
    /// Returns < 0 on error
    pub extern fn sceUmdWaitDriveStatWithTimer(stat: c_int, timeout: c_uint) callconv(.C) c_int;

    /// Cancel a sceUmdWait* call
    /// Returns < 0 on error
    pub extern fn sceUmdCancelWaitDriveStat() callconv(.C) c_int;

    /// Get (poll) the current state of the UMD drive
    /// Returns < 0 on error, one or more of ::pspUmdState on success
    pub extern fn sceUmdGetDriveStat() callconv(.C) c_int;

    /// Prohibit UMD disc being replaced
    /// Returns < 0 on error
    pub extern fn sceUmdReplaceProhibit() callconv(.C) c_int;

    /// Wait for the UMD drive to reach a certain state
    /// `stat` - One or more of ::pspUmdState
    /// Returns < 0 on error
    pub extern fn sceUmdWaitDriveStat(stat: c_int) callconv(.C) c_int;

    /// Register a callback for the UMD drive
    /// @note Callback is of type UmdCallback
    /// `cbid` - A callback ID created from sceKernelCreateCallback
    /// Returns < 0 on error
    /// @par Example:
    /// `
    /// int umd_callback(int unknown, int event)
    /// {
    /// //do something
    /// }
    /// int cbid = sceKernelCreateCallback("UMD Callback", umd_callback, NULL);
    /// sceUmdRegisterUMDCallBack(cbid);
    /// `
    pub extern fn sceUmdRegisterUMDCallBack(cbid: c_int) callconv(.C) c_int;

    /// Un-register a callback for the UMD drive
    /// `cbid` - A callback ID created from sceKernelCreateCallback
    /// Returns < 0 on error
    pub extern fn sceUmdUnRegisterUMDCallBack(cbid: c_int) callconv(.C) c_int;

    /// Activates the UMD drive
    /// `unit` - The unit to initialise (probably). Should be set to 1.
    /// `drive` - A prefix string for the fs device to mount the UMD on (e.g. "disc0:")
    /// Returns < 0 on error
    /// @par Example:
    /// `
    /// // Wait for disc and mount to filesystem
    /// int i;
    /// i = sceUmdCheckMedium();
    /// if(i == 0)
    /// {
    /// sceUmdWaitDriveStat(PSP_UMD_PRESENT);
    /// }
    /// sceUmdActivate(1, "disc0:"); // Mount UMD to disc0: file system
    /// sceUmdWaitDriveStat(PSP_UMD_READY);
    /// // Now you can access the UMD using standard sceIo functions
    /// `
    pub extern fn sceUmdActivate(unit: c_int, drive: [*c]const c_char) callconv(.C) c_int;

    /// Permit UMD disc being replaced
    /// Returns < 0 on error
    pub extern fn sceUmdReplacePermit() callconv(.C) c_int;

    /// Deativates the UMD drive
    /// `unit` - The unit to initialise (probably). Should be set to 1.
    /// `drive` - A prefix string for the fs device to mount the UMD on (e.g. "disc0:")
    /// Returns < 0 on error
    pub extern fn sceUmdDeactivate(unit: c_int, drive: [*c]const c_char) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceUmdUser") and options.sceUmdUser)) sceUmdUser else EMPTY;

const sceCtrl = struct {
    /// Set the controller cycle setting.
    /// `cycle` - Cycle.  Normally set to 0.
    /// Returns The previous cycle setting.
    pub extern fn sceCtrlSetSamplingCycle(cycle: c_int) callconv(.C) c_int;

    /// Get the controller current cycle setting.
    /// `pcycle` - Return value.
    /// Returns 0.
    pub extern fn sceCtrlGetSamplingCycle(pcycle: [*c]c_int) callconv(.C) c_int;

    /// Set the controller mode.
    /// `mode` - One of ::PspCtrlMode. If this is ::PSP_CTRL_MODE_DIGITAL, no data about the analog stick
    /// will be present in the SceCtrlData struct read by SceCtrlReadBuffer.
    /// Returns The previous mode.
    pub extern fn sceCtrlSetSamplingMode(mode: c_int) callconv(.C) c_int;

    /// Get the current controller mode.
    /// `pmode` - Return value.
    /// Returns 0.
    pub extern fn sceCtrlGetSamplingMode(pmode: [*c]c_int) callconv(.C) c_int;

    /// @brief Read latest controller data from the controller service.
    /// Controller data contains current button and axis state.
    /// @note Axis state is present only in ::PSP_CTRL_MODE_ANALOG controller mode.
    /// `pad_data` - A pointer to ::SceCtrlData structure that receives controller data.
    /// `count` - Number of ::SceCtrlData structures to read.
    /// @see ::SceCtrlData
    /// @see ::sceCtrlPeekBufferNegative()
    /// @see ::sceCtrlReadBufferPositive()
    pub extern fn sceCtrlPeekBufferPositive(pad_data: [*c]c_int, count: c_int) callconv(.C) c_int;

    pub extern fn sceCtrlPeekBufferNegative(pad_data: [*c]c_int, count: c_int) callconv(.C) c_int;

    /// @brief Read new controller data from the controller service.
    /// Controller data contains current button and axis state.
    /// **Example:**
    /// `
    /// SceCtrlData pad;
    /// sceCtrlSetSamplingCycle(0);
    /// sceCtrlSetSamplingMode(1);
    /// sceCtrlReadBufferPositive(&pad, 1);
    /// // Do something with the read controller data
    /// `
    /// @note Axis state is present only in ::PSP_CTRL_MODE_ANALOG controller mode.
    /// @warning Controller data is collected once every controller sampling cycle.
    /// If controller data was already read during a cycle, trying to read it again
    /// will block the execution until the next one.
    /// `pad_data` - A pointer to ::SceCtrlData structure that receives controller data.
    /// `count` - Number of ::SceCtrlData structures to read.
    /// @see ::SceCtrlData
    /// @see ::sceCtrlReadBufferNegative()
    /// @see ::sceCtrlPeekBufferPositive()
    pub extern fn sceCtrlReadBufferPositive(pad_data: [*c]c_int, count: c_int) callconv(.C) c_int;

    pub extern fn sceCtrlReadBufferNegative(pad_data: [*c]c_int, count: c_int) callconv(.C) c_int;

    /// @brief Read latest latch data from the controller service.
    /// Latch data contains information about button state changes between two controller service sampling cycles.
    /// `latch_data A pointer to ::SceCtrlLatch structure that receives latch data.`
    /// Returns On success, the number of times the controller service performed sampling since the last time
    /// ::sceCtrlReadLatch() was called.
    /// Returns < 0 on error.
    /// @see ::SceCtrlLatch
    /// @see ::sceCtrlReadLatch()
    pub extern fn sceCtrlPeekLatch(latch_data: [*c]c_int) callconv(.C) c_int;

    /// @brief Read new latch data from the controller service.
    /// Latch data contains information about button state changes between two controller service sampling cycles.
    /// **Example:**
    /// `
    /// SceCtrlLatch latchData;
    /// while (1) {
    /// // Obtain latch data
    /// sceCtrlReadLatch(&latchData);
    /// if (latchData.uiMake & PSP_CTRL_CROSS)
    /// {
    /// // The Cross button has just been pressed (transition from 'released' state to 'pressed' state)
    /// }
    /// if (latchData.uiPress & PSP_CTRL_SQUARE)
    /// {
    /// // The Square button is currently in the 'pressed' state
    /// }
    /// if (latchData.uiBreak & PSP_CTRL_TRIANGLE)
    /// {
    /// // The Triangle button has just been released (transition from 'pressed' state to 'released' state)
    /// }
    /// if (latchData.uiRelease & PSP_CTRL_CIRCLE)
    /// {
    /// // The Circle button is currently in the 'released' state
    /// }
    /// // As we clear the internal latch data with the ReadLatch() call, we can explicitly wait for the VBLANK interval
    /// // to give the controller service the time it needs to collect new latch data again. This guarantees the next call
    /// // to sceCtrlReadLatch() will return collected data again.
    /// //
    /// // Note: The sceCtrlReadBuffer*() APIs are implicitly waiting for a VBLANK interval if necessary.
    /// sceDisplayWaitVBlank();
    /// }
    /// `
    /// @warning Latch data is produced once every controller sampling cycle. If latch data was already read
    /// during a cycle, trying to read it again will block the execution until the next one.
    /// `latch_data A pointer to ::SceCtrlLatch structure that receives latch data.`
    /// Returns On success, the number of times the controller service performed sampling since the last time
    /// ::sceCtrlReadLatch() was called.
    /// Returns < 0 on error.
    /// @see ::SceCtrlLatch
    /// @see ::sceCtrlPeekLatch()
    pub extern fn sceCtrlReadLatch(latch_data: [*c]c_int) callconv(.C) c_int;

    pub extern fn sceCtrl_348D99D4() callconv(.C) void;

    pub extern fn sceCtrl_AF5960F3() callconv(.C) void;

    pub extern fn sceCtrlClearRapidFire() callconv(.C) void;

    pub extern fn sceCtrlSetRapidFire() callconv(.C) void;

    /// Set analog threshold relating to the idle timer.
    /// `idlereset` - Movement needed by the analog to reset the idle timer.
    /// `idleback` - Movement needed by the analog to bring the PSP back from an idle state.
    /// Set to -1 for analog to not cancel idle timer.
    /// Set to 0 for idle timer to be cancelled even if the analog is not moved.
    /// Set between 1 - 128 to specify the movement on either axis needed by the analog to fire the event.
    /// Returns < 0 on error.
    pub extern fn sceCtrlSetIdleCancelThreshold(idlereset: c_int, idleback: c_int) callconv(.C) c_int;

    /// Get the idle threshold values.
    /// `idlerest` - Movement needed by the analog to reset the idle timer.
    /// `idleback` - Movement needed by the analog to bring the PSP back from an idle state.
    /// Returns < 0 on error.
    pub extern fn sceCtrlGetIdleCancelThreshold(idlerest: [*c]c_int, idleback: [*c]c_int) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceCtrl") and options.sceCtrl)) sceCtrl else EMPTY;

const LoadExecForUser = struct {
    /// Execute a new game executable, limited when not running in kernel mode.
    /// `file` - The file to execute.
    /// `param` - Pointer to a ::SceKernelLoadExecParam structure, or NULL.
    /// Returns < 0 on error, probably.
    pub extern fn sceKernelLoadExec(file: [*c]const c_char, param: [*c]c_int) callconv(.C) c_int;

    pub extern fn sceKernelExitGameWithStatus() callconv(.C) void;

    /// Exit game and go back to the PSP browser.
    /// @note You need to be in a thread in order for this function to work
    pub extern fn sceKernelExitGame() callconv(.C) void;

    /// Register callback
    /// @note By installing the exit callback the home button becomes active. However if sceKernelExitGame
    /// is not called in the callback it is likely that the psp will just crash.
    /// @par Example:
    /// `
    /// int exit_callback(void) { sceKernelExitGame(); }
    /// cbid = sceKernelCreateCallback("ExitCallback", exit_callback, NULL);
    /// sceKernelRegisterExitCallback(cbid);
    /// `
    /// `cbid Callback id`
    /// Returns < 0 on error
    pub extern fn sceKernelRegisterExitCallback(cbid: c_int) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "LoadExecForUser") and options.LoadExecForUser)) LoadExecForUser else EMPTY;

const Kernel_Library = struct {
    /// Suspend all interrupts.
    /// Returns The current state of the interrupt controller, to be used with ::sceKernelCpuResumeIntr().
    pub extern fn sceKernelCpuSuspendIntr() callconv(.C) c_uint;

    /// Resume all interrupts.
    /// `flags` - The value returned from ::sceKernelCpuSuspendIntr().
    pub extern fn sceKernelCpuResumeIntr(flags: c_uint) callconv(.C) void;

    /// Resume all interrupts (using sync instructions).
    /// `flags` - The value returned from ::sceKernelCpuSuspendIntr()
    pub extern fn sceKernelCpuResumeIntrWithSync(flags: c_uint) callconv(.C) void;

    /// Determine if interrupts are suspended or active, based on the given flags.
    /// `flags` - The value returned from ::sceKernelCpuSuspendIntr().
    /// Returns 1 if flags indicate that interrupts were not suspended, 0 otherwise.
    pub extern fn sceKernelIsCpuIntrSuspended(flags: c_uint) callconv(.C) c_int;

    /// Determine if interrupts are enabled or disabled.
    /// Returns 1 if interrupts are currently enabled.
    pub extern fn sceKernelIsCpuIntrEnable() callconv(.C) c_int;

    /// Lock a lightweight mutex
    /// `workarea` - The pointer to the workarea
    /// `lockCount` - value of increase the lock counter
    /// `pTimeout` - The pointer for timeout waiting
    /// Returns 0 on success, otherwise one of ::PspKernelErrorCodes
    pub extern fn sceKernelLockLwMutex(workarea: [*c]c_int, lockCount: c_int, pTimeout: [*c]c_uint) callconv(.C) c_int;

    /// Lock a lightweight mutex
    /// `workarea` - The pointer to the workarea
    /// `lockCount` - value of decrease the lock counter
    /// Returns 0 on success, otherwise one of ::PspKernelErrorCodes
    pub extern fn sceKernelUnlockLwMutex(workarea: [*c]c_int, lockCount: c_int) callconv(.C) c_int;

    /// Try to lock a lightweight mutex
    /// `workarea` - The pointer to the workarea
    /// `lockCount` - value of increase the lock counter
    /// Returns 0 on success, otherwise one of ::PspKernelErrorCodes
    pub extern fn sceKernelTryLockLwMutex(workarea: [*c]c_int, lockCount: c_int) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "Kernel_Library") and options.Kernel_Library)) Kernel_Library else EMPTY;

const sceImpose = struct {
    pub extern fn sceImposeGetHomePopup() callconv(.C) void;

    pub extern fn sceImposeGetLanguageMode() callconv(.C) void;

    pub extern fn sceImposeSetLanguageMode() callconv(.C) void;

    pub extern fn sceImposeHomeButton() callconv(.C) void;

    pub extern fn sceImposeSetHomePopup() callconv(.C) void;

    pub extern fn sceImposeSetUMDPopup() callconv(.C) void;

    pub extern fn sceImposeBatteryIconStatus() callconv(.C) void;

    pub extern fn sceImposeGetBacklightOffTime() callconv(.C) void;

    pub extern fn sceImposeSetBacklightOffTime() callconv(.C) void;

    pub extern fn sceImpose_9BA61B49() callconv(.C) void;

    pub extern fn sceImpose_A9884B00() callconv(.C) void;

    pub extern fn sceImpose_BB3F5DEC() callconv(.C) void;

    pub extern fn sceImposeGetUMDPopup() callconv(.C) void;

    pub extern fn sceImpose_FCD44963() callconv(.C) void;

    pub extern fn sceImpose_FF1A2F07() callconv(.C) void;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceImpose") and options.sceImpose)) sceImpose else EMPTY;

const SysMemUserForUser = struct {
    /// Get the size of the largest free memory block.
    /// Returns The size of the largest free memory block, in bytes.
    pub extern fn sceKernelMaxFreeMemSize() callconv(.C) SceSize;

    /// Get the total amount of free memory.
    /// Returns The total amount of free memory, in bytes.
    pub extern fn sceKernelTotalFreeMemSize() callconv(.C) SceSize;

    /// Allocate a memory block from a memory partition.
    /// `partitionid` - The UID of the partition to allocate from.
    /// `name` - Name assigned to the new block.
    /// `type` - Specifies how the block is allocated within the partition.  One of ::PspSysMemBlockTypes.
    /// `size` - Size of the memory block, in bytes.
    /// `addr` - If type is PSP_SMEM_Addr, then addr specifies the lowest address allocate the block from.
    /// Returns The UID of the new block, or if less than 0 an error.
    pub extern fn sceKernelAllocPartitionMemory(partitionid: SceUID, name: [*c]const c_char, type: c_int, size: SceSize, addr: ?*anyopaque) callconv(.C) SceUID;

    /// Free a memory block allocated with ::sceKernelAllocPartitionMemory.
    /// `blockid` - UID of the block to free.
    /// Returns ? on success, less than 0 on error.
    pub extern fn sceKernelFreePartitionMemory(blockid: SceUID) callconv(.C) c_int;

    /// Get the address of a memory block.
    /// `blockid` - UID of the memory block.
    /// Returns The lowest address belonging to the memory block.
    pub extern fn sceKernelGetBlockHeadAddr(blockid: SceUID) callconv(.C) ?*anyopaque;

    /// Get the firmware version.
    /// Returns The firmware version.
    /// 0x01000300 on v1.00 unit,
    /// 0x01050001 on v1.50 unit,
    /// 0x01050100 on v1.51 unit,
    /// 0x01050200 on v1.52 unit,
    /// 0x02000010 on v2.00/v2.01 unit,
    /// 0x02050010 on v2.50 unit,
    /// 0x02060010 on v2.60 unit,
    /// 0x02070010 on v2.70 unit,
    /// 0x02070110 on v2.71 unit.
    pub extern fn sceKernelDevkitVersion() callconv(.C) c_int;

    /// Kernel printf function.
    /// `format` - The format string.
    /// `...` - Arguments for the format string.
    pub extern fn sceKernelPrintf(format: [*c]const c_char, ...) callconv(.C) void;

    /// Set the version of the SDK with which the caller was compiled.
    /// Version numbers are as for sceKernelDevkitVersion().
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceKernelSetCompiledSdkVersion(version: c_int) callconv(.C) c_int;

    /// Get the SDK version set with sceKernelSetCompiledSdkVersion().
    /// Returns Version number, or 0 if unset.
    pub extern fn sceKernelGetCompiledSdkVersion() callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "SysMemUserForUser") and options.SysMemUserForUser)) SysMemUserForUser else EMPTY;

const sceSuspendForUser = struct {
    pub extern fn sceKernelPowerLock() callconv(.C) void;

    pub extern fn sceKernelPowerUnlock() callconv(.C) void;

    pub extern fn sceKernelPowerTick() callconv(.C) void;

    /// Allocate the extra 4megs of RAM
    /// `unk` - No idea as it is never used, set to anything
    /// `ptr` - Pointer to a pointer to hold the address of the memory
    /// `size` - Pointer to an int which will hold the size of the memory
    /// Returns 0 on success
    pub extern fn sceKernelVolatileMemLock(unk: c_int, ptr: ?*anyopaque, size: [*c]c_int) callconv(.C) c_int;

    /// Try and allocate the extra 4megs of RAM, will return an error if
    /// something has already allocated it
    /// `unk` - No idea as it is never used, set to anything
    /// `ptr` - Pointer to a pointer to hold the address of the memory
    /// `size` - Pointer to an int which will hold the size of the memory
    /// Returns 0 on success
    pub extern fn sceKernelVolatileMemTryLock(unk: c_int, ptr: ?*anyopaque, size: [*c]c_int) callconv(.C) c_int;

    /// Deallocate the extra 4 megs of RAM
    /// `unk` - Set to 0, otherwise it fails in 3.52+, possibly earlier
    /// Returns 0 on success
    pub extern fn sceKernelVolatileMemUnlock(unk: c_int) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceSuspendForUser") and options.sceSuspendForUser)) sceSuspendForUser else EMPTY;

const ModuleMgrForUser = struct {
    /// Load a module from the given file UID.
    /// `fid` - The module's file UID.
    /// `flags` - Unused, always 0.
    /// `option` - Pointer to an optional ::SceKernelLMOption structure.
    /// Returns The UID of the loaded module on success, otherwise one of ::PspKernelErrorCodes.
    pub extern fn sceKernelLoadModuleByID(fid: SceUID, flags: c_int, option: [*c]c_int) callconv(.C) SceUID;

    /// Load a module.
    /// @note This function restricts where it can load from (such as from flash0)
    /// unless you call it in kernel mode. It also must be called from a thread.
    /// `path` - The path to the module to load.
    /// `flags` - Unused, always 0 .
    /// `option` - Pointer to a mod_param_t structure. Can be NULL.
    /// Returns The UID of the loaded module on success, otherwise one of ::PspKernelErrorCodes.
    pub extern fn sceKernelLoadModule(path: [*c]const c_char, flags: c_int, option: [*c]c_int) callconv(.C) SceUID;

    /// Load a module from MS.
    /// @note This function restricts what it can load, e.g. it wont load plain executables.
    /// `path` - The path to the module to load.
    /// `flags` - Unused, set to 0.
    /// `option` - Pointer to a mod_param_t structure. Can be NULL.
    /// Returns The UID of the loaded module on success, otherwise one of ::PspKernelErrorCodes.
    pub extern fn sceKernelLoadModuleMs(path: [*c]const c_char, flags: c_int, option: [*c]c_int) callconv(.C) SceUID;

    /// Load a module from a buffer using the USB/WLAN API.
    /// Can only be called from kernel mode, or from a thread that has attributes of 0xa0000000.
    /// `bufsize` - Size (in bytes) of the buffer pointed to by buf.
    /// `buf` - Pointer to a buffer containing the module to load.  The buffer must reside at an
    /// address that is a multiple to 64 bytes.
    /// `flags` - Unused, always 0.
    /// `option` - Pointer to an optional ::SceKernelLMOption structure.
    /// Returns The UID of the loaded module on success, otherwise one of ::PspKernelErrorCodes.
    pub extern fn sceKernelLoadModuleBufferUsbWlan(bufsize: SceSize, buf: ?*anyopaque, flags: c_int, option: [*c]c_int) callconv(.C) SceUID;

    /// Start a loaded module.
    /// `modid` - The ID of the module returned from LoadModule.
    /// `argsize` - Length of the args.
    /// `argp` - A pointer to the arguments to the module.
    /// `status` - Returns the status of the start.
    /// `option` - Pointer to an optional ::SceKernelSMOption structure.
    /// Returns ??? on success, otherwise one of ::PspKernelErrorCodes.
    pub extern fn sceKernelStartModule(modid: SceUID, argsize: SceSize, argp: ?*anyopaque, status: [*c]c_int, option: [*c]c_int) callconv(.C) c_int;

    /// Stop a running module.
    /// `modid` - The UID of the module to stop.
    /// `argsize` - The length of the arguments pointed to by argp.
    /// `argp` - Pointer to arguments to pass to the module's module_stop() routine.
    /// `status` - Return value of the module's module_stop() routine.
    /// `option` - Pointer to an optional ::SceKernelSMOption structure.
    /// Returns ??? on success, otherwise one of ::PspKernelErrorCodes.
    pub extern fn sceKernelStopModule(modid: SceUID, argsize: SceSize, argp: ?*anyopaque, status: [*c]c_int, option: [*c]c_int) callconv(.C) c_int;

    /// Unload a stopped module.
    /// `modid` - The UID of the module to unload.
    /// Returns ??? on success, otherwise one of ::PspKernelErrorCodes.
    pub extern fn sceKernelUnloadModule(modid: SceUID) callconv(.C) c_int;

    /// Stop and unload the current module.
    /// `unknown` - Unknown (I've seen 1 passed).
    /// `argsize` - Size (in bytes) of the arguments that will be passed to module_stop().
    /// `argp` - Pointer to arguments that will be passed to module_stop().
    /// Returns ??? on success, otherwise one of ::PspKernelErrorCodes.
    pub extern fn sceKernelSelfStopUnloadModule(unknown: c_int, argsize: SceSize, argp: ?*anyopaque) callconv(.C) c_int;

    /// Stop and unload the current module.
    /// `argsize` - Size (in bytes) of the arguments that will be passed to module_stop().
    /// `argp` - Poitner to arguments that will be passed to module_stop().
    /// `status` - Return value from module_stop().
    /// `option` - Pointer to an optional ::SceKernelSMOption structure.
    /// Returns ??? on success, otherwise one of ::PspKernelErrorCodes.
    pub extern fn sceKernelStopUnloadSelfModule(argsize: SceSize, argp: ?*anyopaque, status: [*c]c_int, option: [*c]c_int) callconv(.C) c_int;

    /// Query the information about a loaded module from its UID.
    /// @note This fails on v1.0 firmware (and even it worked has a limited structure)
    /// so if you want to be compatible with both 1.5 and 1.0 (and you are running in
    /// kernel mode) then call this function first then ::pspSdkQueryModuleInfoV1
    /// if it fails, or make separate v1 and v1.5+ builds.
    /// `modid` - The UID of the loaded module.
    /// `info` - Pointer to a ::SceKernelModuleInfo structure.
    /// Returns 0 on success, otherwise one of ::PspKernelErrorCodes.
    pub extern fn sceKernelQueryModuleInfo(modid: SceUID, info: [*c]c_int) callconv(.C) c_int;

    /// Get a list of module IDs. NOTE: This is only available on 1.5 firmware
    /// and above. For V1 use ::pspSdkGetModuleIdList.
    /// `readbuf` - Buffer to store the module list.
    /// `readbufsize` - Number of elements in the readbuffer.
    /// `idcount` - Returns the number of module ids
    /// Returns >= 0 on success
    pub extern fn sceKernelGetModuleIdList(readbuf: [*c]SceUID, readbufsize: c_int, idcount: [*c]c_int) callconv(.C) c_int;

    /// Get the ID of the module occupying the address
    /// `moduleAddr` - A pointer to the module
    /// Returns >= 0 on success, otherwise one of ::PspKernelErrorCodes
    pub extern fn sceKernelGetModuleIdByAddress(moduleAddr: ?*const anyopaque) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "ModuleMgrForUser") and options.ModuleMgrForUser)) ModuleMgrForUser else EMPTY;

const IoFileMgrForUser = struct {
    /// Poll for asyncronous completion.
    /// `fd` - The file descriptor which is current performing an asynchronous action.
    /// `res` - The result of the async action.
    /// Returns < 0 on error.
    pub extern fn sceIoPollAsync(fd: SceUID, res: [*c]SceInt64) callconv(.C) c_int;

    /// Wait for asyncronous completion.
    /// `fd` - The file descriptor which is current performing an asynchronous action.
    /// `res` - The result of the async action.
    /// Returns < 0 on error.
    pub extern fn sceIoWaitAsync(fd: SceUID, res: [*c]SceInt64) callconv(.C) c_int;

    /// Wait for asyncronous completion (with callbacks).
    /// `fd` - The file descriptor which is current performing an asynchronous action.
    /// `res` - The result of the async action.
    /// Returns < 0 on error.
    pub extern fn sceIoWaitAsyncCB(fd: SceUID, res: [*c]SceInt64) callconv(.C) c_int;

    /// Get the asyncronous completion status.
    /// `fd` - The file descriptor which is current performing an asynchronous action.
    /// `poll` - If 0 then waits for the status, otherwise it polls the fd.
    /// `res` - The result of the async action.
    /// Returns < 0 on error.
    pub extern fn sceIoGetAsyncStat(fd: SceUID, poll: c_int, res: [*c]SceInt64) callconv(.C) c_int;

    /// Change the priority of the asynchronous thread.
    /// `fd` - The opened fd on which the priority should be changed.
    /// `pri` - The priority of the thread.
    /// Returns < 0 on error.
    pub extern fn sceIoChangeAsyncPriority(fd: SceUID, pri: c_int) callconv(.C) c_int;

    /// Sets a callback for the asynchronous action.
    /// `fd` - The filedescriptor currently performing an asynchronous action.
    /// `cb` - The UID of the callback created with ::sceKernelCreateCallback
    /// `argp` - Pointer to an argument to pass to the callback.
    /// Returns < 0 on error.
    pub extern fn sceIoSetAsyncCallback(fd: SceUID, cb: SceUID, argp: ?*anyopaque) callconv(.C) c_int;

    /// Delete a descriptor
    /// `
    /// sceIoClose(fd);
    /// `
    /// `fd` - File descriptor to close
    /// Returns < 0 on error
    pub extern fn sceIoClose(fd: SceUID) callconv(.C) c_int;

    /// Delete a descriptor (asynchronous)
    /// `fd` - File descriptor to close
    /// Returns < 0 on error
    pub extern fn sceIoCloseAsync(fd: SceUID) callconv(.C) c_int;

    /// Open or create a file for reading or writing
    /// @par Example1: Open a file for reading
    /// `
    /// if(!(fd = sceIoOpen("device:/path/to/file", O_RDONLY, 0777)) {
    /// // error
    /// }
    /// `
    /// @par Example2: Open a file for writing, creating it if it doesnt exist
    /// `
    /// if(!(fd = sceIoOpen("device:/path/to/file", O_WRONLY|O_CREAT, 0777)) {
    /// // error
    /// }
    /// `
    /// `file` - Pointer to a string holding the name of the file to open
    /// `flags` - Libc styled flags that are or'ed together
    /// `mode` - File access mode.
    /// Returns A non-negative integer is a valid fd, anything else an error
    pub extern fn sceIoOpen(file: [*c]const c_char, flags: c_int, mode: SceMode) callconv(.C) SceUID;

    /// Open or create a file for reading or writing (asynchronous)
    /// `file` - Pointer to a string holding the name of the file to open
    /// `flags` - Libc styled flags that are or'ed together
    /// `mode` - File access mode.
    /// Returns A non-negative integer is a valid fd, anything else an error
    pub extern fn sceIoOpenAsync(file: [*c]const c_char, flags: c_int, mode: SceMode) callconv(.C) SceUID;

    /// Read input
    /// @par Example:
    /// `
    /// bytes_read = sceIoRead(fd, data, 100);
    /// `
    /// `fd` - Opened file descriptor to read from
    /// `data` - Pointer to the buffer where the read data will be placed
    /// `size` - Size of the read in bytes
    /// Returns The number of bytes read
    pub extern fn sceIoRead(fd: SceUID, data: ?*anyopaque, size: SceSize) callconv(.C) c_int;

    /// Read input (asynchronous)
    /// @par Example:
    /// `
    /// bytes_read = sceIoRead(fd, data, 100);
    /// `
    /// `fd` - Opened file descriptor to read from
    /// `data` - Pointer to the buffer where the read data will be placed
    /// `size` - Size of the read in bytes
    /// Returns < 0 on error.
    pub extern fn sceIoReadAsync(fd: SceUID, data: ?*anyopaque, size: SceSize) callconv(.C) c_int;

    /// Write output
    /// @par Example:
    /// `
    /// bytes_written = sceIoWrite(fd, data, 100);
    /// `
    /// `fd` - Opened file descriptor to write to
    /// `data` - Pointer to the data to write
    /// `size` - Size of data to write
    /// Returns The number of bytes written
    pub extern fn sceIoWrite(fd: SceUID, data: ?*const anyopaque, size: SceSize) callconv(.C) c_int;

    /// Write output (asynchronous)
    /// `fd` - Opened file descriptor to write to
    /// `data` - Pointer to the data to write
    /// `size` - Size of data to write
    /// Returns < 0 on error.
    pub extern fn sceIoWriteAsync(fd: SceUID, data: ?*const anyopaque, size: SceSize) callconv(.C) c_int;

    /// Reposition read/write file descriptor offset
    /// @par Example:
    /// `
    /// pos = sceIoLseek(fd, -10, SEEK_END);
    /// `
    /// `fd` - Opened file descriptor with which to seek
    /// `offset` - Relative offset from the start position given by whence
    /// `whence` - Set to SEEK_SET to seek from the start of the file, SEEK_CUR
    /// seek from the current position and SEEK_END to seek from the end.
    /// Returns The position in the file after the seek.
    pub extern fn sceIoLseek(fd: SceUID, offset: SceOff, whence: c_int) callconv(.C) SceOff;

    /// Reposition read/write file descriptor offset (asynchronous)
    /// `fd` - Opened file descriptor with which to seek
    /// `offset` - Relative offset from the start position given by whence
    /// `whence` - Set to SEEK_SET to seek from the start of the file, SEEK_CUR
    /// seek from the current position and SEEK_END to seek from the end.
    /// Returns < 0 on error. Actual value should be passed returned by the ::sceIoWaitAsync call.
    pub extern fn sceIoLseekAsync(fd: SceUID, offset: SceOff, whence: c_int) callconv(.C) c_int;

    /// Reposition read/write file descriptor offset (32bit mode)
    /// @par Example:
    /// `
    /// pos = sceIoLseek32(fd, -10, SEEK_END);
    /// `
    /// `fd` - Opened file descriptor with which to seek
    /// `offset` - Relative offset from the start position given by whence
    /// `whence` - Set to SEEK_SET to seek from the start of the file, SEEK_CUR
    /// seek from the current position and SEEK_END to seek from the end.
    /// Returns The position in the file after the seek.
    pub extern fn sceIoLseek32(fd: SceUID, offset: c_int, whence: c_int) callconv(.C) c_int;

    /// Reposition read/write file descriptor offset (32bit mode, asynchronous)
    /// `fd` - Opened file descriptor with which to seek
    /// `offset` - Relative offset from the start position given by whence
    /// `whence` - Set to SEEK_SET to seek from the start of the file, SEEK_CUR
    /// seek from the current position and SEEK_END to seek from the end.
    /// Returns < 0 on error.
    pub extern fn sceIoLseek32Async(fd: SceUID, offset: c_int, whence: c_int) callconv(.C) c_int;

    /// Perform an ioctl on a device.
    /// `fd` - Opened file descriptor to ioctl to
    /// `cmd` - The command to send to the device
    /// `indata` - A data block to send to the device, if NULL sends no data
    /// `inlen` - Length of indata, if 0 sends no data
    /// `outdata` - A data block to receive the result of a command, if NULL receives no data
    /// `outlen` - Length of outdata, if 0 receives no data
    /// Returns 0 on success, < 0 on error
    pub extern fn sceIoIoctl(fd: SceUID, cmd: c_uint, indata: ?*anyopaque, inlen: c_int, outdata: ?*anyopaque, outlen: c_int) callconv(.C) c_int;

    /// Perform an ioctl on a device. (asynchronous)
    /// `fd` - Opened file descriptor to ioctl to
    /// `cmd` - The command to send to the device
    /// `indata` - A data block to send to the device, if NULL sends no data
    /// `inlen` - Length of indata, if 0 sends no data
    /// `outdata` - A data block to receive the result of a command, if NULL receives no data
    /// `outlen` - Length of outdata, if 0 receives no data
    /// Returns 0 on success, < 0 on error
    pub extern fn sceIoIoctlAsync(fd: SceUID, cmd: c_uint, indata: ?*anyopaque, inlen: c_int, outdata: ?*anyopaque, outlen: c_int) callconv(.C) c_int;

    /// Open a directory
    /// @par Example:
    /// `
    /// int dfd;
    /// dfd = sceIoDopen("device:/");
    /// if(dfd >= 0)
    /// { Do something with the file descriptor }
    /// `
    /// `dirname` - The directory to open for reading.
    /// Returns If >= 0 then a valid file descriptor, otherwise a Sony error code.
    pub extern fn sceIoDopen(dirname: [*c]const c_char) callconv(.C) SceUID;

    /// Reads an entry from an opened file descriptor.
    /// `fd` - Already opened file descriptor (using sceIoDopen)
    /// `dir` - Pointer to an io_dirent_t structure to hold the file information
    /// Returns Read status
    /// -   0 - No more directory entries left
    /// - > 0 - More directory entired to go
    /// - < 0 - Error
    pub extern fn sceIoDread(fd: SceUID, dir: [*c]c_int) callconv(.C) c_int;

    /// Close an opened directory file descriptor
    /// `fd` - Already opened file descriptor (using sceIoDopen)
    /// Returns < 0 on error
    pub extern fn sceIoDclose(fd: SceUID) callconv(.C) c_int;

    /// Remove directory entry
    /// `file` - Path to the file to remove
    /// Returns < 0 on error
    pub extern fn sceIoRemove(file: [*c]const c_char) callconv(.C) c_int;

    /// Make a directory file
    /// `dir`
    /// `mode` - Access mode.
    /// Returns Returns the value 0 if its succesful otherwise -1
    pub extern fn sceIoMkdir(dir: [*c]const c_char, mode: SceMode) callconv(.C) c_int;

    /// Remove a directory file
    /// `path` - Removes a directory file pointed by the string path
    /// Returns Returns the value 0 if its succesful otherwise -1
    pub extern fn sceIoRmdir(path: [*c]const c_char) callconv(.C) c_int;

    /// Change the current directory.
    /// `path` - The path to change to.
    /// Returns < 0 on error.
    pub extern fn sceIoChdir(path: [*c]const c_char) callconv(.C) c_int;

    /// Synchronise the file data on the device.
    /// `device` - The device to synchronise (e.g. msfat0:)
    /// `unk` - Unknown
    pub extern fn sceIoSync(device: [*c]const c_char, unk: c_uint) callconv(.C) c_int;

    /// Get the status of a file.
    /// `file` - The path to the file.
    /// `stat` - A pointer to an io_stat_t structure.
    /// Returns < 0 on error.
    pub extern fn sceIoGetstat(file: [*c]const c_char, stat: [*c]c_int) callconv(.C) c_int;

    /// Change the status of a file.
    /// `file` - The path to the file.
    /// `stat` - A pointer to an io_stat_t structure.
    /// `bits` - Bitmask defining which bits to change.
    /// Returns < 0 on error.
    pub extern fn sceIoChstat(file: [*c]const c_char, stat: [*c]c_int, bits: c_int) callconv(.C) c_int;

    /// Change the name of a file
    /// `oldname` - The old filename
    /// `newname` - The new filename
    /// Returns < 0 on error.
    pub extern fn sceIoRename(oldname: [*c]const c_char, newname: [*c]const c_char) callconv(.C) c_int;

    /// Send a devctl command to a device.
    /// @par Example: Sending a simple command to a device (not a real devctl)
    /// `
    /// sceIoDevctl("ms0:", 0x200000, indata, 4, NULL, NULL);
    /// `
    /// `dev` - String for the device to send the devctl to (e.g. "ms0:")
    /// `cmd` - The command to send to the device
    /// `indata` - A data block to send to the device, if NULL sends no data
    /// `inlen` - Length of indata, if 0 sends no data
    /// `outdata` - A data block to receive the result of a command, if NULL receives no data
    /// `outlen` - Length of outdata, if 0 receives no data
    /// Returns 0 on success, < 0 on error
    pub extern fn sceIoDevctl(dev: [*c]const c_char, cmd: c_uint, indata: ?*anyopaque, inlen: c_int, outdata: ?*anyopaque, outlen: c_int) callconv(.C) c_int;

    /// Get the device type of the currently opened file descriptor.
    /// `fd` - The opened file descriptor.
    /// Returns < 0 on error. Otherwise the device type?
    pub extern fn sceIoGetDevType(fd: SceUID) callconv(.C) c_int;

    /// Assigns one IO device to another (I guess)
    /// `dev1` - The device name to assign.
    /// `dev2` - The block device to assign from.
    /// `dev3` - The filesystem device to mape the block device to dev1
    /// `mode` - Read/Write mode. One of IoAssignPerms.
    /// `unk1` - Unknown, set to NULL.
    /// `unk2` - Unknown, set to 0.
    /// Returns < 0 on error.
    /// @par Example: Reassign flash0 in read/write mode.
    /// `
    /// sceIoUnassign("flash0");
    /// sceIoAssign("flash0", "lflash0:0,0", "flashfat0:", IOASSIGN_RDWR, NULL, 0);
    /// `
    pub extern fn sceIoAssign(dev1: [*c]const c_char, dev2: [*c]const c_char, dev3: [*c]const c_char, mode: c_int, unk1: ?*anyopaque, unk2: c_long) callconv(.C) c_int;

    /// Unassign an IO device.
    /// `dev` - The device to unassign.
    /// Returns < 0 on error
    /// @par Example: See ::sceIoAssign
    pub extern fn sceIoUnassign(dev: [*c]const c_char) callconv(.C) c_int;

    /// Cancel an asynchronous operation on a file descriptor.
    /// `fd` - The file descriptor to perform cancel on.
    /// Returns < 0 on error.
    pub extern fn sceIoCancel(fd: SceUID) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "IoFileMgrForUser") and options.IoFileMgrForUser)) IoFileMgrForUser else EMPTY;

const UtilsForUser = struct {
    /// Invalidate a range of addresses in data cache
    pub extern fn sceKernelDcacheInvalidateRange(p: ?*const anyopaque, size: c_uint) callconv(.C) void;

    /// Function to perform an MD5 digest of a data block.
    /// `data` - Pointer to a data block to make a digest of.
    /// `size` - Size of the data block.
    /// `digest` - Pointer to a 16byte buffer to store the resulting digest
    /// Returns < 0 on error.
    pub extern fn sceKernelUtilsMd5Digest(data: [*c]u8, size: u32, digest: [*c]u8) callconv(.C) c_int;

    /// Function to initialise a MD5 digest context
    /// `ctx` - A context block to initialise
    /// Returns < 0 on error.
    /// @par Example:
    /// `
    /// SceKernelUtilsMd5Context ctx;
    /// u8 digest[16];
    /// sceKernelUtilsMd5BlockInit(&ctx);
    /// sceKernelUtilsMd5BlockUpdate(&ctx, (u8*) "Hello", 5);
    /// sceKernelUtilsMd5BlockResult(&ctx, digest);
    /// `
    pub extern fn sceKernelUtilsMd5BlockInit(ctx: [*c]c_int) callconv(.C) c_int;

    /// Function to update the MD5 digest with a block of data.
    /// `ctx` - A filled in context block.
    /// `data` - The data block to hash.
    /// `size` - The size of the data to hash
    /// Returns < 0 on error.
    pub extern fn sceKernelUtilsMd5BlockUpdate(ctx: [*c]c_int, data: [*c]u8, size: u32) callconv(.C) c_int;

    /// Function to get the digest result of the MD5 hash.
    /// `ctx` - A filled in context block.
    /// `digest` - A 16 byte array to hold the digest.
    /// Returns < 0 on error.
    pub extern fn sceKernelUtilsMd5BlockResult(ctx: [*c]c_int, digest: [*c]u8) callconv(.C) c_int;

    /// Function to SHA1 hash a data block.
    /// `data` - The data to hash.
    /// `size` - The size of the data.
    /// `digest` - Pointer to a 20 byte array for storing the digest
    /// Returns < 0 on error.
    pub extern fn sceKernelUtilsSha1Digest(data: [*c]u8, size: u32, digest: [*c]u8) callconv(.C) c_int;

    /// Function to initialise a context for SHA1 hashing.
    /// `ctx` - Pointer to a context.
    /// Returns < 0 on error.
    /// @par Example:
    /// `
    /// SceKernelUtilsSha1Context ctx;
    /// u8 digest[20];
    /// sceKernelUtilsSha1BlockInit(&ctx);
    /// sceKernelUtilsSha1BlockUpdate(&ctx, (u8*) "Hello", 5);
    /// sceKernelUtilsSha1BlockResult(&ctx, digest);
    /// `
    pub extern fn sceKernelUtilsSha1BlockInit(ctx: [*c]c_int) callconv(.C) c_int;

    /// Function to update the current hash.
    /// `ctx` - Pointer to a prefilled context.
    /// `data` - The data block to hash.
    /// `size` - The size of the data block
    /// Returns < 0 on error.
    pub extern fn sceKernelUtilsSha1BlockUpdate(ctx: [*c]c_int, data: [*c]u8, size: u32) callconv(.C) c_int;

    /// Function to get the result of the SHA1 hash.
    /// `ctx` - Pointer to a prefilled context.
    /// `digest` - A pointer to a 20 byte array to contain the digest.
    /// Returns < 0 on error.
    pub extern fn sceKernelUtilsSha1BlockResult(ctx: [*c]c_int, digest: [*c]u8) callconv(.C) c_int;

    /// Function to initialise a mersenne twister context.
    /// `ctx` - Pointer to a context
    /// `seed` - A seed for the random function.
    /// @par Example:
    /// `
    /// SceKernelUtilsMt19937Context ctx;
    /// sceKernelUtilsMt19937Init(&ctx, time(NULL));
    /// u23 rand_val = sceKernelUtilsMt19937UInt(&ctx);
    /// `
    /// Returns < 0 on error.
    pub extern fn sceKernelUtilsMt19937Init(ctx: [*c]c_int, seed: u32) callconv(.C) c_int;

    /// Function to return a new psuedo random number.
    /// `ctx` - Pointer to a pre-initialised context.
    /// Returns A pseudo random number (between 0 and MAX_INT).
    pub extern fn sceKernelUtilsMt19937UInt(ctx: [*c]c_int) callconv(.C) u32;

    pub extern fn sceKernelGetGPI() callconv(.C) void;

    pub extern fn sceKernelSetGPO() callconv(.C) void;

    /// Get the processor clock used since the start of the process
    pub extern fn sceKernelLibcClock() callconv(.C) c_int;

    /// Get the time in seconds since the epoc (1st Jan 1970)
    pub extern fn sceKernelLibcTime(t: [*c]c_int) callconv(.C) c_int;

    /// Get the current time of time and time zone information
    pub extern fn sceKernelLibcGettimeofday(tp: [*c]c_int, tzp: [*c]c_int) callconv(.C) c_int;

    /// Write back the data cache to memory
    pub extern fn sceKernelDcacheWritebackAll() callconv(.C) void;

    /// Write back and invalidate the data cache
    pub extern fn sceKernelDcacheWritebackInvalidateAll() callconv(.C) void;

    /// Write back a range of addresses from the data cache to memory
    pub extern fn sceKernelDcacheWritebackRange(p: ?*const anyopaque, size: c_uint) callconv(.C) void;

    /// Write back and invalidate a range of addresses in the data cache
    pub extern fn sceKernelDcacheWritebackInvalidateRange(p: ?*const anyopaque, size: c_uint) callconv(.C) void;

    pub extern fn sceKernelDcacheProbe() callconv(.C) void;

    pub extern fn sceKernelDcacheReadTag() callconv(.C) void;

    pub extern fn sceKernelIcacheProbe() callconv(.C) void;

    pub extern fn sceKernelIcacheReadTag() callconv(.C) void;

    /// Invalidate the instruction cache
    pub extern fn sceKernelIcacheInvalidateAll() callconv(.C) void;

    /// Invalidate a range of addresses in the instruction cache
    pub extern fn sceKernelIcacheInvalidateRange(p: ?*const anyopaque, size: c_uint) callconv(.C) void;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "UtilsForUser") and options.UtilsForUser)) UtilsForUser else EMPTY;

const InterruptManager = struct {
    /// Register a sub interrupt handler.
    /// `intno` - The interrupt number to register.
    /// `no` - The sub interrupt handler number (user controlled)
    /// `handler` - The interrupt handler
    /// `arg` - An argument passed to the interrupt handler
    /// Returns < 0 on error.
    pub extern fn sceKernelRegisterSubIntrHandler(intno: c_int, no: c_int, handler: ?*anyopaque, arg: ?*anyopaque) callconv(.C) c_int;

    /// Release a sub interrupt handler.
    /// `intno` - The interrupt number to register.
    /// `no` - The sub interrupt handler number
    /// Returns < 0 on error.
    pub extern fn sceKernelReleaseSubIntrHandler(intno: c_int, no: c_int) callconv(.C) c_int;

    /// Enable a sub interrupt.
    /// `intno` - The sub interrupt to enable.
    /// `no` - The sub interrupt handler number
    /// Returns < 0 on error.
    pub extern fn sceKernelEnableSubIntr(intno: c_int, no: c_int) callconv(.C) c_int;

    /// Disable a sub interrupt handler.
    /// `intno` - The sub interrupt to disable.
    /// `no` - The sub interrupt handler number
    /// Returns < 0 on error.
    pub extern fn sceKernelDisableSubIntr(intno: c_int, no: c_int) callconv(.C) c_int;

    pub extern fn sceKernelSuspendSubIntr() callconv(.C) void;

    pub extern fn sceKernelResumeSubIntr() callconv(.C) void;

    pub extern fn sceKernelIsSubInterruptOccurred() callconv(.C) void;

    pub extern fn QueryIntrHandlerInfo(intr_code: SceUID, sub_intr_code: SceUID, data: [*c]c_int) callconv(.C) c_int;

    pub extern fn sceKernelRegisterUserSpaceIntrStack() callconv(.C) void;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "InterruptManager") and options.InterruptManager)) InterruptManager else EMPTY;

const ThreadManForUser = struct {
    /// Return from a callback (used as a syscall for the return
    /// of the callback function)
    pub extern fn _sceKernelReturnFromCallback() callconv(.C) void;

    /// Register a thread event handler
    /// `name` - Name for the thread event handler
    /// `threadID` - Thread ID to monitor
    /// `mask` - Bit mask for what events to handle (only lowest 4 bits valid)
    /// `handler` - Pointer to a ::SceKernelThreadEventHandler function
    /// `common` - Common pointer
    /// Returns The UID of the create event handler, < 0 on error
    pub extern fn sceKernelRegisterThreadEventHandler(name: [*c]const c_char, threadID: SceUID, mask: c_int, handler: c_int, common: ?*anyopaque) callconv(.C) SceUID;

    /// Release a thread event handler.
    /// `uid` - The UID of the event handler
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelReleaseThreadEventHandler(uid: SceUID) callconv(.C) c_int;

    /// Refer the status of an thread event handler
    /// `uid` - The UID of the event handler
    /// `info` - Pointer to a ::SceKernelThreadEventHandlerInfo structure
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelReferThreadEventHandlerStatus(uid: SceUID, info: [*c]c_int) callconv(.C) c_int;

    /// Create callback
    /// @par Example:
    /// `
    /// int cbid;
    /// cbid = sceKernelCreateCallback("Exit Callback", exit_cb, NULL);
    /// `
    /// `name` - A textual name for the callback
    /// `func` - A pointer to a function that will be called as the callback
    /// `arg` - Argument for the callback ?
    /// Returns >= 0 A callback id which can be used in subsequent functions, < 0 an error.
    pub extern fn sceKernelCreateCallback(name: [*c]const c_char, func: c_int, arg: ?*anyopaque) callconv(.C) c_int;

    /// Delete a callback
    /// `cb` - The UID of the specified callback
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelDeleteCallback(cb: SceUID) callconv(.C) c_int;

    /// Notify a callback
    /// `cb` - The UID of the specified callback
    /// `arg2` - Passed as arg2 into the callback function
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelNotifyCallback(cb: SceUID, arg2: c_int) callconv(.C) c_int;

    /// Cancel a callback ?
    /// `cb` - The UID of the specified callback
    /// Returns 0 on succes, < 0 on error
    pub extern fn sceKernelCancelCallback(cb: SceUID) callconv(.C) c_int;

    /// Get the callback count
    /// `cb` - The UID of the specified callback
    /// Returns The callback count, < 0 on error
    pub extern fn sceKernelGetCallbackCount(cb: SceUID) callconv(.C) c_int;

    /// Check callback ?
    /// Returns Something or another
    pub extern fn sceKernelCheckCallback() callconv(.C) c_int;

    /// Gets the status of a specified callback.
    /// `cb` - The UID of the callback to refer.
    /// `status` - Pointer to a status structure. The size parameter should be
    /// initialised before calling.
    /// Returns < 0 on error.
    pub extern fn sceKernelReferCallbackStatus(cb: SceUID, status: [*c]c_int) callconv(.C) c_int;

    /// Sleep thread
    /// Returns < 0 on error.
    pub extern fn sceKernelSleepThread() callconv(.C) c_int;

    /// Sleep thread but service any callbacks as necessary
    /// @par Example:
    /// `
    /// // Once all callbacks have been setup call this function
    /// sceKernelSleepThreadCB();
    /// `
    pub extern fn sceKernelSleepThreadCB() callconv(.C) c_int;

    /// Wake a thread previously put into the sleep state.
    /// `thid` - UID of the thread to wake.
    /// Returns Success if >= 0, an error if < 0.
    pub extern fn sceKernelWakeupThread(thid: SceUID) callconv(.C) c_int;

    /// Cancel a thread that was to be woken with ::sceKernelWakeupThread.
    /// `thid` - UID of the thread to cancel.
    /// Returns Success if >= 0, an error if < 0.
    pub extern fn sceKernelCancelWakeupThread(thid: SceUID) callconv(.C) c_int;

    /// Suspend a thread.
    /// `thid` - UID of the thread to suspend.
    /// Returns Success if >= 0, an error if < 0.
    pub extern fn sceKernelSuspendThread(thid: SceUID) callconv(.C) c_int;

    /// Resume a thread previously put into a suspended state with ::sceKernelSuspendThread.
    /// `thid` - UID of the thread to resume.
    /// Returns Success if >= 0, an error if < 0.
    pub extern fn sceKernelResumeThread(thid: SceUID) callconv(.C) c_int;

    /// Wait until a thread has ended.
    /// `thid` - Id of the thread to wait for.
    /// `timeout` - Timeout in microseconds (assumed).
    /// Returns < 0 on error.
    pub extern fn sceKernelWaitThreadEnd(thid: SceUID, timeout: [*c]SceUInt) callconv(.C) c_int;

    /// Wait until a thread has ended and handle callbacks if necessary.
    /// `thid` - Id of the thread to wait for.
    /// `timeout` - Timeout in microseconds (assumed).
    /// Returns < 0 on error.
    pub extern fn sceKernelWaitThreadEndCB(thid: SceUID, timeout: [*c]SceUInt) callconv(.C) c_int;

    /// Delay the current thread by a specified number of microseconds
    /// `delay` - Delay in microseconds.
    /// @par Example:
    /// `
    /// sceKernelDelayThread(1000000); // Delay for a second
    /// `
    pub extern fn sceKernelDelayThread(delay: SceUInt) callconv(.C) c_int;

    /// Delay the current thread by a specified number of microseconds and handle any callbacks.
    /// `delay` - Delay in microseconds.
    /// @par Example:
    /// `
    /// sceKernelDelayThread(1000000); // Delay for a second
    /// `
    pub extern fn sceKernelDelayThreadCB(delay: SceUInt) callconv(.C) c_int;

    /// Delay the current thread by a specified number of sysclocks
    /// `delay` - Delay in sysclocks
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelDelaySysClockThread(delay: [*c]c_int) callconv(.C) c_int;

    /// Delay the current thread by a specified number of sysclocks handling callbacks
    /// `delay` - Delay in sysclocks
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelDelaySysClockThreadCB(delay: [*c]c_int) callconv(.C) c_int;

    /// Creates a new semaphore
    /// @par Example:
    /// `
    /// int semaid;
    /// semaid = sceKernelCreateSema("MyMutex", 0, 1, 1, 0);
    /// `
    /// `name` - Specifies the name of the sema
    /// `attr` - Sema attribute flags (normally set to 0)
    /// `initVal` - Sema initial value
    /// `maxVal` - Sema maximum value
    /// `option` - Sema options (normally set to 0)
    /// Returns A semaphore id
    pub extern fn sceKernelCreateSema(name: [*c]const c_char, attr: SceUInt, initVal: c_int, maxVal: c_int, option: [*c]c_int) callconv(.C) SceUID;

    /// Destroy a semaphore
    /// `semaid` - The semaid returned from a previous create call.
    /// Returns Returns the value 0 if its succesful otherwise -1
    pub extern fn sceKernelDeleteSema(semaid: SceUID) callconv(.C) c_int;

    /// Send a signal to a semaphore
    /// @par Example:
    /// `
    /// // Signal the sema
    /// sceKernelSignalSema(semaid, 1);
    /// `
    /// `semaid` - The sema id returned from sceKernelCreateSema
    /// `signal` - The amount to signal the sema (i.e. if 2 then increment the sema by 2)
    /// Returns < 0 On error.
    pub extern fn sceKernelSignalSema(semaid: SceUID, signal: c_int) callconv(.C) c_int;

    /// Lock a semaphore
    /// @par Example:
    /// `
    /// sceKernelWaitSema(semaid, 1, 0);
    /// `
    /// `semaid` - The sema id returned from sceKernelCreateSema
    /// `signal` - The value to wait for (i.e. if 1 then wait till reaches a signal state of 1)
    /// `timeout` - Timeout in microseconds (assumed).
    /// Returns < 0 on error.
    pub extern fn sceKernelWaitSema(semaid: SceUID, signal: c_int, timeout: [*c]SceUInt) callconv(.C) c_int;

    /// Lock a semaphore a handle callbacks if necessary.
    /// @par Example:
    /// `
    /// sceKernelWaitSemaCB(semaid, 1, 0);
    /// `
    /// `semaid` - The sema id returned from sceKernelCreateSema
    /// `signal` - The value to wait for (i.e. if 1 then wait till reaches a signal state of 1)
    /// `timeout` - Timeout in microseconds (assumed).
    /// Returns < 0 on error.
    pub extern fn sceKernelWaitSemaCB(semaid: SceUID, signal: c_int, timeout: [*c]SceUInt) callconv(.C) c_int;

    /// Poll a sempahore.
    /// `semaid` - UID of the semaphore to poll.
    /// `signal` - The value to test for.
    /// Returns < 0 on error.
    pub extern fn sceKernelPollSema(semaid: SceUID, signal: c_int) callconv(.C) c_int;

    pub extern fn sceKernelCancelSema() callconv(.C) void;

    /// Retrieve information about a semaphore.
    /// `semaid` - UID of the semaphore to retrieve info for.
    /// `info` - Pointer to a ::SceKernelSemaInfo struct to receive the info.
    /// Returns < 0 on error.
    pub extern fn sceKernelReferSemaStatus(semaid: SceUID, info: [*c]c_int) callconv(.C) c_int;

    /// Create an event flag.
    /// `name` - The name of the event flag.
    /// `attr` - Attributes from ::PspEventFlagAttributes
    /// `bits` - Initial bit pattern.
    /// `opt` - Options, set to NULL
    /// Returns < 0 on error. >= 0 event flag id.
    /// @par Example:
    /// `
    /// int evid;
    /// evid = sceKernelCreateEventFlag("wait_event", 0, 0, 0);
    /// `
    pub extern fn sceKernelCreateEventFlag(name: [*c]const c_char, attr: c_int, bits: c_int, opt: [*c]c_int) callconv(.C) SceUID;

    /// Delete an event flag
    /// `evid` - The event id returned by sceKernelCreateEventFlag.
    /// Returns < 0 On error
    pub extern fn sceKernelDeleteEventFlag(evid: c_int) callconv(.C) c_int;

    /// Set an event flag bit pattern.
    /// `evid` - The event id returned by sceKernelCreateEventFlag.
    /// `bits` - The bit pattern to set.
    /// Returns < 0 On error
    pub extern fn sceKernelSetEventFlag(evid: SceUID, bits: u32) callconv(.C) c_int;

    /// Clear a event flag bit pattern
    /// `evid` - The event id returned by ::sceKernelCreateEventFlag
    /// `bits` - The bits to clean
    /// Returns < 0 on Error
    pub extern fn sceKernelClearEventFlag(evid: SceUID, bits: u32) callconv(.C) c_int;

    /// Wait for an event flag for a given bit pattern.
    /// `evid` - The event id returned by sceKernelCreateEventFlag.
    /// `bits` - The bit pattern to poll for.
    /// `wait` - Wait type, one or more of ::PspEventFlagWaitTypes or'ed together
    /// `outBits` - The bit pattern that was matched.
    /// `timeout` - Timeout in microseconds
    /// Returns < 0 On error
    pub extern fn sceKernelWaitEventFlag(evid: c_int, bits: u32, wait: u32, outBits: [*c]u32, timeout: [*c]SceUInt) callconv(.C) c_int;

    /// Wait for an event flag for a given bit pattern with callback.
    /// `evid` - The event id returned by sceKernelCreateEventFlag.
    /// `bits` - The bit pattern to poll for.
    /// `wait` - Wait type, one or more of ::PspEventFlagWaitTypes or'ed together
    /// `outBits` - The bit pattern that was matched.
    /// `timeout` - Timeout in microseconds
    /// Returns < 0 On error
    pub extern fn sceKernelWaitEventFlagCB(evid: c_int, bits: u32, wait: u32, outBits: [*c]u32, timeout: [*c]SceUInt) callconv(.C) c_int;

    /// Poll an event flag for a given bit pattern.
    /// `evid` - The event id returned by sceKernelCreateEventFlag.
    /// `bits` - The bit pattern to poll for.
    /// `wait` - Wait type, one or more of ::PspEventFlagWaitTypes or'ed together
    /// `outBits` - The bit pattern that was matched.
    /// Returns < 0 On error
    pub extern fn sceKernelPollEventFlag(evid: c_int, bits: u32, wait: u32, outBits: [*c]u32) callconv(.C) c_int;

    pub extern fn sceKernelCancelEventFlag() callconv(.C) void;

    /// Get the status of an event flag.
    /// `event` - The UID of the event.
    /// `status` - A pointer to a ::SceKernelEventFlagInfo structure.
    /// Returns < 0 on error.
    pub extern fn sceKernelReferEventFlagStatus(event: SceUID, status: [*c]c_int) callconv(.C) c_int;

    /// Creates a new messagebox
    /// @par Example:
    /// `
    /// int mbxid;
    /// mbxid = sceKernelCreateMbx("MyMessagebox", 0, NULL);
    /// `
    /// `name` - Specifies the name of the mbx
    /// `attr` - Mbx attribute flags (normally set to 0)
    /// `option` - Mbx options (normally set to NULL)
    /// Returns A messagebox id
    pub extern fn sceKernelCreateMbx(name: [*c]const c_char, attr: SceUInt, option: [*c]c_int) callconv(.C) SceUID;

    /// Destroy a messagebox
    /// `mbxid` - The mbxid returned from a previous create call.
    /// Returns Returns the value 0 if its succesful otherwise an error code
    pub extern fn sceKernelDeleteMbx(mbxid: SceUID) callconv(.C) c_int;

    /// Send a message to a messagebox
    /// @par Example:
    /// `
    /// struct MyMessage {
    /// SceKernelMsgPacket header;
    /// char text[8];
    /// };
    /// struct MyMessage msg = { {0}, "Hello" };
    /// // Send the message
    /// sceKernelSendMbx(mbxid, (void*) &msg);
    /// `
    /// `mbxid` - The mbx id returned from sceKernelCreateMbx
    /// `message` - A message to be forwarded to the receiver.
    /// The start of the message should be the
    /// ::SceKernelMsgPacket structure, the rest
    /// Returns < 0 On error.
    pub extern fn sceKernelSendMbx(mbxid: SceUID, message: ?*anyopaque) callconv(.C) c_int;

    /// Wait for a message to arrive in a messagebox
    /// @par Example:
    /// `
    /// void *msg;
    /// sceKernelReceiveMbx(mbxid, &msg, NULL);
    /// `
    /// `mbxid` - The mbx id returned from sceKernelCreateMbx
    /// `pmessage` - A pointer to where a pointer to the
    /// received message should be stored
    /// `timeout` - Timeout in microseconds
    /// Returns < 0 on error.
    pub extern fn sceKernelReceiveMbx(mbxid: SceUID, pmessage: ?*anyopaque, timeout: [*c]SceUInt) callconv(.C) c_int;

    /// Wait for a message to arrive in a messagebox and handle callbacks if necessary.
    /// @par Example:
    /// `
    /// void *msg;
    /// sceKernelReceiveMbxCB(mbxid, &msg, NULL);
    /// `
    /// `mbxid` - The mbx id returned from sceKernelCreateMbx
    /// `pmessage` - A pointer to where a pointer to the
    /// received message should be stored
    /// `timeout` - Timeout in microseconds
    /// Returns < 0 on error.
    pub extern fn sceKernelReceiveMbxCB(mbxid: SceUID, pmessage: ?*anyopaque, timeout: [*c]SceUInt) callconv(.C) c_int;

    /// Check if a message has arrived in a messagebox
    /// @par Example:
    /// `
    /// void *msg;
    /// sceKernelPollMbx(mbxid, &msg);
    /// `
    /// `mbxid` - The mbx id returned from sceKernelCreateMbx
    /// `pmessage` - A pointer to where a pointer to the
    /// received message should be stored
    /// Returns < 0 on error (SCE_KERNEL_ERROR_MBOX_NOMSG if the mbx is empty).
    pub extern fn sceKernelPollMbx(mbxid: SceUID, pmessage: ?*anyopaque) callconv(.C) c_int;

    /// Abort all wait operations on a messagebox
    /// @par Example:
    /// `
    /// sceKernelCancelReceiveMbx(mbxid, NULL);
    /// `
    /// `mbxid` - The mbx id returned from sceKernelCreateMbx
    /// `pnum` - A pointer to where the number of threads which
    /// were waiting on the mbx should be stored (NULL
    /// if you don't care)
    /// Returns < 0 on error
    pub extern fn sceKernelCancelReceiveMbx(mbxid: SceUID, pnum: [*c]c_int) callconv(.C) c_int;

    /// Retrieve information about a messagebox.
    /// `mbxid` - UID of the messagebox to retrieve info for.
    /// `info` - Pointer to a ::SceKernelMbxInfo struct to receive the info.
    /// Returns < 0 on error.
    pub extern fn sceKernelReferMbxStatus(mbxid: SceUID, info: [*c]c_int) callconv(.C) c_int;

    /// Create a message pipe
    /// `name` - Name of the pipe
    /// `part` - ID of the memory partition
    /// `attr` - Set to 0?
    /// `unk1` - Unknown
    /// `opt` - Message pipe options (set to NULL)
    /// Returns The UID of the created pipe, < 0 on error
    pub extern fn sceKernelCreateMsgPipe(name: [*c]const c_char, part: c_int, attr: c_int, unk1: ?*anyopaque, opt: ?*anyopaque) callconv(.C) SceUID;

    /// Delete a message pipe
    /// `uid` - The UID of the pipe
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelDeleteMsgPipe(uid: SceUID) callconv(.C) c_int;

    /// Send a message to a pipe
    /// `uid` - The UID of the pipe
    /// `message` - Pointer to the message
    /// `size` - Size of the message
    /// `unk1` - Unknown
    /// `unk2` - Unknown
    /// `timeout` - Timeout for send
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelSendMsgPipe(uid: SceUID, message: ?*anyopaque, size: c_uint, unk1: c_int, unk2: ?*anyopaque, timeout: [*c]c_uint) callconv(.C) c_int;

    /// Send a message to a pipe (with callback)
    /// `uid` - The UID of the pipe
    /// `message` - Pointer to the message
    /// `size` - Size of the message
    /// `unk1` - Unknown
    /// `unk2` - Unknown
    /// `timeout` - Timeout for send
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelSendMsgPipeCB(uid: SceUID, message: ?*anyopaque, size: c_uint, unk1: c_int, unk2: ?*anyopaque, timeout: [*c]c_uint) callconv(.C) c_int;

    /// Try to send a message to a pipe
    /// `uid` - The UID of the pipe
    /// `message` - Pointer to the message
    /// `size` - Size of the message
    /// `unk1` - Unknown
    /// `unk2` - Unknown
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelTrySendMsgPipe(uid: SceUID, message: ?*anyopaque, size: c_uint, unk1: c_int, unk2: ?*anyopaque) callconv(.C) c_int;

    /// Receive a message from a pipe
    /// `uid` - The UID of the pipe
    /// `message` - Pointer to the message
    /// `size` - Size of the message
    /// `unk1` - Unknown
    /// `unk2` - Unknown
    /// `timeout` - Timeout for receive
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelReceiveMsgPipe(uid: SceUID, message: ?*anyopaque, size: c_uint, unk1: c_int, unk2: ?*anyopaque, timeout: [*c]c_uint) callconv(.C) c_int;

    /// Receive a message from a pipe (with callback)
    /// `uid` - The UID of the pipe
    /// `message` - Pointer to the message
    /// `size` - Size of the message
    /// `unk1` - Unknown
    /// `unk2` - Unknown
    /// `timeout` - Timeout for receive
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelReceiveMsgPipeCB(uid: SceUID, message: ?*anyopaque, size: c_uint, unk1: c_int, unk2: ?*anyopaque, timeout: [*c]c_uint) callconv(.C) c_int;

    /// Receive a message from a pipe
    /// `uid` - The UID of the pipe
    /// `message` - Pointer to the message
    /// `size` - Size of the message
    /// `unk1` - Unknown
    /// `unk2` - Unknown
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelTryReceiveMsgPipe(uid: SceUID, message: ?*anyopaque, size: c_uint, unk1: c_int, unk2: ?*anyopaque) callconv(.C) c_int;

    /// Cancel a message pipe
    /// `uid` - UID of the pipe to cancel
    /// `psend` - Receive number of sending threads?
    /// `precv` - Receive number of receiving threads?
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelCancelMsgPipe(uid: SceUID, psend: [*c]c_int, precv: [*c]c_int) callconv(.C) c_int;

    /// Get the status of a Message Pipe
    /// `uid` - The uid of the Message Pipe
    /// `info` - Pointer to a ::SceKernelMppInfo structure
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelReferMsgPipeStatus(uid: SceUID, info: [*c]c_int) callconv(.C) c_int;

    /// Create a variable pool
    /// `name` - Name of the pool
    /// `part` - The memory partition ID
    /// `attr` - Attributes
    /// `size` - Size of pool
    /// `opt` - Options (set to NULL)
    /// Returns The UID of the created pool, < 0 on error.
    pub extern fn sceKernelCreateVpl(name: [*c]const c_char, part: c_int, attr: c_int, size: c_uint, opt: [*c]c_int) callconv(.C) SceUID;

    /// Delete a variable pool
    /// `uid` - The UID of the pool
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelDeleteVpl(uid: SceUID) callconv(.C) c_int;

    /// Allocate from the pool
    /// `uid` - The UID of the pool
    /// `size` - The size to allocate
    /// `data` - Receives the address of the allocated data
    /// `timeout` - Amount of time to wait for allocation?
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelAllocateVpl(uid: SceUID, size: c_uint, data: ?*anyopaque, timeout: [*c]c_uint) callconv(.C) c_int;

    /// Allocate from the pool (with callback)
    /// `uid` - The UID of the pool
    /// `size` - The size to allocate
    /// `data` - Receives the address of the allocated data
    /// `timeout` - Amount of time to wait for allocation?
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelAllocateVplCB(uid: SceUID, size: c_uint, data: ?*anyopaque, timeout: [*c]c_uint) callconv(.C) c_int;

    /// Try to allocate from the pool
    /// `uid` - The UID of the pool
    /// `size` - The size to allocate
    /// `data` - Receives the address of the allocated data
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelTryAllocateVpl(uid: SceUID, size: c_uint, data: ?*anyopaque) callconv(.C) c_int;

    /// Free a block
    /// `uid` - The UID of the pool
    /// `data` - The data block to deallocate
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelFreeVpl(uid: SceUID, data: ?*anyopaque) callconv(.C) c_int;

    /// Cancel a pool
    /// `uid` - The UID of the pool
    /// `pnum` - Receives the number of waiting threads
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelCancelVpl(uid: SceUID, pnum: [*c]c_int) callconv(.C) c_int;

    /// Get the status of an VPL
    /// `uid` - The uid of the VPL
    /// `info` - Pointer to a ::SceKernelVplInfo structure
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelReferVplStatus(uid: SceUID, info: [*c]c_int) callconv(.C) c_int;

    /// Create a fixed pool
    /// `name` - Name of the pool
    /// `part` - The memory partition ID
    /// `attr` - Attributes
    /// `size` - Size of pool block
    /// `blocks` - Number of blocks to allocate
    /// `opt` - Options (set to NULL)
    /// Returns The UID of the created pool, < 0 on error.
    pub extern fn sceKernelCreateFpl(name: [*c]const c_char, part: c_int, attr: c_int, size: c_uint, blocks: c_uint, opt: [*c]c_int) callconv(.C) c_int;

    /// Delete a fixed pool
    /// `uid` - The UID of the pool
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelDeleteFpl(uid: SceUID) callconv(.C) c_int;

    /// Allocate from the pool
    /// `uid` - The UID of the pool
    /// `data` - Receives the address of the allocated data
    /// `timeout` - Amount of time to wait for allocation?
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelAllocateFpl(uid: SceUID, data: ?*anyopaque, timeout: [*c]c_uint) callconv(.C) c_int;

    /// Allocate from the pool (with callback)
    /// `uid` - The UID of the pool
    /// `data` - Receives the address of the allocated data
    /// `timeout` - Amount of time to wait for allocation?
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelAllocateFplCB(uid: SceUID, data: ?*anyopaque, timeout: [*c]c_uint) callconv(.C) c_int;

    /// Try to allocate from the pool
    /// `uid` - The UID of the pool
    /// `data` - Receives the address of the allocated data
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelTryAllocateFpl(uid: SceUID, data: ?*anyopaque) callconv(.C) c_int;

    /// Free a block
    /// `uid` - The UID of the pool
    /// `data` - The data block to deallocate
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelFreeFpl(uid: SceUID, data: ?*anyopaque) callconv(.C) c_int;

    /// Cancel a pool
    /// `uid` - The UID of the pool
    /// `pnum` - Receives the number of waiting threads
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelCancelFpl(uid: SceUID, pnum: [*c]c_int) callconv(.C) c_int;

    /// Get the status of an FPL
    /// `uid` - The uid of the FPL
    /// `info` - Pointer to a ::SceKernelFplInfo structure
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelReferFplStatus(uid: SceUID, info: [*c]c_int) callconv(.C) c_int;

    /// Return from a timer handler (doesn't seem to do alot)
    pub extern fn _sceKernelReturnFromTimerHandler() callconv(.C) void;

    /// Convert a number of microseconds to a ::SceKernelSysClock structure
    /// `usec` - Number of microseconds
    /// `clock` - Pointer to a ::SceKernelSysClock structure
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelUSec2SysClock(usec: c_uint, clock: [*c]c_int) callconv(.C) c_int;

    /// Convert a number of microseconds to a wide time
    /// `usec` - Number of microseconds.
    /// Returns The time
    pub extern fn sceKernelUSec2SysClockWide(usec: c_uint) callconv(.C) SceInt64;

    /// Convert a ::SceKernelSysClock structure to microseconds
    /// `clock` - Pointer to a ::SceKernelSysClock structure
    /// `low` - Pointer to the low part of the time
    /// `high` - Pointer to the high part of the time
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelSysClock2USec(clock: [*c]c_int, low: [*c]c_uint, high: [*c]c_uint) callconv(.C) c_int;

    /// Convert a wide time to microseconds
    /// `clock` - Wide time
    /// `low` - Pointer to the low part of the time
    /// `high` - Pointer to the high part of the time
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelSysClock2USecWide(clock: SceInt64, low: [*c]c_int, high: [*c]c_uint) callconv(.C) c_int;

    /// Get the system time
    /// `time` - Pointer to a ::SceKernelSysClock structure
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelGetSystemTime(time: [*c]c_int) callconv(.C) c_int;

    /// Get the system time (wide version)
    /// Returns The system time
    pub extern fn sceKernelGetSystemTimeWide() callconv(.C) SceInt64;

    /// Get the low 32bits of the current system time
    /// Returns The low 32bits of the system time
    pub extern fn sceKernelGetSystemTimeLow() callconv(.C) c_uint;

    /// Set an alarm.
    /// `clock` - The number of micro seconds till the alarm occurrs.
    /// `handler` - Pointer to a ::SceKernelAlarmHandler
    /// `common` - Common pointer for the alarm handler
    /// Returns A UID representing the created alarm, < 0 on error.
    pub extern fn sceKernelSetAlarm(clock: SceUInt, handler: c_int, common: ?*anyopaque) callconv(.C) SceUID;

    /// Set an alarm using a ::SceKernelSysClock structure for the time
    /// `clock` - Pointer to a ::SceKernelSysClock structure
    /// `handler` - Pointer to a ::SceKernelAlarmHandler
    /// `common` - Common pointer for the alarm handler.
    /// Returns A UID representing the created alarm, < 0 on error.
    pub extern fn sceKernelSetSysClockAlarm(clock: [*c]c_int, handler: c_int, common: ?*anyopaque) callconv(.C) SceUID;

    /// Cancel a pending alarm.
    /// `alarmid` - UID of the alarm to cancel.
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceKernelCancelAlarm(alarmid: SceUID) callconv(.C) c_int;

    /// Refer the status of a created alarm.
    /// `alarmid` - UID of the alarm to get the info of
    /// `info` - Pointer to a ::SceKernelAlarmInfo structure
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceKernelReferAlarmStatus(alarmid: SceUID, info: [*c]c_int) callconv(.C) c_int;

    /// Create a virtual timer
    /// `name` - Name for the timer.
    /// `opt` - Pointer to an ::SceKernelVTimerOptParam (pass NULL)
    /// Returns The VTimer's UID or < 0 on error.
    pub extern fn sceKernelCreateVTimer(name: [*c]const c_char, opt: [*c]c_int) callconv(.C) SceUID;

    /// Delete a virtual timer
    /// `uid` - The UID of the timer
    /// Returns < 0 on error.
    pub extern fn sceKernelDeleteVTimer(uid: SceUID) callconv(.C) c_int;

    /// Get the timer base
    /// `uid` - UID of the vtimer
    /// `base` - Pointer to a ::SceKernelSysClock structure
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelGetVTimerBase(uid: SceUID, base: [*c]c_int) callconv(.C) c_int;

    /// Get the timer base (wide format)
    /// `uid` - UID of the vtimer
    /// Returns The 64bit timer base
    pub extern fn sceKernelGetVTimerBaseWide(uid: SceUID) callconv(.C) SceInt64;

    /// Get the timer time
    /// `uid` - UID of the vtimer
    /// `time` - Pointer to a ::SceKernelSysClock structure
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelGetVTimerTime(uid: SceUID, time: [*c]c_int) callconv(.C) c_int;

    /// Get the timer time (wide format)
    /// `uid` - UID of the vtimer
    /// Returns The 64bit timer time
    pub extern fn sceKernelGetVTimerTimeWide(uid: SceUID) callconv(.C) SceInt64;

    /// Set the timer time
    /// `uid` - UID of the vtimer
    /// `time` - Pointer to a ::SceKernelSysClock structure
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelSetVTimerTime(uid: SceUID, time: [*c]c_int) callconv(.C) c_int;

    /// Set the timer time (wide format)
    /// `uid` - UID of the vtimer
    /// `time` - Pointer to a ::SceKernelSysClock structure
    /// Returns Possibly the last time
    pub extern fn sceKernelSetVTimerTimeWide(uid: SceUID, time: SceInt64) callconv(.C) SceInt64;

    /// Start a virtual timer
    /// `uid` - The UID of the timer
    /// Returns < 0 on error
    pub extern fn sceKernelStartVTimer(uid: SceUID) callconv(.C) c_int;

    /// Stop a virtual timer
    /// `uid` - The UID of the timer
    /// Returns < 0 on error
    pub extern fn sceKernelStopVTimer(uid: SceUID) callconv(.C) c_int;

    /// Set the timer handler
    /// `uid` - UID of the vtimer
    /// `time` - Time to call the handler?
    /// `handler` - The timer handler
    /// `common` - Common pointer
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelSetVTimerHandler(uid: SceUID, time: [*c]c_int, handler: c_int, common: ?*anyopaque) callconv(.C) c_int;

    /// Set the timer handler (wide mode)
    /// `uid` - UID of the vtimer
    /// `time` - Time to call the handler?
    /// `handler` - The timer handler
    /// `common` - Common pointer
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelSetVTimerHandlerWide(uid: SceUID, time: SceInt64, handler: c_int, common: ?*anyopaque) callconv(.C) c_int;

    /// Cancel the timer handler
    /// `uid` - The UID of the vtimer
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelCancelVTimerHandler(uid: SceUID) callconv(.C) c_int;

    /// Get the status of a VTimer
    /// `uid` - The uid of the VTimer
    /// `info` - Pointer to a ::SceKernelVTimerInfo structure
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelReferVTimerStatus(uid: SceUID, info: [*c]c_int) callconv(.C) c_int;

    pub extern fn sceKernelCreateThread(name: [*c]const c_char, entry: c_int, initPriority: c_int, stackSize: c_int, attr: SceUInt, option: [*c]c_int) callconv(.C) SceUID;

    /// Delate a thread
    /// `thid` - UID of the thread to be deleted.
    /// Returns < 0 on error.
    pub extern fn sceKernelDeleteThread(thid: SceUID) callconv(.C) c_int;

    /// Start a created thread
    /// `thid` - Thread id from sceKernelCreateThread
    /// `arglen` - Length of the data pointed to by argp, in bytes
    /// `argp` - Pointer to the arguments.
    pub extern fn sceKernelStartThread(thid: SceUID, arglen: SceSize, argp: ?*anyopaque) callconv(.C) c_int;

    /// Exit the thread (probably used as the syscall when the main thread
    /// returns
    pub extern fn _sceKernelExitThread() callconv(.C) void;

    /// Exit a thread
    /// `status` - Exit status.
    pub extern fn sceKernelExitThread(status: c_int) callconv(.C) c_int;

    /// Exit a thread and delete itself.
    /// `status` - Exit status
    pub extern fn sceKernelExitDeleteThread(status: c_int) callconv(.C) c_int;

    /// Terminate a thread.
    /// `thid` - UID of the thread to terminate.
    /// Returns Success if >= 0, an error if < 0.
    pub extern fn sceKernelTerminateThread(thid: SceUID) callconv(.C) c_int;

    /// Terminate and delete a thread.
    /// `thid` - UID of the thread to terminate and delete.
    /// Returns Success if >= 0, an error if < 0.
    pub extern fn sceKernelTerminateDeleteThread(thid: SceUID) callconv(.C) c_int;

    /// Suspend the dispatch thread
    /// Returns The current state of the dispatch thread, < 0 on error
    pub extern fn sceKernelSuspendDispatchThread() callconv(.C) c_int;

    /// Resume the dispatch thread
    /// `state` - The state of the dispatch thread
    /// (from ::sceKernelSuspendDispatchThread)
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelResumeDispatchThread(state: c_int) callconv(.C) c_int;

    /// Modify the attributes of the current thread.
    /// `unknown` - Set to 0.
    /// `attr` - The thread attributes to modify.  One of ::PspThreadAttributes.
    /// Returns < 0 on error.
    pub extern fn sceKernelChangeCurrentThreadAttr(unknown: c_int, attr: SceUInt) callconv(.C) c_int;

    /// Change the threads current priority.
    /// `thid` - The ID of the thread (from sceKernelCreateThread or sceKernelGetThreadId)
    /// `priority` - The new priority (the lower the number the higher the priority)
    /// @par Example:
    /// `
    /// int thid = sceKernelGetThreadId();
    /// // Change priority of current thread to 16
    /// sceKernelChangeThreadPriority(thid, 16);
    /// `
    /// Returns 0 if successful, otherwise the error code.
    pub extern fn sceKernelChangeThreadPriority(thid: SceUID, priority: c_int) callconv(.C) c_int;

    /// Rotate thread ready queue at a set priority
    /// `priority` - The priority of the queue
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceKernelRotateThreadReadyQueue(priority: c_int) callconv(.C) c_int;

    /// Release a thread in the wait state.
    /// `thid` - The UID of the thread.
    /// Returns 0 on success, < 0 on error
    pub extern fn sceKernelReleaseWaitThread(thid: SceUID) callconv(.C) c_int;

    /// Get the current thread Id
    /// Returns The thread id of the calling thread.
    pub extern fn sceKernelGetThreadId() callconv(.C) c_int;

    /// Get the current priority of the thread you are in.
    /// Returns The current thread priority
    pub extern fn sceKernelGetThreadCurrentPriority() callconv(.C) c_int;

    /// Get the exit status of a thread.
    /// `thid` - The UID of the thread to check.
    /// Returns The exit status
    pub extern fn sceKernelGetThreadExitStatus(thid: SceUID) callconv(.C) c_int;

    /// Check the thread stack?
    /// Returns Unknown.
    pub extern fn sceKernelCheckThreadStack() callconv(.C) c_int;

    /// Get the free stack size for a thread.
    /// `thid` - The thread ID. Seem to take current thread
    /// if set to 0.
    /// Returns The free size.
    pub extern fn sceKernelGetThreadStackFreeSize(thid: SceUID) callconv(.C) c_int;

    /// Get the status information for the specified thread.
    /// `thid` - Id of the thread to get status
    /// `info` - Pointer to the info structure to receive the data.
    /// Note: The structures size field should be set to
    /// sizeof(SceKernelThreadInfo) before calling this function.
    /// @par Example:
    /// `
    /// SceKernelThreadInfo status;
    /// status.size = sizeof(SceKernelThreadInfo);
    /// if(sceKernelReferThreadStatus(thid, &status) == 0)
    /// { Do something... }
    /// `
    /// Returns 0 if successful, otherwise the error code.
    pub extern fn sceKernelReferThreadStatus(thid: SceUID, info: [*c]c_int) callconv(.C) c_int;

    /// Retrive the runtime status of a thread.
    /// `thid` - UID of the thread to retrive status.
    /// `status` - Pointer to a ::SceKernelThreadRunStatus struct to receive the runtime status.
    /// Returns 0 if successful, otherwise the error code.
    pub extern fn sceKernelReferThreadRunStatus(thid: SceUID, status: [*c]c_int) callconv(.C) c_int;

    /// Get the current system status.
    /// `status` - Pointer to a ::SceKernelSystemStatus structure.
    /// Returns < 0 on error.
    pub extern fn sceKernelReferSystemStatus(status: [*c]c_int) callconv(.C) c_int;

    /// Get a list of UIDs from threadman. Allows you to enumerate
    /// resources such as threads or semaphores.
    /// `type` - The type of resource to list, one of ::SceKernelIdListType.
    /// `readbuf` - A pointer to a buffer to store the list.
    /// `readbufsize` - The size of the buffer in SceUID units.
    /// `idcount` - Pointer to an integer in which to return the number of ids in the list.
    /// Returns < 0 on error. Either 0 or the same as idcount on success.
    pub extern fn sceKernelGetThreadmanIdList(type: c_int, readbuf: [*c]SceUID, readbufsize: c_int, idcount: [*c]c_int) callconv(.C) c_int;

    /// Get the type of a threadman uid
    /// `uid` - The uid to get the type from
    /// Returns The type, < 0 on error
    pub extern fn sceKernelGetThreadmanIdType(uid: SceUID) callconv(.C) c_int;

    /// Get the thread profiler registers.
    /// Returns Pointer to the registers, NULL on error
    pub extern fn sceKernelReferThreadProfiler() callconv(.C) [*c]c_int;

    /// Get the globile profiler registers.
    /// Returns Pointer to the registers, NULL on error
    pub extern fn sceKernelReferGlobalProfiler() callconv(.C) [*c]c_int;

    /// Delete a lightweight mutex
    /// `workarea` - The pointer to the workarea
    /// Returns 0 on success, otherwise one of ::PspKernelErrorCodes
    pub extern fn sceKernelDeleteLwMutex(workarea: [*c]c_int) callconv(.C) c_int;

    /// Create a lightweight mutex
    /// `workarea` - The pointer to the workarea
    /// `name` - The name of the lightweight mutex
    /// `attr` - The LwMutex attributes, zero or more of ::PspLwMutexAttributes.
    /// `initialCount` - THe inital value of the mutex
    /// `optionsPtr` - Other options for mutex
    /// Returns 0 on success, otherwise one of ::PspKernelErrorCodes
    pub extern fn sceKernelCreateLwMutex(workarea: [*c]c_int, name: [*c]const c_char, attr: SceUInt32, initialCount: c_int, optionsPtr: [*c]u32) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "ThreadManForUser") and options.ThreadManForUser)) ThreadManForUser else EMPTY;

const StdioForUser = struct {
    pub extern fn sceKernelStdioRead() callconv(.C) void;

    pub extern fn sceKernelStdioLseek() callconv(.C) void;

    pub extern fn sceKernelStdioSendChar() callconv(.C) void;

    pub extern fn sceKernelStdioWrite() callconv(.C) void;

    pub extern fn sceKernelStdioClose() callconv(.C) void;

    pub extern fn sceKernelStdioOpen() callconv(.C) void;

    /// Function to get the current standard in file no
    /// Returns The stdin fileno
    pub extern fn sceKernelStdin() callconv(.C) SceUID;

    /// Function to get the current standard out file no
    /// Returns The stdout fileno
    pub extern fn sceKernelStdout() callconv(.C) SceUID;

    /// Function to get the current standard err file no
    /// Returns The stderr fileno
    pub extern fn sceKernelStderr() callconv(.C) SceUID;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "StdioForUser") and options.StdioForUser)) StdioForUser else EMPTY;

const sceUsbCam = struct {
    pub extern fn sceUsbCamSetupMic() callconv(.C) void;

    pub extern fn sceUsbCamSetMicGain() callconv(.C) void;

    /// Sets the contrast
    /// `contrast` - The contrast (0-255)
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUsbCamSetContrast(contrast: c_int) callconv(.C) c_int;

    /// Setups the parameters to take a still image (with more options)
    /// `param` - pointer to a ::PspUsbCamSetupStillExParam
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUsbCamSetupStillEx(param: [*c]c_int) callconv(.C) c_int;

    /// Gets the state of the autoreversal of the image.
    /// Returns 1 if it is set to automatic, 0 otherwise
    pub extern fn sceUsbCamGetAutoImageReverseState() callconv(.C) c_int;

    /// Set ups the parameters for video capture.
    /// `param` - Pointer to a ::PspUsbCamSetupVideoParam structure.
    /// `workarea` - Pointer to a buffer used as work area by the driver.
    /// `wasize` - Size of the work area.
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUsbCamSetupVideo(param: [*c]c_int, workarea: ?*anyopaque, wasize: c_int) callconv(.C) c_int;

    /// Polls the status of still input completion.
    /// Returns the size of the acquired image if still input has ended,
    /// 0 if the input has not ended, < 0 on error.
    pub extern fn sceUsbCamStillPollInputEnd() callconv(.C) c_int;

    /// Sets the exposure level
    /// `ev` - The exposure level, one of ::PspUsbCamEVLevel
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUsbCamSetEvLevel(ev: c_int) callconv(.C) c_int;

    pub extern fn sceUsbCam_1E958148() callconv(.C) void;

    /// Gets the current exposure level.
    /// `ev` - pointer to a variable that receives the current exposure level
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUsbCamGetEvLevel(ev: [*c]c_int) callconv(.C) c_int;

    pub extern fn sceUsbCamSetupMicEx() callconv(.C) void;

    pub extern fn sceUsbCamReadMicBlocking() callconv(.C) void;

    /// Gets the current saturation
    /// `saturation` - pointer to a variable that receives the current saturation
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUsbCamGetSaturation(saturation: [*c]c_int) callconv(.C) c_int;

    pub extern fn sceUsbCamReadMic() callconv(.C) void;

    /// Setups the parameters to take a still image.
    /// `param` - pointer to a ::PspUsbCamSetupStillParam
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUsbCamSetupStill(param: [*c]c_int) callconv(.C) c_int;

    /// Polls the status of video frame read completion.
    /// Returns the size of the acquired frame if it has been read,
    /// 0 if the frame has not yet been read, < 0 on error.
    pub extern fn sceUsbCamPollReadVideoFrameEnd() callconv(.C) c_int;

    pub extern fn sceUsbCamUnregisterLensRotationCallback() callconv(.C) void;

    /// Gets the direction of the camera lens
    /// Returns 1 if the camera is "looking to you", 0 if the camera
    /// is "looking to the other side".
    pub extern fn sceUsbCamGetLensDirection() callconv(.C) c_int;

    /// Sets the brightness
    /// `brightness` - The brightness (0-255)
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUsbCamSetBrightness(brightness: c_int) callconv(.C) c_int;

    pub extern fn sceUsbCamStopMic() callconv(.C) void;

    /// Starts video input from the camera.
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUsbCamStartVideo() callconv(.C) c_int;

    pub extern fn sceUsbCamGetMicDataLength() callconv(.C) void;

    /// Gets a still image. The function doesn't return until the image
    /// has been acquired.
    /// `buf` - The buffer that receives the image jpeg data
    /// `size` - The size of the buffer.
    /// Returns size of acquired image on success, < 0 on error
    pub extern fn sceUsbCamStillInputBlocking(buf: [*c]u8, size: SceSize) callconv(.C) c_int;

    /// Sets the sharpness
    /// `sharpness` - The sharpness (0-255)
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUsbCamSetSharpness(sharpness: c_int) callconv(.C) c_int;

    pub extern fn sceUsbCamSetAntiFlicker() callconv(.C) void;

    /// Stops video input from the camera.
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUsbCamStopVideo() callconv(.C) c_int;

    /// Sets the saturation
    /// `saturation` - The saturation (0-255)
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUsbCamSetSaturation(saturation: c_int) callconv(.C) c_int;

    /// Gets the current brightness
    /// `brightness` - pointer to a variable that receives the current brightness
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUsbCamGetBrightness(brightness: [*c]c_int) callconv(.C) c_int;

    /// Waits untils still input has been finished.
    /// Returns the size of the acquired image on sucess, < 0 on error
    pub extern fn sceUsbCamStillWaitInputEnd() callconv(.C) c_int;

    /// Reads a video frame. The function doesn't return until the frame
    /// has been acquired.
    /// `buf` - The buffer that receives the frame jpeg data
    /// `size` - The size of the buffer.
    /// Returns size of acquired frame on success, < 0 on error
    pub extern fn sceUsbCamReadVideoFrameBlocking(buf: [*c]u8, size: SceSize) callconv(.C) c_int;

    pub extern fn sceUsbCamStartMic() callconv(.C) void;

    /// Sets the reverse mode
    /// `reverseflags` - The reverse flags, zero or more of ::PspUsbCamReverseFlags
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUsbCamSetReverseMode(reverseflags: c_int) callconv(.C) c_int;

    pub extern fn sceUsbCam_95F8901E() callconv(.C) void;

    /// Gets the current image efect mode
    /// `effectmode` - pointer to a variable that receives the current effect mode
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUsbCamGetImageEffectMode(effectmode: [*c]c_int) callconv(.C) c_int;

    /// Reads a video frame. The function returns inmediately, and
    /// the completion has to be handled by calling ::sceUsbCamWaitReadVideoFrameEnd
    /// or ::sceUsbCamPollReadVideoFrameEnd.
    /// `buf` - The buffer that receives the frame jpeg data
    /// `size` - The size of the buffer.
    /// Returns 0 on success, < 0 on error
    /// Reads a video frame. The function doesn't return until the frame
    /// has been acquired.
    /// `buf` - The buffer that receives the frame jpeg data
    /// `size` - The size of the buffer.
    /// Returns size of acquired frame on success, < 0 on error
    pub extern fn sceUsbCamReadVideoFrame(buf: [*c]u8, size: SceSize) callconv(.C) c_int;

    /// Gets the current zoom.
    /// `zoom` - pointer to a variable that receives the current zoom
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUsbCamGetZoom(zoom: [*c]c_int) callconv(.C) c_int;

    /// Gets the current contrast
    /// `contrast` - pointer to a variable that receives the current contrast
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUsbCamGetContrast(contrast: [*c]c_int) callconv(.C) c_int;

    /// Cancels the still input.
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUsbCamStillCancelInput() callconv(.C) c_int;

    pub extern fn sceUsbCamGetAntiFlicker() callconv(.C) void;

    pub extern fn sceUsbCamWaitReadMicEnd() callconv(.C) void;

    /// Sets the zoom.
    /// `zoom` - The zoom level starting by 10. (10 = 1X, 11 = 1.1X, etc)
    /// Returns s 0 on success, < 0 on error
    pub extern fn sceUsbCamSetZoom(zoom: c_int) callconv(.C) c_int;

    pub extern fn sceUsbCam_C72ED6D3() callconv(.C) void;

    /// Set ups the parameters for video capture (with more options)
    /// `param` - Pointer to a ::PspUsbCamSetupVideoExParam structure.
    /// `workarea` - Pointer to a buffer used as work area by the driver.
    /// `wasize` - Size of the work area.
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUsbCamSetupVideoEx(param: [*c]c_int, workarea: ?*anyopaque, wasize: c_int) callconv(.C) c_int;

    pub extern fn sceUsbCamRegisterLensRotationCallback() callconv(.C) void;

    /// Sets the image effect mode
    /// `effectmode` - The effect mode, one of ::PspUsbCamEffectMode
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUsbCamSetImageEffectMode(effectmode: c_int) callconv(.C) c_int;

    /// Gets the current reverse mode.
    /// `reverseflags` - pointer to a variable that receives the current reverse mode flags
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUsbCamGetReverseMode(reverseflags: [*c]c_int) callconv(.C) c_int;

    pub extern fn sceUsbCam_D865997B() callconv(.C) void;

    /// Gets the size of the acquired frame.
    /// Returns the size of the acquired frame on success, < 0 on error
    pub extern fn sceUsbCamGetReadVideoFrameSize() callconv(.C) c_int;

    /// Gets the size of the acquired still image.
    /// Returns the size of the acquired image on success, < 0 on error
    pub extern fn sceUsbCamStillGetInputLength() callconv(.C) c_int;

    pub extern fn sceUsbCamPollReadMicEnd() callconv(.C) void;

    /// Waits untils the current frame has been read.
    /// Returns the size of the acquired frame on sucess, < 0 on error
    pub extern fn sceUsbCamWaitReadVideoFrameEnd() callconv(.C) c_int;

    /// Sets if the image should be automatically reversed, depending of the position
    /// of the camera.
    /// `on` - 1 to set the automatical reversal of the image, 0 to set it off
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUsbCamAutoImageReverseSW(on: c_int) callconv(.C) c_int;

    /// Gets a still image. The function returns inmediately, and
    /// the completion has to be handled by calling ::sceUsbCamStillWaitInputEnd
    /// or ::sceUsbCamStillPollInputEnd.
    /// `buf` - The buffer that receives the image jpeg data
    /// `size` - The size of the buffer.
    /// Returns 0 on success, < 0 on error
    /// Gets a still image. The function doesn't return until the image
    /// has been acquired.
    /// `buf` - The buffer that receives the image jpeg data
    /// `size` - The size of the buffer.
    /// Returns size of acquired image on success, < 0 on error
    pub extern fn sceUsbCamStillInput(buf: [*c]u8, size: SceSize) callconv(.C) c_int;

    /// Gets the current sharpness
    /// `sharpness` - pointer to a variable that receives the current sharpness
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUsbCamGetSharpness(sharpness: [*c]c_int) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceUsbCam") and options.sceUsbCam)) sceUsbCam else EMPTY;

const sceUsb = struct {
    /// Start a USB driver.
    /// `driverName` - name of the USB driver to start
    /// `size` - Size of arguments to pass to USB driver start
    /// `args` - Arguments to pass to USB driver start
    /// Returns 0 on success
    pub extern fn sceUsbStart(driverName: [*c]const c_char, size: c_int, args: ?*anyopaque) callconv(.C) c_int;

    /// Stop a USB driver.
    /// `driverName` - name of the USB driver to stop
    /// `size` - Size of arguments to pass to USB driver stop
    /// `args` - Arguments to pass to USB driver stop
    /// Returns 0 on success
    pub extern fn sceUsbStop(driverName: [*c]const c_char, size: c_int, args: ?*anyopaque) callconv(.C) c_int;

    /// Get USB state
    /// Returns OR'd PSP_USB_* constants
    pub extern fn sceUsbGetState() callconv(.C) c_int;

    pub extern fn sceUsbGetDrvList(r4one: u32, r5ret: [*c]u32, r6one: u32) callconv(.C) c_int;

    /// Get state of a specific USB driver
    /// `driverName` - name of USB driver to get status from
    /// Returns 1 if the driver has been started, 2 if it is stopped
    pub extern fn sceUsbGetDrvState(driverName: [*c]const c_char) callconv(.C) c_int;

    /// Activate a USB driver.
    /// `pid` - Product ID for the default USB Driver
    /// Returns 0 on success
    pub extern fn sceUsbActivate(pid: u32) callconv(.C) c_int;

    /// Deactivate USB driver.
    /// `pid` - Product ID for the default USB driver
    /// Returns 0 on success
    pub extern fn sceUsbDeactivate(pid: u32) callconv(.C) c_int;

    pub extern fn sceUsbWaitState(state: u32, waitmode: c_int, timeout: [*c]u32) callconv(.C) c_int;

    pub extern fn sceUsbWaitCancel() callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceUsb") and options.sceUsb)) sceUsb else EMPTY;

const sceDmac = struct {
    /// Copy data in memory using DMAC
    /// `dst` - The pointer to the destination
    /// `src` - The pointer to the source
    /// `n` - The size of data
    /// Returns 0 on success; otherwise an error code
    pub extern fn sceDmacMemcpy(dst: ?*anyopaque, src: ?*const anyopaque, n: SceSize) callconv(.C) c_int;

    pub extern fn sceDmacTryMemcpy(dst: ?*anyopaque, src: ?*const anyopaque, n: SceSize) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceDmac") and options.sceDmac)) sceDmac else EMPTY;

const sceAudio = struct {
    /// Output audio of the specified channel
    /// `channel` - The channel number.
    /// `vol` - The volume.
    /// `buf` - Pointer to the PCM data to output.
    /// Returns 0 on success, an error if less than 0.
    pub extern fn sceAudioOutput(channel: c_int, vol: c_int, buf: ?*anyopaque) callconv(.C) c_int;

    /// Output audio of the specified channel (blocking)
    /// `channel` - The channel number.
    /// `vol` - The volume.
    /// `buf` - Pointer to the PCM data to output.
    /// Returns 0 on success, an error if less than 0.
    pub extern fn sceAudioOutputBlocking(channel: c_int, vol: c_int, buf: ?*anyopaque) callconv(.C) c_int;

    /// Output panned audio of the specified channel
    /// `channel` - The channel number.
    /// `leftvol` - The left volume.
    /// `rightvol` - The right volume.
    /// `buf` - Pointer to the PCM data to output.
    /// Returns 0 on success, an error if less than 0.
    pub extern fn sceAudioOutputPanned(channel: c_int, leftvol: c_int, rightvol: c_int, buf: ?*anyopaque) callconv(.C) c_int;

    /// Output panned audio of the specified channel (blocking)
    /// `channel` - The channel number.
    /// `leftvol` - The left volume.
    /// `rightvol` - The right volume.
    /// `buf` - Pointer to the PCM data to output.
    /// Returns 0 on success, an error if less than 0.
    pub extern fn sceAudioOutputPannedBlocking(channel: c_int, leftvol: c_int, rightvol: c_int, buf: ?*anyopaque) callconv(.C) c_int;

    /// Allocate and initialize a hardware output channel.
    /// `channel` - Use a value between 0 - 7 to reserve a specific channel.
    /// Pass PSP_AUDIO_NEXT_CHANNEL to get the first available channel.
    /// `samplecount` - The number of samples that can be output on the channel per
    /// output call.  It must be a value between ::PSP_AUDIO_SAMPLE_MIN
    /// and ::PSP_AUDIO_SAMPLE_MAX, and it must be aligned to 64 bytes
    /// (use the ::PSP_AUDIO_SAMPLE_ALIGN macro to align it).
    /// `format` - The output format to use for the channel.  One of ::PspAudioFormats.
    /// Returns The channel number on success, an error code if less than 0.
    pub extern fn sceAudioChReserve(channel: c_int, samplecount: c_int, format: c_int) callconv(.C) c_int;

    pub extern fn sceAudioOneshotOutput() callconv(.C) void;

    /// Release a hardware output channel.
    /// `channel` - The channel to release.
    /// Returns 0 on success, an error if less than 0.
    pub extern fn sceAudioChRelease(channel: c_int) callconv(.C) c_int;

    /// Get count of unplayed samples remaining
    /// `channel` - The channel number.
    /// Returns Number of samples to be played, an error if less than 0.
    pub extern fn sceAudioGetChannelRestLen(channel: c_int) callconv(.C) c_int;

    /// Change the output sample count, after it's already been reserved
    /// `channel` - The channel number.
    /// `samplecount` - The number of samples to output in one output call.
    /// Returns 0 on success, an error if less than 0.
    pub extern fn sceAudioSetChannelDataLen(channel: c_int, samplecount: c_int) callconv(.C) c_int;

    /// Change the format of a channel
    /// `channel` - The channel number.
    /// `format` - One of ::PspAudioFormats
    /// Returns 0 on success, an error if less than 0.
    pub extern fn sceAudioChangeChannelConfig(channel: c_int, format: c_int) callconv(.C) c_int;

    /// Change the volume of a channel
    /// `channel` - The channel number.
    /// `leftvol` - The left volume.
    /// `rightvol` - The right volume.
    /// Returns 0 on success, an error if less than 0.
    pub extern fn sceAudioChangeChannelVolume(channel: c_int, leftvol: c_int, rightvol: c_int) callconv(.C) c_int;

    /// Reserve the audio output
    /// `samplecount` - The number of samples to output in one output call (min 17, max 4111).
    /// `freq` - The frequency. One of 48000, 44100, 32000, 24000, 22050, 16000, 12000, 11050, 8000.
    /// `channels` - Number of channels. Pass 2 (stereo).
    /// Returns 0 on success, an error if less than 0.
    pub extern fn sceAudioSRCChReserve(samplecount: c_int, freq: c_int, channels: c_int) callconv(.C) c_int;

    /// Release the audio output
    /// Returns 0 on success, an error if less than 0.
    pub extern fn sceAudioSRCChRelease() callconv(.C) c_int;

    /// Output audio
    /// `vol` - The volume.
    /// `buf` - Pointer to the PCM data to output.
    /// Returns 0 on success, an error if less than 0.
    pub extern fn sceAudioSRCOutputBlocking(vol: c_int, buf: ?*anyopaque) callconv(.C) c_int;

    /// Perform audio input (blocking)
    /// `samplecount` - Number of samples.
    /// `freq` - Either 44100, 22050 or 11025.
    /// `buf` - Pointer to where the audio data will be stored.
    /// Returns 0 on success, an error if less than 0.
    pub extern fn sceAudioInputBlocking(samplecount: c_int, freq: c_int, buf: ?*anyopaque) callconv(.C) c_int;

    /// Perform audio input
    /// `samplecount` - Number of samples.
    /// `freq` - Either 44100, 22050 or 11025.
    /// `buf` - Pointer to where the audio data will be stored.
    /// Returns 0 on success, an error if less than 0.
    /// Perform audio input (blocking)
    /// `samplecount` - Number of samples.
    /// `freq` - Either 44100, 22050 or 11025.
    /// `buf` - Pointer to where the audio data will be stored.
    /// Returns 0 on success, an error if less than 0.
    /// Init audio input (with extra arguments)
    /// `params` - A pointer to a ::pspAudioInputParams struct.
    /// Returns 0 on success, an error if less than 0.
    /// Init audio input
    /// `unknown1` - Unknown. Pass 0.
    /// `gain` - Gain.
    /// `unknown2` - Unknown. Pass 0.
    /// Returns 0 on success, an error if less than 0.
    pub extern fn sceAudioInput(samplecount: c_int, freq: c_int, buf: ?*anyopaque) callconv(.C) c_int;

    /// Get the number of samples that were acquired
    /// Returns Number of samples acquired, an error if less than 0.
    pub extern fn sceAudioGetInputLength() callconv(.C) c_int;

    /// Wait for non-blocking audio input to complete
    /// Returns 0 on success, an error if less than 0.
    pub extern fn sceAudioWaitInputEnd() callconv(.C) c_int;

    /// Init audio input
    /// `unknown1` - Unknown. Pass 0.
    /// `gain` - Gain.
    /// `unknown2` - Unknown. Pass 0.
    /// Returns 0 on success, an error if less than 0.
    pub extern fn sceAudioInputInit(unknown1: c_int, gain: c_int, unknown2: c_int) callconv(.C) c_int;

    /// Poll for non-blocking audio input status
    /// Returns 0 if input has completed, 1 if not completed or an error if less than 0.
    pub extern fn sceAudioPollInputEnd() callconv(.C) c_int;

    /// Get count of unplayed samples remaining
    /// `channel` - The channel number.
    /// Returns Number of samples to be played, an error if less than 0.
    pub extern fn sceAudioGetChannelRestLength(channel: c_int) callconv(.C) c_int;

    /// Init audio input (with extra arguments)
    /// `params` - A pointer to a ::pspAudioInputParams struct.
    /// Returns 0 on success, an error if less than 0.
    pub extern fn sceAudioInputInitEx(params: [*c]c_int) callconv(.C) c_int;

    /// Reserve the audio output and set the output sample count
    /// `samplecount` - The number of samples to output in one output call (min 17, max 4111).
    /// Returns 0 on success, an error if less than 0.
    pub extern fn sceAudioOutput2Reserve(samplecount: c_int) callconv(.C) c_int;

    /// Output audio (blocking)
    /// `vol` - The volume.
    /// `buf` - Pointer to the PCM data.
    /// Returns 0 on success, an error if less than 0.
    pub extern fn sceAudioOutput2OutputBlocking(vol: c_int, buf: ?*anyopaque) callconv(.C) c_int;

    /// Release the audio output
    /// Returns 0 on success, an error if less than 0.
    pub extern fn sceAudioOutput2Release() callconv(.C) c_int;

    /// Change the output sample count, after it's already been reserved
    /// `samplecount` - The number of samples to output in one output call (min 17, max 4111).
    /// Returns 0 on success, an error if less than 0.
    pub extern fn sceAudioOutput2ChangeLength(samplecount: c_int) callconv(.C) c_int;

    /// Get count of unplayed samples remaining
    /// Returns Number of samples to be played, an error if less than 0.
    pub extern fn sceAudioOutput2GetRestSample() callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceAudio") and options.sceAudio)) sceAudio else EMPTY;

const sceAudiocodec = struct {
    pub extern fn sceAudiocodecCheckNeedMem(Buffer: [*c]c_ulong, Type: c_int) callconv(.C) c_int;

    pub extern fn sceAudiocodecInit(Buffer: [*c]c_ulong, Type: c_int) callconv(.C) c_int;

    pub extern fn sceAudiocodecDecode(Buffer: [*c]c_ulong, Type: c_int) callconv(.C) c_int;

    pub extern fn sceAudiocodecGetInfo() callconv(.C) void;

    pub extern fn sceAudiocodec_6CD2A861() callconv(.C) void;

    pub extern fn sceAudiocodec_59176A0F() callconv(.C) void;

    pub extern fn sceAudiocodecGetEDRAM(Buffer: [*c]c_ulong, Type: c_int) callconv(.C) c_int;

    pub extern fn sceAudiocodecReleaseEDRAM(Buffer: [*c]c_ulong) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceAudiocodec") and options.sceAudiocodec)) sceAudiocodec else EMPTY;

const sceGe_user = struct {
    /// Get the size of VRAM.
    /// Returns The size of VRAM (in bytes).
    pub extern fn sceGeEdramGetSize() callconv(.C) c_uint;

    /// Get the eDRAM address.
    /// Returns A pointer to the base of the eDRAM.
    pub extern fn sceGeEdramGetAddr() callconv(.C) ?*anyopaque;

    /// Set the eDRAM address translation mode.
    /// `width` - 0 to not set the translation width, otherwise 512, 1024, 2048 or 4096.
    /// Returns The previous width if it was set, otherwise 0, < 0 on error.
    pub extern fn sceGeEdramSetAddrTranslation(width: c_int) callconv(.C) c_int;

    /// Retrieve the current value of a GE command.
    /// `cmd` - The GE command register to retrieve (0 to 0xFF, both included).
    /// Returns The value of the GE command, < 0 on error.
    pub extern fn sceGeGetCmd(cmd: c_int) callconv(.C) c_uint;

    /// Retrieve a matrix of the given type.
    /// `type` - One of ::PspGeMatrixTypes.
    /// `matrix` - Pointer to a variable to store the matrix.
    /// Returns < 0 on error.
    pub extern fn sceGeGetMtx(type: c_int, matrix: ?*anyopaque) callconv(.C) c_int;

    /// Retrieve the stack of the display list currently being executed.
    /// `stackId` - The ID of the stack to retrieve.
    /// `stack` - Pointer to a structure to store the stack, or NULL to not store it.
    /// Returns The number of stacks of the current display list, < 0 on error.
    pub extern fn sceGeGetStack(stackId: c_int, stack: [*c]c_int) callconv(.C) c_int;

    /// Save the GE's current state.
    /// `context` - Pointer to a ::PspGeContext.
    /// Returns < 0 on error.
    pub extern fn sceGeSaveContext(context: [*c]c_int) callconv(.C) c_int;

    /// Restore a previously saved GE context.
    /// `context` - Pointer to a ::PspGeContext.
    /// Returns < 0 on error.
    pub extern fn sceGeRestoreContext(context: [*c]const c_int) callconv(.C) c_int;

    /// Enqueue a display list at the tail of the GE display list queue.
    /// `list` - The head of the list to queue.
    /// `stall` - The stall address.
    /// If NULL then no stall address is set and the list is transferred immediately.
    /// `cbid` - ID of the callback set by calling sceGeSetCallback
    /// `arg` - Structure containing GE context buffer address
    /// Returns The ID of the queue, < 0 on error.
    pub extern fn sceGeListEnQueue(list: ?*const anyopaque, stall: ?*anyopaque, cbid: c_int, arg: [*c]c_int) callconv(.C) c_int;

    /// Enqueue a display list at the head of the GE display list queue.
    /// `list` - The head of the list to queue.
    /// `stall` - The stall address.
    /// If NULL then no stall address is set and the list is transferred immediately.
    /// `cbid` - ID of the callback set by calling sceGeSetCallback
    /// `arg` - Structure containing GE context buffer address
    /// Returns The ID of the queue, < 0 on error.
    pub extern fn sceGeListEnQueueHead(list: ?*const anyopaque, stall: ?*anyopaque, cbid: c_int, arg: [*c]c_int) callconv(.C) c_int;

    /// Cancel a queued or running list.
    /// `qid` - The ID of the queue.
    /// Returns < 0 on error.
    pub extern fn sceGeListDeQueue(qid: c_int) callconv(.C) c_int;

    /// Update the stall address for the specified queue.
    /// `qid` - The ID of the queue.
    /// `stall` - The new stall address.
    /// Returns < 0 on error
    pub extern fn sceGeListUpdateStallAddr(qid: c_int, stall: ?*anyopaque) callconv(.C) c_int;

    /// Wait for syncronisation of a list.
    /// `qid` - The queue ID of the list to sync.
    /// `syncType` - 0 if you want to wait for the list to be completed, or 1 if you just want to peek the actual state.
    /// Returns The specified queue status, one of ::PspGeListState.
    pub extern fn sceGeListSync(qid: c_int, syncType: c_int) callconv(.C) c_int;

    /// Wait for drawing to complete.
    /// `syncType` - 0 if you want to wait for the drawing to be completed, or 1 if you just want to peek the state of the display list currently being executed.
    /// Returns The current queue status, one of ::PspGeListState.
    pub extern fn sceGeDrawSync(syncType: c_int) callconv(.C) c_int;

    /// Interrupt drawing queue.
    /// `mode` - If set to 1, reset all the queues.
    /// `pParam` - Unused (just K1-checked).
    /// Returns The stopped queue ID if mode isn't set to 0, otherwise 0, and < 0 on error.
    pub extern fn sceGeBreak(mode: c_int, pParam: [*c]c_int) callconv(.C) c_int;

    /// Restart drawing queue.
    /// Returns < 0 on error.
    pub extern fn sceGeContinue() callconv(.C) c_int;

    /// Register callback handlers for the the GE.
    /// `cb` - Configured callback data structure.
    /// Returns The callback ID, < 0 on error.
    pub extern fn sceGeSetCallback(cb: [*c]c_int) callconv(.C) c_int;

    /// Unregister the callback handlers.
    /// `cbid` - The ID of the callbacks, returned by sceGeSetCallback().
    /// Returns < 0 on error
    pub extern fn sceGeUnsetCallback(cbid: c_int) callconv(.C) c_int;

    /// Sets the EDRAM size to be enabled.
    /// `size -size    The size (0x200000 or 0x400000). Will return an error if 0x400000 is specified for the PSP FAT.`
    /// Returns Zero on success, otherwise less than zero.
    pub extern fn sceGeEdramSetSize(size: c_int) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceGe_user") and options.sceGe_user)) sceGe_user else EMPTY;

const sceMp3 = struct {
    /// sceMp3ReserveMp3Handle
    /// `args` - Pointer to SceMp3InitArg structure
    /// Returns sceMp3 handle on success, < 0 on error.
    pub extern fn sceMp3ReserveMp3Handle(args: [*c]c_int) callconv(.C) SceInt32;

    /// sceMp3NotifyAddStreamData
    /// `handle` - sceMp3 handle
    /// `size` - number of bytes added to the stream data buffer
    /// Returns 0 if success, < 0 on error.
    pub extern fn sceMp3NotifyAddStreamData(handle: SceInt32, size: SceInt32) callconv(.C) SceInt32;

    /// sceMp3ResetPlayPosition
    /// `handle` - sceMp3 handle
    /// Returns 0 if success, < 0 on error.
    pub extern fn sceMp3ResetPlayPosition(handle: SceInt32) callconv(.C) SceInt32;

    /// sceMp3GetSumDecodedSample
    /// `handle` - sceMp3 handle
    /// Returns Number of decoded samples, < 0 on error.
    pub extern fn sceMp3GetSumDecodedSample(handle: SceInt32) callconv(.C) SceInt32;

    /// sceMp3InitResource
    /// Returns 0 if success, < 0 on error.
    pub extern fn sceMp3InitResource() callconv(.C) SceInt32;

    /// sceMp3TermResource
    /// Returns 0 if success, < 0 on error.
    pub extern fn sceMp3TermResource() callconv(.C) SceInt32;

    /// sceMp3SetLoopNum
    /// `handle` - sceMp3 handle
    /// `loop` - Number of loops
    /// Returns 0 if success, < 0 on error.
    pub extern fn sceMp3SetLoopNum(handle: SceInt32, loop: SceInt32) callconv(.C) SceInt32;

    /// sceMp3Init
    /// `handle` - sceMp3 handle
    /// Returns 0 if success, < 0 on error.
    /// sceMp3InitResource
    /// Returns 0 if success, < 0 on error.
    pub extern fn sceMp3Init(handle: SceInt32) callconv(.C) SceInt32;

    pub extern fn sceMp3_732B042A() callconv(.C) void;

    /// sceMp3GetMp3ChannelNum
    /// `handle` - sceMp3 handle
    /// Returns Number of channels of the mp3, < 0 on error.
    pub extern fn sceMp3GetMp3ChannelNum(handle: SceInt32) callconv(.C) SceInt32;

    /// sceMp3GetBitRate
    /// `handle` - sceMp3 handle
    /// Returns Bitrate of the mp3, < 0 on error.
    pub extern fn sceMp3GetBitRate(handle: SceInt32) callconv(.C) SceInt32;

    /// sceMp3GetMaxOutputSample
    /// `handle` - sceMp3 handle
    /// Returns Number of max samples to output, < 0 on error.
    pub extern fn sceMp3GetMaxOutputSample(handle: SceInt32) callconv(.C) SceInt32;

    pub extern fn sceMp3_8AB81558() callconv(.C) void;

    /// sceMp3GetSamplingRate
    /// `handle` - sceMp3 handle
    /// Returns Sampling rate of the mp3, < 0 on error.
    pub extern fn sceMp3GetSamplingRate(handle: SceInt32) callconv(.C) SceInt32;

    /// sceMp3GetInfoToAddStreamData
    /// `handle` - sceMp3 handle
    /// `dst` - Pointer to stream data buffer
    /// `towrite` - Space remaining in stream data buffer
    /// `srcpos` - Position in source stream to start reading from
    /// Returns 0 if success, < 0 on error.
    pub extern fn sceMp3GetInfoToAddStreamData(handle: SceInt32, dst: [*c]SceUChar8, towrite: [*c]SceInt32, srcpos: [*c]SceInt32) callconv(.C) SceInt32;

    /// sceMp3Decode
    /// `handle` - sceMp3 handle
    /// `dst` - Pointer to destination pcm samples buffer
    /// Returns number of bytes in decoded pcm buffer, < 0 on error.
    pub extern fn sceMp3Decode(handle: SceInt32, dst: [*c]SceShort16) callconv(.C) SceInt32;

    /// sceMp3CheckStreamDataNeeded
    /// `handle` - sceMp3 handle
    /// Returns 1 if more stream data is needed, < 0 on error.
    pub extern fn sceMp3CheckStreamDataNeeded(handle: SceInt32) callconv(.C) SceInt32;

    /// sceMp3GetLoopNum
    /// `handle` - sceMp3 handle
    /// Returns Number of loops, < 0 on error.
    pub extern fn sceMp3GetLoopNum(handle: SceInt32) callconv(.C) SceInt32;

    /// sceMp3ReleaseMp3Handle
    /// `handle` - sceMp3 handle
    /// Returns 0 if success, < 0 on error.
    pub extern fn sceMp3ReleaseMp3Handle(handle: SceInt32) callconv(.C) SceInt32;

    /// sceMp3GetMPEGVersion
    /// `handle` - sceMp3 handle
    /// Returns MPEG Version, < 0 on error
    pub extern fn sceMp3GetMPEGVersion(handle: SceInt32) callconv(.C) SceInt32;

    /// sceMp3GetFrameNum
    /// `handle` - sceMp3 handle
    /// Returns Number of audio frames, < 0 on error
    pub extern fn sceMp3GetFrameNum(handle: SceInt32) callconv(.C) SceInt32;

    /// sceMp3ResetPlayPositionByFrame
    /// `handle` - sceMp3 handle
    /// `frame` - frame
    /// Returns 0 if success, < 0 on error.
    pub extern fn sceMp3ResetPlayPositionByFrame(handle: SceInt32, frame: SceUInt32) callconv(.C) SceInt32;

    /// sceMp3LowLevelInit
    /// `handle` - sceMp3 handle
    /// `src` - Pointer to a buffer to contain raw mp3 stream data
    /// Returns 0 if success, < 0 on error.
    pub extern fn sceMp3LowLevelInit(handle: SceInt32, src: [*c]SceUChar8) callconv(.C) SceInt32;

    /// sceMp3LowLevelDecode
    /// `handle` - sceMp3 handle
    /// `mp3src` - Pointer to a buffer to contain raw mp3 stream data
    /// `mp3srcused` - mp3 data size consumed by decoding
    /// `pcmdst` - Pointer to destination pcm samples buffer
    /// `pcmdstoutsz` - Size of pcm data output by decoding
    /// Returns 0 if success, < 0 on error.
    pub extern fn sceMp3LowLevelDecode(handle: SceInt32, mp3src: [*c]SceUChar8, mp3srcused: [*c]SceUInt32, pcmdst: [*c]SceShort16, pcmdstoutsz: [*c]SceUInt32) callconv(.C) SceInt32;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceMp3") and options.sceMp3)) sceMp3 else EMPTY;

const sceRtc = struct {
    /// Get the resolution of the tick counter
    /// Returns # of ticks per second
    pub extern fn sceRtcGetTickResolution() callconv(.C) u32;

    /// Get current tick count
    /// `tick` - pointer to u64 to receive tick count
    /// Returns 0 on success, < 0 on error
    pub extern fn sceRtcGetCurrentTick(tick: [*c]u64) callconv(.C) c_int;

    pub extern fn sceRtc_029CA3B3() callconv(.C) void;

    /// Get current tick count, adjusted for local time zone
    /// `time` - pointer to ScePspDateTime struct to receive time
    /// `tz` - time zone to adjust to (minutes from UTC)
    /// Returns 0 on success, < 0 on error
    pub extern fn sceRtcGetCurrentClock(time: [*c]c_int, tz: c_int) callconv(.C) c_int;

    /// Get current local time into a ScePspDateTime struct
    /// `time` - pointer to ScePspDateTime struct to receive time
    /// Returns 0 on success, < 0 on error
    pub extern fn sceRtcGetCurrentClockLocalTime(time: [*c]c_int) callconv(.C) c_int;

    /// Convert a UTC-based tickcount into a local time tick count
    /// `tickUTC` - pointer to u64 tick in UTC time
    /// `tickLocal` - pointer to u64 to receive tick in local time
    /// Returns 0 on success, < 0 on error
    pub extern fn sceRtcConvertUtcToLocalTime(tickUTC: [*c]const u64, tickLocal: [*c]u64) callconv(.C) c_int;

    /// Convert a local time based tickcount into a UTC-based tick count
    /// `tickLocal` - pointer to u64 tick in local time
    /// `tickUTC` - pointer to u64 to receive tick in UTC based time
    /// Returns 0 on success, < 0 on error
    pub extern fn sceRtcConvertLocalTimeToUTC(tickLocal: [*c]const u64, tickUTC: [*c]u64) callconv(.C) c_int;

    /// Check if a year is a leap year
    /// `year` - year to check if is a leap year
    /// Returns 1 on leapyear, 0 if not
    pub extern fn sceRtcIsLeapYear(year: c_int) callconv(.C) c_int;

    /// Get number of days in a specific month
    /// `year` - year in which to check (accounts for leap year)
    /// `month` - month to get number of days for
    /// Returns # of days in month, <0 on error (?)
    pub extern fn sceRtcGetDaysInMonth(year: c_int, month: c_int) callconv(.C) c_int;

    /// Get day of the week for a date
    /// `year` - year in which to check (accounts for leap year)
    /// `month` - month that day is in
    /// `day` - day to get day of week for
    /// Returns day of week with 0 representing Monday
    pub extern fn sceRtcGetDayOfWeek(year: c_int, month: c_int, day: c_int) callconv(.C) c_int;

    /// Validate pspDate component ranges
    /// `date` - pointer to pspDate struct to be checked
    /// Returns 0 on success, one of ::pspRtcCheckValidErrors on error
    pub extern fn sceRtcCheckValid(date: [*c]const c_int) callconv(.C) c_int;

    pub extern fn sceRtcSetTime_t(date: [*c]c_int, time: c_int) callconv(.C) c_int;

    pub extern fn sceRtcGetTime_t(date: [*c]const c_int, time: [*c]c_int) callconv(.C) c_int;

    pub extern fn sceRtcSetDosTime(date: [*c]c_int, dosTime: u32) callconv(.C) c_int;

    pub extern fn sceRtcGetDosTime(date: [*c]c_int, dosTime: u32) callconv(.C) c_int;

    pub extern fn sceRtcSetWin32FileTime(date: [*c]c_int, win32Time: [*c]u64) callconv(.C) c_int;

    pub extern fn sceRtcGetWin32FileTime(date: [*c]c_int, win32Time: [*c]u64) callconv(.C) c_int;

    /// Set a ScePspDateTime struct based on ticks
    /// `date` - pointer to ScePspDateTime struct to set
    /// `tick` - pointer to ticks to convert
    /// Returns 0 on success, < 0 on error
    pub extern fn sceRtcSetTick(date: [*c]c_int, tick: [*c]const u64) callconv(.C) c_int;

    /// Set ticks based on a ScePspDateTime struct
    /// `date` - pointer to ScePspDateTime to convert
    /// `tick` - pointer to tick to set
    /// Returns 0 on success, < 0 on error
    /// Get the resolution of the tick counter
    /// Returns # of ticks per second
    pub extern fn sceRtcGetTick(date: [*c]const c_int, tick: [*c]u64) callconv(.C) c_int;

    /// Compare two ticks
    /// `tick1` - pointer to first tick
    /// `tick2` - poiinter to second tick
    /// Returns 0 on equal, <0 when tick1 < tick2, >0 when tick1 > tick2
    pub extern fn sceRtcCompareTick(tick1: [*c]const u64, tick2: [*c]const u64) callconv(.C) c_int;

    /// Add two ticks
    /// `destTick` - pointer to tick to hold result
    /// `srcTick` - pointer to source tick
    /// `numTicks` - number of ticks to add
    /// Returns 0 on success, <0 on error
    pub extern fn sceRtcTickAddTicks(destTick: [*c]u64, srcTick: [*c]const u64, numTicks: u64) callconv(.C) c_int;

    /// Add an amount of ms to a tick
    /// `destTick` - pointer to tick to hold result
    /// `srcTick` - pointer to source tick
    /// `numMS` - number of ms to add
    /// Returns 0 on success, <0 on error
    pub extern fn sceRtcTickAddMicroseconds(destTick: [*c]u64, srcTick: [*c]const u64, numMS: u64) callconv(.C) c_int;

    /// Add an amount of seconds to a tick
    /// `destTick` - pointer to tick to hold result
    /// `srcTick` - pointer to source tick
    /// `numSecs` - number of seconds to add
    /// Returns 0 on success, <0 on error
    pub extern fn sceRtcTickAddSeconds(destTick: [*c]u64, srcTick: [*c]const u64, numSecs: u64) callconv(.C) c_int;

    /// Add an amount of minutes to a tick
    /// `destTick` - pointer to tick to hold result
    /// `srcTick` - pointer to source tick
    /// `numMins` - number of minutes to add
    /// Returns 0 on success, <0 on error
    pub extern fn sceRtcTickAddMinutes(destTick: [*c]u64, srcTick: [*c]const u64, numMins: u64) callconv(.C) c_int;

    /// Add an amount of hours to a tick
    /// `destTick` - pointer to tick to hold result
    /// `srcTick` - pointer to source tick
    /// `numHours` - number of hours to add
    /// Returns 0 on success, <0 on error
    pub extern fn sceRtcTickAddHours(destTick: [*c]u64, srcTick: [*c]const u64, numHours: c_int) callconv(.C) c_int;

    /// Add an amount of days to a tick
    /// `destTick` - pointer to tick to hold result
    /// `srcTick` - pointer to source tick
    /// `numDays` - number of days to add
    /// Returns 0 on success, <0 on error
    pub extern fn sceRtcTickAddDays(destTick: [*c]u64, srcTick: [*c]const u64, numDays: c_int) callconv(.C) c_int;

    /// Add an amount of weeks to a tick
    /// `destTick` - pointer to tick to hold result
    /// `srcTick` - pointer to source tick
    /// `numWeeks` - number of weeks to add
    /// Returns 0 on success, <0 on error
    pub extern fn sceRtcTickAddWeeks(destTick: [*c]u64, srcTick: [*c]const u64, numWeeks: c_int) callconv(.C) c_int;

    /// Add an amount of months to a tick
    /// `destTick` - pointer to tick to hold result
    /// `srcTick` - pointer to source tick
    /// `numMonths` - number of months to add
    /// Returns 0 on success, <0 on error
    pub extern fn sceRtcTickAddMonths(destTick: [*c]u64, srcTick: [*c]const u64, numMonths: c_int) callconv(.C) c_int;

    /// Add an amount of years to a tick
    /// `destTick` - pointer to tick to hold result
    /// `srcTick` - pointer to source tick
    /// `numYears` - number of years to add
    /// Returns 0 on success, <0 on error
    pub extern fn sceRtcTickAddYears(destTick: [*c]u64, srcTick: [*c]const u64, numYears: c_int) callconv(.C) c_int;

    /// Format Tick-representation UTC time in RFC2822 format
    pub extern fn sceRtcFormatRFC2822(pszDateTime: [*c]c_char, pUtc: [*c]const u64, iTimeZoneMinutes: c_int) callconv(.C) c_int;

    /// Format Tick-representation UTC time in RFC2822 format
    pub extern fn sceRtcFormatRFC2822LocalTime(pszDateTime: [*c]c_char, pUtc: [*c]const u64) callconv(.C) c_int;

    /// Format Tick-representation UTC time in RFC3339(ISO8601) format
    pub extern fn sceRtcFormatRFC3339(pszDateTime: [*c]c_char, pUtc: [*c]const u64, iTimeZoneMinutes: c_int) callconv(.C) c_int;

    /// Format Tick-representation UTC time in RFC3339(ISO8601) format
    pub extern fn sceRtcFormatRFC3339LocalTime(pszDateTime: [*c]c_char, pUtc: [*c]const u64) callconv(.C) c_int;

    pub extern fn sceRtcParseDateTime(destTick: [*c]u64, dateString: [*c]const c_char) callconv(.C) c_int;

    /// Parse time information represented in RFC3339 format
    pub extern fn sceRtcParseRFC3339(pUtc: [*c]u64, pszDateTime: [*c]const c_char) callconv(.C) c_int;

    pub extern fn sceRtcGetAccumulativeTime() callconv(.C) void;

    pub extern fn sceRtcSetTime64_t() callconv(.C) void;

    pub extern fn sceRtcGetLastReincarnatedTime() callconv(.C) void;

    pub extern fn sceRtcGetLastAdjustedTime() callconv(.C) void;

    pub extern fn sceRtcGetTime64_t() callconv(.C) void;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceRtc") and options.sceRtc)) sceRtc else EMPTY;

const sceVaudio = struct {
    /// Output audio (blocking)
    /// `volume` - It must be a value between 0 and ::PSP_VAUDIO_VOLUME_MAX
    /// `buffer` - Pointer to the PCM data to output.
    /// Returns 0 on success, an error if less than 0.
    pub extern fn sceVaudioOutputBlocking(volume: c_int, buffer: ?*anyopaque) callconv(.C) c_int;

    /// Allocate and initialize a virtual output channel.
    /// `samplecount` - The number of samples that can be output on the channel per
    /// output call. One of 256, 576, 1024, 1152, 2048.
    /// It must be a value between ::PSP_VAUDIO_SAMPLE_MIN and ::PSP_VAUDIO_SAMPLE_MAX.
    /// `frequency` - The frequency. One of 48000, 44100, 32000, 24000, 22050, 16000, 12000, 11050, 8000.
    /// `format` - The output format to use for the channel. One of ::PSP_VAUDIO_FORMAT_
    /// Returns 0 if success, < 0 on error.
    pub extern fn sceVaudioChReserve(samplecount: c_int, frequency: c_int, format: c_int) callconv(.C) c_int;

    /// Release  a virtual output channel.
    /// Returns 0 if success, < 0 on error.
    pub extern fn sceVaudioChRelease() callconv(.C) c_int;

    /// Set effect type
    /// `effect` - The effect type. One of ::PSP_VAUDIO_EFFECT_
    /// `volume` - The volume. It must be a value between 0 and ::PSP_VAUDIO_VOLUME_MAX
    /// Returns The volume value on success, < 0 on error.
    pub extern fn sceVaudioSetEffectType(effect: c_int, volume: c_int) callconv(.C) c_int;

    /// Set ALC(dynamic normalizer)
    /// `mode` - The mode. One of ::PSP_VAUDIO_ALC_
    /// Returns 0 if success, < 0 on error.
    pub extern fn sceVaudioSetAlcMode(mode: c_int) callconv(.C) c_int;

    pub extern fn sceVaudio_504E4745() callconv(.C) void;

    pub extern fn sceVaudioChReserveBuffering() callconv(.C) void;

    pub extern fn sceVaudio_E8E78DC8() callconv(.C) void;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceVaudio") and options.sceVaudio)) sceVaudio else EMPTY;

const sceReg = struct {
    pub extern fn sceRegExit() callconv(.C) void;

    /// Open the registry
    /// `reg` - A filled in ::RegParam structure
    /// `mode` - Open mode (set to 1)
    /// `h` - Pointer to a REGHANDLE to receive the registry handle
    /// Returns 0 on success, < 0 on error
    pub extern fn sceRegOpenRegistry(reg: [*c]c_int, mode: c_int, h: [*c]c_int) callconv(.C) c_int;

    /// Close the registry
    /// `h` - The open registry handle
    /// Returns 0 on success, < 0 on error
    pub extern fn sceRegCloseRegistry(h: c_int) callconv(.C) c_int;

    /// Remove a registry (HONESTLY, DO NOT USE)
    /// `reg` - Filled out registry parameter
    /// Returns 0 on success, < 0 on error
    pub extern fn sceRegRemoveRegistry(reg: [*c]c_int) callconv(.C) c_int;

    /// Open a registry directory
    /// `h` - The open registry handle
    /// `name` - The path to the dir to open (e.g. /CONFIG/SYSTEM)
    /// `mode` - Open mode (can be 1 or 2, probably read or read/write
    /// `hd` - Pointer to a REGHANDLE to receive the registry dir handle
    /// Returns 0 on success, < 0 on error
    pub extern fn sceRegOpenCategory(h: c_int, name: [*c]const c_char, mode: c_int, hd: [*c]c_int) callconv(.C) c_int;

    /// Close the registry directory
    /// `hd` - The open registry dir handle
    /// Returns 0 on success, < 0 on error
    pub extern fn sceRegCloseCategory(hd: c_int) callconv(.C) c_int;

    /// Flush the registry to disk
    /// `h` - The open registry handle
    /// Returns 0 on success, < 0 on error
    pub extern fn sceRegFlushRegistry(h: c_int) callconv(.C) c_int;

    /// Flush the registry directory to disk
    /// `hd` - The open registry dir handle
    /// Returns 0 on success, < 0 on error
    pub extern fn sceRegFlushCategory(hd: c_int) callconv(.C) c_int;

    /// Create a key
    /// `hd` - The open registry dir handle
    /// `name` - Name of the key to create
    /// `type` - Type of key (note cannot be a directory type)
    /// `size` - Size of the allocated value space
    /// Returns 0 on success, < 0 on error
    pub extern fn sceRegCreateKey(hd: c_int, name: [*c]const c_char, type: c_int, size: SceSize) callconv(.C) c_int;

    /// Set a key's value
    /// `hd` - The open registry dir handle
    /// `name` - The key name
    /// `buf` - Buffer to hold the value
    /// `size` - The size of the buffer
    /// Returns 0 on success, < 0 on error
    pub extern fn sceRegSetKeyValue(hd: c_int, name: [*c]const c_char, buf: ?*const anyopaque, size: SceSize) callconv(.C) c_int;

    /// Get a key's information
    /// `hd` - The open registry dir handle
    /// `name` - Name of the key
    /// `hk` - Pointer to a REGHANDLE to get registry key handle
    /// `type` - Type of the key, on of ::RegKeyTypes
    /// `size` - The size of the key's value in bytes
    /// Returns 0 on success, < 0 on error
    pub extern fn sceRegGetKeyInfo(hd: c_int, name: [*c]const c_char, hk: [*c]c_int, type: [*c]c_uint, size: [*c]SceSize) callconv(.C) c_int;

    /// Get a key's value
    /// `hd` - The open registry dir handle
    /// `hk` - The open registry key handler (from ::sceRegGetKeyInfo)
    /// `buf` - Buffer to hold the value
    /// `size` - The size of the buffer
    /// Returns 0 on success, < 0 on error
    pub extern fn sceRegGetKeyValue(hd: c_int, hk: c_int, buf: ?*anyopaque, size: SceSize) callconv(.C) c_int;

    /// Get number of subkeys in the current dir
    /// `hd` - The open registry dir handle
    /// `num` - Pointer to an integer to receive the number
    /// Returns 0 on success, < 0 on error
    pub extern fn sceRegGetKeysNum(hd: c_int, num: [*c]c_int) callconv(.C) c_int;

    /// Get the key names in the current directory
    /// `hd` - The open registry dir handle
    /// `buf` - Buffer to hold the NUL terminated strings, should be num*REG_KEYNAME_SIZE
    /// `num` - Number of elements in buf
    /// Returns 0 on success, < 0 on error
    /// Get number of subkeys in the current dir
    /// `hd` - The open registry dir handle
    /// `num` - Pointer to an integer to receive the number
    /// Returns 0 on success, < 0 on error
    pub extern fn sceRegGetKeys(hd: c_int, buf: [*c]c_char, num: c_int) callconv(.C) c_int;

    /// Remove a registry dir
    /// `h` - The open registry dir handle
    /// `name` - The name of the key
    /// Returns 0 on success, < 0 on error
    pub extern fn sceRegRemoveCategory(h: c_int, name: [*c]const c_char) callconv(.C) c_int;

    pub extern fn sceRegRemoveKey() callconv(.C) void;

    /// Get a key's information by name
    /// `hd` - The open registry dir handle
    /// `name` - Name of the key
    /// `type` - Type of the key, on of ::RegKeyTypes
    /// `size` - The size of the key's value in bytes
    /// Returns 0 on success, < 0 on error
    pub extern fn sceRegGetKeyInfoByName(hd: c_int, name: [*c]const c_char, type: [*c]c_uint, size: [*c]SceSize) callconv(.C) c_int;

    /// Get a key's value by name
    /// `hd` - The open registry dir handle
    /// `name` - The key name
    /// `buf` - Buffer to hold the value
    /// `size` - The size of the buffer
    /// Returns 0 on success, < 0 on error
    pub extern fn sceRegGetKeyValueByName(hd: c_int, name: [*c]const c_char, buf: ?*anyopaque, size: SceSize) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceReg") and options.sceReg)) sceReg else EMPTY;

const sceWlanDrv_lib = struct {
    /// Attach to the wlan device
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceWlanDevAttach() callconv(.C) c_int;

    /// Detach from the wlan device
    /// Returns 0 on success, < 0 on error/
    pub extern fn sceWlanDevDetach() callconv(.C) c_int;

    pub extern fn sceWlanDrv_lib_19E51F54() callconv(.C) void;

    pub extern fn sceWlanDevIsGameMode() callconv(.C) void;

    pub extern fn sceWlanGPPrevEstablishActive() callconv(.C) void;

    pub extern fn sceWlanGPSend() callconv(.C) void;

    pub extern fn sceWlanGPRecv() callconv(.C) void;

    pub extern fn sceWlanGPRegisterCallback() callconv(.C) void;

    pub extern fn sceWlanGPUnRegisterCallback() callconv(.C) void;

    pub extern fn sceWlanDrv_lib_81579D36() callconv(.C) void;

    pub extern fn sceWlanDrv_lib_5BAA1FE5() callconv(.C) void;

    pub extern fn sceWlanDrv_lib_4C14BACA() callconv(.C) void;

    pub extern fn sceWlanDrv_lib_2D0FAE4E() callconv(.C) void;

    pub extern fn sceWlanDrv_lib_56F467CA() callconv(.C) void;

    pub extern fn sceWlanDrv_lib_FE8A0B46() callconv(.C) void;

    pub extern fn sceWlanDrv_lib_40B0AA4A() callconv(.C) void;

    pub extern fn sceWlanDevSetGPIO() callconv(.C) void;

    pub extern fn sceWlanDevGetStateGPIO() callconv(.C) void;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceWlanDrv_lib") and options.sceWlanDrv_lib)) sceWlanDrv_lib else EMPTY;

const sceWlanDrv = struct {
    /// Determine if the wlan device is currently powered on
    /// Returns 0 if off, 1 if on
    pub extern fn sceWlanDevIsPowerOn() callconv(.C) c_int;

    /// Determine the state of the Wlan power switch
    /// Returns 0 if off, 1 if on
    pub extern fn sceWlanGetSwitchState() callconv(.C) c_int;

    /// Get the Ethernet Address of the wlan controller
    /// `etherAddr` - pointer to a buffer of uint8_t (NOTE: it only writes to 6 bytes, but
    /// requests 8 so pass it 8 bytes just in case)
    /// Returns 0 on success, < 0 on error
    pub extern fn sceWlanGetEtherAddr(etherAddr: [*c]u8) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceWlanDrv") and options.sceWlanDrv)) sceWlanDrv else EMPTY;

const sceOpenPSID = struct {
    pub extern fn sceOpenPSIDGetOpenPSID(openpsid: [*c]c_int) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceOpenPSID") and options.sceOpenPSID)) sceOpenPSID else EMPTY;

const sceDisplay = struct {
    /// Set display mode
    /// @par Example1:
    /// `
    /// `
    /// `mode` - Display mode, normally 0.
    /// `width` - Width of screen in pixels.
    /// `height` - Height of screen in pixels.
    /// Returns ???
    pub extern fn sceDisplaySetMode(mode: c_int, width: c_int, height: c_int) callconv(.C) c_int;

    /// Get display mode
    /// `pmode` - Pointer to an integer to receive the current mode.
    /// `pwidth` - Pointer to an integer to receive the current width.
    /// `pheight` - Pointer to an integer to receive the current height,
    /// Returns 0 on success
    pub extern fn sceDisplayGetMode(pmode: [*c]c_int, pwidth: [*c]c_int, pheight: [*c]c_int) callconv(.C) c_int;

    /// Get number of frames per second
    pub extern fn sceDisplayGetFramePerSec() callconv(.C) f32;

    pub extern fn sceDisplaySetHoldMode() callconv(.C) void;

    pub extern fn sceDisplaySetResumeMode() callconv(.C) void;

    /// Display set framebuf
    /// `topaddr` - address of start of framebuffer
    /// `bufferwidth` - buffer width (must be power of 2)
    /// `pixelformat` - One of ::PspDisplayPixelFormats.
    /// `sync` - One of ::PspDisplaySetBufSync
    /// Returns 0 on success
    pub extern fn sceDisplaySetFrameBuf(topaddr: ?*anyopaque, bufferwidth: c_int, pixelformat: c_int, sync: c_int) callconv(.C) c_int;

    /// Get Display Framebuffer information
    /// `topaddr` - pointer to void* to receive address of start of framebuffer
    /// `bufferwidth` - pointer to int to receive buffer width (must be power of 2)
    /// `pixelformat` - pointer to int to receive one of ::PspDisplayPixelFormats.
    /// `sync` - One of ::PspDisplaySetBufSync
    /// Returns 0 on success
    pub extern fn sceDisplayGetFrameBuf(topaddr: ?*anyopaque, bufferwidth: [*c]c_int, pixelformat: [*c]c_int, sync: c_int) callconv(.C) c_int;

    /// Get whether or not frame buffer is being displayed
    pub extern fn sceDisplayIsForeground() callconv(.C) c_int;

    pub extern fn sceDisplay_31C4BAA8() callconv(.C) void;

    /// Number of vertical blank pulses up to now
    pub extern fn sceDisplayGetVcount() callconv(.C) c_uint;

    /// Test whether VBLANK is active
    pub extern fn sceDisplayIsVblank() callconv(.C) c_int;

    /// Wait for vertical blank
    /// Wait for vertical blank start with callback
    /// Wait for vertical blank start
    pub extern fn sceDisplayWaitVblank() callconv(.C) c_int;

    /// Wait for vertical blank with callback
    pub extern fn sceDisplayWaitVblankCB() callconv(.C) c_int;

    /// Wait for vertical blank start
    pub extern fn sceDisplayWaitVblankStart() callconv(.C) c_int;

    /// Wait for vertical blank start with callback
    pub extern fn sceDisplayWaitVblankStartCB() callconv(.C) c_int;

    /// Get current HSYNC count
    pub extern fn sceDisplayGetCurrentHcount() callconv(.C) c_int;

    /// Get accumlated HSYNC count
    pub extern fn sceDisplayGetAccumulatedHcount() callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceDisplay") and options.sceDisplay)) sceDisplay else EMPTY;

const sceAtrac3plus = struct {
    pub extern fn sceAtracStartEntry() callconv(.C) void;

    pub extern fn sceAtracEndEntry() callconv(.C) void;

    pub extern fn sceAtracGetAtracID() callconv(.C) void;

    /// It releases an atrac ID
    /// `atracID` - the atrac ID to release
    /// Returns < 0 on error
    pub extern fn sceAtracReleaseAtracID(atracID: c_int) callconv(.C) c_int;

    /// Creates a new Atrac ID from the specified data
    /// `buf` - the buffer holding the atrac3 data, including the RIFF/WAVE header.
    /// `bufsize` - the size of the buffer pointed by buf
    /// Returns the new atrac ID, or < 0 on error
    pub extern fn sceAtracSetData(atracID: c_int, pucBufferAddr: [*c]u8, uiBufferByte: u32) callconv(.C) c_int;

    pub extern fn sceAtracSetHalfwayBuffer(atracID: c_int, pucBufferAddr: [*c]u8, uiReadByte: u32, uiBufferByte: u32) callconv(.C) c_int;

    /// Creates a new Atrac ID from the specified data
    /// `buf` - the buffer holding the atrac3 data, including the RIFF/WAVE header.
    /// `bufsize` - the size of the buffer pointed by buf
    /// Returns the new atrac ID, or < 0 on error
    pub extern fn sceAtracSetDataAndGetID(buf: ?*anyopaque, bufsize: SceSize) callconv(.C) c_int;

    pub extern fn sceAtracSetHalfwayBufferAndGetID(pucBufferAddr: [*c]u8, uiReadByte: u32, uiBufferByte: u32) callconv(.C) c_int;

    /// Decode a frame of data.
    /// `atracID` - the atrac ID
    /// `outSamples` - pointer to a buffer that receives the decoded data of the current frame
    /// `outN` - pointer to a integer that receives the number of audio samples of the decoded frame
    /// `outEnd` - pointer to a integer that receives a boolean value indicating if the decoded frame is the last one
    /// `outRemainFrame` - pointer to a integer that receives either -1 if all at3 data is already on memory,
    /// or the remaining (not decoded yet) frames at memory if not all at3 data is on memory
    /// Returns < 0 on error, otherwise 0
    pub extern fn sceAtracDecodeData(atracID: c_int, outSamples: [*c]u16, outN: [*c]c_int, outEnd: [*c]c_int, outRemainFrame: [*c]c_int) callconv(.C) c_int;

    /// Gets the remaining (not decoded) number of frames
    /// `atracID` - the atrac ID
    /// `outRemainFrame` - pointer to a integer that receives either -1 if all at3 data is already on memory,
    /// or the remaining (not decoded yet) frames at memory if not all at3 data is on memory
    /// Returns < 0 on error, otherwise 0
    pub extern fn sceAtracGetRemainFrame(atracID: c_int, outRemainFrame: [*c]c_int) callconv(.C) c_int;

    pub extern fn sceAtracGetStreamDataInfo(atracID: c_int, writePointer: [*c]u8, availableBytes: [*c]u32, readOffset: [*c]u32) callconv(.C) c_int;

    /// `atracID` - the atrac ID
    /// `bytesToAdd` - Number of bytes read into location given by sceAtracGetStreamDataInfo().
    /// Returns < 0 on error, otherwise 0
    pub extern fn sceAtracAddStreamData(atracID: c_int, bytesToAdd: c_uint) callconv(.C) c_int;

    pub extern fn sceAtracGetSecondBufferInfo(atracID: c_int, puiPosition: [*c]u32, puiDataByte: [*c]u32) callconv(.C) c_int;

    pub extern fn sceAtracSetSecondBuffer(atracID: c_int, pucSecondBufferAddr: [*c]u8, uiSecondBufferByte: u32) callconv(.C) c_int;

    pub extern fn sceAtracGetNextDecodePosition(atracID: c_int, puiSamplePosition: [*c]u32) callconv(.C) c_int;

    pub extern fn sceAtracGetSoundSample(atracID: c_int, piEndSample: [*c]c_int, piLoopStartSample: [*c]c_int, piLoopEndSample: [*c]c_int) callconv(.C) c_int;

    pub extern fn sceAtracGetChannel(atracID: c_int, puiChannel: [*c]u32) callconv(.C) c_int;

    /// Gets the maximum number of samples of the atrac3 stream.
    /// `atracID` - the atrac ID
    /// `outMax` - pointer to a integer that receives the maximum number of samples.
    /// Returns < 0 on error, otherwise 0
    pub extern fn sceAtracGetMaxSample(atracID: c_int, outMax: [*c]c_int) callconv(.C) c_int;

    /// Gets the number of samples of the next frame to be decoded.
    /// `atracID` - the atrac ID
    /// `outN` - pointer to receives the number of samples of the next frame.
    /// Returns < 0 on error, otherwise 0
    pub extern fn sceAtracGetNextSample(atracID: c_int, outN: [*c]c_int) callconv(.C) c_int;

    /// Gets the bitrate.
    /// `atracID` - the atracID
    /// `outBitrate` - pointer to a integer that receives the bitrate in kbps
    /// Returns < 0 on error, otherwise 0
    pub extern fn sceAtracGetBitrate(atracID: c_int, outBitrate: [*c]c_int) callconv(.C) c_int;

    pub extern fn sceAtracGetLoopStatus(atracID: c_int, piLoopNum: [*c]c_int, puiLoopStatus: [*c]u32) callconv(.C) c_int;

    /// Sets the number of loops for this atrac ID
    /// `atracID` - the atracID
    /// `nloops` - the number of loops to set
    /// Returns < 0 on error, otherwise 0
    pub extern fn sceAtracSetLoopNum(atracID: c_int, nloops: c_int) callconv(.C) c_int;

    pub extern fn sceAtracGetBufferInfoForReseting(atracID: c_int, uiSample: u32, pBufferInfo: [*c]c_int) callconv(.C) c_int;

    pub extern fn sceAtracResetPlayPosition(atracID: c_int, uiSample: u32, uiWriteByteFirstBuf: u32, uiWriteByteSecondBuf: u32) callconv(.C) c_int;

    pub extern fn sceAtracGetInternalErrorInfo(atracID: c_int, piResult: [*c]c_int) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceAtrac3plus") and options.sceAtrac3plus)) sceAtrac3plus else EMPTY;

const sceUsbstor = struct {
    pub extern fn sceUsbstorGetStatus() callconv(.C) void;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceUsbstor") and options.sceUsbstor)) sceUsbstor else EMPTY;

const sceUtility = struct {
    /// Init the game sharing
    /// `params` - game sharing parameters
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceUtilityGameSharingInitStart(params: [*c]c_int) callconv(.C) c_int;

    /// Shutdown game sharing.
    pub extern fn sceUtilityGameSharingShutdownStart() callconv(.C) void;

    /// Refresh the GUI for game sharing
    /// `n` - unknown, pass 1
    pub extern fn sceUtilityGameSharingUpdate(n: c_int) callconv(.C) void;

    /// Get the current status of game sharing.
    /// Returns 2 if the GUI is visible (you need to call sceUtilityGameSharingGetStatus).
    /// 3 if the user cancelled the dialog, and you need to call sceUtilityGameSharingShutdownStart.
    /// 4 if the dialog has been successfully shut down.
    pub extern fn sceUtilityGameSharingGetStatus() callconv(.C) c_int;

    pub extern fn sceNetplayDialogInitStart() callconv(.C) void;

    pub extern fn sceNetplayDialogShutdownStart() callconv(.C) void;

    pub extern fn sceNetplayDialogUpdate() callconv(.C) void;

    pub extern fn sceNetplayDialogGetStatus() callconv(.C) void;

    /// Init the Network Configuration Dialog Utility
    /// `data` - pointer to pspUtilityNetconfData to be initialized
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUtilityNetconfInitStart(data: [*c]c_int) callconv(.C) c_int;

    /// Shutdown the Network Configuration Dialog Utility
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUtilityNetconfShutdownStart() callconv(.C) c_int;

    /// Update the Network Configuration Dialog GUI
    /// `unknown` - unknown; set to 1
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUtilityNetconfUpdate(unknown: c_int) callconv(.C) c_int;

    /// Get the status of a running Network Configuration Dialog
    /// Returns one of pspUtilityDialogState on success, < 0 on error
    pub extern fn sceUtilityNetconfGetStatus() callconv(.C) c_int;

    /// Saves or Load savedata to/from the passed structure
    /// After having called this continue calling sceUtilitySavedataGetStatus to
    /// check if the operation is completed
    /// `params` - savedata parameters
    /// Returns 0 on success
    pub extern fn sceUtilitySavedataInitStart(params: [*c]c_int) callconv(.C) c_int;

    /// Shutdown the savedata utility. after calling this continue calling
    /// ::sceUtilitySavedataGetStatus to check when it has shutdown
    /// Returns 0 on success
    pub extern fn sceUtilitySavedataShutdownStart() callconv(.C) c_int;

    /// Refresh status of the savedata function
    /// `unknown` - unknown, pass 1
    pub extern fn sceUtilitySavedataUpdate(unknown: c_int) callconv(.C) void;

    /// Check the current status of the saving/loading/shutdown process
    /// Continue calling this to check current status of the process
    /// before calling this call also sceUtilitySavedataUpdate
    /// Returns 2 if the process is still being processed.
    /// 3 on save/load success, then you can call sceUtilitySavedataShutdownStart.
    /// 4 on complete shutdown.
    pub extern fn sceUtilitySavedataGetStatus() callconv(.C) c_int;

    pub extern fn sceUtility_2995D020() callconv(.C) void;

    pub extern fn sceUtility_B62A4061() callconv(.C) void;

    pub extern fn sceUtility_ED0FAD38() callconv(.C) void;

    pub extern fn sceUtility_88BC7406() callconv(.C) void;

    /// Create a message dialog
    /// `params` - dialog parameters
    /// Returns 0 on success
    pub extern fn sceUtilityMsgDialogInitStart(params: [*c]c_int) callconv(.C) c_int;

    /// Remove a message dialog currently active.  After calling this
    /// function you need to keep calling GetStatus and Update until
    /// you get a status of 4.
    pub extern fn sceUtilityMsgDialogShutdownStart() callconv(.C) void;

    /// Refresh the GUI for a message dialog currently active
    /// `n` - unknown, pass 1
    pub extern fn sceUtilityMsgDialogUpdate(n: c_int) callconv(.C) void;

    /// Get the current status of a message dialog currently active.
    /// Returns 2 if the GUI is visible (you need to call sceUtilityMsgDialogGetStatus).
    /// 3 if the user cancelled the dialog, and you need to call sceUtilityMsgDialogShutdownStart.
    /// 4 if the dialog has been successfully shut down.
    pub extern fn sceUtilityMsgDialogGetStatus() callconv(.C) c_int;

    /// Create an on-screen keyboard
    /// `params` - OSK parameters.
    /// Returns < 0 on error.
    pub extern fn sceUtilityOskInitStart(params: [*c]c_int) callconv(.C) c_int;

    /// Remove a currently active keyboard. After calling this function you must
    /// poll sceUtilityOskGetStatus() until it returns PSP_UTILITY_DIALOG_NONE.
    /// Returns < 0 on error.
    pub extern fn sceUtilityOskShutdownStart() callconv(.C) c_int;

    /// Refresh the GUI for a keyboard currently active
    /// `n` - Unknown, pass 1.
    /// Returns < 0 on error.
    pub extern fn sceUtilityOskUpdate(n: c_int) callconv(.C) c_int;

    /// Get the status of a on-screen keyboard currently active.
    /// Returns the current status of the keyboard. See ::pspUtilityDialogState for details.
    pub extern fn sceUtilityOskGetStatus() callconv(.C) c_int;

    /// Set Integer System Parameter
    /// `id` - which parameter to set
    /// `value` - integer value to set
    /// Returns 0 on success, PSP_SYSTEMPARAM_RETVAL_FAIL on failure
    pub extern fn sceUtilitySetSystemParamInt(id: c_int, value: c_int) callconv(.C) c_int;

    /// Set String System Parameter
    /// `id` - which parameter to set
    /// `str` - char * value to set
    /// Returns 0 on success, PSP_SYSTEMPARAM_RETVAL_FAIL on failure
    pub extern fn sceUtilitySetSystemParamString(id: c_int, str: [*c]const c_char) callconv(.C) c_int;

    /// Get Integer System Parameter
    /// `id` - which parameter to get
    /// `value` - pointer to integer value to place result in
    /// Returns 0 on success, PSP_SYSTEMPARAM_RETVAL_FAIL on failure
    pub extern fn sceUtilityGetSystemParamInt(id: c_int, value: [*c]c_int) callconv(.C) c_int;

    /// Get String System Parameter
    /// `id` - which parameter to get
    /// `str` - char * buffer to place result in
    /// `len` - length of str buffer
    /// Returns 0 on success, PSP_SYSTEMPARAM_RETVAL_FAIL on failure
    pub extern fn sceUtilityGetSystemParamString(id: c_int, str: [*c]c_char, len: c_int) callconv(.C) c_int;

    /// Check existance of a Net Configuration
    /// `id` - id of net Configuration (1 to n)
    /// Returns 0 on success,
    pub extern fn sceUtilityCheckNetParam(id: c_int) callconv(.C) c_int;

    /// Get Net Configuration Parameter
    /// `conf` - Net Configuration number (1 to n)
    /// (0 returns valid but seems to be a copy of the last config requested)
    /// `param` - which parameter to get
    /// `data` - parameter data
    /// Returns 0 on success,
    pub extern fn sceUtilityGetNetParam(conf: c_int, param: c_int, data: [*c]c_int) callconv(.C) c_int;

    /// Load a network module (PRX) from user mode.
    /// Load PSP_NET_MODULE_COMMON and PSP_NET_MODULE_INET
    /// to use infrastructure WifI (via an access point).
    /// Available on firmware 2.00 and higher only.
    /// `module` - module number to load (PSP_NET_MODULE_xxx)
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUtilityLoadNetModule(module: c_int) callconv(.C) c_int;

    /// Unload a network module (PRX) from user mode.
    /// Available on firmware 2.00 and higher only.
    /// `module` - module number be unloaded
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUtilityUnloadNetModule(module: c_int) callconv(.C) c_int;

    /// Load an audio/video module (PRX) from user mode.
    /// Available on firmware 2.00 and higher only.
    /// `module` - module number to load (PSP_AV_MODULE_xxx)
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUtilityLoadAvModule(module: c_int) callconv(.C) c_int;

    /// Unload an audio/video module (PRX) from user mode.
    /// Available on firmware 2.00 and higher only.
    /// `module` - module number to be unloaded
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUtilityUnloadAvModule(module: c_int) callconv(.C) c_int;

    /// Load a usb module (PRX) from user mode.
    /// Available on firmware 2.70 and higher only.
    /// `module` - module number to load (PSP_USB_MODULE_xxx)
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUtilityLoadUsbModule(module: c_int) callconv(.C) c_int;

    /// Unload a usb module (PRX) from user mode.
    /// Available on firmware 2.70 and higher only.
    /// `module` - module number to be unloaded
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUtilityUnloadUsbModule(module: c_int) callconv(.C) c_int;

    /// Abort a message dialog currently active
    pub extern fn sceUtilityMsgDialogAbort() callconv(.C) c_int;

    /// Refresh the GUI for html viewer
    /// `n` - unknown, pass 1
    pub extern fn sceUtilityHtmlViewerUpdate(n: c_int) callconv(.C) c_int;

    /// Get the current status of the html viewer.
    /// Returns 2 if the GUI is visible (you need to call sceUtilityHtmlViewerGetStatus).
    /// 3 if the user cancelled the dialog, and you need to call sceUtilityHtmlViewerShutdownStart.
    /// 4 if the dialog has been successfully shut down.
    pub extern fn sceUtilityHtmlViewerGetStatus() callconv(.C) c_int;

    /// Init the html viewer
    /// `params` - html viewer parameters
    /// Returns 0 on success, < 0 on error.
    pub extern fn sceUtilityHtmlViewerInitStart(params: [*c]c_int) callconv(.C) c_int;

    /// Shutdown html viewer.
    pub extern fn sceUtilityHtmlViewerShutdownStart() callconv(.C) c_int;

    /// Load a module (PRX) from user mode.
    /// `module` - module to load (PSP_MODULE_xxx)
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUtilityLoadModule(module: c_int) callconv(.C) c_int;

    /// Unload a module (PRX) from user mode.
    /// `module` - module to unload (PSP_MODULE_xxx)
    /// Returns 0 on success, < 0 on error
    pub extern fn sceUtilityUnloadModule(module: c_int) callconv(.C) c_int;

    pub extern fn sceUtilityScreenshotInitStart() callconv(.C) void;

    pub extern fn sceUtilityScreenshotShutdownStart() callconv(.C) void;

    pub extern fn sceUtilityScreenshotUpdate() callconv(.C) void;

    pub extern fn sceUtilityScreenshotGetStatus() callconv(.C) void;

    pub extern fn sceUtilityScreenshotContStart() callconv(.C) void;

    pub extern fn sceUtilityNpSigninInitStart() callconv(.C) void;

    pub extern fn sceUtilityNpSigninShutdownStart() callconv(.C) void;

    pub extern fn sceUtilityNpSigninUpdate() callconv(.C) void;

    pub extern fn sceUtilityNpSigninGetStatus() callconv(.C) void;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceUtility") and options.sceUtility)) sceUtility else EMPTY;

const sceUtility_netparam_internal = struct {
    /// Create a new Network Configuration
    /// @note This creates a new configuration at conf and clears 0
    /// `conf` - Net Configuration number (1 to n)
    /// Returns 0 on success
    pub extern fn sceUtilityCreateNetParam(conf: c_int) callconv(.C) c_int;

    /// Deletes a Network Configuration
    /// `conf` - Net Configuration number (1 to n)
    /// Returns 0 on success
    pub extern fn sceUtilityDeleteNetParam(conf: c_int) callconv(.C) c_int;

    /// Copies a Network Configuration to another
    /// `src` - Source Net Configuration number (0 to n)
    /// `dest` - Destination Net Configuration number (0 to n)
    /// Returns 0 on success
    pub extern fn sceUtilityCopyNetParam(src: c_int, dest: c_int) callconv(.C) c_int;

    /// Sets a network parameter
    /// @note This sets only to configuration 0
    /// `param` - Which parameter to set
    /// `val` - Pointer to the the data to set
    /// Returns 0 on success
    pub extern fn sceUtilitySetNetParam(param: c_int, val: ?*const anyopaque) callconv(.C) c_int;

};

pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "sceUtility_netparam_internal") and options.sceUtility_netparam_internal)) sceUtility_netparam_internal else EMPTY;

