// MJPEG decoding
//
// Wraps:
//   c/module/sceJpeg.zig

const c = @import("../c/modules.zig");
const err = @import("errors/jpeg.zig");
const internal = @import("internal.zig");
const check = err.check;
const ci = internal.ci;
const cu = internal.cu;
const Error = err.Error;

const jpeg = c.sceJpeg;

// -- Lifecycle ----------------------------------------------------------

pub fn init_mjpeg() Error!void {
    return check(jpeg.sceJpegInitMJpeg());
}

pub fn finish_mjpeg() Error!void {
    return check(jpeg.sceJpegFinishMJpeg());
}

pub fn create_mjpeg(width: u32, height: u32) Error!void {
    return check(jpeg.sceJpegCreateMJpeg(ci(width), ci(height)));
}

pub fn delete_mjpeg() Error!void {
    return check(jpeg.sceJpegDeleteMJpeg());
}

// -- Decoding -----------------------------------------------------------

pub const FrameSize = struct { width: u32, height: u32 };

fn unpack_frame_size(ret: c_int) Error!FrameSize {
    if (ret < 0) {
        @branchHint(.unlikely);
        return err.translate(@bitCast(ret));
    }
    const val: u32 = @intCast(ret);
    return .{ .width = val >> 16, .height = val & 0xFFFF };
}

/// Decode MJPEG frame to RGBA.
pub fn decode_mjpeg(jpegbuf: []u8, rgba: [*]u8) Error!FrameSize {
    return unpack_frame_size(jpeg.sceJpegDecodeMJpeg(jpegbuf.ptr, jpegbuf.len, rgba, 0));
}

/// Decode MJPEG frame to YCbCr.
pub fn decode_mjpeg_ycbcr(jpegbuf: []u8, ycbcr: []u8) Error!FrameSize {
    return unpack_frame_size(jpeg.sceJpegDecodeMJpegYCbCr(jpegbuf.ptr, jpegbuf.len, ycbcr.ptr, ycbcr.len, 0));
}

/// Get output info for a MJPEG frame. Returns the required YCbCr buffer size.
pub fn get_output_info(jpegbuf: []u8, colour_info: *i32) Error!u32 {
    const ret = jpeg.sceJpegGetOutputInfo(jpegbuf.ptr, jpegbuf.len, @ptrCast(colour_info), 0);
    if (ret <= 0) return error.Unexpected;
    return cu(ret);
}

/// Convert YCbCr to RGBA.
pub fn csc(image_addr: [*]u8, ycbcr_addr: [*]u8, width_height: u32, buffer_width: u32, colour_info: i32) Error!void {
    return check(jpeg.sceJpegCsc(image_addr, ycbcr_addr, ci(width_height), ci(buffer_width), @as(c_int, colour_info)));
}
