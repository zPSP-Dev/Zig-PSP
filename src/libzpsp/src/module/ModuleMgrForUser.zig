// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Load a module from the given file UID.
/// `fid` - The module's file UID.
/// `flags` - Unused, always 0.
/// `option` - Pointer to an optional ::SceKernelLMOption structure.
/// Returns The UID of the loaded module on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelLoadModuleByID(fid: types.SceUID, flags: c_int, option: [*c]types.SceKernelLMOption) callconv(.c) types.SceUID;

/// Load a module.
/// @note This function restricts where it can load from (such as from flash0)
/// unless you call it in kernel mode. It also must be called from a thread.
/// `path` - The path to the module to load.
/// `flags` - Unused, always 0 .
/// `option` - Pointer to a mod_param_t structure. Can be NULL.
/// Returns The UID of the loaded module on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelLoadModule(path: [*c]const c_char, flags: c_int, option: [*c]types.SceKernelLMOption) callconv(.c) types.SceUID;

/// Load a module from MS.
/// @note This function restricts what it can load, e.g. it wont load plain executables.
/// `path` - The path to the module to load.
/// `flags` - Unused, set to 0.
/// `option` - Pointer to a mod_param_t structure. Can be NULL.
/// Returns The UID of the loaded module on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelLoadModuleMs(path: [*c]const c_char, flags: c_int, option: [*c]types.SceKernelLMOption) callconv(.c) types.SceUID;

/// Load a module from a buffer using the USB/WLAN API.
/// Can only be called from kernel mode, or from a thread that has attributes of 0xa0000000.
/// `bufsize` - Size (in bytes) of the buffer pointed to by buf.
/// `buf` - Pointer to a buffer containing the module to load.  The buffer must reside at an
/// address that is a multiple to 64 bytes.
/// `flags` - Unused, always 0.
/// `option` - Pointer to an optional ::SceKernelLMOption structure.
/// Returns The UID of the loaded module on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelLoadModuleBufferUsbWlan(bufsize: types.SceSize, buf: ?*anyopaque, flags: c_int, option: [*c]types.SceKernelLMOption) callconv(.c) types.SceUID;

/// Start a loaded module.
/// `modid` - The ID of the module returned from LoadModule.
/// `argsize` - Length of the args.
/// `argp` - A pointer to the arguments to the module.
/// `status` - Returns the status of the start.
/// `option` - Pointer to an optional ::SceKernelSMOption structure.
/// Returns modID (modID > 0) UID of the module that was started and made resident,
/// 0 on success for modules that don't need to be made resident,
/// otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelStartModule(modid: types.SceUID, argsize: types.SceSize, argp: ?*anyopaque, status: [*c]c_int, option: [*c]types.SceKernelSMOption) callconv(.c) c_int;

/// Stop a running module.
/// `modid` - The UID of the module to stop.
/// `argsize` - The length of the arguments pointed to by argp.
/// `argp` - Pointer to arguments to pass to the module's module_stop() routine.
/// `status` - Return value of the module's module_stop() routine.
/// `option` - Pointer to an optional ::SceKernelSMOption structure.
/// Returns ??? on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelStopModule(modid: types.SceUID, argsize: types.SceSize, argp: ?*anyopaque, status: [*c]c_int, option: [*c]types.SceKernelSMOption) callconv(.c) c_int;

/// Unload a stopped module.
/// `modid` - The UID of the module to unload.
/// Returns ??? on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelUnloadModule(modid: types.SceUID) callconv(.c) c_int;

/// Stop and unload the current module.
/// `unknown` - Unknown (I've seen 1 passed).
/// `argsize` - Size (in bytes) of the arguments that will be passed to module_stop().
/// `argp` - Pointer to arguments that will be passed to module_stop().
/// Returns ??? on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelSelfStopUnloadModule(unknown: c_int, argsize: types.SceSize, argp: ?*anyopaque) callconv(.c) c_int;

/// Stop and unload the current module.
/// `argsize` - Size (in bytes) of the arguments that will be passed to module_stop().
/// `argp` - Poitner to arguments that will be passed to module_stop().
/// `status` - Return value from module_stop().
/// `option` - Pointer to an optional ::SceKernelSMOption structure.
/// Returns ??? on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelStopUnloadSelfModule(argsize: types.SceSize, argp: ?*anyopaque, status: [*c]c_int, option: [*c]types.SceKernelSMOption) callconv(.c) c_int;

/// Query the information about a loaded module from its UID.
/// @note This fails on v1.0 firmware (and even it worked has a limited structure)
/// so if you want to be compatible with both 1.5 and 1.0 (and you are running in
/// kernel mode) then call this function first then ::pspSdkQueryModuleInfoV1
/// if it fails, or make separate v1 and v1.5+ builds.
/// `modid` - The UID of the loaded module.
/// `info` - Pointer to a ::SceKernelModuleInfo structure.
/// Returns 0 on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelQueryModuleInfo(modid: types.SceUID, info: [*c]types.SceKernelModuleInfo) callconv(.c) c_int;

/// Get a list of module IDs. NOTE: This is only available on 1.5 firmware
/// and above. For V1 use ::pspSdkGetModuleIdList.
/// `readbuf` - Buffer to store the module list.
/// `readbufsize` - Number of elements in the readbuffer.
/// `idcount` - Returns the number of module ids
/// Returns >= 0 on success
pub extern fn sceKernelGetModuleIdList(readbuf: [*c]types.SceUID, readbufsize: c_int, idcount: [*c]c_int) callconv(.c) c_int;

/// Get the ID of the module occupying the address
/// `moduleAddr` - A pointer to the module
/// Returns >= 0 on success, otherwise one of ::PspKernelErrorCodes
pub extern fn sceKernelGetModuleIdByAddress(moduleAddr: ?*const anyopaque) callconv(.c) c_int;

comptime {
    asm (macro.import_module_start("ModuleMgrForUser", "0x40010000", "12"));
    asm (macro.import_function("ModuleMgrForUser", "0xB7F46618", "sceKernelLoadModuleByID"));
    asm (macro.import_function("ModuleMgrForUser", "0x977DE386", "sceKernelLoadModule"));
    asm (macro.import_function("ModuleMgrForUser", "0x710F61B5", "sceKernelLoadModuleMs"));
    asm (macro.import_function("ModuleMgrForUser", "0xF9275D98", "sceKernelLoadModuleBufferUsbWlan"));
    asm (macro.import_function("ModuleMgrForUser", "0x50F0C1EC", "sceKernelStartModule_stub"));
    asm (macro.generic_abi_wrapper("sceKernelStartModule", 5));
    asm (macro.import_function("ModuleMgrForUser", "0xD1FF982A", "sceKernelStopModule_stub"));
    asm (macro.generic_abi_wrapper("sceKernelStopModule", 5));
    asm (macro.import_function("ModuleMgrForUser", "0x2E0911AA", "sceKernelUnloadModule"));
    asm (macro.import_function("ModuleMgrForUser", "0xD675EBB8", "sceKernelSelfStopUnloadModule"));
    asm (macro.import_function("ModuleMgrForUser", "0xCC1D3699", "sceKernelStopUnloadSelfModule"));
    asm (macro.import_function("ModuleMgrForUser", "0x748CBED9", "sceKernelQueryModuleInfo"));
    asm (macro.import_function("ModuleMgrForUser", "0x644395E2", "sceKernelGetModuleIdList"));
    asm (macro.import_function("ModuleMgrForUser", "0xD8B73127", "sceKernelGetModuleIdByAddress"));
}
