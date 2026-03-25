// Ad-hoc networking -- direct PSP-to-PSP communication and matchmaking
//
// Wraps:
//   c/module/sceNetAdhoc.zig
//   c/module/sceNetAdhocctl.zig
//   c/module/sceNetAdhocMatching.zig

const c = @import("../c/modules.zig");
const internal = @import("internal.zig");
const check = internal.check;
const checkPositive = internal.checkPositive;
const ci = internal.ci;
const cu = internal.cu;
const Error = internal.Error;

const adhoc = c.sceNetAdhoc;
const ctl = c.sceNetAdhocctl;
const matching = c.sceNetAdhocMatching;

// -- Re-exported types -------------------------------------------------

pub const ProductStruct = c.types.productStruct;
pub const ScanInfo = c.types.SceNetAdhocctlScanInfo;
pub const Params = c.types.SceNetAdhocctlParams;
pub const GameModeInfo = c.types.SceNetAdhocctlGameModeInfo;
pub const PeerInfo = c.types.SceNetAdhocctlPeerInfo;
pub const PdpStat = c.types.pdpStatStruct;
pub const PtpStat = c.types.ptpStatStruct;
pub const MatchingCallback = c.types.pspAdhocMatchingCallback;
pub const PoolStat = c.types.pspAdhocPoolStat;
pub const CtlHandler = c.types.sceNetAdhocctlHandler;

// -- sceNetAdhoc lifecycle ---------------------------------------------

pub fn init() Error!void {
    return check(adhoc.sceNetAdhocInit());
}

pub fn term() Error!void {
    return check(adhoc.sceNetAdhocTerm());
}

// -- PDP (connectionless) ---------------------------------------------

pub fn pdp_create(mac: [*]u8, port: u16, bufsize: u32, unk: i32) Error!i32 {
    const ret = adhoc.sceNetAdhocPdpCreate(mac, @as(c_ushort, port), @as(c_uint, bufsize), @as(c_int, unk));
    return checkPositive(ret);
}

pub fn pdp_send(id: i32, dest_mac: [*]u8, port: u16, data: ?*anyopaque, len: u32, timeout: u32, nonblock: bool) Error!void {
    return check(adhoc.sceNetAdhocPdpSend(@as(c_int, id), dest_mac, @as(c_ushort, port), data, @as(c_uint, len), @as(c_uint, timeout), @intFromBool(nonblock)));
}

pub fn pdp_recv(id: i32, src_mac: [*]u8, port: *u16, data: ?*anyopaque, data_length: ?*anyopaque, timeout: u32, nonblock: bool) Error!void {
    return check(adhoc.sceNetAdhocPdpRecv(@as(c_int, id), src_mac, @ptrCast(port), data, data_length, @as(c_uint, timeout), @intFromBool(nonblock)));
}

pub fn pdp_delete(id: i32, unk: i32) Error!void {
    return check(adhoc.sceNetAdhocPdpDelete(@as(c_int, id), @as(c_int, unk)));
}

pub fn get_pdp_stat(size: *i32, stat: [*c]PdpStat) Error!void {
    return check(adhoc.sceNetAdhocGetPdpStat(@ptrCast(size), stat));
}

// -- PTP (connection-oriented) ----------------------------------------

pub fn ptp_open(srcmac: [*]u8, srcport: u16, destmac: [*]u8, destport: u16, bufsize: u32, delay: u32, count: i32, unk: i32) Error!i32 {
    const ret = adhoc.sceNetAdhocPtpOpen(srcmac, @as(c_ushort, srcport), destmac, @as(c_ushort, destport), @as(c_uint, bufsize), @as(c_uint, delay), @as(c_int, count), @as(c_int, unk));
    return checkPositive(ret);
}

pub fn ptp_connect(id: i32, timeout: u32, nonblock: bool) Error!void {
    return check(adhoc.sceNetAdhocPtpConnect(@as(c_int, id), @as(c_uint, timeout), @intFromBool(nonblock)));
}

pub fn ptp_listen(srcmac: [*]u8, srcport: u16, bufsize: u32, delay: u32, count: i32, queue: i32, unk: i32) Error!i32 {
    const ret = adhoc.sceNetAdhocPtpListen(srcmac, @as(c_ushort, srcport), @as(c_uint, bufsize), @as(c_uint, delay), @as(c_int, count), @as(c_int, queue), @as(c_int, unk));
    return checkPositive(ret);
}

pub fn ptp_accept(id: i32, mac: [*]u8, port: *u16, timeout: u32, nonblock: bool) Error!i32 {
    const ret = adhoc.sceNetAdhocPtpAccept(@as(c_int, id), mac, @ptrCast(port), @as(c_uint, timeout), @intFromBool(nonblock));
    return checkPositive(ret);
}

pub fn ptp_send(id: i32, data: ?*anyopaque, datasize: *i32, timeout: u32, nonblock: bool) Error!void {
    return check(adhoc.sceNetAdhocPtpSend(@as(c_int, id), data, @ptrCast(datasize), @as(c_uint, timeout), @intFromBool(nonblock)));
}

pub fn ptp_recv(id: i32, data: ?*anyopaque, datasize: *i32, timeout: u32, nonblock: bool) Error!void {
    return check(adhoc.sceNetAdhocPtpRecv(@as(c_int, id), data, @ptrCast(datasize), @as(c_uint, timeout), @intFromBool(nonblock)));
}

pub fn ptp_flush(id: i32, timeout: u32, nonblock: bool) Error!void {
    return check(adhoc.sceNetAdhocPtpFlush(@as(c_int, id), @as(c_uint, timeout), @intFromBool(nonblock)));
}

pub fn ptp_close(id: i32, unk: i32) Error!void {
    return check(adhoc.sceNetAdhocPtpClose(@as(c_int, id), @as(c_int, unk)));
}

pub fn get_ptp_stat(size: *i32, stat: [*c]PtpStat) Error!void {
    return check(adhoc.sceNetAdhocGetPtpStat(@ptrCast(size), stat));
}

// -- Game mode ---------------------------------------------------------

pub fn game_mode_create_master(data: ?*anyopaque, size: i32) Error!void {
    return check(adhoc.sceNetAdhocGameModeCreateMaster(data, @as(c_int, size)));
}

pub fn game_mode_create_replica(mac: [*]u8, data: ?*anyopaque, size: i32) Error!void {
    return check(adhoc.sceNetAdhocGameModeCreateReplica(mac, data, @as(c_int, size)));
}

pub fn game_mode_update_master() Error!void {
    return check(adhoc.sceNetAdhocGameModeUpdateMaster());
}

pub fn game_mode_update_replica(id: i32, unk: i32) Error!void {
    return check(adhoc.sceNetAdhocGameModeUpdateReplica(@as(c_int, id), @as(c_int, unk)));
}

pub fn game_mode_delete_master() Error!void {
    return check(adhoc.sceNetAdhocGameModeDeleteMaster());
}

pub fn game_mode_delete_replica(id: i32) Error!void {
    return check(adhoc.sceNetAdhocGameModeDeleteReplica(@as(c_int, id)));
}

// Undocumented stubs
pub const poll_socket = adhoc.sceNetAdhocPollSocket;
pub const set_socket_alert = adhoc.sceNetAdhocSetSocketAlert;
pub const get_socket_alert = adhoc.sceNetAdhocGetSocketAlert;

// -- sceNetAdhocctl ---------------------------------------------------

pub fn ctl_init(stacksize: i32, priority: i32, product: *ProductStruct) Error!void {
    return check(ctl.sceNetAdhocctlInit(@as(c_int, stacksize), @as(c_int, priority), product));
}

pub fn ctl_term() Error!void {
    return check(ctl.sceNetAdhocctlTerm());
}

pub fn ctl_connect(name: [*:0]const u8) Error!void {
    return check(ctl.sceNetAdhocctlConnect(name));
}

pub fn ctl_create(name: [*:0]const u8) Error!void {
    return check(ctl.sceNetAdhocctlCreate(name));
}

pub fn ctl_join(scaninfo: *ScanInfo) Error!void {
    return check(ctl.sceNetAdhocctlJoin(scaninfo));
}

pub fn ctl_scan() Error!void {
    return check(ctl.sceNetAdhocctlScan());
}

pub fn ctl_disconnect() Error!void {
    return check(ctl.sceNetAdhocctlDisconnect());
}

pub fn ctl_add_handler(handler: CtlHandler, unknown: ?*anyopaque) Error!i32 {
    const ret = ctl.sceNetAdhocctlAddHandler(handler, unknown);
    return checkPositive(ret);
}

pub fn ctl_del_handler(id: i32) Error!void {
    return check(ctl.sceNetAdhocctlDelHandler(@as(c_int, id)));
}

pub fn ctl_get_state(event: *i32) Error!void {
    return check(ctl.sceNetAdhocctlGetState(@ptrCast(event)));
}

pub fn ctl_get_adhoc_id(product: *ProductStruct) Error!void {
    return check(ctl.sceNetAdhocctlGetAdhocId(product));
}

pub fn ctl_get_peer_list(length: *i32, buf: ?*anyopaque) Error!void {
    return check(ctl.sceNetAdhocctlGetPeerList(@ptrCast(length), buf));
}

pub fn ctl_get_addr_by_name(nickname: [*:0]const u8, length: *i32, buf: ?*anyopaque) Error!void {
    return check(ctl.sceNetAdhocctlGetAddrByName(@ptrCast(@constCast(nickname)), @ptrCast(length), buf));
}

pub fn ctl_get_name_by_addr(mac: [*]u8, nickname: [*]u8) Error!void {
    return check(ctl.sceNetAdhocctlGetNameByAddr(mac, @ptrCast(nickname)));
}

pub fn ctl_get_parameter(params: *Params) Error!void {
    return check(ctl.sceNetAdhocctlGetParameter(params));
}

pub fn ctl_get_scan_info(length: *i32, buf: ?*anyopaque) Error!void {
    return check(ctl.sceNetAdhocctlGetScanInfo(@ptrCast(length), buf));
}

pub fn ctl_create_enter_game_mode(name: [*:0]const u8, unknown: i32, num: i32, macs: [*]u8, timeout: u32, unknown2: i32) Error!void {
    return check(ctl.sceNetAdhocctlCreateEnterGameMode(name, @as(c_int, unknown), @as(c_int, num), macs, @as(c_uint, timeout), @as(c_int, unknown2)));
}

pub fn ctl_join_enter_game_mode(name: [*:0]const u8, hostmac: [*]u8, timeout: u32, unknown: i32) Error!void {
    return check(ctl.sceNetAdhocctlJoinEnterGameMode(name, hostmac, @as(c_uint, timeout), @as(c_int, unknown)));
}

pub fn ctl_exit_game_mode() Error!void {
    return check(ctl.sceNetAdhocctlExitGameMode());
}

pub fn ctl_get_game_mode_info(info: *GameModeInfo) Error!void {
    return check(ctl.sceNetAdhocctlGetGameModeInfo(info));
}

pub fn ctl_get_peer_info(mac: [*]u8, size: i32, peerinfo: *PeerInfo) Error!void {
    return check(ctl.sceNetAdhocctlGetPeerInfo(mac, @as(c_int, size), peerinfo));
}

// -- sceNetAdhocMatching ----------------------------------------------

pub fn matching_init(memsize: i32) Error!void {
    return check(matching.sceNetAdhocMatchingInit(@as(c_int, memsize)));
}

pub fn matching_term() Error!void {
    return check(matching.sceNetAdhocMatchingTerm());
}

pub fn matching_create(mode: i32, maxpeers: i32, port: u16, bufsize: i32, hellodelay: u32, pingdelay: u32, initcount: i32, msgdelay: u32, callback: MatchingCallback) Error!i32 {
    const ret = matching.sceNetAdhocMatchingCreate(@as(c_int, mode), @as(c_int, maxpeers), @as(c_ushort, port), @as(c_int, bufsize), @as(c_uint, hellodelay), @as(c_uint, pingdelay), @as(c_int, initcount), @as(c_uint, msgdelay), callback);
    return checkPositive(ret);
}

pub fn matching_start(id: i32, evthpri: i32, evthstack: i32, inthpri: i32, inthstack: i32, optlen: i32, optdata: ?*anyopaque) Error!void {
    return check(matching.sceNetAdhocMatchingStart(@as(c_int, id), @as(c_int, evthpri), @as(c_int, evthstack), @as(c_int, inthpri), @as(c_int, inthstack), @as(c_int, optlen), optdata));
}

pub fn matching_stop(id: i32) Error!void {
    return check(matching.sceNetAdhocMatchingStop(@as(c_int, id)));
}

pub fn matching_delete(id: i32) Error!void {
    return check(matching.sceNetAdhocMatchingDelete(@as(c_int, id)));
}

pub fn matching_select_target(id: i32, mac: [*]u8, optlen: i32, optdata: ?*anyopaque) Error!void {
    return check(matching.sceNetAdhocMatchingSelectTarget(@as(c_int, id), mac, @as(c_int, optlen), optdata));
}

pub fn matching_cancel_target(id: i32, mac: [*]u8) Error!void {
    return check(matching.sceNetAdhocMatchingCancelTarget(@as(c_int, id), mac));
}

pub fn matching_cancel_target_with_opt(id: i32, mac: [*]u8, optlen: i32, optdata: ?*anyopaque) Error!void {
    return check(matching.sceNetAdhocMatchingCancelTargetWithOpt(@as(c_int, id), mac, @as(c_int, optlen), optdata));
}

pub fn matching_set_hello_opt(id: i32, optlen: i32, optdata: ?*anyopaque) Error!void {
    return check(matching.sceNetAdhocMatchingSetHelloOpt(@as(c_int, id), @as(c_int, optlen), optdata));
}

pub fn matching_get_hello_opt(id: i32, optlen: *i32, optdata: ?*anyopaque) Error!void {
    return check(matching.sceNetAdhocMatchingGetHelloOpt(@as(c_int, id), @ptrCast(optlen), optdata));
}

pub fn matching_get_members(id: i32, length: *i32, buf: ?*anyopaque) Error!void {
    return check(matching.sceNetAdhocMatchingGetMembers(@as(c_int, id), @ptrCast(length), buf));
}

pub fn matching_get_pool_max_alloc() i32 {
    return matching.sceNetAdhocMatchingGetPoolMaxAlloc();
}

pub fn matching_get_pool_stat(poolstat: *PoolStat) Error!void {
    return check(matching.sceNetAdhocMatchingGetPoolStat(poolstat));
}

pub fn matching_send_data(id: i32, mac: [*]u8, datalen: i32, data: ?*anyopaque) Error!void {
    return check(matching.sceNetAdhocMatchingSendData(@as(c_int, id), mac, @as(c_int, datalen), data));
}

pub fn matching_abort_send_data(id: i32, mac: [*]u8) Error!void {
    return check(matching.sceNetAdhocMatchingAbortSendData(@as(c_int, id), mac));
}
