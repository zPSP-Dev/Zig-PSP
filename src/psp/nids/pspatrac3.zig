const macro = @import("pspmacros.zig");

comptime {
    asm (macro.import_module_start("sceAtrac3plus", "0x00090000", "25"));
    asm (macro.import_function("sceAtrac3plus", "0xD1F59FDB", "sceAtracStartEntry"));
    asm (macro.import_function("sceAtrac3plus", "0xD5C28CC0", "sceAtracEndEntry"));
    asm (macro.import_function("sceAtrac3plus", "0x780F88D1", "sceAtracGetAtracID"));
    asm (macro.import_function("sceAtrac3plus", "0x61EB33F5", "sceAtracReleaseAtracID"));
    asm (macro.import_function("sceAtrac3plus", "0x0E2A73AB", "sceAtracSetData"));
    asm (macro.import_function("sceAtrac3plus", "0x3F6E26B5", "sceAtracSetHalfwayBuffer"));
    asm (macro.import_function("sceAtrac3plus", "0x7A20E7AF", "sceAtracSetDataAndGetID"));
    asm (macro.import_function("sceAtrac3plus", "0x0FAE370E", "sceAtracSetHalfwayBufferAndGetID"));
    asm (macro.import_function("sceAtrac3plus", "0x6A8C3CD5", "sceAtracDecodeData_stub"));
    asm (macro.import_function("sceAtrac3plus", "0x9AE849A7", "sceAtracGetRemainFrame"));
    asm (macro.import_function("sceAtrac3plus", "0x5D268707", "sceAtracGetStreamDataInfo"));
    asm (macro.import_function("sceAtrac3plus", "0x7DB31251", "sceAtracAddStreamData"));
    asm (macro.import_function("sceAtrac3plus", "0x83E85EA0", "sceAtracGetSecondBufferInfo"));
    asm (macro.import_function("sceAtrac3plus", "0x83BF7AFD", "sceAtracSetSecondBuffer"));
    asm (macro.import_function("sceAtrac3plus", "0xE23E3A35", "sceAtracGetNextDecodePosition"));
    asm (macro.import_function("sceAtrac3plus", "0xA2BBA8BE", "sceAtracGetSoundSample"));
    asm (macro.import_function("sceAtrac3plus", "0x31668BAA", "sceAtracGetChannel"));
    asm (macro.import_function("sceAtrac3plus", "0xD6A5F2F7", "sceAtracGetMaxSample"));
    asm (macro.import_function("sceAtrac3plus", "0x36FAABFB", "sceAtracGetNextSample"));
    asm (macro.import_function("sceAtrac3plus", "0xA554A158", "sceAtracGetBitrate"));
    asm (macro.import_function("sceAtrac3plus", "0xFAA4F89B", "sceAtracGetLoopStatus"));
    asm (macro.import_function("sceAtrac3plus", "0x868120B5", "sceAtracSetLoopNum"));
    asm (macro.import_function("sceAtrac3plus", "0xCA3CA3D2", "sceAtracGetBufferInfoForReseting"));
    asm (macro.import_function("sceAtrac3plus", "0x644E5607", "sceAtracResetPlayPosition"));
    asm (macro.import_function("sceAtrac3plus", "0xE88F759B", "sceAtracGetInternalErrorInfo"));

    asm (macro.generic_abi_wrapper("sceAtracDecodeData", 5));
}
