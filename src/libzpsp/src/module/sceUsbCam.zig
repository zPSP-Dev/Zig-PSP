// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

pub extern fn sceUsbCamSetupMic() callconv(.c) void;

pub extern fn sceUsbCamSetMicGain() callconv(.c) void;

/// Sets the contrast
/// `contrast` - The contrast (0-255)
/// Returns 0 on success, < 0 on error
pub extern fn sceUsbCamSetContrast(contrast: c_int) callconv(.c) c_int;

/// Setups the parameters to take a still image (with more options)
/// `param` - pointer to a ::PspUsbCamSetupStillExParam
/// Returns 0 on success, < 0 on error
pub extern fn sceUsbCamSetupStillEx(param: [*c]types.PspUsbCamSetupStillExParam) callconv(.c) c_int;

/// Gets the state of the autoreversal of the image.
/// Returns 1 if it is set to automatic, 0 otherwise
pub extern fn sceUsbCamGetAutoImageReverseState() callconv(.c) c_int;

/// Set ups the parameters for video capture.
/// `param` - Pointer to a ::PspUsbCamSetupVideoParam structure.
/// `workarea` - Pointer to a buffer used as work area by the driver.
/// `wasize` - Size of the work area.
/// Returns 0 on success, < 0 on error
pub extern fn sceUsbCamSetupVideo(param: [*c]types.PspUsbCamSetupVideoParam, workarea: ?*anyopaque, wasize: c_int) callconv(.c) c_int;

/// Polls the status of still input completion.
/// Returns the size of the acquired image if still input has ended,
/// 0 if the input has not ended, < 0 on error.
pub extern fn sceUsbCamStillPollInputEnd() callconv(.c) c_int;

/// Sets the exposure level
/// `ev` - The exposure level, one of ::PspUsbCamEVLevel
/// Returns 0 on success, < 0 on error
pub extern fn sceUsbCamSetEvLevel(ev: c_int) callconv(.c) c_int;

pub extern fn sceUsbCam_1E958148() callconv(.c) void;

/// Gets the current exposure level.
/// `ev` - pointer to a variable that receives the current exposure level
/// Returns 0 on success, < 0 on error
pub extern fn sceUsbCamGetEvLevel(ev: [*c]c_int) callconv(.c) c_int;

pub extern fn sceUsbCamSetupMicEx() callconv(.c) void;

pub extern fn sceUsbCamReadMicBlocking() callconv(.c) void;

/// Gets the current saturation
/// `saturation` - pointer to a variable that receives the current saturation
/// Returns 0 on success, < 0 on error
pub extern fn sceUsbCamGetSaturation(saturation: [*c]c_int) callconv(.c) c_int;

pub extern fn sceUsbCamReadMic() callconv(.c) void;

/// Setups the parameters to take a still image.
/// `param` - pointer to a ::PspUsbCamSetupStillParam
/// Returns 0 on success, < 0 on error
pub extern fn sceUsbCamSetupStill(param: [*c]types.PspUsbCamSetupStillParam) callconv(.c) c_int;

/// Polls the status of video frame read completion.
/// Returns the size of the acquired frame if it has been read,
/// 0 if the frame has not yet been read, < 0 on error.
pub extern fn sceUsbCamPollReadVideoFrameEnd() callconv(.c) c_int;

pub extern fn sceUsbCamUnregisterLensRotationCallback() callconv(.c) void;

/// Gets the direction of the camera lens
/// Returns 1 if the camera is "looking to you", 0 if the camera
/// is "looking to the other side".
pub extern fn sceUsbCamGetLensDirection() callconv(.c) c_int;

/// Sets the brightness
/// `brightness` - The brightness (0-255)
/// Returns 0 on success, < 0 on error
pub extern fn sceUsbCamSetBrightness(brightness: c_int) callconv(.c) c_int;

pub extern fn sceUsbCamStopMic() callconv(.c) void;

/// Starts video input from the camera.
/// Returns 0 on success, < 0 on error
pub extern fn sceUsbCamStartVideo() callconv(.c) c_int;

pub extern fn sceUsbCamGetMicDataLength() callconv(.c) void;

/// Gets a still image. The function doesn't return until the image
/// has been acquired.
/// `buf` - The buffer that receives the image jpeg data
/// `size` - The size of the buffer.
/// Returns size of acquired image on success, < 0 on error
pub extern fn sceUsbCamStillInputBlocking(buf: [*c]u8, size: types.SceSize) callconv(.c) c_int;

/// Sets the sharpness
/// `sharpness` - The sharpness (0-255)
/// Returns 0 on success, < 0 on error
pub extern fn sceUsbCamSetSharpness(sharpness: c_int) callconv(.c) c_int;

pub extern fn sceUsbCamSetAntiFlicker() callconv(.c) void;

/// Stops video input from the camera.
/// Returns 0 on success, < 0 on error
pub extern fn sceUsbCamStopVideo() callconv(.c) c_int;

/// Sets the saturation
/// `saturation` - The saturation (0-255)
/// Returns 0 on success, < 0 on error
pub extern fn sceUsbCamSetSaturation(saturation: c_int) callconv(.c) c_int;

/// Gets the current brightness
/// `brightness` - pointer to a variable that receives the current brightness
/// Returns 0 on success, < 0 on error
pub extern fn sceUsbCamGetBrightness(brightness: [*c]c_int) callconv(.c) c_int;

/// Waits untils still input has been finished.
/// Returns the size of the acquired image on sucess, < 0 on error
pub extern fn sceUsbCamStillWaitInputEnd() callconv(.c) c_int;

/// Reads a video frame. The function doesn't return until the frame
/// has been acquired.
/// `buf` - The buffer that receives the frame jpeg data
/// `size` - The size of the buffer.
/// Returns size of acquired frame on success, < 0 on error
pub extern fn sceUsbCamReadVideoFrameBlocking(buf: [*c]u8, size: types.SceSize) callconv(.c) c_int;

pub extern fn sceUsbCamStartMic() callconv(.c) void;

/// Sets the reverse mode
/// `reverseflags` - The reverse flags, zero or more of ::PspUsbCamReverseFlags
/// Returns 0 on success, < 0 on error
pub extern fn sceUsbCamSetReverseMode(reverseflags: c_int) callconv(.c) c_int;

pub extern fn sceUsbCam_95F8901E() callconv(.c) void;

/// Gets the current image efect mode
/// `effectmode` - pointer to a variable that receives the current effect mode
/// Returns 0 on success, < 0 on error
pub extern fn sceUsbCamGetImageEffectMode(effectmode: [*c]c_int) callconv(.c) c_int;

/// Reads a video frame. The function returns inmediately, and
/// the completion has to be handled by calling ::sceUsbCamWaitReadVideoFrameEnd
/// or ::sceUsbCamPollReadVideoFrameEnd.
/// `buf` - The buffer that receives the frame jpeg data
/// `size` - The size of the buffer.
/// Returns 0 on success, < 0 on error
/// Reads a video frame. The function doesn't return until the frame
/// has been acquired.
/// `buf` - The buffer that receives the frame jpeg data
/// `size` - The size of the buffer.
/// Returns size of acquired frame on success, < 0 on error
pub extern fn sceUsbCamReadVideoFrame(buf: [*c]u8, size: types.SceSize) callconv(.c) c_int;

/// Gets the current zoom.
/// `zoom` - pointer to a variable that receives the current zoom
/// Returns 0 on success, < 0 on error
pub extern fn sceUsbCamGetZoom(zoom: [*c]c_int) callconv(.c) c_int;

/// Gets the current contrast
/// `contrast` - pointer to a variable that receives the current contrast
/// Returns 0 on success, < 0 on error
pub extern fn sceUsbCamGetContrast(contrast: [*c]c_int) callconv(.c) c_int;

/// Cancels the still input.
/// Returns 0 on success, < 0 on error
pub extern fn sceUsbCamStillCancelInput() callconv(.c) c_int;

pub extern fn sceUsbCamGetAntiFlicker() callconv(.c) void;

pub extern fn sceUsbCamWaitReadMicEnd() callconv(.c) void;

/// Sets the zoom.
/// `zoom` - The zoom level starting by 10. (10 = 1X, 11 = 1.1X, etc)
/// Returns s 0 on success, < 0 on error
pub extern fn sceUsbCamSetZoom(zoom: c_int) callconv(.c) c_int;

pub extern fn sceUsbCam_C72ED6D3() callconv(.c) void;

/// Set ups the parameters for video capture (with more options)
/// `param` - Pointer to a ::PspUsbCamSetupVideoExParam structure.
/// `workarea` - Pointer to a buffer used as work area by the driver.
/// `wasize` - Size of the work area.
/// Returns 0 on success, < 0 on error
pub extern fn sceUsbCamSetupVideoEx(param: [*c]types.PspUsbCamSetupVideoExParam, workarea: ?*anyopaque, wasize: c_int) callconv(.c) c_int;

pub extern fn sceUsbCamRegisterLensRotationCallback() callconv(.c) void;

/// Sets the image effect mode
/// `effectmode` - The effect mode, one of ::PspUsbCamEffectMode
/// Returns 0 on success, < 0 on error
pub extern fn sceUsbCamSetImageEffectMode(effectmode: c_int) callconv(.c) c_int;

/// Gets the current reverse mode.
/// `reverseflags` - pointer to a variable that receives the current reverse mode flags
/// Returns 0 on success, < 0 on error
pub extern fn sceUsbCamGetReverseMode(reverseflags: [*c]c_int) callconv(.c) c_int;

pub extern fn sceUsbCam_D865997B() callconv(.c) void;

/// Gets the size of the acquired frame.
/// Returns the size of the acquired frame on success, < 0 on error
pub extern fn sceUsbCamGetReadVideoFrameSize() callconv(.c) c_int;

/// Gets the size of the acquired still image.
/// Returns the size of the acquired image on success, < 0 on error
pub extern fn sceUsbCamStillGetInputLength() callconv(.c) c_int;

pub extern fn sceUsbCamPollReadMicEnd() callconv(.c) void;

/// Waits untils the current frame has been read.
/// Returns the size of the acquired frame on sucess, < 0 on error
pub extern fn sceUsbCamWaitReadVideoFrameEnd() callconv(.c) c_int;

/// Sets if the image should be automatically reversed, depending of the position
/// of the camera.
/// `on` - 1 to set the automatical reversal of the image, 0 to set it off
/// Returns 0 on success, < 0 on error
pub extern fn sceUsbCamAutoImageReverseSW(on: c_int) callconv(.c) c_int;

/// Gets a still image. The function returns inmediately, and
/// the completion has to be handled by calling ::sceUsbCamStillWaitInputEnd
/// or ::sceUsbCamStillPollInputEnd.
/// `buf` - The buffer that receives the image jpeg data
/// `size` - The size of the buffer.
/// Returns 0 on success, < 0 on error
/// Gets a still image. The function doesn't return until the image
/// has been acquired.
/// `buf` - The buffer that receives the image jpeg data
/// `size` - The size of the buffer.
/// Returns size of acquired image on success, < 0 on error
pub extern fn sceUsbCamStillInput(buf: [*c]u8, size: types.SceSize) callconv(.c) c_int;

/// Gets the current sharpness
/// `sharpness` - pointer to a variable that receives the current sharpness
/// Returns 0 on success, < 0 on error
pub extern fn sceUsbCamGetSharpness(sharpness: [*c]c_int) callconv(.c) c_int;

comptime {
    asm (macro.import_module_start("sceUsbCam", "0x40090000", "54"));
    asm (macro.import_function("sceUsbCam", "0x03ED7A82", "sceUsbCamSetupMic"));
    asm (macro.import_function("sceUsbCam", "0x08AEE98A", "sceUsbCamSetMicGain"));
    asm (macro.import_function("sceUsbCam", "0x09C26C7E", "sceUsbCamSetContrast"));
    asm (macro.import_function("sceUsbCam", "0x0A41A298", "sceUsbCamSetupStillEx"));
    asm (macro.import_function("sceUsbCam", "0x11A1F128", "sceUsbCamGetAutoImageReverseState"));
    asm (macro.import_function("sceUsbCam", "0x17F7B2FB", "sceUsbCamSetupVideo"));
    asm (macro.import_function("sceUsbCam", "0x1A46CFE7", "sceUsbCamStillPollInputEnd"));
    asm (macro.import_function("sceUsbCam", "0x1D686870", "sceUsbCamSetEvLevel"));
    asm (macro.import_function("sceUsbCam", "0x1E958148", "sceUsbCam_1E958148"));
    asm (macro.import_function("sceUsbCam", "0x2BCD50C0", "sceUsbCamGetEvLevel"));
    asm (macro.import_function("sceUsbCam", "0x2E930264", "sceUsbCamSetupMicEx"));
    asm (macro.import_function("sceUsbCam", "0x36636925", "sceUsbCamReadMicBlocking"));
    asm (macro.import_function("sceUsbCam", "0x383E9FA8", "sceUsbCamGetSaturation"));
    asm (macro.import_function("sceUsbCam", "0x3DC0088E", "sceUsbCamReadMic"));
    asm (macro.import_function("sceUsbCam", "0x3F0CF289", "sceUsbCamSetupStill"));
    asm (macro.import_function("sceUsbCam", "0x41E73E95", "sceUsbCamPollReadVideoFrameEnd"));
    asm (macro.import_function("sceUsbCam", "0x41EE8797", "sceUsbCamUnregisterLensRotationCallback"));
    asm (macro.import_function("sceUsbCam", "0x4C34F553", "sceUsbCamGetLensDirection"));
    asm (macro.import_function("sceUsbCam", "0x4F3D84D5", "sceUsbCamSetBrightness"));
    asm (macro.import_function("sceUsbCam", "0x5145868A", "sceUsbCamStopMic"));
    asm (macro.import_function("sceUsbCam", "0x574A8C3F", "sceUsbCamStartVideo"));
    asm (macro.import_function("sceUsbCam", "0x5778B452", "sceUsbCamGetMicDataLength"));
    asm (macro.import_function("sceUsbCam", "0x61BE5CAC", "sceUsbCamStillInputBlocking"));
    asm (macro.import_function("sceUsbCam", "0x622F83CC", "sceUsbCamSetSharpness"));
    asm (macro.import_function("sceUsbCam", "0x6784E6A8", "sceUsbCamSetAntiFlicker"));
    asm (macro.import_function("sceUsbCam", "0x6CF32CB9", "sceUsbCamStopVideo"));
    asm (macro.import_function("sceUsbCam", "0x6E205974", "sceUsbCamSetSaturation"));
    asm (macro.import_function("sceUsbCam", "0x70F522C5", "sceUsbCamGetBrightness"));
    asm (macro.import_function("sceUsbCam", "0x7563AFA1", "sceUsbCamStillWaitInputEnd"));
    asm (macro.import_function("sceUsbCam", "0x7DAC0C71", "sceUsbCamReadVideoFrameBlocking"));
    asm (macro.import_function("sceUsbCam", "0x82A64030", "sceUsbCamStartMic"));
    asm (macro.import_function("sceUsbCam", "0x951BEDF5", "sceUsbCamSetReverseMode"));
    asm (macro.import_function("sceUsbCam", "0x95F8901E", "sceUsbCam_95F8901E"));
    asm (macro.import_function("sceUsbCam", "0x994471E0", "sceUsbCamGetImageEffectMode"));
    asm (macro.import_function("sceUsbCam", "0x99D86281", "sceUsbCamReadVideoFrame"));
    asm (macro.import_function("sceUsbCam", "0x9E8AAF8D", "sceUsbCamGetZoom"));
    asm (macro.import_function("sceUsbCam", "0xA063A957", "sceUsbCamGetContrast"));
    asm (macro.import_function("sceUsbCam", "0xA720937C", "sceUsbCamStillCancelInput"));
    asm (macro.import_function("sceUsbCam", "0xAA7D94BA", "sceUsbCamGetAntiFlicker"));
    asm (macro.import_function("sceUsbCam", "0xB048A67D", "sceUsbCamWaitReadMicEnd"));
    asm (macro.import_function("sceUsbCam", "0xC484901F", "sceUsbCamSetZoom"));
    asm (macro.import_function("sceUsbCam", "0xC72ED6D3", "sceUsbCam_C72ED6D3"));
    asm (macro.import_function("sceUsbCam", "0xCFE9E999", "sceUsbCamSetupVideoEx"));
    asm (macro.import_function("sceUsbCam", "0xD293A100", "sceUsbCamRegisterLensRotationCallback"));
    asm (macro.import_function("sceUsbCam", "0xD4876173", "sceUsbCamSetImageEffectMode"));
    asm (macro.import_function("sceUsbCam", "0xD5279339", "sceUsbCamGetReverseMode"));
    asm (macro.import_function("sceUsbCam", "0xD865997B", "sceUsbCam_D865997B"));
    asm (macro.import_function("sceUsbCam", "0xDF9D0C92", "sceUsbCamGetReadVideoFrameSize"));
    asm (macro.import_function("sceUsbCam", "0xE5959C36", "sceUsbCamStillGetInputLength"));
    asm (macro.import_function("sceUsbCam", "0xF8847F60", "sceUsbCamPollReadMicEnd"));
    asm (macro.import_function("sceUsbCam", "0xF90B2293", "sceUsbCamWaitReadVideoFrameEnd"));
    asm (macro.import_function("sceUsbCam", "0xF93C4669", "sceUsbCamAutoImageReverseSW"));
    asm (macro.import_function("sceUsbCam", "0xFB0A6C5D", "sceUsbCamStillInput"));
    asm (macro.import_function("sceUsbCam", "0xFDB68C23", "sceUsbCamGetSharpness"));
}
