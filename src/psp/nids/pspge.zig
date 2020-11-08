const macro = @import("pspmacros.zig");

comptime {
    asm (macro.import_module_start("sceGe_user", "0x40010000", "18"));
    asm (macro.import_function("sceGe_user", "0x1F6752AD", "sceGeEdramGetSize"));
    asm (macro.import_function("sceGe_user", "0xE47E40E4", "sceGeEdramGetAddr"));
    asm (macro.import_function("sceGe_user", "0xB77905EA", "sceGeEdramSetAddrTranslation"));
    asm (macro.import_function("sceGe_user", "0xDC93CFEF", "sceGeGetCmd"));
    asm (macro.import_function("sceGe_user", "0x57C8945B", "sceGeGetMtx"));
    //asm(macro.import_function("sceGe_user", "0xE66CB92E", "sceGeGetStack"));
    asm (macro.import_function("sceGe_user", "0x438A385A", "sceGeSaveContext"));
    asm (macro.import_function("sceGe_user", "0x0BF608FB", "sceGeRestoreContext"));
    asm (macro.import_function("sceGe_user", "0xAB49E76A", "sceGeListEnQueue"));
    asm (macro.import_function("sceGe_user", "0x1C0D95A6", "sceGeListEnQueueHead"));
    asm (macro.import_function("sceGe_user", "0x5FB86AB0", "sceGeListDeQueue"));
    asm (macro.import_function("sceGe_user", "0xE0D68148", "sceGeListUpdateStallAddr"));
    asm (macro.import_function("sceGe_user", "0x03444EB4", "sceGeListSync"));
    asm (macro.import_function("sceGe_user", "0xB287BD61", "sceGeDrawSync"));
    asm (macro.import_function("sceGe_user", "0xB448EC0D", "sceGeBreak"));
    asm (macro.import_function("sceGe_user", "0x4C06E472", "sceGeContinue"));
    asm (macro.import_function("sceGe_user", "0xA4FC06A4", "sceGeSetCallback"));
    asm (macro.import_function("sceGe_user", "0x05DB22CE", "sceGeUnsetCallback"));
}
