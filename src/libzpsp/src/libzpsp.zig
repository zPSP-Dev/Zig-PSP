const macro = @import("pspmacros.zig");
const options = @import("libzpsp_option");

comptime {
    @setEvalBranchQuota(1000000);

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_scePower") and options.include_scePower)) {
        asm(macro.import_module_start("scePower", "0x40010000", "46"));
        asm(macro.import_function("scePower", "0x2B51FE2F", "scePowerGetWlanActivity"));
        asm(macro.import_function("scePower", "0x442BFBAC", "scePowerGetBacklightMaximum"));
        asm(macro.import_function("scePower", "0xEFD3C963", "scePowerTick"));
        asm(macro.import_function("scePower", "0xEDC13FE5", "scePowerGetIdleTimer"));
        asm(macro.import_function("scePower", "0x7F30B3B1", "scePowerIdleTimerEnable"));
        asm(macro.import_function("scePower", "0x972CE941", "scePowerIdleTimerDisable"));
        asm(macro.import_function("scePower", "0x27F3292C", "scePowerBatteryUpdateInfo"));
        asm(macro.import_function("scePower", "0xE8E4E204", "scePowerGetForceSuspendCapacity"));
        asm(macro.import_function("scePower", "0xB999184C", "scePowerGetLowBatteryCapacity"));
        asm(macro.import_function("scePower", "0x87440F5E", "scePowerIsPowerOnline"));
        asm(macro.import_function("scePower", "0x0AFD0D8B", "scePowerIsBatteryExist"));
        asm(macro.import_function("scePower", "0x1E490401", "scePowerIsBatteryCharging"));
        asm(macro.import_function("scePower", "0xB4432BC8", "scePowerGetBatteryChargingStatus"));
        asm(macro.import_function("scePower", "0xD3075926", "scePowerIsLowBattery"));
        asm(macro.import_function("scePower", "0x78A1A796", "scePowerIsSuspendRequired"));
        asm(macro.import_function("scePower", "0x94F5A53F", "scePowerGetBatteryRemainCapacity"));
        asm(macro.import_function("scePower", "0xFD18A0FF", "scePowerGetBatteryFullCapacity"));
        asm(macro.import_function("scePower", "0x2085D15D", "scePowerGetBatteryLifePercent"));
        asm(macro.import_function("scePower", "0x8EFB3FA2", "scePowerGetBatteryLifeTime"));
        asm(macro.import_function("scePower", "0x28E12023", "scePowerGetBatteryTemp"));
        asm(macro.import_function("scePower", "0x862AE1A6", "scePowerGetBatteryElec"));
        asm(macro.import_function("scePower", "0x483CE86B", "scePowerGetBatteryVolt"));
        asm(macro.import_function("scePower", "0x23436A4A", "scePowerGetInnerTemp"));
        asm(macro.import_function("scePower", "0x0CD21B1F", "scePowerSetPowerSwMode"));
        asm(macro.import_function("scePower", "0x165CE085", "scePowerGetPowerSwMode"));
        asm(macro.import_function("scePower", "0xD6D016EF", "scePowerLock"));
        asm(macro.import_function("scePower", "0xCA3D34C1", "scePowerUnlock"));
        asm(macro.import_function("scePower", "0xDB62C9CF", "scePowerCancelRequest"));
        asm(macro.import_function("scePower", "0x7FA406DD", "scePowerIsRequest"));
        asm(macro.import_function("scePower", "0x2B7C7CF4", "scePowerRequestStandby"));
        asm(macro.import_function("scePower", "0xAC32C9CC", "scePowerRequestSuspend"));
        asm(macro.import_function("scePower", "0x2875994B", "scePowerRequestSuspendTouchAndGo"));
        asm(macro.import_function("scePower", "0x3951AF53", "scePowerEncodeUBattery"));
        asm(macro.import_function("scePower", "0x0074EF9B", "scePowerGetResumeCount"));
        asm(macro.import_function("scePower", "0x04B7766E", "scePowerRegisterCallback"));
        asm(macro.import_function("scePower", "0xDFA8BAF8", "scePowerUnregisterCallback"));
        asm(macro.import_function("scePower", "0xDB9D28DD", "scePowerUnregitserCallback"));
        asm(macro.import_function("scePower", "0x843FBF43", "scePowerSetCpuClockFrequency"));
        asm(macro.import_function("scePower", "0xB8D7B3FB", "scePowerSetBusClockFrequency"));
        asm(macro.import_function("scePower", "0xFEE03A2F", "scePowerGetCpuClockFrequency"));
        asm(macro.import_function("scePower", "0x478FE6F5", "scePowerGetBusClockFrequency"));
        asm(macro.import_function("scePower", "0xFDB5BFE9", "scePowerGetCpuClockFrequencyInt"));
        asm(macro.import_function("scePower", "0xBD681969", "scePowerGetBusClockFrequencyInt"));
        asm(macro.import_function("scePower", "0xB1A52C83", "scePowerGetCpuClockFrequencyFloat"));
        asm(macro.import_function("scePower", "0x9BADB3EB", "scePowerGetBusClockFrequencyFloat"));
        asm(macro.import_function("scePower", "0x737486F2", "scePowerSetClockFrequency"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceVideocodec") and options.include_sceVideocodec)) {
        asm(macro.import_module_start("sceVideocodec", "0x40010011", "11"));
        asm(macro.import_function("sceVideocodec", "0x17099F0A", "sceVideocodecInit"));
        asm(macro.import_function("sceVideocodec", "0x26927D19", "sceVideocodecGetVersion"));
        asm(macro.import_function("sceVideocodec", "0x2D31F5B1", "sceVideocodecGetEDRAM"));
        asm(macro.import_function("sceVideocodec", "0x2F385E7F", "sceVideocodecScanHeader"));
        asm(macro.import_function("sceVideocodec", "0x307E6E1C", "sceVideocodecDelete"));
        asm(macro.import_function("sceVideocodec", "0x4F160BF4", "sceVideocodecReleaseEDRAM"));
        asm(macro.import_function("sceVideocodec", "0x627B7D42", "sceVideocodec_627B7D42"));
        asm(macro.import_function("sceVideocodec", "0x745A7B7A", "sceVideocodecSetMemory"));
        asm(macro.import_function("sceVideocodec", "0xA2F0564E", "sceVideocodecStop"));
        asm(macro.import_function("sceVideocodec", "0xC01EC829", "sceVideocodecOpen"));
        asm(macro.import_function("sceVideocodec", "0xDBA273FA", "sceVideocodecDecode"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceNetInet") and options.include_sceNetInet)) {
        asm(macro.import_module_start("sceNetInet", "0x00090000", "30"));
        asm(macro.import_function("sceNetInet", "0x17943399", "sceNetInetInit"));
        asm(macro.import_function("sceNetInet", "0xA9ED66B9", "sceNetInetTerm"));
        asm(macro.import_function("sceNetInet", "0xDB094E1B", "sceNetInetAccept"));
        asm(macro.import_function("sceNetInet", "0x1A33F9AE", "sceNetInetBind"));
        asm(macro.import_function("sceNetInet", "0x8D7284EA", "sceNetInetClose"));
        asm(macro.import_function("sceNetInet", "0x805502DD", "sceNetInetCloseWithRST"));
        asm(macro.import_function("sceNetInet", "0x410B34AA", "sceNetInetConnect"));
        asm(macro.import_function("sceNetInet", "0xE247B6D6", "sceNetInetGetpeername"));
        asm(macro.import_function("sceNetInet", "0x162E6FD5", "sceNetInetGetsockname"));
        asm(macro.import_function("sceNetInet", "0x4A114C7C", "sceNetInetGetsockopt"));
        asm(macro.import_function("sceNetInet", "0xD10A1A7A", "sceNetInetListen"));
        asm(macro.import_function("sceNetInet", "0xFAABB1DD", "sceNetInetPoll"));
        asm(macro.import_function("sceNetInet", "0xCDA85C99", "sceNetInetRecv"));
        asm(macro.import_function("sceNetInet", "0xC91142E4", "sceNetInetRecvfrom"));
        asm(macro.import_function("sceNetInet", "0xEECE61D2", "sceNetInetRecvmsg"));
        asm(macro.import_function("sceNetInet", "0x5BE8D595", "sceNetInetSelect_stub"));
        asm(macro.generic_abi_wrapper("sceNetInetSelect", 5));
        asm(macro.import_function("sceNetInet", "0x7AA671BC", "sceNetInetSend"));
        asm(macro.import_function("sceNetInet", "0x05038FC7", "sceNetInetSendto"));
        asm(macro.import_function("sceNetInet", "0x774E36F4", "sceNetInetSendmsg"));
        asm(macro.import_function("sceNetInet", "0x2FE71FE7", "sceNetInetSetsockopt"));
        asm(macro.import_function("sceNetInet", "0x4CFE4E56", "sceNetInetShutdown"));
        asm(macro.import_function("sceNetInet", "0x8B7B220F", "sceNetInetSocket"));
        asm(macro.import_function("sceNetInet", "0x80A21ABD", "sceNetInetSocketAbort"));
        asm(macro.import_function("sceNetInet", "0xFBABE411", "sceNetInetGetErrno"));
        asm(macro.import_function("sceNetInet", "0xB3888AD4", "sceNetInetGetTcpcbstat"));
        asm(macro.import_function("sceNetInet", "0x39B0C7D3", "sceNetInetGetUdpcbstat"));
        asm(macro.import_function("sceNetInet", "0xB75D5B0A", "sceNetInetInetAddr"));
        asm(macro.import_function("sceNetInet", "0x1BDF5D13", "sceNetInetInetAton"));
        asm(macro.import_function("sceNetInet", "0xD0792666", "sceNetInetInetNtop"));
        asm(macro.import_function("sceNetInet", "0xE30B8C19", "sceNetInetInetPton"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceNetApctl") and options.include_sceNetApctl)) {
        asm(macro.import_module_start("sceNetApctl", "0x00090000", "8"));
        asm(macro.import_function("sceNetApctl", "0xE2F91F9B", "sceNetApctlInit"));
        asm(macro.import_function("sceNetApctl", "0xB3EDD0EC", "sceNetApctlTerm"));
        asm(macro.import_function("sceNetApctl", "0x2BEFDF23", "sceNetApctlGetInfo"));
        asm(macro.import_function("sceNetApctl", "0x8ABADD51", "sceNetApctlAddHandler"));
        asm(macro.import_function("sceNetApctl", "0x5963991B", "sceNetApctlDelHandler"));
        asm(macro.import_function("sceNetApctl", "0xCFB957C6", "sceNetApctlConnect"));
        asm(macro.import_function("sceNetApctl", "0x24FE91A1", "sceNetApctlDisconnect"));
        asm(macro.import_function("sceNetApctl", "0x5DEAC81B", "sceNetApctlGetState"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceHttp") and options.include_sceHttp)) {
        asm(macro.import_module_start("sceHttp", "0x00090011", "83"));
        asm(macro.import_function("sceHttp", "0x0282A3BD", "sceHttpGetContentLength"));
        asm(macro.import_function("sceHttp", "0x03D9526F", "sceHttpSetResolveRetry"));
        asm(macro.import_function("sceHttp", "0x06488A1C", "sceHttpSetCookieSendCallback"));
        asm(macro.import_function("sceHttp", "0x0809C831", "sceHttpEnableRedirect"));
        asm(macro.import_function("sceHttp", "0x0B12ABFB", "sceHttpDisableCookie"));
        asm(macro.import_function("sceHttp", "0x0DAFA58F", "sceHttpEnableCookie"));
        asm(macro.import_function("sceHttp", "0x15540184", "sceHttpDeleteHeader"));
        asm(macro.import_function("sceHttp", "0x1A0EBB69", "sceHttpDisableRedirect"));
        asm(macro.import_function("sceHttp", "0x1CEDB9D4", "sceHttpFlushCache"));
        asm(macro.import_function("sceHttp", "0x1F0FC3E3", "sceHttpSetRecvTimeOut"));
        asm(macro.import_function("sceHttp", "0x2255551E", "sceHttpGetNetworkPspError"));
        asm(macro.import_function("sceHttp", "0x267618F4", "sceHttpSetAuthInfoCallback"));
        asm(macro.import_function("sceHttp", "0x2A6C3296", "sceHttpSetAuthInfoCB"));
        asm(macro.import_function("sceHttp", "0x2C3C82CF", "sceHttpFlushAuthList"));
        asm(macro.import_function("sceHttp", "0x3A67F306", "sceHttpSetCookieRecvCallback"));
        asm(macro.import_function("sceHttp", "0x3C478044", "sceHttp_3C478044"));
        asm(macro.import_function("sceHttp", "0x3EABA285", "sceHttpAddExtraHeader"));
        asm(macro.import_function("sceHttp", "0x457D221D", "sceHttp_457D221D"));
        asm(macro.import_function("sceHttp", "0x47347B50", "sceHttpCreateRequest"));
        asm(macro.import_function("sceHttp", "0x47940436", "sceHttpSetResolveTimeOut"));
        asm(macro.import_function("sceHttp", "0x4CC7D78F", "sceHttpGetStatusCode"));
        asm(macro.import_function("sceHttp", "0x4E4A284A", "sceHttp_4E4A284A"));
        asm(macro.import_function("sceHttp", "0x5152773B", "sceHttpDeleteConnection"));
        asm(macro.import_function("sceHttp", "0x54E7DF75", "sceHttpIsRequestInCache"));
        asm(macro.import_function("sceHttp", "0x569A1481", "sceHttpsSetSslCallback"));
        asm(macro.import_function("sceHttp", "0x59E6D16F", "sceHttpEnableCache"));
        asm(macro.import_function("sceHttp", "0x68AB0F86", "sceHttpsInitWithPath"));
        asm(macro.import_function("sceHttp", "0x739C2D79", "sceHttp_739C2D79"));
        asm(macro.import_function("sceHttp", "0x76D1363B", "sceHttpSaveSystemCookie"));
        asm(macro.import_function("sceHttp", "0x7774BF4C", "sceHttpAddCookie"));
        asm(macro.import_function("sceHttp", "0x77EE5319", "sceHttp_77EE5319"));
        asm(macro.import_function("sceHttp", "0x78A0D3EC", "sceHttpEnableKeepAlive"));
        asm(macro.import_function("sceHttp", "0x78B54C09", "sceHttpEndCache"));
        asm(macro.import_function("sceHttp", "0x8046E250", "sceHttp_8046E250"));
        asm(macro.import_function("sceHttp", "0x87797BDD", "sceHttpsLoadDefaultCert"));
        asm(macro.import_function("sceHttp", "0x87F1E666", "sceHttp_87F1E666"));
        asm(macro.import_function("sceHttp", "0x8ACD1F73", "sceHttpSetConnectTimeOut"));
        asm(macro.import_function("sceHttp", "0x8EEFD953", "sceHttpCreateConnection_stub"));
        asm(macro.generic_abi_wrapper("sceHttpCreateConnection", 5));
        asm(macro.import_function("sceHttp", "0x951D310E", "sceHttp_951D310E"));
        asm(macro.import_function("sceHttp", "0x9668864C", "sceHttpSetRecvBlockSize"));
        asm(macro.import_function("sceHttp", "0x96F16D3E", "sceHttpGetCookie"));
        asm(macro.import_function("sceHttp", "0x9988172D", "sceHttpSetSendTimeOut"));
        asm(macro.import_function("sceHttp", "0x9AFC98B2", "sceHttpSendRequestInCacheFirstMode"));
        asm(macro.import_function("sceHttp", "0x9B1F1F36", "sceHttpCreateTemplate"));
        asm(macro.import_function("sceHttp", "0x9FC5F10D", "sceHttpEnableAuth"));
        asm(macro.import_function("sceHttp", "0xA4496DE5", "sceHttpSetRedirectCallback"));
        asm(macro.import_function("sceHttp", "0xA461A167", "sceHttp_A461A167"));
        asm(macro.import_function("sceHttp", "0xA5512E01", "sceHttpDeleteRequest"));
        asm(macro.import_function("sceHttp", "0xA6800C34", "sceHttpInitCache"));
        asm(macro.import_function("sceHttp", "0xA909F2AE", "sceHttp_A909F2AE"));
        asm(macro.import_function("sceHttp", "0xAB1540D5", "sceHttpsGetSslError"));
        asm(macro.import_function("sceHttp", "0xAB1ABE07", "sceHttpInit"));
        asm(macro.import_function("sceHttp", "0xAE948FEE", "sceHttpDisableAuth"));
        asm(macro.import_function("sceHttp", "0xB0257723", "sceHttp_B0257723"));
        asm(macro.import_function("sceHttp", "0xB0C34B1D", "sceHttpSetCacheContentLengthMaxSize"));
        asm(macro.import_function("sceHttp", "0xB3FAF831", "sceHttpsDisableOption"));
        asm(macro.import_function("sceHttp", "0xB509B09E", "sceHttpCreateRequestWithURL"));
        asm(macro.import_function("sceHttp", "0xBAC31BF1", "sceHttpsEnableOption"));
        asm(macro.import_function("sceHttp", "0xBB70706F", "sceHttpSendRequest"));
        asm(macro.import_function("sceHttp", "0xC0E69162", "sceHttp_C0E69162"));
        asm(macro.import_function("sceHttp", "0xC10B6BD9", "sceHttpAbortRequest"));
        asm(macro.import_function("sceHttp", "0xC6330B0D", "sceHttp_C6330B0D"));
        asm(macro.import_function("sceHttp", "0xC7EF2559", "sceHttpDisableKeepAlive"));
        asm(macro.import_function("sceHttp", "0xC98CBBA7", "sceHttpSetResHeaderMaxSize"));
        asm(macro.import_function("sceHttp", "0xCC920C12", "sceHttp_CC920C12"));
        asm(macro.import_function("sceHttp", "0xCCBD167A", "sceHttpDisableCache"));
        asm(macro.import_function("sceHttp", "0xCDB0DC58", "sceHttp_CDB0DC58"));
        asm(macro.import_function("sceHttp", "0xCDF8ECB9", "sceHttpCreateConnectionWithURL"));
        asm(macro.import_function("sceHttp", "0xD081EC8F", "sceHttpGetNetworkErrno"));
        asm(macro.import_function("sceHttp", "0xD11DAB01", "sceHttpsGetCaList"));
        asm(macro.import_function("sceHttp", "0xD1C8945E", "sceHttpEnd"));
        asm(macro.import_function("sceHttp", "0xD29163DA", "sceHttp_D29163DA"));
        asm(macro.import_function("sceHttp", "0xD70D4847", "sceHttpGetProxy_stub"));
        asm(macro.generic_abi_wrapper("sceHttpGetProxy", 6));
        asm(macro.import_function("sceHttp", "0xD80BE761", "sceHttp_D80BE761"));
        asm(macro.import_function("sceHttp", "0xDB266CCF", "sceHttpGetAllHeader"));
        asm(macro.import_function("sceHttp", "0xDD6E7857", "sceHttp_DD6E7857"));
        asm(macro.import_function("sceHttp", "0xE4D21302", "sceHttpsInit"));
        asm(macro.import_function("sceHttp", "0xEDEEB999", "sceHttpReadData"));
        asm(macro.import_function("sceHttp", "0xF0F46C62", "sceHttpSetProxy_stub"));
        asm(macro.generic_abi_wrapper("sceHttpSetProxy", 5));
        asm(macro.import_function("sceHttp", "0xF1657B22", "sceHttpLoadSystemCookie"));
        asm(macro.import_function("sceHttp", "0xF49934F6", "sceHttpSetMallocFunction"));
        asm(macro.import_function("sceHttp", "0xF9D8EB63", "sceHttpsEnd"));
        asm(macro.import_function("sceHttp", "0xFCF8C055", "sceHttpDeleteTemplate"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceNet") and options.include_sceNet)) {
        asm(macro.import_module_start("sceNet", "0x00090000", "8"));
        asm(macro.import_function("sceNet", "0x39AF39A6", "sceNetInit_stub"));
        asm(macro.generic_abi_wrapper("sceNetInit", 5));
        asm(macro.import_function("sceNet", "0x281928A9", "sceNetTerm"));
        asm(macro.import_function("sceNet", "0x50647530", "sceNetFreeThreadinfo"));
        asm(macro.import_function("sceNet", "0xAD6844C6", "sceNetThreadAbort"));
        asm(macro.import_function("sceNet", "0x89360950", "sceNetEtherNtostr"));
        asm(macro.import_function("sceNet", "0xD27961C9", "sceNetEtherStrton"));
        asm(macro.import_function("sceNet", "0x0BF0A3AE", "sceNetGetLocalEtherAddr"));
        asm(macro.import_function("sceNet", "0xCC393E48", "sceNetGetMallocStat"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceNetResolver") and options.include_sceNetResolver)) {
        asm(macro.import_module_start("sceNetResolver", "0x00090000", "7"));
        asm(macro.import_function("sceNetResolver", "0xF3370E61", "sceNetResolverInit"));
        asm(macro.import_function("sceNetResolver", "0x6138194A", "sceNetResolverTerm"));
        asm(macro.import_function("sceNetResolver", "0x244172AF", "sceNetResolverCreate"));
        asm(macro.import_function("sceNetResolver", "0x94523E09", "sceNetResolverDelete"));
        asm(macro.import_function("sceNetResolver", "0x224C5F44", "sceNetResolverStartNtoA_stub"));
        asm(macro.generic_abi_wrapper("sceNetResolverStartNtoA", 5));
        asm(macro.import_function("sceNetResolver", "0x629E2FB7", "sceNetResolverStartAtoN_stub"));
        asm(macro.generic_abi_wrapper("sceNetResolverStartAtoN", 6));
        asm(macro.import_function("sceNetResolver", "0x808F6063", "sceNetResolverStop"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceNet_lib") and options.include_sceNet_lib)) {
        asm(macro.import_module_start("sceNet_lib", "0x00090000", "96"));
        asm(macro.import_function("sceNet_lib", "0x3B617AA0", "sceNet_lib_3B617AA0"));
        asm(macro.import_function("sceNet_lib", "0xDB88F458", "sceNet_lib_DB88F458"));
        asm(macro.import_function("sceNet_lib", "0xB6FC0A5B", "sceNet_lib_B6FC0A5B"));
        asm(macro.import_function("sceNet_lib", "0xC431A214", "sceNet_lib_C431A214"));
        asm(macro.import_function("sceNet_lib", "0xBFCFEFF6", "sceNet_lib_BFCFEFF6"));
        asm(macro.import_function("sceNet_lib", "0xE1F4696F", "sceNet_lib_E1F4696F"));
        asm(macro.import_function("sceNet_lib", "0x5216CBF5", "sceNet_lib_5216CBF5"));
        asm(macro.import_function("sceNet_lib", "0xD2422E4D", "sceNet_lib_D2422E4D"));
        asm(macro.import_function("sceNet_lib", "0xD1BE2CE9", "sceNet_lib_D1BE2CE9"));
        asm(macro.import_function("sceNet_lib", "0xAB7DD9A5", "sceNet_lib_AB7DD9A5"));
        asm(macro.import_function("sceNet_lib", "0x80E1933E", "sceNet_lib_80E1933E"));
        asm(macro.import_function("sceNet_lib", "0x7BA3ED91", "sceNet_lib_7BA3ED91"));
        asm(macro.import_function("sceNet_lib", "0x03164B12", "sceNet_lib_03164B12"));
        asm(macro.import_function("sceNet_lib", "0x389728AB", "sceNet_lib_389728AB"));
        asm(macro.import_function("sceNet_lib", "0x4BF9E1DE", "sceNet_lib_4BF9E1DE"));
        asm(macro.import_function("sceNet_lib", "0xD5B64E37", "sceNet_lib_D5B64E37"));
        asm(macro.import_function("sceNet_lib", "0xDA02F383", "sceNet_lib_DA02F383"));
        asm(macro.import_function("sceNet_lib", "0xAFA11338", "sceNet_lib_AFA11338"));
        asm(macro.import_function("sceNet_lib", "0xB20F84F8", "sceNet_lib_B20F84F8"));
        asm(macro.import_function("sceNet_lib", "0x83FE280A", "sceNet_lib_83FE280A"));
        asm(macro.import_function("sceNet_lib", "0x4F8F3808", "sceNet_lib_4F8F3808"));
        asm(macro.import_function("sceNet_lib", "0x891723D5", "sceNet_lib_891723D5"));
        asm(macro.import_function("sceNet_lib", "0x0DFF67F9", "sceNet_lib_0DFF67F9"));
        asm(macro.import_function("sceNet_lib", "0xF355C73B", "sceNet_lib_F355C73B"));
        asm(macro.import_function("sceNet_lib", "0xA55C914F", "sceNet_lib_A55C914F"));
        asm(macro.import_function("sceNet_lib", "0x0D633F53", "sceNet_lib_0D633F53"));
        asm(macro.import_function("sceNet_lib", "0x8D33C11D", "sceNetConfigGetEtherAddr"));
        asm(macro.import_function("sceNet_lib", "0x522A971B", "sceNet_lib_522A971B"));
        asm(macro.import_function("sceNet_lib", "0x1858883D", "sceNetRand"));
        asm(macro.import_function("sceNet_lib", "0x75D9985C", "sceNet_lib_75D9985C"));
        asm(macro.import_function("sceNet_lib", "0x25CC373A", "sceNet_lib_25CC373A"));
        asm(macro.import_function("sceNet_lib", "0xDCBC596E", "sceNet_lib_DCBC596E"));
        asm(macro.import_function("sceNet_lib", "0x7C86FBA4", "sceNet_lib_7C86FBA4"));
        asm(macro.import_function("sceNet_lib", "0xA8B6205A", "sceNet_lib_A8B6205A"));
        asm(macro.import_function("sceNet_lib", "0xA93A93E9", "sceNet_lib_A93A93E9"));
        asm(macro.import_function("sceNet_lib", "0x6B294EE4", "sceNet_lib_6B294EE4"));
        asm(macro.import_function("sceNet_lib", "0x51C209B2", "sceNet_lib_51C209B2"));
        asm(macro.import_function("sceNet_lib", "0xC9C97945", "sceNet_lib_C9C97945"));
        asm(macro.import_function("sceNet_lib", "0xB8C4A858", "sceNet_lib_B8C4A858"));
        asm(macro.import_function("sceNet_lib", "0x205E8D17", "sceNet_lib_205E8D17"));
        asm(macro.import_function("sceNet_lib", "0xF6DB0A0B", "sceNet_lib_F6DB0A0B"));
        asm(macro.import_function("sceNet_lib", "0x7574FDA1", "sceNet_lib_7574FDA1"));
        asm(macro.import_function("sceNet_lib", "0xCA3CF5EB", "sceNet_lib_CA3CF5EB"));
        asm(macro.import_function("sceNet_lib", "0x757085B0", "sceNet_lib_757085B0"));
        asm(macro.import_function("sceNet_lib", "0x435843CB", "sceNet_lib_435843CB"));
        asm(macro.import_function("sceNet_lib", "0xD861EF33", "sceNet_lib_D861EF33"));
        asm(macro.import_function("sceNet_lib", "0xBB2B3DDB", "sceNet_lib_BB2B3DDB"));
        asm(macro.import_function("sceNet_lib", "0x6D5D42D7", "sceNet_lib_6D5D42D7"));
        asm(macro.import_function("sceNet_lib", "0xC21E18B2", "sceNet_lib_C21E18B2"));
        asm(macro.import_function("sceNet_lib", "0x45452B7B", "sceNet_lib_45452B7B"));
        asm(macro.import_function("sceNet_lib", "0x94B44F26", "sceNet_lib_94B44F26"));
        asm(macro.import_function("sceNet_lib", "0x515B2F33", "sceNet_lib_515B2F33"));
        asm(macro.import_function("sceNet_lib", "0x6DC71518", "sceNet_lib_6DC71518"));
        asm(macro.import_function("sceNet_lib", "0x7C3B86C5", "sceNet_lib_7C3B86C5"));
        asm(macro.import_function("sceNet_lib", "0x05D525E4", "sceNet_lib_05D525E4"));
        asm(macro.import_function("sceNet_lib", "0x1D10419C", "sceNet_lib_1D10419C"));
        asm(macro.import_function("sceNet_lib", "0xC2EC2EEA", "sceNet_lib_C2EC2EEA"));
        asm(macro.import_function("sceNet_lib", "0x710BD467", "sceNet_lib_710BD467"));
        asm(macro.import_function("sceNet_lib", "0x701DDDC3", "sceNet_lib_701DDDC3"));
        asm(macro.import_function("sceNet_lib", "0xD5A03BC0", "sceNet_lib_D5A03BC0"));
        asm(macro.import_function("sceNet_lib", "0xFA6DE6A6", "sceNet_lib_FA6DE6A6"));
        asm(macro.import_function("sceNet_lib", "0xEDB11CB4", "sceNet_lib_EDB11CB4"));
        asm(macro.import_function("sceNet_lib", "0x8C55B410", "sceNet_lib_8C55B410"));
        asm(macro.import_function("sceNet_lib", "0x13A8B98A", "sceNet_lib_13A8B98A"));
        asm(macro.import_function("sceNet_lib", "0xEA42B353", "sceNet_lib_EA42B353"));
        asm(macro.import_function("sceNet_lib", "0x45945E8D", "sceNet_lib_45945E8D"));
        asm(macro.import_function("sceNet_lib", "0xD60225A3", "sceNet_lib_D60225A3"));
        asm(macro.import_function("sceNet_lib", "0xEB6DE71A", "sceNet_lib_EB6DE71A"));
        asm(macro.import_function("sceNet_lib", "0xEDCC871E", "sceNet_lib_EDCC871E"));
        asm(macro.import_function("sceNet_lib", "0x4B2B3416", "sceNet_lib_4B2B3416"));
        asm(macro.import_function("sceNet_lib", "0x2B42872F", "sceNet_lib_2B42872F"));
        asm(macro.import_function("sceNet_lib", "0xC4261339", "sceNet_lib_C4261339"));
        asm(macro.import_function("sceNet_lib", "0x41FD8B5C", "sceNet_lib_41FD8B5C"));
        asm(macro.import_function("sceNet_lib", "0x92633D8D", "sceNet_lib_92633D8D"));
        asm(macro.import_function("sceNet_lib", "0xB9C780C7", "sceNet_lib_B9C780C7"));
        asm(macro.import_function("sceNet_lib", "0xB68E1EEA", "sceNet_lib_B68E1EEA"));
        asm(macro.import_function("sceNet_lib", "0xE155112D", "sceNet_lib_E155112D"));
        asm(macro.import_function("sceNet_lib", "0x41621EB0", "sceNet_lib_41621EB0"));
        asm(macro.import_function("sceNet_lib", "0x2E005032", "sceNet_lib_2E005032"));
        asm(macro.import_function("sceNet_lib", "0x33B230BD", "sceNet_lib_33B230BD"));
        asm(macro.import_function("sceNet_lib", "0x976AB1E9", "sceNet_lib_976AB1E9"));
        asm(macro.import_function("sceNet_lib", "0x4C8FD452", "sceNet_lib_4C8FD452"));
        asm(macro.import_function("sceNet_lib", "0x5ED457BE", "sceNet_lib_5ED457BE"));
        asm(macro.import_function("sceNet_lib", "0x31F3CDA1", "sceNet_lib_31F3CDA1"));
        asm(macro.import_function("sceNet_lib", "0x1F94AFD9", "sceNet_lib_1F94AFD9"));
        asm(macro.import_function("sceNet_lib", "0x0A5A8751", "sceNet_lib_0A5A8751"));
        asm(macro.import_function("sceNet_lib", "0xB3A48B7F", "sceNet_lib_B3A48B7F"));
        asm(macro.import_function("sceNet_lib", "0x949F1FBB", "sceNet_lib_949F1FBB"));
        asm(macro.import_function("sceNet_lib", "0x13672F83", "sceNet_lib_13672F83"));
        asm(macro.import_function("sceNet_lib", "0x5C7C7381", "sceNet_lib_5C7C7381"));
        asm(macro.import_function("sceNet_lib", "0x86B6DCD9", "sceNet_lib_86B6DCD9"));
        asm(macro.import_function("sceNet_lib", "0x7AE91FB4", "sceNet_lib_7AE91FB4"));
        asm(macro.import_function("sceNet_lib", "0x572AD6ED", "sceNet_lib_572AD6ED"));
        asm(macro.import_function("sceNet_lib", "0x87DC7A7E", "sceNet_lib_87DC7A7E"));
        asm(macro.import_function("sceNet_lib", "0x991FF86D", "sceNet_lib_991FF86D"));
        asm(macro.import_function("sceNet_lib", "0x5505D820", "sceNet_lib_5505D820"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceNetAdhocctl") and options.include_sceNetAdhocctl)) {
        asm(macro.import_module_start("sceNetAdhocctl", "0x00090000", "21"));
        asm(macro.import_function("sceNetAdhocctl", "0xE26F226E", "sceNetAdhocctlInit"));
        asm(macro.import_function("sceNetAdhocctl", "0x9D689E13", "sceNetAdhocctlTerm"));
        asm(macro.import_function("sceNetAdhocctl", "0x0AD043ED", "sceNetAdhocctlConnect"));
        asm(macro.import_function("sceNetAdhocctl", "0xEC0635C1", "sceNetAdhocctlCreate"));
        asm(macro.import_function("sceNetAdhocctl", "0x5E7F79C9", "sceNetAdhocctlJoin"));
        asm(macro.import_function("sceNetAdhocctl", "0x08FFF7A0", "sceNetAdhocctlScan"));
        asm(macro.import_function("sceNetAdhocctl", "0x34401D65", "sceNetAdhocctlDisconnect"));
        asm(macro.import_function("sceNetAdhocctl", "0x20B317A0", "sceNetAdhocctlAddHandler"));
        asm(macro.import_function("sceNetAdhocctl", "0x6402490B", "sceNetAdhocctlDelHandler"));
        asm(macro.import_function("sceNetAdhocctl", "0x75ECD386", "sceNetAdhocctlGetState"));
        asm(macro.import_function("sceNetAdhocctl", "0x362CBE8F", "sceNetAdhocctlGetAdhocId"));
        asm(macro.import_function("sceNetAdhocctl", "0xE162CB14", "sceNetAdhocctlGetPeerList"));
        asm(macro.import_function("sceNetAdhocctl", "0x99560ABE", "sceNetAdhocctlGetAddrByName"));
        asm(macro.import_function("sceNetAdhocctl", "0x8916C003", "sceNetAdhocctlGetNameByAddr"));
        asm(macro.import_function("sceNetAdhocctl", "0xDED9D28E", "sceNetAdhocctlGetParameter"));
        asm(macro.import_function("sceNetAdhocctl", "0x81AEE1BE", "sceNetAdhocctlGetScanInfo"));
        asm(macro.import_function("sceNetAdhocctl", "0xA5C055CE", "sceNetAdhocctlCreateEnterGameMode_stub"));
        asm(macro.generic_abi_wrapper("sceNetAdhocctlCreateEnterGameMode", 6));
        asm(macro.import_function("sceNetAdhocctl", "0x1FF89745", "sceNetAdhocctlJoinEnterGameMode"));
        asm(macro.import_function("sceNetAdhocctl", "0xCF8E084D", "sceNetAdhocctlExitGameMode"));
        asm(macro.import_function("sceNetAdhocctl", "0x5A014CE0", "sceNetAdhocctlGetGameModeInfo"));
        asm(macro.import_function("sceNetAdhocctl", "0x8DB83FDC", "sceNetAdhocctlGetPeerInfo"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceNetAdhocMatching") and options.include_sceNetAdhocMatching)) {
        asm(macro.import_module_start("sceNetAdhocMatching", "0x00090000", "16"));
        asm(macro.import_function("sceNetAdhocMatching", "0x2A2A1E07", "sceNetAdhocMatchingInit"));
        asm(macro.import_function("sceNetAdhocMatching", "0x7945ECDA", "sceNetAdhocMatchingTerm"));
        asm(macro.import_function("sceNetAdhocMatching", "0xCA5EDA6F", "sceNetAdhocMatchingCreate_stub"));
        asm(macro.generic_abi_wrapper("sceNetAdhocMatchingCreate", 9));
        asm(macro.import_function("sceNetAdhocMatching", "0x93EF3843", "sceNetAdhocMatchingStart_stub"));
        asm(macro.generic_abi_wrapper("sceNetAdhocMatchingStart", 7));
        asm(macro.import_function("sceNetAdhocMatching", "0x32B156B3", "sceNetAdhocMatchingStop"));
        asm(macro.import_function("sceNetAdhocMatching", "0xF16EAF4F", "sceNetAdhocMatchingDelete"));
        asm(macro.import_function("sceNetAdhocMatching", "0x5E3D4B79", "sceNetAdhocMatchingSelectTarget"));
        asm(macro.import_function("sceNetAdhocMatching", "0xEA3C6108", "sceNetAdhocMatchingCancelTarget"));
        asm(macro.import_function("sceNetAdhocMatching", "0xB58E61B7", "sceNetAdhocMatchingSetHelloOpt"));
        asm(macro.import_function("sceNetAdhocMatching", "0xB5D96C2A", "sceNetAdhocMatchingGetHelloOpt"));
        asm(macro.import_function("sceNetAdhocMatching", "0xC58BCD9E", "sceNetAdhocMatchingGetMembers"));
        asm(macro.import_function("sceNetAdhocMatching", "0x40F8F435", "sceNetAdhocMatchingGetPoolMaxAlloc"));
        asm(macro.import_function("sceNetAdhocMatching", "0x8F58BEDF", "sceNetAdhocMatchingCancelTargetWithOpt"));
        asm(macro.import_function("sceNetAdhocMatching", "0x9C5CFB7D", "sceNetAdhocMatchingGetPoolStat"));
        asm(macro.import_function("sceNetAdhocMatching", "0xF79472D7", "sceNetAdhocMatchingSendData"));
        asm(macro.import_function("sceNetAdhocMatching", "0xEC19337D", "sceNetAdhocMatchingAbortSendData"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceNetAdhoc") and options.include_sceNetAdhoc)) {
        asm(macro.import_module_start("sceNetAdhoc", "0x00090000", "25"));
        asm(macro.import_function("sceNetAdhoc", "0xE1D621D7", "sceNetAdhocInit"));
        asm(macro.import_function("sceNetAdhoc", "0xA62C6F57", "sceNetAdhocTerm"));
        asm(macro.import_function("sceNetAdhoc", "0x7A662D6B", "sceNetAdhocPollSocket"));
        asm(macro.import_function("sceNetAdhoc", "0x73BFD52D", "sceNetAdhocSetSocketAlert"));
        asm(macro.import_function("sceNetAdhoc", "0x4D2CE199", "sceNetAdhocGetSocketAlert"));
        asm(macro.import_function("sceNetAdhoc", "0x6F92741B", "sceNetAdhocPdpCreate"));
        asm(macro.import_function("sceNetAdhoc", "0xABED3790", "sceNetAdhocPdpSend_stub"));
        asm(macro.generic_abi_wrapper("sceNetAdhocPdpSend", 7));
        asm(macro.import_function("sceNetAdhoc", "0xDFE53E03", "sceNetAdhocPdpRecv_stub"));
        asm(macro.generic_abi_wrapper("sceNetAdhocPdpRecv", 7));
        asm(macro.import_function("sceNetAdhoc", "0x7F27BB5E", "sceNetAdhocPdpDelete"));
        asm(macro.import_function("sceNetAdhoc", "0xC7C1FC57", "sceNetAdhocGetPdpStat"));
        asm(macro.import_function("sceNetAdhoc", "0x877F6D66", "sceNetAdhocPtpOpen_stub"));
        asm(macro.generic_abi_wrapper("sceNetAdhocPtpOpen", 8));
        asm(macro.import_function("sceNetAdhoc", "0xFC6FC07B", "sceNetAdhocPtpConnect"));
        asm(macro.import_function("sceNetAdhoc", "0xE08BDAC1", "sceNetAdhocPtpListen_stub"));
        asm(macro.generic_abi_wrapper("sceNetAdhocPtpListen", 7));
        asm(macro.import_function("sceNetAdhoc", "0x9DF81198", "sceNetAdhocPtpAccept_stub"));
        asm(macro.generic_abi_wrapper("sceNetAdhocPtpAccept", 5));
        asm(macro.import_function("sceNetAdhoc", "0x4DA4C788", "sceNetAdhocPtpSend_stub"));
        asm(macro.generic_abi_wrapper("sceNetAdhocPtpSend", 5));
        asm(macro.import_function("sceNetAdhoc", "0x8BEA2B3E", "sceNetAdhocPtpRecv_stub"));
        asm(macro.generic_abi_wrapper("sceNetAdhocPtpRecv", 5));
        asm(macro.import_function("sceNetAdhoc", "0x9AC2EEAC", "sceNetAdhocPtpFlush"));
        asm(macro.import_function("sceNetAdhoc", "0x157E6225", "sceNetAdhocPtpClose"));
        asm(macro.import_function("sceNetAdhoc", "0xB9685118", "sceNetAdhocGetPtpStat"));
        asm(macro.import_function("sceNetAdhoc", "0x7F75C338", "sceNetAdhocGameModeCreateMaster"));
        asm(macro.import_function("sceNetAdhoc", "0x3278AB0C", "sceNetAdhocGameModeCreateReplica"));
        asm(macro.import_function("sceNetAdhoc", "0x98C204C8", "sceNetAdhocGameModeUpdateMaster"));
        asm(macro.import_function("sceNetAdhoc", "0xFA324B4E", "sceNetAdhocGameModeUpdateReplica"));
        asm(macro.import_function("sceNetAdhoc", "0xA0229362", "sceNetAdhocGameModeDeleteMaster"));
        asm(macro.import_function("sceNetAdhoc", "0x0B2228E9", "sceNetAdhocGameModeDeleteReplica"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceSsl") and options.include_sceSsl)) {
        asm(macro.import_module_start("sceSsl", "0x00090011", "11"));
        asm(macro.import_function("sceSsl", "0x058D21C0", "sceSslGetNameEntryCount"));
        asm(macro.import_function("sceSsl", "0x0EB43B06", "sceSslGetUsedMemoryCurrent"));
        asm(macro.import_function("sceSsl", "0x17A10DCC", "sceSslGetNotBefore"));
        asm(macro.import_function("sceSsl", "0x191CDEFF", "sceSslEnd"));
        asm(macro.import_function("sceSsl", "0x1B7C8191", "sceSslGetIssuerName"));
        asm(macro.import_function("sceSsl", "0x3DD5E023", "sceSslGetSubjectName"));
        asm(macro.import_function("sceSsl", "0x5BFB6B61", "sceSslGetNotAfter"));
        asm(macro.import_function("sceSsl", "0x957ECBE2", "sceSslInit"));
        asm(macro.import_function("sceSsl", "0xB99EDE6A", "sceSslGetUsedMemoryMax"));
        asm(macro.import_function("sceSsl", "0xCC0919B0", "sceSslGetSerialNumber"));
        asm(macro.import_function("sceSsl", "0xD6D097B4", "sceSslGetNameEntryInfo"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceJpeg") and options.include_sceJpeg)) {
        asm(macro.import_module_start("sceJpeg", "0x00090000", "13"));
        asm(macro.import_function("sceJpeg", "0x0425B986", "sceJpeg_0425B986"));
        asm(macro.import_function("sceJpeg", "0x04B5AE02", "sceJpegMJpegCsc"));
        asm(macro.import_function("sceJpeg", "0x04B93CEF", "sceJpegDecodeMJpeg"));
        asm(macro.import_function("sceJpeg", "0x227662D7", "sceJpeg_227662D7"));
        asm(macro.import_function("sceJpeg", "0x48B602B7", "sceJpegDeleteMJpeg"));
        asm(macro.import_function("sceJpeg", "0x64B6F978", "sceJpeg_64B6F978"));
        asm(macro.import_function("sceJpeg", "0x67F0ED84", "sceJpeg_67F0ED84"));
        asm(macro.import_function("sceJpeg", "0x7D2F3D7F", "sceJpegFinishMJpeg"));
        asm(macro.import_function("sceJpeg", "0x8F2BB012", "sceJpegGetOutputInfo"));
        asm(macro.import_function("sceJpeg", "0x91EED83C", "sceJpegDecodeMJpegYCbCr"));
        asm(macro.import_function("sceJpeg", "0x9B36444C", "sceJpeg_9B36444C"));
        asm(macro.import_function("sceJpeg", "0x9D47469C", "sceJpegCreateMJpeg"));
        asm(macro.import_function("sceJpeg", "0xAC9E70E6", "sceJpegInitMJpeg"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceMpegbase") and options.include_sceMpegbase)) {
        asm(macro.import_module_start("sceMpegbase", "0x00090000", "9"));
        asm(macro.import_function("sceMpegbase", "0xBE45C284", "sceMpegBaseYCrCbCopyVme"));
        asm(macro.import_function("sceMpegbase", "0x492B5E4B", "sceMpegBaseCscInit"));
        asm(macro.import_function("sceMpegbase", "0xCE8EB837", "sceMpegBaseCscVme"));
        asm(macro.import_function("sceMpegbase", "0x0530BE4E", "sceMpegbase_0530BE4E"));
        asm(macro.import_function("sceMpegbase", "0x304882E1", "sceMpegbase_304882E1"));
        asm(macro.import_function("sceMpegbase", "0x7AC0321A", "sceMpegBaseYCrCbCopy"));
        asm(macro.import_function("sceMpegbase", "0x91929A21", "sceMpegBaseCscAvc"));
        asm(macro.import_function("sceMpegbase", "0xAC9E717E", "sceMpegbase_AC9E717E"));
        asm(macro.import_function("sceMpegbase", "0xBEA18F91", "sceMpegbase_BEA18F91"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceMpeg") and options.include_sceMpeg)) {
        asm(macro.import_module_start("sceMpeg", "0x00090000", "38"));
        asm(macro.import_function("sceMpeg", "0x21FF80E4", "sceMpegQueryStreamOffset"));
        asm(macro.import_function("sceMpeg", "0x611E9E11", "sceMpegQueryStreamSize"));
        asm(macro.import_function("sceMpeg", "0x682A619B", "sceMpegInit"));
        asm(macro.import_function("sceMpeg", "0x874624D6", "sceMpegFinish"));
        asm(macro.import_function("sceMpeg", "0xC132E22F", "sceMpegQueryMemSize"));
        asm(macro.import_function("sceMpeg", "0xD8C5F121", "sceMpegCreate_stub"));
        asm(macro.generic_abi_wrapper("sceMpegCreate", 7));
        asm(macro.import_function("sceMpeg", "0x606A4649", "sceMpegDelete"));
        asm(macro.import_function("sceMpeg", "0x42560F23", "sceMpegRegistStream"));
        asm(macro.import_function("sceMpeg", "0x591A4AA2", "sceMpegUnRegistStream"));
        asm(macro.import_function("sceMpeg", "0xA780CF7E", "sceMpegMallocAvcEsBuf"));
        asm(macro.import_function("sceMpeg", "0xCEB870B1", "sceMpegFreeAvcEsBuf"));
        asm(macro.import_function("sceMpeg", "0xF8DCB679", "sceMpegQueryAtracEsSize"));
        asm(macro.import_function("sceMpeg", "0xC02CF6B5", "sceMpegQueryPcmEsSize"));
        asm(macro.import_function("sceMpeg", "0x167AFD9E", "sceMpegInitAu"));
        asm(macro.import_function("sceMpeg", "0x234586AE", "sceMpegChangeGetAvcAuMode"));
        asm(macro.import_function("sceMpeg", "0x9DCFB7EA", "sceMpegChangeGetAuMode"));
        asm(macro.import_function("sceMpeg", "0xFE246728", "sceMpegGetAvcAu"));
        asm(macro.import_function("sceMpeg", "0x8C1E027D", "sceMpegGetPcmAu"));
        asm(macro.import_function("sceMpeg", "0xE1CE83A7", "sceMpegGetAtracAu"));
        asm(macro.import_function("sceMpeg", "0x500F0429", "sceMpegFlushStream"));
        asm(macro.import_function("sceMpeg", "0x707B7629", "sceMpegFlushAllStream"));
        asm(macro.import_function("sceMpeg", "0x0E3C2E9D", "sceMpegAvcDecode_stub"));
        asm(macro.generic_abi_wrapper("sceMpegAvcDecode", 5));
        asm(macro.import_function("sceMpeg", "0x0F6C18D7", "sceMpegAvcDecodeDetail"));
        asm(macro.import_function("sceMpeg", "0xA11C7026", "sceMpegAvcDecodeMode"));
        asm(macro.import_function("sceMpeg", "0x740FCCD1", "sceMpegAvcDecodeStop"));
        asm(macro.import_function("sceMpeg", "0x800C44DF", "sceMpegAtracDecode"));
        asm(macro.import_function("sceMpeg", "0xD7A29F46", "sceMpegRingbufferQueryMemSize"));
        asm(macro.import_function("sceMpeg", "0x37295ED8", "sceMpegRingbufferConstruct_stub"));
        asm(macro.generic_abi_wrapper("sceMpegRingbufferConstruct", 6));
        asm(macro.import_function("sceMpeg", "0x13407F13", "sceMpegRingbufferDestruct"));
        asm(macro.import_function("sceMpeg", "0xB240A59E", "sceMpegRingbufferPut"));
        asm(macro.import_function("sceMpeg", "0xB5F6DC87", "sceMpegRingbufferAvailableSize"));
        asm(macro.import_function("sceMpeg", "0x11CAB459", "sceMpeg_11CAB459"));
        asm(macro.import_function("sceMpeg", "0x3C37A7A6", "sceMpeg_3C37A7A6"));
        asm(macro.import_function("sceMpeg", "0xB27711A8", "sceMpeg_B27711A8"));
        asm(macro.import_function("sceMpeg", "0xD4DD6E75", "sceMpeg_D4DD6E75"));
        asm(macro.import_function("sceMpeg", "0xC345DED2", "sceMpeg_C345DED2"));
        asm(macro.import_function("sceMpeg", "0xCF3547A2", "sceMpegAvcDecodeDetail2"));
        asm(macro.import_function("sceMpeg", "0x988E9E12", "sceMpeg_988E9E12"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceHprm") and options.include_sceHprm)) {
        asm(macro.import_module_start("sceHprm", "0x40010000", "8"));
        asm(macro.import_function("sceHprm", "0xC7154136", "sceHprmRegisterCallback"));
        asm(macro.import_function("sceHprm", "0x444ED0B7", "sceHprmUnregisterCallback"));
        asm(macro.import_function("sceHprm", "0x208DB1BD", "sceHprmIsRemoteExist"));
        asm(macro.import_function("sceHprm", "0x7E69EDA4", "sceHprmIsHeadphoneExist"));
        asm(macro.import_function("sceHprm", "0x219C58F1", "sceHprmIsMicrophoneExist"));
        asm(macro.import_function("sceHprm", "0x1910B327", "sceHprmPeekCurrentKey"));
        asm(macro.import_function("sceHprm", "0x2BCEC83E", "sceHprmPeekLatch"));
        asm(macro.import_function("sceHprm", "0x40D2F9F0", "sceHprmReadLatch"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceUmdUser") and options.include_sceUmdUser)) {
        asm(macro.import_module_start("sceUmdUser", "0x40010011", "14"));
        asm(macro.import_function("sceUmdUser", "0x20628E6F", "sceUmdGetErrorStat"));
        asm(macro.import_function("sceUmdUser", "0x340B7686", "sceUmdGetDiscInfo"));
        asm(macro.import_function("sceUmdUser", "0x46EBB729", "sceUmdCheckMedium"));
        asm(macro.import_function("sceUmdUser", "0x4A9E5E29", "sceUmdWaitDriveStatCB"));
        asm(macro.import_function("sceUmdUser", "0x56202973", "sceUmdWaitDriveStatWithTimer"));
        asm(macro.import_function("sceUmdUser", "0x6AF9B50A", "sceUmdCancelWaitDriveStat"));
        asm(macro.import_function("sceUmdUser", "0x6B4A146C", "sceUmdGetDriveStat"));
        asm(macro.import_function("sceUmdUser", "0x87533940", "sceUmdReplaceProhibit"));
        asm(macro.import_function("sceUmdUser", "0x8EF08FCE", "sceUmdWaitDriveStat"));
        asm(macro.import_function("sceUmdUser", "0xAEE7404D", "sceUmdRegisterUMDCallBack"));
        asm(macro.import_function("sceUmdUser", "0xBD2BDE07", "sceUmdUnRegisterUMDCallBack"));
        asm(macro.import_function("sceUmdUser", "0xC6183D47", "sceUmdActivate"));
        asm(macro.import_function("sceUmdUser", "0xCBE9F02A", "sceUmdReplacePermit"));
        asm(macro.import_function("sceUmdUser", "0xE83742BA", "sceUmdDeactivate"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceCtrl") and options.include_sceCtrl)) {
        asm(macro.import_module_start("sceCtrl", "0x40010000", "16"));
        asm(macro.import_function("sceCtrl", "0x6A2774F3", "sceCtrlSetSamplingCycle"));
        asm(macro.import_function("sceCtrl", "0x02BAAD91", "sceCtrlGetSamplingCycle"));
        asm(macro.import_function("sceCtrl", "0x1F4011E6", "sceCtrlSetSamplingMode"));
        asm(macro.import_function("sceCtrl", "0xDA6B76A1", "sceCtrlGetSamplingMode"));
        asm(macro.import_function("sceCtrl", "0x3A622550", "sceCtrlPeekBufferPositive"));
        asm(macro.import_function("sceCtrl", "0xC152080A", "sceCtrlPeekBufferNegative"));
        asm(macro.import_function("sceCtrl", "0x1F803938", "sceCtrlReadBufferPositive"));
        asm(macro.import_function("sceCtrl", "0x60B81F86", "sceCtrlReadBufferNegative"));
        asm(macro.import_function("sceCtrl", "0xB1D0E5CD", "sceCtrlPeekLatch"));
        asm(macro.import_function("sceCtrl", "0x0B588501", "sceCtrlReadLatch"));
        asm(macro.import_function("sceCtrl", "0x348D99D4", "sceCtrl_348D99D4"));
        asm(macro.import_function("sceCtrl", "0xAF5960F3", "sceCtrl_AF5960F3"));
        asm(macro.import_function("sceCtrl", "0xA68FD260", "sceCtrlClearRapidFire"));
        asm(macro.import_function("sceCtrl", "0x6841BE1A", "sceCtrlSetRapidFire"));
        asm(macro.import_function("sceCtrl", "0xA7144800", "sceCtrlSetIdleCancelThreshold"));
        asm(macro.import_function("sceCtrl", "0x687660FA", "sceCtrlGetIdleCancelThreshold"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_LoadExecForUser") and options.include_LoadExecForUser)) {
        asm(macro.import_module_start("LoadExecForUser", "0x40010000", "4"));
        asm(macro.import_function("LoadExecForUser", "0xBD2F1094", "sceKernelLoadExec"));
        asm(macro.import_function("LoadExecForUser", "0x2AC9954B", "sceKernelExitGameWithStatus"));
        asm(macro.import_function("LoadExecForUser", "0x05572A5F", "sceKernelExitGame"));
        asm(macro.import_function("LoadExecForUser", "0x4AC57943", "sceKernelRegisterExitCallback"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_Kernel_Library") and options.include_Kernel_Library)) {
        asm(macro.import_module_start("Kernel_Library", "0x00010000", "8"));
        asm(macro.import_function("Kernel_Library", "0x092968F4", "sceKernelCpuSuspendIntr"));
        asm(macro.import_function("Kernel_Library", "0x5F10D406", "sceKernelCpuResumeIntr"));
        asm(macro.import_function("Kernel_Library", "0x3B84732D", "sceKernelCpuResumeIntrWithSync"));
        asm(macro.import_function("Kernel_Library", "0x47A0B729", "sceKernelIsCpuIntrSuspended"));
        asm(macro.import_function("Kernel_Library", "0xB55249D2", "sceKernelIsCpuIntrEnable"));
        asm(macro.import_function("Kernel_Library", "0xBEA46419", "sceKernelLockLwMutex"));
        asm(macro.import_function("Kernel_Library", "0x15B6446B", "sceKernelUnlockLwMutex"));
        asm(macro.import_function("Kernel_Library", "0xDC692EE3", "sceKernelTryLockLwMutex"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceImpose") and options.include_sceImpose)) {
        asm(macro.import_module_start("sceImpose", "0x40010011", "15"));
        asm(macro.import_function("sceImpose", "0x0F341BE4", "sceImposeGetHomePopup"));
        asm(macro.import_function("sceImpose", "0x24FD7BCF", "sceImposeGetLanguageMode"));
        asm(macro.import_function("sceImpose", "0x36AA6E91", "sceImposeSetLanguageMode"));
        asm(macro.import_function("sceImpose", "0x381BD9E7", "sceImposeHomeButton"));
        asm(macro.import_function("sceImpose", "0x5595A71A", "sceImposeSetHomePopup"));
        asm(macro.import_function("sceImpose", "0x72189C48", "sceImposeSetUMDPopup"));
        asm(macro.import_function("sceImpose", "0x8C943191", "sceImposeBatteryIconStatus"));
        asm(macro.import_function("sceImpose", "0x8F6E3518", "sceImposeGetBacklightOffTime"));
        asm(macro.import_function("sceImpose", "0x967F6D4A", "sceImposeSetBacklightOffTime"));
        asm(macro.import_function("sceImpose", "0x9BA61B49", "sceImpose_9BA61B49"));
        asm(macro.import_function("sceImpose", "0xA9884B00", "sceImpose_A9884B00"));
        asm(macro.import_function("sceImpose", "0xBB3F5DEC", "sceImpose_BB3F5DEC"));
        asm(macro.import_function("sceImpose", "0xE0887BC8", "sceImposeGetUMDPopup"));
        asm(macro.import_function("sceImpose", "0xFCD44963", "sceImpose_FCD44963"));
        asm(macro.import_function("sceImpose", "0xFF1A2F07", "sceImpose_FF1A2F07"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_SysMemUserForUser") and options.include_SysMemUserForUser)) {
        asm(macro.import_module_start("SysMemUserForUser", "0x40000000", "9"));
        asm(macro.import_function("SysMemUserForUser", "0xA291F107", "sceKernelMaxFreeMemSize"));
        asm(macro.import_function("SysMemUserForUser", "0xF919F628", "sceKernelTotalFreeMemSize"));
        asm(macro.import_function("SysMemUserForUser", "0x237DBD4F", "sceKernelAllocPartitionMemory_stub"));
        asm(macro.generic_abi_wrapper("sceKernelAllocPartitionMemory", 5));
        asm(macro.import_function("SysMemUserForUser", "0xB6D61D02", "sceKernelFreePartitionMemory"));
        asm(macro.import_function("SysMemUserForUser", "0x9D9A5BA1", "sceKernelGetBlockHeadAddr"));
        asm(macro.import_function("SysMemUserForUser", "0x3FC9AE6A", "sceKernelDevkitVersion"));
        asm(macro.import_function("SysMemUserForUser", "0x13A5ABEF", "sceKernelPrintf"));
        asm(macro.import_function("SysMemUserForUser", "0x7591C7DB", "sceKernelSetCompiledSdkVersion"));
        asm(macro.import_function("SysMemUserForUser", "0xFC114573", "sceKernelGetCompiledSdkVersion"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceSuspendForUser") and options.include_sceSuspendForUser)) {
        asm(macro.import_module_start("sceSuspendForUser", "0x40000000", "6"));
        asm(macro.import_function("sceSuspendForUser", "0xEADB1BD7", "sceKernelPowerLock"));
        asm(macro.import_function("sceSuspendForUser", "0x3AEE7261", "sceKernelPowerUnlock"));
        asm(macro.import_function("sceSuspendForUser", "0x090CCB3F", "sceKernelPowerTick"));
        asm(macro.import_function("sceSuspendForUser", "0x3E0271D3", "sceKernelVolatileMemLock"));
        asm(macro.import_function("sceSuspendForUser", "0xA14F40B2", "sceKernelVolatileMemTryLock"));
        asm(macro.import_function("sceSuspendForUser", "0xA569E425", "sceKernelVolatileMemUnlock"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_ModuleMgrForUser") and options.include_ModuleMgrForUser)) {
        asm(macro.import_module_start("ModuleMgrForUser", "0x40010000", "12"));
        asm(macro.import_function("ModuleMgrForUser", "0xB7F46618", "sceKernelLoadModuleByID"));
        asm(macro.import_function("ModuleMgrForUser", "0x977DE386", "sceKernelLoadModule"));
        asm(macro.import_function("ModuleMgrForUser", "0x710F61B5", "sceKernelLoadModuleMs"));
        asm(macro.import_function("ModuleMgrForUser", "0xF9275D98", "sceKernelLoadModuleBufferUsbWlan"));
        asm(macro.import_function("ModuleMgrForUser", "0x50F0C1EC", "sceKernelStartModule_stub"));
        asm(macro.generic_abi_wrapper("sceKernelStartModule", 5));
        asm(macro.import_function("ModuleMgrForUser", "0xD1FF982A", "sceKernelStopModule_stub"));
        asm(macro.generic_abi_wrapper("sceKernelStopModule", 5));
        asm(macro.import_function("ModuleMgrForUser", "0x2E0911AA", "sceKernelUnloadModule"));
        asm(macro.import_function("ModuleMgrForUser", "0xD675EBB8", "sceKernelSelfStopUnloadModule"));
        asm(macro.import_function("ModuleMgrForUser", "0xCC1D3699", "sceKernelStopUnloadSelfModule"));
        asm(macro.import_function("ModuleMgrForUser", "0x748CBED9", "sceKernelQueryModuleInfo"));
        asm(macro.import_function("ModuleMgrForUser", "0x644395E2", "sceKernelGetModuleIdList"));
        asm(macro.import_function("ModuleMgrForUser", "0xD8B73127", "sceKernelGetModuleIdByAddress"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_IoFileMgrForUser") and options.include_IoFileMgrForUser)) {
        asm(macro.import_module_start("IoFileMgrForUser", "0x40010000", "36"));
        asm(macro.import_function("IoFileMgrForUser", "0x3251EA56", "sceIoPollAsync"));
        asm(macro.import_function("IoFileMgrForUser", "0xE23EEC33", "sceIoWaitAsync"));
        asm(macro.import_function("IoFileMgrForUser", "0x35DBD746", "sceIoWaitAsyncCB"));
        asm(macro.import_function("IoFileMgrForUser", "0xCB05F8D6", "sceIoGetAsyncStat"));
        asm(macro.import_function("IoFileMgrForUser", "0xB293727F", "sceIoChangeAsyncPriority"));
        asm(macro.import_function("IoFileMgrForUser", "0xA12A0514", "sceIoSetAsyncCallback"));
        asm(macro.import_function("IoFileMgrForUser", "0x810C4BC3", "sceIoClose"));
        asm(macro.import_function("IoFileMgrForUser", "0xFF5940B6", "sceIoCloseAsync"));
        asm(macro.import_function("IoFileMgrForUser", "0x109F50BC", "sceIoOpen"));
        asm(macro.import_function("IoFileMgrForUser", "0x89AA9906", "sceIoOpenAsync"));
        asm(macro.import_function("IoFileMgrForUser", "0x6A638D83", "sceIoRead"));
        asm(macro.import_function("IoFileMgrForUser", "0xA0B5A7C2", "sceIoReadAsync"));
        asm(macro.import_function("IoFileMgrForUser", "0x42EC03AC", "sceIoWrite"));
        asm(macro.import_function("IoFileMgrForUser", "0x0FACAB19", "sceIoWriteAsync"));
        asm(macro.import_function("IoFileMgrForUser", "0x27EB27B8", "sceIoLseek"));
        asm(macro.import_function("IoFileMgrForUser", "0x71B19E77", "sceIoLseekAsync"));
        asm(macro.import_function("IoFileMgrForUser", "0x68963324", "sceIoLseek32"));
        asm(macro.import_function("IoFileMgrForUser", "0x1B385D8F", "sceIoLseek32Async"));
        asm(macro.import_function("IoFileMgrForUser", "0x63632449", "sceIoIoctl_stub"));
        asm(macro.generic_abi_wrapper("sceIoIoctl", 6));
        asm(macro.import_function("IoFileMgrForUser", "0xE95A012B", "sceIoIoctlAsync_stub"));
        asm(macro.generic_abi_wrapper("sceIoIoctlAsync", 6));
        asm(macro.import_function("IoFileMgrForUser", "0xB29DDF9C", "sceIoDopen"));
        asm(macro.import_function("IoFileMgrForUser", "0xE3EB004C", "sceIoDread"));
        asm(macro.import_function("IoFileMgrForUser", "0xEB092469", "sceIoDclose"));
        asm(macro.import_function("IoFileMgrForUser", "0xF27A9C51", "sceIoRemove"));
        asm(macro.import_function("IoFileMgrForUser", "0x06A70004", "sceIoMkdir"));
        asm(macro.import_function("IoFileMgrForUser", "0x1117C65F", "sceIoRmdir"));
        asm(macro.import_function("IoFileMgrForUser", "0x55F4717D", "sceIoChdir"));
        asm(macro.import_function("IoFileMgrForUser", "0xAB96437F", "sceIoSync"));
        asm(macro.import_function("IoFileMgrForUser", "0xACE946E8", "sceIoGetstat"));
        asm(macro.import_function("IoFileMgrForUser", "0xB8A740F4", "sceIoChstat"));
        asm(macro.import_function("IoFileMgrForUser", "0x779103A0", "sceIoRename"));
        asm(macro.import_function("IoFileMgrForUser", "0x54F5FB11", "sceIoDevctl_stub"));
        asm(macro.generic_abi_wrapper("sceIoDevctl", 6));
        asm(macro.import_function("IoFileMgrForUser", "0x08BD7374", "sceIoGetDevType"));
        asm(macro.import_function("IoFileMgrForUser", "0xB2A628C1", "sceIoAssign_stub"));
        asm(macro.generic_abi_wrapper("sceIoAssign", 6));
        asm(macro.import_function("IoFileMgrForUser", "0x6D08A871", "sceIoUnassign"));
        asm(macro.import_function("IoFileMgrForUser", "0xE8BC6571", "sceIoCancel"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_UtilsForUser") and options.include_UtilsForUser)) {
        asm(macro.import_module_start("UtilsForUser", "0x40010000", "26"));
        asm(macro.import_function("UtilsForUser", "0xBFA98062", "sceKernelDcacheInvalidateRange"));
        asm(macro.import_function("UtilsForUser", "0xC8186A58", "sceKernelUtilsMd5Digest"));
        asm(macro.import_function("UtilsForUser", "0x9E5C5086", "sceKernelUtilsMd5BlockInit"));
        asm(macro.import_function("UtilsForUser", "0x61E1E525", "sceKernelUtilsMd5BlockUpdate"));
        asm(macro.import_function("UtilsForUser", "0xB8D24E78", "sceKernelUtilsMd5BlockResult"));
        asm(macro.import_function("UtilsForUser", "0x840259F1", "sceKernelUtilsSha1Digest"));
        asm(macro.import_function("UtilsForUser", "0xF8FCD5BA", "sceKernelUtilsSha1BlockInit"));
        asm(macro.import_function("UtilsForUser", "0x346F6DA8", "sceKernelUtilsSha1BlockUpdate"));
        asm(macro.import_function("UtilsForUser", "0x585F1C09", "sceKernelUtilsSha1BlockResult"));
        asm(macro.import_function("UtilsForUser", "0xE860E75E", "sceKernelUtilsMt19937Init"));
        asm(macro.import_function("UtilsForUser", "0x06FB8A63", "sceKernelUtilsMt19937UInt"));
        asm(macro.import_function("UtilsForUser", "0x37FB5C42", "sceKernelGetGPI"));
        asm(macro.import_function("UtilsForUser", "0x6AD345D7", "sceKernelSetGPO"));
        asm(macro.import_function("UtilsForUser", "0x91E4F6A7", "sceKernelLibcClock"));
        asm(macro.import_function("UtilsForUser", "0x27CC57F0", "sceKernelLibcTime"));
        asm(macro.import_function("UtilsForUser", "0x71EC4271", "sceKernelLibcGettimeofday"));
        asm(macro.import_function("UtilsForUser", "0x79D1C3FA", "sceKernelDcacheWritebackAll"));
        asm(macro.import_function("UtilsForUser", "0xB435DEC5", "sceKernelDcacheWritebackInvalidateAll"));
        asm(macro.import_function("UtilsForUser", "0x3EE30821", "sceKernelDcacheWritebackRange"));
        asm(macro.import_function("UtilsForUser", "0x34B9FA9E", "sceKernelDcacheWritebackInvalidateRange"));
        asm(macro.import_function("UtilsForUser", "0x80001C4C", "sceKernelDcacheProbe"));
        asm(macro.import_function("UtilsForUser", "0x16641D70", "sceKernelDcacheReadTag"));
        asm(macro.import_function("UtilsForUser", "0x4FD31C9D", "sceKernelIcacheProbe"));
        asm(macro.import_function("UtilsForUser", "0xFB05FAD0", "sceKernelIcacheReadTag"));
        asm(macro.import_function("UtilsForUser", "0x920F104A", "sceKernelIcacheInvalidateAll"));
        asm(macro.import_function("UtilsForUser", "0xC2DF770E", "sceKernelIcacheInvalidateRange"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_InterruptManager") and options.include_InterruptManager)) {
        asm(macro.import_module_start("InterruptManager", "0x40000000", "9"));
        asm(macro.import_function("InterruptManager", "0xCA04A2B9", "sceKernelRegisterSubIntrHandler"));
        asm(macro.import_function("InterruptManager", "0xD61E6961", "sceKernelReleaseSubIntrHandler"));
        asm(macro.import_function("InterruptManager", "0xFB8E22EC", "sceKernelEnableSubIntr"));
        asm(macro.import_function("InterruptManager", "0x8A389411", "sceKernelDisableSubIntr"));
        asm(macro.import_function("InterruptManager", "0x5CB5A78B", "sceKernelSuspendSubIntr"));
        asm(macro.import_function("InterruptManager", "0x7860E0DC", "sceKernelResumeSubIntr"));
        asm(macro.import_function("InterruptManager", "0xFC4374B8", "sceKernelIsSubInterruptOccurred"));
        asm(macro.import_function("InterruptManager", "0xD2E8363F", "QueryIntrHandlerInfo"));
        asm(macro.import_function("InterruptManager", "0xEEE43F47", "sceKernelRegisterUserSpaceIntrStack"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_ThreadManForUser") and options.include_ThreadManForUser)) {
        asm(macro.import_module_start("ThreadManForUser", "0x40010000", "128"));
        asm(macro.import_function("ThreadManForUser", "0x6E9EA350", "_sceKernelReturnFromCallback"));
        asm(macro.import_function("ThreadManForUser", "0x0C106E53", "sceKernelRegisterThreadEventHandler_stub"));
        asm(macro.generic_abi_wrapper("sceKernelRegisterThreadEventHandler", 5));
        asm(macro.import_function("ThreadManForUser", "0x72F3C145", "sceKernelReleaseThreadEventHandler"));
        asm(macro.import_function("ThreadManForUser", "0x369EEB6B", "sceKernelReferThreadEventHandlerStatus"));
        asm(macro.import_function("ThreadManForUser", "0xE81CAF8F", "sceKernelCreateCallback"));
        asm(macro.import_function("ThreadManForUser", "0xEDBA5844", "sceKernelDeleteCallback"));
        asm(macro.import_function("ThreadManForUser", "0xC11BA8C4", "sceKernelNotifyCallback"));
        asm(macro.import_function("ThreadManForUser", "0xBA4051D6", "sceKernelCancelCallback"));
        asm(macro.import_function("ThreadManForUser", "0x2A3D44FF", "sceKernelGetCallbackCount"));
        asm(macro.import_function("ThreadManForUser", "0x349D6D6C", "sceKernelCheckCallback"));
        asm(macro.import_function("ThreadManForUser", "0x730ED8BC", "sceKernelReferCallbackStatus"));
        asm(macro.import_function("ThreadManForUser", "0x9ACE131E", "sceKernelSleepThread"));
        asm(macro.import_function("ThreadManForUser", "0x82826F70", "sceKernelSleepThreadCB"));
        asm(macro.import_function("ThreadManForUser", "0xD59EAD2F", "sceKernelWakeupThread"));
        asm(macro.import_function("ThreadManForUser", "0xFCCFAD26", "sceKernelCancelWakeupThread"));
        asm(macro.import_function("ThreadManForUser", "0x9944F31F", "sceKernelSuspendThread"));
        asm(macro.import_function("ThreadManForUser", "0x75156E8F", "sceKernelResumeThread"));
        asm(macro.import_function("ThreadManForUser", "0x278C0DF5", "sceKernelWaitThreadEnd"));
        asm(macro.import_function("ThreadManForUser", "0x840E8133", "sceKernelWaitThreadEndCB"));
        asm(macro.import_function("ThreadManForUser", "0xCEADEB47", "sceKernelDelayThread"));
        asm(macro.import_function("ThreadManForUser", "0x68DA9E36", "sceKernelDelayThreadCB"));
        asm(macro.import_function("ThreadManForUser", "0xBD123D9E", "sceKernelDelaySysClockThread"));
        asm(macro.import_function("ThreadManForUser", "0x1181E963", "sceKernelDelaySysClockThreadCB"));
        asm(macro.import_function("ThreadManForUser", "0xD6DA4BA1", "sceKernelCreateSema_stub"));
        asm(macro.generic_abi_wrapper("sceKernelCreateSema", 5));
        asm(macro.import_function("ThreadManForUser", "0x28B6489C", "sceKernelDeleteSema"));
        asm(macro.import_function("ThreadManForUser", "0x3F53E640", "sceKernelSignalSema"));
        asm(macro.import_function("ThreadManForUser", "0x4E3A1105", "sceKernelWaitSema"));
        asm(macro.import_function("ThreadManForUser", "0x6D212BAC", "sceKernelWaitSemaCB"));
        asm(macro.import_function("ThreadManForUser", "0x58B1F937", "sceKernelPollSema"));
        asm(macro.import_function("ThreadManForUser", "0x8FFDF9A2", "sceKernelCancelSema"));
        asm(macro.import_function("ThreadManForUser", "0xBC6FEBC5", "sceKernelReferSemaStatus"));
        asm(macro.import_function("ThreadManForUser", "0x55C20A00", "sceKernelCreateEventFlag"));
        asm(macro.import_function("ThreadManForUser", "0xEF9E4C70", "sceKernelDeleteEventFlag"));
        asm(macro.import_function("ThreadManForUser", "0x1FB15A32", "sceKernelSetEventFlag"));
        asm(macro.import_function("ThreadManForUser", "0x812346E4", "sceKernelClearEventFlag"));
        asm(macro.import_function("ThreadManForUser", "0x402FCF22", "sceKernelWaitEventFlag_stub"));
        asm(macro.generic_abi_wrapper("sceKernelWaitEventFlag", 5));
        asm(macro.import_function("ThreadManForUser", "0x328C546A", "sceKernelWaitEventFlagCB_stub"));
        asm(macro.generic_abi_wrapper("sceKernelWaitEventFlagCB", 5));
        asm(macro.import_function("ThreadManForUser", "0x30FD48F0", "sceKernelPollEventFlag"));
        asm(macro.import_function("ThreadManForUser", "0xCD203292", "sceKernelCancelEventFlag"));
        asm(macro.import_function("ThreadManForUser", "0xA66B0120", "sceKernelReferEventFlagStatus"));
        asm(macro.import_function("ThreadManForUser", "0x8125221D", "sceKernelCreateMbx"));
        asm(macro.import_function("ThreadManForUser", "0x86255ADA", "sceKernelDeleteMbx"));
        asm(macro.import_function("ThreadManForUser", "0xE9B3061E", "sceKernelSendMbx"));
        asm(macro.import_function("ThreadManForUser", "0x18260574", "sceKernelReceiveMbx"));
        asm(macro.import_function("ThreadManForUser", "0xF3986382", "sceKernelReceiveMbxCB"));
        asm(macro.import_function("ThreadManForUser", "0x0D81716A", "sceKernelPollMbx"));
        asm(macro.import_function("ThreadManForUser", "0x87D4DD36", "sceKernelCancelReceiveMbx"));
        asm(macro.import_function("ThreadManForUser", "0xA8E8C846", "sceKernelReferMbxStatus"));
        asm(macro.import_function("ThreadManForUser", "0x7C0DC2A0", "sceKernelCreateMsgPipe_stub"));
        asm(macro.generic_abi_wrapper("sceKernelCreateMsgPipe", 5));
        asm(macro.import_function("ThreadManForUser", "0xF0B7DA1C", "sceKernelDeleteMsgPipe"));
        asm(macro.import_function("ThreadManForUser", "0x876DBFAD", "sceKernelSendMsgPipe_stub"));
        asm(macro.generic_abi_wrapper("sceKernelSendMsgPipe", 6));
        asm(macro.import_function("ThreadManForUser", "0x7C41F2C2", "sceKernelSendMsgPipeCB_stub"));
        asm(macro.generic_abi_wrapper("sceKernelSendMsgPipeCB", 6));
        asm(macro.import_function("ThreadManForUser", "0x884C9F90", "sceKernelTrySendMsgPipe_stub"));
        asm(macro.generic_abi_wrapper("sceKernelTrySendMsgPipe", 5));
        asm(macro.import_function("ThreadManForUser", "0x74829B76", "sceKernelReceiveMsgPipe_stub"));
        asm(macro.generic_abi_wrapper("sceKernelReceiveMsgPipe", 6));
        asm(macro.import_function("ThreadManForUser", "0xFBFA697D", "sceKernelReceiveMsgPipeCB_stub"));
        asm(macro.generic_abi_wrapper("sceKernelReceiveMsgPipeCB", 6));
        asm(macro.import_function("ThreadManForUser", "0xDF52098F", "sceKernelTryReceiveMsgPipe_stub"));
        asm(macro.generic_abi_wrapper("sceKernelTryReceiveMsgPipe", 5));
        asm(macro.import_function("ThreadManForUser", "0x349B864D", "sceKernelCancelMsgPipe"));
        asm(macro.import_function("ThreadManForUser", "0x33BE4024", "sceKernelReferMsgPipeStatus"));
        asm(macro.import_function("ThreadManForUser", "0x56C039B5", "sceKernelCreateVpl_stub"));
        asm(macro.generic_abi_wrapper("sceKernelCreateVpl", 5));
        asm(macro.import_function("ThreadManForUser", "0x89B3D48C", "sceKernelDeleteVpl"));
        asm(macro.import_function("ThreadManForUser", "0xBED27435", "sceKernelAllocateVpl"));
        asm(macro.import_function("ThreadManForUser", "0xEC0A693F", "sceKernelAllocateVplCB"));
        asm(macro.import_function("ThreadManForUser", "0xAF36D708", "sceKernelTryAllocateVpl"));
        asm(macro.import_function("ThreadManForUser", "0xB736E9FF", "sceKernelFreeVpl"));
        asm(macro.import_function("ThreadManForUser", "0x1D371B8A", "sceKernelCancelVpl"));
        asm(macro.import_function("ThreadManForUser", "0x39810265", "sceKernelReferVplStatus"));
        asm(macro.import_function("ThreadManForUser", "0xC07BB470", "sceKernelCreateFpl_stub"));
        asm(macro.generic_abi_wrapper("sceKernelCreateFpl", 6));
        asm(macro.import_function("ThreadManForUser", "0xED1410E0", "sceKernelDeleteFpl"));
        asm(macro.import_function("ThreadManForUser", "0xD979E9BF", "sceKernelAllocateFpl"));
        asm(macro.import_function("ThreadManForUser", "0xE7282CB6", "sceKernelAllocateFplCB"));
        asm(macro.import_function("ThreadManForUser", "0x623AE665", "sceKernelTryAllocateFpl"));
        asm(macro.import_function("ThreadManForUser", "0xF6414A71", "sceKernelFreeFpl"));
        asm(macro.import_function("ThreadManForUser", "0xA8AA591F", "sceKernelCancelFpl"));
        asm(macro.import_function("ThreadManForUser", "0xD8199E4C", "sceKernelReferFplStatus"));
        asm(macro.import_function("ThreadManForUser", "0x0E927AED", "_sceKernelReturnFromTimerHandler"));
        asm(macro.import_function("ThreadManForUser", "0x110DEC9A", "sceKernelUSec2SysClock"));
        asm(macro.import_function("ThreadManForUser", "0xC8CD158C", "sceKernelUSec2SysClockWide"));
        asm(macro.import_function("ThreadManForUser", "0xBA6B92E2", "sceKernelSysClock2USec"));
        asm(macro.import_function("ThreadManForUser", "0xE1619D7C", "sceKernelSysClock2USecWide"));
        asm(macro.import_function("ThreadManForUser", "0xDB738F35", "sceKernelGetSystemTime"));
        asm(macro.import_function("ThreadManForUser", "0x82BC5777", "sceKernelGetSystemTimeWide"));
        asm(macro.import_function("ThreadManForUser", "0x369ED59D", "sceKernelGetSystemTimeLow"));
        asm(macro.import_function("ThreadManForUser", "0x6652B8CA", "sceKernelSetAlarm"));
        asm(macro.import_function("ThreadManForUser", "0xB2C25152", "sceKernelSetSysClockAlarm"));
        asm(macro.import_function("ThreadManForUser", "0x7E65B999", "sceKernelCancelAlarm"));
        asm(macro.import_function("ThreadManForUser", "0xDAA3F564", "sceKernelReferAlarmStatus"));
        asm(macro.import_function("ThreadManForUser", "0x20FFF560", "sceKernelCreateVTimer"));
        asm(macro.import_function("ThreadManForUser", "0x328F9E52", "sceKernelDeleteVTimer"));
        asm(macro.import_function("ThreadManForUser", "0xB3A59970", "sceKernelGetVTimerBase"));
        asm(macro.import_function("ThreadManForUser", "0xB7C18B77", "sceKernelGetVTimerBaseWide"));
        asm(macro.import_function("ThreadManForUser", "0x034A921F", "sceKernelGetVTimerTime"));
        asm(macro.import_function("ThreadManForUser", "0xC0B3FFD2", "sceKernelGetVTimerTimeWide"));
        asm(macro.import_function("ThreadManForUser", "0x542AD630", "sceKernelSetVTimerTime"));
        asm(macro.import_function("ThreadManForUser", "0xFB6425C3", "sceKernelSetVTimerTimeWide"));
        asm(macro.import_function("ThreadManForUser", "0xC68D9437", "sceKernelStartVTimer"));
        asm(macro.import_function("ThreadManForUser", "0xD0AEEE87", "sceKernelStopVTimer"));
        asm(macro.import_function("ThreadManForUser", "0xD8B299AE", "sceKernelSetVTimerHandler"));
        asm(macro.import_function("ThreadManForUser", "0x53B00E9A", "sceKernelSetVTimerHandlerWide"));
        asm(macro.import_function("ThreadManForUser", "0xD2D615EF", "sceKernelCancelVTimerHandler"));
        asm(macro.import_function("ThreadManForUser", "0x5F32BEAA", "sceKernelReferVTimerStatus"));
        asm(macro.import_function("ThreadManForUser", "0x446D8DE6", "sceKernelCreateThread_stub"));
        asm(macro.generic_abi_wrapper("sceKernelCreateThread", 6));
        asm(macro.import_function("ThreadManForUser", "0x9FA03CD3", "sceKernelDeleteThread"));
        asm(macro.import_function("ThreadManForUser", "0xF475845D", "sceKernelStartThread"));
        asm(macro.import_function("ThreadManForUser", "0x532A522E", "_sceKernelExitThread"));
        asm(macro.import_function("ThreadManForUser", "0xAA73C935", "sceKernelExitThread"));
        asm(macro.import_function("ThreadManForUser", "0x809CE29B", "sceKernelExitDeleteThread"));
        asm(macro.import_function("ThreadManForUser", "0x616403BA", "sceKernelTerminateThread"));
        asm(macro.import_function("ThreadManForUser", "0x383F7BCC", "sceKernelTerminateDeleteThread"));
        asm(macro.import_function("ThreadManForUser", "0x3AD58B8C", "sceKernelSuspendDispatchThread"));
        asm(macro.import_function("ThreadManForUser", "0x27E22EC2", "sceKernelResumeDispatchThread"));
        asm(macro.import_function("ThreadManForUser", "0xEA748E31", "sceKernelChangeCurrentThreadAttr"));
        asm(macro.import_function("ThreadManForUser", "0x71BC9871", "sceKernelChangeThreadPriority"));
        asm(macro.import_function("ThreadManForUser", "0x912354A7", "sceKernelRotateThreadReadyQueue"));
        asm(macro.import_function("ThreadManForUser", "0x2C34E053", "sceKernelReleaseWaitThread"));
        asm(macro.import_function("ThreadManForUser", "0x293B45B8", "sceKernelGetThreadId"));
        asm(macro.import_function("ThreadManForUser", "0x94AA61EE", "sceKernelGetThreadCurrentPriority"));
        asm(macro.import_function("ThreadManForUser", "0x3B183E26", "sceKernelGetThreadExitStatus"));
        asm(macro.import_function("ThreadManForUser", "0xD13BDE95", "sceKernelCheckThreadStack"));
        asm(macro.import_function("ThreadManForUser", "0x52089CA1", "sceKernelGetThreadStackFreeSize"));
        asm(macro.import_function("ThreadManForUser", "0x17C1684E", "sceKernelReferThreadStatus"));
        asm(macro.import_function("ThreadManForUser", "0xFFC36A14", "sceKernelReferThreadRunStatus"));
        asm(macro.import_function("ThreadManForUser", "0x627E6F3A", "sceKernelReferSystemStatus"));
        asm(macro.import_function("ThreadManForUser", "0x94416130", "sceKernelGetThreadmanIdList"));
        asm(macro.import_function("ThreadManForUser", "0x57CF62DD", "sceKernelGetThreadmanIdType"));
        asm(macro.import_function("ThreadManForUser", "0x64D4540E", "sceKernelReferThreadProfiler"));
        asm(macro.import_function("ThreadManForUser", "0x8218B4DD", "sceKernelReferGlobalProfiler"));
        asm(macro.import_function("ThreadManForUser", "0x60107536", "sceKernelDeleteLwMutex"));
        asm(macro.import_function("ThreadManForUser", "0x19CFF145", "sceKernelCreateLwMutex_stub"));
        asm(macro.generic_abi_wrapper("sceKernelCreateLwMutex", 5));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_StdioForUser") and options.include_StdioForUser)) {
        asm(macro.import_module_start("StdioForUser", "0x40010000", "9"));
        asm(macro.import_function("StdioForUser", "0x3054D478", "sceKernelStdioRead"));
        asm(macro.import_function("StdioForUser", "0x0CBB0571", "sceKernelStdioLseek"));
        asm(macro.import_function("StdioForUser", "0xA46785C9", "sceKernelStdioSendChar"));
        asm(macro.import_function("StdioForUser", "0xA3B931DB", "sceKernelStdioWrite"));
        asm(macro.import_function("StdioForUser", "0x9D061C19", "sceKernelStdioClose"));
        asm(macro.import_function("StdioForUser", "0x924ABA61", "sceKernelStdioOpen"));
        asm(macro.import_function("StdioForUser", "0x172D316E", "sceKernelStdin"));
        asm(macro.import_function("StdioForUser", "0xA6BAB2E9", "sceKernelStdout"));
        asm(macro.import_function("StdioForUser", "0xF78BA90A", "sceKernelStderr"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceUsbCam") and options.include_sceUsbCam)) {
        asm(macro.import_module_start("sceUsbCam", "0x40090000", "54"));
        asm(macro.import_function("sceUsbCam", "0x03ED7A82", "sceUsbCamSetupMic"));
        asm(macro.import_function("sceUsbCam", "0x08AEE98A", "sceUsbCamSetMicGain"));
        asm(macro.import_function("sceUsbCam", "0x09C26C7E", "sceUsbCamSetContrast"));
        asm(macro.import_function("sceUsbCam", "0x0A41A298", "sceUsbCamSetupStillEx"));
        asm(macro.import_function("sceUsbCam", "0x11A1F128", "sceUsbCamGetAutoImageReverseState"));
        asm(macro.import_function("sceUsbCam", "0x17F7B2FB", "sceUsbCamSetupVideo"));
        asm(macro.import_function("sceUsbCam", "0x1A46CFE7", "sceUsbCamStillPollInputEnd"));
        asm(macro.import_function("sceUsbCam", "0x1D686870", "sceUsbCamSetEvLevel"));
        asm(macro.import_function("sceUsbCam", "0x1E958148", "sceUsbCam_1E958148"));
        asm(macro.import_function("sceUsbCam", "0x2BCD50C0", "sceUsbCamGetEvLevel"));
        asm(macro.import_function("sceUsbCam", "0x2E930264", "sceUsbCamSetupMicEx"));
        asm(macro.import_function("sceUsbCam", "0x36636925", "sceUsbCamReadMicBlocking"));
        asm(macro.import_function("sceUsbCam", "0x383E9FA8", "sceUsbCamGetSaturation"));
        asm(macro.import_function("sceUsbCam", "0x3DC0088E", "sceUsbCamReadMic"));
        asm(macro.import_function("sceUsbCam", "0x3F0CF289", "sceUsbCamSetupStill"));
        asm(macro.import_function("sceUsbCam", "0x41E73E95", "sceUsbCamPollReadVideoFrameEnd"));
        asm(macro.import_function("sceUsbCam", "0x41EE8797", "sceUsbCamUnregisterLensRotationCallback"));
        asm(macro.import_function("sceUsbCam", "0x4C34F553", "sceUsbCamGetLensDirection"));
        asm(macro.import_function("sceUsbCam", "0x4F3D84D5", "sceUsbCamSetBrightness"));
        asm(macro.import_function("sceUsbCam", "0x5145868A", "sceUsbCamStopMic"));
        asm(macro.import_function("sceUsbCam", "0x574A8C3F", "sceUsbCamStartVideo"));
        asm(macro.import_function("sceUsbCam", "0x5778B452", "sceUsbCamGetMicDataLength"));
        asm(macro.import_function("sceUsbCam", "0x61BE5CAC", "sceUsbCamStillInputBlocking"));
        asm(macro.import_function("sceUsbCam", "0x622F83CC", "sceUsbCamSetSharpness"));
        asm(macro.import_function("sceUsbCam", "0x6784E6A8", "sceUsbCamSetAntiFlicker"));
        asm(macro.import_function("sceUsbCam", "0x6CF32CB9", "sceUsbCamStopVideo"));
        asm(macro.import_function("sceUsbCam", "0x6E205974", "sceUsbCamSetSaturation"));
        asm(macro.import_function("sceUsbCam", "0x70F522C5", "sceUsbCamGetBrightness"));
        asm(macro.import_function("sceUsbCam", "0x7563AFA1", "sceUsbCamStillWaitInputEnd"));
        asm(macro.import_function("sceUsbCam", "0x7DAC0C71", "sceUsbCamReadVideoFrameBlocking"));
        asm(macro.import_function("sceUsbCam", "0x82A64030", "sceUsbCamStartMic"));
        asm(macro.import_function("sceUsbCam", "0x951BEDF5", "sceUsbCamSetReverseMode"));
        asm(macro.import_function("sceUsbCam", "0x95F8901E", "sceUsbCam_95F8901E"));
        asm(macro.import_function("sceUsbCam", "0x994471E0", "sceUsbCamGetImageEffectMode"));
        asm(macro.import_function("sceUsbCam", "0x99D86281", "sceUsbCamReadVideoFrame"));
        asm(macro.import_function("sceUsbCam", "0x9E8AAF8D", "sceUsbCamGetZoom"));
        asm(macro.import_function("sceUsbCam", "0xA063A957", "sceUsbCamGetContrast"));
        asm(macro.import_function("sceUsbCam", "0xA720937C", "sceUsbCamStillCancelInput"));
        asm(macro.import_function("sceUsbCam", "0xAA7D94BA", "sceUsbCamGetAntiFlicker"));
        asm(macro.import_function("sceUsbCam", "0xB048A67D", "sceUsbCamWaitReadMicEnd"));
        asm(macro.import_function("sceUsbCam", "0xC484901F", "sceUsbCamSetZoom"));
        asm(macro.import_function("sceUsbCam", "0xC72ED6D3", "sceUsbCam_C72ED6D3"));
        asm(macro.import_function("sceUsbCam", "0xCFE9E999", "sceUsbCamSetupVideoEx"));
        asm(macro.import_function("sceUsbCam", "0xD293A100", "sceUsbCamRegisterLensRotationCallback"));
        asm(macro.import_function("sceUsbCam", "0xD4876173", "sceUsbCamSetImageEffectMode"));
        asm(macro.import_function("sceUsbCam", "0xD5279339", "sceUsbCamGetReverseMode"));
        asm(macro.import_function("sceUsbCam", "0xD865997B", "sceUsbCam_D865997B"));
        asm(macro.import_function("sceUsbCam", "0xDF9D0C92", "sceUsbCamGetReadVideoFrameSize"));
        asm(macro.import_function("sceUsbCam", "0xE5959C36", "sceUsbCamStillGetInputLength"));
        asm(macro.import_function("sceUsbCam", "0xF8847F60", "sceUsbCamPollReadMicEnd"));
        asm(macro.import_function("sceUsbCam", "0xF90B2293", "sceUsbCamWaitReadVideoFrameEnd"));
        asm(macro.import_function("sceUsbCam", "0xF93C4669", "sceUsbCamAutoImageReverseSW"));
        asm(macro.import_function("sceUsbCam", "0xFB0A6C5D", "sceUsbCamStillInput"));
        asm(macro.import_function("sceUsbCam", "0xFDB68C23", "sceUsbCamGetSharpness"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceUsb") and options.include_sceUsb)) {
        asm(macro.import_module_start("sceUsb", "0x40010000", "9"));
        asm(macro.import_function("sceUsb", "0xAE5DE6AF", "sceUsbStart"));
        asm(macro.import_function("sceUsb", "0xC2464FA0", "sceUsbStop"));
        asm(macro.import_function("sceUsb", "0xC21645A4", "sceUsbGetState"));
        asm(macro.import_function("sceUsb", "0x4E537366", "sceUsbGetDrvList"));
        asm(macro.import_function("sceUsb", "0x112CC951", "sceUsbGetDrvState"));
        asm(macro.import_function("sceUsb", "0x586DB82C", "sceUsbActivate"));
        asm(macro.import_function("sceUsb", "0xC572A9C8", "sceUsbDeactivate"));
        asm(macro.import_function("sceUsb", "0x5BE0E002", "sceUsbWaitState"));
        asm(macro.import_function("sceUsb", "0x1C360735", "sceUsbWaitCancel"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceDmac") and options.include_sceDmac)) {
        asm(macro.import_module_start("sceDmac", "0x40010011", "2"));
        asm(macro.import_function("sceDmac", "0x617F3FE6", "sceDmacMemcpy"));
        asm(macro.import_function("sceDmac", "0xD97F94D8", "sceDmacTryMemcpy"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceSircs") and options.include_sceSircs)) {
        asm(macro.import_module_start("sceSircs", "0x40010000", "1"));
        asm(macro.import_function("sceSircs", "0x71EEF62D", "sceSircsSend"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceAudio") and options.include_sceAudio)) {
        asm(macro.import_module_start("sceAudio", "0x40010000", "27"));
        asm(macro.import_function("sceAudio", "0x8C1009B2", "sceAudioOutput"));
        asm(macro.import_function("sceAudio", "0x136CAF51", "sceAudioOutputBlocking"));
        asm(macro.import_function("sceAudio", "0xE2D56B2D", "sceAudioOutputPanned"));
        asm(macro.import_function("sceAudio", "0x13F592BC", "sceAudioOutputPannedBlocking"));
        asm(macro.import_function("sceAudio", "0x5EC81C55", "sceAudioChReserve"));
        asm(macro.import_function("sceAudio", "0x41EFADE7", "sceAudioOneshotOutput"));
        asm(macro.import_function("sceAudio", "0x6FC46853", "sceAudioChRelease"));
        asm(macro.import_function("sceAudio", "0xE9D97901", "sceAudioGetChannelRestLen"));
        asm(macro.import_function("sceAudio", "0xCB2E439E", "sceAudioSetChannelDataLen"));
        asm(macro.import_function("sceAudio", "0x95FD0C2D", "sceAudioChangeChannelConfig"));
        asm(macro.import_function("sceAudio", "0xB7E1D8E7", "sceAudioChangeChannelVolume"));
        asm(macro.import_function("sceAudio", "0x38553111", "sceAudioSRCChReserve"));
        asm(macro.import_function("sceAudio", "0x5C37C0AE", "sceAudioSRCChRelease"));
        asm(macro.import_function("sceAudio", "0xE0727056", "sceAudioSRCOutputBlocking"));
        asm(macro.import_function("sceAudio", "0x086E5895", "sceAudioInputBlocking"));
        asm(macro.import_function("sceAudio", "0x6D4BEC68", "sceAudioInput"));
        asm(macro.import_function("sceAudio", "0xA708C6A6", "sceAudioGetInputLength"));
        asm(macro.import_function("sceAudio", "0x87B2E651", "sceAudioWaitInputEnd"));
        asm(macro.import_function("sceAudio", "0x7DE61688", "sceAudioInputInit"));
        asm(macro.import_function("sceAudio", "0xA633048E", "sceAudioPollInputEnd"));
        asm(macro.import_function("sceAudio", "0xB011922F", "sceAudioGetChannelRestLength"));
        asm(macro.import_function("sceAudio", "0xE926D3FB", "sceAudioInputInitEx"));
        asm(macro.import_function("sceAudio", "0x01562BA3", "sceAudioOutput2Reserve"));
        asm(macro.import_function("sceAudio", "0x2D53F36E", "sceAudioOutput2OutputBlocking"));
        asm(macro.import_function("sceAudio", "0x43196845", "sceAudioOutput2Release"));
        asm(macro.import_function("sceAudio", "0x63F2889C", "sceAudioOutput2ChangeLength"));
        asm(macro.import_function("sceAudio", "0x647CEF33", "sceAudioOutput2GetRestSample"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceAudiocodec") and options.include_sceAudiocodec)) {
        asm(macro.import_module_start("sceAudiocodec", "0x40090000", "8"));
        asm(macro.import_function("sceAudiocodec", "0x9D3F790C", "sceAudiocodecCheckNeedMem"));
        asm(macro.import_function("sceAudiocodec", "0x5B37EB1D", "sceAudiocodecInit"));
        asm(macro.import_function("sceAudiocodec", "0x70A703F8", "sceAudiocodecDecode"));
        asm(macro.import_function("sceAudiocodec", "0x8ACA11D5", "sceAudiocodecGetInfo"));
        asm(macro.import_function("sceAudiocodec", "0x6CD2A861", "sceAudiocodec_6CD2A861"));
        asm(macro.import_function("sceAudiocodec", "0x59176A0F", "sceAudiocodec_59176A0F"));
        asm(macro.import_function("sceAudiocodec", "0x3A20A200", "sceAudiocodecGetEDRAM"));
        asm(macro.import_function("sceAudiocodec", "0x29681260", "sceAudiocodecReleaseEDRAM"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceGe_user") and options.include_sceGe_user)) {
        asm(macro.import_module_start("sceGe_user", "0x40010000", "19"));
        asm(macro.import_function("sceGe_user", "0x1F6752AD", "sceGeEdramGetSize"));
        asm(macro.import_function("sceGe_user", "0xE47E40E4", "sceGeEdramGetAddr"));
        asm(macro.import_function("sceGe_user", "0xB77905EA", "sceGeEdramSetAddrTranslation"));
        asm(macro.import_function("sceGe_user", "0xDC93CFEF", "sceGeGetCmd"));
        asm(macro.import_function("sceGe_user", "0x57C8945B", "sceGeGetMtx"));
        asm(macro.import_function("sceGe_user", "0xE66CB92E", "sceGeGetStack"));
        asm(macro.import_function("sceGe_user", "0x438A385A", "sceGeSaveContext"));
        asm(macro.import_function("sceGe_user", "0x0BF608FB", "sceGeRestoreContext"));
        asm(macro.import_function("sceGe_user", "0xAB49E76A", "sceGeListEnQueue"));
        asm(macro.import_function("sceGe_user", "0x1C0D95A6", "sceGeListEnQueueHead"));
        asm(macro.import_function("sceGe_user", "0x5FB86AB0", "sceGeListDeQueue"));
        asm(macro.import_function("sceGe_user", "0xE0D68148", "sceGeListUpdateStallAddr"));
        asm(macro.import_function("sceGe_user", "0x03444EB4", "sceGeListSync"));
        asm(macro.import_function("sceGe_user", "0xB287BD61", "sceGeDrawSync"));
        asm(macro.import_function("sceGe_user", "0xB448EC0D", "sceGeBreak"));
        asm(macro.import_function("sceGe_user", "0x4C06E472", "sceGeContinue"));
        asm(macro.import_function("sceGe_user", "0xA4FC06A4", "sceGeSetCallback"));
        asm(macro.import_function("sceGe_user", "0x05DB22CE", "sceGeUnsetCallback"));
        asm(macro.import_function("sceGe_user", "0x5BAA5439", "sceGeEdramSetSize"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceMp3") and options.include_sceMp3)) {
        asm(macro.import_module_start("sceMp3", "0x00090011", "24"));
        asm(macro.import_function("sceMp3", "0x07EC321A", "sceMp3ReserveMp3Handle"));
        asm(macro.import_function("sceMp3", "0x0DB149F4", "sceMp3NotifyAddStreamData"));
        asm(macro.import_function("sceMp3", "0x2A368661", "sceMp3ResetPlayPosition"));
        asm(macro.import_function("sceMp3", "0x354D27EA", "sceMp3GetSumDecodedSample"));
        asm(macro.import_function("sceMp3", "0x35750070", "sceMp3InitResource"));
        asm(macro.import_function("sceMp3", "0x3C2FA058", "sceMp3TermResource"));
        asm(macro.import_function("sceMp3", "0x3CEF484F", "sceMp3SetLoopNum"));
        asm(macro.import_function("sceMp3", "0x44E07129", "sceMp3Init"));
        asm(macro.import_function("sceMp3", "0x732B042A", "sceMp3_732B042A"));
        asm(macro.import_function("sceMp3", "0x7F696782", "sceMp3GetMp3ChannelNum"));
        asm(macro.import_function("sceMp3", "0x87677E40", "sceMp3GetBitRate"));
        asm(macro.import_function("sceMp3", "0x87C263D1", "sceMp3GetMaxOutputSample"));
        asm(macro.import_function("sceMp3", "0x8AB81558", "sceMp3_8AB81558"));
        asm(macro.import_function("sceMp3", "0x8F450998", "sceMp3GetSamplingRate"));
        asm(macro.import_function("sceMp3", "0xA703FE0F", "sceMp3GetInfoToAddStreamData"));
        asm(macro.import_function("sceMp3", "0xD021C0FB", "sceMp3Decode"));
        asm(macro.import_function("sceMp3", "0xD0A56296", "sceMp3CheckStreamDataNeeded"));
        asm(macro.import_function("sceMp3", "0xD8F54A51", "sceMp3GetLoopNum"));
        asm(macro.import_function("sceMp3", "0xF5478233", "sceMp3ReleaseMp3Handle"));
        asm(macro.import_function("sceMp3", "0xAE6D2027", "sceMp3GetMPEGVersion"));
        asm(macro.import_function("sceMp3", "0x3548AEC8", "sceMp3GetFrameNum"));
        asm(macro.import_function("sceMp3", "0x0840E808", "sceMp3ResetPlayPositionByFrame"));
        asm(macro.import_function("sceMp3", "0x1B839B83", "sceMp3LowLevelInit"));
        asm(macro.import_function("sceMp3", "0xE3EE2C81", "sceMp3LowLevelDecode_stub"));
        asm(macro.generic_abi_wrapper("sceMp3LowLevelDecode", 5));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceRtc") and options.include_sceRtc)) {
        asm(macro.import_module_start("sceRtc", "0x40010000", "40"));
        asm(macro.import_function("sceRtc", "0xC41C2853", "sceRtcGetTickResolution"));
        asm(macro.import_function("sceRtc", "0x3F7AD767", "sceRtcGetCurrentTick"));
        asm(macro.import_function("sceRtc", "0x029CA3B3", "sceRtc_029CA3B3"));
        asm(macro.import_function("sceRtc", "0x4CFA57B0", "sceRtcGetCurrentClock"));
        asm(macro.import_function("sceRtc", "0xE7C27D1B", "sceRtcGetCurrentClockLocalTime"));
        asm(macro.import_function("sceRtc", "0x34885E0D", "sceRtcConvertUtcToLocalTime"));
        asm(macro.import_function("sceRtc", "0x779242A2", "sceRtcConvertLocalTimeToUTC"));
        asm(macro.import_function("sceRtc", "0x42307A17", "sceRtcIsLeapYear"));
        asm(macro.import_function("sceRtc", "0x05EF322C", "sceRtcGetDaysInMonth"));
        asm(macro.import_function("sceRtc", "0x57726BC1", "sceRtcGetDayOfWeek"));
        asm(macro.import_function("sceRtc", "0x4B1B5E82", "sceRtcCheckValid"));
        asm(macro.import_function("sceRtc", "0x3A807CC8", "sceRtcSetTime_t"));
        asm(macro.import_function("sceRtc", "0x27C4594C", "sceRtcGetTime_t"));
        asm(macro.import_function("sceRtc", "0xF006F264", "sceRtcSetDosTime"));
        asm(macro.import_function("sceRtc", "0x36075567", "sceRtcGetDosTime"));
        asm(macro.import_function("sceRtc", "0x7ACE4C04", "sceRtcSetWin32FileTime"));
        asm(macro.import_function("sceRtc", "0xCF561893", "sceRtcGetWin32FileTime"));
        asm(macro.import_function("sceRtc", "0x7ED29E40", "sceRtcSetTick"));
        asm(macro.import_function("sceRtc", "0x6FF40ACC", "sceRtcGetTick"));
        asm(macro.import_function("sceRtc", "0x9ED0AE87", "sceRtcCompareTick"));
        asm(macro.import_function("sceRtc", "0x44F45E05", "sceRtcTickAddTicks"));
        asm(macro.import_function("sceRtc", "0x26D25A5D", "sceRtcTickAddMicroseconds"));
        asm(macro.import_function("sceRtc", "0xF2A4AFE5", "sceRtcTickAddSeconds"));
        asm(macro.import_function("sceRtc", "0xE6605BCA", "sceRtcTickAddMinutes"));
        asm(macro.import_function("sceRtc", "0x26D7A24A", "sceRtcTickAddHours"));
        asm(macro.import_function("sceRtc", "0xE51B4B7A", "sceRtcTickAddDays"));
        asm(macro.import_function("sceRtc", "0xCF3A2CA8", "sceRtcTickAddWeeks"));
        asm(macro.import_function("sceRtc", "0xDBF74F1B", "sceRtcTickAddMonths"));
        asm(macro.import_function("sceRtc", "0x42842C77", "sceRtcTickAddYears"));
        asm(macro.import_function("sceRtc", "0xC663B3B9", "sceRtcFormatRFC2822"));
        asm(macro.import_function("sceRtc", "0x7DE6711B", "sceRtcFormatRFC2822LocalTime"));
        asm(macro.import_function("sceRtc", "0x0498FB3C", "sceRtcFormatRFC3339"));
        asm(macro.import_function("sceRtc", "0x27F98543", "sceRtcFormatRFC3339LocalTime"));
        asm(macro.import_function("sceRtc", "0xDFBC5F16", "sceRtcParseDateTime"));
        asm(macro.import_function("sceRtc", "0x28E1E988", "sceRtcParseRFC3339"));
        asm(macro.import_function("sceRtc", "0x011F03C1", "sceRtcGetAccumulativeTime"));
        asm(macro.import_function("sceRtc", "0x1909C99B", "sceRtcSetTime64_t"));
        asm(macro.import_function("sceRtc", "0x203CEB0D", "sceRtcGetLastReincarnatedTime"));
        asm(macro.import_function("sceRtc", "0x62685E98", "sceRtcGetLastAdjustedTime"));
        asm(macro.import_function("sceRtc", "0xE1C93E47", "sceRtcGetTime64_t"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceVaudio") and options.include_sceVaudio)) {
        asm(macro.import_module_start("sceVaudio", "0x40090000", "8"));
        asm(macro.import_function("sceVaudio", "0x8986295E", "sceVaudioOutputBlocking"));
        asm(macro.import_function("sceVaudio", "0x03B6807D", "sceVaudioChReserve"));
        asm(macro.import_function("sceVaudio", "0x67585DFD", "sceVaudioChRelease"));
        asm(macro.import_function("sceVaudio", "0x346fbe94", "sceVaudioSetEffectType"));
        asm(macro.import_function("sceVaudio", "0xcbd4ac51", "sceVaudioSetAlcMode"));
        asm(macro.import_function("sceVaudio", "0x504E4745", "sceVaudio_504E4745"));
        asm(macro.import_function("sceVaudio", "0x27ACC20B", "sceVaudioChReserveBuffering"));
        asm(macro.import_function("sceVaudio", "0xE8E78DC8", "sceVaudio_E8E78DC8"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceReg") and options.include_sceReg)) {
        asm(macro.import_module_start("sceReg", "0x40010000", "18"));
        asm(macro.import_function("sceReg", "0x9B25EDF1", "sceRegExit"));
        asm(macro.import_function("sceReg", "0x92E41280", "sceRegOpenRegistry"));
        asm(macro.import_function("sceReg", "0xFA8A5739", "sceRegCloseRegistry"));
        asm(macro.import_function("sceReg", "0xDEDA92BF", "sceRegRemoveRegistry"));
        asm(macro.import_function("sceReg", "0x1D8A762E", "sceRegOpenCategory"));
        asm(macro.import_function("sceReg", "0x0CAE832B", "sceRegCloseCategory"));
        asm(macro.import_function("sceReg", "0x39461B4D", "sceRegFlushRegistry"));
        asm(macro.import_function("sceReg", "0x0D69BF40", "sceRegFlushCategory"));
        asm(macro.import_function("sceReg", "0x57641A81", "sceRegCreateKey"));
        asm(macro.import_function("sceReg", "0x17768E14", "sceRegSetKeyValue"));
        asm(macro.import_function("sceReg", "0xD4475AA8", "sceRegGetKeyInfo_stub"));
        asm(macro.generic_abi_wrapper("sceRegGetKeyInfo", 5));
        asm(macro.import_function("sceReg", "0x28A8E98A", "sceRegGetKeyValue"));
        asm(macro.import_function("sceReg", "0x2C0DB9DD", "sceRegGetKeysNum"));
        asm(macro.import_function("sceReg", "0x2D211135", "sceRegGetKeys"));
        asm(macro.import_function("sceReg", "0x4CA16893", "sceRegRemoveCategory"));
        asm(macro.import_function("sceReg", "0x3615BC87", "sceRegRemoveKey"));
        asm(macro.import_function("sceReg", "0xC5768D02", "sceRegGetKeyInfoByName"));
        asm(macro.import_function("sceReg", "0x30BE0259", "sceRegGetKeyValueByName"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceWlanDrv_lib") and options.include_sceWlanDrv_lib)) {
        asm(macro.import_module_start("sceWlanDrv_lib", "0x40010000", "18"));
        asm(macro.import_function("sceWlanDrv_lib", "0x482CAE9A", "sceWlanDevAttach"));
        asm(macro.import_function("sceWlanDrv_lib", "0xC9A8CAB7", "sceWlanDevDetach"));
        asm(macro.import_function("sceWlanDrv_lib", "0x19E51F54", "sceWlanDrv_lib_19E51F54"));
        asm(macro.import_function("sceWlanDrv_lib", "0x5E7C8D94", "sceWlanDevIsGameMode"));
        asm(macro.import_function("sceWlanDrv_lib", "0x5ED4049A", "sceWlanGPPrevEstablishActive"));
        asm(macro.import_function("sceWlanDrv_lib", "0xB4D7CB74", "sceWlanGPSend"));
        asm(macro.import_function("sceWlanDrv_lib", "0xA447103A", "sceWlanGPRecv"));
        asm(macro.import_function("sceWlanDrv_lib", "0x9658C9F7", "sceWlanGPRegisterCallback"));
        asm(macro.import_function("sceWlanDrv_lib", "0x4C7F62E0", "sceWlanGPUnRegisterCallback"));
        asm(macro.import_function("sceWlanDrv_lib", "0x81579D36", "sceWlanDrv_lib_81579D36"));
        asm(macro.import_function("sceWlanDrv_lib", "0x5BAA1FE5", "sceWlanDrv_lib_5BAA1FE5"));
        asm(macro.import_function("sceWlanDrv_lib", "0x4C14BACA", "sceWlanDrv_lib_4C14BACA"));
        asm(macro.import_function("sceWlanDrv_lib", "0x2D0FAE4E", "sceWlanDrv_lib_2D0FAE4E"));
        asm(macro.import_function("sceWlanDrv_lib", "0x56F467CA", "sceWlanDrv_lib_56F467CA"));
        asm(macro.import_function("sceWlanDrv_lib", "0xFE8A0B46", "sceWlanDrv_lib_FE8A0B46"));
        asm(macro.import_function("sceWlanDrv_lib", "0x40B0AA4A", "sceWlanDrv_lib_40B0AA4A"));
        asm(macro.import_function("sceWlanDrv_lib", "0x7FF54BD2", "sceWlanDevSetGPIO"));
        asm(macro.import_function("sceWlanDrv_lib", "0x05FE320C", "sceWlanDevGetStateGPIO"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceWlanDrv") and options.include_sceWlanDrv)) {
        asm(macro.import_module_start("sceWlanDrv", "0x40010000", "3"));
        asm(macro.import_function("sceWlanDrv", "0x93440B11", "sceWlanDevIsPowerOn"));
        asm(macro.import_function("sceWlanDrv", "0xD7763699", "sceWlanGetSwitchState"));
        asm(macro.import_function("sceWlanDrv", "0x0C622081", "sceWlanGetEtherAddr"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceOpenPSID") and options.include_sceOpenPSID)) {
        asm(macro.import_module_start("sceOpenPSID", "0x40010011", "1"));
        asm(macro.import_function("sceOpenPSID", "0xC69BEBCE", "sceOpenPSIDGetOpenPSID"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceDisplay") and options.include_sceDisplay)) {
        asm(macro.import_module_start("sceDisplay", "0x40010000", "17"));
        asm(macro.import_function("sceDisplay", "0x0E20F177", "sceDisplaySetMode"));
        asm(macro.import_function("sceDisplay", "0xDEA197D4", "sceDisplayGetMode"));
        asm(macro.import_function("sceDisplay", "0xDBA6C4C4", "sceDisplayGetFramePerSec"));
        asm(macro.import_function("sceDisplay", "0x7ED59BC4", "sceDisplaySetHoldMode"));
        asm(macro.import_function("sceDisplay", "0xA544C486", "sceDisplaySetResumeMode"));
        asm(macro.import_function("sceDisplay", "0x289D82FE", "sceDisplaySetFrameBuf"));
        asm(macro.import_function("sceDisplay", "0xEEDA2E54", "sceDisplayGetFrameBuf"));
        asm(macro.import_function("sceDisplay", "0xB4F378FA", "sceDisplayIsForeground"));
        asm(macro.import_function("sceDisplay", "0x31C4BAA8", "sceDisplay_31C4BAA8"));
        asm(macro.import_function("sceDisplay", "0x9C6EAAD7", "sceDisplayGetVcount"));
        asm(macro.import_function("sceDisplay", "0x4D4E10EC", "sceDisplayIsVblank"));
        asm(macro.import_function("sceDisplay", "0x36CDFADE", "sceDisplayWaitVblank"));
        asm(macro.import_function("sceDisplay", "0x8EB9EC49", "sceDisplayWaitVblankCB"));
        asm(macro.import_function("sceDisplay", "0x984C27E7", "sceDisplayWaitVblankStart"));
        asm(macro.import_function("sceDisplay", "0x46F186C3", "sceDisplayWaitVblankStartCB"));
        asm(macro.import_function("sceDisplay", "0x773DD3A3", "sceDisplayGetCurrentHcount"));
        asm(macro.import_function("sceDisplay", "0x210EAB3A", "sceDisplayGetAccumulatedHcount"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceAtrac3plus") and options.include_sceAtrac3plus)) {
        asm(macro.import_module_start("sceAtrac3plus", "0x00090000", "25"));
        asm(macro.import_function("sceAtrac3plus", "0xD1F59FDB", "sceAtracStartEntry"));
        asm(macro.import_function("sceAtrac3plus", "0xD5C28CC0", "sceAtracEndEntry"));
        asm(macro.import_function("sceAtrac3plus", "0x780F88D1", "sceAtracGetAtracID"));
        asm(macro.import_function("sceAtrac3plus", "0x61EB33F5", "sceAtracReleaseAtracID"));
        asm(macro.import_function("sceAtrac3plus", "0x0E2A73AB", "sceAtracSetData"));
        asm(macro.import_function("sceAtrac3plus", "0x3F6E26B5", "sceAtracSetHalfwayBuffer"));
        asm(macro.import_function("sceAtrac3plus", "0x7A20E7AF", "sceAtracSetDataAndGetID"));
        asm(macro.import_function("sceAtrac3plus", "0x0FAE370E", "sceAtracSetHalfwayBufferAndGetID"));
        asm(macro.import_function("sceAtrac3plus", "0x6A8C3CD5", "sceAtracDecodeData_stub"));
        asm(macro.generic_abi_wrapper("sceAtracDecodeData", 5));
        asm(macro.import_function("sceAtrac3plus", "0x9AE849A7", "sceAtracGetRemainFrame"));
        asm(macro.import_function("sceAtrac3plus", "0x5D268707", "sceAtracGetStreamDataInfo"));
        asm(macro.import_function("sceAtrac3plus", "0x7DB31251", "sceAtracAddStreamData"));
        asm(macro.import_function("sceAtrac3plus", "0x83E85EA0", "sceAtracGetSecondBufferInfo"));
        asm(macro.import_function("sceAtrac3plus", "0x83BF7AFD", "sceAtracSetSecondBuffer"));
        asm(macro.import_function("sceAtrac3plus", "0xE23E3A35", "sceAtracGetNextDecodePosition"));
        asm(macro.import_function("sceAtrac3plus", "0xA2BBA8BE", "sceAtracGetSoundSample"));
        asm(macro.import_function("sceAtrac3plus", "0x31668BAA", "sceAtracGetChannel"));
        asm(macro.import_function("sceAtrac3plus", "0xD6A5F2F7", "sceAtracGetMaxSample"));
        asm(macro.import_function("sceAtrac3plus", "0x36FAABFB", "sceAtracGetNextSample"));
        asm(macro.import_function("sceAtrac3plus", "0xA554A158", "sceAtracGetBitrate"));
        asm(macro.import_function("sceAtrac3plus", "0xFAA4F89B", "sceAtracGetLoopStatus"));
        asm(macro.import_function("sceAtrac3plus", "0x868120B5", "sceAtracSetLoopNum"));
        asm(macro.import_function("sceAtrac3plus", "0xCA3CA3D2", "sceAtracGetBufferInfoForReseting"));
        asm(macro.import_function("sceAtrac3plus", "0x644E5607", "sceAtracResetPlayPosition"));
        asm(macro.import_function("sceAtrac3plus", "0xE88F759B", "sceAtracGetInternalErrorInfo"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceUsbstor") and options.include_sceUsbstor)) {
        asm(macro.import_module_start("sceUsbstor", "0x40090000", "1"));
        asm(macro.import_function("sceUsbstor", "0x60066CFE", "sceUsbstorGetStatus"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceUtility") and options.include_sceUtility)) {
        asm(macro.import_module_start("sceUtility", "0x40010000", "56"));
        asm(macro.import_function("sceUtility", "0xC492F751", "sceUtilityGameSharingInitStart"));
        asm(macro.import_function("sceUtility", "0xEFC6F80F", "sceUtilityGameSharingShutdownStart"));
        asm(macro.import_function("sceUtility", "0x7853182D", "sceUtilityGameSharingUpdate"));
        asm(macro.import_function("sceUtility", "0x946963F3", "sceUtilityGameSharingGetStatus"));
        asm(macro.import_function("sceUtility", "0x3AD50AE7", "sceNetplayDialogInitStart"));
        asm(macro.import_function("sceUtility", "0xBC6B6296", "sceNetplayDialogShutdownStart"));
        asm(macro.import_function("sceUtility", "0x417BED54", "sceNetplayDialogUpdate"));
        asm(macro.import_function("sceUtility", "0xB6CEE597", "sceNetplayDialogGetStatus"));
        asm(macro.import_function("sceUtility", "0x4DB1E739", "sceUtilityNetconfInitStart"));
        asm(macro.import_function("sceUtility", "0xF88155F6", "sceUtilityNetconfShutdownStart"));
        asm(macro.import_function("sceUtility", "0x91E70E35", "sceUtilityNetconfUpdate"));
        asm(macro.import_function("sceUtility", "0x6332AA39", "sceUtilityNetconfGetStatus"));
        asm(macro.import_function("sceUtility", "0x50C4CD57", "sceUtilitySavedataInitStart"));
        asm(macro.import_function("sceUtility", "0x9790B33C", "sceUtilitySavedataShutdownStart"));
        asm(macro.import_function("sceUtility", "0xD4B95FFB", "sceUtilitySavedataUpdate"));
        asm(macro.import_function("sceUtility", "0x8874DBE0", "sceUtilitySavedataGetStatus"));
        asm(macro.import_function("sceUtility", "0x2995D020", "sceUtility_2995D020"));
        asm(macro.import_function("sceUtility", "0xB62A4061", "sceUtility_B62A4061"));
        asm(macro.import_function("sceUtility", "0xED0FAD38", "sceUtility_ED0FAD38"));
        asm(macro.import_function("sceUtility", "0x88BC7406", "sceUtility_88BC7406"));
        asm(macro.import_function("sceUtility", "0x2AD8E239", "sceUtilityMsgDialogInitStart"));
        asm(macro.import_function("sceUtility", "0x67AF3428", "sceUtilityMsgDialogShutdownStart"));
        asm(macro.import_function("sceUtility", "0x95FC253B", "sceUtilityMsgDialogUpdate"));
        asm(macro.import_function("sceUtility", "0x9A1C91D7", "sceUtilityMsgDialogGetStatus"));
        asm(macro.import_function("sceUtility", "0xF6269B82", "sceUtilityOskInitStart"));
        asm(macro.import_function("sceUtility", "0x3DFAEBA9", "sceUtilityOskShutdownStart"));
        asm(macro.import_function("sceUtility", "0x4B85C861", "sceUtilityOskUpdate"));
        asm(macro.import_function("sceUtility", "0xF3F76017", "sceUtilityOskGetStatus"));
        asm(macro.import_function("sceUtility", "0x45C18506", "sceUtilitySetSystemParamInt"));
        asm(macro.import_function("sceUtility", "0x41E30674", "sceUtilitySetSystemParamString"));
        asm(macro.import_function("sceUtility", "0xA5DA2406", "sceUtilityGetSystemParamInt"));
        asm(macro.import_function("sceUtility", "0x34B78343", "sceUtilityGetSystemParamString"));
        asm(macro.import_function("sceUtility", "0x5EEE6548", "sceUtilityCheckNetParam"));
        asm(macro.import_function("sceUtility", "0x434D4B3A", "sceUtilityGetNetParam"));
        asm(macro.import_function("sceUtility", "0x1579a159", "sceUtilityLoadNetModule"));
        asm(macro.import_function("sceUtility", "0x64d50c56", "sceUtilityUnloadNetModule"));
        asm(macro.import_function("sceUtility", "0xC629AF26", "sceUtilityLoadAvModule"));
        asm(macro.import_function("sceUtility", "0xF7D8D092", "sceUtilityUnloadAvModule"));
        asm(macro.import_function("sceUtility", "0x0D5BC6D2", "sceUtilityLoadUsbModule"));
        asm(macro.import_function("sceUtility", "0xF64910F0", "sceUtilityUnloadUsbModule"));
        asm(macro.import_function("sceUtility", "0x4928BD96", "sceUtilityMsgDialogAbort"));
        asm(macro.import_function("sceUtility", "0x05AFB9E4", "sceUtilityHtmlViewerUpdate"));
        asm(macro.import_function("sceUtility", "0xBDA7D894", "sceUtilityHtmlViewerGetStatus"));
        asm(macro.import_function("sceUtility", "0xCDC3AA41", "sceUtilityHtmlViewerInitStart"));
        asm(macro.import_function("sceUtility", "0xF5CE1134", "sceUtilityHtmlViewerShutdownStart"));
        asm(macro.import_function("sceUtility", "0x2A2B3DE0", "sceUtilityLoadModule"));
        asm(macro.import_function("sceUtility", "0xE49BFE92", "sceUtilityUnloadModule"));
        asm(macro.import_function("sceUtility", "0x0251B134", "sceUtilityScreenshotInitStart"));
        asm(macro.import_function("sceUtility", "0xF9E0008C", "sceUtilityScreenshotShutdownStart"));
        asm(macro.import_function("sceUtility", "0xAB083EA9", "sceUtilityScreenshotUpdate"));
        asm(macro.import_function("sceUtility", "0xD81957B7", "sceUtilityScreenshotGetStatus"));
        asm(macro.import_function("sceUtility", "0x86A03A27", "sceUtilityScreenshotContStart"));
        asm(macro.import_function("sceUtility", "0x16D02AF0", "sceUtilityNpSigninInitStart"));
        asm(macro.import_function("sceUtility", "0xE19C97D6", "sceUtilityNpSigninShutdownStart"));
        asm(macro.import_function("sceUtility", "0xF3FBC572", "sceUtilityNpSigninUpdate"));
        asm(macro.import_function("sceUtility", "0x86ABDB1B", "sceUtilityNpSigninGetStatus"));
    }

    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "include_sceUtility_netparam_internal") and options.include_sceUtility_netparam_internal)) {
        asm(macro.import_module_start("sceUtility_netparam_internal", "0x40010000", "4"));
        asm(macro.import_function("sceUtility_netparam_internal", "0x072DEBF2", "sceUtilityCreateNetParam"));
        asm(macro.import_function("sceUtility_netparam_internal", "0x9CE50172", "sceUtilityDeleteNetParam"));
        asm(macro.import_function("sceUtility_netparam_internal", "0xFB0C4840", "sceUtilityCopyNetParam"));
        asm(macro.import_function("sceUtility_netparam_internal", "0xFC4516F3", "sceUtilitySetNetParam"));
    }

}
