// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

pub extern fn sceRegExit() callconv(.c) void;

/// Open the registry
/// `reg` - A filled in ::RegParam structure
/// `mode` - Open mode (set to 1)
/// `h` - Pointer to a REGHANDLE to receive the registry handle
/// Returns 0 on success, < 0 on error
pub extern fn sceRegOpenRegistry(reg: [*c]c_int, mode: c_int, h: [*c]c_int) callconv(.c) c_int;

/// Close the registry
/// `h` - The open registry handle
/// Returns 0 on success, < 0 on error
pub extern fn sceRegCloseRegistry(h: c_int) callconv(.c) c_int;

/// Remove a registry (HONESTLY, DO NOT USE)
/// `reg` - Filled out registry parameter
/// Returns 0 on success, < 0 on error
pub extern fn sceRegRemoveRegistry(reg: [*c]c_int) callconv(.c) c_int;

/// Open a registry directory
/// `h` - The open registry handle
/// `name` - The path to the dir to open (e.g. /CONFIG/SYSTEM)
/// `mode` - Open mode (can be 1 or 2, probably read or read/write
/// `hd` - Pointer to a REGHANDLE to receive the registry dir handle
/// Returns 0 on success, < 0 on error
pub extern fn sceRegOpenCategory(h: c_int, name: [*c]const c_char, mode: c_int, hd: [*c]c_int) callconv(.c) c_int;

/// Close the registry directory
/// `hd` - The open registry dir handle
/// Returns 0 on success, < 0 on error
pub extern fn sceRegCloseCategory(hd: c_int) callconv(.c) c_int;

/// Flush the registry to disk
/// `h` - The open registry handle
/// Returns 0 on success, < 0 on error
pub extern fn sceRegFlushRegistry(h: c_int) callconv(.c) c_int;

/// Flush the registry directory to disk
/// `hd` - The open registry dir handle
/// Returns 0 on success, < 0 on error
pub extern fn sceRegFlushCategory(hd: c_int) callconv(.c) c_int;

/// Create a key
/// `hd` - The open registry dir handle
/// `name` - Name of the key to create
/// `type` - Type of key (note cannot be a directory type)
/// `size` - Size of the allocated value space
/// Returns 0 on success, < 0 on error
pub extern fn sceRegCreateKey(hd: c_int, name: [*c]const c_char, type: c_int, size: types.SceSize) callconv(.c) c_int;

/// Set a key's value
/// `hd` - The open registry dir handle
/// `name` - The key name
/// `buf` - Buffer to hold the value
/// `size` - The size of the buffer
/// Returns 0 on success, < 0 on error
pub extern fn sceRegSetKeyValue(hd: c_int, name: [*c]const c_char, buf: ?*const anyopaque, size: types.SceSize) callconv(.c) c_int;

/// Get a key's information
/// `hd` - The open registry dir handle
/// `name` - Name of the key
/// `hk` - Pointer to a REGHANDLE to get registry key handle
/// `type` - Type of the key, on of ::RegKeyTypes
/// `size` - The size of the key's value in bytes
/// Returns 0 on success, < 0 on error
pub extern fn sceRegGetKeyInfo(hd: c_int, name: [*c]const c_char, hk: [*c]c_int, type: [*c]c_uint, size: [*c]types.SceSize) callconv(.c) c_int;

/// Get a key's value
/// `hd` - The open registry dir handle
/// `hk` - The open registry key handler (from ::sceRegGetKeyInfo)
/// `buf` - Buffer to hold the value
/// `size` - The size of the buffer
/// Returns 0 on success, < 0 on error
pub extern fn sceRegGetKeyValue(hd: c_int, hk: c_int, buf: ?*anyopaque, size: types.SceSize) callconv(.c) c_int;

/// Get number of subkeys in the current dir
/// `hd` - The open registry dir handle
/// `num` - Pointer to an integer to receive the number
/// Returns 0 on success, < 0 on error
pub extern fn sceRegGetKeysNum(hd: c_int, num: [*c]c_int) callconv(.c) c_int;

/// Get the key names in the current directory
/// `hd` - The open registry dir handle
/// `buf` - Buffer to hold the NUL terminated strings, should be num*REG_KEYNAME_SIZE
/// `num` - Number of elements in buf
/// Returns 0 on success, < 0 on error
/// Get number of subkeys in the current dir
/// `hd` - The open registry dir handle
/// `num` - Pointer to an integer to receive the number
/// Returns 0 on success, < 0 on error
pub extern fn sceRegGetKeys(hd: c_int, buf: [*c]c_char, num: c_int) callconv(.c) c_int;

/// Remove a registry dir
/// `h` - The open registry dir handle
/// `name` - The name of the key
/// Returns 0 on success, < 0 on error
pub extern fn sceRegRemoveCategory(h: c_int, name: [*c]const c_char) callconv(.c) c_int;

pub extern fn sceRegRemoveKey() callconv(.c) void;

/// Get a key's information by name
/// `hd` - The open registry dir handle
/// `name` - Name of the key
/// `type` - Type of the key, on of ::RegKeyTypes
/// `size` - The size of the key's value in bytes
/// Returns 0 on success, < 0 on error
pub extern fn sceRegGetKeyInfoByName(hd: c_int, name: [*c]const c_char, type: [*c]c_uint, size: [*c]types.SceSize) callconv(.c) c_int;

/// Get a key's value by name
/// `hd` - The open registry dir handle
/// `name` - The key name
/// `buf` - Buffer to hold the value
/// `size` - The size of the buffer
/// Returns 0 on success, < 0 on error
pub extern fn sceRegGetKeyValueByName(hd: c_int, name: [*c]const c_char, buf: ?*anyopaque, size: types.SceSize) callconv(.c) c_int;

comptime {
    asm (macro.import_module_start("sceReg", "0x40010000", "18"));
    asm (macro.import_function("sceReg", "0x9B25EDF1", "sceRegExit"));
    asm (macro.import_function("sceReg", "0x92E41280", "sceRegOpenRegistry"));
    asm (macro.import_function("sceReg", "0xFA8A5739", "sceRegCloseRegistry"));
    asm (macro.import_function("sceReg", "0xDEDA92BF", "sceRegRemoveRegistry"));
    asm (macro.import_function("sceReg", "0x1D8A762E", "sceRegOpenCategory"));
    asm (macro.import_function("sceReg", "0x0CAE832B", "sceRegCloseCategory"));
    asm (macro.import_function("sceReg", "0x39461B4D", "sceRegFlushRegistry"));
    asm (macro.import_function("sceReg", "0x0D69BF40", "sceRegFlushCategory"));
    asm (macro.import_function("sceReg", "0x57641A81", "sceRegCreateKey"));
    asm (macro.import_function("sceReg", "0x17768E14", "sceRegSetKeyValue"));
    asm (macro.import_function("sceReg", "0xD4475AA8", "sceRegGetKeyInfo_stub"));
    asm (macro.generic_abi_wrapper("sceRegGetKeyInfo", 5));
    asm (macro.import_function("sceReg", "0x28A8E98A", "sceRegGetKeyValue"));
    asm (macro.import_function("sceReg", "0x2C0DB9DD", "sceRegGetKeysNum"));
    asm (macro.import_function("sceReg", "0x2D211135", "sceRegGetKeys"));
    asm (macro.import_function("sceReg", "0x4CA16893", "sceRegRemoveCategory"));
    asm (macro.import_function("sceReg", "0x3615BC87", "sceRegRemoveKey"));
    asm (macro.import_function("sceReg", "0xC5768D02", "sceRegGetKeyInfoByName"));
    asm (macro.import_function("sceReg", "0x30BE0259", "sceRegGetKeyValueByName"));
}
