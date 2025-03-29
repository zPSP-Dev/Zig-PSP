const std = @import("std");

pub fn addOptions(b: *std.Build) *std.Build.Options {
    const options = b.addOptions();

    options.addOption(bool, "everything", b.option(bool, "everything", "Enable all PSP libraries") orelse false);

    options.addOption(bool, "scePower", b.option(bool, "scePower", "Enable scePower library") orelse false);
    options.addOption(bool, "sceVideocodec", b.option(bool, "sceVideocodec", "Enable sceVideocodec library") orelse false);
    options.addOption(bool, "sceNetInet", b.option(bool, "sceNetInet", "Enable sceNetInet library") orelse false);
    options.addOption(bool, "sceNetApctl", b.option(bool, "sceNetApctl", "Enable sceNetApctl library") orelse false);
    options.addOption(bool, "sceHttp", b.option(bool, "sceHttp", "Enable sceHttp library") orelse false);
    options.addOption(bool, "sceNet", b.option(bool, "sceNet", "Enable sceNet library") orelse false);
    options.addOption(bool, "sceNetResolver", b.option(bool, "sceNetResolver", "Enable sceNetResolver library") orelse false);
    options.addOption(bool, "sceNet_lib", b.option(bool, "sceNet_lib", "Enable sceNet_lib library") orelse false);
    options.addOption(bool, "sceNetAdhocctl", b.option(bool, "sceNetAdhocctl", "Enable sceNetAdhocctl library") orelse false);
    options.addOption(bool, "sceNetAdhocMatching", b.option(bool, "sceNetAdhocMatching", "Enable sceNetAdhocMatching library") orelse false);
    options.addOption(bool, "sceNetAdhoc", b.option(bool, "sceNetAdhoc", "Enable sceNetAdhoc library") orelse false);
    options.addOption(bool, "sceSsl", b.option(bool, "sceSsl", "Enable sceSsl library") orelse false);
    options.addOption(bool, "sceJpeg", b.option(bool, "sceJpeg", "Enable sceJpeg library") orelse false);
    options.addOption(bool, "sceMpegbase", b.option(bool, "sceMpegbase", "Enable sceMpegbase library") orelse false);
    options.addOption(bool, "sceMpeg", b.option(bool, "sceMpeg", "Enable sceMpeg library") orelse false);
    options.addOption(bool, "sceHprm", b.option(bool, "sceHprm", "Enable sceHprm library") orelse false);
    options.addOption(bool, "sceUmdUser", b.option(bool, "sceUmdUser", "Enable sceUmdUser library") orelse false);
    options.addOption(bool, "sceCtrl", b.option(bool, "sceCtrl", "Enable sceCtrl library") orelse false);
    options.addOption(bool, "LoadExecForUser", b.option(bool, "LoadExecForUser", "Enable LoadExecForUser library") orelse false);
    options.addOption(bool, "Kernel_Library", b.option(bool, "Kernel_Library", "Enable Kernel_Library library") orelse false);
    options.addOption(bool, "sceImpose", b.option(bool, "sceImpose", "Enable sceImpose library") orelse false);
    options.addOption(bool, "SysMemUserForUser", b.option(bool, "SysMemUserForUser", "Enable SysMemUserForUser library") orelse false);
    options.addOption(bool, "sceSuspendForUser", b.option(bool, "sceSuspendForUser", "Enable sceSuspendForUser library") orelse false);
    options.addOption(bool, "ModuleMgrForUser", b.option(bool, "ModuleMgrForUser", "Enable ModuleMgrForUser library") orelse false);
    options.addOption(bool, "IoFileMgrForUser", b.option(bool, "IoFileMgrForUser", "Enable IoFileMgrForUser library") orelse false);
    options.addOption(bool, "UtilsForUser", b.option(bool, "UtilsForUser", "Enable UtilsForUser library") orelse false);
    options.addOption(bool, "InterruptManager", b.option(bool, "InterruptManager", "Enable InterruptManager library") orelse false);
    options.addOption(bool, "ThreadManForUser", b.option(bool, "ThreadManForUser", "Enable ThreadManForUser library") orelse false);
    options.addOption(bool, "StdioForUser", b.option(bool, "StdioForUser", "Enable StdioForUser library") orelse false);
    options.addOption(bool, "sceUsbCam", b.option(bool, "sceUsbCam", "Enable sceUsbCam library") orelse false);
    options.addOption(bool, "sceUsb", b.option(bool, "sceUsb", "Enable sceUsb library") orelse false);
    options.addOption(bool, "sceDmac", b.option(bool, "sceDmac", "Enable sceDmac library") orelse false);
    options.addOption(bool, "sceSircs", b.option(bool, "sceSircs", "Enable sceSircs library") orelse false);
    options.addOption(bool, "sceAudio", b.option(bool, "sceAudio", "Enable sceAudio library") orelse false);
    options.addOption(bool, "sceAudiocodec", b.option(bool, "sceAudiocodec", "Enable sceAudiocodec library") orelse false);
    options.addOption(bool, "sceGe_user", b.option(bool, "sceGe_user", "Enable sceGe_user library") orelse false);
    options.addOption(bool, "sceMp3", b.option(bool, "sceMp3", "Enable sceMp3 library") orelse false);
    options.addOption(bool, "sceRtc", b.option(bool, "sceRtc", "Enable sceRtc library") orelse false);
    options.addOption(bool, "sceVaudio", b.option(bool, "sceVaudio", "Enable sceVaudio library") orelse false);
    options.addOption(bool, "sceReg", b.option(bool, "sceReg", "Enable sceReg library") orelse false);
    options.addOption(bool, "sceWlanDrv_lib", b.option(bool, "sceWlanDrv_lib", "Enable sceWlanDrv_lib library") orelse false);
    options.addOption(bool, "sceWlanDrv", b.option(bool, "sceWlanDrv", "Enable sceWlanDrv library") orelse false);
    options.addOption(bool, "sceOpenPSID", b.option(bool, "sceOpenPSID", "Enable sceOpenPSID library") orelse false);
    options.addOption(bool, "sceDisplay", b.option(bool, "sceDisplay", "Enable sceDisplay library") orelse false);
    options.addOption(bool, "sceAtrac3plus", b.option(bool, "sceAtrac3plus", "Enable sceAtrac3plus library") orelse false);
    options.addOption(bool, "sceUsbstor", b.option(bool, "sceUsbstor", "Enable sceUsbstor library") orelse false);
    options.addOption(bool, "sceUtility", b.option(bool, "sceUtility", "Enable sceUtility library") orelse false);
    options.addOption(bool, "sceUtility_netparam_internal", b.option(bool, "sceUtility_netparam_internal", "Enable sceUtility_netparam_internal library") orelse false);

    return options;
}
