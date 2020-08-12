<h1 align="center">Zig-PSP</h1>

<p align="center">
<img src="https://github.com/zPSP-Dev/Zig-PSP/raw/master/ZigPSP_logo.png" data-canonical-src="https://github.com/zPSP-Dev/Zig-PSP/raw/master/ZigPSP_logo.png" width="512" height="512" /></p>

<p align="center">A project to bring Zig to the Sony PlayStation Portable</p>

## Why Zig on the PSP?

In the PSP programming community, many libraries, tools, and other features are written in C or C++, which as we know has its problems with writing clean, reusable, and high quality code. Given that the core objectives of Zig as a language are to allow us to create well-designed and reusable software, Zig seems like a perfect fit for integrating older PSP libraries while striving to develop higher quality software!

## What about the PSPSDK?

Zig-PSP has **no reliance** on the legacy toolchain.

## Road to Release!
- [x] PSP PRX Generation
- [x] All PSP Userland Library Symbols
- [x] Full `build.zig` build script
- [x] Remove all dependencies on PSPSDK headers & Newlib
- [x] Basic PSP Debug Printing
- [x] Remove dependency on Rust-PSP installs.
- [x] Basic PSP Memory & VRAM Allocator
- [x] Basic Error handling on Main
- [x] Fixup enums
- [x] Panic Support
- [x] Remove C dependencies!
- [x] Documentation for the custom modules.
- [x] Benchmarking
- [x] Include basic examples!
- [ ] Self-hosted tools
- [ ] Remove Reliance on Rust libpsp.a
- [ ] Initial Release!
- [ ] Stack Traces
- [ ] CPU-level analysis and profiling
- [ ] STD Custom OS Support
- [ ] STD Upstream Support

## Dependencies

The only true external dependency that this library requires is the lld linker for LLVM. This is required purely because the build script cannot pass the -emit-relocs flag to generate an ELF. [See The Issue Here](https://github.com/ziglang/zig/issues/5986)

Zig-PSP also relies on binary tools from Rust-PSP and the static library, which are included with the download by default. There are plans to make these tools self hosted, even if the library may not be.

## Usage

Currently, using Zig-PSP is rather straight forward - one must use the psp folder in their project's src folder in order to have the extern definitions for libpsp.a alongside with some custom utilities I have created. One also must include the lib/ folder to include libpsp.a alongside with the post-build tools. To build a PSP app, use the included `build.zig` script to generate a PSP executable! (EBOOT.PBP / app.prx) This script is well commented for explanation and documentation.

For a main.zig file one should include something like:

```zig
//A simple hello world

const psp = @import("psp/pspsdk.zig");

comptime {
    _ = psp.module_start_struct;
}

pub fn main() !void {
    psp.utils.enableHomeButton();
    psp.debug.screenInit();

    psp.debug.print("Hello from Zig!");
}
```

A quick call to `zig build` will build your program and should emit an EBOOT.PBP and app.prx in your root. These are the two PSP executable formats - .prx for debugging, and .PBP for running normally.

One can run a .PBP file on their PSP (assuming CFW is installed) by adding their application to `PSP_DRIVE:/PSP/GAME/YourAppName/EBOOT.PBP` and it will be available under the Games->Memory Stick list in the PSP's XMB.

## EBOOT Customization
In order to customize the EBOOT, one can look into the `build.zig` file and modify the constant fields to change their application icon, background, and even add animations or sounds to the EBOOT on the XMB screen.

## Documentation

Currently Zig-PSP does not include documentation of the PSPSDK in the SDK's .zig files - but rather they are well documented for both [Rust](https://docs.rs/psp/) and [C](http://psp.jim.sh/pspsdk-doc/). These both have an excellent documentation of the same APIs, although you might prefer the C documentation as this project is closer to C than Rust.

## Debugging

If one has an installed copy of the legacy PSPSDK, one can use PSPLink - a USB debugging software, to connect their PSP to their computer and run debugging functions on the application. With legacy PSPSDK, you'll also have access to psp-gdb, a PSP-specific version of GDB to use as well. PSP-GDB with Zig is untested at the moment, but in theory should work.
