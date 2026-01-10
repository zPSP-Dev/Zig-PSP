const c = @import("../c/modules.zig");

pub const SceUID = c.types.SceUID;
pub const SceMpeg = c.types.SceMpeg;
pub const SceMpegAu = c.types.SceMpegAu;
pub const SceMpegAvcMode = c.types.SceMpegAvcMode;
pub const SceMpegLLI = c.types.SceMpegLLI;
pub const SceMpegRingbuffer = c.types.SceMpegRingbuffer;
pub const sceMpegRingbufferCB = c.types.sceMpegRingbufferCB;
pub const SceMpegStream = c.types.SceMpegStream;
pub const SceMpegYCrCbBuffer = c.types.SceMpegYCrCbBuffer;

// Use c bindings directly for now
