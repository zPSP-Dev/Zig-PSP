// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Inititalise the resolver library
/// Returns 0 on sucess, < 0 on error.
pub extern fn sceNetResolverInit() callconv(.c) c_int;

/// Terminate the resolver library
/// Returns 0 on success, < 0 on error
pub extern fn sceNetResolverTerm() callconv(.c) c_int;

/// Create a resolver object
/// `rid` - Pointer to receive the resolver id
/// `buf` - Temporary buffer
/// `buflen` - Length of the temporary buffer
/// Returns 0 on success, < 0 on error
pub extern fn sceNetResolverCreate(rid: [*c]c_int, buf: ?*anyopaque, buflen: types.SceSize) callconv(.c) c_int;

/// Delete a resolver
/// `rid` - The resolver to delete
/// Returns 0 on success, < 0 on error
pub extern fn sceNetResolverDelete(rid: c_int) callconv(.c) c_int;

/// Begin a name to address lookup
/// `rid` - Resolver id
/// `hostname` - Name to resolve
/// `addr` - Pointer to in_addr structure to receive the address
/// `timeout` - Number of seconds before timeout
/// `retry` - Number of retires
/// Returns 0 on success, < 0 on error
pub extern fn sceNetResolverStartNtoA(rid: c_int, hostname: [*c]const c_char, addr: [*c]types.in_addr, timeout: c_uint, retry: c_int) callconv(.c) c_int;

/// Begin a address to name lookup
/// `rid -Resolver id`
/// `addr` - Pointer to the address to resolve
/// `hostname` - Buffer to receive the name
/// `hostname_len` - Length of the buffer
/// `timeout` - Number of seconds before timeout
/// `retry` - Number of retries
/// Returns 0 on success, < 0 on error
pub extern fn sceNetResolverStartAtoN(rid: c_int, addr: [*c]const types.in_addr, hostname: [*c]c_char, hostname_len: types.SceSize, timeout: c_uint, retry: c_int) callconv(.c) c_int;

/// Stop a resolver operation
/// `rid` - Resolver id
/// Returns 0 on success, < 0 on error
pub extern fn sceNetResolverStop(rid: c_int) callconv(.c) c_int;

comptime {
    asm (macro.import_module_start("sceNetResolver", "0x00090000", "7"));
    asm (macro.import_function("sceNetResolver", "0xF3370E61", "sceNetResolverInit"));
    asm (macro.import_function("sceNetResolver", "0x6138194A", "sceNetResolverTerm"));
    asm (macro.import_function("sceNetResolver", "0x244172AF", "sceNetResolverCreate"));
    asm (macro.import_function("sceNetResolver", "0x94523E09", "sceNetResolverDelete"));
    asm (macro.import_function("sceNetResolver", "0x224C5F44", "sceNetResolverStartNtoA_stub"));
    asm (macro.generic_abi_wrapper("sceNetResolverStartNtoA", 5));
    asm (macro.import_function("sceNetResolver", "0x629E2FB7", "sceNetResolverStartAtoN_stub"));
    asm (macro.generic_abi_wrapper("sceNetResolverStartAtoN", 6));
    asm (macro.import_function("sceNetResolver", "0x808F6063", "sceNetResolverStop"));
}
