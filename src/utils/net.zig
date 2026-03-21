const std = @import("std");

const sceNet = @import("../c/module/sceNet.zig");
const sceNetInet = @import("../c/module/sceNetInet.zig");
const sceNetApctl = @import("../c/module/sceNetApctl.zig");
const sceNetResolver = @import("../c/module/sceNetResolver.zig");
const sceUtility = @import("../c/module/sceUtility.zig");
const threadman = @import("../c/module/ThreadManForUser.zig");

pub const PSP_NET_MODULE_COMMON = 1;
pub const PSP_NET_MODULE_ADHOC = 2;
pub const PSP_NET_MODULE_INET = 3;

pub const PSP_NET_APCTL_STATE_DISCONNECTED = 0;
pub const PSP_NET_APCTL_STATE_SCANNING = 1;
pub const PSP_NET_APCTL_STATE_JOINING = 2;
pub const PSP_NET_APCTL_STATE_GETTING_IP = 3;
pub const PSP_NET_APCTL_STATE_GOT_IP = 4;

pub const PSP_NET_APCTL_INFO_IP = 8;

// AF_INET for PSP
pub const AF_INET = 2;
pub const SOCK_STREAM = 1;
pub const SOCK_DGRAM = 2;
pub const IPPROTO_TCP = 6;
pub const IPPROTO_UDP = 17;

// Shutdown flags
pub const SHUT_RD = 0;
pub const SHUT_WR = 1;
pub const SHUT_RDWR = 2;

// Socket options
pub const SOL_SOCKET = 0xFFFF;
pub const SO_REUSEADDR = 0x0004;
pub const SO_NBIO = 0x1009;

pub const InitError = error{
    LoadCommonModule,
    LoadInetModule,
    NetInit,
    InetInit,
    ApctlInit,
    ResolverInit,
};

pub const ConnectError = error{
    ApctlConnect,
    ApctlGetState,
    Timeout,
};

var net_initialized = false;

/// Initialize the PSP networking stack.
/// Loads kernel modules, initializes sceNet, sceNetInet, sceNetApctl, and sceNetResolver.
pub fn init() InitError!void {
    if (net_initialized) return;

    if (sceUtility.sceUtilityLoadNetModule(PSP_NET_MODULE_COMMON) < 0)
        return error.LoadCommonModule;

    if (sceUtility.sceUtilityLoadNetModule(PSP_NET_MODULE_INET) < 0)
        return error.LoadInetModule;

    if (sceNet.sceNetInit(128 * 1024, 42, 4 * 1024, 42, 4 * 1024) < 0)
        return error.NetInit;

    if (sceNetInet.sceNetInetInit() < 0)
        return error.InetInit;

    if (sceNetApctl.sceNetApctlInit(0x8000, 48) < 0)
        return error.ApctlInit;

    if (sceNetResolver.sceNetResolverInit() < 0)
        return error.ResolverInit;

    net_initialized = true;
}

/// Connect to a saved WiFi network by connection index (1-based).
/// Blocks until connected or timeout. `timeout_us` is microseconds (0 = wait forever).
pub fn connectToApctl(conn_index: c_int, timeout_us: u32) ConnectError!void {
    if (sceNetApctl.sceNetApctlConnect(conn_index) < 0)
        return error.ApctlConnect;

    var elapsed: u32 = 0;
    const poll_interval: u32 = 50_000; // 50ms

    while (true) {
        var state: c_int = 0;
        if (sceNetApctl.sceNetApctlGetState(&state) < 0)
            return error.ApctlGetState;

        if (state == PSP_NET_APCTL_STATE_GOT_IP)
            return;

        _ = threadman.sceKernelDelayThread(poll_interval);
        elapsed += poll_interval;

        if (timeout_us > 0 and elapsed >= timeout_us)
            return error.Timeout;
    }
}

/// Get the local IP address as a string (e.g. "192.168.1.100").
/// Returns the number of bytes written.
pub fn getLocalIp(buf: *[16]u8) ?[]const u8 {
    var info: @import("../c/types.zig").SceNetApctlInfo = undefined;
    if (sceNetApctl.sceNetApctlGetInfo(PSP_NET_APCTL_INFO_IP, &info) < 0)
        return null;
    const ip_bytes: []const u8 = &info.ip;
    // Find null terminator
    var len: usize = 0;
    while (len < 16 and ip_bytes[len] != 0) : (len += 1) {}
    @memcpy(buf[0..len], ip_bytes[0..len]);
    return buf[0..len];
}

/// Disconnect from the access point.
pub fn disconnect() void {
    _ = sceNetApctl.sceNetApctlDisconnect();
}

/// Shut down the entire networking stack.
pub fn deinit() void {
    if (!net_initialized) return;
    _ = sceNetResolver.sceNetResolverTerm();
    _ = sceNetApctl.sceNetApctlTerm();
    _ = sceNetInet.sceNetInetTerm();
    _ = sceNet.sceNetTerm();
    _ = sceUtility.sceUtilityUnloadNetModule(PSP_NET_MODULE_INET);
    _ = sceUtility.sceUtilityUnloadNetModule(PSP_NET_MODULE_COMMON);
    net_initialized = false;
}
