// PSP networking example using sdk.extra.net and the std.Io vtable.
//
// Initializes the PSP WiFi stack, connects to the first saved access point,
// resolves a hostname via DNS, opens a TCP connection, sends an HTTP request,
// and prints the response headers.
//
// Prerequisites: a WiFi network must be saved in PSP network settings (slot 1).
//
// Expected output (varies by network):
//
//   [1] Network modules loaded
//   [2] Connected to WiFi
//   [3] Local IP: 192.168.x.x
//   [4] Resolved example.com
//   [5] Connected to server
//   [6] Sent HTTP request
//   [7] Response (first 512 bytes):
//   HTTP/1.1 200 OK
//   ...
//   [8] Connection closed
//   Done!
const std = @import("std");
const sdk = @import("pspsdk");

pub const panic = sdk.extra.debug.panic;

pub const std_options_debug_threaded_io: ?*std.Io.Threaded = null;
pub const std_options_debug_io: std.Io = sdk.extra.Io.psp_io;

pub fn std_options_cwd() std.Io.Dir {
    return .{ .handle = -1 };
}

comptime {
    asm (sdk.extra.module.module_info("SDK Network", .{ .mode = .User }, 1, 0));
}

pub fn main(_: std.process.Init) !void {
    sdk.extra.utils.enableHBCB();
    sdk.extra.debug.screenInit();

    // [1] Initialize networking
    sdk.extra.net.init() catch |err| {
        std.debug.print("Net init failed: {s}\n", .{@errorName(err)});
        return;
    };
    defer sdk.extra.net.deinit();
    std.debug.print("[1] Network modules loaded\n", .{});

    // [2] Connect to first saved WiFi network (30 second timeout)
    sdk.extra.net.connectToApctl(1, 30_000_000) catch |err| {
        std.debug.print("WiFi connect failed: {s}\n", .{@errorName(err)});
        return;
    };
    std.debug.print("[2] Connected to WiFi\n", .{});

    // [3] Show local IP
    var ip_buf: [16]u8 = undefined;
    if (sdk.extra.net.getLocalIp(&ip_buf)) |ip| {
        std.debug.print("[3] Local IP: {s}\n", .{ip});
    } else {
        std.debug.print("[3] Could not get local IP\n", .{});
    }

    // [4] DNS lookup for example.com using the resolver
    const inet = sdk.c.sceNetInet;
    const resolver = sdk.c.sceNetResolver;
    const c_types = sdk.c.types;

    var rid: c_int = 0;
    var resolver_buf: [1024]u8 = undefined;
    if (resolver.sceNetResolverCreate(&rid, &resolver_buf, resolver_buf.len) < 0) {
        std.debug.print("Resolver create failed\n", .{});
        return;
    }
    defer _ = resolver.sceNetResolverDelete(rid);

    var resolved_addr: c_types.in_addr = undefined;
    if (resolver.sceNetResolverStartNtoA(rid, @ptrCast("example.com"), &resolved_addr, 5, 3) < 0) {
        std.debug.print("DNS resolve failed\n", .{});
        return;
    }
    std.debug.print("[4] Resolved example.com\n", .{});

    // [5] Connect via TCP
    var sa: c_types.sockaddr_in = .{
        .sin_port = @byteSwap(@as(u16, 80)),
        .sin_addr = resolved_addr,
    };
    const sock = inet.sceNetInetSocket(sdk.extra.net.AF_INET, sdk.extra.net.SOCK_STREAM, 0);
    if (sock < 0) {
        std.debug.print("Socket create failed\n", .{});
        return;
    }
    defer _ = inet.sceNetInetClose(sock);

    if (inet.sceNetInetConnect(sock, &sa, @sizeOf(c_types.sockaddr_in)) < 0) {
        std.debug.print("Connect failed\n", .{});
        return;
    }
    std.debug.print("[5] Connected to server\n", .{});

    // [6] Send HTTP GET request
    const request = "GET / HTTP/1.0\r\nHost: example.com\r\nConnection: close\r\n\r\n";
    const sent = inet.sceNetInetSend(sock, request.ptr, request.len, 0);
    if (sent < 0) {
        std.debug.print("Send failed\n", .{});
        return;
    }
    std.debug.print("[6] Sent HTTP request\n", .{});

    // [7] Read and display response
    var buf: [512]u8 = undefined;
    const received = inet.sceNetInetRecv(sock, &buf, buf.len - 1, 0);
    if (received > 0) {
        const n: usize = @intCast(received);
        buf[n] = 0;
        std.debug.print("[7] Response (first {} bytes):\n{s}\n", .{ n, buf[0..n] });
    } else {
        std.debug.print("[7] No response received\n", .{});
    }

    std.debug.print("[8] Connection closed\nDone!\n", .{});
}
