usingnamespace @import("psptypes.zig");

pub const enum_PspUsbCamResolution = extern enum(c_int) {
    PSP_USBCAM_RESOLUTION_160_120 = 0,
    PSP_USBCAM_RESOLUTION_176_144 = 1,
    PSP_USBCAM_RESOLUTION_320_240 = 2,
    PSP_USBCAM_RESOLUTION_352_288 = 3,
    PSP_USBCAM_RESOLUTION_640_480 = 4,
    PSP_USBCAM_RESOLUTION_1024_768 = 5,
    PSP_USBCAM_RESOLUTION_1280_960 = 6,
    PSP_USBCAM_RESOLUTION_480_272 = 7,
    PSP_USBCAM_RESOLUTION_360_272 = 8,
    _,
};
pub const enum_PspUsbCamResolutionEx = extern enum(c_int) {
    PSP_USBCAM_RESOLUTION_EX_160_120 = 0,
    PSP_USBCAM_RESOLUTION_EX_176_144 = 1,
    PSP_USBCAM_RESOLUTION_EX_320_240 = 2,
    PSP_USBCAM_RESOLUTION_EX_352_288 = 3,
    PSP_USBCAM_RESOLUTION_EX_360_272 = 4,
    PSP_USBCAM_RESOLUTION_EX_480_272 = 5,
    PSP_USBCAM_RESOLUTION_EX_640_480 = 6,
    PSP_USBCAM_RESOLUTION_EX_1024_768 = 7,
    PSP_USBCAM_RESOLUTION_EX_1280_960 = 8,
    _,
};
pub const enum_PspUsbCamReverseFlags = extern enum(c_int) {
    PSP_USBCAM_FLIP = 1,
    PSP_USBCAM_MIRROR = 256,
    _,
};
pub const enum_PspUsbCamDelay = extern enum(c_int) {
    PSP_USBCAM_NODELAY = 0,
    PSP_USBCAM_DELAY_10SEC = 1,
    PSP_USBCAM_DELAY_20SEC = 2,
    PSP_USBCAM_DELAY_30SEC = 3,
    _,
};
pub const enum_PspUsbCamFrameRate = extern enum(c_int) {
    PSP_USBCAM_FRAMERATE_3_75_FPS = 0,
    PSP_USBCAM_FRAMERATE_5_FPS = 1,
    PSP_USBCAM_FRAMERATE_7_5_FPS = 2,
    PSP_USBCAM_FRAMERATE_10_FPS = 3,
    PSP_USBCAM_FRAMERATE_15_FPS = 4,
    PSP_USBCAM_FRAMERATE_20_FPS = 5,
    PSP_USBCAM_FRAMERATE_30_FPS = 6,
    PSP_USBCAM_FRAMERATE_60_FPS = 7,
    _,
};
pub const enum_PspUsbCamWB = extern enum(c_int) {
    PSP_USBCAM_WB_AUTO = 0,
    PSP_USBCAM_WB_DAYLIGHT = 1,
    PSP_USBCAM_WB_FLUORESCENT = 2,
    PSP_USBCAM_WB_INCADESCENT = 3,
    _,
};
pub const enum_PspUsbCamEffectMode = extern enum(c_int) {
    PSP_USBCAM_EFFECTMODE_NORMAL = 0,
    PSP_USBCAM_EFFECTMODE_NEGATIVE = 1,
    PSP_USBCAM_EFFECTMODE_BLACKWHITE = 2,
    PSP_USBCAM_EFFECTMODE_SEPIA = 3,
    PSP_USBCAM_EFFECTMODE_BLUE = 4,
    PSP_USBCAM_EFFECTMODE_RED = 5,
    PSP_USBCAM_EFFECTMODE_GREEN = 6,
    _,
};
pub const enum_PspUsbCamEVLevel = extern enum(c_int) {
    PSP_USBCAM_EVLEVEL_2_0_POSITIVE = 0,
    PSP_USBCAM_EVLEVEL_1_7_POSITIVE = 1,
    PSP_USBCAM_EVLEVEL_1_5_POSITIVE = 2,
    PSP_USBCAM_EVLEVEL_1_3_POSITIVE = 3,
    PSP_USBCAM_EVLEVEL_1_0_POSITIVE = 4,
    PSP_USBCAM_EVLEVEL_0_7_POSITIVE = 5,
    PSP_USBCAM_EVLEVEL_0_5_POSITIVE = 6,
    PSP_USBCAM_EVLEVEL_0_3_POSITIVE = 7,
    PSP_USBCAM_EVLEVEL_0_0 = 8,
    PSP_USBCAM_EVLEVEL_0_3_NEGATIVE = 9,
    PSP_USBCAM_EVLEVEL_0_5_NEGATIVE = 10,
    PSP_USBCAM_EVLEVEL_0_7_NEGATIVE = 11,
    PSP_USBCAM_EVLEVEL_1_0_NEGATIVE = 12,
    PSP_USBCAM_EVLEVEL_1_3_NEGATIVE = 13,
    PSP_USBCAM_EVLEVEL_1_5_NEGATIVE = 14,
    PSP_USBCAM_EVLEVEL_1_7_NEGATIVE = 15,
    PSP_USBCAM_EVLEVEL_2_0_NEGATIVE = 16,
    _,
};
pub const struct_PspUsbCamSetupStillParam = extern struct {
    size: c_int,
    resolution: c_int,
    jpegsize: c_int,
    reverseflags: c_int,
    delay: c_int,
    complevel: c_int,
};
pub const PspUsbCamSetupStillParam = struct_PspUsbCamSetupStillParam;
pub const struct_PspUsbCamSetupStillExParam = extern struct {
    size: c_int,
    unk: u32_3,
    resolution: c_int,
    jpegsize: c_int,
    complevel: c_int,
    unk2: u32_3,
    unk3: u32_3,
    flip: c_int,
    mirror: c_int,
    delay: c_int,
    unk4: [5]u32_3,
};
pub const PspUsbCamSetupStillExParam = struct_PspUsbCamSetupStillExParam;
pub const struct_PspUsbCamSetupVideoParam = extern struct {
    size: c_int,
    resolution: c_int,
    framerate: c_int,
    wb: c_int,
    saturation: c_int,
    brightness: c_int,
    contrast: c_int,
    sharpness: c_int,
    effectmode: c_int,
    framesize: c_int,
    unk: u32_3,
    evlevel: c_int,
};
pub const PspUsbCamSetupVideoParam = struct_PspUsbCamSetupVideoParam;
pub const struct_PspUsbCamSetupVideoExParam = extern struct {
    size: c_int,
    unk: u32_3,
    resolution: c_int,
    framerate: c_int,
    unk2: u32_3,
    unk3: u32_3,
    wb: c_int,
    saturation: c_int,
    brightness: c_int,
    contrast: c_int,
    sharpness: c_int,
    unk4: u32_3,
    unk5: u32_3,
    unk6: [3]u32_3,
    effectmode: c_int,
    unk7: u32_3,
    unk8: u32_3,
    unk9: u32_3,
    unk10: u32_3,
    unk11: u32_3,
    framesize: c_int,
    unk12: u32_3,
    evlevel: c_int,
};
pub const PspUsbCamSetupVideoExParam = struct_PspUsbCamSetupVideoExParam;
pub extern fn sceUsbCamSetupStill(param: [*c]PspUsbCamSetupStillParam) c_int;
pub extern fn sceUsbCamSetupStillEx(param: [*c]PspUsbCamSetupStillExParam) c_int;
pub extern fn sceUsbCamStillInputBlocking(buf: [*c]u8_1, size: SceSize) c_int;
pub extern fn sceUsbCamStillInput(buf: [*c]u8_1, size: SceSize) c_int;
pub extern fn sceUsbCamStillWaitInputEnd() c_int;
pub extern fn sceUsbCamStillPollInputEnd() c_int;
pub extern fn sceUsbCamStillCancelInput() c_int;
pub extern fn sceUsbCamStillGetInputLength() c_int;
pub extern fn sceUsbCamSetupVideo(param: [*c]PspUsbCamSetupVideoParam, workarea: ?*c_void, wasize: c_int) c_int;
pub extern fn sceUsbCamSetupVideoEx(param: [*c]PspUsbCamSetupVideoExParam, workarea: ?*c_void, wasize: c_int) c_int;
pub extern fn sceUsbCamStartVideo() c_int;
pub extern fn sceUsbCamStopVideo() c_int;
pub extern fn sceUsbCamReadVideoFrameBlocking(buf: [*c]u8_1, size: SceSize) c_int;
pub extern fn sceUsbCamReadVideoFrame(buf: [*c]u8_1, size: SceSize) c_int;
pub extern fn sceUsbCamWaitReadVideoFrameEnd() c_int;
pub extern fn sceUsbCamPollReadVideoFrameEnd() c_int;
pub extern fn sceUsbCamGetReadVideoFrameSize() c_int;
pub extern fn sceUsbCamSetSaturation(saturation: c_int) c_int;
pub extern fn sceUsbCamSetBrightness(brightness: c_int) c_int;
pub extern fn sceUsbCamSetContrast(contrast: c_int) c_int;
pub extern fn sceUsbCamSetSharpness(sharpness: c_int) c_int;
pub extern fn sceUsbCamSetImageEffectMode(effectmode: c_int) c_int;
pub extern fn sceUsbCamSetEvLevel(ev: c_int) c_int;
pub extern fn sceUsbCamSetReverseMode(reverseflags: c_int) c_int;
pub extern fn sceUsbCamSetZoom(zoom: c_int) c_int;
pub extern fn sceUsbCamGetSaturation(saturation: [*c]c_int) c_int;
pub extern fn sceUsbCamGetBrightness(brightness: [*c]c_int) c_int;
pub extern fn sceUsbCamGetContrast(contrast: [*c]c_int) c_int;
pub extern fn sceUsbCamGetSharpness(sharpness: [*c]c_int) c_int;
pub extern fn sceUsbCamGetImageEffectMode(effectmode: [*c]c_int) c_int;
pub extern fn sceUsbCamGetEvLevel(ev: [*c]c_int) c_int;
pub extern fn sceUsbCamGetReverseMode(reverseflags: [*c]c_int) c_int;
pub extern fn sceUsbCamGetZoom(zoom: [*c]c_int) c_int;
pub extern fn sceUsbCamAutoImageReverseSW(on: c_int) c_int;
pub extern fn sceUsbCamGetAutoImageReverseState() c_int;
pub extern fn sceUsbCamGetLensDirection() c_int;

pub const PSP_USBCAM_PID = 0x282;
pub const PSP_USBCAM_DRIVERNAME = "USBCamDriver";
pub const PSP_USBCAMMIC_DRIVERNAME = "USBCamMicDriver";
pub const PspUsbCamResolution = enum_PspUsbCamResolution;
pub const PspUsbCamResolutionEx = enum_PspUsbCamResolutionEx;
pub const PspUsbCamReverseFlags = enum_PspUsbCamReverseFlags;
pub const PspUsbCamDelay = enum_PspUsbCamDelay;
pub const PspUsbCamFrameRate = enum_PspUsbCamFrameRate;
pub const PspUsbCamWB = enum_PspUsbCamWB;
pub const PspUsbCamEffectMode = enum_PspUsbCamEffectMode;
pub const PspUsbCamEVLevel = enum_PspUsbCamEVLevel;
