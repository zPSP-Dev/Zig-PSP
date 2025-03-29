const std = @import("std");

pub const Options = struct {
    everything: bool = false,
    scePower: bool = false,
    sceVideocodec: bool = false,
    sceNetInet: bool = false,
    sceNetApctl: bool = false,
    sceHttp: bool = false,
    sceNet: bool = false,
    sceNetResolver: bool = false,
    sceNet_lib: bool = false,
    sceNetAdhocctl: bool = false,
    sceNetAdhocMatching: bool = false,
    sceNetAdhoc: bool = false,
    sceSsl: bool = false,
    sceJpeg: bool = false,
    sceMpegbase: bool = false,
    sceMpeg: bool = false,
    sceHprm: bool = false,
    sceUmdUser: bool = false,
    sceCtrl: bool = false,
    LoadExecForUser: bool = false,
    Kernel_Library: bool = false,
    sceImpose: bool = false,
    SysMemUserForUser: bool = false,
    sceSuspendForUser: bool = false,
    ModuleMgrForUser: bool = false,
    IoFileMgrForUser: bool = false,
    UtilsForUser: bool = false,
    InterruptManager: bool = false,
    ThreadManForUser: bool = false,
    StdioForUser: bool = false,
    sceUsbCam: bool = false,
    sceUsb: bool = false,
    sceDmac: bool = false,
    sceSircs: bool = false,
    sceAudio: bool = false,
    sceAudiocodec: bool = false,
    sceGe_user: bool = false,
    sceMp3: bool = false,
    sceRtc: bool = false,
    sceVaudio: bool = false,
    sceReg: bool = false,
    sceWlanDrv_lib: bool = false,
    sceWlanDrv: bool = false,
    sceOpenPSID: bool = false,
    sceDisplay: bool = false,
    sceAtrac3plus: bool = false,
    sceUsbstor: bool = false,
    sceUtility: bool = false,
    sceUtility_netparam_internal: bool = false,
};

pub fn addOptions(b: *std.Build, options: Options) *std.Build.Step.Options {
    const step_options = b.addOptions();

    step_options.addOption(bool, "everything", options.everything);

    step_options.addOption(bool, "scePower", options.scePower);
    step_options.addOption(bool, "sceVideocodec", options.sceVideocodec);
    step_options.addOption(bool, "sceNetInet", options.sceNetInet);
    step_options.addOption(bool, "sceNetApctl", options.sceNetApctl);
    step_options.addOption(bool, "sceHttp", options.sceHttp);
    step_options.addOption(bool, "sceNet", options.sceNet);
    step_options.addOption(bool, "sceNetResolver", options.sceNetResolver);
    step_options.addOption(bool, "sceNet_lib", options.sceNet_lib);
    step_options.addOption(bool, "sceNetAdhocctl", options.sceNetAdhocctl);
    step_options.addOption(bool, "sceNetAdhocMatching", options.sceNetAdhocMatching);
    step_options.addOption(bool, "sceNetAdhoc", options.sceNetAdhoc);
    step_options.addOption(bool, "sceSsl", options.sceSsl);
    step_options.addOption(bool, "sceJpeg", options.sceJpeg);
    step_options.addOption(bool, "sceMpegbase", options.sceMpegbase);
    step_options.addOption(bool, "sceMpeg", options.sceMpeg);
    step_options.addOption(bool, "sceHprm", options.sceHprm);
    step_options.addOption(bool, "sceUmdUser", options.sceUmdUser);
    step_options.addOption(bool, "sceCtrl", options.sceCtrl);
    step_options.addOption(bool, "LoadExecForUser", options.LoadExecForUser);
    step_options.addOption(bool, "Kernel_Library", options.Kernel_Library);
    step_options.addOption(bool, "sceImpose", options.sceImpose);
    step_options.addOption(bool, "SysMemUserForUser", options.SysMemUserForUser);
    step_options.addOption(bool, "sceSuspendForUser", options.sceSuspendForUser);
    step_options.addOption(bool, "ModuleMgrForUser", options.ModuleMgrForUser);
    step_options.addOption(bool, "IoFileMgrForUser", options.IoFileMgrForUser);
    step_options.addOption(bool, "UtilsForUser", options.UtilsForUser);
    step_options.addOption(bool, "InterruptManager", options.InterruptManager);
    step_options.addOption(bool, "ThreadManForUser", options.ThreadManForUser);
    step_options.addOption(bool, "StdioForUser", options.StdioForUser);
    step_options.addOption(bool, "sceUsbCam", options.sceUsbCam);
    step_options.addOption(bool, "sceUsb", options.sceUsb);
    step_options.addOption(bool, "sceDmac", options.sceDmac);
    step_options.addOption(bool, "sceSircs", options.sceSircs);
    step_options.addOption(bool, "sceAudio", options.sceAudio);
    step_options.addOption(bool, "sceAudiocodec", options.sceAudiocodec);
    step_options.addOption(bool, "sceGe_user", options.sceGe_user);
    step_options.addOption(bool, "sceMp3", options.sceMp3);
    step_options.addOption(bool, "sceRtc", options.sceRtc);
    step_options.addOption(bool, "sceVaudio", options.sceVaudio);
    step_options.addOption(bool, "sceReg", options.sceReg);
    step_options.addOption(bool, "sceWlanDrv_lib", options.sceWlanDrv_lib);
    step_options.addOption(bool, "sceWlanDrv", options.sceWlanDrv);
    step_options.addOption(bool, "sceOpenPSID", options.sceOpenPSID);
    step_options.addOption(bool, "sceDisplay", options.sceDisplay);
    step_options.addOption(bool, "sceAtrac3plus", options.sceAtrac3plus);
    step_options.addOption(bool, "sceUsbstor", options.sceUsbstor);
    step_options.addOption(bool, "sceUtility", options.sceUtility);
    step_options.addOption(bool, "sceUtility_netparam_internal", options.sceUtility_netparam_internal);

    return step_options;
}
