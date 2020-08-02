pub extern fn sceIdStorageLookup(key: u16_2, offset: u32_3, buf: ?*c_void, len: u32_3) c_int;
pub extern fn sceIdStorageReadLeaf(key: u16_2, buf: ?*c_void) c_int;
pub extern fn sceIdStorageWriteLeaf(key: u16_2, buf: ?*c_void) c_int;
pub extern fn sceIdStorageIsReadOnly() c_int;
pub extern fn sceIdStorageFlush() c_int;