// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

pub extern fn sceNetInetInit() callconv(.c) c_int;

pub extern fn sceNetInetTerm() callconv(.c) c_int;

pub extern fn sceNetInetAccept() callconv(.c) void;

pub extern fn sceNetInetBind() callconv(.c) void;

pub extern fn sceNetInetClose(s: c_int) callconv(.c) c_int;

pub extern fn sceNetInetCloseWithRST() callconv(.c) void;

pub extern fn sceNetInetConnect() callconv(.c) void;

pub extern fn sceNetInetGetpeername() callconv(.c) void;

pub extern fn sceNetInetGetsockname() callconv(.c) void;

pub extern fn sceNetInetGetsockopt() callconv(.c) void;

pub extern fn sceNetInetListen() callconv(.c) void;

pub extern fn sceNetInetPoll() callconv(.c) void;

pub extern fn sceNetInetRecv() callconv(.c) void;

pub extern fn sceNetInetRecvfrom() callconv(.c) void;

pub extern fn sceNetInetRecvmsg(s: c_int, msg: [*c]c_int, flags: c_int) callconv(.c) isize;

pub extern fn sceNetInetSelect(n: c_int, readfds: [*c]c_int, writefds: [*c]c_int, exceptfds: [*c]c_int, timeout: [*c]types.SceNetInetTimeval) callconv(.c) c_int;

pub extern fn sceNetInetSend() callconv(.c) void;

pub extern fn sceNetInetSendto() callconv(.c) void;

pub extern fn sceNetInetSendmsg(s: c_int, msg: [*c]const c_int, flags: c_int) callconv(.c) isize;

pub extern fn sceNetInetSetsockopt() callconv(.c) void;

pub extern fn sceNetInetShutdown() callconv(.c) void;

pub extern fn sceNetInetSocket() callconv(.c) void;

pub extern fn sceNetInetSocketAbort() callconv(.c) void;

pub extern fn sceNetInetGetErrno() callconv(.c) c_int;

pub extern fn sceNetInetGetTcpcbstat() callconv(.c) void;

pub extern fn sceNetInetGetUdpcbstat() callconv(.c) void;

pub extern fn sceNetInetInetAddr() callconv(.c) void;

pub extern fn sceNetInetInetAton() callconv(.c) void;

pub extern fn sceNetInetInetNtop() callconv(.c) void;

pub extern fn sceNetInetInetPton() callconv(.c) void;

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
