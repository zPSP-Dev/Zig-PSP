const macro = @import("pspmacros.zig");

comptime {
    asm (macro.import_module_start("IoFileMgrForUser", "0x40010000", "36"));
    asm (macro.import_function("IoFileMgrForUser", "0x3251EA56", "sceIoPollAsync"));
    asm (macro.import_function("IoFileMgrForUser", "0xE23EEC33", "sceIoWaitAsync"));
    asm (macro.import_function("IoFileMgrForUser", "0x35DBD746", "sceIoWaitAsyncCB"));
    asm (macro.import_function("IoFileMgrForUser", "0xCB05F8D6", "sceIoGetAsyncStat"));
    asm (macro.import_function("IoFileMgrForUser", "0xB293727F", "sceIoChangeAsyncPriority"));
    asm (macro.import_function("IoFileMgrForUser", "0xA12A0514", "sceIoSetAsyncCallback"));
    asm (macro.import_function("IoFileMgrForUser", "0x810C4BC3", "sceIoClose"));
    asm (macro.import_function("IoFileMgrForUser", "0xFF5940B6", "sceIoCloseAsync"));
    asm (macro.import_function("IoFileMgrForUser", "0x109F50BC", "sceIoOpen"));
    asm (macro.import_function("IoFileMgrForUser", "0x89AA9906", "sceIoOpenAsync"));
    asm (macro.import_function("IoFileMgrForUser", "0x6A638D83", "sceIoRead"));
    asm (macro.import_function("IoFileMgrForUser", "0xA0B5A7C2", "sceIoReadAsync"));
    asm (macro.import_function("IoFileMgrForUser", "0x42EC03AC", "sceIoWrite"));
    asm (macro.import_function("IoFileMgrForUser", "0x0FACAB19", "sceIoWriteAsync"));
    asm (macro.import_function("IoFileMgrForUser", "0x27EB27B8", "sceIoLseek"));
    asm (macro.import_function("IoFileMgrForUser", "0x71B19E77", "sceIoLseekAsync"));
    asm (macro.import_function("IoFileMgrForUser", "0x68963324", "sceIoLseek32"));
    asm (macro.import_function("IoFileMgrForUser", "0x1B385D8F", "sceIoLseek32Async"));
    asm (macro.import_function("IoFileMgrForUser", "0x63632449", "sceIoIoctl_stub"));
    asm (macro.import_function("IoFileMgrForUser", "0xE95A012B", "sceIoIoctlAsync_stub"));
    asm (macro.import_function("IoFileMgrForUser", "0xB29DDF9C", "sceIoDopen"));
    asm (macro.import_function("IoFileMgrForUser", "0xE3EB004C", "sceIoDread"));
    asm (macro.import_function("IoFileMgrForUser", "0xEB092469", "sceIoDclose"));
    asm (macro.import_function("IoFileMgrForUser", "0xF27A9C51", "sceIoRemove"));
    asm (macro.import_function("IoFileMgrForUser", "0x06A70004", "sceIoMkdir"));
    asm (macro.import_function("IoFileMgrForUser", "0x1117C65F", "sceIoRmdir"));
    asm (macro.import_function("IoFileMgrForUser", "0x55F4717D", "sceIoChdir"));
    asm (macro.import_function("IoFileMgrForUser", "0xAB96437F", "sceIoSync"));
    asm (macro.import_function("IoFileMgrForUser", "0xACE946E8", "sceIoGetstat"));
    asm (macro.import_function("IoFileMgrForUser", "0xB8A740F4", "sceIoChstat"));
    asm (macro.import_function("IoFileMgrForUser", "0x779103A0", "sceIoRename"));
    asm (macro.import_function("IoFileMgrForUser", "0x54F5FB11", "sceIoDevctl_stub"));
    asm (macro.import_function("IoFileMgrForUser", "0x08BD7374", "sceIoGetDevType"));
    asm (macro.import_function("IoFileMgrForUser", "0xB2A628C1", "sceIoAssign_stub"));
    asm (macro.import_function("IoFileMgrForUser", "0x6D08A871", "sceIoUnassign"));
    asm (macro.import_function("IoFileMgrForUser", "0xE8BC6571", "sceIoCancel"));

    asm (macro.generic_abi_wrapper("sceIoDevctl", 6));
    asm (macro.generic_abi_wrapper("sceIoAssign", 6));
    asm (macro.generic_abi_wrapper("sceIoIoctl", 6));
    asm (macro.generic_abi_wrapper("sceIoIoctlAsync", 6));
}
