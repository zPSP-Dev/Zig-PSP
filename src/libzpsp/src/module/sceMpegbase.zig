// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

pub extern fn sceMpegBaseYCrCbCopyVme(YUVBuffer: types.ScePVoid, Buffer: [*c]types.SceInt32, Type: types.SceInt32) callconv(.c) types.SceInt32;

pub extern fn sceMpegBaseCscInit(width: types.SceInt32) callconv(.c) types.SceInt32;

pub extern fn sceMpegBaseCscVme(pRGBbuffer: types.ScePVoid, pRGBbuffer2: types.ScePVoid, width: types.SceInt32, pYCrCbBuffer: [*c]c_int) callconv(.c) types.SceInt32;

pub extern fn sceMpegbase_0530BE4E() callconv(.c) void;

pub extern fn sceMpegbase_304882E1() callconv(.c) void;

pub extern fn sceMpegBaseYCrCbCopy() callconv(.c) void;

pub extern fn sceMpegBaseCscAvc() callconv(.c) void;

pub extern fn sceMpegbase_AC9E717E() callconv(.c) void;

pub extern fn sceMpegbase_BEA18F91(pLLI: [*c]c_int) callconv(.c) types.SceInt32;

comptime {
    asm (macro.import_module_start("sceMpegbase", "0x00090000", "9"));
    asm (macro.import_function("sceMpegbase", "0xBE45C284", "sceMpegBaseYCrCbCopyVme"));
    asm (macro.import_function("sceMpegbase", "0x492B5E4B", "sceMpegBaseCscInit"));
    asm (macro.import_function("sceMpegbase", "0xCE8EB837", "sceMpegBaseCscVme"));
    asm (macro.import_function("sceMpegbase", "0x0530BE4E", "sceMpegbase_0530BE4E"));
    asm (macro.import_function("sceMpegbase", "0x304882E1", "sceMpegbase_304882E1"));
    asm (macro.import_function("sceMpegbase", "0x7AC0321A", "sceMpegBaseYCrCbCopy"));
    asm (macro.import_function("sceMpegbase", "0x91929A21", "sceMpegBaseCscAvc"));
    asm (macro.import_function("sceMpegbase", "0xAC9E717E", "sceMpegbase_AC9E717E"));
    asm (macro.import_function("sceMpegbase", "0xBEA18F91", "sceMpegbase_BEA18F91"));
}
