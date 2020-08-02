pub extern fn sceSslInit(unknown1: c_int) c_int;
pub extern fn sceSslEnd() c_int;
pub extern fn sceSslGetUsedMemoryMax(memory: [*c]c_uint) c_int;
pub extern fn sceSslGetUsedMemoryCurrent(memory: [*c]c_uint) c_int;
