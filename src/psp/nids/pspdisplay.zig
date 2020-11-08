const macro = @import("pspmacros.zig");

comptime {
    asm (macro.import_module_start("sceDisplay", "0x40010000", "17"));
    asm (macro.import_function("sceDisplay", "0x0E20F177", "sceDisplaySetMode"));
    asm (macro.import_function("sceDisplay", "0xDEA197D4", "sceDisplayGetMode"));
    asm (macro.import_function("sceDisplay", "0xDBA6C4C4", "sceDisplayGetFramePerSec"));
    asm (macro.import_function("sceDisplay", "0x7ED59BC4", "sceDisplaySetHoldMode"));
    asm (macro.import_function("sceDisplay", "0xA544C486", "sceDisplaySetResumeMode"));
    asm (macro.import_function("sceDisplay", "0x289D82FE", "sceDisplaySetFrameBuf"));
    asm (macro.import_function("sceDisplay", "0xEEDA2E54", "sceDisplayGetFrameBuf"));
    asm (macro.import_function("sceDisplay", "0xB4F378FA", "sceDisplayIsForeground"));
    asm (macro.import_function("sceDisplay", "0x31C4BAA8", "sceDisplay_31C4BAA8"));
    asm (macro.import_function("sceDisplay", "0x9C6EAAD7", "sceDisplayGetVcount"));
    asm (macro.import_function("sceDisplay", "0x4D4E10EC", "sceDisplayIsVblank"));
    asm (macro.import_function("sceDisplay", "0x36CDFADE", "sceDisplayWaitVblank"));
    asm (macro.import_function("sceDisplay", "0x8EB9EC49", "sceDisplayWaitVblankCB"));
    asm (macro.import_function("sceDisplay", "0x984C27E7", "sceDisplayWaitVblankStart"));
    asm (macro.import_function("sceDisplay", "0x46F186C3", "sceDisplayWaitVblankStartCB"));
    asm (macro.import_function("sceDisplay", "0x773DD3A3", "sceDisplayGetCurrentHcount"));
    asm (macro.import_function("sceDisplay", "0x210EAB3A", "sceDisplayGetAccumulatedHcount"));
}
