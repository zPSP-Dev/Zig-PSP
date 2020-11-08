pub const struct_SceNetMallocStat = extern struct {
    pool: c_int,
    maximum: c_int,
    free: c_int,
};
pub const SceNetMallocStat = struct_SceNetMallocStat;
pub extern fn sceNetInit(poolsize: c_int, calloutprio: c_int, calloutstack: c_int, netintrprio: c_int, netintrstack: c_int) c_int;
pub extern fn sceNetTerm() c_int;
pub extern fn sceNetFreeThreadinfo(thid: c_int) c_int;
pub extern fn sceNetThreadAbort(thid: c_int) c_int;
pub extern fn sceNetEtherStrton(name: [*c]u8, mac: [*c]u8) void;
pub extern fn sceNetEtherNtostr(mac: [*c]u8, name: [*c]u8) void;
pub extern fn sceNetGetLocalEtherAddr(mac: [*c]u8) c_int;
pub extern fn sceNetGetMallocStat(stat: [*c]SceNetMallocStat) c_int;

pub extern fn sceNetAdhocInit() c_int;
pub extern fn sceNetAdhocTerm() c_int;
pub extern fn sceNetAdhocPdpCreate(mac: [*c]u8, port: c_ushort, bufsize: c_uint, unk1: c_int) c_int;
pub extern fn sceNetAdhocPdpDelete(id: c_int, unk1: c_int) c_int;
pub extern fn sceNetAdhocPdpSend(id: c_int, destMacAddr: [*c]u8, port: c_ushort, data: ?*c_void, len: c_uint, timeout: c_uint, nonblock: c_int) c_int;
pub extern fn sceNetAdhocPdpRecv(id: c_int, srcMacAddr: [*c]u8, port: [*c]c_ushort, data: ?*c_void, dataLength: ?*c_void, timeout: c_uint, nonblock: c_int) c_int;
pub const struct_pdpStatStruct = extern struct {
    next: [*c]struct_pdpStatStruct,
    pdpId: c_int,
    mac: [6]u8,
    port: c_ushort,
    rcvdData: c_uint,
};
pub const pdpStatStruct = struct_pdpStatStruct;
pub extern fn sceNetAdhocGetPdpStat(size: [*c]c_int, stat: [*c]pdpStatStruct) c_int;
pub extern fn sceNetAdhocGameModeCreateMaster(data: ?*c_void, size: c_int) c_int;
pub extern fn sceNetAdhocGameModeCreateReplica(mac: [*c]u8, data: ?*c_void, size: c_int) c_int;
pub extern fn sceNetAdhocGameModeUpdateMaster() c_int;
pub extern fn sceNetAdhocGameModeUpdateReplica(id: c_int, unk1: c_int) c_int;
pub extern fn sceNetAdhocGameModeDeleteMaster() c_int;
pub extern fn sceNetAdhocGameModeDeleteReplica(id: c_int) c_int;
pub extern fn sceNetAdhocPtpOpen(srcmac: [*c]u8, srcport: c_ushort, destmac: [*c]u8, destport: c_ushort, bufsize: c_uint, delay: c_uint, count: c_int, unk1: c_int) c_int;
pub extern fn sceNetAdhocPtpConnect(id: c_int, timeout: c_uint, nonblock: c_int) c_int;
pub extern fn sceNetAdhocPtpListen(srcmac: [*c]u8, srcport: c_ushort, bufsize: c_uint, delay: c_uint, count: c_int, queue: c_int, unk1: c_int) c_int;
pub extern fn sceNetAdhocPtpAccept(id: c_int, mac: [*c]u8, port: [*c]c_ushort, timeout: c_uint, nonblock: c_int) c_int;
pub extern fn sceNetAdhocPtpSend(id: c_int, data: ?*c_void, datasize: [*c]c_int, timeout: c_uint, nonblock: c_int) c_int;
pub extern fn sceNetAdhocPtpRecv(id: c_int, data: ?*c_void, datasize: [*c]c_int, timeout: c_uint, nonblock: c_int) c_int;
pub extern fn sceNetAdhocPtpFlush(id: c_int, timeout: c_uint, nonblock: c_int) c_int;
pub extern fn sceNetAdhocPtpClose(id: c_int, unk1: c_int) c_int;
pub const struct_ptpStatStruct = extern struct {
    next: [*c]struct_ptpStatStruct,
    ptpId: c_int,
    mac: [6]u8,
    peermac: [6]u8,
    port: c_ushort,
    peerport: c_ushort,
    sentData: c_uint,
    rcvdData: c_uint,
    unk1: c_int,
};
pub const ptpStatStruct = struct_ptpStatStruct;
pub extern fn sceNetAdhocGetPtpStat(size: [*c]c_int, stat: [*c]ptpStatStruct) c_int;

pub const struct_productStruct = extern struct {
    unknown: c_int,
    product: [9]u8,
    unk: [3]u8,
};
pub const struct_SceNetAdhocctlPeerInfo = extern struct {
    next: [*c]struct_SceNetAdhocctlPeerInfo,
    nickname: [128]u8,
    mac: [6]u8,
    unknown: [6]u8,
    timestamp: c_ulong,
};
pub const struct_SceNetAdhocctlScanInfo = extern struct {
    next: [*c]struct_SceNetAdhocctlScanInfo,
    channel: c_int,
    name: [8]u8,
    bssid: [6]u8,
    unknown: [2]u8,
    unknown2: c_int,
};
pub const struct_SceNetAdhocctlGameModeInfo = extern struct {
    count: c_int,
    macs: [16][6]u8,
};
pub const struct_SceNetAdhocctlParams = extern struct {
    channel: c_int,
    name: [8]u8,
    bssid: [6]u8,
    nickname: [128]u8,
};
pub extern fn sceNetAdhocctlInit(stacksize: c_int, priority: c_int, product: [*c]struct_productStruct) c_int;
pub extern fn sceNetAdhocctlTerm() c_int;
pub extern fn sceNetAdhocctlConnect(name: [*c]const u8) c_int;
pub extern fn sceNetAdhocctlDisconnect() c_int;
pub extern fn sceNetAdhocctlGetState(event: [*c]c_int) c_int;
pub extern fn sceNetAdhocctlCreate(name: [*c]const u8) c_int;
pub extern fn sceNetAdhocctlJoin(scaninfo: [*c]struct_SceNetAdhocctlScanInfo) c_int;
pub extern fn sceNetAdhocctlGetAdhocId(product: [*c]struct_productStruct) c_int;
pub extern fn sceNetAdhocctlCreateEnterGameMode(name: [*c]const u8, unknown: c_int, num: c_int, macs: [*c]u8, timeout: c_uint, unknown2: c_int) c_int;
pub extern fn sceNetAdhocctlJoinEnterGameMode(name: [*c]const u8, hostmac: [*c]u8, timeout: c_uint, unknown: c_int) c_int;
pub extern fn sceNetAdhocctlGetGameModeInfo(gamemodeinfo: [*c]struct_SceNetAdhocctlGameModeInfo) c_int;
pub extern fn sceNetAdhocctlExitGameMode() c_int;
pub extern fn sceNetAdhocctlGetPeerList(length: [*c]c_int, buf: ?*c_void) c_int;
pub extern fn sceNetAdhocctlGetPeerInfo(mac: [*c]u8, size: c_int, peerinfo: [*c]struct_SceNetAdhocctlPeerInfo) c_int;
pub extern fn sceNetAdhocctlScan() c_int;
pub extern fn sceNetAdhocctlGetScanInfo(length: [*c]c_int, buf: ?*c_void) c_int;
pub const sceNetAdhocctlHandler = ?fn (c_int, c_int, ?*c_void) callconv(.C) void;
pub extern fn sceNetAdhocctlAddHandler(handler: sceNetAdhocctlHandler, unknown: ?*c_void) c_int;
pub extern fn sceNetAdhocctlDelHandler(id: c_int) c_int;
pub extern fn sceNetAdhocctlGetNameByAddr(mac: [*c]u8, nickname: [*c]u8) c_int;
pub extern fn sceNetAdhocctlGetAddrByName(nickname: [*c]u8, length: [*c]c_int, buf: ?*c_void) c_int;
pub extern fn sceNetAdhocctlGetParameter(params: [*c]struct_SceNetAdhocctlParams) c_int;

pub const enum_pspAdhocMatchingEvents = extern enum(c_int) {
    PSP_ADHOC_MATCHING_EVENT_HELLO = 1,
    PSP_ADHOC_MATCHING_EVENT_JOIN = 2,
    PSP_ADHOC_MATCHING_EVENT_LEFT = 3,
    PSP_ADHOC_MATCHING_EVENT_REJECT = 4,
    PSP_ADHOC_MATCHING_EVENT_CANCEL = 5,
    PSP_ADHOC_MATCHING_EVENT_ACCEPT = 6,
    PSP_ADHOC_MATCHING_EVENT_COMPLETE = 7,
    PSP_ADHOC_MATCHING_EVENT_TIMEOUT = 8,
    PSP_ADHOC_MATCHING_EVENT_ERROR = 9,
    PSP_ADHOC_MATCHING_EVENT_DISCONNECT = 10,
    PSP_ADHOC_MATCHING_EVENT_DATA = 11,
    PSP_ADHOC_MATCHING_EVENT_DATA_CONFIRM = 12,
    PSP_ADHOC_MATCHING_EVENT_DATA_TIMEOUT = 13,
    _,
};

pub const enum_pspAdhocMatchingModes = extern enum(c_int) {
    PSP_ADHOC_MATCHING_MODE_HOST = 1,
    PSP_ADHOC_MATCHING_MODE_CLIENT = 2,
    PSP_ADHOC_MATCHING_MODE_PTP = 3,
    _,
};
pub const struct_pspAdhocMatchingMember = extern struct {
    next: [*c]struct_pspAdhocMatchingMember,
    mac: [6]u8,
    unknown: [2]u8,
};
pub const struct_pspAdhocPoolStat = extern struct {
    size: c_int,
    maxsize: c_int,
    freesize: c_int,
};
pub extern fn sceNetAdhocMatchingInit(memsize: c_int) c_int;
pub extern fn sceNetAdhocMatchingTerm() c_int;
pub const pspAdhocMatchingCallback = ?fn (c_int, c_int, [*c]u8, c_int, ?*c_void) callconv(.C) void;
pub extern fn sceNetAdhocMatchingCreate(mode: c_int, maxpeers: c_int, port: c_ushort, bufsize: c_int, hellodelay: c_uint, pingdelay: c_uint, initcount: c_int, msgdelay: c_uint, callback: pspAdhocMatchingCallback) c_int;
pub extern fn sceNetAdhocMatchingDelete(matchingid: c_int) c_int;
pub extern fn sceNetAdhocMatchingStart(matchingid: c_int, evthpri: c_int, evthstack: c_int, inthpri: c_int, inthstack: c_int, optlen: c_int, optdata: ?*c_void) c_int;
pub extern fn sceNetAdhocMatchingStop(matchingid: c_int) c_int;
pub extern fn sceNetAdhocMatchingSelectTarget(matchingid: c_int, mac: [*c]u8, optlen: c_int, optdata: ?*c_void) c_int;
pub extern fn sceNetAdhocMatchingCancelTarget(matchingid: c_int, mac: [*c]u8) c_int;
pub extern fn sceNetAdhocMatchingCancelTargetWithOpt(matchingid: c_int, mac: [*c]u8, optlen: c_int, optdata: ?*c_void) c_int;
pub extern fn sceNetAdhocMatchingSendData(matchingid: c_int, mac: [*c]u8, datalen: c_int, data: ?*c_void) c_int;
pub extern fn sceNetAdhocMatchingAbortSendData(matchingid: c_int, mac: [*c]u8) c_int;
pub extern fn sceNetAdhocMatchingSetHelloOpt(matchingid: c_int, optlen: c_int, optdata: ?*c_void) c_int;
pub extern fn sceNetAdhocMatchingGetHelloOpt(matchingid: c_int, optlen: [*c]c_int, optdata: ?*c_void) c_int;
pub extern fn sceNetAdhocMatchingGetMembers(matchingid: c_int, length: [*c]c_int, buf: ?*c_void) c_int;
pub extern fn sceNetAdhocMatchingGetPoolMaxAlloc() c_int;
pub extern fn sceNetAdhocMatchingGetPoolStat(poolstat: [*c]struct_pspAdhocPoolStat) c_int;

pub const union_SceNetApctlInfo = extern union {
    name: [64]u8,
    bssid: [6]u8,
    ssid: [32]u8,
    ssidLength: c_uint,
    securityType: c_uint,
    strength: u8,
    channel: u8,
    powerSave: u8,
    ip: [16]u8,
    subNetMask: [16]u8,
    gateway: [16]u8,
    primaryDns: [16]u8,
    secondaryDns: [16]u8,
    useProxy: c_uint,
    proxyUrl: [128]u8,
    proxyPort: c_ushort,
    eapType: c_uint,
    startBrowser: c_uint,
    wifisp: c_uint,
};
pub const sceNetApctlHandler = ?fn (c_int, c_int, c_int, c_int, ?*c_void) callconv(.C) void;
pub extern fn sceNetApctlInit(stackSize: c_int, initPriority: c_int) c_int;
pub extern fn sceNetApctlTerm() c_int;
pub extern fn sceNetApctlGetInfo(code: c_int, pInfo: [*c]union_SceNetApctlInfo) c_int;
pub extern fn sceNetApctlAddHandler(handler: sceNetApctlHandler, pArg: ?*c_void) c_int;
pub extern fn sceNetApctlDelHandler(handlerId: c_int) c_int;
pub extern fn sceNetApctlConnect(connIndex: c_int) c_int;
pub extern fn sceNetApctlDisconnect() c_int;
pub extern fn sceNetApctlGetState(pState: [*c]c_int) c_int;

pub extern fn sceNetInetInit() c_int;
pub extern fn sceNetInetTerm() c_int;

pub const ApctlState = extern enum(c_int) {
    Disconnected,
    Scanning,
    Joining,
    GettingIp,
    GotIp,
    EapAuth,
    KeyExchange,
};

pub const ApctlEvent = extern enum(c_int) {
    ConnectRequest,
    ScanRequest,
    ScanComplete,
    Established,
    GetIp,
    DisconnectRequest,
    Error,
    Info,
    EapAuth,
    KeyExchange,
    Reconnect,
};

pub const ApctlInfo = extern enum(c_int) {
    ProfileName,
    Bssid,
    Ssid,
    SsidLength,
    SecurityType,
    Strength,
    Channel,
    PowerSave,
    Ip,
    SubnetMask,
    Gateway,
    PrimaryDns,
    SecondaryDns,
    UseProxy,
    ProxyUrl,
    ProxyPort,
    EapType,
    StartBrowser,
    Wifisp,
};

pub const ApctlInfoSecurityType = extern enum(c_int) {
    None,
    Wep,
    Wpa,
};

pub const productStruct = struct_productStruct;
pub const SceNetAdhocctlPeerInfo = struct_SceNetAdhocctlPeerInfo;
pub const SceNetAdhocctlScanInfo = struct_SceNetAdhocctlScanInfo;
pub const SceNetAdhocctlGameModeInfo = struct_SceNetAdhocctlGameModeInfo;
pub const SceNetAdhocctlParams = struct_SceNetAdhocctlParams;
pub const pspAdhocMatchingEvents = enum_pspAdhocMatchingEvents;
pub const pspAdhocMatchingModes = enum_pspAdhocMatchingModes;
pub const pspAdhocMatchingMember = struct_pspAdhocMatchingMember;
pub const pspAdhocPoolStat = struct_pspAdhocPoolStat;
pub const SceNetApctlInfo = union_SceNetApctlInfo;

pub const socklen_t = u32;
pub const sa_family_t = u8;

pub const struct_sockaddr = extern struct {
    sa_len: u8,
    sa_family: sa_family_t,
    sa_data: [14]u8,
};
pub const sockaddr = struct_sockaddr;

pub extern fn sceNetInetAccept(s: c_int, addr: [*c]struct_sockaddr, addrlen: [*c]socklen_t) c_int;
pub extern fn sceNetInetBind(s: c_int, my_addr: [*c]const struct_sockaddr, addrlen: socklen_t) c_int;
pub extern fn sceNetInetConnect(s: c_int, serv_addr: [*c]const struct_sockaddr, addrlen: socklen_t) c_int;
pub extern fn sceNetInetGetsockopt(s: c_int, level: c_int, optname: c_int, optval: ?*c_void, optlen: [*c]socklen_t) c_int;
pub extern fn sceNetInetListen(s: c_int, backlog: c_int) c_int;
pub extern fn sceNetInetRecv(s: c_int, buf: ?*c_void, len: u32, flags: c_int) u32;
pub extern fn sceNetInetRecvfrom(s: c_int, buf: ?*c_void, flags: u32, c_int, from: [*c]struct_sockaddr, fromlen: [*c]socklen_t) u32;
pub extern fn sceNetInetSend(s: c_int, buf: ?*const c_void, len: u32, flags: c_int) u32;
pub extern fn sceNetInetSendto(s: c_int, buf: ?*const c_void, len: u32, flags: c_int, to: [*c]const struct_sockaddr, tolen: socklen_t) u32;
pub extern fn sceNetInetSetsockopt(s: c_int, level: c_int, optname: c_int, optval: ?*const c_void, optlen: socklen_t) c_int;
pub extern fn sceNetInetShutdown(s: c_int, how: c_int) c_int;
pub extern fn sceNetInetSocket(domain: c_int, type: c_int, protocol: c_int) c_int;
pub extern fn sceNetInetClose(s: c_int) c_int;
pub extern fn sceNetInetGetErrno() c_int;

pub const in_addr_t = u32;
pub const struct_in_addr = packed struct {
    s_addr: in_addr_t,
};

pub extern fn sceNetResolverInit() c_int;
pub extern fn sceNetResolverCreate(rid: [*c]c_int, buf: ?*c_void, buflen: SceSize) c_int;
pub extern fn sceNetResolverDelete(rid: c_int) c_int;
pub extern fn sceNetResolverStartNtoA(rid: c_int, hostname: [*c]const u8, addr: [*c]struct_in_addr, timeout: c_uint, retry: c_int) c_int;
pub extern fn sceNetResolverStartAtoN(rid: c_int, addr: [*c]const struct_in_addr, hostname: [*c]u8, hostname_len: SceSize, timeout: c_uint, retry: c_int) c_int;
pub extern fn sceNetResolverStop(rid: c_int) c_int;
pub extern fn sceNetResolverTerm() c_int;
