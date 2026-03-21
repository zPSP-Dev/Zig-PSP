<h1 align="center">Zig-PSP</h1>
<p align="center">A project to bring Zig to the Sony PlayStation Portable</p>

## Why Zig on the PSP?

In the PSP programming community, many libraries, tools, and other features are written in C or C++, which as we know has its problems with writing clean, reusable, and high quality code. Given that the core objectives of Zig as a language are to allow us to create well-designed and reusable software, Zig seems like a perfect fit for integrating older PSP libraries while striving to develop higher quality software!

## Special Thanks

Special thanks is given to the [Rust-PSP team](https://github.com/overdrivenpotato/rust-psp) whose efforts influenced and helped to get this project off the ground. No harm is intended, and it's thanks to you Rustaceans that fellow Ziguanas can program for the PSP.

## Requirements

- **Zig 0.16.0-dev** nightly (see `build.zig.zon` for the exact fingerprint)

No legacy PSPSDK or external C toolchain is required. All build tools (`zPRXGen`, `zSFOTool`, `zPBPTool`) are written in Zig and built automatically.

## Usage

Add Zig-PSP to your project and import `pspsdk` in your source. Every PSP application needs a `module_info` comptime call, the panic handler import, and the homebrew callback setup:

```zig
const std = @import("std");
const sdk = @import("pspsdk");

// Required: without this, the default panic handler pulls in std.Io.Threaded
// which references posix symbols that don't exist on PSP.
pub const panic = sdk.extra.debug.panic;

comptime {
    asm (sdk.extra.module.module_info("My App Name", .{ .mode = .User }, 1, 0));
}

pub fn main(_: std.process.Init) !void {
    sdk.extra.utils.enableHBCB();
    sdk.extra.debug.screenInit();

    sdk.extra.debug.print("Hello from Zig!");
}
```

### API Tiers

The SDK exposes PSP functions through three tiers — pick whichever fits your style:

| Tier | Example | Description |
|---|---|---|
| Raw C stub | `sdk.c.LoadExecForUser.sceKernelExitGame()` | Auto-generated bindings, one namespace per firmware module |
| Top-level sce-prefix | `sdk.sceKernelExitGame()` | Direct re-exports at the package root |
| Snake_case sub-namespace | `sdk.kernel.exit_game()` | Idiomatic Zig names grouped by subsystem |

Sub-namespaces include: `sdk.gu`, `sdk.gum`, `sdk.ge`, `sdk.ctrl`, `sdk.display`, `sdk.kernel`, `sdk.audio`, `sdk.atrac3`, `sdk.rtc`, `sdk.power`, `sdk.umd`, `sdk.io`, `sdk.hprm`, `sdk.wlan`, `sdk.utility`.

The utility layer lives under `sdk.extra`: `sdk.extra.debug`, `sdk.extra.module`, `sdk.extra.utils`, `sdk.extra.allocator`, `sdk.extra.vram`.

### Build Commands

```bash
# Build everything (tools + examples) — default
zig build

# Build only the host tools (zPRXGen, zSFOTool, zPBPTool)
zig build tools

# Build only examples
zig build examples
```

A successful build emits `EBOOT.PBP` and `app.prx` for each example under `zig-out/bin/<name>/`.

### Adding Your App to build.zig

Add a `PSPBuildInfo` entry to the inline loop in `build.zig`:

```zig
PSPBuildInfo{
    .name = "my_app",
    .src_file = "src/main.zig",
    .title = "My App Title",
    // Optional: .icon0, .icon1, .pic0, .pic1, .snd0
},
```

## Running on PSP

Copy the output to your memory stick:

```
PSP/GAME/MyAppName/EBOOT.PBP
```

The application will appear under **Game → Memory Stick** in the XMB. Custom firmware (CFW) is required.

## Examples

The repository includes the following examples:

| Name | Description |
|---|---|
| `hello_world` | Screen debug print |
| `allocator` | PSP page allocator — one kernel block per allocation, no overhead |
| `arena` | `std.heap.ArenaAllocator` backed by the PSP page allocator |
| `clear_screen` | GU display list, vsync, buffer swap |
| `ziggy_cube` | 3D rotating cube using GU + GUM |
| `error` | `main()` returning an error, exercising the panic handler |
| `panic` | Integer overflow triggering the panic handler |
| `print` | Colored text output using the debug screen |
| `io` | Basic `std.Io` vtable usage — streaming file read/write |
| `time_random` | Clock resolution, timestamps, sleep, random number generation via `std.Io` |
| `cwd` | Process working directory — get and set CWD via `std.Io` |
| `dir_file` | Full directory and file operations — create, stat, seek, rename, delete via `std.Io` |
| `network` | WiFi init, DNS lookup, HTTP GET over TCP via `sdk.extra.net` + `sceNetInet*` |
| `http` | HTTP HEAD request using `std.http.Client` (TLS disabled, plain HTTP) |
| `https` | HTTPS HEAD request using `std.http.Client` with embedded root CA certificate |

## std.Io Integration

Zig-PSP implements a PSP-native `std.Io` vtable, allowing standard library I/O to work transparently on the PSP. This includes `std.debug.print`, file and directory operations, process CWD, clocks, sleep, random number generation, and TCP/UDP networking — all routed through PSP syscalls (`sceIo*`, `sceRtc*`, `sceKernelDelayThread`, `sceNetInet*`, etc.).

To enable `std.Io` in your app, add these declarations:

```zig
pub const std_options_debug_threaded_io: ?*std.Io.Threaded = null;
pub const std_options_debug_io: std.Io = sdk.extra.Io.psp_io;

pub fn std_options_cwd() std.Io.Dir {
    return .{ .handle = -1 };
}
```

The vtable covers all 56 feasible functions (100%) — directory, file, time/random, stderr, process CWD, cancellation, and network support. See `ISSUE_41.md` for detailed status.

### Networking

To use WiFi networking, initialize the stack with `sdk.extra.net`:

```zig
try sdk.extra.net.init();
defer sdk.extra.net.deinit();
try sdk.extra.net.connectToApctl(1, 30_000_000); // connect to saved network #1
```

After initialization, the `std.Io` network vtable functions (`netConnectIp`, `netRead`, `netWrite`, etc.) and raw `sceNetInet*` socket calls are both available. `std.http.Client` works out of the box for plain HTTP requests — see `examples/http.zig`.

### HTTPS / TLS

PSP has no system CA certificate store, so `std.http.Client` cannot verify server certificates by default. To use HTTPS, embed the required root CA as a DER file and load it into the client's CA bundle before making requests:

```zig
const root_ca_der = @embedFile("root_ca.der");

// ...after WiFi init:
const now = std.Io.Clock.real.now(io);
try http_client.ca_bundle.bytes.appendSlice(gpa, root_ca_der);
try http_client.ca_bundle.parseCert(gpa, 0, now.toSeconds());
http_client.now = now;
```

TLS crypto requires extra stack space — set `pub const psp_stack_size: u32 = 512 * 1024;` in your app. See `examples/https.zig` for a complete working example.

## Comparisons To C/C++

Without the weight of the C standard library, Zig produces notably smaller PSP executables. LLVM is an excellent backend, and a simple Hello World in Zig comes in around 10 KB versus ~68 KB for an equivalent C program — roughly an 85% reduction in size.

## Documentation

Auto-generated API docs are published at **https://zpsp-dev.github.io/Zig-PSP/** and updated on every push to `trunk`.

PSP system calls are also [documented in C](https://pspdev.github.io/pspsdk/). The Zig SDK types and wrappers closely mirror those names and signatures. Binding sources live in `src/c/module/` (auto-generated — do not edit by hand) and `src/sdk/` (idiomatic Zig wrappers).

## Debugging

PSPLink (from the legacy PSPSDK) can be used for USB debugging and `psp-gdb` access. Zig's own panic handler (`sdk.extra.debug.panic`) prints a backtrace to the screen, which is useful without a USB connection.
