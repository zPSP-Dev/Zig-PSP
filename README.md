<h1 align="center">Zig-PSP</h1>
<p align="center">A project to bring Zig to the Sony PlayStation Portable</p>

## Why Zig on the PSP?

In the PSP programming community, many libraries, tools, and other features are written in C or C++, which as we know has its problems with writing clean, reusable, and high quality code. Given that the core objectives of Zig as a language are to allow us to create well-designed and reusable software, Zig seems like a perfect fit for integrating older PSP libraries while striving to develop higher quality software!

## Installation Requirements

The only other program required to use Zig-PSP is the lld linker for LLVM. This is required purely because the build script cannot pass the -emit-relocs flag to generate an ELF. [See The Issue Here](https://github.com/ziglang/zig/issues/5986)

Zig-PSP also relies on binary tools included as submodules from the zPSP-Dev team.

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

Currently Zig-PSP does not include documentation of the PSPSDK in the SDK's .zig files - but rather they are [well documented in C](http://psp.jim.sh/pspsdk-doc/). It is planned to add documentation in the future to resolve this

## Debugging

If one has an installed copy of the legacy PSPSDK, one can use PSPLink - a USB debugging software, to connect their PSP to their computer and run debugging functions on the application. With legacy PSPSDK, you'll also have access to psp-gdb, a PSP-specific version of GDB to use as well. PSP-GDB with Zig is untested at the moment, but in theory should work.
