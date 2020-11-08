usingnamespace @import("psptypes.zig");

pub const SceKernelLMOption = extern struct {
    size: SceSize,
    mpidtext: SceUID,
    mpiddata: SceUID,
    flags: c_uint,
    position: u8,
    access: u8,
    creserved: [2]u8,
};

pub const SceKernelSMOption = extern struct {
    size: SceSize,
    mpidstack: SceUID,
    stacksize: SceSize,
    priority: c_int,
    attribute: c_uint,
};

pub const SceKernelModuleInfo = extern struct {
    size: SceSize,
    nsegment: u8,
    reserved: [3]u8,
    segmentaddr: [4]c_int,
    segmentsize: [4]c_int,
    entry_addr: c_uint,
    gp_value: c_uint,
    text_addr: c_uint,
    text_size: c_uint,
    data_size: c_uint,
    bss_size: c_uint,
    attribute: c_ushort,
    version: [2]u8,
    name: [28]u8,
};

pub const PSP_MEMORY_PARTITION_KERNEL = 1;
pub const PSP_MEMORY_PARTITION_USER = 2;

// Load a module.
// @note This function restricts where it can load from (such as from flash0)
// unless you call it in kernel mode. It also must be called from a thread.
//
// @param path - The path to the module to load.
// @param flags - Unused, always 0 .
// @param option  - Pointer to a mod_param_t structure. Can be NULL.
//
// @return The UID of the loaded module on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelLoadModule(path: []const u8, flags: c_int, option: *SceKernelLMOption) SceUID;

// Load a module from MS.
// @note This function restricts what it can load, e.g. it wont load plain executables.
//
// @param path - The path to the module to load.
// @param flags - Unused, set to 0.
// @param option  - Pointer to a mod_param_t structure. Can be NULL.
//
// @return The UID of the loaded module on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelLoadModuleMs(path: []const u8, flags: c_int, option: *SceKernelLMOption) SceUID;

// Load a module from the given file UID.
//
// @param fid - The module's file UID.
// @param flags - Unused, always 0.
// @param option - Pointer to an optional ::SceKernelLMOption structure.
//
// @return The UID of the loaded module on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelLoadModuleByID(fid: SceUID, flags: c_int, option: *SceKernelLMOption) SceUID;

// Load a module from a buffer using the USB/WLAN API.
//
// Can only be called from kernel mode, or from a thread that has attributes of 0xa0000000.
//
// @param bufsize - Size (in bytes) of the buffer pointed to by buf.
// @param buf - Pointer to a buffer containing the module to load.  The buffer must reside at an
//              address that is a multiple to 64 bytes.
// @param flags - Unused, always 0.
// @param option - Pointer to an optional ::SceKernelLMOption structure.
//
// @return The UID of the loaded module on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelLoadModuleBufferUsbWlan(bufsize: SceSize, buf: ?*c_void, flags: c_int, option: *SceKernelLMOption) SceUID;

// Start a loaded module.
//
// @param modid - The ID of the module returned from LoadModule.
// @param argsize - Length of the args.
// @param argp - A pointer to the arguments to the module.
// @param status - Returns the status of the start.
// @param option - Pointer to an optional ::SceKernelSMOption structure.
//
// @return ??? on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelStartModule(modid: SceUID, argsize: SceSize, argp: ?*c_void, status: *c_int, option: *SceKernelSMOption) c_int;

// Stop a running module.
//
// @param modid - The UID of the module to stop.
// @param argsize - The length of the arguments pointed to by argp.
// @param argp - Pointer to arguments to pass to the module's module_stop() routine.
// @param status - Return value of the module's module_stop() routine.
// @param option - Pointer to an optional ::SceKernelSMOption structure.
//
// @return ??? on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelStopModule(modid: SceUID, argsize: SceSize, argp: ?*c_void, status: *c_int, option: *SceKernelSMOption) c_int;

// Unload a stopped module.
//
// @param modid - The UID of the module to unload.
//
// @return ??? on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelUnloadModule(modid: SceUID) c_int;

// Stop and unload the current module.
//
// @param unknown - Unknown (I've seen 1 passed).
// @param argsize - Size (in bytes) of the arguments that will be passed to module_stop().
// @param argp - Pointer to arguments that will be passed to module_stop().
//
// @return ??? on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelSelfStopUnloadModule(unknown: c_int, argsize: SceSize, argp: ?*c_void) c_int;

// Stop and unload the current module.
//
// @param argsize - Size (in bytes) of the arguments that will be passed to module_stop().
// @param argp - Poitner to arguments that will be passed to module_stop().
// @param status - Return value from module_stop().
// @param option - Pointer to an optional ::SceKernelSMOption structure.
//
// @return ??? on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelStopUnloadSelfModule(argsize: SceSize, argp: ?*c_void, status: *c_int, option: *SceKernelSMOption) c_int;

// Query the information about a loaded module from its UID.
// @note This fails on v1.0 firmware (and even it worked has a limited structure)
// so if you want to be compatible with both 1.5 and 1.0 (and you are running in
// kernel mode) then call this function first then ::pspSdkQueryModuleInfoV1
// if it fails, or make separate v1 and v1.5+ builds.
//
// @param modid - The UID of the loaded module.
// @param info - Pointer to a ::SceKernelModuleInfo structure.
//
// @return 0 on success, otherwise one of ::PspKernelErrorCodes.
pub extern fn sceKernelQueryModuleInfo(modid: SceUID, info: *SceKernelModuleInfo) c_int;

// Get a list of module IDs. NOTE: This is only available on 1.5 firmware
// and above. For V1 use ::pspSdkGetModuleIdList.
//
// @param readbuf - Buffer to store the module list.
// @param readbufsize - Number of elements in the readbuffer.
// @param idcount - Returns the number of module ids
//
// @return >= 0 on success
pub extern fn sceKernelGetModuleIdList(readbuf: *SceUID, readbufsize: c_int, idcount: *c_int) c_int;

// Get the ID of the module occupying the address
//
// @param moduleAddr - A pointer to the module
//
// @return >= 0 on success, otherwise one of ::PspKernelErrorCodes
pub extern fn sceKernelGetModuleIdByAddress(moduleAddr: ?*c_void) c_int;
