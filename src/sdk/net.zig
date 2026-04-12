// Infrastructure networking -- sockets, AP control, DNS resolver
//
// Wraps:
//   c/module/sceNet.zig
//   c/module/sceNetInet.zig
//   c/module/sceNetApctl.zig
//   c/module/sceNetResolver.zig
//   c/module/sceNet_lib.zig

const c = @import("../c/modules.zig");
const err = @import("errors/net.zig");
const errno = @import("errors/errno.zig");
const check = err.check;
const checkPositive = err.checkPositive;
const Error = err.Error;
pub const ErrnoError = errno.ErrnoError;

const net = c.sceNet;
const inet = c.sceNetInet;
const apctl = c.sceNetApctl;
const resolver = c.sceNetResolver;

// -- Re-exported types -------------------------------------------------

pub const SceNetMallocStat = c.types.SceNetMallocStat;
pub const SceNetApctlInfo = c.types.SceNetApctlInfo;
pub const ApctlHandler = c.types.sceNetApctlHandler;
pub const sockaddr_in = c.types.sockaddr_in;
pub const in_addr = c.types.in_addr;
pub const socklen_t = c.types.socklen_t;
pub const fd_set = c.types.fd_set;
pub const msghdr = c.types.msghdr;
pub const SceNetInetTimeval = c.types.SceNetInetTimeval;

// -- sceNet core -------------------------------------------------------

pub fn init(poolsize: i32, calloutprio: i32, calloutstack: i32, netintrprio: i32, netintrstack: i32) Error!void {
    return check(net.sceNetInit(@as(c_int, poolsize), @as(c_int, calloutprio), @as(c_int, calloutstack), @as(c_int, netintrprio), @as(c_int, netintrstack)));
}

pub fn term() Error!void {
    return check(net.sceNetTerm());
}

pub fn free_threadinfo(thid: i32) Error!void {
    return check(net.sceNetFreeThreadinfo(@as(c_int, thid)));
}

pub fn thread_abort(thid: i32) Error!void {
    return check(net.sceNetThreadAbort(@as(c_int, thid)));
}

pub fn ether_ntostr(mac: [*]u8, name: [*]u8) void {
    net.sceNetEtherNtostr(mac, @ptrCast(name));
}

pub fn ether_strton(name: [*:0]const u8, mac: [*]u8) void {
    net.sceNetEtherStrton(@ptrCast(@constCast(name)), mac);
}

pub fn get_local_ether_addr(mac: [*]u8) Error!void {
    return check(net.sceNetGetLocalEtherAddr(mac));
}

pub fn get_malloc_stat(stat: *SceNetMallocStat) Error!void {
    return check(net.sceNetGetMallocStat(stat));
}

// -- sceNetInet (BSD sockets) -----------------------------------------

pub fn inet_init() Error!void {
    return check(inet.sceNetInetInit());
}

pub fn inet_term() Error!void {
    return check(inet.sceNetInetTerm());
}

pub fn inet_socket(domain: i32, sock_type: i32, protocol: i32) Error!i32 {
    return checkPositive(i32, inet.sceNetInetSocket(@as(c_int, domain), @as(c_int, sock_type), @as(c_int, protocol)));
}

pub fn inet_close(s: i32) Error!void {
    return check(inet.sceNetInetClose(@as(c_int, s)));
}

pub fn inet_connect(s: i32, addr: *const sockaddr_in, addrlen: socklen_t) Error!void {
    return check(inet.sceNetInetConnect(@as(c_int, s), addr, addrlen));
}

pub fn inet_bind(s: i32, addr: *const sockaddr_in, addrlen: socklen_t) Error!void {
    return check(inet.sceNetInetBind(@as(c_int, s), addr, addrlen));
}

pub fn inet_listen(s: i32, backlog: i32) Error!void {
    return check(inet.sceNetInetListen(@as(c_int, s), @as(c_int, backlog)));
}

pub fn inet_accept(s: i32, addr: *sockaddr_in, addrlen: *socklen_t) Error!i32 {
    return checkPositive(i32, inet.sceNetInetAccept(@as(c_int, s), addr, addrlen));
}

pub fn inet_send(s: i32, buf: ?*const anyopaque, len: usize, flags: i32) ErrnoError!usize {
    return errno.checkErrno(usize, inet.sceNetInetSend(@as(c_int, s), buf, len, @as(c_int, flags)));
}

pub fn inet_sendto(s: i32, buf: ?*const anyopaque, len: usize, flags: i32, to: *const sockaddr_in, tolen: socklen_t) ErrnoError!usize {
    return errno.checkErrno(usize, inet.sceNetInetSendto(@as(c_int, s), buf, len, @as(c_int, flags), to, tolen));
}

pub fn inet_sendmsg(s: i32, msg: *const msghdr, flags: i32) ErrnoError!isize {
    return errno.checkErrno(isize, inet.sceNetInetSendmsg(@as(c_int, s), @constCast(msg), @as(c_int, flags)));
}

pub fn inet_recv(s: i32, buf: ?*anyopaque, len: usize, flags: i32) ErrnoError!usize {
    return errno.checkErrno(usize, inet.sceNetInetRecv(@as(c_int, s), buf, len, @as(c_int, flags)));
}

pub fn inet_recvfrom(s: i32, buf: ?*anyopaque, len: usize, flags: i32, from: *sockaddr_in, fromlen: *socklen_t) ErrnoError!usize {
    return errno.checkErrno(usize, inet.sceNetInetRecvfrom(@as(c_int, s), buf, len, @as(c_int, flags), from, fromlen));
}

pub fn inet_recvmsg(s: i32, msg: *msghdr, flags: i32) ErrnoError!isize {
    return errno.checkErrno(isize, inet.sceNetInetRecvmsg(@as(c_int, s), msg, @as(c_int, flags)));
}

pub fn inet_select(n: i32, readfds: [*c]fd_set, writefds: [*c]fd_set, exceptfds: [*c]fd_set, timeout: [*c]SceNetInetTimeval) Error!i32 {
    const ret = inet.sceNetInetSelect(@as(c_int, n), readfds, writefds, exceptfds, timeout);
    return checkPositive(i32, ret);
}

pub fn inet_shutdown(s: i32, how: i32) Error!void {
    return check(inet.sceNetInetShutdown(@as(c_int, s), @as(c_int, how)));
}

pub fn inet_getsockopt(s: i32, level: i32, optname: i32, optval: ?*anyopaque, optlen: *socklen_t) Error!void {
    return check(inet.sceNetInetGetsockopt(@as(c_int, s), @as(c_int, level), @as(c_int, optname), optval, optlen));
}

pub fn inet_setsockopt(s: i32, level: i32, optname: i32, optval: ?*const anyopaque, optlen: socklen_t) Error!void {
    return check(inet.sceNetInetSetsockopt(@as(c_int, s), @as(c_int, level), @as(c_int, optname), optval, optlen));
}

pub fn inet_getpeername(s: i32, name: *sockaddr_in, namelen: *socklen_t) Error!void {
    return check(inet.sceNetInetGetpeername(@as(c_int, s), name, namelen));
}

pub fn inet_getsockname(s: i32, name: *sockaddr_in, namelen: *socklen_t) Error!void {
    return check(inet.sceNetInetGetsockname(@as(c_int, s), name, namelen));
}

// Undocumented inet stubs
pub const inet_poll = inet.sceNetInetPoll;
pub const inet_socket_abort = inet.sceNetInetSocketAbort;
pub const inet_get_tcpcb_stat = inet.sceNetInetGetTcpcbstat;
pub const inet_get_udpcb_stat = inet.sceNetInetGetUdpcbstat;
pub const inet_addr = inet.sceNetInetInetAddr;
pub const inet_aton = inet.sceNetInetInetAton;
pub const inet_ntop = inet.sceNetInetInetNtop;
pub const inet_pton = inet.sceNetInetInetPton;

// -- sceNetApctl (access point control) -------------------------------

pub fn apctl_init(stack_size: i32, init_priority: i32) Error!void {
    return check(apctl.sceNetApctlInit(@as(c_int, stack_size), @as(c_int, init_priority)));
}

pub fn apctl_term() Error!void {
    return check(apctl.sceNetApctlTerm());
}

pub fn apctl_get_info(code: i32, info: *SceNetApctlInfo) Error!void {
    return check(apctl.sceNetApctlGetInfo(@as(c_int, code), info));
}

pub fn apctl_add_handler(handler: ApctlHandler, arg: ?*anyopaque) Error!i32 {
    const ret = apctl.sceNetApctlAddHandler(handler, arg);
    return checkPositive(i32, ret);
}

pub fn apctl_del_handler(handler_id: i32) Error!void {
    return check(apctl.sceNetApctlDelHandler(@as(c_int, handler_id)));
}

pub fn apctl_connect(conn_index: i32) Error!void {
    return check(apctl.sceNetApctlConnect(@as(c_int, conn_index)));
}

pub fn apctl_disconnect() Error!void {
    return check(apctl.sceNetApctlDisconnect());
}

pub fn apctl_get_state(state: *i32) Error!void {
    return check(apctl.sceNetApctlGetState(@ptrCast(state)));
}

// -- sceNetResolver (DNS) ---------------------------------------------

pub fn resolver_init() Error!void {
    return check(resolver.sceNetResolverInit());
}

pub fn resolver_term() Error!void {
    return check(resolver.sceNetResolverTerm());
}

pub fn resolver_create(rid: *i32, buf: ?*anyopaque, buflen: usize) Error!void {
    return check(resolver.sceNetResolverCreate(@ptrCast(rid), buf, buflen));
}

pub fn resolver_delete(rid: i32) Error!void {
    return check(resolver.sceNetResolverDelete(@as(c_int, rid)));
}

pub fn resolver_start_ntoa(rid: i32, hostname: [*:0]const u8, addr: *in_addr, timeout: u32, retry: i32) Error!void {
    return check(resolver.sceNetResolverStartNtoA(@as(c_int, rid), @ptrCast(hostname), addr, @as(c_uint, timeout), @as(c_int, retry)));
}

pub fn resolver_start_aton(rid: i32, addr: *const in_addr, hostname: [*]u8, hostname_len: usize, timeout: u32, retry: i32) Error!void {
    return check(resolver.sceNetResolverStartAtoN(@as(c_int, rid), addr, @ptrCast(hostname), hostname_len, @as(c_uint, timeout), @as(c_int, retry)));
}

pub fn resolver_stop(rid: i32) Error!void {
    return check(resolver.sceNetResolverStop(@as(c_int, rid)));
}
