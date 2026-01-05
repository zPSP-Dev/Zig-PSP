// Copy data in memory using DMAC
//
// @param dst - The pointer to the destination
// @param src - The pointer to the source
// @param n - The size of data
//
// @return 0 on success; otherwise an error code
pub extern fn sceDmacMemcpy(dst: *anyopaque, src: *const anyopaque, n: usize) c_int;

pub extern fn sceDmacTryMemcpy(dst: *anyopaque, src: *const anyopaque, n: usize) c_int;
