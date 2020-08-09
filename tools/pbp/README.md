<h1 align="center">zPBPTool</h1>
<p align="center">A cross-platform multi-tool for packing, unpacking, and analyzing PSP PBP files.</p>

## Why zPBPTool?
This tool is meant to ship with the [Zig-PSP Toolchain](https://github.com/zPSP-Dev/Zig-PSP).

zPBPTool replaces PSPSDK's `pack-pbp` and `unpack-pbp` tools. In addition to this - it also can be used to analyze a PBP without extracting.

## Usage
zPBPTool is used internally by Zig-PSP's build process to create a PBP. It also can be used standalone.

To use it standalone, you can use `pbptool pack`, `pbptool unpack`, and `pbptool analyze`.

To use packing, you'll want to supply it: `pbptool pack <output.pbp> <param.sfo> <icon0.png> <icon1.pmf> <pic0.png> <pic1.png> <snd0.at3> <data.psp> <data.psar>`
If you don't want to include a file - give it the value `NULL`

To use unpacking, you'll need to supply: `pbptool unpack <input.pbp> <outputdir>`

To use analysis, all it requires is: `pbptool analyze <input.pbp>`
