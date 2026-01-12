// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

pub extern fn sceJpeg_0425B986() callconv(.c) void;

pub extern fn sceJpegMJpegCsc() callconv(.c) void;

/// Decodes a mjpeg frame to RGBA encoding.
/// @note Input frame should be encoded as either yuv420p or yuvj420p,
/// returns SCE_JPEG_ERROR_UNSUPPORT_SAMPLING otherwise
/// `jpegbuf` - the buffer with the mjpeg frame
/// `size` - size of the buffer pointed by jpegbuf
/// `rgba` - buffer where the decoded data in RGBA format will be stored.
/// It should have a size of (width * height * 4).
/// `unk` - Unknown, pass 0
/// Returns (width * 65536) + height on success, < 0 on error
pub extern fn sceJpegDecodeMJpeg(jpegbuf: [*c]u8, size: usize, rgba: [*c]u8, unk: u32) callconv(.c) c_int;

pub extern fn sceJpeg_227662D7() callconv(.c) void;

/// Deletes the current decoder context.
/// Returns 0 on success, < 0 on error
pub extern fn sceJpegDeleteMJpeg() callconv(.c) c_int;

pub extern fn sceJpeg_64B6F978() callconv(.c) void;

/// Converts a frame from YCbCr to RGBA
/// `imageAddr` - buffer where the converted data in RGBA format will be stored.
/// `yCbCrAddr` - the buffer with the YCbCr data
/// `widthHeight` - width and height of the frame (width * 65536) + height,
/// as returned by sceJpegDecodeMJpegYCbCr() or sceJpegDecodeMJpeg()
/// `bufferWidth` - number of pixels per row of the buffer
/// `colourInfo` - chroma subsampling mode, as provided by sceJpegGetOutputInfo()
/// Returns 0 on success, < 0 on error
pub extern fn sceJpegCsc(imageAddr: [*c]u8, yCbCrAddr: [*c]u8, widthHeight: c_int, bufferWidth: c_int, colourInfo: c_int) callconv(.c) c_int;

/// Finishes the MJpeg library
/// Returns 0 on success, < 0 on error
pub extern fn sceJpegFinishMJpeg() callconv(.c) c_int;

/// Reads information from mjpeg frame
/// `jpegbuf` - the buffer with the mjpeg frame
/// `size` - size of the mjpeg frame
/// `colourInfo` - address where the mjpeg chroma information will be stored
/// `unk` - Unknown, pass 0
/// Returns number of bytes needed in the buffer that will be used for YCbCr decoding, <= 0 on error
pub extern fn sceJpegGetOutputInfo(jpegbuf: [*c]u8, size: usize, colourInfo: [*c]c_int, unk: c_int) callconv(.c) c_int;

/// Decodes a mjpeg frame to YCbCr encoding
/// @note Input frame should be encoded as either yuv420p or yuvj420p,
/// returns SCE_JPEG_ERROR_UNSUPPORT_SAMPLING otherwise
/// `jpegbuf` - the buffer with the mjpeg frame
/// `size` - size of the buffer pointed by jpegbuf
/// `yCbCr` - buffer where the decoded data in YCbCr format will be stored
/// `yCbCrSize` - size of the buffer pointed by yCbCr (see sceJpegGetOutputInfo())
/// `unk` - Unknown, pass 0
/// Returns (width * 65536) + height on success, < 0 on error
pub extern fn sceJpegDecodeMJpegYCbCr(jpegbuf: [*c]u8, size: usize, yCbCr: [*c]u8, yCbCrSize: usize, unk: u32) callconv(.c) c_int;

pub extern fn sceJpeg_9B36444C() callconv(.c) void;

/// Creates the decoder context.
/// `width` - The width of the frame
/// `height` - The height of the frame
/// Returns 0 on success, < 0 on error
pub extern fn sceJpegCreateMJpeg(width: c_int, height: c_int) callconv(.c) c_int;

/// Inits the MJpeg library
/// Returns 0 on success, < 0 on error
pub extern fn sceJpegInitMJpeg() callconv(.c) c_int;

comptime {
    asm (macro.import_module_start("sceJpeg", "0x00090000", "13"));
    asm (macro.import_function("sceJpeg", "0x0425B986", "sceJpeg_0425B986"));
    asm (macro.import_function("sceJpeg", "0x04B5AE02", "sceJpegMJpegCsc"));
    asm (macro.import_function("sceJpeg", "0x04B93CEF", "sceJpegDecodeMJpeg"));
    asm (macro.import_function("sceJpeg", "0x227662D7", "sceJpeg_227662D7"));
    asm (macro.import_function("sceJpeg", "0x48B602B7", "sceJpegDeleteMJpeg"));
    asm (macro.import_function("sceJpeg", "0x64B6F978", "sceJpeg_64B6F978"));
    asm (macro.import_function("sceJpeg", "0x67F0ED84", "sceJpegCsc_stub"));
    asm (macro.generic_abi_wrapper("sceJpegCsc", 5));
    asm (macro.import_function("sceJpeg", "0x7D2F3D7F", "sceJpegFinishMJpeg"));
    asm (macro.import_function("sceJpeg", "0x8F2BB012", "sceJpegGetOutputInfo"));
    asm (macro.import_function("sceJpeg", "0x91EED83C", "sceJpegDecodeMJpegYCbCr_stub"));
    asm (macro.generic_abi_wrapper("sceJpegDecodeMJpegYCbCr", 5));
    asm (macro.import_function("sceJpeg", "0x9B36444C", "sceJpeg_9B36444C"));
    asm (macro.import_function("sceJpeg", "0x9D47469C", "sceJpegCreateMJpeg"));
    asm (macro.import_function("sceJpeg", "0xAC9E70E6", "sceJpegInitMJpeg"));
}
