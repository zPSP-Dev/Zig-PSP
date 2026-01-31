// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Copy data in memory using DMAC
/// `dst` - The pointer to the destination
/// `src` - The pointer to the source
/// `n` - The size of data
/// Returns 0 on success; otherwise an error code
pub extern fn sceDmacMemcpy(dst: ?*anyopaque, src: ?*const anyopaque, n: usize) callconv(.c) c_int;

pub extern fn sceDmacTryMemcpy(dst: ?*anyopaque, src: ?*const anyopaque, n: usize) callconv(.c) c_int;

comptime {
    asm (macro.import_module_start("sceDmac", "0x40010011", "2"));
    asm (macro.import_function("sceDmac", "0x617F3FE6", "sceDmacMemcpy"));
    asm (macro.import_function("sceDmac", "0xD97F94D8", "sceDmacTryMemcpy"));
}
