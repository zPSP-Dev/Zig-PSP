usingnamespace @import("psptypes.zig");

pub const struct_SceAsfFrame = extern struct {
    pData: ScePVoid,
    iFrameMs: SceUInt32,
    iUnk1: SceUInt32,
    iUnk2: SceUInt32,
    iUnk3: SceUInt32,
    iUnk4: SceUInt32,
    iUnk5: SceUInt32,
    iUnk6: SceUInt32,
    u8Unknown: [32]SceUChar8,
};
pub const SceAsfFrame = struct_SceAsfFrame;
pub const struct__SceAsfParser = extern struct {
    iUnk0: SceUInt32,
    iUnk1: SceUInt32,
    iUnk2: SceUInt32,
    iUnk3: SceUInt32,
    iUnk4: SceUInt32,
    iUnk5: SceUInt32,
    iUnk6: SceUInt32,
    iUnk7: SceUInt32,
    iNeedMem: SceUInt32,
    pNeedMemBuffer: ScePVoid,
    iUnk10_20: [10]SceUInt32,
    iDuration: SceUInt64,
    iUnk22_3626: [3604]SceUInt32,
    sFrame: SceAsfFrame,
    iUnk3345_3643: [298]SceUInt32,
    iUnk3644: SceUInt32,
    iUnk3644_4095: [451]SceUInt32,
};
pub const SceAsfParser = struct__SceAsfParser;
pub const SceAsfParserReadCB = ?fn (?*c_void, ?*c_void, SceSize) callconv(.C) SceInt64;
pub const SceAsfParserSeekCB = ?fn (?*c_void, ?*c_void, SceOff, c_int) callconv(.C) SceInt64;
pub extern fn sceAsfCheckNeedMem(parser: [*c]SceAsfParser) c_int;
pub extern fn sceAsfInitParser(parser: [*c]SceAsfParser, user_data: ScePVoid, read_cb: SceAsfParserReadCB, seek_cb: SceAsfParserSeekCB) c_int;
pub extern fn sceAsfGetFrameData(parser: [*c]SceAsfParser, unknown: c_int, frame: [*c]SceAsfFrame) c_int;
pub extern fn sceAsfSeekTime(parser: [*c]SceAsfParser, unknown: c_int, ms: [*c]SceUInt32) c_int;
pub extern fn sceAsfParser_685E0DA7(asf: [*c]SceAsfParser, ptr: ?*c_void, flag: c_int, arg4: ?*c_void, start: [*c]SceUInt64, size: [*c]SceUInt64) c_int;
pub extern fn sceAsfParser_C6D98C54(asf: [*c]SceAsfParser, unk: ?*c_void, start: [*c]SceUInt64, size: [*c]SceUInt64) c_int;
