usingnamespace @import("psptypes.zig");

pub extern fn sceNandSetWriteProtect(protectFlag: c_int) c_int;
pub extern fn sceNandLock(writeFlag: c_int) c_int;
pub extern fn sceNandUnlock() void;
pub extern fn sceNandReadStatus() c_int;
pub extern fn sceNandReset(flag: c_int) c_int;
pub extern fn sceNandReadId(buf: ?*c_void, size: SceSize) c_int;
pub extern fn sceNandReadPages(ppn: u32_3, buf: ?*c_void, buf2: ?*c_void, count: u32_3) c_int;
pub extern fn sceNandGetPageSize() c_int;
pub extern fn sceNandGetPagesPerBlock() c_int;
pub extern fn sceNandGetTotalBlocks() c_int;
pub extern fn sceNandReadBlockWithRetry(ppn: u32_3, buf: ?*c_void, buf2: ?*c_void) c_int;
pub extern fn sceNandIsBadBlock(ppn: u32_3) c_int;
