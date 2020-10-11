usingnamespace @import("psptypes.zig");

pub const struct_SceKernelSysClock = extern struct {
    low: SceUInt32,
    hi: SceUInt32,
};
pub const SceKernelSysClock = struct_SceKernelSysClock;

pub const enum_PspThreadAttributes = extern enum(u32) {
    PSP_THREAD_ATTR_VFPU = 16384,
    PSP_THREAD_ATTR_USER = 2147483648,
    PSP_THREAD_ATTR_USBWLAN = 2684354560,
    PSP_THREAD_ATTR_VSH = 3221225472,
    PSP_THREAD_ATTR_SCRATCH_SRAM = 32768,
    PSP_THREAD_ATTR_NO_FILLSTACK = 1048576,
    PSP_THREAD_ATTR_CLEAR_STACK = 2097152,
    _,
};
pub const SceKernelThreadEntry = ?fn (SceSize, ?*c_void) callconv(.C) c_int;
pub const struct_SceKernelThreadOptParam = extern struct {
    size: SceSize,
    stackMpid: SceUID,
};
pub const SceKernelThreadOptParam = struct_SceKernelThreadOptParam;
pub const struct_SceKernelThreadInfo = extern struct {
    size: SceSize,
    name: [32]u8,
    attr: SceUInt,
    status: c_int,
    entry: SceKernelThreadEntry,
    stack: ?*c_void,
    stackSize: c_int,
    gpReg: ?*c_void,
    initPriority: c_int,
    currentPriority: c_int,
    waitType: c_int,
    waitId: SceUID,
    wakeupCount: c_int,
    exitStatus: c_int,
    runClocks: SceKernelSysClock,
    intrPreemptCount: SceUInt,
    threadPreemptCount: SceUInt,
    releaseCount: SceUInt,
};
pub const SceKernelThreadInfo = struct_SceKernelThreadInfo;
pub const struct_SceKernelThreadRunStatus = extern struct {
    size: SceSize,
    status: c_int,
    currentPriority: c_int,
    waitType: c_int,
    waitId: c_int,
    wakeupCount: c_int,
    runClocks: SceKernelSysClock,
    intrPreemptCount: SceUInt,
    threadPreemptCount: SceUInt,
    releaseCount: SceUInt,
};
pub const SceKernelThreadRunStatus = struct_SceKernelThreadRunStatus;
pub const enum_PspThreadStatus = extern enum(c_int) {
    PSP_THREAD_RUNNING = 1,
    PSP_THREAD_READY = 2,
    PSP_THREAD_WAITING = 4,
    PSP_THREAD_SUSPEND = 8,
    PSP_THREAD_STOPPED = 16,
    PSP_THREAD_KILLED = 32,
    _,
};
pub extern fn sceKernelDeleteThread(thid: SceUID) c_int;
pub extern fn sceKernelStartThread(thid: SceUID, arglen: SceSize, argp: ?*c_void) c_int;
pub extern fn sceKernelExitThread(status: c_int) c_int;
pub extern fn sceKernelExitDeleteThread(status: c_int) c_int;
pub extern fn sceKernelTerminateThread(thid: SceUID) c_int;
pub extern fn sceKernelTerminateDeleteThread(thid: SceUID) c_int;
pub extern fn sceKernelSuspendDispatchThread() c_int;
pub extern fn sceKernelResumeDispatchThread(state: c_int) c_int;
pub extern fn sceKernelSleepThread() c_int;
pub extern fn sceKernelSleepThreadCB() c_int;
pub extern fn sceKernelWakeupThread(thid: SceUID) c_int;
pub extern fn sceKernelCancelWakeupThread(thid: SceUID) c_int;
pub extern fn sceKernelSuspendThread(thid: SceUID) c_int;
pub extern fn sceKernelResumeThread(thid: SceUID) c_int;
pub extern fn sceKernelWaitThreadEnd(thid: SceUID, timeout: [*c]SceUInt) c_int;
pub extern fn sceKernelWaitThreadEndCB(thid: SceUID, timeout: [*c]SceUInt) c_int;
pub extern fn sceKernelDelayThread(delay: u32) c_int;
pub extern fn sceKernelDelayThreadCB(delay: SceUInt) c_int;
pub extern fn sceKernelDelaySysClockThread(delay: [*c]SceKernelSysClock) c_int;
pub extern fn sceKernelDelaySysClockThreadCB(delay: [*c]SceKernelSysClock) c_int;
pub extern fn sceKernelChangeCurrentThreadAttr(unknown: c_int, attr: SceUInt) c_int;
pub extern fn sceKernelChangeThreadPriority(thid: SceUID, priority: c_int) c_int;
pub extern fn sceKernelRotateThreadReadyQueue(priority: c_int) c_int;
pub extern fn sceKernelReleaseWaitThread(thid: SceUID) c_int;
pub extern fn sceKernelGetThreadId() c_int;
pub extern fn sceKernelGetThreadCurrentPriority() c_int;
pub extern fn sceKernelGetThreadExitStatus(thid: SceUID) c_int;
pub extern fn sceKernelCheckThreadStack() c_int;
pub extern fn sceKernelGetThreadStackFreeSize(thid: SceUID) c_int;
pub extern fn sceKernelReferThreadStatus(thid: SceUID, info: [*c]SceKernelThreadInfo) c_int;
pub extern fn sceKernelReferThreadRunStatus(thid: SceUID, status: [*c]SceKernelThreadRunStatus) c_int;
pub const struct_SceKernelSemaOptParam = extern struct {
    size: SceSize,
};
pub const SceKernelSemaOptParam = struct_SceKernelSemaOptParam;
pub const struct_SceKernelSemaInfo = extern struct {
    size: SceSize,
    name: [32]u8,
    attr: SceUInt,
    initCount: c_int,
    currentCount: c_int,
    maxCount: c_int,
    numWaitThreads: c_int,
};
pub const SceKernelSemaInfo = struct_SceKernelSemaInfo;
pub extern fn sceKernelCreateSema(name: [*c]const u8, attr: SceUInt, initVal: c_int, maxVal: c_int, option: [*c]SceKernelSemaOptParam) SceUID;
pub extern fn sceKernelDeleteSema(semaid: SceUID) c_int;
pub extern fn sceKernelSignalSema(semaid: SceUID, signal: c_int) c_int;
pub extern fn sceKernelWaitSema(semaid: SceUID, signal: c_int, timeout: [*c]SceUInt) c_int;
pub extern fn sceKernelWaitSemaCB(semaid: SceUID, signal: c_int, timeout: [*c]SceUInt) c_int;
pub extern fn sceKernelPollSema(semaid: SceUID, signal: c_int) c_int;
pub extern fn sceKernelReferSemaStatus(semaid: SceUID, info: [*c]SceKernelSemaInfo) c_int;
pub const struct_SceKernelEventFlagInfo = extern struct {
    size: SceSize,
    name: [32]u8,
    attr: SceUInt,
    initPattern: SceUInt,
    currentPattern: SceUInt,
    numWaitThreads: c_int,
};
pub const SceKernelEventFlagInfo = struct_SceKernelEventFlagInfo;
pub const struct_SceKernelEventFlagOptParam = extern struct {
    size: SceSize,
};
pub const SceKernelEventFlagOptParam = struct_SceKernelEventFlagOptParam;
pub const enum_PspEventFlagAttributes = extern enum(c_int) {
    PSP_EVENT_WAITMULTIPLE = 512,
    _,
};
pub const enum_PspEventFlagWaitTypes = extern enum(c_int) {
    PSP_EVENT_WAITAND = 0,
    PSP_EVENT_WAITOR = 1,
    PSP_EVENT_WAITCLEAR = 32,
    _,
};
pub extern fn sceKernelCreateEventFlag(name: [*c]const u8, attr: c_int, bits: c_int, opt: [*c]SceKernelEventFlagOptParam) SceUID;
pub extern fn sceKernelSetEventFlag(evid: SceUID, bits: u32) c_int;
pub extern fn sceKernelClearEventFlag(evid: SceUID, bits: u32) c_int;
pub extern fn sceKernelPollEventFlag(evid: c_int, bits: u32, wait: u32, outBits: [*c]u32) c_int;
pub extern fn sceKernelWaitEventFlag(evid: c_int, bits: u32, wait: u32, outBits: [*c]u32, timeout: [*c]SceUInt) c_int;
pub extern fn sceKernelWaitEventFlagCB(evid: c_int, bits: u32, wait: u32, outBits: [*c]u32, timeout: [*c]SceUInt) c_int;
pub extern fn sceKernelDeleteEventFlag(evid: c_int) c_int;
pub extern fn sceKernelReferEventFlagStatus(event: SceUID, status: [*c]SceKernelEventFlagInfo) c_int;
pub const struct_SceKernelMbxOptParam = extern struct {
    size: SceSize,
};
pub const SceKernelMbxOptParam = struct_SceKernelMbxOptParam;
pub const struct_SceKernelMbxInfo = extern struct {
    size: SceSize,
    name: [32]u8,
    attr: SceUInt,
    numWaitThreads: c_int,
    numMessages: c_int,
    firstMessage: ?*c_void,
};
pub const SceKernelMbxInfo = struct_SceKernelMbxInfo;
pub const struct_SceKernelMsgPacket = extern struct {
    next: [*c]struct_SceKernelMsgPacket,
    msgPriority: SceUChar,
    dummy: [3]SceUChar,
};
pub const SceKernelMsgPacket = struct_SceKernelMsgPacket;
pub extern fn sceKernelCreateMbx(name: [*c]const u8, attr: SceUInt, option: [*c]SceKernelMbxOptParam) SceUID;
pub extern fn sceKernelDeleteMbx(mbxid: SceUID) c_int;
pub extern fn sceKernelSendMbx(mbxid: SceUID, message: ?*c_void) c_int;
pub extern fn sceKernelReceiveMbx(mbxid: SceUID, pmessage: [*c]?*c_void, timeout: [*c]SceUInt) c_int;
pub extern fn sceKernelReceiveMbxCB(mbxid: SceUID, pmessage: [*c]?*c_void, timeout: [*c]SceUInt) c_int;
pub extern fn sceKernelPollMbx(mbxid: SceUID, pmessage: [*c]?*c_void) c_int;
pub extern fn sceKernelCancelReceiveMbx(mbxid: SceUID, pnum: [*c]c_int) c_int;
pub extern fn sceKernelReferMbxStatus(mbxid: SceUID, info: [*c]SceKernelMbxInfo) c_int;
pub const SceKernelAlarmHandler = ?fn (?*c_void) callconv(.C) SceUInt;
pub const struct_SceKernelAlarmInfo = extern struct {
    size: SceSize,
    schedule: SceKernelSysClock,
    handler: SceKernelAlarmHandler,
    common: ?*c_void,
};
pub const SceKernelAlarmInfo = struct_SceKernelAlarmInfo;
pub extern fn sceKernelSetAlarm(clock: SceUInt, handler: SceKernelAlarmHandler, common: ?*c_void) SceUID;
pub extern fn sceKernelSetSysClockAlarm(clock: [*c]SceKernelSysClock, handler: SceKernelAlarmHandler, common: ?*c_void) SceUID;
pub extern fn sceKernelCancelAlarm(alarmid: SceUID) c_int;
pub extern fn sceKernelReferAlarmStatus(alarmid: SceUID, info: [*c]SceKernelAlarmInfo) c_int;
pub const SceKernelCallbackFunction = ?fn (c_int, c_int, ?*c_void) callconv(.C) c_int;
pub const struct_SceKernelCallbackInfo = extern struct {
    size: SceSize,
    name: [32]u8,
    threadId: SceUID,
    callback: SceKernelCallbackFunction,
    common: ?*c_void,
    notifyCount: c_int,
    notifyArg: c_int,
};
pub const SceKernelCallbackInfo = struct_SceKernelCallbackInfo;
pub extern fn sceKernelCreateCallback(name: [*c]const u8, func: SceKernelCallbackFunction, arg: ?*c_void) c_int;
pub extern fn sceKernelReferCallbackStatus(cb: SceUID, status: [*c]SceKernelCallbackInfo) c_int;
pub extern fn sceKernelDeleteCallback(cb: SceUID) c_int;
pub extern fn sceKernelNotifyCallback(cb: SceUID, arg2: c_int) c_int;
pub extern fn sceKernelCancelCallback(cb: SceUID) c_int;
pub extern fn sceKernelGetCallbackCount(cb: SceUID) c_int;
pub extern fn sceKernelCheckCallback() c_int;
pub const enum_SceKernelIdListType = extern enum(c_int) {
    SCE_KERNEL_TMID_Thread = 1,
    SCE_KERNEL_TMID_Semaphore = 2,
    SCE_KERNEL_TMID_EventFlag = 3,
    SCE_KERNEL_TMID_Mbox = 4,
    SCE_KERNEL_TMID_Vpl = 5,
    SCE_KERNEL_TMID_Fpl = 6,
    SCE_KERNEL_TMID_Mpipe = 7,
    SCE_KERNEL_TMID_Callback = 8,
    SCE_KERNEL_TMID_ThreadEventHandler = 9,
    SCE_KERNEL_TMID_Alarm = 10,
    SCE_KERNEL_TMID_VTimer = 11,
    SCE_KERNEL_TMID_SleepThread = 64,
    SCE_KERNEL_TMID_DelayThread = 65,
    SCE_KERNEL_TMID_SuspendThread = 66,
    SCE_KERNEL_TMID_DormantThread = 67,
    _,
};
pub extern fn sceKernelGetThreadmanIdList(typec: enum_SceKernelIdListType, readbuf: [*c]SceUID, readbufsize: c_int, idcount: [*c]c_int) c_int;
pub const struct_SceKernelSystemStatus = extern struct {
    size: SceSize,
    status: SceUInt,
    idleClocks: SceKernelSysClock,
    comesOutOfIdleCount: SceUInt,
    threadSwitchCount: SceUInt,
    vfpuSwitchCount: SceUInt,
};
pub const SceKernelSystemStatus = struct_SceKernelSystemStatus;
pub extern fn sceKernelReferSystemStatus(status: [*c]SceKernelSystemStatus) c_int;
pub extern fn sceKernelCreateMsgPipe(name: [*c]const u8, part: c_int, attr: c_int, unk1: ?*c_void, opt: ?*c_void) SceUID;
pub extern fn sceKernelDeleteMsgPipe(uid: SceUID) c_int;
pub extern fn sceKernelSendMsgPipe(uid: SceUID, message: ?*c_void, size: c_uint, unk1: c_int, unk2: ?*c_void, timeout: [*c]c_uint) c_int;
pub extern fn sceKernelSendMsgPipeCB(uid: SceUID, message: ?*c_void, size: c_uint, unk1: c_int, unk2: ?*c_void, timeout: [*c]c_uint) c_int;
pub extern fn sceKernelTrySendMsgPipe(uid: SceUID, message: ?*c_void, size: c_uint, unk1: c_int, unk2: ?*c_void) c_int;
pub extern fn sceKernelReceiveMsgPipe(uid: SceUID, message: ?*c_void, size: c_uint, unk1: c_int, unk2: ?*c_void, timeout: [*c]c_uint) c_int;
pub extern fn sceKernelReceiveMsgPipeCB(uid: SceUID, message: ?*c_void, size: c_uint, unk1: c_int, unk2: ?*c_void, timeout: [*c]c_uint) c_int;
pub extern fn sceKernelTryReceiveMsgPipe(uid: SceUID, message: ?*c_void, size: c_uint, unk1: c_int, unk2: ?*c_void) c_int;
pub extern fn sceKernelCancelMsgPipe(uid: SceUID, psend: [*c]c_int, precv: [*c]c_int) c_int;
pub const struct_SceKernelMppInfo = extern struct {
    size: SceSize,
    name: [32]u8,
    attr: SceUInt,
    bufSize: c_int,
    freeSize: c_int,
    numSendWaitThreads: c_int,
    numReceiveWaitThreads: c_int,
};
pub const SceKernelMppInfo = struct_SceKernelMppInfo;
pub extern fn sceKernelReferMsgPipeStatus(uid: SceUID, info: [*c]SceKernelMppInfo) c_int;
pub const struct_SceKernelVplOptParam = extern struct {
    size: SceSize,
};
pub extern fn sceKernelCreateVpl(name: [*c]const u8, part: c_int, attr: c_int, size: c_uint, opt: [*c]struct_SceKernelVplOptParam) SceUID;
pub extern fn sceKernelDeleteVpl(uid: SceUID) c_int;
pub extern fn sceKernelAllocateVpl(uid: SceUID, size: c_uint, data: [*c]?*c_void, timeout: [*c]c_uint) c_int;
pub extern fn sceKernelAllocateVplCB(uid: SceUID, size: c_uint, data: [*c]?*c_void, timeout: [*c]c_uint) c_int;
pub extern fn sceKernelTryAllocateVpl(uid: SceUID, size: c_uint, data: [*c]?*c_void) c_int;
pub extern fn sceKernelFreeVpl(uid: SceUID, data: ?*c_void) c_int;
pub extern fn sceKernelCancelVpl(uid: SceUID, pnum: [*c]c_int) c_int;
pub const struct_SceKernelVplInfo = extern struct {
    size: SceSize,
    name: [32]u8,
    attr: SceUInt,
    poolSize: c_int,
    freeSize: c_int,
    numWaitThreads: c_int,
};
pub const SceKernelVplInfo = struct_SceKernelVplInfo;
pub extern fn sceKernelReferVplStatus(uid: SceUID, info: [*c]SceKernelVplInfo) c_int;
pub const struct_SceKernelFplOptParam = extern struct {
    size: SceSize,
};
pub extern fn sceKernelCreateFpl(name: [*c]const u8, part: c_int, attr: c_int, size: c_uint, blocks: c_uint, opt: [*c]struct_SceKernelFplOptParam) c_int;
pub extern fn sceKernelDeleteFpl(uid: SceUID) c_int;
pub extern fn sceKernelAllocateFpl(uid: SceUID, data: [*c]?*c_void, timeout: [*c]c_uint) c_int;
pub extern fn sceKernelAllocateFplCB(uid: SceUID, data: [*c]?*c_void, timeout: [*c]c_uint) c_int;
pub extern fn sceKernelTryAllocateFpl(uid: SceUID, data: [*c]?*c_void) c_int;
pub extern fn sceKernelFreeFpl(uid: SceUID, data: ?*c_void) c_int;
pub extern fn sceKernelCancelFpl(uid: SceUID, pnum: [*c]c_int) c_int;
pub const struct_SceKernelFplInfo = extern struct {
    size: SceSize,
    name: [32]u8,
    attr: SceUInt,
    blockSize: c_int,
    numBlocks: c_int,
    freeBlocks: c_int,
    numWaitThreads: c_int,
};
pub const SceKernelFplInfo = struct_SceKernelFplInfo;
pub extern fn sceKernelReferFplStatus(uid: SceUID, info: [*c]SceKernelFplInfo) c_int;
pub extern fn _sceKernelReturnFromTimerHandler() void;
pub extern fn _sceKernelReturnFromCallback() void;
pub extern fn sceKernelUSec2SysClock(usec: c_uint, clock: [*c]SceKernelSysClock) c_int;
pub extern fn sceKernelUSec2SysClockWide(usec: c_uint) SceInt64;
pub extern fn sceKernelSysClock2USec(clock: [*c]SceKernelSysClock, low: [*c]c_uint, high: [*c]c_uint) c_int;
pub extern fn sceKernelSysClock2USecWide(clock: SceInt64, low: [*c]c_uint, high: [*c]c_uint) c_int;
pub extern fn sceKernelGetSystemTime(time: [*c]SceKernelSysClock) c_int;
pub extern fn sceKernelGetSystemTimeWide() SceInt64;
pub extern fn sceKernelGetSystemTimeLow() c_uint;
pub const struct_SceKernelVTimerOptParam = extern struct {
    size: SceSize,
};
pub extern fn sceKernelCreateVTimer(name: [*c]const u8, opt: [*c]struct_SceKernelVTimerOptParam) SceUID;
pub extern fn sceKernelDeleteVTimer(uid: SceUID) c_int;
pub extern fn sceKernelGetVTimerBase(uid: SceUID, base: [*c]SceKernelSysClock) c_int;
pub extern fn sceKernelGetVTimerBaseWide(uid: SceUID) SceInt64;
pub extern fn sceKernelGetVTimerTime(uid: SceUID, time: [*c]SceKernelSysClock) c_int;
pub extern fn sceKernelGetVTimerTimeWide(uid: SceUID) SceInt64;
pub extern fn sceKernelSetVTimerTime(uid: SceUID, time: [*c]SceKernelSysClock) c_int;
pub extern fn sceKernelSetVTimerTimeWide(uid: SceUID, time: SceInt64) SceInt64;
pub extern fn sceKernelStartVTimer(uid: SceUID) c_int;
pub extern fn sceKernelStopVTimer(uid: SceUID) c_int;
pub const SceKernelVTimerHandler = ?fn (SceUID, [*c]SceKernelSysClock, [*c]SceKernelSysClock, ?*c_void) callconv(.C) SceUInt;
pub const SceKernelVTimerHandlerWide = ?fn (SceUID, SceInt64, SceInt64, ?*c_void) callconv(.C) SceUInt;
pub extern fn sceKernelSetVTimerHandler(uid: SceUID, time: [*c]SceKernelSysClock, handler: SceKernelVTimerHandler, common: ?*c_void) c_int;
pub extern fn sceKernelSetVTimerHandlerWide(uid: SceUID, time: SceInt64, handler: SceKernelVTimerHandlerWide, common: ?*c_void) c_int;
pub extern fn sceKernelCancelVTimerHandler(uid: SceUID) c_int;
pub const struct_SceKernelVTimerInfo = extern struct {
    size: SceSize,
    name: [32]u8,
    active: c_int,
    base: SceKernelSysClock,
    current: SceKernelSysClock,
    schedule: SceKernelSysClock,
    handler: SceKernelVTimerHandler,
    common: ?*c_void,
};
pub const SceKernelVTimerInfo = struct_SceKernelVTimerInfo;
pub extern fn sceKernelReferVTimerStatus(uid: SceUID, info: [*c]SceKernelVTimerInfo) c_int;
pub extern fn _sceKernelExitThread() void;
pub extern fn sceKernelGetThreadmanIdType(uid: SceUID) enum_SceKernelIdListType;
pub const SceKernelThreadEventHandler = ?fn (c_int, SceUID, ?*c_void) callconv(.C) c_int;
pub const struct_SceKernelThreadEventHandlerInfo = extern struct {
    size: SceSize,
    name: [32]u8,
    threadId: SceUID,
    mask: c_int,
    handler: SceKernelThreadEventHandler,
    common: ?*c_void,
};
pub const SceKernelThreadEventHandlerInfo = struct_SceKernelThreadEventHandlerInfo;
pub const enum_ThreadEventIds = extern enum(c_int) {
    THREADEVENT_ALL = 4294967295,
    THREADEVENT_KERN = 4294967288,
    THREADEVENT_USER = 4294967280,
    THREADEVENT_CURRENT = 0,
    _,
};
pub const enum_ThreadEvents = extern enum(c_int) {
    THREAD_CREATE = 1,
    THREAD_START = 2,
    THREAD_EXIT = 4,
    THREAD_DELETE = 8,
    _,
};
pub extern fn sceKernelRegisterThreadEventHandler(name: [*c]const u8, threadID: SceUID, mask: c_int, handler: SceKernelThreadEventHandler, common: ?*c_void) SceUID;
pub extern fn sceKernelReleaseThreadEventHandler(uid: SceUID) c_int;
pub extern fn sceKernelReferThreadEventHandlerStatus(uid: SceUID, info: [*c]struct_SceKernelThreadEventHandlerInfo) c_int;
pub extern fn sceKernelReferThreadProfiler() [*c]PspDebugProfilerRegs;
pub extern fn sceKernelReferGlobalProfiler() [*c]PspDebugProfilerRegs;
pub extern fn sceKernelCreateThread(name: [*c]const u8, entry: SceKernelThreadEntry, initPriority: c_int, stackSize: c_int, attr: SceUInt, option: [*c]SceKernelThreadOptParam) SceUID;

pub const PspModuleInfoAttr = enum_PspModuleInfoAttr;
pub const PspThreadAttributes = enum_PspThreadAttributes;
pub const PspThreadStatus = enum_PspThreadStatus;
pub const PspEventFlagAttributes = enum_PspEventFlagAttributes;
pub const PspEventFlagWaitTypes = enum_PspEventFlagWaitTypes;
pub const SceKernelIdListType = enum_SceKernelIdListType;
pub const SceKernelVplOptParam = struct_SceKernelVplOptParam;
pub const SceKernelFplOptParam = struct_SceKernelFplOptParam;
pub const SceKernelVTimerOptParam = struct_SceKernelVTimerOptParam;
pub const ThreadEventIds = enum_ThreadEventIds;
pub const ThreadEvents = enum_ThreadEvents;
