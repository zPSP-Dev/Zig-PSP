pub const enum_PspCtrlButtons = extern enum(c_int) {
    PSP_CTRL_SELECT = 1,
    PSP_CTRL_START = 8,
    PSP_CTRL_UP = 16,
    PSP_CTRL_RIGHT = 32,
    PSP_CTRL_DOWN = 64,
    PSP_CTRL_LEFT = 128,
    PSP_CTRL_LTRIGGER = 256,
    PSP_CTRL_RTRIGGER = 512,
    PSP_CTRL_TRIANGLE = 4096,
    PSP_CTRL_CIRCLE = 8192,
    PSP_CTRL_CROSS = 16384,
    PSP_CTRL_SQUARE = 32768,
    PSP_CTRL_HOME = 65536,
    PSP_CTRL_HOLD = 131072,
    PSP_CTRL_NOTE = 8388608,
    PSP_CTRL_SCREEN = 4194304,
    PSP_CTRL_VOLUP = 1048576,
    PSP_CTRL_VOLDOWN = 2097152,
    PSP_CTRL_WLAN_UP = 262144,
    PSP_CTRL_REMOTE = 524288,
    PSP_CTRL_DISC = 16777216,
    PSP_CTRL_MS = 33554432,
    _,
};

pub const enum_PspCtrlMode = extern enum(c_int) {
    PSP_CTRL_MODE_DIGITAL = 0,
    PSP_CTRL_MODE_ANALOG = 1,
    _,
};
pub const struct_SceCtrlData = extern struct {
    TimeStamp: c_uint,
    Buttons: c_uint,
    Lx: u8,
    Ly: u8,
    Rsrv: [6]u8,
};
pub const SceCtrlData = struct_SceCtrlData;
pub const struct_SceCtrlLatch = extern struct {
    uiMake: c_uint,
    uiBreak: c_uint,
    uiPress: c_uint,
    uiRelease: c_uint,
};
pub const SceCtrlLatch = struct_SceCtrlLatch;
pub extern fn sceCtrlSetSamplingCycle(cycle: c_int) c_int;
pub extern fn sceCtrlGetSamplingCycle(pcycle: [*c]c_int) c_int;
pub extern fn sceCtrlSetSamplingMode(mode: c_int) c_int;
pub extern fn sceCtrlGetSamplingMode(pmode: [*c]c_int) c_int;
pub extern fn sceCtrlPeekBufferPositive(pad_data: [*c]SceCtrlData, count: c_int) c_int;
pub extern fn sceCtrlPeekBufferNegative(pad_data: [*c]SceCtrlData, count: c_int) c_int;
pub extern fn sceCtrlReadBufferPositive(pad_data: [*c]SceCtrlData, count: c_int) c_int;
pub extern fn sceCtrlReadBufferNegative(pad_data: [*c]SceCtrlData, count: c_int) c_int;
pub extern fn sceCtrlPeekLatch(latch_data: [*c]SceCtrlLatch) c_int;
pub extern fn sceCtrlReadLatch(latch_data: [*c]SceCtrlLatch) c_int;
pub extern fn sceCtrlSetIdleCancelThreshold(idlereset: c_int, idleback: c_int) c_int;
pub extern fn sceCtrlGetIdleCancelThreshold(idlerest: [*c]c_int, idleback: [*c]c_int) c_int;

pub const PspCtrlButtons = enum_PspCtrlButtons;
pub const PspCtrlMode = enum_PspCtrlMode;

//Kernel?
pub extern fn sceDisplay_driver_63E22A26(pri: c_int, topaddr: ?*c_void, bufferwidth: c_int, pixelformat: c_int, sync: c_int) c_int;
pub extern fn sceDisplay_driver_5B5AEFAD(pri: c_int, topaddr: [*c]?*c_void, bufferwidth: [*c]c_int, pixelformat: [*c]c_int, sync: c_int) c_int;
pub extern fn sceDisplaySetBrightness(level: c_int, unk1: c_int) void;
pub extern fn sceDisplayGetBrightness(level: [*c]c_int, unk1: [*c]c_int) void;

pub const sceDisplayGetFrameBufferInternal = sceDisplay_driver_5B5AEFAD;
pub const sceDisplaySetFrameBufferInternal = sceDisplay_driver_63E22A26;
