const std = @import("std");

const Io = std.Io;
const Dir = std.Io.Dir;
const File = std.Io.File;
const Terminal = std.Io.Terminal;
const net = std.Io.net;

const io = @import("../sdk/io.zig");
const rtc = @import("../sdk/rtc.zig");
const kernel = @import("../sdk/kernel.zig");
const psp_net = @import("../sdk/net.zig");
const net_utils = @import("net.zig");

const SceUID = io.SceUID;

/// A stub std.Io backed by this vtable.
/// Every method panics; fill in the ones you need.
pub const psp_io: Io = .{
    .userdata = null,
    .vtable = &vtable,
};

pub const vtable: Io.VTable = .{
    .crashHandler = crashHandler,
    .async = async,
    .concurrent = concurrent,
    .await = await,
    .cancel = cancel,
    .groupAsync = groupAsync,
    .groupConcurrent = groupConcurrent,
    .groupAwait = groupAwait,
    .groupCancel = groupCancel,
    .recancel = recancel,
    .swapCancelProtection = swapCancelProtection,
    .checkCancel = checkCancel,
    .futexWait = futexWait,
    .futexWaitUncancelable = futexWaitUncancelable,
    .futexWake = futexWake,
    .operate = operate,
    .batchAwaitAsync = batchAwaitAsync,
    .batchAwaitConcurrent = batchAwaitConcurrent,
    .batchCancel = batchCancel,
    .dirCreateDir = dirCreateDir,
    .dirCreateDirPath = dirCreateDirPath,
    .dirCreateDirPathOpen = dirCreateDirPathOpen,
    .dirOpenDir = dirOpenDir,
    .dirStat = dirStat,
    .dirStatFile = dirStatFile,
    .dirAccess = dirAccess,
    .dirCreateFile = dirCreateFile,
    .dirCreateFileAtomic = dirCreateFileAtomic,
    .dirOpenFile = dirOpenFile,
    .dirClose = dirClose,
    .dirRead = dirRead,
    .dirRealPath = dirRealPath,
    .dirRealPathFile = dirRealPathFile,
    .dirDeleteFile = dirDeleteFile,
    .dirDeleteDir = dirDeleteDir,
    .dirRename = dirRename,
    .dirRenamePreserve = dirRenamePreserve,
    .dirSymLink = dirSymLink,
    .dirReadLink = dirReadLink,
    .dirSetOwner = dirSetOwner,
    .dirSetFileOwner = dirSetFileOwner,
    .dirSetPermissions = dirSetPermissions,
    .dirSetFilePermissions = dirSetFilePermissions,
    .dirSetTimestamps = dirSetTimestamps,
    .dirHardLink = dirHardLink,
    .fileStat = fileStat,
    .fileLength = fileLength,
    .fileClose = fileClose,
    .fileWritePositional = fileWritePositional,
    .fileWriteFileStreaming = fileWriteFileStreaming,
    .fileWriteFilePositional = fileWriteFilePositional,
    .fileReadPositional = fileReadPositional,
    .fileSeekBy = fileSeekBy,
    .fileSeekTo = fileSeekTo,
    .fileSync = fileSync,
    .fileIsTty = fileIsTty,
    .fileEnableAnsiEscapeCodes = fileEnableAnsiEscapeCodes,
    .fileSupportsAnsiEscapeCodes = fileSupportsAnsiEscapeCodes,
    .fileSetLength = fileSetLength,
    .fileSetOwner = fileSetOwner,
    .fileSetPermissions = fileSetPermissions,
    .fileSetTimestamps = fileSetTimestamps,
    .fileLock = fileLock,
    .fileTryLock = fileTryLock,
    .fileUnlock = fileUnlock,
    .fileDowngradeLock = fileDowngradeLock,
    .fileRealPath = fileRealPath,
    .fileHardLink = fileHardLink,
    .fileMemoryMapCreate = fileMemoryMapCreate,
    .fileMemoryMapDestroy = fileMemoryMapDestroy,
    .fileMemoryMapSetLength = fileMemoryMapSetLength,
    .fileMemoryMapRead = fileMemoryMapRead,
    .fileMemoryMapWrite = fileMemoryMapWrite,
    .processExecutableOpen = processExecutableOpen,
    .processExecutablePath = processExecutablePath,
    .lockStderr = lockStderr,
    .tryLockStderr = tryLockStderr,
    .unlockStderr = unlockStderr,
    .processCurrentPath = processCurrentPath,
    .processSetCurrentDir = processSetCurrentDir,
    .processSetCurrentPath = processSetCurrentPath,
    .processReplace = processReplace,
    .processReplacePath = processReplacePath,
    .processSpawn = processSpawn,
    .processSpawnPath = processSpawnPath,
    .childWait = childWait,
    .childKill = childKill,
    .progressParentFile = progressParentFile,
    .now = now,
    .clockResolution = clockResolution,
    .sleep = sleep,
    .random = random,
    .randomSecure = randomSecure,
    .netListenIp = netListenIp,
    .netAccept = netAccept,
    .netBindIp = netBindIp,
    .netConnectIp = netConnectIp,
    .netListenUnix = netListenUnix,
    .netConnectUnix = netConnectUnix,
    .netSocketCreatePair = netSocketCreatePair,
    .netSend = netSend,
    .netRead = netRead,
    .netWrite = netWrite,
    .netWriteFile = netWriteFile,
    .netClose = netClose,
    .netShutdown = netShutdown,
    .netInterfaceNameResolve = netInterfaceNameResolve,
    .netInterfaceName = netInterfaceName,
    .netLookup = netLookup,
};

fn toNullTerminated(path: []const u8, buf: *[1024]u8) ?[*:0]const u8 {
    if (path.len >= buf.len) return null;
    @memcpy(buf[0..path.len], path);
    buf[path.len] = 0;
    return buf[0..path.len :0].ptr;
}

fn crashHandler(_: ?*anyopaque) void {
    @panic("Io.crashHandler not implemented");
}

// -- Global State ------------------------------------------------------

var alloc: std.mem.Allocator = undefined;

// -- Per-thread cancellation state table ----------------------------------

const MAX_PSP_THREADS = 64;

const ThreadState = struct {
    thread_id: i32 = -1, // SceUID; -1 = unused slot
    cancel_protection: Io.CancelProtection = .unblocked,
    canceled: bool = false,
    cancel_acknowledged: bool = false,
};

var thread_states: [MAX_PSP_THREADS]ThreadState = [_]ThreadState{.{}} ** MAX_PSP_THREADS;

fn getThreadState() ?*ThreadState {
    const tid = kernel.get_thread_id();
    for (&thread_states) |*s| {
        if (s.thread_id == tid) return s;
    }
    return null;
}

fn registerThreadState() usize {
    const tid = kernel.get_thread_id();
    const dispatch_state = kernel.suspend_dispatch_thread() catch 0;
    defer kernel.resume_dispatch_thread(dispatch_state) catch {};
    for (&thread_states, 0..) |*s, i| {
        if (s.thread_id == -1) {
            s.* = .{ .thread_id = tid };
            return i;
        }
    }
    // All slots full -- should not happen with <= 64 PSP threads.
    // Fall back to slot 0 (main thread) which is always registered.
    return 0;
}

fn unregisterThreadState(slot: usize) void {
    const dispatch_state = kernel.suspend_dispatch_thread() catch 0;
    defer kernel.resume_dispatch_thread(dispatch_state) catch {};
    thread_states[slot] = .{};
}
var stderr_locked: bool = false;
var stdin_fd: SceUID = undefined;
var stdout_fd: SceUID = undefined;
var stderr_fd: SceUID = undefined;
var stderr_writer: File.Writer = .{
    .io = psp_io,
    .interface = File.Writer.initInterface(&.{}),
    .file = undefined,
    .mode = .streaming,
};

pub fn init(arg0: ?[*:0]const u8, allocator: std.mem.Allocator) void {
    alloc = allocator;
    stdin_fd = io.stdin();
    stdout_fd = io.stdout();
    stderr_fd = io.stderr();
    stderr_writer.file = .{ .handle = stderr_fd, .flags = .{ .nonblocking = false } };

    // Register main thread in the per-thread state table.
    thread_states[0] = .{ .thread_id = kernel.get_thread_id() };

    // Derive initial cwd from arg0 (program path, e.g. "ms0:/PSP/GAME/APP/EBOOT.PBP")
    if (arg0) |path_ptr| {
        const path = std.mem.sliceTo(path_ptr, 0);
        if (path.len > 0) {
            // Find last '/' to get the directory portion
            if (std.mem.lastIndexOfScalar(u8, path, '/')) |last_slash| {
                const dir = path[0..last_slash];
                if (dir.len > 0 and dir.len < cwd_buf.len) {
                    @memcpy(cwd_buf[0..dir.len], dir);
                    cwd_len = dir.len;
                    cwd_initialized = true;
                    // Also set the PSP kernel's cwd
                    var chdir_buf: [1024]u8 = undefined;
                    if (toNullTerminated(dir, &chdir_buf)) |path_z| {
                        io.chdir(path_z) catch {};
                    }
                }
            }
        }
    }
}

// -- fd->path tracking table --------------------------------------------

const MAX_TRACKED_FDS = 32;
const FdPathEntry = struct {
    fd: SceUID = -1,
    path: [1024]u8 = undefined,
    len: usize = 0,
};
var fd_table: [MAX_TRACKED_FDS]FdPathEntry = [_]FdPathEntry{.{}} ** MAX_TRACKED_FDS;

fn trackFd(fd: SceUID, path: []const u8) void {
    // Find a free slot (fd == -1) or reuse one
    for (&fd_table) |*entry| {
        if (entry.fd == -1) {
            const copy_len = @min(path.len, entry.path.len);
            @memcpy(entry.path[0..copy_len], path[0..copy_len]);
            entry.len = copy_len;
            entry.fd = fd;
            return;
        }
    }
}

fn untrackFd(fd: SceUID) void {
    for (&fd_table) |*entry| {
        if (entry.fd == fd) {
            entry.fd = -1;
            entry.len = 0;
            return;
        }
    }
}

fn lookupFdPath(fd: SceUID) ?[]const u8 {
    for (&fd_table) |*entry| {
        if (entry.fd == fd) {
            return entry.path[0..entry.len];
        }
    }
    return null;
}

// -- ScePspDateTime <-> Io.Timestamp helpers -----------------------------

// PSP RTC tick epoch is January 1, year 1 AD (confirmed by sceRtcGetCurrentTick output).
// Offset from year 1 AD to Unix epoch (1970-01-01) in seconds.
const psp_epoch_offset_s: i96 = 62135596800;

fn pspDateTimeToTimestamp(dt: rtc.DateTime) Io.Timestamp {
    var tick: u64 = 0;
    rtc.get_tick(&dt, &tick) catch return .{ .nanoseconds = 0 };
    // tick = microseconds since year 1 AD
    const tick_i96: i96 = @intCast(tick);
    const ns = tick_i96 * 1000 - psp_epoch_offset_s * 1_000_000_000;
    return .{ .nanoseconds = ns };
}

fn timestampToPspDateTime(ts: Io.Timestamp) rtc.DateTime {
    // Convert nanoseconds since Unix epoch -> microseconds since year 1 AD
    const ns = ts.nanoseconds;
    const us_since_year1: i96 = @divTrunc(ns, 1000) + psp_epoch_offset_s * 1_000_000;
    var tick: u64 = if (us_since_year1 < 0) 0 else @intCast(us_since_year1);
    var dt: rtc.DateTime = undefined;
    rtc.set_tick(&dt, &tick) catch {};
    return dt;
}

fn sceIoStatToFileStat(psp_stat: *const io.SceIoStat) File.Stat {
    return .{
        .inode = 0,
        .nlink = 0,
        .size = if (psp_stat.st_size < 0) 0 else @intCast(psp_stat.st_size),
        .permissions = @enumFromInt(@as(u32, @bitCast(psp_stat.st_mode))),
        .kind = if (psp_stat.st_attr & 0x10 != 0) .directory else .file,
        .atime = pspDateTimeToTimestamp(psp_stat.st_atime),
        .mtime = pspDateTimeToTimestamp(psp_stat.st_mtime),
        .ctime = pspDateTimeToTimestamp(psp_stat.st_ctime),
        .block_size = 0,
    };
}

// -- Async/Concurrency -------------------------------------------------
//
// PSP is single-core but has real kernel threads. We spawn a dedicated PSP
// thread per async/concurrent call and use a semaphore for completion
// signaling. Cancellation is tracked in the per-thread state table above.

const ASYNC_STACK_SIZE: i32 = 128 * 1024; // 128KB per worker thread
var thread_name_counter: u32 = 0;

// -- PspFuture: single-alloc header + context + result --------------------

const PspFuture = struct {
    func: *const fn (*const anyopaque, *anyopaque) void,
    thread_id: SceUID,
    completion_sema: SceUID,
    canceled: bool,
    done: bool,
    context_offset: usize,
    context_len: usize,
    result_offset: usize,
    result_len: usize,
    alloc_len: usize,

    fn contextPointer(self: *PspFuture) *const anyopaque {
        return @ptrFromInt(@intFromPtr(self) + self.context_offset);
    }

    fn resultPointer(self: *PspFuture) *anyopaque {
        return @ptrFromInt(@intFromPtr(self) + self.result_offset);
    }

    fn resultSlice(self: *PspFuture) []u8 {
        const ptr: [*]u8 = @ptrFromInt(@intFromPtr(self) + self.result_offset);
        return ptr[0..self.result_len];
    }

    fn create(
        result_len: usize,
        result_alignment: std.mem.Alignment,
        context: []const u8,
        context_alignment: std.mem.Alignment,
        func: *const fn (*const anyopaque, *anyopaque) void,
    ) ?*PspFuture {
        const header_size = @sizeOf(PspFuture);
        // Compute aligned offsets for context and result after the header.
        const ctx_offset = context_alignment.forward(header_size);
        const res_offset = result_alignment.forward(ctx_offset + context.len);
        const total = res_offset + result_len;

        const mem = alloc.rawAlloc(total, .@"8", 0) orelse return null;
        const self: *PspFuture = @ptrCast(@alignCast(mem));
        self.* = .{
            .func = func,
            .thread_id = 0,
            .completion_sema = 0,
            .canceled = false,
            .done = false,
            .context_offset = ctx_offset,
            .context_len = context.len,
            .result_offset = res_offset,
            .result_len = result_len,
            .alloc_len = total,
        };
        // Copy context bytes.
        const ctx_dst: [*]u8 = @ptrFromInt(@intFromPtr(self) + ctx_offset);
        @memcpy(ctx_dst[0..context.len], context);
        return self;
    }

    fn destroy(self: *PspFuture) void {
        kernel.delete_sema(self.completion_sema) catch {};
        const ptr: [*]u8 = @ptrCast(self);
        alloc.rawFree(ptr[0..self.alloc_len], .@"8", 0);
    }
};

// -- PspGroupState / PspGroupTask -----------------------------------------

const PspGroupState = struct {
    num_running: u32 = 0,
    canceled: bool = false,
    completion_sema: SceUID,
};

const PspGroupTask = struct {
    func: *const fn (*const anyopaque) void,
    group_state: *PspGroupState,
    context_offset: usize,
    context_len: usize,
    alloc_len: usize,

    fn contextPointer(self: *PspGroupTask) *const anyopaque {
        return @ptrFromInt(@intFromPtr(self) + self.context_offset);
    }

    fn create(
        context: []const u8,
        context_alignment: std.mem.Alignment,
        func: *const fn (*const anyopaque) void,
        gs: *PspGroupState,
    ) ?*PspGroupTask {
        const header_size = @sizeOf(PspGroupTask);
        const ctx_offset = context_alignment.forward(header_size);
        const total = ctx_offset + context.len;

        const mem = alloc.rawAlloc(total, .@"8", 0) orelse return null;
        const self: *PspGroupTask = @ptrCast(@alignCast(mem));
        self.* = .{
            .func = func,
            .group_state = gs,
            .context_offset = ctx_offset,
            .context_len = context.len,
            .alloc_len = total,
        };
        const ctx_dst: [*]u8 = @ptrFromInt(@intFromPtr(self) + ctx_offset);
        @memcpy(ctx_dst[0..context.len], context);
        return self;
    }

    fn destroy(self: *PspGroupTask) void {
        const ptr: [*]u8 = @ptrCast(self);
        alloc.rawFree(ptr[0..self.alloc_len], .@"8", 0);
    }
};

// -- Thread name helper ---------------------------------------------------

fn makeThreadName(buf: *[32]u8) [:0]const u8 {
    const n = thread_name_counter;
    thread_name_counter +%= 1;
    // Format "io_N\0" into buf.
    const prefix = "io_";
    @memcpy(buf[0..prefix.len], prefix);
    var pos: usize = prefix.len;
    var val = n;
    if (val == 0) {
        buf[pos] = '0';
        pos += 1;
    } else {
        var digits: [10]u8 = undefined;
        var dlen: usize = 0;
        while (val > 0) {
            digits[dlen] = @intCast(val % 10 + '0');
            dlen += 1;
            val /= 10;
        }
        var i: usize = 0;
        while (i < dlen) : (i += 1) {
            buf[pos] = digits[dlen - 1 - i];
            pos += 1;
        }
    }
    buf[pos] = 0;
    return buf[0..pos :0];
}

// -- Dispatch suspend helper for critical sections ------------------------

fn atomicDecrementRunning(gs: *PspGroupState) bool {
    const state = kernel.suspend_dispatch_thread() catch 0;
    gs.num_running -= 1;
    const is_last = (gs.num_running == 0);
    kernel.resume_dispatch_thread(state) catch {};
    return is_last;
}

fn atomicIncrementRunning(gs: *PspGroupState) void {
    const state = kernel.suspend_dispatch_thread() catch 0;
    gs.num_running += 1;
    kernel.resume_dispatch_thread(state) catch {};
}

fn atomicDecrementRunningOnFail(gs: *PspGroupState) void {
    const state = kernel.suspend_dispatch_thread() catch 0;
    gs.num_running -= 1;
    kernel.resume_dispatch_thread(state) catch {};
}

// -- Thread entry points --------------------------------------------------

fn inheritCwd() void {
    ensureCwdInit();
    var chdir_buf: [1024]u8 = undefined;
    if (toNullTerminated(cwd_buf[0..cwd_len], &chdir_buf)) |path_z| {
        io.chdir(path_z) catch {};
    }
}

fn futureThreadEntry(_: usize, argp: ?*anyopaque) callconv(.c) c_int {
    // argp points to a kernel-copied buffer containing our *PspFuture pointer.
    const future: *PspFuture = @as(*const *PspFuture, @ptrCast(@alignCast(argp.?))).*;
    const slot = registerThreadState();
    inheritCwd();

    if (future.canceled) {
        thread_states[slot].canceled = true;
    }

    future.func(future.contextPointer(), future.resultPointer());

    future.done = true;
    unregisterThreadState(slot);
    kernel.signal_sema(future.completion_sema, 1) catch {};
    kernel.exit_delete_thread(0) catch {};
    unreachable;
}

fn groupThreadEntry(_: usize, argp: ?*anyopaque) callconv(.c) c_int {
    // argp points to a kernel-copied buffer containing our *PspGroupTask pointer.
    const task: *PspGroupTask = @as(*const *PspGroupTask, @ptrCast(@alignCast(argp.?))).*;
    const gs = task.group_state;
    const slot = registerThreadState();
    inheritCwd();

    if (gs.canceled) {
        thread_states[slot].canceled = true;
    }

    task.func(task.contextPointer());

    unregisterThreadState(slot);
    const is_last = atomicDecrementRunning(gs);
    task.destroy();
    if (is_last) {
        kernel.signal_sema(gs.completion_sema, 1) catch {};
    }
    kernel.exit_delete_thread(0) catch {};
    unreachable;
}

// -- Spawn helper (shared by async and concurrent) ------------------------

fn spawnFuture(
    result_ptr: []u8,
    result_alignment: std.mem.Alignment,
    args_ptr: []const u8,
    context_alignment: std.mem.Alignment,
    start_fn: *const fn (*const anyopaque, *anyopaque) void,
) ?*PspFuture {
    const future = PspFuture.create(
        result_ptr.len,
        result_alignment,
        args_ptr,
        context_alignment,
        start_fn,
    ) orelse return null;

    const sema = kernel.create_sema("ioas", 0, 0, 1, null) catch {
        future.destroy();
        return null;
    };
    future.completion_sema = sema;

    var name_buf: [32]u8 = undefined;
    const name = makeThreadName(&name_buf);
    const priority = kernel.get_thread_current_priority() +| 1;

    const thid = kernel.create_thread(name, &futureThreadEntry, priority, ASYNC_STACK_SIZE, .{ .user = true }, null) catch {
        future.destroy();
        return null;
    };
    future.thread_id = thid;

    // Pass pointer to future as the thread argument.
    var arg: *PspFuture = future;
    kernel.start_thread(thid, @sizeOf(@TypeOf(arg)), @ptrCast(&arg)) catch {
        kernel.delete_thread(thid) catch {};
        future.destroy();
        return null;
    };

    return future;
}

// -- VTable: async --------------------------------------------------------

fn async(
    _: ?*anyopaque,
    result_ptr: []u8,
    result_alignment: std.mem.Alignment,
    args_ptr: []const u8,
    context_alignment: std.mem.Alignment,
    start_fn: *const fn (*const anyopaque, *anyopaque) void,
) ?*Io.AnyFuture {
    if (spawnFuture(result_ptr, result_alignment, args_ptr, context_alignment, start_fn)) |future| {
        return @ptrCast(future);
    }
    // Eager fallback: run synchronously and return null.
    start_fn(args_ptr.ptr, result_ptr.ptr);
    return null;
}

// -- VTable: concurrent ---------------------------------------------------

fn concurrent(
    _: ?*anyopaque,
    result_len: usize,
    result_alignment: std.mem.Alignment,
    args_ptr: []const u8,
    context_alignment: std.mem.Alignment,
    start_fn: *const fn (*const anyopaque, *anyopaque) void,
) Io.ConcurrentError!*Io.AnyFuture {
    const future = PspFuture.create(
        result_len,
        result_alignment,
        args_ptr,
        context_alignment,
        start_fn,
    ) orelse return error.ConcurrencyUnavailable;

    const sema = kernel.create_sema("iocs", 0, 0, 1, null) catch {
        future.destroy();
        return error.ConcurrencyUnavailable;
    };
    future.completion_sema = sema;

    var name_buf: [32]u8 = undefined;
    const name = makeThreadName(&name_buf);
    const priority = kernel.get_thread_current_priority() +| 1;

    const thid = kernel.create_thread(name, &futureThreadEntry, priority, ASYNC_STACK_SIZE, .{ .user = true }, null) catch {
        future.destroy();
        return error.ConcurrencyUnavailable;
    };
    future.thread_id = thid;

    var arg: *PspFuture = future;
    kernel.start_thread(thid, @sizeOf(@TypeOf(arg)), @ptrCast(&arg)) catch {
        kernel.delete_thread(thid) catch {};
        future.destroy();
        return error.ConcurrencyUnavailable;
    };

    return @ptrCast(future);
}

// -- VTable: await --------------------------------------------------------

fn await(
    _: ?*anyopaque,
    any_future: *Io.AnyFuture,
    result: []u8,
    _: std.mem.Alignment,
) void {
    const future: *PspFuture = @ptrCast(@alignCast(any_future));
    if (!future.done) {
        kernel.wait_sema(future.completion_sema, 1, null) catch {};
    }
    @memcpy(result, future.resultSlice());
    future.destroy();
}

// -- VTable: cancel -------------------------------------------------------

fn cancel(
    _: ?*anyopaque,
    any_future: *Io.AnyFuture,
    result: []u8,
    _: std.mem.Alignment,
) void {
    const future: *PspFuture = @ptrCast(@alignCast(any_future));
    // Request cancellation.
    future.canceled = true;
    // Also set the worker thread's cancel flag in the state table.
    for (&thread_states) |*s| {
        if (s.thread_id == future.thread_id) {
            s.canceled = true;
            break;
        }
    }
    // Block until the task finishes.
    if (!future.done) {
        kernel.wait_sema(future.completion_sema, 1, null) catch {};
    }
    @memcpy(result, future.resultSlice());
    future.destroy();
}

// -- VTable: groupAsync ---------------------------------------------------

fn getOrCreateGroupState(group: *Io.Group) ?*PspGroupState {
    if (group.token.load(.acquire)) |tok| {
        return @ptrCast(@alignCast(tok));
    }
    // Allocate new group state.
    const mem = alloc.rawAlloc(@sizeOf(PspGroupState), .@"8", 0) orelse return null;
    const gs: *PspGroupState = @ptrCast(@alignCast(mem));
    const sema = kernel.create_sema("iogs", 0, 0, 1, null) catch {
        alloc.rawFree(mem[0..@sizeOf(PspGroupState)], .@"8", 0);
        return null;
    };
    gs.* = .{ .completion_sema = sema };
    group.token.store(@ptrCast(gs), .release);
    return gs;
}

fn groupAsync(
    _: ?*anyopaque,
    group: *Io.Group,
    args_ptr: []const u8,
    context_alignment: std.mem.Alignment,
    start_fn: *const fn (*const anyopaque) void,
) void {
    const gs = getOrCreateGroupState(group) orelse {
        // Cannot allocate group state -- run eagerly.
        start_fn(args_ptr.ptr);
        return;
    };

    const task = PspGroupTask.create(args_ptr, context_alignment, start_fn, gs) orelse {
        start_fn(args_ptr.ptr);
        return;
    };

    atomicIncrementRunning(gs);

    var name_buf: [32]u8 = undefined;
    const name = makeThreadName(&name_buf);
    const priority = kernel.get_thread_current_priority() +| 1;

    const thid = kernel.create_thread(name, &groupThreadEntry, priority, ASYNC_STACK_SIZE, .{ .user = true }, null) catch {
        atomicDecrementRunningOnFail(gs);
        task.destroy();
        start_fn(args_ptr.ptr);
        return;
    };

    var arg: *PspGroupTask = task;
    kernel.start_thread(thid, @sizeOf(@TypeOf(arg)), @ptrCast(&arg)) catch {
        kernel.delete_thread(thid) catch {};
        atomicDecrementRunningOnFail(gs);
        task.destroy();
        start_fn(args_ptr.ptr);
        return;
    };
}

// -- VTable: groupConcurrent ----------------------------------------------

fn groupConcurrent(
    _: ?*anyopaque,
    group: *Io.Group,
    args_ptr: []const u8,
    context_alignment: std.mem.Alignment,
    start_fn: *const fn (*const anyopaque) void,
) Io.ConcurrentError!void {
    const gs = getOrCreateGroupState(group) orelse return error.ConcurrencyUnavailable;

    const task = PspGroupTask.create(args_ptr, context_alignment, start_fn, gs) orelse
        return error.ConcurrencyUnavailable;

    atomicIncrementRunning(gs);

    var name_buf: [32]u8 = undefined;
    const name = makeThreadName(&name_buf);
    const priority = kernel.get_thread_current_priority() +| 1;

    const thid = kernel.create_thread(name, &groupThreadEntry, priority, ASYNC_STACK_SIZE, .{ .user = true }, null) catch {
        atomicDecrementRunningOnFail(gs);
        task.destroy();
        return error.ConcurrencyUnavailable;
    };

    var arg: *PspGroupTask = task;
    kernel.start_thread(thid, @sizeOf(@TypeOf(arg)), @ptrCast(&arg)) catch {
        kernel.delete_thread(thid) catch {};
        atomicDecrementRunningOnFail(gs);
        task.destroy();
        return error.ConcurrencyUnavailable;
    };
}

// -- VTable: groupAwait ---------------------------------------------------

fn groupAwait(_: ?*anyopaque, group: *Io.Group, _: *anyopaque) Io.Cancelable!void {
    const gs: *PspGroupState = @ptrCast(@alignCast(group.token.load(.acquire) orelse return));

    // Propagate caller's cancellation to the group.
    if (getThreadState()) |s| {
        if (s.cancel_protection == .unblocked and s.canceled) {
            gs.canceled = true;
        }
    }

    if (gs.num_running > 0) {
        kernel.wait_sema(gs.completion_sema, 1, null) catch {};
    }

    const was_canceled = gs.canceled;
    // Clean up group state.
    kernel.delete_sema(gs.completion_sema) catch {};
    const mem: [*]u8 = @ptrCast(gs);
    alloc.rawFree(mem[0..@sizeOf(PspGroupState)], .@"8", 0);
    group.token.store(null, .release);

    if (was_canceled) {
        if (getThreadState()) |s| {
            s.canceled = false;
            s.cancel_acknowledged = true;
        }
        return error.Canceled;
    }
}

// -- VTable: groupCancel --------------------------------------------------

fn groupCancel(_: ?*anyopaque, group: *Io.Group, _: *anyopaque) void {
    const gs: *PspGroupState = @ptrCast(@alignCast(group.token.load(.acquire) orelse return));

    gs.canceled = true;

    if (gs.num_running > 0) {
        kernel.wait_sema(gs.completion_sema, 1, null) catch {};
    }

    kernel.delete_sema(gs.completion_sema) catch {};
    const mem: [*]u8 = @ptrCast(gs);
    alloc.rawFree(mem[0..@sizeOf(PspGroupState)], .@"8", 0);
    group.token.store(null, .release);
}

// -- VTable: recancel -----------------------------------------------------

fn recancel(_: ?*anyopaque) void {
    if (getThreadState()) |s| {
        s.canceled = true;
        s.cancel_acknowledged = false;
    }
}

// -- Cancellation/Sync -------------------------------------------------

fn swapCancelProtection(_: ?*anyopaque, new_val: Io.CancelProtection) Io.CancelProtection {
    const state = getThreadState() orelse return .unblocked;
    const old = state.cancel_protection;
    state.cancel_protection = new_val;
    return old;
}

fn checkCancel(_: ?*anyopaque) Io.Cancelable!void {
    const state = getThreadState() orelse return;
    if (state.cancel_protection == .blocked) return;
    if (state.canceled) {
        state.canceled = false;
        state.cancel_acknowledged = true;
        return error.Canceled;
    }
}

fn futexWait(_: ?*anyopaque, ptr: *const u32, expected: u32, timeout: Io.Timeout) Io.Cancelable!void {
    // Spin-yield: on single-core PSP, the value can only change when we yield.
    const atomic_ptr: *const std.atomic.Value(u32) = @ptrCast(ptr);
    if (atomic_ptr.load(.acquire) != expected) return;

    // Compute a deadline in PSP RTC ticks (microseconds since epoch).
    const deadline_tick: ?u64 = switch (timeout) {
        .none => null,
        .duration => |d| blk: {
            var tick: u64 = undefined;
            rtc.get_current_tick(&tick) catch return;
            const us: i64 = d.raw.toMicroseconds();
            break :blk if (us > 0) tick +| @as(u64, @intCast(us)) else tick;
        },
        .deadline => |d| blk: {
            // Convert absolute nanosecond timestamp to PSP tick.
            const ns = d.raw.toNanoseconds();
            const us: i96 = @divTrunc(ns, 1000);
            break :blk if (us > 0) @as(u64, @intCast(us)) else 0;
        },
    };

    while (atomic_ptr.load(.acquire) == expected) {
        // Cancellation point.
        if (getThreadState()) |s| {
            if (s.cancel_protection == .unblocked and s.canceled) {
                s.canceled = false;
                s.cancel_acknowledged = true;
                return error.Canceled;
            }
        }
        // Check timeout.
        if (deadline_tick) |dl| {
            var current_tick: u64 = undefined;
            rtc.get_current_tick(&current_tick) catch break;
            if (current_tick >= dl) break;
        }
        // Yield to other threads.
        kernel.delay_thread(100) catch {};
    }
}

fn futexWaitUncancelable(_: ?*anyopaque, ptr: *const u32, expected: u32) void {
    const atomic_ptr: *const std.atomic.Value(u32) = @ptrCast(ptr);
    while (atomic_ptr.load(.acquire) == expected) {
        kernel.delay_thread(100) catch {};
    }
}

fn futexWake(_: ?*anyopaque, _: *const u32, _: u32) void {
    // No-op: spin-yield waiters will observe the value change on their next
    // iteration after a delay_thread yield.
}

// -- Operate (Multiplexed I/O) -----------------------------------------

fn pspWrite(fd: SceUID, buf: []const u8) error{WriteFailed}!usize {
    return io.write(fd, buf) catch return error.WriteFailed;
}

fn operate(_: ?*anyopaque, op: Io.Operation) Io.Cancelable!Io.Operation.Result {
    switch (op) {
        .device_io_control => @panic("Io.operate: Device io_ctl Not Implemented"),
        .net_receive => @panic("Io.operate: net_receive Not Implemented"),
        .file_read_streaming => |r| {
            const fd = r.file.handle;
            var total: usize = 0;
            for (r.data) |buf| {
                if (buf.len > 0) {
                    const n = io.read(fd, buf) catch
                        return .{ .file_read_streaming = error.InputOutput };
                    total += n;
                    if (n < buf.len) break;
                }
            }
            return .{ .file_read_streaming = total };
        },
        .file_write_streaming => |w| {
            const fd = w.file.handle;
            var written: usize = 0;

            // Write header
            if (w.header.len > 0) {
                written += pspWrite(fd, w.header) catch
                    return .{ .file_write_streaming = error.InputOutput };
            }

            // Write data slices
            for (w.data[0..w.data.len -| 1]) |slice| {
                if (slice.len > 0) {
                    written += pspWrite(fd, slice) catch
                        return .{ .file_write_streaming = error.InputOutput };
                }
            }

            // Write last slice repeated `splat` times
            if (w.data.len > 0) {
                const pattern = w.data[w.data.len - 1];
                if (pattern.len > 0) {
                    var i: usize = 0;
                    while (i < w.splat) : (i += 1) {
                        written += pspWrite(fd, pattern) catch
                            return .{ .file_write_streaming = error.InputOutput };
                    }
                }
            }

            return .{ .file_write_streaming = written };
        },
    }
}

// -- Batch (N/A on PSP) -----------------------------------------------

fn batchAwaitAsync(_: ?*anyopaque, _: *Io.Batch) Io.Cancelable!void {
    @panic("Io.batchAwaitAsync not implemented");
}

fn batchAwaitConcurrent(_: ?*anyopaque, _: *Io.Batch, _: Io.Timeout) Io.Batch.AwaitConcurrentError!void {
    @panic("Io.batchAwaitConcurrent not implemented");
}

fn batchCancel(_: ?*anyopaque, _: *Io.Batch) void {
    @panic("Io.batchCancel not implemented");
}

// -- Directory operations ----------------------------------------------

fn dirCreateDir(_: ?*anyopaque, _: Dir, sub_path: []const u8, _: Dir.Permissions) Dir.CreateDirError!void {
    var path_buf: [1024]u8 = undefined;
    const path_z = toNullTerminated(sub_path, &path_buf) orelse return error.NameTooLong;
    io.mkdir(path_z, 0o777) catch return error.AccessDenied;
}

fn dirCreateDirPath(_: ?*anyopaque, _: Dir, sub_path: []const u8, _: Dir.Permissions) Dir.CreateDirPathError!Dir.CreatePathStatus {
    var path_buf: [1024]u8 = undefined;
    if (sub_path.len >= path_buf.len) return error.NameTooLong;
    @memcpy(path_buf[0..sub_path.len], sub_path);

    // Create each component incrementally
    var created_any = false;
    var i: usize = 0;
    while (i < sub_path.len) {
        if (path_buf[i] == '/') {
            if (i > 0) {
                path_buf[i] = 0;
                if (io.mkdir(@ptrCast(path_buf[0..i :0].ptr), 0o777)) |_|
                    created_any = true
                else |_| {}
                path_buf[i] = '/';
            }
            i += 1;
            continue;
        }
        i += 1;
    }
    // Create the final component
    path_buf[sub_path.len] = 0;
    const final_path: [*:0]const u8 = @ptrCast(path_buf[0..sub_path.len :0].ptr);
    if (io.mkdir(final_path, 0o777)) |_|
        return .created
    else |_| {}
    if (created_any) return .created;
    // If the final mkdir failed, it might already exist
    var stat_buf: io.SceIoStat = undefined;
    if (io.getstat(final_path, &stat_buf)) |_| {
        if (stat_buf.st_attr & 0x10 != 0) return .existed;
    } else |_| {}
    return error.AccessDenied;
}

fn dirCreateDirPathOpen(_: ?*anyopaque, _: Dir, sub_path: []const u8, _: Dir.Permissions, _: Dir.OpenOptions) Dir.CreateDirPathOpenError!Dir {
    var path_buf: [1024]u8 = undefined;
    if (sub_path.len >= path_buf.len) return error.NameTooLong;
    @memcpy(path_buf[0..sub_path.len], sub_path);

    // Create each component incrementally
    var i: usize = 0;
    while (i < sub_path.len) {
        if (path_buf[i] == '/') {
            if (i > 0) {
                path_buf[i] = 0;
                io.mkdir(@ptrCast(path_buf[0..i :0].ptr), 0o777) catch {};
                path_buf[i] = '/';
            }
            i += 1;
            continue;
        }
        i += 1;
    }
    // Create final component
    path_buf[sub_path.len] = 0;
    const final_path: [*:0]const u8 = @ptrCast(path_buf[0..sub_path.len :0].ptr);
    io.mkdir(final_path, 0o777) catch {};

    // Open it
    const fd = io.dopen(final_path) catch return error.FileNotFound;
    return .{ .handle = fd };
}

fn dirOpenDir(_: ?*anyopaque, _: Dir, sub_path: []const u8, _: Dir.OpenOptions) Dir.OpenError!Dir {
    var path_buf: [1024]u8 = undefined;
    const path_z = toNullTerminated(sub_path, &path_buf) orelse return error.NameTooLong;
    const fd = io.dopen(path_z) catch return error.FileNotFound;
    return .{ .handle = fd };
}

fn dirStat(_: ?*anyopaque, d: Dir) Dir.StatError!Dir.Stat {
    const path = lookupFdPath(d.handle) orelse return error.AccessDenied;
    var path_buf: [1024]u8 = undefined;
    const path_z = toNullTerminated(path, &path_buf) orelse return error.AccessDenied;
    var stat_buf: io.SceIoStat = undefined;
    io.getstat(path_z, &stat_buf) catch return error.AccessDenied;
    return sceIoStatToFileStat(&stat_buf);
}

fn dirStatFile(_: ?*anyopaque, _: Dir, sub_path: []const u8, _: Dir.StatFileOptions) Dir.StatFileError!File.Stat {
    var path_buf: [1024]u8 = undefined;
    const path_z = toNullTerminated(sub_path, &path_buf) orelse return error.NameTooLong;
    var stat_buf: io.SceIoStat = undefined;
    io.getstat(path_z, &stat_buf) catch return error.FileNotFound;
    return sceIoStatToFileStat(&stat_buf);
}

fn dirAccess(_: ?*anyopaque, _: Dir, sub_path: []const u8, _: Dir.AccessOptions) Dir.AccessError!void {
    var path_buf: [1024]u8 = undefined;
    const path_z = toNullTerminated(sub_path, &path_buf) orelse return error.NameTooLong;
    var stat_buf: io.SceIoStat = undefined;
    io.getstat(path_z, &stat_buf) catch return error.FileNotFound;
}

fn dirCreateFile(_: ?*anyopaque, _: Dir, sub_path: []const u8, flags: File.CreateFlags) File.OpenError!File {
    var path_buf: [1024]u8 = undefined;
    const path_z = toNullTerminated(sub_path, &path_buf) orelse return error.NameTooLong;
    const fd = io.open(path_z, .{
        .read = flags.read,
        .write = true,
        .create = true,
        .truncate = flags.truncate,
        .excl = flags.exclusive,
    }, 0o777) catch return error.AccessDenied;
    trackFd(fd, sub_path);
    return .{ .handle = fd, .flags = .{ .nonblocking = false } };
}

fn dirCreateFileAtomic(_: ?*anyopaque, _: Dir, _: []const u8, _: Dir.CreateFileAtomicOptions) Dir.CreateFileAtomicError!File.Atomic {
    return error.AccessDenied;
}

fn dirOpenFile(_: ?*anyopaque, _: Dir, sub_path: []const u8, flags: File.OpenFlags) File.OpenError!File {
    var path_buf: [1024]u8 = undefined;
    const path_z = toNullTerminated(sub_path, &path_buf) orelse return error.NameTooLong;
    const open_flags: io.OpenFlags = switch (flags.mode) {
        .read_only => .{ .read = true },
        .write_only => .{ .write = true },
        .read_write => .{ .read = true, .write = true },
    };
    const fd = io.open(path_z, open_flags, 0o777) catch return error.FileNotFound;
    trackFd(fd, sub_path);
    return .{ .handle = fd, .flags = .{ .nonblocking = false } };
}

fn dirClose(_: ?*anyopaque, dirs: []const Dir) void {
    for (dirs) |dir| {
        io.dclose(dir.handle) catch {};
    }
}

fn dirRead(_: ?*anyopaque, reader: *Dir.Reader, buffer: []Dir.Entry) Dir.Reader.Error!usize {
    var count: usize = 0;
    while (count < buffer.len) {
        var dirent: io.SceIoDirent = undefined;
        @memset(std.mem.asBytes(&dirent), 0);
        const has_entry = io.dread(reader.dir.handle, &dirent) catch {
            reader.state = .finished;
            break;
        };
        if (!has_entry) {
            reader.state = .finished;
            break;
        }
        const name_bytes: []const u8 = &dirent.d_name;
        const name_len = std.mem.indexOfScalar(u8, name_bytes, 0) orelse name_bytes.len;
        const name = name_bytes[0..name_len];
        // Skip . and ..
        if (std.mem.eql(u8, name, ".") or std.mem.eql(u8, name, "..")) continue;
        // Copy name into the reader buffer so Entry.name has stable storage
        const buf = reader.buffer;
        if (name_len > buf.len) break;
        @memcpy(buf[0..name_len], name_bytes[0..name_len]);
        const kind: File.Kind = if (dirent.d_stat.st_attr & 0x10 != 0) .directory else .file;
        buffer[count] = .{
            .name = buf[0..name_len],
            .kind = kind,
            .inode = 0,
        };
        count += 1;
    }
    return count;
}

fn dirRealPath(_: ?*anyopaque, _: Dir, _: []u8) Dir.RealPathError!usize {
    return error.OperationUnsupported;
}

fn dirRealPathFile(_: ?*anyopaque, _: Dir, _: []const u8, _: []u8) Dir.RealPathFileError!usize {
    return error.OperationUnsupported;
}

fn dirDeleteFile(_: ?*anyopaque, _: Dir, sub_path: []const u8) Dir.DeleteFileError!void {
    var path_buf: [1024]u8 = undefined;
    const path_z = toNullTerminated(sub_path, &path_buf) orelse return error.NameTooLong;
    io.remove(path_z) catch return error.AccessDenied;
}

fn dirDeleteDir(_: ?*anyopaque, _: Dir, sub_path: []const u8) Dir.DeleteDirError!void {
    var path_buf: [1024]u8 = undefined;
    const path_z = toNullTerminated(sub_path, &path_buf) orelse return error.NameTooLong;
    io.rmdir(path_z) catch return error.AccessDenied;
}

fn dirRename(_: ?*anyopaque, _: Dir, old_path: []const u8, _: Dir, new_path: []const u8) Dir.RenameError!void {
    var old_buf: [1024]u8 = undefined;
    var new_buf: [1024]u8 = undefined;
    const old_z = toNullTerminated(old_path, &old_buf) orelse return error.NameTooLong;
    const new_z = toNullTerminated(new_path, &new_buf) orelse return error.NameTooLong;
    io.rename(old_z, new_z) catch return error.AccessDenied;
}

fn dirRenamePreserve(_: ?*anyopaque, _: Dir, _: []const u8, _: Dir, _: []const u8) Dir.RenamePreserveError!void {
    return error.OperationUnsupported;
}

fn dirSymLink(_: ?*anyopaque, _: Dir, _: []const u8, _: []const u8, _: Dir.SymLinkFlags) Dir.SymLinkError!void {
    @panic("Io.dirSymLink not implemented");
}

fn dirReadLink(_: ?*anyopaque, _: Dir, _: []const u8, _: []u8) Dir.ReadLinkError!usize {
    @panic("Io.dirReadLink not implemented");
}

fn dirSetOwner(_: ?*anyopaque, _: Dir, _: ?File.Uid, _: ?File.Gid) Dir.SetOwnerError!void {
    @panic("Io.dirSetOwner not implemented");
}

fn dirSetFileOwner(_: ?*anyopaque, _: Dir, _: []const u8, _: ?File.Uid, _: ?File.Gid, _: Dir.SetFileOwnerOptions) Dir.SetFileOwnerError!void {
    @panic("Io.dirSetFileOwner not implemented");
}

fn dirSetPermissions(_: ?*anyopaque, _: Dir, _: Dir.Permissions) Dir.SetPermissionsError!void {
    // No-op: PSP permissions are simple, and sceIoChstat needs a path.
}

fn dirSetFilePermissions(_: ?*anyopaque, _: Dir, _: []const u8, _: File.Permissions, _: Dir.SetFilePermissionsOptions) Dir.SetFilePermissionsError!void {
    // No-op: PSP doesn't have a meaningful permission model.
}

fn dirSetTimestamps(_: ?*anyopaque, _: Dir, sub_path: []const u8, options: Dir.SetTimestampsOptions) Dir.SetTimestampsError!void {
    var path_buf: [1024]u8 = undefined;
    const path_z = toNullTerminated(sub_path, &path_buf) orelse return error.AccessDenied;

    // Read current stat so we can update only what's requested
    var stat_buf: io.SceIoStat = undefined;
    io.getstat(path_z, &stat_buf) catch return error.AccessDenied;

    var bits: c_int = 0;
    switch (options.access_timestamp) {
        .unchanged => {},
        .now => {
            stat_buf.st_atime = timestampToPspDateTime(now(null, .real));
            bits |= 0x04; // PSP_CST_ATIME
        },
        .new => |ts| {
            stat_buf.st_atime = timestampToPspDateTime(ts);
            bits |= 0x04;
        },
    }
    switch (options.modify_timestamp) {
        .unchanged => {},
        .now => {
            stat_buf.st_mtime = timestampToPspDateTime(now(null, .real));
            bits |= 0x02; // PSP_CST_MTIME
        },
        .new => |ts| {
            stat_buf.st_mtime = timestampToPspDateTime(ts);
            bits |= 0x02;
        },
    }

    if (bits != 0) {
        io.chstat(path_z, &stat_buf, @intCast(bits)) catch return error.AccessDenied;
    }
}

fn dirHardLink(_: ?*anyopaque, _: Dir, _: []const u8, _: Dir, _: []const u8, _: Dir.HardLinkOptions) Dir.HardLinkError!void {
    @panic("Io.dirHardLink not implemented");
}

// -- File operations ---------------------------------------------------

fn fileStat(_: ?*anyopaque, file: File) File.StatError!File.Stat {
    const path = lookupFdPath(file.handle) orelse return error.AccessDenied;
    var path_buf: [1024]u8 = undefined;
    const path_z = toNullTerminated(path, &path_buf) orelse return error.AccessDenied;
    var stat_buf: io.SceIoStat = undefined;
    io.getstat(path_z, &stat_buf) catch return error.AccessDenied;
    return sceIoStatToFileStat(&stat_buf);
}

fn fileLength(_: ?*anyopaque, file: File) File.LengthError!u64 {
    const fd = file.handle;
    // Save current position
    const cur = io.lseek32(fd, 0, .cur) catch return error.AccessDenied;
    // Seek to end
    const end = io.lseek32(fd, 0, .end) catch return error.AccessDenied;
    // Restore position
    _ = io.lseek32(fd, cur, .set) catch {};
    return @intCast(end);
}

fn fileClose(_: ?*anyopaque, files: []const File) void {
    for (files) |f| {
        untrackFd(f.handle);
        io.close(f.handle) catch {};
    }
}

fn fileWritePositional(_: ?*anyopaque, file: File, header: []const u8, data: []const []const u8, splat: usize, offset: u64) File.WritePositionalError!usize {
    const fd = file.handle;
    // Save current position
    const cur = io.lseek32(fd, 0, .cur) catch return error.Unseekable;
    // Seek to offset
    _ = io.lseek32(fd, @intCast(offset), .set) catch return error.Unseekable;

    var written: usize = 0;

    // Write header
    if (header.len > 0) {
        written += pspWrite(fd, header) catch {
            _ = io.lseek32(fd, cur, .set) catch {};
            return error.InputOutput;
        };
    }

    // Write data slices
    for (data[0..data.len -| 1]) |slice| {
        if (slice.len > 0) {
            written += pspWrite(fd, slice) catch {
                _ = io.lseek32(fd, cur, .set) catch {};
                return error.InputOutput;
            };
        }
    }

    // Write last slice repeated `splat` times
    if (data.len > 0) {
        const pattern = data[data.len - 1];
        if (pattern.len > 0) {
            var i: usize = 0;
            while (i < splat) : (i += 1) {
                written += pspWrite(fd, pattern) catch {
                    _ = io.lseek32(fd, cur, .set) catch {};
                    return error.InputOutput;
                };
            }
        }
    }

    // Restore position
    _ = io.lseek32(fd, cur, .set) catch {};
    return written;
}

fn fileWriteFileStreaming(_: ?*anyopaque, file: File, header: []const u8, reader: *Io.File.Reader, limit: Io.Limit) File.Writer.WriteFileError!usize {
    const fd = file.handle;
    var written: usize = 0;

    // Write header
    if (header.len > 0) {
        written += pspWrite(fd, header) catch return error.InputOutput;
    }

    // Copy from reader to fd in chunks
    var buf: [4096]u8 = undefined;
    var remaining: usize = @intFromEnum(limit);
    while (remaining > 0) {
        const to_read = @min(buf.len, remaining);
        var bufs = [_][]u8{buf[0..to_read]};
        const n = reader.interface.readVec(&bufs) catch return error.InputOutput;
        if (n == 0) break;
        const w = pspWrite(fd, buf[0..n]) catch return error.InputOutput;
        written += w;
        remaining -|= n;
    }
    return written;
}

fn fileWriteFilePositional(_: ?*anyopaque, file: File, header: []const u8, reader: *Io.File.Reader, limit: Io.Limit, offset: u64) File.WriteFilePositionalError!usize {
    const fd = file.handle;
    // Save current position
    const cur = io.lseek32(fd, 0, .cur) catch return error.Unseekable;
    // Seek to offset
    _ = io.lseek32(fd, @intCast(offset), .set) catch return error.Unseekable;

    var written: usize = 0;

    // Write header
    if (header.len > 0) {
        written += pspWrite(fd, header) catch {
            _ = io.lseek32(fd, cur, .set) catch {};
            return error.InputOutput;
        };
    }

    // Copy from reader to fd in chunks
    var buf: [4096]u8 = undefined;
    var remaining: usize = @intFromEnum(limit);
    while (remaining > 0) {
        const to_read = @min(buf.len, remaining);
        var bufs = [_][]u8{buf[0..to_read]};
        const n = reader.interface.readVec(&bufs) catch {
            _ = io.lseek32(fd, cur, .set) catch {};
            return error.InputOutput;
        };
        if (n == 0) break;
        const w = pspWrite(fd, buf[0..n]) catch {
            _ = io.lseek32(fd, cur, .set) catch {};
            return error.InputOutput;
        };
        written += w;
        remaining -|= n;
    }

    // Restore position
    _ = io.lseek32(fd, cur, .set) catch {};
    return written;
}

fn fileReadPositional(_: ?*anyopaque, file: File, bufs: []const []u8, offset: u64) File.ReadPositionalError!usize {
    const fd = file.handle;
    // Save current position
    const cur = io.lseek32(fd, 0, .cur) catch return error.Unseekable;
    // Seek to offset
    _ = io.lseek32(fd, @intCast(offset), .set) catch return error.Unseekable;

    var total: usize = 0;
    for (bufs) |buf| {
        if (buf.len > 0) {
            const n = io.read(fd, buf) catch {
                _ = io.lseek32(fd, cur, .set) catch {};
                return error.InputOutput;
            };
            total += n;
            if (n < buf.len) break;
        }
    }

    // Restore position
    _ = io.lseek32(fd, cur, .set) catch {};
    return total;
}

fn fileSeekBy(_: ?*anyopaque, file: File, offset: i64) File.SeekError!void {
    _ = io.lseek32(file.handle, @intCast(offset), .cur) catch return error.Unseekable;
}

fn fileSeekTo(_: ?*anyopaque, file: File, offset: u64) File.SeekError!void {
    _ = io.lseek32(file.handle, @intCast(offset), .set) catch return error.Unseekable;
}

fn fileSync(_: ?*anyopaque, _: File) File.SyncError!void {
    // sceIoSync takes a device name, not an fd. Sync the memory stick.
    io.sync("ms0:", 0) catch {};
}

fn fileIsTty(_: ?*anyopaque, file: File) Io.Cancelable!bool {
    return file.handle == stdin_fd or file.handle == stdout_fd or file.handle == stderr_fd;
}

fn fileEnableAnsiEscapeCodes(_: ?*anyopaque, _: File) File.EnableAnsiEscapeCodesError!void {
    @panic("Io.fileEnableAnsiEscapeCodes not implemented");
}

fn fileSupportsAnsiEscapeCodes(_: ?*anyopaque, _: File) Io.Cancelable!bool {
    @panic("Io.fileSupportsAnsiEscapeCodes not implemented");
}

fn fileSetLength(_: ?*anyopaque, _: File, _: u64) File.SetLengthError!void {
    return error.NonResizable;
}

fn fileSetOwner(_: ?*anyopaque, _: File, _: ?File.Uid, _: ?File.Gid) File.SetOwnerError!void {
    @panic("Io.fileSetOwner not implemented");
}

fn fileSetPermissions(_: ?*anyopaque, _: File, _: File.Permissions) File.SetPermissionsError!void {
    // No-op: PSP doesn't have a meaningful per-file permission model.
}

fn fileSetTimestamps(_: ?*anyopaque, file: File, options: File.SetTimestampsOptions) File.SetTimestampsError!void {
    const path = lookupFdPath(file.handle) orelse return error.AccessDenied;
    var path_buf: [1024]u8 = undefined;
    const path_z = toNullTerminated(path, &path_buf) orelse return error.AccessDenied;

    var stat_buf: io.SceIoStat = undefined;
    io.getstat(path_z, &stat_buf) catch return error.AccessDenied;

    var bits: c_int = 0;
    switch (options.access_timestamp) {
        .unchanged => {},
        .now => {
            stat_buf.st_atime = timestampToPspDateTime(now(null, .real));
            bits |= 0x04;
        },
        .new => |ts| {
            stat_buf.st_atime = timestampToPspDateTime(ts);
            bits |= 0x04;
        },
    }
    switch (options.modify_timestamp) {
        .unchanged => {},
        .now => {
            stat_buf.st_mtime = timestampToPspDateTime(now(null, .real));
            bits |= 0x02;
        },
        .new => |ts| {
            stat_buf.st_mtime = timestampToPspDateTime(ts);
            bits |= 0x02;
        },
    }

    if (bits != 0) {
        io.chstat(path_z, &stat_buf, @intCast(bits)) catch return error.AccessDenied;
    }
}

fn fileLock(_: ?*anyopaque, _: File, _: File.Lock) File.LockError!void {
    @panic("Io.fileLock not implemented");
}

fn fileTryLock(_: ?*anyopaque, _: File, _: File.Lock) File.LockError!bool {
    @panic("Io.fileTryLock not implemented");
}

fn fileUnlock(_: ?*anyopaque, _: File) void {
    @panic("Io.fileUnlock not implemented");
}

fn fileDowngradeLock(_: ?*anyopaque, _: File) File.DowngradeLockError!void {
    @panic("Io.fileDowngradeLock not implemented");
}

fn fileRealPath(_: ?*anyopaque, _: File, _: []u8) File.RealPathError!usize {
    return error.OperationUnsupported;
}

fn fileHardLink(_: ?*anyopaque, _: File, _: Dir, _: []const u8, _: File.HardLinkOptions) File.HardLinkError!void {
    @panic("Io.fileHardLink not implemented");
}

fn fileMemoryMapCreate(_: ?*anyopaque, _: File, _: File.MemoryMap.CreateOptions) File.MemoryMap.CreateError!File.MemoryMap {
    @panic("Io.fileMemoryMapCreate not implemented");
}

fn fileMemoryMapDestroy(_: ?*anyopaque, _: *File.MemoryMap) void {
    @panic("Io.fileMemoryMapDestroy not implemented");
}

fn fileMemoryMapSetLength(_: ?*anyopaque, _: *File.MemoryMap, _: usize) File.MemoryMap.SetLengthError!void {
    @panic("Io.fileMemoryMapSetLength not implemented");
}

fn fileMemoryMapRead(_: ?*anyopaque, _: *File.MemoryMap) File.ReadPositionalError!void {
    @panic("Io.fileMemoryMapRead not implemented");
}

fn fileMemoryMapWrite(_: ?*anyopaque, _: *File.MemoryMap) File.WritePositionalError!void {
    @panic("Io.fileMemoryMapWrite not implemented");
}

// -- Process -----------------------------------------------------------

fn processExecutableOpen(_: ?*anyopaque, _: File.OpenFlags) std.process.OpenExecutableError!File {
    @panic("Io.processExecutableOpen not implemented");
}

fn processExecutablePath(_: ?*anyopaque, _: []u8) std.process.ExecutablePathError!usize {
    @panic("Io.processExecutablePath not implemented");
}

// -- Stderr ------------------------------------------------------------

fn lockStderr(_: ?*anyopaque, _: ?Terminal.Mode) Io.Cancelable!Io.LockedStderr {
    stderr_locked = true;
    return .{
        .file_writer = &stderr_writer,
        .terminal_mode = .no_color,
    };
}

fn tryLockStderr(_: ?*anyopaque, _: ?Terminal.Mode) Io.Cancelable!?Io.LockedStderr {
    if (stderr_locked) return null;
    stderr_locked = true;
    return .{
        .file_writer = &stderr_writer,
        .terminal_mode = .no_color,
    };
}

fn unlockStderr(_: ?*anyopaque) void {
    stderr_writer.interface.flush() catch {};
    stderr_writer.interface.end = 0;
    stderr_writer.interface.buffer = &.{};
    stderr_locked = false;
}

// -- CWD ---------------------------------------------------------------

// PSP has no getcwd syscall, so we track cwd in a module-level buffer.
// Defaults to "ms0:/" (memory stick root).
var cwd_buf: [1024]u8 = undefined;
var cwd_len: usize = 5;
var cwd_initialized: bool = false;

fn ensureCwdInit() void {
    if (!cwd_initialized) {
        @memcpy(cwd_buf[0..5], "ms0:/");
        cwd_initialized = true;
    }
}

fn processCurrentPath(_: ?*anyopaque, buffer: []u8) std.process.CurrentPathError!usize {
    ensureCwdInit();
    if (buffer.len < cwd_len) return error.NameTooLong;
    @memcpy(buffer[0..cwd_len], cwd_buf[0..cwd_len]);
    return cwd_len;
}

fn processSetCurrentDir(_: ?*anyopaque, _: Dir) std.process.SetCurrentDirError!void {
    // PSP has no fchdir equivalent -- cannot set cwd from a directory handle.
    return error.OperationUnsupported;
}

fn processSetCurrentPath(_: ?*anyopaque, path: []const u8) std.process.SetCurrentPathError!void {
    if (path.len >= cwd_buf.len) return error.NameTooLong;
    var path_z_buf: [1024]u8 = undefined;
    const path_z = toNullTerminated(path, &path_z_buf) orelse return error.NameTooLong;
    io.chdir(path_z) catch return error.FileNotFound;
    // Update tracked cwd
    @memcpy(cwd_buf[0..path.len], path);
    cwd_len = path.len;
    cwd_initialized = true;
}

fn processReplace(_: ?*anyopaque, _: std.process.ReplaceOptions) std.process.ReplaceError {
    @panic("Io.processReplace not implemented");
}

fn processReplacePath(_: ?*anyopaque, _: Dir, _: std.process.ReplaceOptions) std.process.ReplaceError {
    @panic("Io.processReplacePath not implemented");
}

fn processSpawn(_: ?*anyopaque, _: std.process.SpawnOptions) std.process.SpawnError!std.process.Child {
    @panic("Io.processSpawn not implemented");
}

fn processSpawnPath(_: ?*anyopaque, _: Dir, _: std.process.SpawnOptions) std.process.SpawnError!std.process.Child {
    @panic("Io.processSpawnPath not implemented");
}

fn childWait(_: ?*anyopaque, _: *std.process.Child) std.process.Child.WaitError!std.process.Child.Term {
    @panic("Io.childWait not implemented");
}

fn childKill(_: ?*anyopaque, _: *std.process.Child) void {
    @panic("Io.childKill not implemented");
}

fn progressParentFile(_: ?*anyopaque) std.Progress.ParentFileError!File {
    @panic("Io.progressParentFile not implemented");
}

// -- Time/Random -------------------------------------------------------

fn now(_: ?*anyopaque, clock: Io.Clock) Io.Timestamp {
    switch (clock) {
        .real, .awake, .boot => {
            var tick: u64 = 0;
            rtc.get_current_tick(&tick) catch {};
            const tick_i96: i96 = @intCast(tick);
            // PSP ticks are microseconds since year 1 AD.
            // Convert to nanoseconds since Unix epoch.
            const ns = tick_i96 * 1000 - psp_epoch_offset_s * 1_000_000_000;
            return .{ .nanoseconds = ns };
        },
        .cpu_process, .cpu_thread => {
            // No per-process/thread CPU clock on PSP; return zero.
            return .{ .nanoseconds = 0 };
        },
    }
}

fn clockResolution(_: ?*anyopaque, clock: Io.Clock) Io.Clock.ResolutionError!Io.Duration {
    switch (clock) {
        .real, .awake, .boot => {
            // sceRtcGetTickResolution() returns 1_000_000 (microsecond ticks).
            // Resolution = 1 microsecond = 1000 nanoseconds.
            return .{ .nanoseconds = 1000 };
        },
        .cpu_process, .cpu_thread => {
            return error.ClockUnavailable;
        },
    }
}

fn sleep(_: ?*anyopaque, timeout: Io.Timeout) Io.Cancelable!void {
    const us: u32 = switch (timeout) {
        .none => return,
        .duration => |d| blk: {
            const ns = d.raw.nanoseconds;
            if (ns <= 0) break :blk 0;
            const val = @divTrunc(ns, 1000);
            break :blk if (val > std.math.maxInt(u32)) std.math.maxInt(u32) else @intCast(val);
        },
        .deadline => |dl| blk: {
            var tick: u64 = 0;
            rtc.get_current_tick(&tick) catch {};
            const now_ns: i96 = @as(i96, @intCast(tick)) * 1000 - psp_epoch_offset_s * 1_000_000_000;
            const delta = dl.raw.nanoseconds - now_ns;
            if (delta <= 0) break :blk 0;
            const val = @divTrunc(delta, 1000);
            break :blk if (val > std.math.maxInt(u32)) std.math.maxInt(u32) else @intCast(val);
        },
    };
    if (us > 0) {
        kernel.delay_thread(us) catch {};
    }
}

var mt_ctx: kernel.Mt19937Context = undefined;
var mt_initialized: bool = false;

fn fillRandom(buf: []u8) void {
    if (!mt_initialized) {
        var tick: u64 = 0;
        rtc.get_current_tick(&tick) catch {};
        kernel.mt19937_init(&mt_ctx, @truncate(tick)) catch {};
        mt_initialized = true;
    }
    var i: usize = 0;
    while (i + 4 <= buf.len) : (i += 4) {
        const val = kernel.mt19937_uint(&mt_ctx);
        buf[i] = @truncate(val);
        buf[i + 1] = @truncate(val >> 8);
        buf[i + 2] = @truncate(val >> 16);
        buf[i + 3] = @truncate(val >> 24);
    }
    if (i < buf.len) {
        const val = kernel.mt19937_uint(&mt_ctx);
        var shift: u5 = 0;
        while (i < buf.len) : (i += 1) {
            buf[i] = @truncate(val >> shift);
            shift +%= 8;
        }
    }
}

fn random(_: ?*anyopaque, buf: []u8) void {
    fillRandom(buf);
}

fn randomSecure(_: ?*anyopaque, buf: []u8) Io.RandomSecureError!void {
    fillRandom(buf);
}

// -- Network -----------------------------------------------------------

fn ipAddressToSockaddr(addr: *const net.IpAddress) psp_net.sockaddr_in {
    switch (addr.*) {
        .ip4 => |ip4| {
            return .{
                .sin_port = @byteSwap(ip4.port), // host->network byte order
                .sin_addr = .{ .s_addr = @bitCast(ip4.bytes) },
            };
        },
        .ip6 => |ip6| {
            // Map IPv6-mapped IPv4 to plain IPv4; pure IPv6 not supported on PSP
            if (net.Ip4Address.fromIp6(ip6)) |ip4| {
                return .{
                    .sin_port = @byteSwap(ip4.port),
                    .sin_addr = .{ .s_addr = @bitCast(ip4.bytes) },
                };
            }
            // No IPv6 on PSP -- fall back to unspecified
            return .{
                .sin_port = @byteSwap(ip6.port),
                .sin_addr = .{ .s_addr = 0 },
            };
        },
    }
}

fn sockaddrToIpAddress(sa: *const psp_net.sockaddr_in) net.IpAddress {
    return .{ .ip4 = .{
        .bytes = @bitCast(sa.sin_addr.s_addr),
        .port = @byteSwap(sa.sin_port),
    } };
}

fn socketModeToType(mode: net.Socket.Mode) i32 {
    return switch (mode) {
        .stream => net_utils.SOCK_STREAM,
        .dgram => net_utils.SOCK_DGRAM,
        else => net_utils.SOCK_STREAM,
    };
}

fn netListenIp(_: ?*anyopaque, addr: *const net.IpAddress, options: net.IpAddress.ListenOptions) net.IpAddress.ListenError!net.Socket {
    const sock_type = socketModeToType(options.mode);
    const fd = psp_net.inet_socket(net_utils.AF_INET, sock_type, 0) catch
        return error.SystemResources;

    if (options.reuse_address) {
        const one: c_int = 1;
        psp_net.inet_setsockopt(fd, net_utils.SOL_SOCKET, net_utils.SO_REUSEADDR, &one, @sizeOf(c_int)) catch {};
    }

    var sa = ipAddressToSockaddr(addr);
    psp_net.inet_bind(fd, &sa, @sizeOf(psp_net.sockaddr_in)) catch {
        psp_net.inet_close(fd) catch {};
        return error.AddressInUse;
    };

    psp_net.inet_listen(fd, @intCast(options.kernel_backlog)) catch {
        psp_net.inet_close(fd) catch {};
        return error.AddressInUse;
    };

    // Read back the bound address (for ephemeral port)
    var bound_sa: psp_net.sockaddr_in = undefined;
    var sa_len: psp_net.socklen_t = @sizeOf(psp_net.sockaddr_in);
    psp_net.inet_getsockname(fd, &bound_sa, &sa_len) catch {};

    return .{
        .handle = fd,
        .address = sockaddrToIpAddress(&bound_sa),
    };
}

fn netAccept(_: ?*anyopaque, handle: net.Socket.Handle, _: net.Server.AcceptOptions) net.Server.AcceptError!net.Socket {
    var client_sa: psp_net.sockaddr_in = undefined;
    var sa_len: psp_net.socklen_t = @sizeOf(psp_net.sockaddr_in);
    const client_fd = psp_net.inet_accept(handle, &client_sa, &sa_len) catch
        return error.ConnectionAborted;
    return .{
        .handle = client_fd,
        .address = sockaddrToIpAddress(&client_sa),
    };
}

fn netBindIp(_: ?*anyopaque, addr: *const net.IpAddress, options: net.IpAddress.BindOptions) net.IpAddress.BindError!net.Socket {
    const sock_type = socketModeToType(options.mode);
    const fd = psp_net.inet_socket(net_utils.AF_INET, sock_type, 0) catch
        return error.SystemResources;

    var sa = ipAddressToSockaddr(addr);
    psp_net.inet_bind(fd, &sa, @sizeOf(psp_net.sockaddr_in)) catch {
        psp_net.inet_close(fd) catch {};
        return error.AddressInUse;
    };

    var bound_sa: psp_net.sockaddr_in = undefined;
    var sa_len: psp_net.socklen_t = @sizeOf(psp_net.sockaddr_in);
    psp_net.inet_getsockname(fd, &bound_sa, &sa_len) catch {};

    return .{
        .handle = fd,
        .address = sockaddrToIpAddress(&bound_sa),
    };
}

fn netConnectIp(_: ?*anyopaque, addr: *const net.IpAddress, options: net.IpAddress.ConnectOptions) net.IpAddress.ConnectError!net.Socket {
    const sock_type = socketModeToType(options.mode);
    const fd = psp_net.inet_socket(net_utils.AF_INET, sock_type, 0) catch
        return error.SystemResources;

    var sa = ipAddressToSockaddr(addr);
    psp_net.inet_connect(fd, &sa, @sizeOf(psp_net.sockaddr_in)) catch {
        psp_net.inet_close(fd) catch {};
        return error.ConnectionRefused;
    };

    return .{
        .handle = fd,
        .address = addr.*,
    };
}

fn netListenUnix(_: ?*anyopaque, _: *const net.UnixAddress, _: net.UnixAddress.ListenOptions) net.UnixAddress.ListenError!net.Socket.Handle {
    return error.AddressFamilyUnsupported;
}

fn netConnectUnix(_: ?*anyopaque, _: *const net.UnixAddress) net.UnixAddress.ConnectError!net.Socket.Handle {
    return error.AddressFamilyUnsupported;
}

fn netSocketCreatePair(_: ?*anyopaque, _: net.Socket.CreatePairOptions) net.Socket.CreatePairError![2]net.Socket {
    return error.AddressFamilyUnsupported;
}

fn netSend(_: ?*anyopaque, handle: net.Socket.Handle, messages: []net.OutgoingMessage, flags: net.SendFlags) struct { ?net.Socket.SendError, usize } {
    _ = flags;
    var total: usize = 0;
    for (messages) |*msg| {
        const sa = ipAddressToSockaddr(msg.address);
        const sent: isize = @bitCast(psp_net.inet_sendto(
            handle,
            msg.data_ptr,
            msg.data_len,
            0,
            &sa,
            @sizeOf(psp_net.sockaddr_in),
        ));
        if (sent < 0) return .{ error.SystemResources, total };
        const sent_u: usize = @intCast(sent);
        msg.data_len = sent_u;
        total += sent_u;
    }
    return .{ null, total };
}

fn netRead(_: ?*anyopaque, handle: net.Socket.Handle, bufs: [][]u8) net.Stream.Reader.Error!usize {
    var total: usize = 0;
    for (bufs) |buf| {
        const n: isize = @bitCast(psp_net.inet_recv(handle, buf.ptr, buf.len, 0));
        if (n < 0) return error.ConnectionResetByPeer;
        if (n == 0) break;
        total += @as(usize, @intCast(n));
        if (@as(usize, @intCast(n)) < buf.len) break;
    }
    return total;
}

fn netWrite(_: ?*anyopaque, handle: net.Socket.Handle, header: []const u8, payload: []const []const u8, splat: usize) net.Stream.Writer.Error!usize {
    var total: usize = 0;
    if (header.len > 0) {
        const n: isize = @bitCast(psp_net.inet_send(handle, header.ptr, header.len, 0));
        if (n < 0) return error.ConnectionResetByPeer;
        total += @as(usize, @intCast(n));
    }
    // Send all but the last element once
    if (payload.len > 1) {
        for (payload[0 .. payload.len - 1]) |chunk| {
            if (chunk.len == 0) continue;
            const n: isize = @bitCast(psp_net.inet_send(handle, chunk.ptr, chunk.len, 0));
            if (n < 0) return error.ConnectionResetByPeer;
            total += @as(usize, @intCast(n));
        }
    }
    // Send the last element `splat` times
    if (payload.len > 0) {
        const last = payload[payload.len - 1];
        if (last.len > 0) {
            for (0..splat) |_| {
                const n: isize = @bitCast(psp_net.inet_send(handle, last.ptr, last.len, 0));
                if (n < 0) return error.ConnectionResetByPeer;
                total += @as(usize, @intCast(n));
            }
        }
    }
    return total;
}

fn netWriteFile(_: ?*anyopaque, handle: net.Socket.Handle, header: []const u8, file_reader: *Io.File.Reader, limit: Io.Limit) net.Stream.Writer.WriteFileError!usize {
    var total: usize = 0;
    if (header.len > 0) {
        const n: isize = @bitCast(psp_net.inet_send(handle, header.ptr, header.len, 0));
        if (n < 0) return error.NetworkDown;
        total += @as(usize, @intCast(n));
    }
    const max_bytes = @intFromEnum(limit);
    var buf: [4096]u8 = undefined;
    while (max_bytes == 0 or total < max_bytes) {
        const to_read = if (max_bytes == 0) buf.len else @min(buf.len, max_bytes - total);
        var read_bufs = [_][]u8{buf[0..to_read]};
        const got = file_reader.interface.readVec(&read_bufs) catch break;
        if (got == 0) break;
        const n: isize = @bitCast(psp_net.inet_send(handle, &buf, got, 0));
        if (n < 0) return error.NetworkDown;
        total += @as(usize, @intCast(n));
    }
    return total;
}

fn netClose(_: ?*anyopaque, handles: []const net.Socket.Handle) void {
    for (handles) |handle| {
        psp_net.inet_close(handle) catch {};
    }
}

fn netShutdown(_: ?*anyopaque, handle: net.Socket.Handle, how: net.ShutdownHow) net.ShutdownError!void {
    const psp_how: i32 = switch (how) {
        .recv => net_utils.SHUT_RD,
        .send => net_utils.SHUT_WR,
        .both => net_utils.SHUT_RDWR,
    };
    psp_net.inet_shutdown(handle, psp_how) catch
        return error.ConnectionResetByPeer;
}

fn netInterfaceNameResolve(_: ?*anyopaque, _: *const net.Interface.Name) net.Interface.Name.ResolveError!net.Interface {
    // PSP has only one network interface (WiFi)
    return .{ .index = 1 };
}

fn netInterfaceName(_: ?*anyopaque, _: net.Interface) net.Interface.NameError!net.Interface.Name {
    // PSP IFNAMESIZE is void, so Name.max_len = 0 -- return zero-length name
    return .{ .bytes = .{} };
}

fn netLookup(_: ?*anyopaque, host_name: net.HostName, results: *Io.Queue(net.HostName.LookupResult), options: net.HostName.LookupOptions) net.HostName.LookupError!void {
    // Contract: must close `results` before returning, even on error.
    defer results.close(psp_io);

    // Try parsing as literal IP first
    if (net.IpAddress.parseLiteral(host_name.bytes)) |parsed| {
        var addr = parsed;
        addr.setPort(options.port);
        _ = results.put(psp_io, &.{.{ .address = addr }}, 1) catch return error.NameServerFailure;
        return;
    } else |_| {}

    // DNS resolve via sceNetResolver
    var rid: i32 = 0;
    var resolver_buf: [1024]u8 = undefined;
    psp_net.resolver_create(&rid, &resolver_buf, resolver_buf.len) catch
        return error.NameServerFailure;
    defer psp_net.resolver_delete(rid) catch {};

    // Null-terminate the hostname
    var name_buf: [256]u8 = undefined;
    if (host_name.bytes.len >= name_buf.len) return error.UnknownHostName;
    @memcpy(name_buf[0..host_name.bytes.len], host_name.bytes);
    name_buf[host_name.bytes.len] = 0;

    var resolved_addr: psp_net.in_addr = undefined;
    psp_net.resolver_start_ntoa(rid, @ptrCast(&name_buf), &resolved_addr, 5, 3) catch
        return error.UnknownHostName;

    const ip4_bytes: [4]u8 = @bitCast(resolved_addr.s_addr);
    const result: net.HostName.LookupResult = .{ .address = .{ .ip4 = .{
        .bytes = ip4_bytes,
        .port = options.port,
    } } };
    _ = results.put(psp_io, &.{result}, 1) catch return error.NameServerFailure;
}
