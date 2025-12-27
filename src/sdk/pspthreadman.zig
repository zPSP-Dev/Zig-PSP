const libzpsp = @import("libzpsp");
const module = libzpsp.ThreadManForUser;

pub const SceUID = libzpsp.types.SceUID;
pub const SceSize = libzpsp.types.SceSize;
pub const SceUInt = libzpsp.types.SceUInt;
pub const SceInt64 = libzpsp.types.SceInt64;
pub const SceUInt32 = libzpsp.types.SceUInt32;
pub const SceUChar = libzpsp.types.SceUChar;

pub const SceKernelCallbackFunction = libzpsp.types.SceKernelCallbackFunction;
pub const SceKernelCallbackInfo = libzpsp.types.SceKernelCallbackInfo;
pub const SceKernelVplOptParam = libzpsp.types.SceKernelVplOptParam;
pub const SceKernelFplOptParam = libzpsp.types.SceKernelFplOptParam;
pub const SceKernelFplInfo = libzpsp.types.SceKernelFplInfo;
pub const SceKernelIdListType = libzpsp.types.SceKernelIdListType;
pub const PspEventFlagWaitTypes = libzpsp.types.PspEventFlagWaitTypes;
pub const SceKernelAlarmHandler = libzpsp.types.SceKernelAlarmHandler;
pub const SceKernelAlarmInfo = libzpsp.types.SceKernelAlarmInfo;
pub const SceKernelEventFlagInfo = libzpsp.types.SceKernelEventFlagInfo;
pub const SceKernelEventFlagOptParam = libzpsp.types.SceKernelEventFlagOptParam;
pub const SceKernelMbxInfo = libzpsp.types.SceKernelMbxInfo;
pub const SceKernelMbxOptParam = libzpsp.types.SceKernelMbxOptParam;
pub const SceKernelMppInfo = libzpsp.types.SceKernelMppInfo;
pub const SceKernelSemaInfo = libzpsp.types.SceKernelSemaInfo;
pub const SceKernelSemaOptParam = libzpsp.types.SceKernelSemaOptParam;
pub const SceKernelSysClock = libzpsp.types.SceKernelSysClock;
pub const SceKernelSystemStatus = libzpsp.types.SceKernelSystemStatus;
pub const SceKernelThreadEntry = libzpsp.types.SceKernelThreadEntry;
pub const SceKernelThreadEventHandler = libzpsp.types.SceKernelThreadEventHandler;
pub const SceKernelThreadEventHandlerInfo = libzpsp.types.SceKernelThreadEventHandlerInfo;
pub const SceKernelThreadInfo = libzpsp.types.SceKernelThreadInfo;
pub const SceKernelThreadOptParam = libzpsp.types.SceKernelThreadOptParam;
pub const SceKernelThreadRunStatus = libzpsp.types.SceKernelThreadRunStatus;
pub const SceKernelVTimerHandler = libzpsp.types.SceKernelVTimerHandler;
pub const SceKernelVTimerHandlerWide = libzpsp.types.SceKernelVTimerHandlerWide;
pub const SceKernelVTimerInfo = libzpsp.types.SceKernelVTimerInfo;
pub const SceKernelVTimerOptParam = libzpsp.types.SceKernelVTimerOptParam;
pub const SceKernelVplInfo = libzpsp.types.SceKernelVplInfo;

// Helper for PspEventFlagWaitTypes
pub const PspEventFlagWaitTypesMask = packed struct(u32) {
    boolean_op: enum(u1) {
        And = 0, // PSP_EVENT_WAITAND = 0,
        Or = 1, // PSP_EVENT_WAITOR = 1
    } = .And,

    unused_b1_5: u4 = 0,

    wait_clear: bool = false, // PSP_EVENT_WAITCLEAR = 32,

    unused_b7_31: u26 = 0,
};

pub const PspThreadAttributes = enum(u32) {
    VFPU = 0x00_00_40_00, // Enable VFPU access for the thread.
    SCRATCH_SRAM = 0x00_00_80_00, // Allow using scratchpad memory for a thread, NOT USABLE ON V1.0
    NO_FILLSTACK = 0x00_10_00_00, // Disables filling the stack with 0xFF on creation
    CLEAR_STACK = 0x00_20_00_00, // Clear the stack when the thread is deleted
    USER = 0x80_00_00_00, // Start the thread in user mode (done automatically if the thread creating it is in user mode).
    USBWLAN = 0xa0_00_00_00, // Thread is part of the USB/WLAN API.
    VSH = 0xc0_00_00_00, // Thread is part of the VSH API.
};

// Helper for PspThreadAttributes
pub const PspThreadAttributesMask = packed struct(u32) {
    unused_b0_13: u14 = 0,

    vfpu: bool = false, // bit 14 (0x00004000)
    scratch_sram: bool = false, // bit 15 (0x00008000)

    unused_b16_19: u4 = 0,

    no_fillstack: bool = false, // bit 20 (0x00100000)
    clear_stack: bool = false, // bit 21 (0x00200000)

    unused_b22_28: u7 = 0,

    usbwlan: bool = false, // NOTE: Set the user bit as well when using this
    vsh: bool = false, // NOTE: Set the user bit as well when using this
    user: bool = false, // bit 31 (0x80000000)
};

pub const ThreadEventIds = enum(c_int) {
    THREADEVENT_ALL = 0xFFFFFFFF,
    THREADEVENT_KERN = 0xFFFFFFF8,
    THREADEVENT_USER = 0xFFFFFFF0,
    THREADEVENT_CURRENT = 0,
    _,
};

pub const ThreadEvents = enum(c_int) {
    THREAD_CREATE = 1,
    THREAD_START = 2,
    THREAD_EXIT = 4,
    THREAD_DELETE = 8,
    _,
};

pub const PspThreadStatus = enum(c_int) {
    PSP_THREAD_RUNNING = 1,
    PSP_THREAD_READY = 2,
    PSP_THREAD_WAITING = 4,
    PSP_THREAD_SUSPEND = 8,
    PSP_THREAD_STOPPED = 16,
    PSP_THREAD_KILLED = 32,
    _,
};

pub const PspEventFlagAttributes = enum(c_int) {
    WaitSingle = 0,
    WaitMultiple = 512,
};

pub const SceKernelMsgPacket = extern struct {
    next: [*c]SceKernelMsgPacket,
    msgPriority: SceUChar,
    dummy: [3]SceUChar,
};

/// Return from a callback (used as a syscall for the return
/// of the callback function)
pub fn _sceKernelReturnFromCallback() void {
    module._sceKernelReturnFromCallback();
}

// NOTE: handler should be a pointer?
/// Register a thread event handler
/// `name` - Name for the thread event handler
/// `threadID` - Thread ID to monitor
/// `mask` - Bit mask for what events to handle (only lowest 4 bits valid)
/// `handler` - Pointer to a ::SceKernelThreadEventHandler function
/// `common` - Common pointer
/// Returns The UID of the create event handler, < 0 on error
pub fn sceKernelRegisterThreadEventHandler(name: [*c]const c_char, threadID: SceUID, mask: c_int, handler: SceKernelThreadEventHandler, common: ?*anyopaque) SceUID {
    return module.sceKernelRegisterThreadEventHandler(name, threadID, mask, handler, common);
}

/// Release a thread event handler.
/// `uid` - The UID of the event handler
/// Returns 0 on success, < 0 on error
pub fn sceKernelReleaseThreadEventHandler(uid: SceUID) c_int {
    return module.sceKernelReleaseThreadEventHandler(uid);
}

/// Refer the status of an thread event handler
/// `uid` - The UID of the event handler
/// `info` - Pointer to a ::SceKernelThreadEventHandlerInfo structure
/// Returns 0 on success, < 0 on error
pub fn sceKernelReferThreadEventHandlerStatus(uid: SceUID, info: [*c]SceKernelThreadEventHandlerInfo) c_int {
    return module.sceKernelReferThreadEventHandlerStatus(uid, info);
}

/// Create callback
/// @par Example:
/// `
/// int cbid;
/// cbid = sceKernelCreateCallback("Exit Callback", exit_cb, NULL);
/// `
/// `name` - A textual name for the callback
/// `func` - A pointer to a function that will be called as the callback
/// `arg` - Argument for the callback ?
/// Returns >= 0 A callback id which can be used in subsequent functions, < 0 an error.
pub fn sceKernelCreateCallback(name: [:0]const u8, func: SceKernelCallbackFunction, arg: ?*anyopaque) c_int {
    return module.sceKernelCreateCallback(@ptrCast(name), func, arg);
}

/// Delete a callback
/// `cb` - The UID of the specified callback
/// Returns 0 on success, < 0 on error
pub fn sceKernelDeleteCallback(cb: SceUID) c_int {
    return module.sceKernelDeleteCallback(cb);
}

/// Notify a callback
/// `cb` - The UID of the specified callback
/// `arg2` - Passed as arg2 into the callback function
/// Returns 0 on success, < 0 on error
pub fn sceKernelNotifyCallback(cb: SceUID, arg2: c_int) c_int {
    return module.sceKernelNotifyCallback(cb, arg2);
}

/// Cancel a callback ?
/// `cb` - The UID of the specified callback
/// Returns 0 on succes, < 0 on error
pub fn sceKernelCancelCallback(cb: SceUID) c_int {
    return module.sceKernelCancelCallback(cb);
}

/// Get the callback count
/// `cb` - The UID of the specified callback
/// Returns The callback count, < 0 on error
pub fn sceKernelGetCallbackCount(cb: SceUID) c_int {
    return module.sceKernelGetCallbackCount(cb);
}

/// Check callback ?
/// Returns Something or another
pub fn sceKernelCheckCallback() c_int {
    return module.sceKernelCheckCallback();
}

/// Gets the status of a specified callback.
/// `cb` - The UID of the callback to refer.
/// `status` - Pointer to a status structure. The size parameter should be
/// initialised before calling.
/// Returns < 0 on error.
pub fn sceKernelReferCallbackStatus(cb: SceUID, status: [*c]SceKernelCallbackInfo) c_int {
    return module.sceKernelReferCallbackStatus(cb, status);
}

/// Sleep thread
/// Returns < 0 on error.
pub fn sceKernelSleepThread() c_int {
    return module.sceKernelSleepThread();
}

/// Sleep thread but service any callbacks as necessary
/// @par Example:
/// `
/// // Once all callbacks have been setup call this function
/// sceKernelSleepThreadCB();
/// `
pub fn sceKernelSleepThreadCB() c_int {
    return module.sceKernelSleepThreadCB();
}

/// Wake a thread previously put into the sleep state.
/// `thid` - UID of the thread to wake.
/// Returns Success if >= 0, an error if < 0.
pub fn sceKernelWakeupThread(thid: SceUID) c_int {
    return module.sceKernelWakeupThread(thid);
}

/// Cancel a thread that was to be woken with ::sceKernelWakeupThread.
/// `thid` - UID of the thread to cancel.
/// Returns Success if >= 0, an error if < 0.
pub fn sceKernelCancelWakeupThread(thid: SceUID) c_int {
    return module.sceKernelCancelWakeupThread(thid);
}

/// Suspend a thread.
/// `thid` - UID of the thread to suspend.
/// Returns Success if >= 0, an error if < 0.
pub fn sceKernelSuspendThread(thid: SceUID) c_int {
    return module.sceKernelSuspendThread(thid);
}

/// Resume a thread previously put into a suspended state with ::sceKernelSuspendThread.
/// `thid` - UID of the thread to resume.
/// Returns Success if >= 0, an error if < 0.
pub fn sceKernelResumeThread(thid: SceUID) c_int {
    return module.sceKernelResumeThread(thid);
}

/// Wait until a thread has ended.
/// `thid` - Id of the thread to wait for.
/// `timeout` - Timeout in microseconds (assumed).
/// Returns < 0 on error.
pub fn sceKernelWaitThreadEnd(thid: SceUID, timeout: [*c]SceUInt) c_int {
    return module.sceKernelWaitThreadEnd(thid, timeout);
}

/// Wait until a thread has ended and handle callbacks if necessary.
/// `thid` - Id of the thread to wait for.
/// `timeout` - Timeout in microseconds (assumed).
/// Returns < 0 on error.
pub fn sceKernelWaitThreadEndCB(thid: SceUID, timeout: [*c]SceUInt) c_int {
    return module.sceKernelWaitThreadEndCB(thid, timeout);
}

/// Delay the current thread by a specified number of microseconds
/// `delay` - Delay in microseconds.
/// @par Example:
/// `
/// sceKernelDelayThread(1000000); // Delay for a second
/// `
pub fn sceKernelDelayThread(delay_us: SceUInt) c_int {
    return module.sceKernelDelayThread(delay_us);
}

/// Delay the current thread by a specified number of microseconds and handle any callbacks.
/// `delay` - Delay in microseconds.
/// @par Example:
/// `
/// sceKernelDelayThread(1000000); // Delay for a second
/// `
pub fn sceKernelDelayThreadCB(delay_us: SceUInt) c_int {
    return module.sceKernelDelayThreadCB(delay_us);
}

/// Delay the current thread by a specified number of sysclocks
/// `delay` - Delay in sysclocks
/// Returns 0 on success, < 0 on error
pub fn sceKernelDelaySysClockThread(delay_sysclocks: *SceKernelSysClock) c_int {
    return module.sceKernelDelaySysClockThread(delay_sysclocks);
}

/// Delay the current thread by a specified number of sysclocks handling callbacks
/// `delay` - Delay in sysclocks
/// Returns 0 on success, < 0 on error
pub fn sceKernelDelaySysClockThreadCB(delay_sysclocks: *SceKernelSysClock) c_int {
    return module.sceKernelDelaySysClockThreadCB(delay_sysclocks);
}

/// Creates a new semaphore
/// @par Example:
/// `
/// int semaid;
/// semaid = sceKernelCreateSema("MyMutex", 0, 1, 1, 0);
/// `
/// `name` - Specifies the name of the sema
/// `attr` - Sema attribute flags (normally set to 0)
/// `initVal` - Sema initial value
/// `maxVal` - Sema maximum value
/// `option` - Sema options (normally set to 0)
/// Returns A semaphore id
pub fn sceKernelCreateSema(name: [*c]const c_char, attr: SceUInt, initVal: c_int, maxVal: c_int, option: [*c]SceKernelSemaOptParam) SceUID {
    return module.sceKernelCreateSema(name, attr, initVal, maxVal, option);
}

/// Destroy a semaphore
/// `semaid` - The semaid returned from a previous create call.
/// Returns Returns the value 0 if its succesful otherwise -1
pub fn sceKernelDeleteSema(semaid: SceUID) c_int {
    return module.sceKernelDeleteSema(semaid);
}

/// Send a signal to a semaphore
/// @par Example:
/// `
/// // Signal the sema
/// sceKernelSignalSema(semaid, 1);
/// `
/// `semaid` - The sema id returned from sceKernelCreateSema
/// `signal` - The amount to signal the sema (i.e. if 2 then increment the sema by 2)
/// Returns < 0 On error.
pub fn sceKernelSignalSema(semaid: SceUID, signal: c_int) c_int {
    return module.sceKernelSignalSema(semaid, signal);
}

/// Lock a semaphore
/// @par Example:
/// `
/// sceKernelWaitSema(semaid, 1, 0);
/// `
/// `semaid` - The sema id returned from sceKernelCreateSema
/// `signal` - The value to wait for (i.e. if 1 then wait till reaches a signal state of 1)
/// `timeout` - Timeout in microseconds (assumed).
/// Returns < 0 on error.
pub fn sceKernelWaitSema(semaid: SceUID, signal: c_int, timeout: [*c]SceUInt) c_int {
    return module.sceKernelWaitSema(semaid, signal, timeout);
}

/// Lock a semaphore a handle callbacks if necessary.
/// @par Example:
/// `
/// sceKernelWaitSemaCB(semaid, 1, 0);
/// `
/// `semaid` - The sema id returned from sceKernelCreateSema
/// `signal` - The value to wait for (i.e. if 1 then wait till reaches a signal state of 1)
/// `timeout` - Timeout in microseconds (assumed).
/// Returns < 0 on error.
pub fn sceKernelWaitSemaCB(semaid: SceUID, signal: c_int, timeout: [*c]SceUInt) c_int {
    return module.sceKernelWaitSemaCB(semaid, signal, timeout);
}

/// Poll a sempahore.
/// `semaid` - UID of the semaphore to poll.
/// `signal` - The value to test for.
/// Returns < 0 on error.
pub fn sceKernelPollSema(semaid: SceUID, signal: c_int) c_int {
    return module.sceKernelPollSema(semaid, signal);
}

// NOTE: Probably wrong signature!
pub fn sceKernelCancelSema() void {
    return module.sceKernelCancelSema();
}

/// Retrieve information about a semaphore.
/// `semaid` - UID of the semaphore to retrieve info for.
/// `info` - Pointer to a ::SceKernelSemaInfo struct to receive the info.
/// Returns < 0 on error.
pub fn sceKernelReferSemaStatus(semaid: SceUID, info: [*c]SceKernelSemaInfo) c_int {
    return module.sceKernelReferSemaStatus(semaid, info);
}

/// Create an event flag.
/// `name` - The name of the event flag.
/// `attr` - Attributes from ::PspEventFlagAttributes
/// `bits` - Initial bit pattern.
/// `opt` - Options, set to NULL
/// Returns < 0 on error. >= 0 event flag id.
/// @par Example:
/// `
/// int evid;
/// evid = sceKernelCreateEventFlag("wait_event", 0, 0, 0);
/// `
pub fn sceKernelCreateEventFlag(name: [:0]const u8, attr: PspEventFlagAttributes, bits: u32, options: ?*SceKernelEventFlagOptParam) SceUID {
    return module.sceKernelCreateEventFlag(@ptrCast(name), @intFromEnum(attr), @bitCast(bits), options);
}

/// Delete an event flag
/// `evid` - The event id returned by sceKernelCreateEventFlag.
/// Returns < 0 On error
pub fn sceKernelDeleteEventFlag(evid: c_int) c_int {
    return module.sceKernelDeleteEventFlag(evid);
}

/// Set an event flag bit pattern.
/// `evid` - The event id returned by sceKernelCreateEventFlag.
/// `bits` - The bit pattern to set.
/// Returns < 0 On error
pub fn sceKernelSetEventFlag(evid: SceUID, bits: u32) c_int {
    return module.sceKernelSetEventFlag(evid, bits);
}

/// Clear a event flag bit pattern
/// `evid` - The event id returned by ::sceKernelCreateEventFlag
/// `bits` - The bits to clean
/// Returns < 0 on Error
pub fn sceKernelClearEventFlag(evid: SceUID, bits: u32) c_int {
    return module.sceKernelClearEventFlag(evid, bits);
}

/// Wait for an event flag for a given bit pattern.
/// `evid` - The event id returned by sceKernelCreateEventFlag.
/// `bits` - The bit pattern to poll for.
/// `wait` - Wait type, one or more of ::PspEventFlagWaitTypes or'ed together
/// `outBits` - The bit pattern that was matched.
/// `timeout` - Timeout in microseconds
/// Returns < 0 On error
pub fn sceKernelWaitEventFlag(evid: c_int, bits: u32, wait: PspEventFlagWaitTypesMask, outBits: [*c]u32, timeout: [*c]SceUInt) c_int {
    return module.sceKernelWaitEventFlag(evid, bits, @bitCast(wait), outBits, timeout);
}

/// Wait for an event flag for a given bit pattern with callback.
/// `evid` - The event id returned by sceKernelCreateEventFlag.
/// `bits` - The bit pattern to poll for.
/// `wait` - Wait type, one or more of ::PspEventFlagWaitTypes or'ed together
/// `outBits` - The bit pattern that was matched.
/// `timeout` - Timeout in microseconds
/// Returns < 0 On error
pub fn sceKernelWaitEventFlagCB(evid: c_int, bits: u32, wait: PspEventFlagWaitTypesMask, outBits: [*c]u32, timeout: [*c]SceUInt) c_int {
    return module.sceKernelWaitEventFlagCB(evid, bits, @bitCast(wait), outBits, timeout);
}

/// Poll an event flag for a given bit pattern.
/// `evid` - The event id returned by sceKernelCreateEventFlag.
/// `bits` - The bit pattern to poll for.
/// `wait` - Wait type, one or more of ::PspEventFlagWaitTypes or'ed together
/// `outBits` - The bit pattern that was matched.
/// Returns < 0 On error
pub fn sceKernelPollEventFlag(evid: c_int, bits: u32, wait: PspEventFlagWaitTypesMask, outBits: [*c]u32) c_int {
    return module.sceKernelPollEventFlag(evid, bits, @bitCast(wait), outBits);
}

pub fn sceKernelCancelEventFlag() void {
    return module.sceKernelCancelEventFlag();
}

/// Get the status of an event flag.
/// `event` - The UID of the event.
/// `status` - A pointer to a ::SceKernelEventFlagInfo structure.
/// Returns < 0 on error.
pub fn sceKernelReferEventFlagStatus(event: SceUID, status: [*c]SceKernelEventFlagInfo) c_int {
    return module.sceKernelReferEventFlagStatus(event, status);
}

/// Creates a new messagebox
/// @par Example:
/// `
/// int mbxid;
/// mbxid = sceKernelCreateMbx("MyMessagebox", 0, NULL);
/// `
/// `name` - Specifies the name of the mbx
/// `attr` - Mbx attribute flags (normally set to 0)
/// `option` - Mbx options (normally set to NULL)
/// Returns A messagebox id
pub fn sceKernelCreateMbx(name: [*c]const c_char, attr: SceUInt, option: [*c]SceKernelMbxOptParam) SceUID {
    return module.sceKernelCreateMbx(name, attr, option);
}

/// Destroy a messagebox
/// `mbxid` - The mbxid returned from a previous create call.
/// Returns Returns the value 0 if its succesful otherwise an error code
pub fn sceKernelDeleteMbx(mbxid: SceUID) c_int {
    return module.sceKernelDeleteMbx(mbxid);
}

/// Send a message to a messagebox
/// @par Example:
/// `
/// struct MyMessage {
/// SceKernelMsgPacket header;
/// char text[8];
/// };
/// struct MyMessage msg = { {0}, "Hello" };
/// // Send the message
/// sceKernelSendMbx(mbxid, (void*) &msg);
/// `
/// `mbxid` - The mbx id returned from sceKernelCreateMbx
/// `message` - A message to be forwarded to the receiver.
/// The start of the message should be the
/// ::SceKernelMsgPacket structure, the rest
/// Returns < 0 On error.
pub fn sceKernelSendMbx(mbxid: SceUID, message: ?*anyopaque) c_int {
    return module.sceKernelSendMbx(mbxid, message);
}

/// Wait for a message to arrive in a messagebox
/// @par Example:
/// `
/// void *msg;
/// sceKernelReceiveMbx(mbxid, &msg, NULL);
/// `
/// `mbxid` - The mbx id returned from sceKernelCreateMbx
/// `pmessage` - A pointer to where a pointer to the
/// received message should be stored
/// `timeout` - Timeout in microseconds
/// Returns < 0 on error.
pub fn sceKernelReceiveMbx(mbxid: SceUID, pmessage: ?*anyopaque, timeout: [*c]SceUInt) c_int {
    return module.sceKernelReceiveMbx(mbxid, pmessage, timeout);
}

/// Wait for a message to arrive in a messagebox and handle callbacks if necessary.
/// @par Example:
/// `
/// void *msg;
/// sceKernelReceiveMbxCB(mbxid, &msg, NULL);
/// `
/// `mbxid` - The mbx id returned from sceKernelCreateMbx
/// `pmessage` - A pointer to where a pointer to the
/// received message should be stored
/// `timeout` - Timeout in microseconds
/// Returns < 0 on error.
pub fn sceKernelReceiveMbxCB(mbxid: SceUID, pmessage: ?*anyopaque, timeout: [*c]SceUInt) c_int {
    return module.sceKernelReceiveMbxCB(mbxid, pmessage, timeout);
}

/// Check if a message has arrived in a messagebox
/// @par Example:
/// `
/// void *msg;
/// sceKernelPollMbx(mbxid, &msg);
/// `
/// `mbxid` - The mbx id returned from sceKernelCreateMbx
/// `pmessage` - A pointer to where a pointer to the
/// received message should be stored
/// Returns < 0 on error (SCE_KERNEL_ERROR_MBOX_NOMSG if the mbx is empty).
pub fn sceKernelPollMbx(mbxid: SceUID, pmessage: ?*anyopaque) c_int {
    return module.sceKernelPollMbx(mbxid, pmessage);
}

/// Abort all wait operations on a messagebox
/// @par Example:
/// `
/// sceKernelCancelReceiveMbx(mbxid, NULL);
/// `
/// `mbxid` - The mbx id returned from sceKernelCreateMbx
/// `pnum` - A pointer to where the number of threads which
/// were waiting on the mbx should be stored (NULL
/// if you don't care)
/// Returns < 0 on error
pub fn sceKernelCancelReceiveMbx(mbxid: SceUID, pnum: [*c]c_int) c_int {
    return module.sceKernelCancelReceiveMbx(mbxid, pnum);
}

/// Retrieve information about a messagebox.
/// `mbxid` - UID of the messagebox to retrieve info for.
/// `info` - Pointer to a ::SceKernelMbxInfo struct to receive the info.
/// Returns < 0 on error.
pub fn sceKernelReferMbxStatus(mbxid: SceUID, info: [*c]SceKernelMbxInfo) c_int {
    return module.sceKernelReferMbxStatus(mbxid, info);
}

/// Create a message pipe
/// `name` - Name of the pipe
/// `part` - ID of the memory partition
/// `attr` - Set to 0?
/// `unk1` - Unknown
/// `opt` - Message pipe options (set to NULL)
/// Returns The UID of the created pipe, < 0 on error
pub fn sceKernelCreateMsgPipe(name: [*c]const c_char, part: c_int, attr: c_int, unk1: ?*anyopaque, opt: ?*anyopaque) SceUID {
    return module.sceKernelCreateMsgPipe(name, part, attr, unk1, opt);
}

/// Delete a message pipe
/// `uid` - The UID of the pipe
/// Returns 0 on success, < 0 on error
pub fn sceKernelDeleteMsgPipe(uid: SceUID) c_int {
    return module.sceKernelDeleteMsgPipe(uid);
}

/// Send a message to a pipe
/// `uid` - The UID of the pipe
/// `message` - Pointer to the message
/// `size` - Size of the message
/// `unk1` - Unknown
/// `unk2` - Unknown
/// `timeout` - Timeout for send
/// Returns 0 on success, < 0 on error
pub fn sceKernelSendMsgPipe(uid: SceUID, message: ?*anyopaque, size: c_uint, unk1: c_int, unk2: ?*anyopaque, timeout: [*c]c_uint) c_int {
    return module.sceKernelSendMsgPipe(uid, message, size, unk1, unk2, timeout);
}

/// Send a message to a pipe (with callback)
/// `uid` - The UID of the pipe
/// `message` - Pointer to the message
/// `size` - Size of the message
/// `unk1` - Unknown
/// `unk2` - Unknown
/// `timeout` - Timeout for send
/// Returns 0 on success, < 0 on error
pub fn sceKernelSendMsgPipeCB(uid: SceUID, message: ?*anyopaque, size: c_uint, unk1: c_int, unk2: ?*anyopaque, timeout: [*c]c_uint) c_int {
    return module.sceKernelSendMsgPipeCB(uid, message, size, unk1, unk2, timeout);
}

/// Try to send a message to a pipe
/// `uid` - The UID of the pipe
/// `message` - Pointer to the message
/// `size` - Size of the message
/// `unk1` - Unknown
/// `unk2` - Unknown
/// Returns 0 on success, < 0 on error
pub fn sceKernelTrySendMsgPipe(uid: SceUID, message: ?*anyopaque, size: c_uint, unk1: c_int, unk2: ?*anyopaque) c_int {
    return module.sceKernelTrySendMsgPipe(uid, message, size, unk1, unk2);
}

/// Receive a message from a pipe
/// `uid` - The UID of the pipe
/// `message` - Pointer to the message
/// `size` - Size of the message
/// `unk1` - Unknown
/// `unk2` - Unknown
/// `timeout` - Timeout for receive
/// Returns 0 on success, < 0 on error
pub fn sceKernelReceiveMsgPipe(uid: SceUID, message: ?*anyopaque, size: c_uint, unk1: c_int, unk2: ?*anyopaque, timeout: [*c]c_uint) c_int {
    return module.sceKernelReceiveMsgPipe(uid, message, size, unk1, unk2, timeout);
}

/// Receive a message from a pipe (with callback)
/// `uid` - The UID of the pipe
/// `message` - Pointer to the message
/// `size` - Size of the message
/// `unk1` - Unknown
/// `unk2` - Unknown
/// `timeout` - Timeout for receive
/// Returns 0 on success, < 0 on error
pub fn sceKernelReceiveMsgPipeCB(uid: SceUID, message: ?*anyopaque, size: c_uint, unk1: c_int, unk2: ?*anyopaque, timeout: [*c]c_uint) c_int {
    return module.sceKernelReceiveMsgPipeCB(uid, message, size, unk1, unk2, timeout);
}

/// Receive a message from a pipe
/// `uid` - The UID of the pipe
/// `message` - Pointer to the message
/// `size` - Size of the message
/// `unk1` - Unknown
/// `unk2` - Unknown
/// Returns 0 on success, < 0 on error
pub fn sceKernelTryReceiveMsgPipe(uid: SceUID, message: ?*anyopaque, size: c_uint, unk1: c_int, unk2: ?*anyopaque) c_int {
    return module.sceKernelTryReceiveMsgPipe(uid, message, size, unk1, unk2);
}

/// Cancel a message pipe
/// `uid` - UID of the pipe to cancel
/// `psend` - Receive number of sending threads?
/// `precv` - Receive number of receiving threads?
/// Returns 0 on success, < 0 on error
pub fn sceKernelCancelMsgPipe(uid: SceUID, psend: [*c]c_int, precv: [*c]c_int) c_int {
    return module.sceKernelCancelMsgPipe(uid, psend, precv);
}

/// Get the status of a Message Pipe
/// `uid` - The uid of the Message Pipe
/// `info` - Pointer to a ::SceKernelMppInfo structure
/// Returns 0 on success, < 0 on error
pub fn sceKernelReferMsgPipeStatus(uid: SceUID, info: [*c]SceKernelMppInfo) c_int {
    return module.sceKernelReferMsgPipeStatus(uid, info);
}

/// Create a variable pool
/// `name` - Name of the pool
/// `part` - The memory partition ID
/// `attr` - Attributes
/// `size` - Size of pool
/// `opt` - Options (set to NULL)
/// Returns The UID of the created pool, < 0 on error.
pub fn sceKernelCreateVpl(name: [*c]const c_char, part: c_int, attr: c_int, size: c_uint, opt: [*c]SceKernelVplOptParam) SceUID {
    return module.sceKernelCreateVpl(name, part, attr, size, opt);
}

/// Delete a variable pool
/// `uid` - The UID of the pool
/// Returns 0 on success, < 0 on error
pub fn sceKernelDeleteVpl(uid: SceUID) c_int {
    return module.sceKernelDeleteVpl(uid);
}

/// Allocate from the pool
/// `uid` - The UID of the pool
/// `size` - The size to allocate
/// `data` - Receives the address of the allocated data
/// `timeout` - Amount of time to wait for allocation?
/// Returns 0 on success, < 0 on error
pub fn sceKernelAllocateVpl(uid: SceUID, size: c_uint, data: ?*anyopaque, timeout: [*c]c_uint) c_int {
    return module.sceKernelAllocateVpl(uid, size, data, timeout);
}

/// Allocate from the pool (with callback)
/// `uid` - The UID of the pool
/// `size` - The size to allocate
/// `data` - Receives the address of the allocated data
/// `timeout` - Amount of time to wait for allocation?
/// Returns 0 on success, < 0 on error
pub fn sceKernelAllocateVplCB(uid: SceUID, size: c_uint, data: ?*anyopaque, timeout: [*c]c_uint) c_int {
    return module.sceKernelAllocateVplCB(uid, size, data, timeout);
}

/// Try to allocate from the pool
/// `uid` - The UID of the pool
/// `size` - The size to allocate
/// `data` - Receives the address of the allocated data
/// Returns 0 on success, < 0 on error
pub fn sceKernelTryAllocateVpl(uid: SceUID, size: c_uint, data: ?*anyopaque) c_int {
    return module.sceKernelTryAllocateVpl(uid, size, data);
}

/// Free a block
/// `uid` - The UID of the pool
/// `data` - The data block to deallocate
/// Returns 0 on success, < 0 on error
pub fn sceKernelFreeVpl(uid: SceUID, data: ?*anyopaque) c_int {
    return module.sceKernelFreeVpl(uid, data);
}

/// Cancel a pool
/// `uid` - The UID of the pool
/// `pnum` - Receives the number of waiting threads
/// Returns 0 on success, < 0 on error
pub fn sceKernelCancelVpl(uid: SceUID, pnum: [*c]c_int) c_int {
    return module.sceKernelCancelVpl(uid, pnum);
}

/// Get the status of an VPL
/// `uid` - The uid of the VPL
/// `info` - Pointer to a ::SceKernelVplInfo structure
/// Returns 0 on success, < 0 on error
pub fn sceKernelReferVplStatus(uid: SceUID, info: [*c]SceKernelVplInfo) c_int {
    return module.sceKernelReferVplStatus(uid, info);
}

/// Create a fixed pool
/// `name` - Name of the pool
/// `part` - The memory partition ID
/// `attr` - Attributes
/// `size` - Size of pool block
/// `blocks` - Number of blocks to allocate
/// `opt` - Options (set to NULL)
/// Returns The UID of the created pool, < 0 on error.
pub fn sceKernelCreateFpl(name: [*c]const c_char, part: c_int, attr: c_int, size: c_uint, blocks: c_uint, opt: [*c]SceKernelFplOptParam) c_int {
    return module.sceKernelCreateFpl(name, part, attr, size, blocks, opt);
}

/// Delete a fixed pool
/// `uid` - The UID of the pool
/// Returns 0 on success, < 0 on error
pub fn sceKernelDeleteFpl(uid: SceUID) c_int {
    return module.sceKernelDeleteFpl(uid);
}

/// Allocate from the pool
/// `uid` - The UID of the pool
/// `data` - Receives the address of the allocated data
/// `timeout` - Amount of time to wait for allocation?
/// Returns 0 on success, < 0 on error
pub fn sceKernelAllocateFpl(uid: SceUID, data: ?*anyopaque, timeout: [*c]c_uint) c_int {
    return module.sceKernelAllocateFpl(uid, data, timeout);
}

/// Allocate from the pool (with callback)
/// `uid` - The UID of the pool
/// `data` - Receives the address of the allocated data
/// `timeout` - Amount of time to wait for allocation?
/// Returns 0 on success, < 0 on error
pub fn sceKernelAllocateFplCB(uid: SceUID, data: ?*anyopaque, timeout: [*c]c_uint) c_int {
    return module.sceKernelAllocateFplCB(uid, data, timeout);
}

/// Try to allocate from the pool
/// `uid` - The UID of the pool
/// `data` - Receives the address of the allocated data
/// Returns 0 on success, < 0 on error
pub fn sceKernelTryAllocateFpl(uid: SceUID, data: ?*anyopaque) c_int {
    return module.sceKernelTryAllocateFpl(uid, data);
}

/// Free a block
/// `uid` - The UID of the pool
/// `data` - The data block to deallocate
/// Returns 0 on success, < 0 on error
pub fn sceKernelFreeFpl(uid: SceUID, data: ?*anyopaque) c_int {
    return module.sceKernelFreeFpl(uid, data);
}

/// Cancel a pool
/// `uid` - The UID of the pool
/// `pnum` - Receives the number of waiting threads
/// Returns 0 on success, < 0 on error
pub fn sceKernelCancelFpl(uid: SceUID, pnum: [*c]c_int) c_int {
    return module.sceKernelCancelFpl(uid, pnum);
}

/// Get the status of an FPL
/// `uid` - The uid of the FPL
/// `info` - Pointer to a ::SceKernelFplInfo structure
/// Returns 0 on success, < 0 on error
pub fn sceKernelReferFplStatus(uid: SceUID, info: [*c]SceKernelFplInfo) c_int {
    return module.sceKernelReferFplStatus(uid, info);
}

/// Return from a timer handler (doesn't seem to do alot)
pub fn _sceKernelReturnFromTimerHandler() void {
    return module._sceKernelReturnFromTimerHandler();
}

/// Convert a number of microseconds to a ::SceKernelSysClock structure
/// `usec` - Number of microseconds
/// `clock` - Pointer to a ::SceKernelSysClock structure
/// Returns 0 on success, < 0 on error
pub fn sceKernelUSec2SysClock(usec: c_uint, clock: [*c]SceKernelSysClock) c_int {
    return module.sceKernelUSec2SysClock(usec, clock);
}

/// Convert a number of microseconds to a wide time
/// `usec` - Number of microseconds.
/// Returns The time
pub fn sceKernelUSec2SysClockWide(usec: c_uint) SceInt64 {
    return module.sceKernelUSec2SysClockWide(usec);
}

/// Convert a ::SceKernelSysClock structure to microseconds
/// `clock` - Pointer to a ::SceKernelSysClock structure
/// `low` - Pointer to the low part of the time
/// `high` - Pointer to the high part of the time
/// Returns 0 on success, < 0 on error
pub fn sceKernelSysClock2USec(clock: [*c]SceKernelSysClock, low: [*c]c_uint, high: [*c]c_uint) c_int {
    return module.sceKernelSysClock2USec(clock, low, high);
}

/// Convert a wide time to microseconds
/// `clock` - Wide time
/// `low` - Pointer to the low part of the time
/// `high` - Pointer to the high part of the time
/// Returns 0 on success, < 0 on error
pub fn sceKernelSysClock2USecWide(clock: SceInt64, low: [*c]c_int, high: [*c]c_uint) c_int {
    return module.sceKernelSysClock2USecWide(clock, low, high);
}

/// Get the system time
/// `time` - Pointer to a ::SceKernelSysClock structure
/// Returns 0 on success, < 0 on error
pub fn sceKernelGetSystemTime(time: *SceKernelSysClock) c_int {
    return module.sceKernelGetSystemTime(time);
}

/// Get the system time (wide version)
/// Returns The system time
pub fn sceKernelGetSystemTimeWide() SceInt64 {
    return module.sceKernelGetSystemTimeWide();
}

/// Get the low 32bits of the current system time
/// Returns The low 32bits of the system time
pub fn sceKernelGetSystemTimeLow() c_uint {
    return module.sceKernelGetSystemTimeLow();
}

/// Set an alarm.
/// `clock` - The number of micro seconds till the alarm occurrs.
/// `handler` - Pointer to a ::SceKernelAlarmHandler
/// `common` - Common pointer for the alarm handler
/// Returns A UID representing the created alarm, < 0 on error.
pub fn sceKernelSetAlarm(clock: SceUInt, handler: SceKernelAlarmHandler, common: ?*anyopaque) SceUID {
    return module.sceKernelSetAlarm(clock, handler, common);
}

/// Set an alarm using a ::SceKernelSysClock structure for the time
/// `clock` - Pointer to a ::SceKernelSysClock structure
/// `handler` - Pointer to a ::SceKernelAlarmHandler
/// `common` - Common pointer for the alarm handler.
/// Returns A UID representing the created alarm, < 0 on error.
pub fn sceKernelSetSysClockAlarm(clock: [*c]SceKernelSysClock, handler: SceKernelAlarmHandler, common: ?*anyopaque) SceUID {
    return module.sceKernelSetSysClockAlarm(clock, handler, common);
}

/// Cancel a pending alarm.
/// `alarmid` - UID of the alarm to cancel.
/// Returns 0 on success, < 0 on error.
pub fn sceKernelCancelAlarm(alarmid: SceUID) c_int {
    return module.sceKernelCancelAlarm(alarmid);
}

/// Refer the status of a created alarm.
/// `alarmid` - UID of the alarm to get the info of
/// `info` - Pointer to a ::SceKernelAlarmInfo structure
/// Returns 0 on success, < 0 on error.
pub fn sceKernelReferAlarmStatus(alarmid: SceUID, info: [*c]SceKernelAlarmInfo) c_int {
    return module.sceKernelReferAlarmStatus(alarmid, info);
}

/// Create a virtual timer
/// `name` - Name for the timer.
/// `opt` - Pointer to an ::SceKernelVTimerOptParam (pass NULL)
/// Returns The VTimer's UID or < 0 on error.
pub fn sceKernelCreateVTimer(name: [*c]const c_char, opt: [*c]SceKernelVTimerOptParam) SceUID {
    return module.sceKernelCreateVTimer(name, opt);
}

/// Delete a virtual timer
/// `uid` - The UID of the timer
/// Returns < 0 on error.
pub fn sceKernelDeleteVTimer(uid: SceUID) c_int {
    return module.sceKernelDeleteVTimer(uid);
}

/// Get the timer base
/// `uid` - UID of the vtimer
/// `base` - Pointer to a ::SceKernelSysClock structure
/// Returns 0 on success, < 0 on error
pub fn sceKernelGetVTimerBase(uid: SceUID, base: [*c]SceKernelSysClock) c_int {
    return module.sceKernelGetVTimerBase(uid, base);
}

/// Get the timer base (wide format)
/// `uid` - UID of the vtimer
/// Returns The 64bit timer base
pub fn sceKernelGetVTimerBaseWide(uid: SceUID) SceInt64 {
    return module.sceKernelGetVTimerBaseWide(uid);
}

/// Get the timer time
/// `uid` - UID of the vtimer
/// `time` - Pointer to a ::SceKernelSysClock structure
/// Returns 0 on success, < 0 on error
pub fn sceKernelGetVTimerTime(uid: SceUID, time: [*c]SceKernelSysClock) c_int {
    return module.sceKernelGetVTimerTime(uid, time);
}

/// Get the timer time (wide format)
/// `uid` - UID of the vtimer
/// Returns The 64bit timer time
pub fn sceKernelGetVTimerTimeWide(uid: SceUID) SceInt64 {
    return module.sceKernelGetVTimerTimeWide(uid);
}

/// Set the timer time
/// `uid` - UID of the vtimer
/// `time` - Pointer to a ::SceKernelSysClock structure
/// Returns 0 on success, < 0 on error
pub fn sceKernelSetVTimerTime(uid: SceUID, time: [*c]SceKernelSysClock) c_int {
    return module.sceKernelSetVTimerTime(uid, time);
}

/// Set the timer time (wide format)
/// `uid` - UID of the vtimer
/// `time` - Pointer to a ::SceKernelSysClock structure
/// Returns Possibly the last time
pub fn sceKernelSetVTimerTimeWide(uid: SceUID, time: SceInt64) SceInt64 {
    return module.sceKernelSetVTimerTimeWide(uid, time);
}

/// Start a virtual timer
/// `uid` - The UID of the timer
/// Returns < 0 on error
pub fn sceKernelStartVTimer(uid: SceUID) c_int {
    return module.sceKernelStartVTimer(uid);
}

/// Stop a virtual timer
/// `uid` - The UID of the timer
/// Returns < 0 on error
pub fn sceKernelStopVTimer(uid: SceUID) c_int {
    return module.sceKernelStopVTimer(uid);
}

/// Set the timer handler
/// `uid` - UID of the vtimer
/// `time` - Time to call the handler?
/// `handler` - The timer handler
/// `common` - Common pointer
/// Returns 0 on success, < 0 on error
pub fn sceKernelSetVTimerHandler(uid: SceUID, time: [*c]SceKernelSysClock, handler: SceKernelVTimerHandler, common: ?*anyopaque) c_int {
    return module.sceKernelSetVTimerHandler(uid, time, handler, common);
}

/// Set the timer handler (wide mode)
/// `uid` - UID of the vtimer
/// `time` - Time to call the handler?
/// `handler` - The timer handler
/// `common` - Common pointer
/// Returns 0 on success, < 0 on error
pub fn sceKernelSetVTimerHandlerWide(uid: SceUID, time: SceInt64, handler: SceKernelVTimerHandlerWide, common: ?*anyopaque) c_int {
    return module.sceKernelSetVTimerHandlerWide(uid, time, handler, common);
}

/// Cancel the timer handler
/// `uid` - The UID of the vtimer
/// Returns 0 on success, < 0 on error
pub fn sceKernelCancelVTimerHandler(uid: SceUID) c_int {
    return module.sceKernelCancelVTimerHandler(uid);
}

/// Get the status of a VTimer
/// `uid` - The uid of the VTimer
/// `info` - Pointer to a ::SceKernelVTimerInfo structure
/// Returns 0 on success, < 0 on error
pub fn sceKernelReferVTimerStatus(uid: SceUID, info: [*c]SceKernelVTimerInfo) c_int {
    return module.sceKernelReferVTimerStatus(uid, info);
}

pub fn sceKernelCreateThread(name: [:0]const u8, entry: SceKernelThreadEntry, initPriority: c_int, stackSize: c_int, attr: PspThreadAttributesMask, option: ?*SceKernelThreadOptParam) SceUID {
    return module.sceKernelCreateThread(@ptrCast(name), entry, initPriority, stackSize, @bitCast(attr), option);
}

/// Delate a thread
/// `thid` - UID of the thread to be deleted.
/// Returns < 0 on error.
pub fn sceKernelDeleteThread(thid: SceUID) c_int {
    return module.sceKernelDeleteThread(thid);
}

/// Start a created thread
/// `thid` - Thread id from sceKernelCreateThread
/// `arglen` - Length of the data pointed to by argp, in bytes
/// `argp` - Pointer to the arguments.
pub fn sceKernelStartThread(thid: SceUID, arglen: SceSize, argp: ?*anyopaque) c_int {
    return module.sceKernelStartThread(thid, arglen, argp);
}

/// Exit the thread (probably used as the syscall when the main thread
/// returns
pub fn _sceKernelExitThread() void {
    return module._sceKernelExitThread();
}

/// Exit a thread
/// `status` - Exit status.
pub fn sceKernelExitThread(status: c_int) c_int {
    return module.sceKernelExitThread(status);
}

/// Exit a thread and delete itself.
/// `status` - Exit status
pub fn sceKernelExitDeleteThread(status: c_int) c_int {
    return module.sceKernelExitDeleteThread(status);
}

/// Terminate a thread.
/// `thid` - UID of the thread to terminate.
/// Returns Success if >= 0, an error if < 0.
pub fn sceKernelTerminateThread(thid: SceUID) c_int {
    return module.sceKernelTerminateThread(thid);
}

/// Terminate and delete a thread.
/// `thid` - UID of the thread to terminate and delete.
/// Returns Success if >= 0, an error if < 0.
pub fn sceKernelTerminateDeleteThread(thid: SceUID) c_int {
    return module.sceKernelTerminateDeleteThread(thid);
}

/// Suspend the dispatch thread
/// Returns The current state of the dispatch thread, < 0 on error
pub fn sceKernelSuspendDispatchThread() c_int {
    return module.sceKernelSuspendDispatchThread();
}

/// Resume the dispatch thread
/// `state` - The state of the dispatch thread
/// (from ::sceKernelSuspendDispatchThread)
/// Returns 0 on success, < 0 on error
pub fn sceKernelResumeDispatchThread(state: c_int) c_int {
    return module.sceKernelResumeDispatchThread(state);
}

/// Modify the attributes of the current thread.
/// `unknown` - Set to 0.
/// `attr` - The thread attributes to modify.  One of ::PspThreadAttributes.
/// Returns < 0 on error.
pub fn sceKernelChangeCurrentThreadAttr(unknown: c_int, attr: PspThreadAttributesMask) c_int {
    return module.sceKernelChangeCurrentThreadAttr(unknown, @bitCast(attr));
}

/// Change the threads current priority.
/// `thid` - The ID of the thread (from sceKernelCreateThread or sceKernelGetThreadId)
/// `priority` - The new priority (the lower the number the higher the priority)
/// @par Example:
/// `
/// int thid = sceKernelGetThreadId();
/// // Change priority of current thread to 16
/// sceKernelChangeThreadPriority(thid, 16);
/// `
/// Returns 0 if successful, otherwise the error code.
pub fn sceKernelChangeThreadPriority(thid: SceUID, priority: c_int) c_int {
    return module.sceKernelChangeThreadPriority(thid, priority);
}

/// Rotate thread ready queue at a set priority
/// `priority` - The priority of the queue
/// Returns 0 on success, < 0 on error.
pub fn sceKernelRotateThreadReadyQueue(priority: c_int) c_int {
    return module.sceKernelRotateThreadReadyQueue(priority);
}

/// Release a thread in the wait state.
/// `thid` - The UID of the thread.
/// Returns 0 on success, < 0 on error
pub fn sceKernelReleaseWaitThread(thid: SceUID) c_int {
    return module.sceKernelReleaseWaitThread(thid);
}

/// Get the current thread Id
/// Returns The thread id of the calling thread.
pub fn sceKernelGetThreadId() c_int {
    return module.sceKernelGetThreadId();
}

/// Get the current priority of the thread you are in.
/// Returns The current thread priority
pub fn sceKernelGetThreadCurrentPriority() c_int {
    return module.sceKernelGetThreadCurrentPriority();
}

/// Get the exit status of a thread.
/// `thid` - The UID of the thread to check.
/// Returns The exit status
pub fn sceKernelGetThreadExitStatus(thid: SceUID) c_int {
    return module.sceKernelGetThreadExitStatus(thid);
}

/// Check the thread stack?
/// Returns Unknown.
pub fn sceKernelCheckThreadStack() c_int {
    return module.sceKernelCheckThreadStack();
}

/// Get the free stack size for a thread.
/// `thid` - The thread ID. Seem to take current thread
/// if set to 0.
/// Returns The free size.
pub fn sceKernelGetThreadStackFreeSize(thid: SceUID) c_int {
    return module.sceKernelGetThreadStackFreeSize(thid);
}

/// Get the status information for the specified thread.
/// `thid` - Id of the thread to get status
/// `info` - Pointer to the info structure to receive the data.
/// Note: The structures size field should be set to
/// sizeof(SceKernelThreadInfo) before calling this function.
/// @par Example:
/// `
/// SceKernelThreadInfo status;
/// status.size = sizeof(SceKernelThreadInfo);
/// if(sceKernelReferThreadStatus(thid, &status) == 0)
/// { Do something... }
/// `
/// Returns 0 if successful, otherwise the error code.
pub fn sceKernelReferThreadStatus(thid: SceUID, info: [*c]SceKernelThreadInfo) c_int {
    return module.sceKernelReferThreadStatus(thid, info);
}

/// Retrive the runtime status of a thread.
/// `thid` - UID of the thread to retrive status.
/// `status` - Pointer to a ::SceKernelThreadRunStatus struct to receive the runtime status.
/// Returns 0 if successful, otherwise the error code.
pub fn sceKernelReferThreadRunStatus(thid: SceUID, status: [*c]SceKernelThreadRunStatus) c_int {
    return module.sceKernelReferThreadRunStatus(thid, status);
}

/// Get the current system status.
/// `status` - Pointer to a ::SceKernelSystemStatus structure.
/// Returns < 0 on error.
pub fn sceKernelReferSystemStatus(status: [*c]SceKernelSystemStatus) c_int {
    return module.sceKernelReferSystemStatus(status);
}

/// Get a list of UIDs from threadman. Allows you to enumerate
/// resources such as threads or semaphores.
/// `type` - The type of resource to list, one of ::SceKernelIdListType.
/// `readbuf` - A pointer to a buffer to store the list.
/// `readbufsize` - The size of the buffer in SceUID units.
/// `idcount` - Pointer to an integer in which to return the number of ids in the list.
/// Returns < 0 on error. Either 0 or the same as idcount on success.
pub fn sceKernelGetThreadmanIdList(list_type: SceKernelIdListType, readbuf: [*c]SceUID, readbufsize: c_int, idcount: [*c]c_int) c_int {
    return module.sceKernelGetThreadmanIdList(list_type, readbuf, readbufsize, idcount);
}

/// Get the type of a threadman uid
/// `uid` - The uid to get the type from
/// Returns The type, < 0 on error
pub fn sceKernelGetThreadmanIdType(uid: SceUID) SceKernelIdListType {
    return module.sceKernelGetThreadmanIdType(uid);
}

/// Get the thread profiler registers.
/// Returns Pointer to the registers, NULL on error
pub fn sceKernelReferThreadProfiler() [*c]c_int {
    return module.sceKernelReferThreadProfiler();
}

/// Get the globile profiler registers.
/// Returns Pointer to the registers, NULL on error
pub fn sceKernelReferGlobalProfiler() [*c]c_int {
    return module.sceKernelReferGlobalProfiler();
}

/// Delete a lightweight mutex
/// `workarea` - The pointer to the workarea
/// Returns 0 on success, otherwise one of ::PspKernelErrorCodes
pub fn sceKernelDeleteLwMutex(workarea: [*c]c_int) c_int {
    return module.sceKernelDeleteLwMutex(workarea);
}

/// Create a lightweight mutex
/// `workarea` - The pointer to the workarea
/// `name` - The name of the lightweight mutex
/// `attr` - The LwMutex attributes, zero or more of ::PspLwMutexAttributes.
/// `initialCount` - THe inital value of the mutex
/// `optionsPtr` - Other options for mutex
/// Returns 0 on success, otherwise one of ::PspKernelErrorCodes
pub fn sceKernelCreateLwMutex(workarea: [*c]c_int, name: [*c]const c_char, attr: SceUInt32, initialCount: c_int, optionsPtr: [*c]u32) c_int {
    return module.sceKernelCreateLwMutex(workarea, name, attr, initialCount, optionsPtr);
}
