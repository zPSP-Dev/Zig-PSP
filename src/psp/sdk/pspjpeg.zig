usingnamespace @import("psptypes.zig");

// Inits the MJpeg library
//
// @return 0 on success, < 0 on error
pub extern fn sceJpegInitMJpeg() c_int;
pub fn jpegInitMJpeg() bool {
    return sceJpegInitMJpeg() == 0;
}

// Finishes the MJpeg library
//
// @return 0 on success, < 0 on error
pub extern fn sceJpegFinishMJpeg() c_int;
pub fn jpegFinishMJpeg() bool {
    return sceJpegFinishMJpeg() == 0;
}

// Creates the decoder context.
//
// @param width - The width of the frame
// @param height - The height of the frame
//
// @return 0 on success, < 0 on error
pub extern fn sceJpegCreateMJpeg(width: c_int, height: c_int) c_int;
pub fn jpegCreateMJpeg(width: c_int, height: c_int) bool {
    return sceJpegCreateMJpeg(width, height) == 0;
}

// Deletes the current decoder context.
//
// @return 0 on success, < 0 on error
pub extern fn sceJpegDeleteMJpeg() c_int;
pub fn jpegDeleteMJpeg() bool {
    return sceJpegDeleteMJpeg == 0;
}
// Decodes a mjpeg frame.
//
// @param jpegbuf - the buffer with the mjpeg frame
// @param size - size of the buffer pointed by jpegbuf
// @param rgba - buffer where the decoded data in RGBA format will be stored.
//				       It should have a size of (width * height * 4).
// @param unk - Unknown, pass 0
//
// @return (width * 65536) + height on success, < 0 on error
pub extern fn sceJpegDecodeMJpeg(jpegbuf: []u8, size: SceSize, rgba: ?*c_void, unk: u32) c_int;
