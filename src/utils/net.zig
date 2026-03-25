const std = @import("std");

const net = @import("../sdk/net.zig");
const utility = @import("../sdk/utility.zig");
const kernel = @import("../sdk/kernel.zig");

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

    utility.load_net_module(.common) catch
        return error.LoadCommonModule;

    utility.load_net_module(.inet) catch
        return error.LoadInetModule;

    net.init(128 * 1024, 42, 4 * 1024, 42, 4 * 1024) catch
        return error.NetInit;

    net.inet_init() catch
        return error.InetInit;

    net.apctl_init(0x8000, 48) catch
        return error.ApctlInit;

    net.resolver_init() catch
        return error.ResolverInit;

    net_initialized = true;
}

/// Connect to a saved WiFi network by connection index (1-based).
/// Blocks until connected or timeout. `timeout_us` is microseconds (0 = wait forever).
pub fn connectToApctl(conn_index: i32, timeout_us: u32) ConnectError!void {
    net.apctl_connect(conn_index) catch
        return error.ApctlConnect;

    var elapsed: u32 = 0;
    const poll_interval: u32 = 50_000; // 50ms

    while (true) {
        var state: i32 = 0;
        net.apctl_get_state(&state) catch
            return error.ApctlGetState;

        if (state == PSP_NET_APCTL_STATE_GOT_IP)
            return;

        kernel.delay_thread(poll_interval) catch {};
        elapsed += poll_interval;

        if (timeout_us > 0 and elapsed >= timeout_us)
            return error.Timeout;
    }
}

/// Get the local IP address as a string (e.g. "192.168.1.100").
/// Returns the number of bytes written.
pub fn getLocalIp(buf: *[16]u8) ?[]const u8 {
    var info: net.SceNetApctlInfo = undefined;
    net.apctl_get_info(PSP_NET_APCTL_INFO_IP, &info) catch return null;
    const ip_bytes: []const u8 = &info.ip;
    // Find null terminator
    var len: usize = 0;
    while (len < 16 and ip_bytes[len] != 0) : (len += 1) {}
    @memcpy(buf[0..len], ip_bytes[0..len]);
    return buf[0..len];
}

/// Disconnect from the access point.
pub fn disconnect() void {
    net.apctl_disconnect() catch {};
}

/// Shut down the entire networking stack.
pub fn deinit() void {
    if (!net_initialized) return;
    net.resolver_term() catch {};
    net.apctl_term() catch {};
    net.inet_term() catch {};
    net.term() catch {};
    utility.unload_net_module(.inet) catch {};
    utility.unload_net_module(.common) catch {};
    net_initialized = false;
}
