const macro = @import("pspmacros.zig");

comptime {
    asm (macro.import_module_start("sceJpeg", "0x00090000", "13"));

    asm (macro.import_function("sceJpeg", "0x0425B986", "sceJpeg_0425B986"));
    asm (macro.import_function("sceJpeg", "0x04B5AE02", "sceJpegMJpegCsc"));
    asm (macro.import_function("sceJpeg", "0x04B93CEF", "sceJpegDecodeMJpeg"));
    asm (macro.import_function("sceJpeg", "0x227662D7", "sceJpeg_227662D7"));
    asm (macro.import_function("sceJpeg", "0x48B602B7", "sceJpegDeleteMJpeg"));
    asm (macro.import_function("sceJpeg", "0x64B6F978", "sceJpeg_64B6F978"));
    asm (macro.import_function("sceJpeg", "0x67F0ED84", "sceJpeg_67F0ED84"));
    asm (macro.import_function("sceJpeg", "0x7D2F3D7F", "sceJpegFinishMJpeg"));
    asm (macro.import_function("sceJpeg", "0x8F2BB012", "sceJpegGetOutputInfo"));
    asm (macro.import_function("sceJpeg", "0x91EED83C", "sceJpegDecodeMJpegYCbCr"));
    asm (macro.import_function("sceJpeg", "0x9B36444C", "sceJpeg_9B36444C"));
    asm (macro.import_function("sceJpeg", "0x9D47469C", "sceJpegCreateMJpeg"));
    asm (macro.import_function("sceJpeg", "0xAC9E70E6", "sceJpegInitMJpeg"));
}
