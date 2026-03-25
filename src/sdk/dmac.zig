// DMA controller -- hardware-accelerated memory copy
//
// Wraps:
//   c/module/sceDmac.zig

const c = @import("../c/modules.zig");
const internal = @import("internal.zig");
const check = internal.check;
const Error = internal.Error;

const dmac = c.sceDmac;

/// Copy memory using the DMA controller. Blocks until complete.
pub fn memcpy(dst: ?*anyopaque, src: ?*const anyopaque, n: usize) Error!void {
    return check(dmac.sceDmacMemcpy(dst, src, n));
}

/// Try to copy memory using the DMA controller. Non-blocking variant.
pub fn try_memcpy(dst: ?*anyopaque, src: ?*const anyopaque, n: usize) Error!void {
    return check(dmac.sceDmacTryMemcpy(dst, src, n));
}
