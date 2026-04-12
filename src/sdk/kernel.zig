// Kernel -- threads, memory, modules, interrupts, suspend, utils
//
// Wraps:
//   c/module/LoadExecForUser.zig
//   c/module/ThreadManForUser.zig
//   c/module/SysMemUserForUser.zig
//   c/module/ModuleMgrForUser.zig
//   c/module/Kernel_Library.zig
//   c/module/InterruptManager.zig
//   c/module/sceSuspendForUser.zig
//   c/module/UtilsForUser.zig

const int = @import("errors/kernel.zig");
const internal = @import("internal.zig");
const check = int.check;
const checkPositive = int.checkPositive;
const ci = internal.ci;
const cu = internal.cu;
const c = @import("../c/modules.zig");

const load_exec_mod = c.LoadExecForUser;
const thread_man = c.ThreadManForUser;
const sys_mem = c.SysMemUserForUser;
const mod_mgr = c.ModuleMgrForUser;
const kern_lib = c.Kernel_Library;
const intr_mgr = c.InterruptManager;
const suspend_mod = c.sceSuspendForUser;

pub const Error = int.Error;

// ---- Re-exported types from c/types ----

pub const SceUID = c.types.SceUID;
pub const SceKernelLoadExecParam = c.types.SceKernelLoadExecParam;
pub const SceKernelCallbackFunction = c.types.SceKernelCallbackFunction;
pub const SceKernelCallbackInfo = c.types.SceKernelCallbackInfo;
pub const SceKernelThreadEntry = c.types.SceKernelThreadEntry;
pub const SceKernelThreadInfo = c.types.SceKernelThreadInfo;
pub const SceKernelThreadOptParam = c.types.SceKernelThreadOptParam;
pub const SceKernelThreadRunStatus = c.types.SceKernelThreadRunStatus;
pub const SceKernelSysClock = c.types.SceKernelSysClock;
pub const SceKernelSystemStatus = c.types.SceKernelSystemStatus;
pub const SceKernelSemaInfo = c.types.SceKernelSemaInfo;
pub const SceKernelSemaOptParam = c.types.SceKernelSemaOptParam;
pub const SceKernelEventFlagInfo = c.types.SceKernelEventFlagInfo;
pub const SceKernelEventFlagOptParam = c.types.SceKernelEventFlagOptParam;
pub const SceKernelMbxInfo = c.types.SceKernelMbxInfo;
pub const SceKernelMbxOptParam = c.types.SceKernelMbxOptParam;
pub const SceKernelMppInfo = c.types.SceKernelMppInfo;
pub const SceKernelVplOptParam = c.types.SceKernelVplOptParam;
pub const SceKernelVplInfo = c.types.SceKernelVplInfo;
pub const SceKernelFplOptParam = c.types.SceKernelFplOptParam;
pub const SceKernelFplInfo = c.types.SceKernelFplInfo;
pub const SceKernelAlarmHandler = c.types.SceKernelAlarmHandler;
pub const SceKernelAlarmInfo = c.types.SceKernelAlarmInfo;
pub const SceKernelVTimerHandler = c.types.SceKernelVTimerHandler;
pub const SceKernelVTimerHandlerWide = c.types.SceKernelVTimerHandlerWide;
pub const SceKernelVTimerInfo = c.types.SceKernelVTimerInfo;
pub const SceKernelVTimerOptParam = c.types.SceKernelVTimerOptParam;
pub const SceKernelIdListType = c.types.SceKernelIdListType;
pub const PspEventFlagWaitTypes = c.types.PspEventFlagWaitTypes;
pub const SceKernelThreadEventHandler = c.types.SceKernelThreadEventHandler;
pub const SceKernelThreadEventHandlerInfo = c.types.SceKernelThreadEventHandlerInfo;
pub const SceKernelLMOption = c.types.SceKernelLMOption;
pub const SceKernelModuleInfo = c.types.SceKernelModuleInfo;
pub const SceKernelSMOption = c.types.SceKernelSMOption;
pub const SceLwMutexWorkarea = c.types.SceLwMutexWorkarea;
pub const PspIntrHandlerOptionParam = c.types.PspIntrHandlerOptionParam;
pub const PspDebugProfilerRegs = c.types.PspDebugProfilerRegs;

// ---- Newsdk-defined types ----

/// Memory block allocation type.
pub const MemBlockType = enum(c_int) {
    /// Allocate from the lowest available address.
    mem_low = 0,
    /// Allocate from the highest available address.
    mem_high = 1,
    /// Allocate at the address specified by the addr parameter.
    mem_addr = 2,
};

/// Memory partition ID.
pub const PartitionId = enum(u32) {
    /// Kernel memory partition.
    kernel = 1,
    /// User memory partition.
    user = 2,
};

/// Packed bitfield helper for PspEventFlagWaitTypes.
pub const EventFlagWaitMask = packed struct(u32) {
    boolean_op: enum(u1) {
        @"and" = 0,
        @"or" = 1,
    } = .@"and",

    unused_b1_4: u4 = 0,

    wait_clear: bool = false,

    unused_b6_31: u26 = 0,
};

/// Thread attribute values.
pub const ThreadAttributes = enum(u32) {
    /// Enable VFPU access for the thread.
    vfpu = 0x00_00_40_00,
    /// Allow using scratchpad memory for a thread (not usable on v1.0).
    scratch_sram = 0x00_00_80_00,
    /// Disables filling the stack with 0xFF on creation.
    no_fillstack = 0x00_10_00_00,
    /// Clear the stack when the thread is deleted.
    clear_stack = 0x00_20_00_00,
    /// Start the thread in user mode.
    user = 0x80_00_00_00,
    /// Thread is part of the USB/WLAN API.
    usbwlan = 0xa0_00_00_00,
    /// Thread is part of the VSH API.
    vsh = 0xc0_00_00_00,
};

/// Packed bitfield helper for thread attributes.
pub const ThreadAttributesMask = packed struct(u32) {
    unused_b0_13: u14 = 0,

    vfpu: bool = false,
    scratch_sram: bool = false,

    unused_b16_19: u4 = 0,

    no_fillstack: bool = false,
    clear_stack: bool = false,

    unused_b22_28: u7 = 0,

    usbwlan: bool = false,
    vsh: bool = false,
    user: bool = false,
};

/// Thread event IDs for monitoring.
pub const ThreadEventId = enum(c_int) {
    all = @as(c_int, @bitCast(@as(u32, 0xFFFFFFFF))),
    kern = @as(c_int, @bitCast(@as(u32, 0xFFFFFFF8))),
    user_threads = @as(c_int, @bitCast(@as(u32, 0xFFFFFFF0))),
    current = 0,
    _,
};

/// Thread event types.
pub const ThreadEvent = enum(c_int) {
    create = 1,
    start = 2,
    exit = 4,
    delete = 8,
    _,
};

/// Thread status values.
pub const ThreadStatus = enum(c_int) {
    running = 1,
    ready = 2,
    waiting = 4,
    @"suspend" = 8,
    stopped = 16,
    killed = 32,
    _,
};

/// Event flag attribute values.
pub const EventFlagAttributes = enum(c_int) {
    wait_single = 0,
    wait_multiple = 512,
};

/// Message packet header for messagebox operations.
pub const SceKernelMsgPacket = extern struct {
    next: [*c]SceKernelMsgPacket,
    msg_priority: u8,
    dummy: [3]u8,
};

// ===========================================================================
// ---- Load/Exec ----
// ===========================================================================

/// Execute a new game executable, limited when not running in kernel mode.
pub fn load_exec(file: [:0]const u8, param: ?*SceKernelLoadExecParam) Error!void {
    return check(load_exec_mod.sceKernelLoadExec(@ptrCast(file), param));
}

/// Exit game with status. NOTE: Probably wrong signature.
pub fn exit_game_with_status() void {
    load_exec_mod.sceKernelExitGameWithStatus();
}

/// Exit game and go back to the PSP browser.
/// You need to be in a thread in order for this function to work.
pub fn exit_game() void {
    load_exec_mod.sceKernelExitGame();
}

/// Register an exit callback.
/// By installing the exit callback the home button becomes active. However
/// if exit_game() is not called in the callback the PSP will likely crash.
pub fn register_exit_callback(cbid: i32) Error!void {
    return check(load_exec_mod.sceKernelRegisterExitCallback(@bitCast(@as(u32, @bitCast(cbid)))));
}

// ===========================================================================
// ---- Thread Management ----
// ===========================================================================

// -- Callbacks --

/// Return from a callback (internal syscall used as the return of the callback function).
pub fn return_from_callback() void {
    thread_man._sceKernelReturnFromCallback();
}

/// Register a thread event handler.
pub fn register_thread_event_handler(name: [:0]const u8, thread_id: SceUID, mask: i32, handler: SceKernelThreadEventHandler, common: ?*anyopaque) Error!SceUID {
    return checkPositive(SceUID, thread_man.sceKernelRegisterThreadEventHandler(@ptrCast(name), thread_id, @bitCast(@as(u32, @bitCast(mask))), handler, common));
}

/// Release a thread event handler.
pub fn release_thread_event_handler(uid: SceUID) Error!void {
    return check(thread_man.sceKernelReleaseThreadEventHandler(uid));
}

/// Get the status of a thread event handler.
pub fn refer_thread_event_handler_status(uid: SceUID, info: *SceKernelThreadEventHandlerInfo) Error!void {
    return check(thread_man.sceKernelReferThreadEventHandlerStatus(uid, info));
}

/// Create a callback.
/// Returns a callback ID which can be used in subsequent functions.
pub fn create_callback(name: [:0]const u8, func: SceKernelCallbackFunction, arg: ?*anyopaque) Error!i32 {
    return checkPositive(i32, thread_man.sceKernelCreateCallback(@ptrCast(name), func, arg));
}

/// Delete a callback.
pub fn delete_callback(cb: SceUID) Error!void {
    return check(thread_man.sceKernelDeleteCallback(cb));
}

/// Notify a callback.
pub fn notify_callback(cb: SceUID, arg2: i32) Error!void {
    return check(thread_man.sceKernelNotifyCallback(cb, @bitCast(@as(u32, @bitCast(arg2)))));
}

/// Cancel a callback.
pub fn cancel_callback(cb: SceUID) Error!void {
    return check(thread_man.sceKernelCancelCallback(cb));
}

/// Get the callback count.
pub fn get_callback_count(cb: SceUID) Error!i32 {
    return checkPositive(i32, thread_man.sceKernelGetCallbackCount(cb));
}

/// Check callbacks.
pub fn check_callback() Error!i32 {
    return checkPositive(i32, thread_man.sceKernelCheckCallback());
}

/// Get the status of a specified callback.
pub fn refer_callback_status(cb: SceUID, status: *SceKernelCallbackInfo) Error!void {
    return check(thread_man.sceKernelReferCallbackStatus(cb, status));
}

// -- Sleep/Wake --

/// Put the current thread to sleep.
pub fn sleep_thread() Error!void {
    return check(thread_man.sceKernelSleepThread());
}

/// Put the current thread to sleep but service any callbacks as necessary.
pub fn sleep_thread_cb() Error!void {
    return check(thread_man.sceKernelSleepThreadCB());
}

/// Wake a thread previously put into the sleep state.
pub fn wakeup_thread(thid: SceUID) Error!void {
    return check(thread_man.sceKernelWakeupThread(thid));
}

/// Cancel a thread that was to be woken with wakeup_thread.
pub fn cancel_wakeup_thread(thid: SceUID) Error!void {
    return check(thread_man.sceKernelCancelWakeupThread(thid));
}

/// Suspend a thread.
pub fn suspend_thread(thid: SceUID) Error!void {
    return check(thread_man.sceKernelSuspendThread(thid));
}

/// Resume a thread previously put into a suspended state.
pub fn resume_thread(thid: SceUID) Error!void {
    return check(thread_man.sceKernelResumeThread(thid));
}

/// Wait until a thread has ended.
pub fn wait_thread_end(thid: SceUID, timeout: ?*u32) Error!void {
    return check(thread_man.sceKernelWaitThreadEnd(thid, timeout));
}

/// Wait until a thread has ended and handle callbacks if necessary.
pub fn wait_thread_end_cb(thid: SceUID, timeout: ?*u32) Error!void {
    return check(thread_man.sceKernelWaitThreadEndCB(thid, timeout));
}

// -- Delay --

/// Delay the current thread by a specified number of microseconds.
pub fn delay_thread(delay_us: u32) Error!void {
    return check(thread_man.sceKernelDelayThread(delay_us));
}

/// Delay the current thread by a specified number of microseconds and handle any callbacks.
pub fn delay_thread_cb(delay_us: u32) Error!void {
    return check(thread_man.sceKernelDelayThreadCB(delay_us));
}

/// Delay the current thread by a specified number of sysclocks.
pub fn delay_sys_clock_thread(delay: *SceKernelSysClock) Error!void {
    return check(thread_man.sceKernelDelaySysClockThread(delay));
}

/// Delay the current thread by a specified number of sysclocks, handling callbacks.
pub fn delay_sys_clock_thread_cb(delay: *SceKernelSysClock) Error!void {
    return check(thread_man.sceKernelDelaySysClockThreadCB(delay));
}

// -- Semaphores --

/// Create a new semaphore.
pub fn create_sema(name: [:0]const u8, attr: u32, init_val: i32, max_val: i32, option: ?*SceKernelSemaOptParam) Error!SceUID {
    return checkPositive(SceUID, thread_man.sceKernelCreateSema(@ptrCast(name), attr, @bitCast(@as(u32, @bitCast(init_val))), @bitCast(@as(u32, @bitCast(max_val))), option));
}

/// Destroy a semaphore.
pub fn delete_sema(semaid: SceUID) Error!void {
    return check(thread_man.sceKernelDeleteSema(semaid));
}

/// Send a signal to a semaphore.
pub fn signal_sema(semaid: SceUID, signal: i32) Error!void {
    return check(thread_man.sceKernelSignalSema(semaid, @bitCast(@as(u32, @bitCast(signal)))));
}

/// Wait on a semaphore.
pub fn wait_sema(semaid: SceUID, signal: i32, timeout: ?*u32) Error!void {
    return check(thread_man.sceKernelWaitSema(semaid, @bitCast(@as(u32, @bitCast(signal))), timeout));
}

/// Wait on a semaphore and handle callbacks if necessary.
pub fn wait_sema_cb(semaid: SceUID, signal: i32, timeout: ?*u32) Error!void {
    return check(thread_man.sceKernelWaitSemaCB(semaid, @bitCast(@as(u32, @bitCast(signal))), timeout));
}

/// Poll a semaphore (non-blocking).
pub fn poll_sema(semaid: SceUID, signal: i32) Error!void {
    return check(thread_man.sceKernelPollSema(semaid, @bitCast(@as(u32, @bitCast(signal)))));
}

/// Cancel a semaphore. NOTE: Probably wrong signature in the C module.
pub fn cancel_sema() void {
    thread_man.sceKernelCancelSema();
}

/// Retrieve information about a semaphore.
pub fn refer_sema_status(semaid: SceUID, info: *SceKernelSemaInfo) Error!void {
    return check(thread_man.sceKernelReferSemaStatus(semaid, info));
}

// -- Event Flags --

/// Create an event flag.
pub fn create_event_flag(name: [:0]const u8, attr: EventFlagAttributes, bits: u32, opt: ?*SceKernelEventFlagOptParam) Error!SceUID {
    return checkPositive(SceUID, thread_man.sceKernelCreateEventFlag(@ptrCast(name), @intFromEnum(attr), @bitCast(bits), opt));
}

/// Delete an event flag.
pub fn delete_event_flag(evid: i32) Error!void {
    return check(thread_man.sceKernelDeleteEventFlag(@bitCast(@as(u32, @bitCast(evid)))));
}

/// Set an event flag bit pattern.
pub fn set_event_flag(evid: SceUID, bits: u32) Error!void {
    return check(thread_man.sceKernelSetEventFlag(evid, bits));
}

/// Clear an event flag bit pattern.
pub fn clear_event_flag(evid: SceUID, bits: u32) Error!void {
    return check(thread_man.sceKernelClearEventFlag(evid, bits));
}

/// Wait for an event flag for a given bit pattern.
pub fn wait_event_flag(evid: i32, bits: u32, wait: EventFlagWaitMask, out_bits: ?*u32, timeout: ?*u32) Error!void {
    return check(thread_man.sceKernelWaitEventFlag(@bitCast(@as(u32, @bitCast(evid))), bits, @bitCast(wait), out_bits, timeout));
}

/// Wait for an event flag for a given bit pattern with callback.
pub fn wait_event_flag_cb(evid: i32, bits: u32, wait: EventFlagWaitMask, out_bits: ?*u32, timeout: ?*u32) Error!void {
    return check(thread_man.sceKernelWaitEventFlagCB(@bitCast(@as(u32, @bitCast(evid))), bits, @bitCast(wait), out_bits, timeout));
}

/// Poll an event flag for a given bit pattern (non-blocking).
pub fn poll_event_flag(evid: i32, bits: u32, wait: EventFlagWaitMask, out_bits: ?*u32) Error!void {
    return check(thread_man.sceKernelPollEventFlag(@bitCast(@as(u32, @bitCast(evid))), bits, @bitCast(wait), out_bits));
}

/// Cancel an event flag. NOTE: Probably wrong signature in the C module.
pub fn cancel_event_flag() void {
    thread_man.sceKernelCancelEventFlag();
}

/// Get the status of an event flag.
pub fn refer_event_flag_status(event: SceUID, status: *SceKernelEventFlagInfo) Error!void {
    return check(thread_man.sceKernelReferEventFlagStatus(event, status));
}

// -- Messageboxes --

/// Create a new messagebox.
pub fn create_mbx(name: [:0]const u8, attr: u32, option: ?*SceKernelMbxOptParam) Error!SceUID {
    return checkPositive(SceUID, thread_man.sceKernelCreateMbx(@ptrCast(name), attr, option));
}

/// Destroy a messagebox.
pub fn delete_mbx(mbxid: SceUID) Error!void {
    return check(thread_man.sceKernelDeleteMbx(mbxid));
}

/// Send a message to a messagebox.
pub fn send_mbx(mbxid: SceUID, message: ?*anyopaque) Error!void {
    return check(thread_man.sceKernelSendMbx(mbxid, message));
}

/// Wait for a message to arrive in a messagebox.
pub fn receive_mbx(mbxid: SceUID, pmessage: ?*anyopaque, timeout: ?*u32) Error!void {
    return check(thread_man.sceKernelReceiveMbx(mbxid, pmessage, timeout));
}

/// Wait for a message to arrive in a messagebox and handle callbacks if necessary.
pub fn receive_mbx_cb(mbxid: SceUID, pmessage: ?*anyopaque, timeout: ?*u32) Error!void {
    return check(thread_man.sceKernelReceiveMbxCB(mbxid, pmessage, timeout));
}

/// Check if a message has arrived in a messagebox (non-blocking).
pub fn poll_mbx(mbxid: SceUID, pmessage: ?*anyopaque) Error!void {
    return check(thread_man.sceKernelPollMbx(mbxid, pmessage));
}

/// Abort all wait operations on a messagebox.
pub fn cancel_receive_mbx(mbxid: SceUID, pnum: ?*i32) Error!void {
    return check(thread_man.sceKernelCancelReceiveMbx(mbxid, @ptrCast(pnum)));
}

/// Retrieve information about a messagebox.
pub fn refer_mbx_status(mbxid: SceUID, info: *SceKernelMbxInfo) Error!void {
    return check(thread_man.sceKernelReferMbxStatus(mbxid, info));
}

// -- Message Pipes --

/// Create a message pipe.
pub fn create_msg_pipe(name: [:0]const u8, part: i32, attr: i32, unk1: ?*anyopaque, opt: ?*anyopaque) Error!SceUID {
    return checkPositive(SceUID, thread_man.sceKernelCreateMsgPipe(@ptrCast(name), @bitCast(@as(u32, @bitCast(part))), @bitCast(@as(u32, @bitCast(attr))), unk1, opt));
}

/// Delete a message pipe.
pub fn delete_msg_pipe(uid: SceUID) Error!void {
    return check(thread_man.sceKernelDeleteMsgPipe(uid));
}

/// Send a message to a pipe.
pub fn send_msg_pipe(uid: SceUID, message: ?*anyopaque, size: u32, unk1: i32, unk2: ?*anyopaque, timeout: ?*u32) Error!void {
    return check(thread_man.sceKernelSendMsgPipe(uid, message, @bitCast(size), @bitCast(@as(u32, @bitCast(unk1))), unk2, @ptrCast(timeout)));
}

/// Send a message to a pipe (with callback).
pub fn send_msg_pipe_cb(uid: SceUID, message: ?*anyopaque, size: u32, unk1: i32, unk2: ?*anyopaque, timeout: ?*u32) Error!void {
    return check(thread_man.sceKernelSendMsgPipeCB(uid, message, @bitCast(size), @bitCast(@as(u32, @bitCast(unk1))), unk2, @ptrCast(timeout)));
}

/// Try to send a message to a pipe (non-blocking).
pub fn try_send_msg_pipe(uid: SceUID, message: ?*anyopaque, size: u32, unk1: i32, unk2: ?*anyopaque) Error!void {
    return check(thread_man.sceKernelTrySendMsgPipe(uid, message, @bitCast(size), @bitCast(@as(u32, @bitCast(unk1))), unk2));
}

/// Receive a message from a pipe.
pub fn receive_msg_pipe(uid: SceUID, message: ?*anyopaque, size: u32, unk1: i32, unk2: ?*anyopaque, timeout: ?*u32) Error!void {
    return check(thread_man.sceKernelReceiveMsgPipe(uid, message, @bitCast(size), @bitCast(@as(u32, @bitCast(unk1))), unk2, @ptrCast(timeout)));
}

/// Receive a message from a pipe (with callback).
pub fn receive_msg_pipe_cb(uid: SceUID, message: ?*anyopaque, size: u32, unk1: i32, unk2: ?*anyopaque, timeout: ?*u32) Error!void {
    return check(thread_man.sceKernelReceiveMsgPipeCB(uid, message, @bitCast(size), @bitCast(@as(u32, @bitCast(unk1))), unk2, @ptrCast(timeout)));
}

/// Try to receive a message from a pipe (non-blocking).
pub fn try_receive_msg_pipe(uid: SceUID, message: ?*anyopaque, size: u32, unk1: i32, unk2: ?*anyopaque) Error!void {
    return check(thread_man.sceKernelTryReceiveMsgPipe(uid, message, @bitCast(size), @bitCast(@as(u32, @bitCast(unk1))), unk2));
}

/// Cancel a message pipe.
pub fn cancel_msg_pipe(uid: SceUID, psend: ?*i32, precv: ?*i32) Error!void {
    return check(thread_man.sceKernelCancelMsgPipe(uid, @ptrCast(psend), @ptrCast(precv)));
}

/// Get the status of a message pipe.
pub fn refer_msg_pipe_status(uid: SceUID, info: *SceKernelMppInfo) Error!void {
    return check(thread_man.sceKernelReferMsgPipeStatus(uid, info));
}

// -- Variable-size Pools (VPL) --

/// Create a variable-size memory pool.
pub fn create_vpl(name: [:0]const u8, part: i32, attr: i32, size: u32, opt: ?*SceKernelVplOptParam) Error!SceUID {
    return checkPositive(SceUID, thread_man.sceKernelCreateVpl(@ptrCast(name), @bitCast(@as(u32, @bitCast(part))), @bitCast(@as(u32, @bitCast(attr))), @bitCast(size), opt));
}

/// Delete a variable-size pool.
pub fn delete_vpl(uid: SceUID) Error!void {
    return check(thread_man.sceKernelDeleteVpl(uid));
}

/// Allocate from a variable-size pool.
pub fn allocate_vpl(uid: SceUID, size: u32, data: ?*anyopaque, timeout: ?*u32) Error!void {
    return check(thread_man.sceKernelAllocateVpl(uid, @bitCast(size), data, @ptrCast(timeout)));
}

/// Allocate from a variable-size pool (with callback).
pub fn allocate_vpl_cb(uid: SceUID, size: u32, data: ?*anyopaque, timeout: ?*u32) Error!void {
    return check(thread_man.sceKernelAllocateVplCB(uid, @bitCast(size), data, @ptrCast(timeout)));
}

/// Try to allocate from a variable-size pool (non-blocking).
pub fn try_allocate_vpl(uid: SceUID, size: u32, data: ?*anyopaque) Error!void {
    return check(thread_man.sceKernelTryAllocateVpl(uid, @bitCast(size), data));
}

/// Free a block from a variable-size pool.
pub fn free_vpl(uid: SceUID, data: ?*anyopaque) Error!void {
    return check(thread_man.sceKernelFreeVpl(uid, data));
}

/// Cancel a variable-size pool.
pub fn cancel_vpl(uid: SceUID, pnum: ?*i32) Error!void {
    return check(thread_man.sceKernelCancelVpl(uid, @ptrCast(pnum)));
}

/// Get the status of a variable-size pool.
pub fn refer_vpl_status(uid: SceUID, info: *SceKernelVplInfo) Error!void {
    return check(thread_man.sceKernelReferVplStatus(uid, info));
}

// -- Fixed-size Pools (FPL) --

/// Create a fixed-size memory pool.
pub fn create_fpl(name: [:0]const u8, part: i32, attr: i32, size: u32, blocks: u32, opt: ?*SceKernelFplOptParam) Error!i32 {
    return checkPositive(i32, thread_man.sceKernelCreateFpl(@ptrCast(name), @bitCast(@as(u32, @bitCast(part))), @bitCast(@as(u32, @bitCast(attr))), @bitCast(size), @bitCast(blocks), opt));
}

/// Delete a fixed-size pool.
pub fn delete_fpl(uid: SceUID) Error!void {
    return check(thread_man.sceKernelDeleteFpl(uid));
}

/// Allocate from a fixed-size pool.
pub fn allocate_fpl(uid: SceUID, data: ?*anyopaque, timeout: ?*u32) Error!void {
    return check(thread_man.sceKernelAllocateFpl(uid, data, @ptrCast(timeout)));
}

/// Allocate from a fixed-size pool (with callback).
pub fn allocate_fpl_cb(uid: SceUID, data: ?*anyopaque, timeout: ?*u32) Error!void {
    return check(thread_man.sceKernelAllocateFplCB(uid, data, @ptrCast(timeout)));
}

/// Try to allocate from a fixed-size pool (non-blocking).
pub fn try_allocate_fpl(uid: SceUID, data: ?*anyopaque) Error!void {
    return check(thread_man.sceKernelTryAllocateFpl(uid, data));
}

/// Free a block from a fixed-size pool.
pub fn free_fpl(uid: SceUID, data: ?*anyopaque) Error!void {
    return check(thread_man.sceKernelFreeFpl(uid, data));
}

/// Cancel a fixed-size pool.
pub fn cancel_fpl(uid: SceUID, pnum: ?*i32) Error!void {
    return check(thread_man.sceKernelCancelFpl(uid, @ptrCast(pnum)));
}

/// Get the status of a fixed-size pool.
pub fn refer_fpl_status(uid: SceUID, info: *SceKernelFplInfo) Error!void {
    return check(thread_man.sceKernelReferFplStatus(uid, info));
}

// -- Timer/Clock --

/// Return from a timer handler (internal syscall, doesn't seem to do much).
pub fn return_from_timer_handler() void {
    thread_man._sceKernelReturnFromTimerHandler();
}

/// Convert a number of microseconds to a SceKernelSysClock structure.
pub fn usec_to_sys_clock(usec: u32, clock: *SceKernelSysClock) Error!void {
    return check(thread_man.sceKernelUSec2SysClock(@bitCast(usec), clock));
}

/// Convert a number of microseconds to a wide time.
pub fn usec_to_sys_clock_wide(usec: u32) i64 {
    return thread_man.sceKernelUSec2SysClockWide(@bitCast(usec));
}

/// Convert a SceKernelSysClock structure to microseconds.
pub fn sys_clock_to_usec(clock: *SceKernelSysClock, low: ?*u32, high: ?*u32) Error!void {
    return check(thread_man.sceKernelSysClock2USec(clock, @ptrCast(low), @ptrCast(high)));
}

/// Convert a wide time to microseconds.
pub fn sys_clock_to_usec_wide(clock: i64, low: ?*i32, high: ?*u32) Error!void {
    return check(thread_man.sceKernelSysClock2USecWide(clock, @ptrCast(low), @ptrCast(high)));
}

/// Get the system time.
pub fn get_system_time(time: *SceKernelSysClock) Error!void {
    return check(thread_man.sceKernelGetSystemTime(time));
}

/// Get the system time (wide version).
pub fn get_system_time_wide() i64 {
    return thread_man.sceKernelGetSystemTimeWide();
}

/// Get the low 32 bits of the current system time.
pub fn get_system_time_low() u32 {
    return thread_man.sceKernelGetSystemTimeLow();
}

// -- Alarms --

/// Set an alarm.
/// Returns a UID representing the created alarm.
pub fn set_alarm(clock: u32, handler: SceKernelAlarmHandler, common: ?*anyopaque) Error!SceUID {
    return checkPositive(SceUID, thread_man.sceKernelSetAlarm(clock, handler, common));
}

/// Set an alarm using a SceKernelSysClock structure for the time.
/// Returns a UID representing the created alarm.
pub fn set_sys_clock_alarm(clock: *SceKernelSysClock, handler: SceKernelAlarmHandler, common: ?*anyopaque) Error!SceUID {
    return checkPositive(SceUID, thread_man.sceKernelSetSysClockAlarm(clock, handler, common));
}

/// Cancel a pending alarm.
pub fn cancel_alarm(alarmid: SceUID) Error!void {
    return check(thread_man.sceKernelCancelAlarm(alarmid));
}

/// Get the status of a created alarm.
pub fn refer_alarm_status(alarmid: SceUID, info: *SceKernelAlarmInfo) Error!void {
    return check(thread_man.sceKernelReferAlarmStatus(alarmid, info));
}

// -- Virtual Timers --

/// Create a virtual timer.
/// Returns the VTimer's UID.
pub fn create_vtimer(name: [:0]const u8, opt: ?*SceKernelVTimerOptParam) Error!SceUID {
    return checkPositive(SceUID, thread_man.sceKernelCreateVTimer(@ptrCast(name), opt));
}

/// Delete a virtual timer.
pub fn delete_vtimer(uid: SceUID) Error!void {
    return check(thread_man.sceKernelDeleteVTimer(uid));
}

/// Get the timer base.
pub fn get_vtimer_base(uid: SceUID, base: *SceKernelSysClock) Error!void {
    return check(thread_man.sceKernelGetVTimerBase(uid, base));
}

/// Get the timer base (wide format).
pub fn get_vtimer_base_wide(uid: SceUID) i64 {
    return thread_man.sceKernelGetVTimerBaseWide(uid);
}

/// Get the timer time.
pub fn get_vtimer_time(uid: SceUID, time: *SceKernelSysClock) Error!void {
    return check(thread_man.sceKernelGetVTimerTime(uid, time));
}

/// Get the timer time (wide format).
pub fn get_vtimer_time_wide(uid: SceUID) i64 {
    return thread_man.sceKernelGetVTimerTimeWide(uid);
}

/// Set the timer time.
pub fn set_vtimer_time(uid: SceUID, time: *SceKernelSysClock) Error!void {
    return check(thread_man.sceKernelSetVTimerTime(uid, time));
}

/// Set the timer time (wide format).
/// Returns possibly the last time.
pub fn set_vtimer_time_wide(uid: SceUID, time: i64) i64 {
    return thread_man.sceKernelSetVTimerTimeWide(uid, time);
}

/// Start a virtual timer.
pub fn start_vtimer(uid: SceUID) Error!void {
    return check(thread_man.sceKernelStartVTimer(uid));
}

/// Stop a virtual timer.
pub fn stop_vtimer(uid: SceUID) Error!void {
    return check(thread_man.sceKernelStopVTimer(uid));
}

/// Set the timer handler.
pub fn set_vtimer_handler(uid: SceUID, time: *SceKernelSysClock, handler: SceKernelVTimerHandler, common: ?*anyopaque) Error!void {
    return check(thread_man.sceKernelSetVTimerHandler(uid, time, handler, common));
}

/// Set the timer handler (wide mode).
pub fn set_vtimer_handler_wide(uid: SceUID, time: i64, handler: SceKernelVTimerHandlerWide, common: ?*anyopaque) Error!void {
    return check(thread_man.sceKernelSetVTimerHandlerWide(uid, time, handler, common));
}

/// Cancel the timer handler.
pub fn cancel_vtimer_handler(uid: SceUID) Error!void {
    return check(thread_man.sceKernelCancelVTimerHandler(uid));
}

/// Get the status of a VTimer.
pub fn refer_vtimer_status(uid: SceUID, info: *SceKernelVTimerInfo) Error!void {
    return check(thread_man.sceKernelReferVTimerStatus(uid, info));
}

// -- Threads --

/// Create a thread.
pub fn create_thread(name: [:0]const u8, entry: SceKernelThreadEntry, init_priority: i32, stack_size: i32, attr: ThreadAttributesMask, option: ?*SceKernelThreadOptParam) Error!SceUID {
    return checkPositive(SceUID, thread_man.sceKernelCreateThread(@ptrCast(name), entry, @bitCast(@as(u32, @bitCast(init_priority))), @bitCast(@as(u32, @bitCast(stack_size))), @bitCast(attr), option));
}

/// Delete a thread.
pub fn delete_thread(thid: SceUID) Error!void {
    return check(thread_man.sceKernelDeleteThread(thid));
}

/// Start a created thread.
pub fn start_thread(thid: SceUID, arglen: usize, argp: ?*anyopaque) Error!void {
    return check(thread_man.sceKernelStartThread(thid, arglen, argp));
}

/// Exit the thread (internal syscall, probably used when the main thread returns).
pub fn exit_thread_internal() void {
    thread_man._sceKernelExitThread();
}

/// Exit a thread.
pub fn exit_thread(status: i32) Error!void {
    return check(thread_man.sceKernelExitThread(@bitCast(@as(u32, @bitCast(status)))));
}

/// Exit a thread and delete itself.
pub fn exit_delete_thread(status: i32) Error!void {
    return check(thread_man.sceKernelExitDeleteThread(@bitCast(@as(u32, @bitCast(status)))));
}

/// Terminate a thread.
pub fn terminate_thread(thid: SceUID) Error!void {
    return check(thread_man.sceKernelTerminateThread(thid));
}

/// Terminate and delete a thread.
pub fn terminate_delete_thread(thid: SceUID) Error!void {
    return check(thread_man.sceKernelTerminateDeleteThread(thid));
}

/// Suspend the dispatch thread.
/// Returns the current state of the dispatch thread.
pub fn suspend_dispatch_thread() Error!i32 {
    return checkPositive(i32, thread_man.sceKernelSuspendDispatchThread());
}

/// Resume the dispatch thread.
pub fn resume_dispatch_thread(state: i32) Error!void {
    return check(thread_man.sceKernelResumeDispatchThread(@bitCast(@as(u32, @bitCast(state)))));
}

/// Modify the attributes of the current thread.
pub fn change_current_thread_attr(unknown: i32, attr: ThreadAttributesMask) Error!void {
    return check(thread_man.sceKernelChangeCurrentThreadAttr(@bitCast(@as(u32, @bitCast(unknown))), @bitCast(attr)));
}

/// Change a thread's current priority.
pub fn change_thread_priority(thid: SceUID, priority: i32) Error!void {
    return check(thread_man.sceKernelChangeThreadPriority(thid, @bitCast(@as(u32, @bitCast(priority)))));
}

/// Rotate thread ready queue at a set priority.
pub fn rotate_thread_ready_queue(priority: i32) Error!void {
    return check(thread_man.sceKernelRotateThreadReadyQueue(@bitCast(@as(u32, @bitCast(priority)))));
}

/// Release a thread in the wait state.
pub fn release_wait_thread(thid: SceUID) Error!void {
    return check(thread_man.sceKernelReleaseWaitThread(thid));
}

/// Get the current thread ID.
pub fn get_thread_id() i32 {
    return thread_man.sceKernelGetThreadId();
}

/// Get the current priority of the calling thread.
pub fn get_thread_current_priority() i32 {
    return thread_man.sceKernelGetThreadCurrentPriority();
}

/// Get the exit status of a thread.
pub fn get_thread_exit_status(thid: SceUID) i32 {
    return thread_man.sceKernelGetThreadExitStatus(thid);
}

/// Check the thread stack.
pub fn check_thread_stack() i32 {
    return thread_man.sceKernelCheckThreadStack();
}

/// Get the free stack size for a thread.
/// Pass 0 for thid to query the current thread.
pub fn get_thread_stack_free_size(thid: SceUID) i32 {
    return thread_man.sceKernelGetThreadStackFreeSize(thid);
}

/// Get the status information for the specified thread.
pub fn refer_thread_status(thid: SceUID, info: *SceKernelThreadInfo) Error!void {
    return check(thread_man.sceKernelReferThreadStatus(thid, info));
}

/// Retrieve the runtime status of a thread.
pub fn refer_thread_run_status(thid: SceUID, status: *SceKernelThreadRunStatus) Error!void {
    return check(thread_man.sceKernelReferThreadRunStatus(thid, status));
}

/// Get the current system status.
pub fn refer_system_status(status: *SceKernelSystemStatus) Error!void {
    return check(thread_man.sceKernelReferSystemStatus(status));
}

/// Get a list of UIDs from threadman. Allows you to enumerate resources.
pub fn get_threadman_id_list(list_type: SceKernelIdListType, readbuf: [*]SceUID, readbufsize: i32, idcount: *i32) Error!void {
    return check(thread_man.sceKernelGetThreadmanIdList(list_type, readbuf, @bitCast(@as(u32, @bitCast(readbufsize))), @ptrCast(idcount)));
}

/// Get the type of a threadman UID.
pub fn get_threadman_id_type(uid: SceUID) SceKernelIdListType {
    return thread_man.sceKernelGetThreadmanIdType(uid);
}

/// Get the thread profiler registers.
pub fn refer_thread_profiler() ?[*]volatile PspDebugProfilerRegs {
    return thread_man.sceKernelReferThreadProfiler();
}

/// Get the global profiler registers.
pub fn refer_global_profiler() ?[*]volatile PspDebugProfilerRegs {
    return thread_man.sceKernelReferGlobalProfiler();
}

// -- Lightweight Mutexes (ThreadManForUser) --

/// Create a lightweight mutex.
pub fn create_lw_mutex(workarea: *SceLwMutexWorkarea, name: [:0]const u8, attr: u32, initial_count: i32, options_ptr: ?*u32) Error!void {
    return check(thread_man.sceKernelCreateLwMutex(workarea, @ptrCast(name), attr, @bitCast(@as(u32, @bitCast(initial_count))), options_ptr));
}

/// Delete a lightweight mutex.
pub fn delete_lw_mutex(workarea: *SceLwMutexWorkarea) Error!void {
    return check(thread_man.sceKernelDeleteLwMutex(workarea));
}

// ===========================================================================
// ---- System Memory ----
// ===========================================================================

/// Get the size of the largest free memory block, in bytes.
pub fn max_free_mem_size() usize {
    return sys_mem.sceKernelMaxFreeMemSize();
}

/// Get the total amount of free memory, in bytes.
pub fn total_free_mem_size() usize {
    return sys_mem.sceKernelTotalFreeMemSize();
}

/// Allocate a memory block from a memory partition.
/// Returns the UID of the new block.
pub fn alloc_partition_memory(partitionid: PartitionId, name: [:0]const u8, block_type: MemBlockType, size: usize, addr: ?*anyopaque) Error!SceUID {
    return checkPositive(SceUID, sys_mem.sceKernelAllocPartitionMemory(@as(c_int, @intCast(@intFromEnum(partitionid))), @ptrCast(name), @intFromEnum(block_type), size, addr));
}

/// Free a memory block allocated with alloc_partition_memory.
pub fn free_partition_memory(blockid: SceUID) Error!void {
    return check(sys_mem.sceKernelFreePartitionMemory(blockid));
}

/// Get the address of a memory block.
/// Returns the lowest address belonging to the memory block.
pub fn get_block_head_addr(blockid: SceUID) ?*anyopaque {
    return sys_mem.sceKernelGetBlockHeadAddr(blockid);
}

/// Get the firmware version.
pub fn devkit_version() i32 {
    return sys_mem.sceKernelDevkitVersion();
}

// sceKernelPrintf is omitted -- variadic C functions cannot be sanely wrapped in Zig.

/// Set the version of the SDK with which the caller was compiled.
pub fn set_compiled_sdk_version(version: i32) Error!void {
    return check(sys_mem.sceKernelSetCompiledSdkVersion(@bitCast(@as(u32, @bitCast(version)))));
}

/// Get the SDK version set with set_compiled_sdk_version.
/// Returns the version number, or 0 if unset.
pub fn get_compiled_sdk_version() i32 {
    return sys_mem.sceKernelGetCompiledSdkVersion();
}

// ===========================================================================
// ---- Module Manager ----
// ===========================================================================

/// Load a module from the given file UID.
/// Returns the UID of the loaded module.
pub fn load_module_by_id(fid: SceUID, flags: i32, option: ?*SceKernelLMOption) Error!SceUID {
    return checkPositive(SceUID, mod_mgr.sceKernelLoadModuleByID(fid, @bitCast(@as(u32, @bitCast(flags))), option));
}

/// Load a module.
/// This function restricts where it can load from unless called in kernel mode.
/// Must be called from a thread.
/// Returns the UID of the loaded module.
pub fn load_module(path: [:0]const u8, flags: i32, option: ?*SceKernelLMOption) Error!SceUID {
    return checkPositive(SceUID, mod_mgr.sceKernelLoadModule(@ptrCast(path), @bitCast(@as(u32, @bitCast(flags))), option));
}

/// Load a module from Memory Stick.
/// This function restricts what it can load, e.g. it won't load plain executables.
/// Returns the UID of the loaded module.
pub fn load_module_ms(path: [:0]const u8, flags: i32, option: ?*SceKernelLMOption) Error!SceUID {
    return checkPositive(SceUID, mod_mgr.sceKernelLoadModuleMs(@ptrCast(path), @bitCast(@as(u32, @bitCast(flags))), option));
}

/// Load a module from a buffer using the USB/WLAN API.
/// Can only be called from kernel mode, or from a thread with attributes 0xa0000000.
/// The buffer must reside at an address that is a multiple of 64 bytes.
/// Returns the UID of the loaded module.
pub fn load_module_buffer_usb_wlan(bufsize: usize, buf: ?*anyopaque, flags: i32, option: ?*SceKernelLMOption) Error!SceUID {
    return checkPositive(SceUID, mod_mgr.sceKernelLoadModuleBufferUsbWlan(bufsize, buf, @bitCast(@as(u32, @bitCast(flags))), option));
}

/// Start a loaded module.
/// Returns the module's UID if it was started and made resident (> 0),
/// or 0 on success for modules that don't need to stay resident.
pub fn start_module(modid: SceUID, argsize: usize, argp: ?*anyopaque, status: ?*i32, option: ?*SceKernelSMOption) Error!i32 {
    return checkPositive(i32, mod_mgr.sceKernelStartModule(modid, argsize, argp, @ptrCast(status), option));
}

/// Stop a running module.
pub fn stop_module(modid: SceUID, argsize: usize, argp: ?*anyopaque, status: ?*i32, option: ?*SceKernelSMOption) Error!void {
    return check(mod_mgr.sceKernelStopModule(modid, argsize, argp, @ptrCast(status), option));
}

/// Unload a stopped module.
pub fn unload_module(modid: SceUID) Error!void {
    return check(mod_mgr.sceKernelUnloadModule(modid));
}

/// Stop and unload the current module.
pub fn self_stop_unload_module(unknown: i32, argsize: usize, argp: ?*anyopaque) Error!void {
    return check(mod_mgr.sceKernelSelfStopUnloadModule(@bitCast(@as(u32, @bitCast(unknown))), argsize, argp));
}

/// Stop and unload the current module (alternate form).
pub fn stop_unload_self_module(argsize: usize, argp: ?*anyopaque, status: ?*i32, option: ?*SceKernelSMOption) Error!void {
    return check(mod_mgr.sceKernelStopUnloadSelfModule(argsize, argp, @ptrCast(status), option));
}

/// Query the information about a loaded module from its UID.
pub fn query_module_info(modid: SceUID, info: *SceKernelModuleInfo) Error!void {
    return check(mod_mgr.sceKernelQueryModuleInfo(modid, info));
}

/// Get a list of module IDs. Only available on firmware 1.5 and above.
pub fn get_module_id_list(readbuf: [*]SceUID, readbufsize: i32, idcount: *i32) Error!void {
    return check(mod_mgr.sceKernelGetModuleIdList(readbuf, @bitCast(@as(u32, @bitCast(readbufsize))), @ptrCast(idcount)));
}

/// Get the ID of the module occupying the given address.
pub fn get_module_id_by_address(module_addr: ?*const anyopaque) Error!i32 {
    return checkPositive(i32, mod_mgr.sceKernelGetModuleIdByAddress(module_addr));
}

// ===========================================================================
// ---- Kernel Library (interrupts, lwmutex) ----
// ===========================================================================

/// Suspend all interrupts.
/// Returns the current state of the interrupt controller, to be used with cpu_resume_intr.
pub fn cpu_suspend_intr() u32 {
    return kern_lib.sceKernelCpuSuspendIntr();
}

/// Resume all interrupts.
pub fn cpu_resume_intr(flags: u32) void {
    kern_lib.sceKernelCpuResumeIntr(flags);
}

/// Resume all interrupts (using sync instructions).
pub fn cpu_resume_intr_with_sync(flags: u32) void {
    kern_lib.sceKernelCpuResumeIntrWithSync(flags);
}

/// Determine if interrupts are suspended or active, based on the given flags.
/// Returns true if flags indicate that interrupts were not suspended.
pub fn is_cpu_intr_suspended(flags: u32) bool {
    return kern_lib.sceKernelIsCpuIntrSuspended(flags) != 0;
}

/// Determine if interrupts are currently enabled.
/// Returns true if interrupts are enabled.
pub fn is_cpu_intr_enable() bool {
    return kern_lib.sceKernelIsCpuIntrEnable() != 0;
}

/// Lock a lightweight mutex (Kernel_Library version).
pub fn lock_lw_mutex(workarea: *SceLwMutexWorkarea, lock_count: i32, timeout: ?*u32) Error!void {
    return check(kern_lib.sceKernelLockLwMutex(workarea, @bitCast(@as(u32, @bitCast(lock_count))), @ptrCast(timeout)));
}

/// Unlock a lightweight mutex (Kernel_Library version).
pub fn unlock_lw_mutex(workarea: *SceLwMutexWorkarea, lock_count: i32) Error!void {
    return check(kern_lib.sceKernelUnlockLwMutex(workarea, @bitCast(@as(u32, @bitCast(lock_count)))));
}

/// Try to lock a lightweight mutex (Kernel_Library version, non-blocking).
pub fn try_lock_lw_mutex(workarea: *SceLwMutexWorkarea, lock_count: i32) Error!void {
    return check(kern_lib.sceKernelTryLockLwMutex(workarea, @bitCast(@as(u32, @bitCast(lock_count)))));
}

// ===========================================================================
// ---- Interrupt Manager ----
// ===========================================================================

/// Register a sub interrupt handler.
pub fn register_sub_intr_handler(intno: i32, no: i32, handler: ?*anyopaque, arg: ?*anyopaque) Error!void {
    return check(intr_mgr.sceKernelRegisterSubIntrHandler(@bitCast(@as(u32, @bitCast(intno))), @bitCast(@as(u32, @bitCast(no))), handler, arg));
}

/// Release a sub interrupt handler.
pub fn release_sub_intr_handler(intno: i32, no: i32) Error!void {
    return check(intr_mgr.sceKernelReleaseSubIntrHandler(@bitCast(@as(u32, @bitCast(intno))), @bitCast(@as(u32, @bitCast(no)))));
}

/// Enable a sub interrupt.
pub fn enable_sub_intr(intno: i32, no: i32) Error!void {
    return check(intr_mgr.sceKernelEnableSubIntr(@bitCast(@as(u32, @bitCast(intno))), @bitCast(@as(u32, @bitCast(no)))));
}

/// Disable a sub interrupt handler.
pub fn disable_sub_intr(intno: i32, no: i32) Error!void {
    return check(intr_mgr.sceKernelDisableSubIntr(@bitCast(@as(u32, @bitCast(intno))), @bitCast(@as(u32, @bitCast(no)))));
}

/// Suspend a sub interrupt.
pub fn suspend_sub_intr() void {
    intr_mgr.sceKernelSuspendSubIntr();
}

/// Resume a sub interrupt.
pub fn resume_sub_intr() void {
    intr_mgr.sceKernelResumeSubIntr();
}

/// Check if a sub interrupt has occurred.
pub fn is_sub_interrupt_occurred() void {
    intr_mgr.sceKernelIsSubInterruptOccurred();
}

/// Query interrupt handler info.
pub fn query_intr_handler_info(intr_code: SceUID, sub_intr_code: SceUID, data: *PspIntrHandlerOptionParam) Error!void {
    return check(intr_mgr.QueryIntrHandlerInfo(intr_code, sub_intr_code, data));
}

/// Register user space interrupt stack.
pub fn register_user_space_intr_stack() void {
    intr_mgr.sceKernelRegisterUserSpaceIntrStack();
}

// ===========================================================================
// ---- Suspend/Power ----
// ===========================================================================

/// Lock power (prevent sleep).
pub fn power_lock() void {
    suspend_mod.sceKernelPowerLock();
}

/// Unlock power (allow sleep).
pub fn power_unlock() void {
    suspend_mod.sceKernelPowerUnlock();
}

/// Reset the power tick timer (prevent auto-sleep).
pub fn power_tick() void {
    suspend_mod.sceKernelPowerTick();
}

/// Allocate the extra 4 MB of RAM (volatile memory).
/// Blocks until the memory is available.
pub fn volatile_mem_lock(unk: i32, ptr: ?*anyopaque, size: ?*i32) Error!void {
    return check(suspend_mod.sceKernelVolatileMemLock(@bitCast(@as(u32, @bitCast(unk))), ptr, @ptrCast(size)));
}

/// Try to allocate the extra 4 MB of RAM (volatile memory).
/// Returns an error if something has already allocated it.
pub fn volatile_mem_try_lock(unk: i32, ptr: ?*anyopaque, size: ?*i32) Error!void {
    return check(suspend_mod.sceKernelVolatileMemTryLock(@bitCast(@as(u32, @bitCast(unk))), ptr, @ptrCast(size)));
}

/// Deallocate the extra 4 MB of RAM (volatile memory).
/// Set unk to 0, otherwise it fails in firmware 3.52+.
pub fn volatile_mem_unlock(unk: i32) Error!void {
    return check(suspend_mod.sceKernelVolatileMemUnlock(@bitCast(@as(u32, @bitCast(unk)))));
}

// -- UtilsForUser -------------------------------------------------------

const utils_mod = c.UtilsForUser;

// Re-exported types
pub const Mt19937Context = c.types.SceKernelUtilsMt19937Context;
pub const Md5Context = c.types.SceKernelUtilsMd5Context;
pub const Sha1Context = c.types.SceKernelUtilsSha1Context;
pub const time_t = c.types.time_t;
pub const clock_t = c.types.clock_t;
pub const Timezone = c.types.timezone;
pub const Timeval = c.types.SceKernelTimeval;

// Mersenne Twister PRNG

/// Initialise a Mersenne Twister context.
pub fn mt19937_init(ctx: *Mt19937Context, seed: u32) Error!void {
    return check(utils_mod.sceKernelUtilsMt19937Init(ctx, seed));
}

/// Return a new pseudo-random number (0 to MAX_INT).
pub fn mt19937_uint(ctx: *Mt19937Context) u32 {
    return utils_mod.sceKernelUtilsMt19937UInt(ctx);
}

// MD5

/// Hash a data block with MD5 in one shot.
pub fn md5_digest(data: []const u8, digest: *[16]u8) Error!void {
    return check(utils_mod.sceKernelUtilsMd5Digest(@constCast(data.ptr), @intCast(data.len), digest));
}

/// Initialise an MD5 streaming context.
pub fn md5_block_init(ctx: *Md5Context) Error!void {
    return check(utils_mod.sceKernelUtilsMd5BlockInit(ctx));
}

/// Feed data into an MD5 streaming context.
pub fn md5_block_update(ctx: *Md5Context, data: []const u8) Error!void {
    return check(utils_mod.sceKernelUtilsMd5BlockUpdate(ctx, @constCast(data.ptr), @intCast(data.len)));
}

/// Finalise an MD5 streaming context and get the digest.
pub fn md5_block_result(ctx: *Md5Context, digest: *[16]u8) Error!void {
    return check(utils_mod.sceKernelUtilsMd5BlockResult(ctx, digest));
}

// SHA1

/// Hash a data block with SHA1 in one shot.
pub fn sha1_digest(data: []const u8, digest: *[20]u8) Error!void {
    return check(utils_mod.sceKernelUtilsSha1Digest(@constCast(data.ptr), @intCast(data.len), digest));
}

/// Initialise a SHA1 streaming context.
pub fn sha1_block_init(ctx: *Sha1Context) Error!void {
    return check(utils_mod.sceKernelUtilsSha1BlockInit(ctx));
}

/// Feed data into a SHA1 streaming context.
pub fn sha1_block_update(ctx: *Sha1Context, data: []const u8) Error!void {
    return check(utils_mod.sceKernelUtilsSha1BlockUpdate(ctx, @constCast(data.ptr), @intCast(data.len)));
}

/// Finalise a SHA1 streaming context and get the digest.
pub fn sha1_block_result(ctx: *Sha1Context, digest: *[20]u8) Error!void {
    return check(utils_mod.sceKernelUtilsSha1BlockResult(ctx, digest));
}

// libc-style time

/// Get the processor clock ticks since process start.
pub fn libc_clock() clock_t {
    return utils_mod.sceKernelLibcClock();
}

/// Get seconds since the Unix epoch (1970-01-01).
pub fn libc_time(t: ?*time_t) time_t {
    return utils_mod.sceKernelLibcTime(t);
}

/// Get current time and timezone information.
pub fn libc_gettimeofday(tp: *Timeval, tzp: ?*Timezone) Error!void {
    return check(utils_mod.sceKernelLibcGettimeofday(tp, tzp));
}

// Cache maintenance

/// Write back the entire data cache to memory.
pub fn dcache_writeback_all() void {
    utils_mod.sceKernelDcacheWritebackAll();
}

/// Write back and invalidate the entire data cache.
pub fn dcache_writeback_invalidate_all() void {
    utils_mod.sceKernelDcacheWritebackInvalidateAll();
}

/// Write back a range from the data cache to memory.
pub fn dcache_writeback_range(p: ?*const anyopaque, size: u32) void {
    utils_mod.sceKernelDcacheWritebackRange(p, size);
}

/// Write back and invalidate a range in the data cache.
pub fn dcache_writeback_invalidate_range(p: ?*const anyopaque, size: u32) void {
    utils_mod.sceKernelDcacheWritebackInvalidateRange(p, size);
}

/// Invalidate a range of addresses in the data cache.
pub fn dcache_invalidate_range(p: ?*const anyopaque, size: u32) void {
    utils_mod.sceKernelDcacheInvalidateRange(p, size);
}

/// Invalidate the entire instruction cache.
pub fn icache_invalidate_all() void {
    utils_mod.sceKernelIcacheInvalidateAll();
}

/// Invalidate a range of addresses in the instruction cache.
pub fn icache_invalidate_range(p: ?*const anyopaque, size: u32) void {
    utils_mod.sceKernelIcacheInvalidateRange(p, size);
}
