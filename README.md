<h1 align="center">Zig-PSP</h1>
<p align="center">A project to bring Zig to the Sony PlayStation Portable</p>

## Why Zig on the PSP?

In the PSP programming community, many libraries, tools, and other features are written in C or C++, which as we know has its problems with writing clean, reusable, and high quality code. Given that the core objectives of Zig as a language are to allow us to create well-designed and reusable software, Zig seems like a perfect fit for integrating older PSP libraries while striving to develop higher quality software!

## Special Thanks

Special thanks is given to the [Rust-PSP team](https://github.com/overdrivenpotato/rust-psp) whose efforts influenced and helped to get this project off the ground. No harm is intended, and it's thanks to you Rustaceans that fellow Ziguanas can program for the PSP.

## Requirements

- **Zig 0.16.0-dev** nightly (see `build.zig.zon` for the exact fingerprint)

No legacy PSPSDK or external C toolchain is required. All build tools (`zPRXGen`, `zSFOTool`, `zPBPTool`) are written in Zig and built automatically.

## Getting Started

### 1. Add pspsdk to your project

```bash
zig fetch --save=pspsdk git+https://github.com/zPSP-Dev/Zig-PSP
```

This adds the dependency to your `build.zig.zon` automatically.

### 2. Set up your build.zig

```zig
const std = @import("std");
const pspsdk = @import("pspsdk");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});

    pspsdk.buildPspEboot(b, .{
        .name             = "my_app",
        .root_source_file = b.path("src/main.zig"),
        .title            = "My App Title",
        .optimize         = optimize,
    }, .{});
}
```

`buildPspEboot` runs the full pipeline (Zig -> ELF -> PRX -> SFO -> PBP) and installs the output to `zig-out/bin/my_app/`. Run `zig build` to produce `EBOOT.PBP`, `app.prx`, and `app.elf`.

Optional PBP asset fields are available on `PspEbootOptions`: `.icon0`, `.icon1`, `.pic0`, `.pic1`, `.snd0` (all `?std.Build.LazyPath`). The output directory defaults to the app name but can be overridden via `PspOutputOptions.dir`.

### Lower-level API for engine/framework integration

If your build system needs to create and configure the executable itself (e.g. to attach engine modules or link additional dependencies), two lower-level functions are available:

- **`configurePspExecutable(exe)`** — applies PSP-specific settings (linker script, entry point, relocation emission) and adds the `pspsdk` module import to an existing executable.
- **`addEbootSteps(b, exe, options)`** — runs the ELF -> PRX -> SFO -> PBP pipeline on an existing PSP executable and optionally installs artifacts.

```zig
const std = @import("std");
const pspsdk = @import("pspsdk");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const psp_target = pspsdk.getPspTarget(b);

    const exe = b.addExecutable(.{
        .name = "main",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = psp_target,
            .optimize = optimize,
            .strip = false,
            .imports = &.{
                .{ .name = "engine", .module = engine_mod },
            },
        }),
    });

    // Apply PSP build settings (linker script, entry point, pspsdk import)
    pspsdk.configurePspExecutable(exe);

    // Run the packaging pipeline and install artifacts
    _ = pspsdk.addEbootSteps(b, exe, .{
        .title = "My App",
        .output_dir = "my_app",
    });
}
```

`buildPspEboot` is implemented as a thin wrapper around these two functions and remains the recommended API for simple projects.

### 3. Write your app

Every PSP app needs a `module_info` comptime call and the panic handler override:

```zig
const std = @import("std");
const sdk = @import("pspsdk");

// Required: overrides the default panic handler which pulls in posix symbols.
pub const panic = sdk.extra.debug.panic;

// Required: routes std.debug.print through PSP I/O instead of posix.
pub const std_options_debug_threaded_io: ?*std.Io.Threaded = null;
pub const std_options_debug_io: std.Io = sdk.extra.Io.psp_io;
pub fn std_options_cwd() std.Io.Dir { return .{ .handle = -1 }; }

comptime {
    asm (sdk.extra.module.module_info("My App Name", .{ .mode = .User }, 1, 0));
}

pub fn main(_: std.process.Init) !void {
    sdk.extra.utils.enableHBCB();
    sdk.extra.debug.screenInit();

    sdk.extra.debug.print("Hello from Zig!", .{});
}
```

### API Tiers

The SDK exposes PSP functions through two tiers:

| Tier | Example | Description |
|---|---|---|
| Raw C bindings | `sdk.c.LoadExecForUser.sceKernelExitGame()` | Auto-generated stubs, one namespace per firmware module |
| Zig bindings | `sdk.sceKernelExitGame()` or `sdk.kernel.exit_game()` | Idiomatic wrappers with two access routes: sce-prefixed re-exports at the package root, or snake_case sub-namespaces |

Sub-namespaces: `sdk.adhoc`, `sdk.atrac3`, `sdk.audio`, `sdk.audiocodec`, `sdk.ctrl`, `sdk.display`, `sdk.dmac`, `sdk.ge`, `sdk.gu`, `sdk.gum`, `sdk.hprm`, `sdk.http`, `sdk.impose`, `sdk.internal`, `sdk.io`, `sdk.jpeg`, `sdk.kermit`, `sdk.kernel`, `sdk.mp3`, `sdk.mpeg`, `sdk.net`, `sdk.openpsid`, `sdk.power`, `sdk.reg`, `sdk.rtc`, `sdk.ssl`, `sdk.umd`, `sdk.usb`, `sdk.usbcam`, `sdk.usbstor`, `sdk.utility`, `sdk.wlan`.

The utility layer lives under `sdk.extra`: `sdk.extra.debug`, `sdk.extra.module`, `sdk.extra.utils`, `sdk.extra.allocator`, `sdk.extra.vram`, `sdk.extra.Io`, `sdk.extra.constants`, `sdk.extra.net`.

## Building This Repository

```bash
# Build everything (tools + examples) -- default
zig build

# Build only the host tools (zPRXGen, zSFOTool, zPBPTool)
zig build tools

# Build only examples
zig build examples

# Build examples as a standalone sub-project (exercises the package API)
cd examples && zig build
```

Output lands in `zig-out/bin/<name>/` with `EBOOT.PBP`, `app.prx`, and `app.elf` for each example.

## Running on PSP

Copy the output to your memory stick:

```
PSP/GAME/MyAppName/EBOOT.PBP
```

The application will appear under **Game -> Memory Stick** in the XMB. Custom firmware (CFW) is required.

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

The vtable covers all 56 feasible functions (100%) — directory, file, time/random, stderr, process CWD, cancellation, and network support.

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
