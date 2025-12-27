// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Return from a callback (used as a syscall for the return
/// of the callback function)
pub extern fn _sceKernelReturnFromCallback() callconv(.C) void;

/// Register a thread event handler
/// `name` - Name for the thread event handler
/// `threadID` - Thread ID to monitor
/// `mask` - Bit mask for what events to handle (only lowest 4 bits valid)
/// `handler` - Pointer to a ::SceKernelThreadEventHandler function
/// `common` - Common pointer
/// Returns The UID of the create event handler, < 0 on error
pub extern fn sceKernelRegisterThreadEventHandler(name: [*c]const c_char, threadID: types.SceUID, mask: c_int, handler: types.SceKernelThreadEventHandler, common: ?*anyopaque) callconv(.C) types.SceUID;

/// Release a thread event handler.
/// `uid` - The UID of the event handler
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelReleaseThreadEventHandler(uid: types.SceUID) callconv(.C) c_int;

/// Refer the status of an thread event handler
/// `uid` - The UID of the event handler
/// `info` - Pointer to a ::SceKernelThreadEventHandlerInfo structure
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelReferThreadEventHandlerStatus(uid: types.SceUID, info: [*c]types.SceKernelThreadEventHandlerInfo) callconv(.C) c_int;

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
pub extern fn sceKernelCreateCallback(name: [*c]const c_char, func: types.SceKernelCallbackFunction, arg: ?*anyopaque) callconv(.C) c_int;

/// Delete a callback
/// `cb` - The UID of the specified callback
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelDeleteCallback(cb: types.SceUID) callconv(.C) c_int;

/// Notify a callback
/// `cb` - The UID of the specified callback
/// `arg2` - Passed as arg2 into the callback function
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelNotifyCallback(cb: types.SceUID, arg2: c_int) callconv(.C) c_int;

/// Cancel a callback ?
/// `cb` - The UID of the specified callback
/// Returns 0 on succes, < 0 on error
pub extern fn sceKernelCancelCallback(cb: types.SceUID) callconv(.C) c_int;

/// Get the callback count
/// `cb` - The UID of the specified callback
/// Returns The callback count, < 0 on error
pub extern fn sceKernelGetCallbackCount(cb: types.SceUID) callconv(.C) c_int;

/// Check callback ?
/// Returns Something or another
pub extern fn sceKernelCheckCallback() callconv(.C) c_int;

/// Gets the status of a specified callback.
/// `cb` - The UID of the callback to refer.
/// `status` - Pointer to a status structure. The size parameter should be
/// initialised before calling.
/// Returns < 0 on error.
pub extern fn sceKernelReferCallbackStatus(cb: types.SceUID, status: [*c]types.SceKernelCallbackInfo) callconv(.C) c_int;

/// Sleep thread
/// Returns < 0 on error.
pub extern fn sceKernelSleepThread() callconv(.C) c_int;

/// Sleep thread but service any callbacks as necessary
/// @par Example:
/// `
/// // Once all callbacks have been setup call this function
/// sceKernelSleepThreadCB();
/// `
pub extern fn sceKernelSleepThreadCB() callconv(.C) c_int;

/// Wake a thread previously put into the sleep state.
/// `thid` - UID of the thread to wake.
/// Returns Success if >= 0, an error if < 0.
pub extern fn sceKernelWakeupThread(thid: types.SceUID) callconv(.C) c_int;

/// Cancel a thread that was to be woken with ::sceKernelWakeupThread.
/// `thid` - UID of the thread to cancel.
/// Returns Success if >= 0, an error if < 0.
pub extern fn sceKernelCancelWakeupThread(thid: types.SceUID) callconv(.C) c_int;

/// Suspend a thread.
/// `thid` - UID of the thread to suspend.
/// Returns Success if >= 0, an error if < 0.
pub extern fn sceKernelSuspendThread(thid: types.SceUID) callconv(.C) c_int;

/// Resume a thread previously put into a suspended state with ::sceKernelSuspendThread.
/// `thid` - UID of the thread to resume.
/// Returns Success if >= 0, an error if < 0.
pub extern fn sceKernelResumeThread(thid: types.SceUID) callconv(.C) c_int;

/// Wait until a thread has ended.
/// `thid` - Id of the thread to wait for.
/// `timeout` - Timeout in microseconds (assumed).
/// Returns < 0 on error.
pub extern fn sceKernelWaitThreadEnd(thid: types.SceUID, timeout: [*c]types.SceUInt) callconv(.C) c_int;

/// Wait until a thread has ended and handle callbacks if necessary.
/// `thid` - Id of the thread to wait for.
/// `timeout` - Timeout in microseconds (assumed).
/// Returns < 0 on error.
pub extern fn sceKernelWaitThreadEndCB(thid: types.SceUID, timeout: [*c]types.SceUInt) callconv(.C) c_int;

/// Delay the current thread by a specified number of microseconds
/// `delay` - Delay in microseconds.
/// @par Example:
/// `
/// sceKernelDelayThread(1000000); // Delay for a second
/// `
pub extern fn sceKernelDelayThread(delay: types.SceUInt) callconv(.C) c_int;

/// Delay the current thread by a specified number of microseconds and handle any callbacks.
/// `delay` - Delay in microseconds.
/// @par Example:
/// `
/// sceKernelDelayThread(1000000); // Delay for a second
/// `
pub extern fn sceKernelDelayThreadCB(delay: types.SceUInt) callconv(.C) c_int;

/// Delay the current thread by a specified number of sysclocks
/// `delay` - Delay in sysclocks
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelDelaySysClockThread(delay: [*c]types.SceKernelSysClock) callconv(.C) c_int;

/// Delay the current thread by a specified number of sysclocks handling callbacks
/// `delay` - Delay in sysclocks
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelDelaySysClockThreadCB(delay: [*c]types.SceKernelSysClock) callconv(.C) c_int;

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
pub extern fn sceKernelCreateSema(name: [*c]const c_char, attr: types.SceUInt, initVal: c_int, maxVal: c_int, option: [*c]types.SceKernelSemaOptParam) callconv(.C) types.SceUID;

/// Destroy a semaphore
/// `semaid` - The semaid returned from a previous create call.
/// Returns Returns the value 0 if its succesful otherwise -1
pub extern fn sceKernelDeleteSema(semaid: types.SceUID) callconv(.C) c_int;

/// Send a signal to a semaphore
/// @par Example:
/// `
/// // Signal the sema
/// sceKernelSignalSema(semaid, 1);
/// `
/// `semaid` - The sema id returned from sceKernelCreateSema
/// `signal` - The amount to signal the sema (i.e. if 2 then increment the sema by 2)
/// Returns < 0 On error.
pub extern fn sceKernelSignalSema(semaid: types.SceUID, signal: c_int) callconv(.C) c_int;

/// Lock a semaphore
/// @par Example:
/// `
/// sceKernelWaitSema(semaid, 1, 0);
/// `
/// `semaid` - The sema id returned from sceKernelCreateSema
/// `signal` - The value to wait for (i.e. if 1 then wait till reaches a signal state of 1)
/// `timeout` - Timeout in microseconds (assumed).
/// Returns < 0 on error.
pub extern fn sceKernelWaitSema(semaid: types.SceUID, signal: c_int, timeout: [*c]types.SceUInt) callconv(.C) c_int;

/// Lock a semaphore a handle callbacks if necessary.
/// @par Example:
/// `
/// sceKernelWaitSemaCB(semaid, 1, 0);
/// `
/// `semaid` - The sema id returned from sceKernelCreateSema
/// `signal` - The value to wait for (i.e. if 1 then wait till reaches a signal state of 1)
/// `timeout` - Timeout in microseconds (assumed).
/// Returns < 0 on error.
pub extern fn sceKernelWaitSemaCB(semaid: types.SceUID, signal: c_int, timeout: [*c]types.SceUInt) callconv(.C) c_int;

/// Poll a sempahore.
/// `semaid` - UID of the semaphore to poll.
/// `signal` - The value to test for.
/// Returns < 0 on error.
pub extern fn sceKernelPollSema(semaid: types.SceUID, signal: c_int) callconv(.C) c_int;

pub extern fn sceKernelCancelSema() callconv(.C) void;

/// Retrieve information about a semaphore.
/// `semaid` - UID of the semaphore to retrieve info for.
/// `info` - Pointer to a ::SceKernelSemaInfo struct to receive the info.
/// Returns < 0 on error.
pub extern fn sceKernelReferSemaStatus(semaid: types.SceUID, info: [*c]types.SceKernelSemaInfo) callconv(.C) c_int;

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
pub extern fn sceKernelCreateEventFlag(name: [*c]const c_char, attr: c_int, bits: c_int, opt: [*c]types.SceKernelEventFlagOptParam) callconv(.C) types.SceUID;

/// Delete an event flag
/// `evid` - The event id returned by sceKernelCreateEventFlag.
/// Returns < 0 On error
pub extern fn sceKernelDeleteEventFlag(evid: c_int) callconv(.C) c_int;

/// Set an event flag bit pattern.
/// `evid` - The event id returned by sceKernelCreateEventFlag.
/// `bits` - The bit pattern to set.
/// Returns < 0 On error
pub extern fn sceKernelSetEventFlag(evid: types.SceUID, bits: u32) callconv(.C) c_int;

/// Clear a event flag bit pattern
/// `evid` - The event id returned by ::sceKernelCreateEventFlag
/// `bits` - The bits to clean
/// Returns < 0 on Error
pub extern fn sceKernelClearEventFlag(evid: types.SceUID, bits: u32) callconv(.C) c_int;

/// Wait for an event flag for a given bit pattern.
/// `evid` - The event id returned by sceKernelCreateEventFlag.
/// `bits` - The bit pattern to poll for.
/// `wait` - Wait type, one or more of ::PspEventFlagWaitTypes or'ed together
/// `outBits` - The bit pattern that was matched.
/// `timeout` - Timeout in microseconds
/// Returns < 0 On error
pub extern fn sceKernelWaitEventFlag(evid: c_int, bits: u32, wait: u32, outBits: [*c]u32, timeout: [*c]types.SceUInt) callconv(.C) c_int;

/// Wait for an event flag for a given bit pattern with callback.
/// `evid` - The event id returned by sceKernelCreateEventFlag.
/// `bits` - The bit pattern to poll for.
/// `wait` - Wait type, one or more of ::PspEventFlagWaitTypes or'ed together
/// `outBits` - The bit pattern that was matched.
/// `timeout` - Timeout in microseconds
/// Returns < 0 On error
pub extern fn sceKernelWaitEventFlagCB(evid: c_int, bits: u32, wait: u32, outBits: [*c]u32, timeout: [*c]types.SceUInt) callconv(.C) c_int;

/// Poll an event flag for a given bit pattern.
/// `evid` - The event id returned by sceKernelCreateEventFlag.
/// `bits` - The bit pattern to poll for.
/// `wait` - Wait type, one or more of ::PspEventFlagWaitTypes or'ed together
/// `outBits` - The bit pattern that was matched.
/// Returns < 0 On error
pub extern fn sceKernelPollEventFlag(evid: c_int, bits: u32, wait: u32, outBits: [*c]u32) callconv(.C) c_int;

pub extern fn sceKernelCancelEventFlag() callconv(.C) void;

/// Get the status of an event flag.
/// `event` - The UID of the event.
/// `status` - A pointer to a ::SceKernelEventFlagInfo structure.
/// Returns < 0 on error.
pub extern fn sceKernelReferEventFlagStatus(event: types.SceUID, status: [*c]types.SceKernelEventFlagInfo) callconv(.C) c_int;

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
pub extern fn sceKernelCreateMbx(name: [*c]const c_char, attr: types.SceUInt, option: [*c]types.SceKernelMbxOptParam) callconv(.C) types.SceUID;

/// Destroy a messagebox
/// `mbxid` - The mbxid returned from a previous create call.
/// Returns Returns the value 0 if its succesful otherwise an error code
pub extern fn sceKernelDeleteMbx(mbxid: types.SceUID) callconv(.C) c_int;

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
pub extern fn sceKernelSendMbx(mbxid: types.SceUID, message: ?*anyopaque) callconv(.C) c_int;

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
pub extern fn sceKernelReceiveMbx(mbxid: types.SceUID, pmessage: ?*anyopaque, timeout: [*c]types.SceUInt) callconv(.C) c_int;

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
pub extern fn sceKernelReceiveMbxCB(mbxid: types.SceUID, pmessage: ?*anyopaque, timeout: [*c]types.SceUInt) callconv(.C) c_int;

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
pub extern fn sceKernelPollMbx(mbxid: types.SceUID, pmessage: ?*anyopaque) callconv(.C) c_int;

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
pub extern fn sceKernelCancelReceiveMbx(mbxid: types.SceUID, pnum: [*c]c_int) callconv(.C) c_int;

/// Retrieve information about a messagebox.
/// `mbxid` - UID of the messagebox to retrieve info for.
/// `info` - Pointer to a ::SceKernelMbxInfo struct to receive the info.
/// Returns < 0 on error.
pub extern fn sceKernelReferMbxStatus(mbxid: types.SceUID, info: [*c]types.SceKernelMbxInfo) callconv(.C) c_int;

/// Create a message pipe
/// `name` - Name of the pipe
/// `part` - ID of the memory partition
/// `attr` - Set to 0?
/// `unk1` - Unknown
/// `opt` - Message pipe options (set to NULL)
/// Returns The UID of the created pipe, < 0 on error
pub extern fn sceKernelCreateMsgPipe(name: [*c]const c_char, part: c_int, attr: c_int, unk1: ?*anyopaque, opt: ?*anyopaque) callconv(.C) types.SceUID;

/// Delete a message pipe
/// `uid` - The UID of the pipe
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelDeleteMsgPipe(uid: types.SceUID) callconv(.C) c_int;

/// Send a message to a pipe
/// `uid` - The UID of the pipe
/// `message` - Pointer to the message
/// `size` - Size of the message
/// `unk1` - Unknown
/// `unk2` - Unknown
/// `timeout` - Timeout for send
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelSendMsgPipe(uid: types.SceUID, message: ?*anyopaque, size: c_uint, unk1: c_int, unk2: ?*anyopaque, timeout: [*c]c_uint) callconv(.C) c_int;

/// Send a message to a pipe (with callback)
/// `uid` - The UID of the pipe
/// `message` - Pointer to the message
/// `size` - Size of the message
/// `unk1` - Unknown
/// `unk2` - Unknown
/// `timeout` - Timeout for send
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelSendMsgPipeCB(uid: types.SceUID, message: ?*anyopaque, size: c_uint, unk1: c_int, unk2: ?*anyopaque, timeout: [*c]c_uint) callconv(.C) c_int;

/// Try to send a message to a pipe
/// `uid` - The UID of the pipe
/// `message` - Pointer to the message
/// `size` - Size of the message
/// `unk1` - Unknown
/// `unk2` - Unknown
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelTrySendMsgPipe(uid: types.SceUID, message: ?*anyopaque, size: c_uint, unk1: c_int, unk2: ?*anyopaque) callconv(.C) c_int;

/// Receive a message from a pipe
/// `uid` - The UID of the pipe
/// `message` - Pointer to the message
/// `size` - Size of the message
/// `unk1` - Unknown
/// `unk2` - Unknown
/// `timeout` - Timeout for receive
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelReceiveMsgPipe(uid: types.SceUID, message: ?*anyopaque, size: c_uint, unk1: c_int, unk2: ?*anyopaque, timeout: [*c]c_uint) callconv(.C) c_int;

/// Receive a message from a pipe (with callback)
/// `uid` - The UID of the pipe
/// `message` - Pointer to the message
/// `size` - Size of the message
/// `unk1` - Unknown
/// `unk2` - Unknown
/// `timeout` - Timeout for receive
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelReceiveMsgPipeCB(uid: types.SceUID, message: ?*anyopaque, size: c_uint, unk1: c_int, unk2: ?*anyopaque, timeout: [*c]c_uint) callconv(.C) c_int;

/// Receive a message from a pipe
/// `uid` - The UID of the pipe
/// `message` - Pointer to the message
/// `size` - Size of the message
/// `unk1` - Unknown
/// `unk2` - Unknown
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelTryReceiveMsgPipe(uid: types.SceUID, message: ?*anyopaque, size: c_uint, unk1: c_int, unk2: ?*anyopaque) callconv(.C) c_int;

/// Cancel a message pipe
/// `uid` - UID of the pipe to cancel
/// `psend` - Receive number of sending threads?
/// `precv` - Receive number of receiving threads?
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelCancelMsgPipe(uid: types.SceUID, psend: [*c]c_int, precv: [*c]c_int) callconv(.C) c_int;

/// Get the status of a Message Pipe
/// `uid` - The uid of the Message Pipe
/// `info` - Pointer to a ::SceKernelMppInfo structure
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelReferMsgPipeStatus(uid: types.SceUID, info: [*c]types.SceKernelMppInfo) callconv(.C) c_int;

/// Create a variable pool
/// `name` - Name of the pool
/// `part` - The memory partition ID
/// `attr` - Attributes
/// `size` - Size of pool
/// `opt` - Options (set to NULL)
/// Returns The UID of the created pool, < 0 on error.
pub extern fn sceKernelCreateVpl(name: [*c]const c_char, part: c_int, attr: c_int, size: c_uint, opt: [*c]types.SceKernelVplOptParam) callconv(.C) types.SceUID;

/// Delete a variable pool
/// `uid` - The UID of the pool
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelDeleteVpl(uid: types.SceUID) callconv(.C) c_int;

/// Allocate from the pool
/// `uid` - The UID of the pool
/// `size` - The size to allocate
/// `data` - Receives the address of the allocated data
/// `timeout` - Amount of time to wait for allocation?
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelAllocateVpl(uid: types.SceUID, size: c_uint, data: ?*anyopaque, timeout: [*c]c_uint) callconv(.C) c_int;

/// Allocate from the pool (with callback)
/// `uid` - The UID of the pool
/// `size` - The size to allocate
/// `data` - Receives the address of the allocated data
/// `timeout` - Amount of time to wait for allocation?
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelAllocateVplCB(uid: types.SceUID, size: c_uint, data: ?*anyopaque, timeout: [*c]c_uint) callconv(.C) c_int;

/// Try to allocate from the pool
/// `uid` - The UID of the pool
/// `size` - The size to allocate
/// `data` - Receives the address of the allocated data
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelTryAllocateVpl(uid: types.SceUID, size: c_uint, data: ?*anyopaque) callconv(.C) c_int;

/// Free a block
/// `uid` - The UID of the pool
/// `data` - The data block to deallocate
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelFreeVpl(uid: types.SceUID, data: ?*anyopaque) callconv(.C) c_int;

/// Cancel a pool
/// `uid` - The UID of the pool
/// `pnum` - Receives the number of waiting threads
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelCancelVpl(uid: types.SceUID, pnum: [*c]c_int) callconv(.C) c_int;

/// Get the status of an VPL
/// `uid` - The uid of the VPL
/// `info` - Pointer to a ::SceKernelVplInfo structure
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelReferVplStatus(uid: types.SceUID, info: [*c]types.SceKernelVplInfo) callconv(.C) c_int;

/// Create a fixed pool
/// `name` - Name of the pool
/// `part` - The memory partition ID
/// `attr` - Attributes
/// `size` - Size of pool block
/// `blocks` - Number of blocks to allocate
/// `opt` - Options (set to NULL)
/// Returns The UID of the created pool, < 0 on error.
pub extern fn sceKernelCreateFpl(name: [*c]const c_char, part: c_int, attr: c_int, size: c_uint, blocks: c_uint, opt: [*c]types.SceKernelFplOptParam) callconv(.C) c_int;

/// Delete a fixed pool
/// `uid` - The UID of the pool
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelDeleteFpl(uid: types.SceUID) callconv(.C) c_int;

/// Allocate from the pool
/// `uid` - The UID of the pool
/// `data` - Receives the address of the allocated data
/// `timeout` - Amount of time to wait for allocation?
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelAllocateFpl(uid: types.SceUID, data: ?*anyopaque, timeout: [*c]c_uint) callconv(.C) c_int;

/// Allocate from the pool (with callback)
/// `uid` - The UID of the pool
/// `data` - Receives the address of the allocated data
/// `timeout` - Amount of time to wait for allocation?
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelAllocateFplCB(uid: types.SceUID, data: ?*anyopaque, timeout: [*c]c_uint) callconv(.C) c_int;

/// Try to allocate from the pool
/// `uid` - The UID of the pool
/// `data` - Receives the address of the allocated data
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelTryAllocateFpl(uid: types.SceUID, data: ?*anyopaque) callconv(.C) c_int;

/// Free a block
/// `uid` - The UID of the pool
/// `data` - The data block to deallocate
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelFreeFpl(uid: types.SceUID, data: ?*anyopaque) callconv(.C) c_int;

/// Cancel a pool
/// `uid` - The UID of the pool
/// `pnum` - Receives the number of waiting threads
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelCancelFpl(uid: types.SceUID, pnum: [*c]c_int) callconv(.C) c_int;

/// Get the status of an FPL
/// `uid` - The uid of the FPL
/// `info` - Pointer to a ::SceKernelFplInfo structure
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelReferFplStatus(uid: types.SceUID, info: [*c]types.SceKernelFplInfo) callconv(.C) c_int;

/// Return from a timer handler (doesn't seem to do alot)
pub extern fn _sceKernelReturnFromTimerHandler() callconv(.C) void;

/// Convert a number of microseconds to a ::SceKernelSysClock structure
/// `usec` - Number of microseconds
/// `clock` - Pointer to a ::SceKernelSysClock structure
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelUSec2SysClock(usec: c_uint, clock: [*c]types.SceKernelSysClock) callconv(.C) c_int;

/// Convert a number of microseconds to a wide time
/// `usec` - Number of microseconds.
/// Returns The time
pub extern fn sceKernelUSec2SysClockWide(usec: c_uint) callconv(.C) types.SceInt64;

/// Convert a ::SceKernelSysClock structure to microseconds
/// `clock` - Pointer to a ::SceKernelSysClock structure
/// `low` - Pointer to the low part of the time
/// `high` - Pointer to the high part of the time
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelSysClock2USec(clock: [*c]types.SceKernelSysClock, low: [*c]c_uint, high: [*c]c_uint) callconv(.C) c_int;

/// Convert a wide time to microseconds
/// `clock` - Wide time
/// `low` - Pointer to the low part of the time
/// `high` - Pointer to the high part of the time
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelSysClock2USecWide(clock: types.SceInt64, low: [*c]c_int, high: [*c]c_uint) callconv(.C) c_int;

/// Get the system time
/// `time` - Pointer to a ::SceKernelSysClock structure
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelGetSystemTime(time: [*c]types.SceKernelSysClock) callconv(.C) c_int;

/// Get the system time (wide version)
/// Returns The system time
pub extern fn sceKernelGetSystemTimeWide() callconv(.C) types.SceInt64;

/// Get the low 32bits of the current system time
/// Returns The low 32bits of the system time
pub extern fn sceKernelGetSystemTimeLow() callconv(.C) c_uint;

/// Set an alarm.
/// `clock` - The number of micro seconds till the alarm occurrs.
/// `handler` - Pointer to a ::SceKernelAlarmHandler
/// `common` - Common pointer for the alarm handler
/// Returns A UID representing the created alarm, < 0 on error.
pub extern fn sceKernelSetAlarm(clock: types.SceUInt, handler: types.SceKernelAlarmHandler, common: ?*anyopaque) callconv(.C) types.SceUID;

/// Set an alarm using a ::SceKernelSysClock structure for the time
/// `clock` - Pointer to a ::SceKernelSysClock structure
/// `handler` - Pointer to a ::SceKernelAlarmHandler
/// `common` - Common pointer for the alarm handler.
/// Returns A UID representing the created alarm, < 0 on error.
pub extern fn sceKernelSetSysClockAlarm(clock: [*c]types.SceKernelSysClock, handler: types.SceKernelAlarmHandler, common: ?*anyopaque) callconv(.C) types.SceUID;

/// Cancel a pending alarm.
/// `alarmid` - UID of the alarm to cancel.
/// Returns 0 on success, < 0 on error.
pub extern fn sceKernelCancelAlarm(alarmid: types.SceUID) callconv(.C) c_int;

/// Refer the status of a created alarm.
/// `alarmid` - UID of the alarm to get the info of
/// `info` - Pointer to a ::SceKernelAlarmInfo structure
/// Returns 0 on success, < 0 on error.
pub extern fn sceKernelReferAlarmStatus(alarmid: types.SceUID, info: [*c]types.SceKernelAlarmInfo) callconv(.C) c_int;

/// Create a virtual timer
/// `name` - Name for the timer.
/// `opt` - Pointer to an ::SceKernelVTimerOptParam (pass NULL)
/// Returns The VTimer's UID or < 0 on error.
pub extern fn sceKernelCreateVTimer(name: [*c]const c_char, opt: [*c]types.SceKernelVTimerOptParam) callconv(.C) types.SceUID;

/// Delete a virtual timer
/// `uid` - The UID of the timer
/// Returns < 0 on error.
pub extern fn sceKernelDeleteVTimer(uid: types.SceUID) callconv(.C) c_int;

/// Get the timer base
/// `uid` - UID of the vtimer
/// `base` - Pointer to a ::SceKernelSysClock structure
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelGetVTimerBase(uid: types.SceUID, base: [*c]types.SceKernelSysClock) callconv(.C) c_int;

/// Get the timer base (wide format)
/// `uid` - UID of the vtimer
/// Returns The 64bit timer base
pub extern fn sceKernelGetVTimerBaseWide(uid: types.SceUID) callconv(.C) types.SceInt64;

/// Get the timer time
/// `uid` - UID of the vtimer
/// `time` - Pointer to a ::SceKernelSysClock structure
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelGetVTimerTime(uid: types.SceUID, time: [*c]types.SceKernelSysClock) callconv(.C) c_int;

/// Get the timer time (wide format)
/// `uid` - UID of the vtimer
/// Returns The 64bit timer time
pub extern fn sceKernelGetVTimerTimeWide(uid: types.SceUID) callconv(.C) types.SceInt64;

/// Set the timer time
/// `uid` - UID of the vtimer
/// `time` - Pointer to a ::SceKernelSysClock structure
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelSetVTimerTime(uid: types.SceUID, time: [*c]types.SceKernelSysClock) callconv(.C) c_int;

/// Set the timer time (wide format)
/// `uid` - UID of the vtimer
/// `time` - Pointer to a ::SceKernelSysClock structure
/// Returns Possibly the last time
pub extern fn sceKernelSetVTimerTimeWide(uid: types.SceUID, time: types.SceInt64) callconv(.C) types.SceInt64;

/// Start a virtual timer
/// `uid` - The UID of the timer
/// Returns < 0 on error
pub extern fn sceKernelStartVTimer(uid: types.SceUID) callconv(.C) c_int;

/// Stop a virtual timer
/// `uid` - The UID of the timer
/// Returns < 0 on error
pub extern fn sceKernelStopVTimer(uid: types.SceUID) callconv(.C) c_int;

/// Set the timer handler
/// `uid` - UID of the vtimer
/// `time` - Time to call the handler?
/// `handler` - The timer handler
/// `common` - Common pointer
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelSetVTimerHandler(uid: types.SceUID, time: [*c]types.SceKernelSysClock, handler: types.SceKernelVTimerHandler, common: ?*anyopaque) callconv(.C) c_int;

/// Set the timer handler (wide mode)
/// `uid` - UID of the vtimer
/// `time` - Time to call the handler?
/// `handler` - The timer handler
/// `common` - Common pointer
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelSetVTimerHandlerWide(uid: types.SceUID, time: types.SceInt64, handler: types.SceKernelVTimerHandlerWide, common: ?*anyopaque) callconv(.C) c_int;

/// Cancel the timer handler
/// `uid` - The UID of the vtimer
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelCancelVTimerHandler(uid: types.SceUID) callconv(.C) c_int;

/// Get the status of a VTimer
/// `uid` - The uid of the VTimer
/// `info` - Pointer to a ::SceKernelVTimerInfo structure
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelReferVTimerStatus(uid: types.SceUID, info: [*c]types.SceKernelVTimerInfo) callconv(.C) c_int;

pub extern fn sceKernelCreateThread(name: [*c]const c_char, entry: types.SceKernelThreadEntry, initPriority: c_int, stackSize: c_int, attr: types.SceUInt, option: [*c]types.SceKernelThreadOptParam) callconv(.C) types.SceUID;

/// Delate a thread
/// `thid` - UID of the thread to be deleted.
/// Returns < 0 on error.
pub extern fn sceKernelDeleteThread(thid: types.SceUID) callconv(.C) c_int;

/// Start a created thread
/// `thid` - Thread id from sceKernelCreateThread
/// `arglen` - Length of the data pointed to by argp, in bytes
/// `argp` - Pointer to the arguments.
pub extern fn sceKernelStartThread(thid: types.SceUID, arglen: types.SceSize, argp: ?*anyopaque) callconv(.C) c_int;

/// Exit the thread (probably used as the syscall when the main thread
/// returns
pub extern fn _sceKernelExitThread() callconv(.C) void;

/// Exit a thread
/// `status` - Exit status.
pub extern fn sceKernelExitThread(status: c_int) callconv(.C) c_int;

/// Exit a thread and delete itself.
/// `status` - Exit status
pub extern fn sceKernelExitDeleteThread(status: c_int) callconv(.C) c_int;

/// Terminate a thread.
/// `thid` - UID of the thread to terminate.
/// Returns Success if >= 0, an error if < 0.
pub extern fn sceKernelTerminateThread(thid: types.SceUID) callconv(.C) c_int;

/// Terminate and delete a thread.
/// `thid` - UID of the thread to terminate and delete.
/// Returns Success if >= 0, an error if < 0.
pub extern fn sceKernelTerminateDeleteThread(thid: types.SceUID) callconv(.C) c_int;

/// Suspend the dispatch thread
/// Returns The current state of the dispatch thread, < 0 on error
pub extern fn sceKernelSuspendDispatchThread() callconv(.C) c_int;

/// Resume the dispatch thread
/// `state` - The state of the dispatch thread
/// (from ::sceKernelSuspendDispatchThread)
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelResumeDispatchThread(state: c_int) callconv(.C) c_int;

/// Modify the attributes of the current thread.
/// `unknown` - Set to 0.
/// `attr` - The thread attributes to modify.  One of ::PspThreadAttributes.
/// Returns < 0 on error.
pub extern fn sceKernelChangeCurrentThreadAttr(unknown: c_int, attr: types.SceUInt) callconv(.C) c_int;

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
pub extern fn sceKernelChangeThreadPriority(thid: types.SceUID, priority: c_int) callconv(.C) c_int;

/// Rotate thread ready queue at a set priority
/// `priority` - The priority of the queue
/// Returns 0 on success, < 0 on error.
pub extern fn sceKernelRotateThreadReadyQueue(priority: c_int) callconv(.C) c_int;

/// Release a thread in the wait state.
/// `thid` - The UID of the thread.
/// Returns 0 on success, < 0 on error
pub extern fn sceKernelReleaseWaitThread(thid: types.SceUID) callconv(.C) c_int;

/// Get the current thread Id
/// Returns The thread id of the calling thread.
pub extern fn sceKernelGetThreadId() callconv(.C) c_int;

/// Get the current priority of the thread you are in.
/// Returns The current thread priority
pub extern fn sceKernelGetThreadCurrentPriority() callconv(.C) c_int;

/// Get the exit status of a thread.
/// `thid` - The UID of the thread to check.
/// Returns The exit status
pub extern fn sceKernelGetThreadExitStatus(thid: types.SceUID) callconv(.C) c_int;

/// Check the thread stack?
/// Returns Unknown.
pub extern fn sceKernelCheckThreadStack() callconv(.C) c_int;

/// Get the free stack size for a thread.
/// `thid` - The thread ID. Seem to take current thread
/// if set to 0.
/// Returns The free size.
pub extern fn sceKernelGetThreadStackFreeSize(thid: types.SceUID) callconv(.C) c_int;

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
pub extern fn sceKernelReferThreadStatus(thid: types.SceUID, info: [*c]types.SceKernelThreadInfo) callconv(.C) c_int;

/// Retrive the runtime status of a thread.
/// `thid` - UID of the thread to retrive status.
/// `status` - Pointer to a ::SceKernelThreadRunStatus struct to receive the runtime status.
/// Returns 0 if successful, otherwise the error code.
pub extern fn sceKernelReferThreadRunStatus(thid: types.SceUID, status: [*c]types.SceKernelThreadRunStatus) callconv(.C) c_int;

/// Get the current system status.
/// `status` - Pointer to a ::SceKernelSystemStatus structure.
/// Returns < 0 on error.
pub extern fn sceKernelReferSystemStatus(status: [*c]types.SceKernelSystemStatus) callconv(.C) c_int;

/// Get a list of UIDs from threadman. Allows you to enumerate
/// resources such as threads or semaphores.
/// `type` - The type of resource to list, one of ::SceKernelIdListType.
/// `readbuf` - A pointer to a buffer to store the list.
/// `readbufsize` - The size of the buffer in SceUID units.
/// `idcount` - Pointer to an integer in which to return the number of ids in the list.
/// Returns < 0 on error. Either 0 or the same as idcount on success.
pub extern fn sceKernelGetThreadmanIdList(type: types.SceKernelIdListType, readbuf: [*c]types.SceUID, readbufsize: c_int, idcount: [*c]c_int) callconv(.C) c_int;

/// Get the type of a threadman uid
/// `uid` - The uid to get the type from
/// Returns The type, < 0 on error
pub extern fn sceKernelGetThreadmanIdType(uid: types.SceUID) callconv(.C) types.SceKernelIdListType;

/// Get the thread profiler registers.
/// Returns Pointer to the registers, NULL on error
pub extern fn sceKernelReferThreadProfiler() callconv(.C) [*c]c_int;

/// Get the globile profiler registers.
/// Returns Pointer to the registers, NULL on error
pub extern fn sceKernelReferGlobalProfiler() callconv(.C) [*c]c_int;

/// Delete a lightweight mutex
/// `workarea` - The pointer to the workarea
/// Returns 0 on success, otherwise one of ::PspKernelErrorCodes
pub extern fn sceKernelDeleteLwMutex(workarea: [*c]c_int) callconv(.C) c_int;

/// Create a lightweight mutex
/// `workarea` - The pointer to the workarea
/// `name` - The name of the lightweight mutex
/// `attr` - The LwMutex attributes, zero or more of ::PspLwMutexAttributes.
/// `initialCount` - THe inital value of the mutex
/// `optionsPtr` - Other options for mutex
/// Returns 0 on success, otherwise one of ::PspKernelErrorCodes
pub extern fn sceKernelCreateLwMutex(workarea: [*c]c_int, name: [*c]const c_char, attr: types.SceUInt32, initialCount: c_int, optionsPtr: [*c]u32) callconv(.C) c_int;

comptime {
    asm (macro.import_module_start("ThreadManForUser", "0x40010000", "128"));
    asm (macro.import_function("ThreadManForUser", "0x6E9EA350", "_sceKernelReturnFromCallback"));
    asm (macro.import_function("ThreadManForUser", "0x0C106E53", "sceKernelRegisterThreadEventHandler_stub"));
    asm (macro.generic_abi_wrapper("sceKernelRegisterThreadEventHandler", 5));
    asm (macro.import_function("ThreadManForUser", "0x72F3C145", "sceKernelReleaseThreadEventHandler"));
    asm (macro.import_function("ThreadManForUser", "0x369EEB6B", "sceKernelReferThreadEventHandlerStatus"));
    asm (macro.import_function("ThreadManForUser", "0xE81CAF8F", "sceKernelCreateCallback"));
    asm (macro.import_function("ThreadManForUser", "0xEDBA5844", "sceKernelDeleteCallback"));
    asm (macro.import_function("ThreadManForUser", "0xC11BA8C4", "sceKernelNotifyCallback"));
    asm (macro.import_function("ThreadManForUser", "0xBA4051D6", "sceKernelCancelCallback"));
    asm (macro.import_function("ThreadManForUser", "0x2A3D44FF", "sceKernelGetCallbackCount"));
    asm (macro.import_function("ThreadManForUser", "0x349D6D6C", "sceKernelCheckCallback"));
    asm (macro.import_function("ThreadManForUser", "0x730ED8BC", "sceKernelReferCallbackStatus"));
    asm (macro.import_function("ThreadManForUser", "0x9ACE131E", "sceKernelSleepThread"));
    asm (macro.import_function("ThreadManForUser", "0x82826F70", "sceKernelSleepThreadCB"));
    asm (macro.import_function("ThreadManForUser", "0xD59EAD2F", "sceKernelWakeupThread"));
    asm (macro.import_function("ThreadManForUser", "0xFCCFAD26", "sceKernelCancelWakeupThread"));
    asm (macro.import_function("ThreadManForUser", "0x9944F31F", "sceKernelSuspendThread"));
    asm (macro.import_function("ThreadManForUser", "0x75156E8F", "sceKernelResumeThread"));
    asm (macro.import_function("ThreadManForUser", "0x278C0DF5", "sceKernelWaitThreadEnd"));
    asm (macro.import_function("ThreadManForUser", "0x840E8133", "sceKernelWaitThreadEndCB"));
    asm (macro.import_function("ThreadManForUser", "0xCEADEB47", "sceKernelDelayThread"));
    asm (macro.import_function("ThreadManForUser", "0x68DA9E36", "sceKernelDelayThreadCB"));
    asm (macro.import_function("ThreadManForUser", "0xBD123D9E", "sceKernelDelaySysClockThread"));
    asm (macro.import_function("ThreadManForUser", "0x1181E963", "sceKernelDelaySysClockThreadCB"));
    asm (macro.import_function("ThreadManForUser", "0xD6DA4BA1", "sceKernelCreateSema_stub"));
    asm (macro.generic_abi_wrapper("sceKernelCreateSema", 5));
    asm (macro.import_function("ThreadManForUser", "0x28B6489C", "sceKernelDeleteSema"));
    asm (macro.import_function("ThreadManForUser", "0x3F53E640", "sceKernelSignalSema"));
    asm (macro.import_function("ThreadManForUser", "0x4E3A1105", "sceKernelWaitSema"));
    asm (macro.import_function("ThreadManForUser", "0x6D212BAC", "sceKernelWaitSemaCB"));
    asm (macro.import_function("ThreadManForUser", "0x58B1F937", "sceKernelPollSema"));
    asm (macro.import_function("ThreadManForUser", "0x8FFDF9A2", "sceKernelCancelSema"));
    asm (macro.import_function("ThreadManForUser", "0xBC6FEBC5", "sceKernelReferSemaStatus"));
    asm (macro.import_function("ThreadManForUser", "0x55C20A00", "sceKernelCreateEventFlag"));
    asm (macro.import_function("ThreadManForUser", "0xEF9E4C70", "sceKernelDeleteEventFlag"));
    asm (macro.import_function("ThreadManForUser", "0x1FB15A32", "sceKernelSetEventFlag"));
    asm (macro.import_function("ThreadManForUser", "0x812346E4", "sceKernelClearEventFlag"));
    asm (macro.import_function("ThreadManForUser", "0x402FCF22", "sceKernelWaitEventFlag_stub"));
    asm (macro.generic_abi_wrapper("sceKernelWaitEventFlag", 5));
    asm (macro.import_function("ThreadManForUser", "0x328C546A", "sceKernelWaitEventFlagCB_stub"));
    asm (macro.generic_abi_wrapper("sceKernelWaitEventFlagCB", 5));
    asm (macro.import_function("ThreadManForUser", "0x30FD48F0", "sceKernelPollEventFlag"));
    asm (macro.import_function("ThreadManForUser", "0xCD203292", "sceKernelCancelEventFlag"));
    asm (macro.import_function("ThreadManForUser", "0xA66B0120", "sceKernelReferEventFlagStatus"));
    asm (macro.import_function("ThreadManForUser", "0x8125221D", "sceKernelCreateMbx"));
    asm (macro.import_function("ThreadManForUser", "0x86255ADA", "sceKernelDeleteMbx"));
    asm (macro.import_function("ThreadManForUser", "0xE9B3061E", "sceKernelSendMbx"));
    asm (macro.import_function("ThreadManForUser", "0x18260574", "sceKernelReceiveMbx"));
    asm (macro.import_function("ThreadManForUser", "0xF3986382", "sceKernelReceiveMbxCB"));
    asm (macro.import_function("ThreadManForUser", "0x0D81716A", "sceKernelPollMbx"));
    asm (macro.import_function("ThreadManForUser", "0x87D4DD36", "sceKernelCancelReceiveMbx"));
    asm (macro.import_function("ThreadManForUser", "0xA8E8C846", "sceKernelReferMbxStatus"));
    asm (macro.import_function("ThreadManForUser", "0x7C0DC2A0", "sceKernelCreateMsgPipe_stub"));
    asm (macro.generic_abi_wrapper("sceKernelCreateMsgPipe", 5));
    asm (macro.import_function("ThreadManForUser", "0xF0B7DA1C", "sceKernelDeleteMsgPipe"));
    asm (macro.import_function("ThreadManForUser", "0x876DBFAD", "sceKernelSendMsgPipe_stub"));
    asm (macro.generic_abi_wrapper("sceKernelSendMsgPipe", 6));
    asm (macro.import_function("ThreadManForUser", "0x7C41F2C2", "sceKernelSendMsgPipeCB_stub"));
    asm (macro.generic_abi_wrapper("sceKernelSendMsgPipeCB", 6));
    asm (macro.import_function("ThreadManForUser", "0x884C9F90", "sceKernelTrySendMsgPipe_stub"));
    asm (macro.generic_abi_wrapper("sceKernelTrySendMsgPipe", 5));
    asm (macro.import_function("ThreadManForUser", "0x74829B76", "sceKernelReceiveMsgPipe_stub"));
    asm (macro.generic_abi_wrapper("sceKernelReceiveMsgPipe", 6));
    asm (macro.import_function("ThreadManForUser", "0xFBFA697D", "sceKernelReceiveMsgPipeCB_stub"));
    asm (macro.generic_abi_wrapper("sceKernelReceiveMsgPipeCB", 6));
    asm (macro.import_function("ThreadManForUser", "0xDF52098F", "sceKernelTryReceiveMsgPipe_stub"));
    asm (macro.generic_abi_wrapper("sceKernelTryReceiveMsgPipe", 5));
    asm (macro.import_function("ThreadManForUser", "0x349B864D", "sceKernelCancelMsgPipe"));
    asm (macro.import_function("ThreadManForUser", "0x33BE4024", "sceKernelReferMsgPipeStatus"));
    asm (macro.import_function("ThreadManForUser", "0x56C039B5", "sceKernelCreateVpl_stub"));
    asm (macro.generic_abi_wrapper("sceKernelCreateVpl", 5));
    asm (macro.import_function("ThreadManForUser", "0x89B3D48C", "sceKernelDeleteVpl"));
    asm (macro.import_function("ThreadManForUser", "0xBED27435", "sceKernelAllocateVpl"));
    asm (macro.import_function("ThreadManForUser", "0xEC0A693F", "sceKernelAllocateVplCB"));
    asm (macro.import_function("ThreadManForUser", "0xAF36D708", "sceKernelTryAllocateVpl"));
    asm (macro.import_function("ThreadManForUser", "0xB736E9FF", "sceKernelFreeVpl"));
    asm (macro.import_function("ThreadManForUser", "0x1D371B8A", "sceKernelCancelVpl"));
    asm (macro.import_function("ThreadManForUser", "0x39810265", "sceKernelReferVplStatus"));
    asm (macro.import_function("ThreadManForUser", "0xC07BB470", "sceKernelCreateFpl_stub"));
    asm (macro.generic_abi_wrapper("sceKernelCreateFpl", 6));
    asm (macro.import_function("ThreadManForUser", "0xED1410E0", "sceKernelDeleteFpl"));
    asm (macro.import_function("ThreadManForUser", "0xD979E9BF", "sceKernelAllocateFpl"));
    asm (macro.import_function("ThreadManForUser", "0xE7282CB6", "sceKernelAllocateFplCB"));
    asm (macro.import_function("ThreadManForUser", "0x623AE665", "sceKernelTryAllocateFpl"));
    asm (macro.import_function("ThreadManForUser", "0xF6414A71", "sceKernelFreeFpl"));
    asm (macro.import_function("ThreadManForUser", "0xA8AA591F", "sceKernelCancelFpl"));
    asm (macro.import_function("ThreadManForUser", "0xD8199E4C", "sceKernelReferFplStatus"));
    asm (macro.import_function("ThreadManForUser", "0x0E927AED", "_sceKernelReturnFromTimerHandler"));
    asm (macro.import_function("ThreadManForUser", "0x110DEC9A", "sceKernelUSec2SysClock"));
    asm (macro.import_function("ThreadManForUser", "0xC8CD158C", "sceKernelUSec2SysClockWide"));
    asm (macro.import_function("ThreadManForUser", "0xBA6B92E2", "sceKernelSysClock2USec"));
    asm (macro.import_function("ThreadManForUser", "0xE1619D7C", "sceKernelSysClock2USecWide"));
    asm (macro.import_function("ThreadManForUser", "0xDB738F35", "sceKernelGetSystemTime"));
    asm (macro.import_function("ThreadManForUser", "0x82BC5777", "sceKernelGetSystemTimeWide"));
    asm (macro.import_function("ThreadManForUser", "0x369ED59D", "sceKernelGetSystemTimeLow"));
    asm (macro.import_function("ThreadManForUser", "0x6652B8CA", "sceKernelSetAlarm"));
    asm (macro.import_function("ThreadManForUser", "0xB2C25152", "sceKernelSetSysClockAlarm"));
    asm (macro.import_function("ThreadManForUser", "0x7E65B999", "sceKernelCancelAlarm"));
    asm (macro.import_function("ThreadManForUser", "0xDAA3F564", "sceKernelReferAlarmStatus"));
    asm (macro.import_function("ThreadManForUser", "0x20FFF560", "sceKernelCreateVTimer"));
    asm (macro.import_function("ThreadManForUser", "0x328F9E52", "sceKernelDeleteVTimer"));
    asm (macro.import_function("ThreadManForUser", "0xB3A59970", "sceKernelGetVTimerBase"));
    asm (macro.import_function("ThreadManForUser", "0xB7C18B77", "sceKernelGetVTimerBaseWide"));
    asm (macro.import_function("ThreadManForUser", "0x034A921F", "sceKernelGetVTimerTime"));
    asm (macro.import_function("ThreadManForUser", "0xC0B3FFD2", "sceKernelGetVTimerTimeWide"));
    asm (macro.import_function("ThreadManForUser", "0x542AD630", "sceKernelSetVTimerTime"));
    asm (macro.import_function("ThreadManForUser", "0xFB6425C3", "sceKernelSetVTimerTimeWide"));
    asm (macro.import_function("ThreadManForUser", "0xC68D9437", "sceKernelStartVTimer"));
    asm (macro.import_function("ThreadManForUser", "0xD0AEEE87", "sceKernelStopVTimer"));
    asm (macro.import_function("ThreadManForUser", "0xD8B299AE", "sceKernelSetVTimerHandler"));
    asm (macro.import_function("ThreadManForUser", "0x53B00E9A", "sceKernelSetVTimerHandlerWide"));
    asm (macro.import_function("ThreadManForUser", "0xD2D615EF", "sceKernelCancelVTimerHandler"));
    asm (macro.import_function("ThreadManForUser", "0x5F32BEAA", "sceKernelReferVTimerStatus"));
    asm (macro.import_function("ThreadManForUser", "0x446D8DE6", "sceKernelCreateThread_stub"));
    asm (macro.generic_abi_wrapper("sceKernelCreateThread", 6));
    asm (macro.import_function("ThreadManForUser", "0x9FA03CD3", "sceKernelDeleteThread"));
    asm (macro.import_function("ThreadManForUser", "0xF475845D", "sceKernelStartThread"));
    asm (macro.import_function("ThreadManForUser", "0x532A522E", "_sceKernelExitThread"));
    asm (macro.import_function("ThreadManForUser", "0xAA73C935", "sceKernelExitThread"));
    asm (macro.import_function("ThreadManForUser", "0x809CE29B", "sceKernelExitDeleteThread"));
    asm (macro.import_function("ThreadManForUser", "0x616403BA", "sceKernelTerminateThread"));
    asm (macro.import_function("ThreadManForUser", "0x383F7BCC", "sceKernelTerminateDeleteThread"));
    asm (macro.import_function("ThreadManForUser", "0x3AD58B8C", "sceKernelSuspendDispatchThread"));
    asm (macro.import_function("ThreadManForUser", "0x27E22EC2", "sceKernelResumeDispatchThread"));
    asm (macro.import_function("ThreadManForUser", "0xEA748E31", "sceKernelChangeCurrentThreadAttr"));
    asm (macro.import_function("ThreadManForUser", "0x71BC9871", "sceKernelChangeThreadPriority"));
    asm (macro.import_function("ThreadManForUser", "0x912354A7", "sceKernelRotateThreadReadyQueue"));
    asm (macro.import_function("ThreadManForUser", "0x2C34E053", "sceKernelReleaseWaitThread"));
    asm (macro.import_function("ThreadManForUser", "0x293B45B8", "sceKernelGetThreadId"));
    asm (macro.import_function("ThreadManForUser", "0x94AA61EE", "sceKernelGetThreadCurrentPriority"));
    asm (macro.import_function("ThreadManForUser", "0x3B183E26", "sceKernelGetThreadExitStatus"));
    asm (macro.import_function("ThreadManForUser", "0xD13BDE95", "sceKernelCheckThreadStack"));
    asm (macro.import_function("ThreadManForUser", "0x52089CA1", "sceKernelGetThreadStackFreeSize"));
    asm (macro.import_function("ThreadManForUser", "0x17C1684E", "sceKernelReferThreadStatus"));
    asm (macro.import_function("ThreadManForUser", "0xFFC36A14", "sceKernelReferThreadRunStatus"));
    asm (macro.import_function("ThreadManForUser", "0x627E6F3A", "sceKernelReferSystemStatus"));
    asm (macro.import_function("ThreadManForUser", "0x94416130", "sceKernelGetThreadmanIdList"));
    asm (macro.import_function("ThreadManForUser", "0x57CF62DD", "sceKernelGetThreadmanIdType"));
    asm (macro.import_function("ThreadManForUser", "0x64D4540E", "sceKernelReferThreadProfiler"));
    asm (macro.import_function("ThreadManForUser", "0x8218B4DD", "sceKernelReferGlobalProfiler"));
    asm (macro.import_function("ThreadManForUser", "0x60107536", "sceKernelDeleteLwMutex"));
    asm (macro.import_function("ThreadManForUser", "0x19CFF145", "sceKernelCreateLwMutex_stub"));
    asm (macro.generic_abi_wrapper("sceKernelCreateLwMutex", 5));
}
