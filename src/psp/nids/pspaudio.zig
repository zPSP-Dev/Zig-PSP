const macro = @import("pspmacros.zig");

comptime {
    asm (macro.import_module_start("sceAudio", "0x40010000", "27"));
    asm (macro.import_function("sceAudio", "0x8C1009B2", "sceAudioOutput"));
    asm (macro.import_function("sceAudio", "0x136CAF51", "sceAudioOutputBlocking"));
    asm (macro.import_function("sceAudio", "0xE2D56B2D", "sceAudioOutputPanned"));
    asm (macro.import_function("sceAudio", "0x13F592BC", "sceAudioOutputPannedBlocking"));
    asm (macro.import_function("sceAudio", "0x5EC81C55", "sceAudioChReserve"));
    asm (macro.import_function("sceAudio", "0x41EFADE7", "sceAudioOneshotOutput"));
    asm (macro.import_function("sceAudio", "0x6FC46853", "sceAudioChRelease"));
    asm (macro.import_function("sceAudio", "0xE9D97901", "sceAudioGetChannelRestLen"));
    asm (macro.import_function("sceAudio", "0xCB2E439E", "sceAudioSetChannelDataLen"));
    asm (macro.import_function("sceAudio", "0x95FD0C2D", "sceAudioChangeChannelConfig"));
    asm (macro.import_function("sceAudio", "0xB7E1D8E7", "sceAudioChangeChannelVolume"));
    asm (macro.import_function("sceAudio", "0x38553111", "sceAudioSRCChReserve"));
    asm (macro.import_function("sceAudio", "0x5C37C0AE", "sceAudioSRCChRelease"));
    asm (macro.import_function("sceAudio", "0xE0727056", "sceAudioSRCOutputBlocking"));
    asm (macro.import_function("sceAudio", "0x086E5895", "sceAudioInputBlocking"));
    asm (macro.import_function("sceAudio", "0x6D4BEC68", "sceAudioInput"));
    asm (macro.import_function("sceAudio", "0xA708C6A6", "sceAudioGetInputLength"));
    asm (macro.import_function("sceAudio", "0x87B2E651", "sceAudioWaitInputEnd"));
    asm (macro.import_function("sceAudio", "0x7DE61688", "sceAudioInputInit"));
    asm (macro.import_function("sceAudio", "0xA633048E", "sceAudioPollInputEnd"));
    asm (macro.import_function("sceAudio", "0xB011922F", "sceAudioGetChannelRestLength"));
    asm (macro.import_function("sceAudio", "0xE926D3FB", "sceAudioInputInitEx"));
    asm (macro.import_function("sceAudio", "0x01562BA3", "sceAudioOutput2Reserve"));
    asm (macro.import_function("sceAudio", "0x2D53F36E", "sceAudioOutput2OutputBlocking"));
    asm (macro.import_function("sceAudio", "0x43196845", "sceAudioOutput2Release"));
    asm (macro.import_function("sceAudio", "0x63F2889C", "sceAudioOutput2ChangeLength"));
    asm (macro.import_function("sceAudio", "0x647CEF33", "sceAudioOutput2GetRestSample"));
}
