// PSP HTTP client example using std.http.Client through the std.Io vtable.
//
// Initializes WiFi, then uses the standard library HTTP client to make
// a HEAD request to http://example.com and prints the response status.
//
// Prerequisites: a WiFi network must be saved in PSP network settings (slot 1).
//
// Expected output:
//
//   [1] Network initialized, IP: 192.168.x.x
//   [2] Sending HEAD http://example.com/ ...
//   [3] Sent
//   [4] received 200 OK
//   Done!
const std = @import("std");
const sdk = @import("pspsdk");

pub const panic = sdk.extra.debug.panic;

pub const std_options: std.Options = .{ .http_disable_tls = true };
pub const std_options_debug_threaded_io: ?*std.Io.Threaded = null;
pub const std_options_debug_io: std.Io = sdk.extra.Io.psp_io;

pub fn std_options_cwd() std.Io.Dir {
    return .{ .handle = -1 };
}

comptime {
    asm (sdk.extra.module.module_info("SDK HTTP", .{ .mode = .User }, 1, 0));
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    sdk.extra.utils.enableHBCB();
    sdk.extra.debug.screenInit();

    // Initialize networking
    sdk.extra.net.init() catch |err| {
        sdk.extra.debug.print("Net init failed: {s}\n", .{@errorName(err)});
        return;
    };
    defer sdk.extra.net.deinit();

    sdk.extra.net.connectToApctl(1, 30_000_000) catch |err| {
        sdk.extra.debug.print("WiFi failed: {s}\n", .{@errorName(err)});
        return;
    };

    var ip_buf: [16]u8 = undefined;
    const ip = sdk.extra.net.getLocalIp(&ip_buf) orelse "unknown";
    sdk.extra.debug.print("[1] Network initialized, IP: {s}\n", .{ip});

    // Use std.http.Client
    var arena = std.heap.ArenaAllocator.init(sdk.extra.allocator.psp_page_allocator);
    defer arena.deinit();
    const gpa = arena.allocator();

    var http_client: std.http.Client = .{ .allocator = gpa, .io = io };
    defer http_client.deinit();

    sdk.extra.debug.print("[2] Sending HEAD http://example.com/ ...\n", .{});

    var request = try http_client.request(.HEAD, .{
        .scheme = "http",
        .host = .{ .percent_encoded = "example.com" },
        .port = 80,
        .path = .{ .percent_encoded = "/" },
    }, .{});
    defer request.deinit();

    try request.sendBodiless();
    sdk.extra.debug.print("[3] Sent\n", .{});

    var redirect_buffer: [1024]u8 = undefined;
    const response = try request.receiveHead(&redirect_buffer);
    sdk.extra.debug.print("[4] received {d} {s}\n", .{ response.head.status, response.head.reason });

    sdk.extra.debug.print("Done!\n", .{});
}
