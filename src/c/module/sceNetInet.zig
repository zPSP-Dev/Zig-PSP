// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

pub extern fn sceNetInetInit() callconv(.c) c_int;

pub extern fn sceNetInetTerm() callconv(.c) c_int;

pub extern fn sceNetInetAccept(s: c_int, addr: [*c]types.sockaddr_in, addrlen: [*c]types.socklen_t) callconv(.c) c_int;

pub extern fn sceNetInetBind(s: c_int, addr: [*c]const types.sockaddr_in, addrlen: types.socklen_t) callconv(.c) c_int;

pub extern fn sceNetInetClose(s: c_int) callconv(.c) c_int;

pub extern fn sceNetInetCloseWithRST(s: c_int) callconv(.c) c_int;

pub extern fn sceNetInetConnect(s: c_int, addr: [*c]const types.sockaddr_in, addrlen: types.socklen_t) callconv(.c) c_int;

pub extern fn sceNetInetGetpeername(s: c_int, addr: [*c]types.sockaddr_in, addrlen: [*c]types.socklen_t) callconv(.c) c_int;

pub extern fn sceNetInetGetsockname(s: c_int, addr: [*c]types.sockaddr_in, addrlen: [*c]types.socklen_t) callconv(.c) c_int;

pub extern fn sceNetInetGetsockopt(s: c_int, level: c_int, optname: c_int, optval: ?*anyopaque, optlen: [*c]types.socklen_t) callconv(.c) c_int;

pub extern fn sceNetInetListen(s: c_int, backlog: c_int) callconv(.c) c_int;

pub extern fn sceNetInetPoll(fds: ?*anyopaque, nfds: c_uint, timeout: c_int) callconv(.c) c_int;

pub extern fn sceNetInetRecv(s: c_int, buf: ?*anyopaque, len: usize, flags: c_int) callconv(.c) isize;

pub extern fn sceNetInetRecvfrom(s: c_int, buf: ?*anyopaque, len: usize, flags: c_int, from: [*c]types.sockaddr_in, fromlen: [*c]types.socklen_t) callconv(.c) isize;

pub extern fn sceNetInetRecvmsg(s: c_int, msg: [*c]types.msghdr, flags: c_int) callconv(.c) isize;

pub extern fn sceNetInetSelect(n: c_int, readfds: [*c]types.fd_set, writefds: [*c]types.fd_set, exceptfds: [*c]types.fd_set, timeout: [*c]types.SceNetInetTimeval) callconv(.c) c_int;

pub extern fn sceNetInetSend(s: c_int, buf: ?*const anyopaque, len: usize, flags: c_int) callconv(.c) isize;

pub extern fn sceNetInetSendto(s: c_int, buf: ?*const anyopaque, len: usize, flags: c_int, to: [*c]const types.sockaddr_in, tolen: types.socklen_t) callconv(.c) isize;

pub extern fn sceNetInetSendmsg(s: c_int, msg: [*c]const types.msghdr, flags: c_int) callconv(.c) isize;

pub extern fn sceNetInetSetsockopt(s: c_int, level: c_int, optname: c_int, optval: ?*const anyopaque, optlen: types.socklen_t) callconv(.c) c_int;

pub extern fn sceNetInetShutdown(s: c_int, how: c_int) callconv(.c) c_int;

pub extern fn sceNetInetSocket(domain: c_int, @"type": c_int, protocol: c_int) callconv(.c) c_int;

pub extern fn sceNetInetSocketAbort(s: c_int) callconv(.c) c_int;

pub extern fn sceNetInetGetErrno() callconv(.c) c_int;

pub extern fn sceNetInetGetTcpcbstat() callconv(.c) void;

pub extern fn sceNetInetGetUdpcbstat() callconv(.c) void;

pub extern fn sceNetInetInetAddr(cp: [*c]const u8) callconv(.c) u32;

pub extern fn sceNetInetInetAton(cp: [*c]const u8, addr: [*c]types.in_addr) callconv(.c) c_int;

pub extern fn sceNetInetInetNtop(af: c_int, src: ?*const anyopaque, dst: [*c]u8, size: types.socklen_t) callconv(.c) [*c]const u8;

pub extern fn sceNetInetInetPton(af: c_int, src: [*c]const u8, dst: ?*anyopaque) callconv(.c) c_int;

comptime {
    asm (macro.import_module_start("sceNetInet", "0x00090000", "30"));
    asm (macro.import_function("sceNetInet", "0x17943399", "sceNetInetInit"));
    asm (macro.import_function("sceNetInet", "0xA9ED66B9", "sceNetInetTerm"));
    asm (macro.import_function("sceNetInet", "0xDB094E1B", "sceNetInetAccept"));
    asm (macro.import_function("sceNetInet", "0x1A33F9AE", "sceNetInetBind"));
    asm (macro.import_function("sceNetInet", "0x8D7284EA", "sceNetInetClose"));
    asm (macro.import_function("sceNetInet", "0x805502DD", "sceNetInetCloseWithRST"));
    asm (macro.import_function("sceNetInet", "0x410B34AA", "sceNetInetConnect"));
    asm (macro.import_function("sceNetInet", "0xE247B6D6", "sceNetInetGetpeername"));
    asm (macro.import_function("sceNetInet", "0x162E6FD5", "sceNetInetGetsockname"));
    asm (macro.import_function("sceNetInet", "0x4A114C7C", "sceNetInetGetsockopt"));
    asm (macro.import_function("sceNetInet", "0xD10A1A7A", "sceNetInetListen"));
    asm (macro.import_function("sceNetInet", "0xFAABB1DD", "sceNetInetPoll"));
    asm (macro.import_function("sceNetInet", "0xCDA85C99", "sceNetInetRecv"));
    asm (macro.import_function("sceNetInet", "0xC91142E4", "sceNetInetRecvfrom"));
    asm (macro.import_function("sceNetInet", "0xEECE61D2", "sceNetInetRecvmsg"));
    asm (macro.import_function("sceNetInet", "0x5BE8D595", "sceNetInetSelect_stub"));
    asm (macro.generic_abi_wrapper("sceNetInetSelect", 5));
    asm (macro.import_function("sceNetInet", "0x7AA671BC", "sceNetInetSend"));
    asm (macro.import_function("sceNetInet", "0x05038FC7", "sceNetInetSendto"));
    asm (macro.import_function("sceNetInet", "0x774E36F4", "sceNetInetSendmsg"));
    asm (macro.import_function("sceNetInet", "0x2FE71FE7", "sceNetInetSetsockopt"));
    asm (macro.import_function("sceNetInet", "0x4CFE4E56", "sceNetInetShutdown"));
    asm (macro.import_function("sceNetInet", "0x8B7B220F", "sceNetInetSocket"));
    asm (macro.import_function("sceNetInet", "0x80A21ABD", "sceNetInetSocketAbort"));
    asm (macro.import_function("sceNetInet", "0xFBABE411", "sceNetInetGetErrno"));
    asm (macro.import_function("sceNetInet", "0xB3888AD4", "sceNetInetGetTcpcbstat"));
    asm (macro.import_function("sceNetInet", "0x39B0C7D3", "sceNetInetGetUdpcbstat"));
    asm (macro.import_function("sceNetInet", "0xB75D5B0A", "sceNetInetInetAddr"));
    asm (macro.import_function("sceNetInet", "0x1BDF5D13", "sceNetInetInetAton"));
    asm (macro.import_function("sceNetInet", "0xD0792666", "sceNetInetInetNtop"));
    asm (macro.import_function("sceNetInet", "0xE30B8C19", "sceNetInetInetPton"));
}
