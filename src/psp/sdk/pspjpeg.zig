usingnamespace @import("psptypes.zig");

pub extern fn sceJpegInitMJpeg() c_int;
pub extern fn sceJpegFinishMJpeg() c_int;
pub extern fn sceJpegCreateMJpeg(width: c_int, height: c_int) c_int;
pub extern fn sceJpegDeleteMJpeg() c_int;
pub extern fn sceJpegDecodeMJpeg(jpegbuf: [*c]u8, size: SceSize, rgba: ?*c_void, unk: u32) c_int;
