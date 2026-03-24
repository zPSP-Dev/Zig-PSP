// PSP HTTPS client example using std.http.Client through the std.Io vtable.
//
// Initializes WiFi, loads an embedded root CA certificate into the TLS
// certificate bundle, then uses the standard library HTTP client to make
// a HEAD request to https://example.com and prints the response status.
//
// PSP has no system CA store, so root certificates must be embedded in the
// binary via @embedFile and manually loaded into the http.Client's CA bundle.
//
// Prerequisites: a WiFi network must be saved in PSP network settings (slot 1).
//
// Expected output:
//
//   [1] Network initialized, IP: 192.168.x.x
//   [2] CA bundle loaded (1 cert)
//   [3] Sending HEAD https://example.com/ ...
//   [4] Sent
//   [5] received 200 OK
//   Done!
const std = @import("std");
const sdk = @import("pspsdk");

pub const panic = sdk.extra.debug.panic;
pub const psp_stack_size: u32 = 512 * 1024; // TLS crypto needs extra stack

pub const std_options: std.Options = .{};
pub const std_options_debug_threaded_io: ?*std.Io.Threaded = null;
pub const std_options_debug_io: std.Io = sdk.extra.Io.psp_io;

pub fn std_options_cwd() std.Io.Dir {
    return .{ .handle = -1 };
}

comptime {
    asm (sdk.extra.module.module_info("SDK HTTPS", .{ .mode = .User }, 1, 0));
}

// AAA Certificate Services root CA (Comodo CA Limited).
// Signs the SSL.com cross-signed intermediate used by Cloudflare (example.com).
// Expires: 2028-12-31.
const root_ca_der = @embedFile("aaa_root_ca.der");

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    sdk.extra.utils.enableHBCB();
    sdk.extra.debug.screenInit();

    // Initialize networking
    sdk.extra.net.init() catch |err| {
        std.debug.print("Net init failed: {s}\n", .{@errorName(err)});
        return;
    };
    defer sdk.extra.net.deinit();

    sdk.extra.net.connectToApctl(1, 30_000_000) catch |err| {
        std.debug.print("WiFi failed: {s}\n", .{@errorName(err)});
        return;
    };

    var ip_buf: [16]u8 = undefined;
    const ip = sdk.extra.net.getLocalIp(&ip_buf) orelse "unknown";
    std.debug.print("[1] Network initialized, IP: {s}\n", .{ip});

    // Use std.http.Client
    var arena = std.heap.ArenaAllocator.init(sdk.extra.allocator.psp_page_allocator);
    defer arena.deinit();
    const gpa = arena.allocator();

    var http_client: std.http.Client = .{ .allocator = gpa, .io = io };
    defer http_client.deinit();

    // PSP has no system CA store -- rescan() is a no-op. We must manually
    // load root CA certificates into the bundle and set `now` so the
    // http.Client skips its (empty) rescan and uses our pre-loaded bundle.
    const now = std.Io.Clock.real.now(io);
    const now_sec = now.toSeconds();

    try http_client.ca_bundle.bytes.appendSlice(gpa, root_ca_der);
    try http_client.ca_bundle.parseCert(gpa, 0, now_sec);
    http_client.now = now;

    std.debug.print("[2] CA bundle loaded ({d} certs)\n", .{http_client.ca_bundle.map.count()});

    std.debug.print("[3] Sending HEAD https://example.com/ ...\n", .{});

    var request = try http_client.request(.HEAD, .{
        .scheme = "https",
        .host = .{ .percent_encoded = "example.com" },
        .port = 443,
        .path = .{ .percent_encoded = "/" },
    }, .{});
    defer request.deinit();

    try request.sendBodiless();
    std.debug.print("[4] Sent\n", .{});

    var redirect_buffer: [1024]u8 = undefined;
    const response = try request.receiveHead(&redirect_buffer);
    std.debug.print("[5] received {d} {s}\n", .{ response.head.status, response.head.reason });

    std.debug.print("Done!\n", .{});
}
