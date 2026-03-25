// USB camera -- Go!Cam peripheral
//
// Wraps:
//   c/module/sceUsbCam.zig
//
// Note: This module has 54 functions. Most are thin wrappers;
// only documented functions with known signatures are wrapped here.
// Access undocumented stubs via sdk.c.sceUsbCam.

const c = @import("../c/modules.zig");
const internal = @import("internal.zig");
const check = internal.check;
const checkPositive = internal.checkPositive;
const ci = internal.ci;
const Error = internal.Error;

const cam = c.sceUsbCam;

// -- Re-exported types --------------------------------------------------

pub const SetupStillParam = c.types.PspUsbCamSetupStillParam;
pub const SetupStillExParam = c.types.PspUsbCamSetupStillExParam;
pub const SetupVideoParam = c.types.PspUsbCamSetupVideoParam;
pub const SetupVideoExParam = c.types.PspUsbCamSetupVideoExParam;

// -- Still image --------------------------------------------------------

pub fn setup_still(param: *SetupStillParam) Error!void {
    return check(cam.sceUsbCamSetupStill(param));
}

pub fn setup_still_ex(param: *SetupStillExParam) Error!void {
    return check(cam.sceUsbCamSetupStillEx(param));
}

pub fn still_input_blocking(buf: [*]u8, size: u32) Error!u32 {
    return checkPositive(u32, cam.sceUsbCamStillInputBlocking(buf, ci(size)));
}

pub fn still_input(buf: [*]u8, size: u32) Error!u32 {
    return checkPositive(u32, cam.sceUsbCamStillInput(buf, ci(size)));
}

pub fn still_wait_input_end() Error!void {
    return check(cam.sceUsbCamStillWaitInputEnd());
}

pub fn still_poll_input_end() Error!void {
    return check(cam.sceUsbCamStillPollInputEnd());
}

pub fn still_cancel_input() Error!void {
    return check(cam.sceUsbCamStillCancelInput());
}

pub fn still_get_input_length() Error!u32 {
    return checkPositive(u32, cam.sceUsbCamStillGetInputLength());
}

// -- Video --------------------------------------------------------------

pub fn setup_video(param: *SetupVideoParam, work_area: ?*anyopaque, work_area_size: u32) Error!void {
    return check(cam.sceUsbCamSetupVideo(param, work_area, ci(work_area_size)));
}

pub fn setup_video_ex(param: *SetupVideoExParam, work_area: ?*anyopaque, work_area_size: u32) Error!void {
    return check(cam.sceUsbCamSetupVideoEx(param, work_area, ci(work_area_size)));
}

pub fn start_video() Error!void {
    return check(cam.sceUsbCamStartVideo());
}

pub fn stop_video() Error!void {
    return check(cam.sceUsbCamStopVideo());
}

pub fn read_video_frame_blocking(buf: [*]u8, size: u32) Error!u32 {
    return checkPositive(u32, cam.sceUsbCamReadVideoFrameBlocking(buf, ci(size)));
}

pub fn read_video_frame(buf: [*]u8, size: u32) Error!u32 {
    return checkPositive(u32, cam.sceUsbCamReadVideoFrame(buf, ci(size)));
}

pub fn wait_read_video_frame_end() Error!void {
    return check(cam.sceUsbCamWaitReadVideoFrameEnd());
}

pub fn poll_read_video_frame_end() Error!void {
    return check(cam.sceUsbCamPollReadVideoFrameEnd());
}

pub fn get_read_video_frame_size() Error!u32 {
    return checkPositive(u32, cam.sceUsbCamGetReadVideoFrameSize());
}

// -- Settings -----------------------------------------------------------

pub fn set_saturation(saturation: i32) Error!void {
    return check(cam.sceUsbCamSetSaturation(@as(c_int, saturation)));
}

pub fn set_brightness(brightness: i32) Error!void {
    return check(cam.sceUsbCamSetBrightness(@as(c_int, brightness)));
}

pub fn set_contrast(contrast: i32) Error!void {
    return check(cam.sceUsbCamSetContrast(@as(c_int, contrast)));
}

pub fn set_sharpness(sharpness: i32) Error!void {
    return check(cam.sceUsbCamSetSharpness(@as(c_int, sharpness)));
}

pub fn set_image_effect_mode(mode: i32) Error!void {
    return check(cam.sceUsbCamSetImageEffectMode(@as(c_int, mode)));
}

pub fn set_ev_level(level: i32) Error!void {
    return check(cam.sceUsbCamSetEvLevel(@as(c_int, level)));
}

pub fn set_reverse_mode(mode: i32) Error!void {
    return check(cam.sceUsbCamSetReverseMode(@as(c_int, mode)));
}

pub fn set_zoom(zoom: i32) Error!void {
    return check(cam.sceUsbCamSetZoom(@as(c_int, zoom)));
}

pub fn get_saturation(saturation: *i32) Error!void {
    return check(cam.sceUsbCamGetSaturation(@ptrCast(saturation)));
}

pub fn get_brightness(brightness: *i32) Error!void {
    return check(cam.sceUsbCamGetBrightness(@ptrCast(brightness)));
}

pub fn get_contrast(contrast: *i32) Error!void {
    return check(cam.sceUsbCamGetContrast(@ptrCast(contrast)));
}

pub fn get_sharpness(sharpness: *i32) Error!void {
    return check(cam.sceUsbCamGetSharpness(@ptrCast(sharpness)));
}

pub fn get_image_effect_mode(mode: *i32) Error!void {
    return check(cam.sceUsbCamGetImageEffectMode(@ptrCast(mode)));
}

pub fn get_ev_level(level: *i32) Error!void {
    return check(cam.sceUsbCamGetEvLevel(@ptrCast(level)));
}

pub fn get_reverse_mode(mode: *i32) Error!void {
    return check(cam.sceUsbCamGetReverseMode(@ptrCast(mode)));
}

pub fn get_zoom(zoom: *i32) Error!void {
    return check(cam.sceUsbCamGetZoom(@ptrCast(zoom)));
}

// -- Auto image reverse -------------------------------------------------

pub fn auto_image_reverse_sw(on: bool) Error!void {
    return check(cam.sceUsbCamAutoImageReverseSW(@intFromBool(on)));
}

pub fn get_auto_image_reverse_state() bool {
    return cam.sceUsbCamGetAutoImageReverseState() != 0;
}

// -- Microphone ---------------------------------------------------------

pub fn setup_mic(param: ?*anyopaque, work_area: ?*anyopaque, work_area_size: u32) Error!void {
    return check(cam.sceUsbCamSetupMic(param, work_area, ci(work_area_size)));
}

pub fn start_mic() Error!void {
    return check(cam.sceUsbCamStartMic());
}

pub fn stop_mic() Error!void {
    return check(cam.sceUsbCamStopMic());
}

pub fn read_mic_blocking(buf: [*]u8, size: u32) Error!u32 {
    return checkPositive(u32, cam.sceUsbCamReadMicBlocking(buf, ci(size)));
}

pub fn read_mic(buf: [*]u8, size: u32) Error!u32 {
    return checkPositive(u32, cam.sceUsbCamReadMic(buf, ci(size)));
}

pub fn get_mic_data_length() Error!u32 {
    return checkPositive(u32, cam.sceUsbCamGetMicDataLength());
}

pub fn wait_read_mic_end() Error!void {
    return check(cam.sceUsbCamWaitReadMicEnd());
}

pub fn poll_read_mic_end() Error!void {
    return check(cam.sceUsbCamPollReadMicEnd());
}

pub fn set_mic_gain(gain: i32) Error!void {
    return check(cam.sceUsbCamSetMicGain(@as(c_int, gain)));
}

pub fn get_lensDirection() Error!u32 {
    return checkPositive(u32, cam.sceUsbCamGetLensDirection());
}
