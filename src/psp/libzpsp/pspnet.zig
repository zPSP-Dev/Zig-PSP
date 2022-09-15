const macro = @import("pspmacros.zig");

comptime {
    asm (macro.import_module_start("sceNet", "0x00090000", "8"));
    asm (macro.import_function("sceNet", "0x39AF39A6", "sceNetInit"));
    asm (macro.import_function("sceNet", "0x281928A9", "sceNetTerm"));
    asm (macro.import_function("sceNet", "0x50647530", "sceNetFreeThreadinfo"));
    asm (macro.import_function("sceNet", "0xAD6844C6", "sceNetThreadAbort"));
    asm (macro.import_function("sceNet", "0x89360950", "sceNetEtherNtostr"));
    asm (macro.import_function("sceNet", "0xD27961C9", "sceNetEtherStrton"));
    asm (macro.import_function("sceNet", "0x0BF0A3AE", "sceNetGetLocalEtherAddr"));
    asm (macro.import_function("sceNet", "0xCC393E48", "sceNetGetMallocStat"));
}

comptime {
    asm (macro.import_module_start("sceNetAdhoc", "0x00090000", "25"));
    asm (macro.import_function("sceNetAdhoc", "0xE1D621D7", "sceNetAdhocInit"));
    asm (macro.import_function("sceNetAdhoc", "0xA62C6F57", "sceNetAdhocTerm"));
    asm (macro.import_function("sceNetAdhoc", "0x7A662D6B", "sceNetAdhocPollSocket"));
    asm (macro.import_function("sceNetAdhoc", "0x73BFD52D", "sceNetAdhocSetSocketAlert"));
    asm (macro.import_function("sceNetAdhoc", "0x4D2CE199", "sceNetAdhocGetSocketAlert"));
    asm (macro.import_function("sceNetAdhoc", "0x6F92741B", "sceNetAdhocPdpCreate"));
    asm (macro.import_function("sceNetAdhoc", "0xABED3790", "sceNetAdhocPdpSend_stub"));
    asm (macro.import_function("sceNetAdhoc", "0xDFE53E03", "sceNetAdhocPdpRecv_stub"));
    asm (macro.import_function("sceNetAdhoc", "0x7F27BB5E", "sceNetAdhocPdpDelete"));
    asm (macro.import_function("sceNetAdhoc", "0xC7C1FC57", "sceNetAdhocGetPdpStat"));
    asm (macro.import_function("sceNetAdhoc", "0x877F6D66", "sceNetAdhocPtpOpen_stub"));
    asm (macro.import_function("sceNetAdhoc", "0xFC6FC07B", "sceNetAdhocPtpConnect"));
    asm (macro.import_function("sceNetAdhoc", "0xE08BDAC1", "sceNetAdhocPtpListen_stub"));
    asm (macro.import_function("sceNetAdhoc", "0x9DF81198", "sceNetAdhocPtpAccept_stub"));
    asm (macro.import_function("sceNetAdhoc", "0x4DA4C788", "sceNetAdhocPtpSend_stub"));
    asm (macro.import_function("sceNetAdhoc", "0x8BEA2B3E", "sceNetAdhocPtpRecv_stub"));
    asm (macro.import_function("sceNetAdhoc", "0x9AC2EEAC", "sceNetAdhocPtpFlush"));
    asm (macro.import_function("sceNetAdhoc", "0x157E6225", "sceNetAdhocPtpClose"));
    asm (macro.import_function("sceNetAdhoc", "0xB9685118", "sceNetAdhocGetPtpStat"));
    asm (macro.import_function("sceNetAdhoc", "0x7F75C338", "sceNetAdhocGameModeCreateMaster"));
    asm (macro.import_function("sceNetAdhoc", "0x3278AB0C", "sceNetAdhocGameModeCreateReplica"));
    asm (macro.import_function("sceNetAdhoc", "0x98C204C8", "sceNetAdhocGameModeUpdateMaster"));
    asm (macro.import_function("sceNetAdhoc", "0xFA324B4E", "sceNetAdhocGameModeUpdateReplica"));
    asm (macro.import_function("sceNetAdhoc", "0xA0229362", "sceNetAdhocGameModeDeleteMaster"));
    asm (macro.import_function("sceNetAdhoc", "0x0B2228E9", "sceNetAdhocGameModeDeleteReplica"));

    asm (macro.generic_abi_wrapper("sceNetAdhocPdpSend", 7));
    asm (macro.generic_abi_wrapper("sceNetAdhocPdpRecv", 7));
    asm (macro.generic_abi_wrapper("sceNetAdhocPtpOpen", 8));
    asm (macro.generic_abi_wrapper("sceNetAdhocPtpListen", 7));
    asm (macro.generic_abi_wrapper("sceNetAdhocPtpAccept", 5));
    asm (macro.generic_abi_wrapper("sceNetAdhocPtpSend", 5));
    asm (macro.generic_abi_wrapper("sceNetAdhocPtpRecv", 5));
}

comptime {
    asm (macro.import_module_start("sceNetAdhocctl", "0x00090000", "21"));
    asm (macro.import_function("sceNetAdhocctl", "0xE26F226E", "sceNetAdhocctlInit"));
    asm (macro.import_function("sceNetAdhocctl", "0x9D689E13", "sceNetAdhocctlTerm"));
    asm (macro.import_function("sceNetAdhocctl", "0x0AD043ED", "sceNetAdhocctlConnect"));
    asm (macro.import_function("sceNetAdhocctl", "0xEC0635C1", "sceNetAdhocctlCreate"));
    asm (macro.import_function("sceNetAdhocctl", "0x5E7F79C9", "sceNetAdhocctlJoin"));
    asm (macro.import_function("sceNetAdhocctl", "0x08FFF7A0", "sceNetAdhocctlScan"));
    asm (macro.import_function("sceNetAdhocctl", "0x34401D65", "sceNetAdhocctlDisconnect"));
    asm (macro.import_function("sceNetAdhocctl", "0x20B317A0", "sceNetAdhocctlAddHandler"));
    asm (macro.import_function("sceNetAdhocctl", "0x6402490B", "sceNetAdhocctlDelHandler"));
    asm (macro.import_function("sceNetAdhocctl", "0x75ECD386", "sceNetAdhocctlGetState"));
    asm (macro.import_function("sceNetAdhocctl", "0x362CBE8F", "sceNetAdhocctlGetAdhocId"));
    asm (macro.import_function("sceNetAdhocctl", "0xE162CB14", "sceNetAdhocctlGetPeerList"));
    asm (macro.import_function("sceNetAdhocctl", "0x99560ABE", "sceNetAdhocctlGetAddrByName"));
    asm (macro.import_function("sceNetAdhocctl", "0x8916C003", "sceNetAdhocctlGetNameByAddr"));
    asm (macro.import_function("sceNetAdhocctl", "0xDED9D28E", "sceNetAdhocctlGetParameter"));
    asm (macro.import_function("sceNetAdhocctl", "0x81AEE1BE", "sceNetAdhocctlGetScanInfo"));
    asm (macro.import_function("sceNetAdhocctl", "0xA5C055CE", "sceNetAdhocctlCreateEnterGameMode_stub"));
    asm (macro.import_function("sceNetAdhocctl", "0x1FF89745", "sceNetAdhocctlJoinEnterGameMode"));
    asm (macro.import_function("sceNetAdhocctl", "0xCF8E084D", "sceNetAdhocctlExitGameMode"));
    asm (macro.import_function("sceNetAdhocctl", "0x5A014CE0", "sceNetAdhocctlGetGameModeInfo"));
    asm (macro.import_function("sceNetAdhocctl", "0x8DB83FDC", "sceNetAdhocctlGetPeerInfo"));
    asm (macro.generic_abi_wrapper("sceNetAdhocctlCreateEnterGameMode", 6));
}

comptime {
    asm (macro.import_module_start("sceNetAdhocMatching", "0x00090000", "21"));
    asm (macro.import_function("sceNetAdhocMatching", "0x2A2A1E07", "sceNetAdhocMatchingInit"));
    asm (macro.import_function("sceNetAdhocMatching", "0x7945ECDA", "sceNetAdhocMatchingTerm"));
    asm (macro.import_function("sceNetAdhocMatching", "0xCA5EDA6F", "sceNetAdhocMatchingCreate_stub"));
    asm (macro.import_function("sceNetAdhocMatching", "0x93EF3843", "sceNetAdhocMatchingStart_stub"));
    asm (macro.import_function("sceNetAdhocMatching", "0x32B156B3", "sceNetAdhocMatchingStop"));
    asm (macro.import_function("sceNetAdhocMatching", "0xF16EAF4F", "sceNetAdhocMatchingDelete"));
    asm (macro.import_function("sceNetAdhocMatching", "0x5E3D4B79", "sceNetAdhocMatchingSelectTarget"));
    asm (macro.import_function("sceNetAdhocMatching", "0xEA3C6108", "sceNetAdhocMatchingCancelTarget"));
    asm (macro.import_function("sceNetAdhocMatching", "0xB58E61B7", "sceNetAdhocMatchingSetHelloOpt"));
    asm (macro.import_function("sceNetAdhocMatching", "0xB5D96C2A", "sceNetAdhocMatchingGetHelloOpt"));
    asm (macro.import_function("sceNetAdhocMatching", "0xC58BCD9E", "sceNetAdhocMatchingGetMembers"));
    asm (macro.import_function("sceNetAdhocMatching", "0x40F8F435", "sceNetAdhocMatchingGetPoolMaxAlloc"));
    asm (macro.import_function("sceNetAdhocMatching", "0x8F58BEDF", "sceNetAdhocMatchingCancelTargetWithOpt"));
    asm (macro.import_function("sceNetAdhocMatching", "0x9C5CFB7D", "sceNetAdhocMatchingGetPoolStat"));
    asm (macro.import_function("sceNetAdhocMatching", "0xF79472D7", "sceNetAdhocMatchingSendData"));
    asm (macro.import_function("sceNetAdhocMatching", "0xEC19337D", "sceNetAdhocMatchingAbortSendData"));

    asm (macro.generic_abi_wrapper("sceNetAdhocMatchingStart", 7));
    asm (macro.generic_abi_wrapper("sceNetAdhocMatchingCreate", 9));
}

comptime {
    asm (macro.import_module_start("sceNetApctl", "0x00090000", "8"));
    asm (macro.import_function("sceNetApctl", "0xE2F91F9B", "sceNetApctlInit"));
    asm (macro.import_function("sceNetApctl", "0xB3EDD0EC", "sceNetApctlTerm"));
    asm (macro.import_function("sceNetApctl", "0x2BEFDF23", "sceNetApctlGetInfo"));
    asm (macro.import_function("sceNetApctl", "0x8ABADD51", "sceNetApctlAddHandler"));
    asm (macro.import_function("sceNetApctl", "0x5963991B", "sceNetApctlDelHandler"));
    asm (macro.import_function("sceNetApctl", "0xCFB957C6", "sceNetApctlConnect"));
    asm (macro.import_function("sceNetApctl", "0x24FE91A1", "sceNetApctlDisconnect"));
    asm (macro.import_function("sceNetApctl", "0x5DEAC81B", "sceNetApctlGetState"));
}

comptime {
    asm (macro.import_module_start("sceNetInet", "0x00090000", "30"));
    asm (macro.import_function("sceNetInet", "0x17943399", "sceNetInetInit"));
    asm (macro.import_function("sceNetInet", "0xA9ED66B9", "sceNetInetTerm"));
    asm (macro.import_function("sceNetInet", "0xDB094E1B", "sceNetInetAccept"));
    asm (macro.import_function("sceNetInet", "0x1A33F9AE", "sceNetInetBind"));
    asm (macro.import_function("sceNetInet", "0x8D7284EA", "sceNetInetClose"));
    asm (macro.import_function("sceNetInet", "0x805502DD", "sceNetInetCloseWithRST"));
    asm (macro.import_function("sceNetInet", "0x410B34AA", "sceNetInetConnect"));
    asm (macro.import_function("sceNetInet", "0xE247B6D6", "sceNetInetGetpeername"));
    asm (macro.import_function("sceNetInet", "0x162E6FD5", "sceNetInetGetsockname"));
    asm (macro.import_function("sceNetInet", "0x4A114C7C", "sceNetInetGetsockopt_stub"));
    asm (macro.import_function("sceNetInet", "0xD10A1A7A", "sceNetInetListen"));
    asm (macro.import_function("sceNetInet", "0xFAABB1DD", "sceNetInetPoll"));
    asm (macro.import_function("sceNetInet", "0xCDA85C99", "sceNetInetRecv"));
    asm (macro.import_function("sceNetInet", "0xC91142E4", "sceNetInetRecvfrom_stub"));
    asm (macro.import_function("sceNetInet", "0xEECE61D2", "sceNetInetRecvmsg"));
    asm (macro.import_function("sceNetInet", "0x5BE8D595", "sceNetInetSelect"));
    asm (macro.import_function("sceNetInet", "0x7AA671BC", "sceNetInetSend"));
    asm (macro.import_function("sceNetInet", "0x05038FC7", "sceNetInetSendto_stub"));
    asm (macro.import_function("sceNetInet", "0x774E36F4", "sceNetInetSendmsg"));
    asm (macro.import_function("sceNetInet", "0x2FE71FE7", "sceNetInetSetsockopt_stub"));
    asm (macro.import_function("sceNetInet", "0x4CFE4E56", "sceNetInetShutdown"));
    asm (macro.import_function("sceNetInet", "0x8B7B220F", "sceNetInetSocket"));
    asm (macro.import_function("sceNetInet", "0x80A21ABD", "sceNetInetSocketAbort"));
    asm (macro.import_function("sceNetInet", "0xFBABE411", "sceNetInetGetErrno"));
    asm (macro.import_function("sceNetInet", "0xB3888AD4", "sceNetInetGetTcpcbstat"));
    asm (macro.import_function("sceNetInet", "0x39B0C7D3", "sceNetInetGetUdpcbstat"));
    asm (macro.import_function("sceNetInet", "0xB75D5B0A", "sceNetInetInetAddr"));
    asm (macro.import_function("sceNetInet", "0x1BDF5D13", "sceNetInetInetAton"));
    asm (macro.import_function("sceNetInet", "0xD0792666", "sceNetInetInetNtop"));
    asm (macro.import_function("sceNetInet", "0xE30B8C19", "sceNetInetInetPton"));

    asm (macro.generic_abi_wrapper("sceNetInetGetsockopt", 5));
    asm (macro.generic_abi_wrapper("sceNetInetRecvfrom", 5));
    asm (macro.generic_abi_wrapper("sceNetInetSendto", 6));
    asm (macro.generic_abi_wrapper("sceNetInetSetsockopt", 5));
}

comptime {
    asm (macro.import_module_start("sceNetResolver", "0x00090000", "7"));
    asm (macro.import_function("sceNetResolver", "0xF3370E61", "sceNetResolverInit"));
    asm (macro.import_function("sceNetResolver", "0x6138194A", "sceNetResolverTerm"));
    asm (macro.import_function("sceNetResolver", "0x244172AF", "sceNetResolverCreate"));
    asm (macro.import_function("sceNetResolver", "0x94523E09", "sceNetResolverDelete"));
    asm (macro.import_function("sceNetResolver", "0x224C5F44", "sceNetResolverStartNtoA_stub"));
    asm (macro.import_function("sceNetResolver", "0x629E2FB7", "sceNetResolverStartAtoN_stub"));
    asm (macro.import_function("sceNetResolver", "0x808F6063", "sceNetResolverStop"));
    asm (macro.generic_abi_wrapper("sceNetResolverStartNtoA", 5));
    asm (macro.generic_abi_wrapper("sceNetResolverStartAtoN", 6));
}
