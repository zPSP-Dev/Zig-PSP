<h1 align="center">Zig-PSP</h1>
<p align="center">A project to bring Zig to the Sony PlayStation Portable</p>

## Why Zig on the PSP?

In the PSP programming community, many libraries, tools, and other features are written in C or C++, which as we know has its problems with writing clean, reusable, and high quality code. Given that the core objectives of Zig as a language are to allow us to create well-designed and reusable software, Zig seems like a perfect fit for integrating older PSP libraries while striving to develop higher quality software!

## Special Thanks

Special thanks is given to the [Rust-PSP team](https://github.com/overdrivenpotato/rust-psp) whose efforts influenced and helped to get this project off the ground. No harm is intended, and it's thanks to you Rustaceans that fellow Ziguanas can program for the PSP.

## Usage

Currently, using Zig-PSP is rather straight forward - one must use the psp folder in their project's src folder in order to have the PSP's function definitions, alongside with some custom utilities I have created. One also must include the tools/ folder to use the post-build tools. To build a PSP app, use the included `build.zig` script to generate a PSP executable! (EBOOT.PBP / app.prx) This script is well commented for explanation and documentation.

For a main.zig file one should include something like:

```zig
const psp = @import("psp/utils/psp.zig");

comptime {
    asm(psp.module_info("Zig PSP App", 0, 1, 0));
}

pub fn main() !void {
    psp.utils.enableHBCB();
    psp.debug.screenInit();

    psp.debug.print("Hello from Zig!");
}
```

A quick call to `zig build` will build your program and should emit an EBOOT.PBP and app.prx in your root. These are the two PSP executable formats - .prx for debugging, and .PBP for running normally.

One can run a .PBP file on their PSP (assuming CFW is installed) by adding their application to `PSP_DRIVE:/PSP/GAME/YourAppName/EBOOT.PBP` and it will be available under the Games->Memory Stick list in the PSP's XMB.

## EBOOT Customization
In order to customize the EBOOT, one can look into the `build.zig` file and modify the constant fields to change their application icon, background, and even add animations or sounds to the EBOOT on the XMB screen.

## Comparisons To C/C++
When comparing Zig code to C/C++, it would be rather apparent that by default, Zig is much smaller and tightly knit. LLVM is an excellent backend which produces some very small code, and Zig is an example of that. Without the weight of the entire C standard library needing to be imported, a simple naive Hello World, as seen above, generates in 10,195 bytes, compared to the C/C++ size of 68,098 bytes. That's an 85% reduction in size! With a few structural changes, as seen in `hello-min.zig` sample, that size can get down to 6,674 bytes! That's 90.2% smaller!  

Hopefully in the future, one could reference track the functions used in the SDK for imports, and dynamically generate module import information. This way, the PSP applications could go as small as 3,200 bytes for a hello world! This repository is distributed as part of a template, allowing one to customize their module imports, meaning that full release applications built with small tweaks to the toolchain NIDS directory could result in extraordinarily small executables for release applications!

## Documentation

Currently Zig-PSP does not include documentation of the PSPSDK in the SDK's .zig files - but rather they are [well documented in C](http://psp.jim.sh/pspsdk-doc/). It is planned to add documentation in the future to resolve this

## Debugging

If one has an installed copy of the legacy PSPSDK, one can use PSPLink - a USB debugging software, to connect their PSP to their computer and run debugging functions on the application. With legacy PSPSDK, you'll also have access to psp-gdb, a PSP-specific version of GDB to use as well. PSP-GDB with Zig is untested at the moment, but in theory should work.
