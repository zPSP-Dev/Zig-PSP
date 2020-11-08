const macro = @import("pspmacros.zig");

comptime {
    asm (macro.import_module_start("sceUsb", "0x40010000", "9"));
    asm (macro.import_function("sceUsb", "0xAE5DE6AF", "sceUsbStart"));
    asm (macro.import_function("sceUsb", "0xC2464FA0", "sceUsbStop"));
    asm (macro.import_function("sceUsb", "0xC21645A4", "sceUsbGetState"));
    asm (macro.import_function("sceUsb", "0x4E537366", "sceUsbGetDrvList"));
    asm (macro.import_function("sceUsb", "0x112CC951", "sceUsbGetDrvState"));
    asm (macro.import_function("sceUsb", "0x586DB82C", "sceUsbActivate"));
    asm (macro.import_function("sceUsb", "0xC572A9C8", "sceUsbDeactivate"));
    asm (macro.import_function("sceUsb", "0x5BE0E002", "sceUsbWaitState"));
    asm (macro.import_function("sceUsb", "0x1C360735", "sceUsbWaitCancel"));
}
