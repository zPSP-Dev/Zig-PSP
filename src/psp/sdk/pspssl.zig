// Init the ssl library.
//
// @param unknown1 - Memory size? Pass 0x28000
//
// @return 0 on success
pub extern fn sceSslInit(unknown1: c_int) c_int;

pub fn sslInit() bool {
    return sceSslInit(0x28000) == 0;
}

// Terminate the ssl library.
//
// @return 0 on success
pub extern fn sceSslEnd() c_int;

pub fn sslEnd() bool {
    return sceSslEnd() == 0;
}

// Get the maximum memory size used by ssl.
//
// @param memory - Pointer where the maximum memory used value will be stored.
//
// @return 0 on success
pub extern fn sceSslGetUsedMemoryMax(memory: *c_uint) c_int;
pub fn sslGetUsedMemoryMax(memory: *c_uint) bool {
    return sceSslGetUsedMemoryMax(memory) == 0;
}

// Get the current memory size used by ssl.
//
// @param memory - Pointer where the current memory used value will be stored.
//
// @return 0 on success
pub extern fn sceSslGetUsedMemoryCurrent(memory: *c_uint) c_int;
pub fn sslGetUsedMemoryCurrent(memory: *c_uint) bool {
    return sceSslGetUsedMemoryCurrent(memory) == 0;
}
