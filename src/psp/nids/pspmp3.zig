const macro = @import("pspmacros.zig");

comptime {
    asm (macro.import_module_start("sceMp3", "0x00090011", "19"));
    asm (macro.import_function("sceMp3", "0x07EC321A", "sceMp3ReserveMp3Handle"));
    asm (macro.import_function("sceMp3", "0x0DB149F4", "sceMp3NotifyAddStreamData"));
    asm (macro.import_function("sceMp3", "0x2A368661", "sceMp3ResetPlayPosition"));
    asm (macro.import_function("sceMp3", "0x354D27EA", "sceMp3GetSumDecodedSample"));
    asm (macro.import_function("sceMp3", "0x35750070", "sceMp3InitResource"));
    asm (macro.import_function("sceMp3", "0x3C2FA058", "sceMp3TermResource"));
    asm (macro.import_function("sceMp3", "0x3CEF484F", "sceMp3SetLoopNum"));
    asm (macro.import_function("sceMp3", "0x44E07129", "sceMp3Init"));
    asm (macro.import_function("sceMp3", "0x7F696782", "sceMp3GetMp3ChannelNum"));
    asm (macro.import_function("sceMp3", "0x87677E40", "sceMp3GetBitRate"));
    asm (macro.import_function("sceMp3", "0x87C263D1", "sceMp3GetMaxOutputSample"));
    asm (macro.import_function("sceMp3", "0x8F450998", "sceMp3GetSamplingRate"));
    asm (macro.import_function("sceMp3", "0xA703FE0F", "sceMp3GetInfoToAddStreamData"));
    asm (macro.import_function("sceMp3", "0xD021C0FB", "sceMp3Decode"));
    asm (macro.import_function("sceMp3", "0xD0A56296", "sceMp3CheckStreamDataNeeded"));
    asm (macro.import_function("sceMp3", "0xD8F54A51", "sceMp3GetLoopNum"));
    asm (macro.import_function("sceMp3", "0xF5478233", "sceMp3ReleaseMp3Handle"));
}
