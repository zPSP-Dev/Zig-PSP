//We do a private use in order to avoid issues in pspsdk.zig
usingnamespace @import("psptypes.zig");


pub extern fn sceKernelRegisterExitCallback(cbid: c_int) c_int;
pub extern fn sceKernelExitGame() void;

pub const struct_SceKernelLoadExecParam = extern struct {
    size: SceSize,
    args: SceSize,
    argp: ?*c_void,
    key: [*c]const u8,
};
pub extern fn sceKernelLoadExec(file: [*c]const u8, param: [*c]struct_SceKernelLoadExecParam) c_int;
pub const struct__scemoduleinfo = packed struct {
    modattribute: c_ushort,
    modversion: [2]u8,
    modname: [27]u8,
    terminal: u8,
    gp_value: [*c]u8,
    ent_top: [*c]u8,
    ent_end: [*c]u8,
    stub_top: [*c]u8,
    stub_end: [*c]u8,
};
pub const _sceModuleInfo = struct__scemoduleinfo;
pub const SceModuleInfo = _sceModuleInfo;

pub extern const _gp: [*c]u8;

pub const PSP_MODULE_USER = @enumToInt(enum_PspModuleInfoAttr.PSP_MODULE_USER);
pub const PSP_MODULE_NO_STOP = @enumToInt(enum_PspModuleInfoAttr.PSP_MODULE_NO_STOP);
pub const PSP_MODULE_SINGLE_LOAD = @enumToInt(enum_PspModuleInfoAttr.PSP_MODULE_SINGLE_LOAD);
pub const PSP_MODULE_SINGLE_START = @enumToInt(enum_PspModuleInfoAttr.PSP_MODULE_SINGLE_START);
pub const PSP_MODULE_KERNEL = @enumToInt(enum_PspModuleInfoAttr.PSP_MODULE_KERNEL);
pub const enum_PspModuleInfoAttr = extern enum(c_int) {
    PSP_MODULE_USER = 0,
    PSP_MODULE_NO_STOP = 1,
    PSP_MODULE_SINGLE_LOAD = 2,
    PSP_MODULE_SINGLE_START = 4,
    PSP_MODULE_KERNEL = 4096,
    _,
};
pub const struct_SceKernelLMOption = extern struct {
    size: SceSize,
    mpidtext: SceUID,
    mpiddata: SceUID,
    flags: c_uint,
    position: u8,
    access: u8,
    creserved: [2]u8,
};
pub const SceKernelLMOption = struct_SceKernelLMOption;
pub const struct_SceKernelSMOption = extern struct {
    size: SceSize,
    mpidstack: SceUID,
    stacksize: SceSize,
    priority: c_int,
    attribute: c_uint,
};
pub const SceKernelSMOption = struct_SceKernelSMOption;
pub extern fn sceKernelLoadModule(path: [*c]const u8, flags: c_int, option: [*c]SceKernelLMOption) SceUID;
pub extern fn sceKernelLoadModuleMs(path: [*c]const u8, flags: c_int, option: [*c]SceKernelLMOption) SceUID;
pub extern fn sceKernelLoadModuleByID(fid: SceUID, flags: c_int, option: [*c]SceKernelLMOption) SceUID;
pub extern fn sceKernelLoadModuleBufferUsbWlan(bufsize: SceSize, buf: ?*c_void, flags: c_int, option: [*c]SceKernelLMOption) SceUID;
pub extern fn sceKernelStartModule(modid: SceUID, argsize: SceSize, argp: ?*c_void, status: [*c]c_int, option: [*c]SceKernelSMOption) c_int;
pub extern fn sceKernelStopModule(modid: SceUID, argsize: SceSize, argp: ?*c_void, status: [*c]c_int, option: [*c]SceKernelSMOption) c_int;
pub extern fn sceKernelUnloadModule(modid: SceUID) c_int;
pub extern fn sceKernelSelfStopUnloadModule(unknown: c_int, argsize: SceSize, argp: ?*c_void) c_int;
pub extern fn sceKernelStopUnloadSelfModule(argsize: SceSize, argp: ?*c_void, status: [*c]c_int, option: [*c]SceKernelSMOption) c_int;
pub const struct_SceKernelModuleInfo = extern struct {
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
pub const SceKernelModuleInfo = struct_SceKernelModuleInfo;
pub extern fn sceKernelQueryModuleInfo(modid: SceUID, info: [*c]SceKernelModuleInfo) c_int;
pub extern fn sceKernelGetModuleIdList(readbuf: [*c]SceUID, readbufsize: c_int, idcount: [*c]c_int) c_int;
pub const PSP_SMEM_Low = @enumToInt(enum_PspSysMemBlockTypes.PSP_SMEM_Low);
pub const PSP_SMEM_High = @enumToInt(enum_PspSysMemBlockTypes.PSP_SMEM_High);
pub const PSP_SMEM_Addr = @enumToInt(enum_PspSysMemBlockTypes.PSP_SMEM_Addr);
pub const enum_PspSysMemBlockTypes = extern enum(c_int) {
    PSP_SMEM_Low = 0,
    PSP_SMEM_High = 1,
    PSP_SMEM_Addr = 2,
    _,
};
pub const SceKernelSysMemAlloc_t = c_int;
pub extern fn sceKernelAllocPartitionMemory(partitionid: SceUID, name: [*c]const u8, type: c_int, size: SceSize, addr: ?*c_void) SceUID;
pub extern fn sceKernelFreePartitionMemory(blockid: SceUID) c_int;
pub extern fn sceKernelGetBlockHeadAddr(blockid: SceUID) ?*c_void;
pub extern fn sceKernelTotalFreeMemSize() SceSize;
pub extern fn sceKernelMaxFreeMemSize() SceSize;

pub extern fn sceKernelDevkitVersion() c_int;
pub extern fn sceKernelSetCompiledSdkVersion(version: c_int) c_int;
pub extern fn sceKernelGetCompiledSdkVersion() c_int;


//pub extern fn pspDebugScreenInit() void;
//pub extern fn pspDebugScreenInitEx(vram_base: ?*c_void, mode: c_int, setup: c_int) void;
//pub extern fn pspDebugScreenPrintf(fmt: [*c]const u8, ...) void;
//pub extern fn pspDebugScreenKprintf(format: [*c]const u8, ...) void;
//pub extern fn pspDebugScreenEnableBackColor(enable: c_int) void;
//pub extern fn pspDebugScreenSetBackColor(color: u32_3) void;
//pub extern fn pspDebugScreenSetTextColor(color: u32_3) void;
//pub extern fn pspDebugScreenSetColorMode(mode: c_int) void;
//pub extern fn pspDebugScreenPutChar(x: c_int, y: c_int, color: u32_3, ch: u8_1) void;
//pub extern fn pspDebugScreenSetXY(x: c_int, y: c_int) void;
//pub extern fn pspDebugScreenSetOffset(offset: c_int) void;
//pub extern fn pspDebugScreenSetBase(base: [*c]u32_3) void;
//pub extern fn pspDebugScreenGetX() c_int;
//pub extern fn pspDebugScreenGetY() c_int;
//pub extern fn pspDebugScreenClear() void;
//pub extern fn pspDebugScreenPrintData(buff: [*c]const u8, size: c_int) c_int;
//pub extern fn pspDebugScreenPuts(str: [*c]const u8) c_int;
//pub extern fn pspDebugGetStackTrace(results: [*c]c_uint, max: c_int) c_int;
//pub extern fn pspDebugScreenClearLineEnable() void;
//pub extern fn pspDebugScreenClearLineDisable() void;
//pub const struct__PspDebugRegBlock = extern struct {
//    frame: [6]u32_3,
//    r: [32]u32_3,
//    status: u32_3,
//    lo: u32_3,
//    hi: u32_3,
//    badvaddr: u32_3,
//    cause: u32_3,
//    epc: u32_3,
//    fpr: [32]f32,
//    fsr: u32_3,
//    fir: u32_3,
//    frame_ptr: u32_3,
//    unused: u32_3,
//    index: u32_3,
//    random: u32_3,
//    entrylo0: u32_3,
//    entrylo1: u32_3,
//    context: u32_3,
//    pagemask: u32_3,
//    wired: u32_3,
//    cop0_7: u32_3,
//    cop0_8: u32_3,
//    cop0_9: u32_3,
//    entryhi: u32_3,
//    cop0_11: u32_3,
//    cop0_12: u32_3,
//    cop0_13: u32_3,
//    cop0_14: u32_3,
//    prid: u32_3,
//    padding: [100]u32_3,
//};