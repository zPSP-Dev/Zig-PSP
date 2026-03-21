const std = @import("std");

const Io = std.Io;
const Dir = std.Io.Dir;
const File = std.Io.File;
const Terminal = std.Io.Terminal;
const net = std.Io.net;

const stdio = @import("../c/module/StdioForUser.zig");
const rtc = @import("../c/module/sceRtc.zig");
const threadman = @import("../c/module/ThreadManForUser.zig");
const utils_mod = @import("../c/module/UtilsForUser.zig");
const io_mgr = @import("../c/module/IoFileMgrForUser.zig");
const c_types = @import("../c/types.zig");

const SceUID = c_types.SceUID;

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

fn toNullTerminated(path: []const u8, buf: *[1024]u8) ?[*c]const i8 {
    if (path.len >= buf.len) return null;
    @memcpy(buf[0..path.len], path);
    buf[path.len] = 0;
    return @ptrCast(buf[0..path.len :0].ptr);
}

fn crashHandler(_: ?*anyopaque) void {
    @panic("Io.crashHandler not implemented");
}

// ── Global State ──────────────────────────────────────────────────────

var cancel_protection: std.Io.CancelProtection = .unblocked;
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

pub fn init() void {
    stdin_fd = stdio.sceKernelStdin();
    stdout_fd = stdio.sceKernelStdout();
    stderr_fd = stdio.sceKernelStderr();
    stderr_writer.file = .{ .handle = stderr_fd, .flags = .{ .nonblocking = false } };
}

// ── fd→path tracking table ────────────────────────────────────────────

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

// ── ScePspDateTime ↔ Io.Timestamp helpers ─────────────────────────────

// PSP RTC epoch is 2000-01-01 00:00:00 UTC.
// Offset from Unix epoch (1970-01-01) to PSP epoch in seconds.
const psp_epoch_offset_s: i96 = 946684800;

fn pspDateTimeToTimestamp(dt: c_types.ScePspDateTime) Io.Timestamp {
    var tick: u64 = 0;
    _ = rtc.sceRtcGetTick(&dt, &tick);
    // tick = microseconds since PSP epoch (2000-01-01)
    const tick_i96: i96 = @intCast(tick);
    const ns = tick_i96 * 1000 + psp_epoch_offset_s * 1_000_000_000;
    return .{ .nanoseconds = ns };
}

fn timestampToPspDateTime(ts: Io.Timestamp) c_types.ScePspDateTime {
    // Convert nanoseconds since Unix epoch → microseconds since PSP epoch
    const ns = ts.nanoseconds;
    const us_since_psp: i96 = @divTrunc(ns, 1000) - psp_epoch_offset_s * 1_000_000;
    var tick: u64 = if (us_since_psp < 0) 0 else @intCast(us_since_psp);
    var dt: c_types.ScePspDateTime = undefined;
    _ = rtc.sceRtcSetTick(&dt, &tick);
    return dt;
}

fn sceIoStatToFileStat(psp_stat: *const c_types.SceIoStat) File.Stat {
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

// ── PSP I/O constants ─────────────────────────────────────────────────

const PSP_O_RDONLY = 0x0001;
const PSP_O_WRONLY = 0x0002;
const PSP_O_RDWR = PSP_O_RDONLY | PSP_O_WRONLY;
const PSP_O_CREAT = 0x0200;
const PSP_O_TRUNC = 0x0400;
const PSP_O_APPEND = 0x0100;
const PSP_O_EXCL = 0x0800;

const PSP_SEEK_SET = 0;
const PSP_SEEK_CUR = 1;
const PSP_SEEK_END = 2;

// ── Async/Concurrency (N/A on PSP) ───────────────────────────────────

fn async(
    _: ?*anyopaque,
    _: []u8,
    _: std.mem.Alignment,
    _: []const u8,
    _: std.mem.Alignment,
    _: *const fn (*const anyopaque, *anyopaque) void,
) ?*Io.AnyFuture {
    @panic("Io.async not implemented");
}

fn concurrent(
    _: ?*anyopaque,
    _: usize,
    _: std.mem.Alignment,
    _: []const u8,
    _: std.mem.Alignment,
    _: *const fn (*const anyopaque, *anyopaque) void,
) Io.ConcurrentError!*Io.AnyFuture {
    @panic("Io.concurrent not implemented");
}

fn await(
    _: ?*anyopaque,
    _: *Io.AnyFuture,
    _: []u8,
    _: std.mem.Alignment,
) void {
    @panic("Io.await not implemented");
}

fn cancel(
    _: ?*anyopaque,
    _: *Io.AnyFuture,
    _: []u8,
    _: std.mem.Alignment,
) void {
    @panic("Io.cancel not implemented");
}

fn groupAsync(
    _: ?*anyopaque,
    _: *Io.Group,
    _: []const u8,
    _: std.mem.Alignment,
    _: *const fn (*const anyopaque) void,
) void {
    @panic("Io.groupAsync not implemented");
}

fn groupConcurrent(
    _: ?*anyopaque,
    _: *Io.Group,
    _: []const u8,
    _: std.mem.Alignment,
    _: *const fn (*const anyopaque) void,
) Io.ConcurrentError!void {
    @panic("Io.groupConcurrent not implemented");
}

fn groupAwait(_: ?*anyopaque, _: *Io.Group, _: *anyopaque) Io.Cancelable!void {
    @panic("Io.groupAwait not implemented");
}

fn groupCancel(_: ?*anyopaque, _: *Io.Group, _: *anyopaque) void {
    @panic("Io.groupCancel not implemented");
}

fn recancel(_: ?*anyopaque) void {
    @panic("Io.recancel not implemented");
}

// ── Cancellation/Sync ─────────────────────────────────────────────────

fn swapCancelProtection(_: ?*anyopaque, new_val: Io.CancelProtection) Io.CancelProtection {
    const old = cancel_protection;
    cancel_protection = new_val;
    return old;
}

fn checkCancel(_: ?*anyopaque) Io.Cancelable!void {
    @panic("Io.checkCancel not implemented");
}

fn futexWait(_: ?*anyopaque, _: *const u32, _: u32, _: Io.Timeout) Io.Cancelable!void {
    @panic("Io.futexWait not implemented");
}

fn futexWaitUncancelable(_: ?*anyopaque, _: *const u32, _: u32) void {
    @panic("Io.futexWaitUncancelable not implemented");
}

fn futexWake(_: ?*anyopaque, _: *const u32, _: u32) void {
    @panic("Io.futexWake not implemented");
}

// ── Operate (Multiplexed I/O) ─────────────────────────────────────────

fn pspWrite(fd: SceUID, buf: []const u8) error{WriteFailed}!usize {
    const ret = io_mgr.sceIoWrite(fd, buf.ptr, buf.len);
    if (ret < 0) return error.WriteFailed;
    return @intCast(ret);
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
                    const ret = io_mgr.sceIoRead(fd, buf.ptr, @intCast(buf.len));
                    if (ret < 0) return .{ .file_read_streaming = error.InputOutput };
                    total += @intCast(ret);
                    if (@as(usize, @intCast(ret)) < buf.len) break;
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

// ── Batch (N/A on PSP) ───────────────────────────────────────────────

fn batchAwaitAsync(_: ?*anyopaque, _: *Io.Batch) Io.Cancelable!void {
    @panic("Io.batchAwaitAsync not implemented");
}

fn batchAwaitConcurrent(_: ?*anyopaque, _: *Io.Batch, _: Io.Timeout) Io.Batch.AwaitConcurrentError!void {
    @panic("Io.batchAwaitConcurrent not implemented");
}

fn batchCancel(_: ?*anyopaque, _: *Io.Batch) void {
    @panic("Io.batchCancel not implemented");
}

// ── Directory operations ──────────────────────────────────────────────

fn dirCreateDir(_: ?*anyopaque, _: Dir, sub_path: []const u8, _: Dir.Permissions) Dir.CreateDirError!void {
    var path_buf: [1024]u8 = undefined;
    const path_z = toNullTerminated(sub_path, &path_buf) orelse return error.NameTooLong;
    const ret = io_mgr.sceIoMkdir(path_z, 0o777);
    if (ret < 0) return error.AccessDenied;
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
                const ret = io_mgr.sceIoMkdir(@ptrCast(path_buf[0..i :0].ptr), 0o777);
                if (ret >= 0) created_any = true;
                // Ignore errors (directory may already exist)
                path_buf[i] = '/';
            }
            i += 1;
            continue;
        }
        i += 1;
    }
    // Create the final component
    path_buf[sub_path.len] = 0;
    const ret = io_mgr.sceIoMkdir(@ptrCast(path_buf[0..sub_path.len :0].ptr), 0o777);
    if (ret >= 0) return .created;
    if (created_any) return .created;
    // If the final mkdir failed, it might already exist
    var stat_buf: c_types.SceIoStat = undefined;
    const stat_ret = io_mgr.sceIoGetstat(@ptrCast(path_buf[0..sub_path.len :0].ptr), &stat_buf);
    if (stat_ret >= 0 and stat_buf.st_attr & 0x10 != 0) return .existed;
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
                _ = io_mgr.sceIoMkdir(@ptrCast(path_buf[0..i :0].ptr), 0o777);
                path_buf[i] = '/';
            }
            i += 1;
            continue;
        }
        i += 1;
    }
    // Create final component
    path_buf[sub_path.len] = 0;
    _ = io_mgr.sceIoMkdir(@ptrCast(path_buf[0..sub_path.len :0].ptr), 0o777);

    // Open it
    const fd = io_mgr.sceIoDopen(@ptrCast(path_buf[0..sub_path.len :0].ptr));
    if (fd < 0) return error.FileNotFound;
    return .{ .handle = fd };
}

fn dirOpenDir(_: ?*anyopaque, _: Dir, sub_path: []const u8, _: Dir.OpenOptions) Dir.OpenError!Dir {
    var path_buf: [1024]u8 = undefined;
    const path_z = toNullTerminated(sub_path, &path_buf) orelse return error.NameTooLong;
    const fd = io_mgr.sceIoDopen(path_z);
    if (fd < 0) return error.FileNotFound;
    return .{ .handle = fd };
}

fn dirStat(_: ?*anyopaque, d: Dir) Dir.StatError!Dir.Stat {
    const path = lookupFdPath(d.handle) orelse return error.AccessDenied;
    var path_buf: [1024]u8 = undefined;
    const path_z = toNullTerminated(path, &path_buf) orelse return error.AccessDenied;
    var stat_buf: c_types.SceIoStat = undefined;
    const ret = io_mgr.sceIoGetstat(path_z, &stat_buf);
    if (ret < 0) return error.AccessDenied;
    return sceIoStatToFileStat(&stat_buf);
}

fn dirStatFile(_: ?*anyopaque, _: Dir, sub_path: []const u8, _: Dir.StatFileOptions) Dir.StatFileError!File.Stat {
    var path_buf: [1024]u8 = undefined;
    const path_z = toNullTerminated(sub_path, &path_buf) orelse return error.NameTooLong;
    var stat_buf: c_types.SceIoStat = undefined;
    const ret = io_mgr.sceIoGetstat(path_z, &stat_buf);
    if (ret < 0) return error.FileNotFound;
    return sceIoStatToFileStat(&stat_buf);
}

fn dirAccess(_: ?*anyopaque, _: Dir, sub_path: []const u8, _: Dir.AccessOptions) Dir.AccessError!void {
    var path_buf: [1024]u8 = undefined;
    const path_z = toNullTerminated(sub_path, &path_buf) orelse return error.NameTooLong;
    var stat_buf: c_types.SceIoStat = undefined;
    const ret = io_mgr.sceIoGetstat(path_z, &stat_buf);
    if (ret < 0) return error.FileNotFound;
}

fn dirCreateFile(_: ?*anyopaque, _: Dir, sub_path: []const u8, flags: File.CreateFlags) File.OpenError!File {
    var path_buf: [1024]u8 = undefined;
    const path_z = toNullTerminated(sub_path, &path_buf) orelse return error.NameTooLong;
    var psp_flags: c_int = PSP_O_CREAT;
    if (flags.read) {
        psp_flags |= PSP_O_RDWR;
    } else {
        psp_flags |= PSP_O_WRONLY;
    }
    if (flags.truncate) psp_flags |= PSP_O_TRUNC;
    if (flags.exclusive) psp_flags |= PSP_O_EXCL;
    const fd = io_mgr.sceIoOpen(path_z, psp_flags, 0o777);
    if (fd < 0) return error.AccessDenied;
    trackFd(fd, sub_path);
    return .{ .handle = fd, .flags = .{ .nonblocking = false } };
}

fn dirCreateFileAtomic(_: ?*anyopaque, _: Dir, _: []const u8, _: Dir.CreateFileAtomicOptions) Dir.CreateFileAtomicError!File.Atomic {
    return error.AccessDenied;
}

fn dirOpenFile(_: ?*anyopaque, _: Dir, sub_path: []const u8, flags: File.OpenFlags) File.OpenError!File {
    var path_buf: [1024]u8 = undefined;
    const path_z = toNullTerminated(sub_path, &path_buf) orelse return error.NameTooLong;
    const psp_flags: c_int = switch (flags.mode) {
        .read_only => PSP_O_RDONLY,
        .write_only => PSP_O_WRONLY,
        .read_write => PSP_O_RDWR,
    };
    const fd = io_mgr.sceIoOpen(path_z, psp_flags, 0o777);
    if (fd < 0) return error.FileNotFound;
    trackFd(fd, sub_path);
    return .{ .handle = fd, .flags = .{ .nonblocking = false } };
}

fn dirClose(_: ?*anyopaque, dirs: []const Dir) void {
    for (dirs) |dir| {
        _ = io_mgr.sceIoDclose(dir.handle);
    }
}

fn dirRead(_: ?*anyopaque, reader: *Dir.Reader, buffer: []Dir.Entry) Dir.Reader.Error!usize {
    var count: usize = 0;
    while (count < buffer.len) {
        var dirent: c_types.SceIoDirent = undefined;
        @memset(std.mem.asBytes(&dirent), 0);
        const ret = io_mgr.sceIoDread(reader.dir.handle, &dirent);
        if (ret <= 0) {
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
    const ret = io_mgr.sceIoRemove(path_z);
    if (ret < 0) return error.AccessDenied;
}

fn dirDeleteDir(_: ?*anyopaque, _: Dir, sub_path: []const u8) Dir.DeleteDirError!void {
    var path_buf: [1024]u8 = undefined;
    const path_z = toNullTerminated(sub_path, &path_buf) orelse return error.NameTooLong;
    const ret = io_mgr.sceIoRmdir(path_z);
    if (ret < 0) return error.AccessDenied;
}

fn dirRename(_: ?*anyopaque, _: Dir, old_path: []const u8, _: Dir, new_path: []const u8) Dir.RenameError!void {
    var old_buf: [1024]u8 = undefined;
    var new_buf: [1024]u8 = undefined;
    const old_z = toNullTerminated(old_path, &old_buf) orelse return error.NameTooLong;
    const new_z = toNullTerminated(new_path, &new_buf) orelse return error.NameTooLong;
    const ret = io_mgr.sceIoRename(old_z, new_z);
    if (ret < 0) return error.AccessDenied;
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
    var stat_buf: c_types.SceIoStat = undefined;
    const gret = io_mgr.sceIoGetstat(path_z, &stat_buf);
    if (gret < 0) return error.AccessDenied;

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
        const ret = io_mgr.sceIoChstat(path_z, &stat_buf, bits);
        if (ret < 0) return error.AccessDenied;
    }
}

fn dirHardLink(_: ?*anyopaque, _: Dir, _: []const u8, _: Dir, _: []const u8, _: Dir.HardLinkOptions) Dir.HardLinkError!void {
    @panic("Io.dirHardLink not implemented");
}

// ── File operations ───────────────────────────────────────────────────

fn fileStat(_: ?*anyopaque, file: File) File.StatError!File.Stat {
    const path = lookupFdPath(file.handle) orelse return error.AccessDenied;
    var path_buf: [1024]u8 = undefined;
    const path_z = toNullTerminated(path, &path_buf) orelse return error.AccessDenied;
    var stat_buf: c_types.SceIoStat = undefined;
    const ret = io_mgr.sceIoGetstat(path_z, &stat_buf);
    if (ret < 0) return error.AccessDenied;
    return sceIoStatToFileStat(&stat_buf);
}

fn fileLength(_: ?*anyopaque, file: File) File.LengthError!u64 {
    const fd = file.handle;
    // Save current position
    const cur = io_mgr.sceIoLseek32(fd, 0, PSP_SEEK_CUR);
    if (cur < 0) return error.AccessDenied;
    // Seek to end
    const end = io_mgr.sceIoLseek32(fd, 0, PSP_SEEK_END);
    if (end < 0) return error.AccessDenied;
    // Restore position
    _ = io_mgr.sceIoLseek32(fd, cur, PSP_SEEK_SET);
    return @intCast(end);
}

fn fileClose(_: ?*anyopaque, files: []const File) void {
    for (files) |f| {
        untrackFd(f.handle);
        _ = io_mgr.sceIoClose(f.handle);
    }
}

fn fileWritePositional(_: ?*anyopaque, file: File, header: []const u8, data: []const []const u8, splat: usize, offset: u64) File.WritePositionalError!usize {
    const fd = file.handle;
    // Save current position
    const cur = io_mgr.sceIoLseek32(fd, 0, PSP_SEEK_CUR);
    if (cur < 0) return error.Unseekable;
    // Seek to offset
    const seek_ret = io_mgr.sceIoLseek32(fd, @intCast(offset), PSP_SEEK_SET);
    if (seek_ret < 0) return error.Unseekable;

    var written: usize = 0;

    // Write header
    if (header.len > 0) {
        written += pspWrite(fd, header) catch {
            _ = io_mgr.sceIoLseek32(fd, cur, PSP_SEEK_SET);
            return error.InputOutput;
        };
    }

    // Write data slices
    for (data[0..data.len -| 1]) |slice| {
        if (slice.len > 0) {
            written += pspWrite(fd, slice) catch {
                _ = io_mgr.sceIoLseek32(fd, cur, PSP_SEEK_SET);
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
                    _ = io_mgr.sceIoLseek32(fd, cur, PSP_SEEK_SET);
                    return error.InputOutput;
                };
            }
        }
    }

    // Restore position
    _ = io_mgr.sceIoLseek32(fd, cur, PSP_SEEK_SET);
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
    const cur = io_mgr.sceIoLseek32(fd, 0, PSP_SEEK_CUR);
    if (cur < 0) return error.Unseekable;
    // Seek to offset
    const seek_ret = io_mgr.sceIoLseek32(fd, @intCast(offset), PSP_SEEK_SET);
    if (seek_ret < 0) return error.Unseekable;

    var written: usize = 0;

    // Write header
    if (header.len > 0) {
        written += pspWrite(fd, header) catch {
            _ = io_mgr.sceIoLseek32(fd, cur, PSP_SEEK_SET);
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
            _ = io_mgr.sceIoLseek32(fd, cur, PSP_SEEK_SET);
            return error.InputOutput;
        };
        if (n == 0) break;
        const w = pspWrite(fd, buf[0..n]) catch {
            _ = io_mgr.sceIoLseek32(fd, cur, PSP_SEEK_SET);
            return error.InputOutput;
        };
        written += w;
        remaining -|= n;
    }

    // Restore position
    _ = io_mgr.sceIoLseek32(fd, cur, PSP_SEEK_SET);
    return written;
}

fn fileReadPositional(_: ?*anyopaque, file: File, bufs: []const []u8, offset: u64) File.ReadPositionalError!usize {
    const fd = file.handle;
    // Save current position
    const cur = io_mgr.sceIoLseek32(fd, 0, PSP_SEEK_CUR);
    if (cur < 0) return error.Unseekable;
    // Seek to offset
    const seek_ret = io_mgr.sceIoLseek32(fd, @intCast(offset), PSP_SEEK_SET);
    if (seek_ret < 0) return error.Unseekable;

    var total: usize = 0;
    for (bufs) |buf| {
        if (buf.len > 0) {
            const ret = io_mgr.sceIoRead(fd, buf.ptr, @intCast(buf.len));
            if (ret < 0) {
                _ = io_mgr.sceIoLseek32(fd, cur, PSP_SEEK_SET);
                return error.InputOutput;
            }
            total += @intCast(ret);
            if (@as(usize, @intCast(ret)) < buf.len) break;
        }
    }

    // Restore position
    _ = io_mgr.sceIoLseek32(fd, cur, PSP_SEEK_SET);
    return total;
}

fn fileSeekBy(_: ?*anyopaque, file: File, offset: i64) File.SeekError!void {
    const off32: c_int = @intCast(offset);
    const ret = io_mgr.sceIoLseek32(file.handle, off32, PSP_SEEK_CUR);
    if (ret < 0) return error.Unseekable;
}

fn fileSeekTo(_: ?*anyopaque, file: File, offset: u64) File.SeekError!void {
    const off32: c_int = @intCast(offset);
    const ret = io_mgr.sceIoLseek32(file.handle, off32, PSP_SEEK_SET);
    if (ret < 0) return error.Unseekable;
}

fn fileSync(_: ?*anyopaque, _: File) File.SyncError!void {
    // sceIoSync takes a device name, not an fd. Sync the memory stick.
    _ = io_mgr.sceIoSync(@ptrCast("ms0:"), 0);
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

    var stat_buf: c_types.SceIoStat = undefined;
    const gret = io_mgr.sceIoGetstat(path_z, &stat_buf);
    if (gret < 0) return error.AccessDenied;

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
        const ret = io_mgr.sceIoChstat(path_z, &stat_buf, bits);
        if (ret < 0) return error.AccessDenied;
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

// ── Process ───────────────────────────────────────────────────────────

fn processExecutableOpen(_: ?*anyopaque, _: File.OpenFlags) std.process.OpenExecutableError!File {
    @panic("Io.processExecutableOpen not implemented");
}

fn processExecutablePath(_: ?*anyopaque, _: []u8) std.process.ExecutablePathError!usize {
    @panic("Io.processExecutablePath not implemented");
}

// ── Stderr ────────────────────────────────────────────────────────────

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

// ── CWD ───────────────────────────────────────────────────────────────

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
    // PSP has no fchdir equivalent — cannot set cwd from a directory handle.
    return error.OperationUnsupported;
}

fn processSetCurrentPath(_: ?*anyopaque, path: []const u8) std.process.SetCurrentPathError!void {
    if (path.len >= cwd_buf.len) return error.NameTooLong;
    var path_z_buf: [1024]u8 = undefined;
    const path_z = toNullTerminated(path, &path_z_buf) orelse return error.NameTooLong;
    const ret = io_mgr.sceIoChdir(path_z);
    if (ret < 0) return error.FileNotFound;
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

// ── Time/Random ───────────────────────────────────────────────────────

fn now(_: ?*anyopaque, clock: Io.Clock) Io.Timestamp {
    switch (clock) {
        .real, .awake, .boot => {
            var tick: u64 = 0;
            _ = rtc.sceRtcGetCurrentTick(&tick);
            const tick_i96: i96 = @intCast(tick);
            // PSP ticks are microseconds since 2000-01-01.
            // Convert to nanoseconds since Unix epoch.
            const ns = tick_i96 * 1000 + psp_epoch_offset_s * 1_000_000_000;
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
            _ = rtc.sceRtcGetCurrentTick(&tick);
            const now_ns: i96 = @as(i96, @intCast(tick)) * 1000 + psp_epoch_offset_s * 1_000_000_000;
            const delta = dl.raw.nanoseconds - now_ns;
            if (delta <= 0) break :blk 0;
            const val = @divTrunc(delta, 1000);
            break :blk if (val > std.math.maxInt(u32)) std.math.maxInt(u32) else @intCast(val);
        },
    };
    if (us > 0) {
        _ = threadman.sceKernelDelayThread(us);
    }
}

const SceKernelUtilsMt19937Context = c_types.SceKernelUtilsMt19937Context;
var mt_ctx: SceKernelUtilsMt19937Context = undefined;
var mt_initialized: bool = false;

fn fillRandom(buf: []u8) void {
    if (!mt_initialized) {
        var tick: u64 = 0;
        _ = rtc.sceRtcGetCurrentTick(&tick);
        _ = utils_mod.sceKernelUtilsMt19937Init(&mt_ctx, @truncate(tick));
        mt_initialized = true;
    }
    var i: usize = 0;
    while (i + 4 <= buf.len) : (i += 4) {
        const val = utils_mod.sceKernelUtilsMt19937UInt(&mt_ctx);
        buf[i] = @truncate(val);
        buf[i + 1] = @truncate(val >> 8);
        buf[i + 2] = @truncate(val >> 16);
        buf[i + 3] = @truncate(val >> 24);
    }
    if (i < buf.len) {
        const val = utils_mod.sceKernelUtilsMt19937UInt(&mt_ctx);
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

// ── Network (not yet implemented) ─────────────────────────────────────

fn netListenIp(_: ?*anyopaque, _: *const net.IpAddress, _: net.IpAddress.ListenOptions) net.IpAddress.ListenError!net.Socket {
    @panic("Io.netListenIp not implemented");
}

fn netAccept(_: ?*anyopaque, _: net.Socket.Handle, _: net.Server.AcceptOptions) net.Server.AcceptError!net.Socket {
    @panic("Io.netAccept not implemented");
}

fn netBindIp(_: ?*anyopaque, _: *const net.IpAddress, _: net.IpAddress.BindOptions) net.IpAddress.BindError!net.Socket {
    @panic("Io.netBindIp not implemented");
}

fn netConnectIp(_: ?*anyopaque, _: *const net.IpAddress, _: net.IpAddress.ConnectOptions) net.IpAddress.ConnectError!net.Socket {
    @panic("Io.netConnectIp not implemented");
}

fn netListenUnix(_: ?*anyopaque, _: *const net.UnixAddress, _: net.UnixAddress.ListenOptions) net.UnixAddress.ListenError!net.Socket.Handle {
    @panic("Io.netListenUnix not implemented");
}

fn netConnectUnix(_: ?*anyopaque, _: *const net.UnixAddress) net.UnixAddress.ConnectError!net.Socket.Handle {
    @panic("Io.netConnectUnix not implemented");
}

fn netSocketCreatePair(_: ?*anyopaque, _: net.Socket.CreatePairOptions) net.Socket.CreatePairError![2]net.Socket {
    @panic("Io.netSocketCreatePair not implemented");
}

fn netSend(_: ?*anyopaque, _: net.Socket.Handle, _: []net.OutgoingMessage, _: net.SendFlags) struct { ?net.Socket.SendError, usize } {
    @panic("Io.netSend not implemented");
}

fn netRead(_: ?*anyopaque, _: net.Socket.Handle, _: [][]u8) net.Stream.Reader.Error!usize {
    @panic("Io.netRead not implemented");
}

fn netWrite(_: ?*anyopaque, _: net.Socket.Handle, _: []const u8, _: []const []const u8, _: usize) net.Stream.Writer.Error!usize {
    @panic("Io.netWrite not implemented");
}

fn netWriteFile(_: ?*anyopaque, _: net.Socket.Handle, _: []const u8, _: *Io.File.Reader, _: Io.Limit) net.Stream.Writer.WriteFileError!usize {
    @panic("Io.netWriteFile not implemented");
}

fn netClose(_: ?*anyopaque, _: []const net.Socket.Handle) void {
    @panic("Io.netClose not implemented");
}

fn netShutdown(_: ?*anyopaque, _: net.Socket.Handle, _: net.ShutdownHow) net.ShutdownError!void {
    @panic("Io.netShutdown not implemented");
}

fn netInterfaceNameResolve(_: ?*anyopaque, _: *const net.Interface.Name) net.Interface.Name.ResolveError!net.Interface {
    @panic("Io.netInterfaceNameResolve not implemented");
}

fn netInterfaceName(_: ?*anyopaque, _: net.Interface) net.Interface.NameError!net.Interface.Name {
    @panic("Io.netInterfaceName not implemented");
}

fn netLookup(_: ?*anyopaque, _: net.HostName, _: *Io.Queue(net.HostName.LookupResult), _: net.HostName.LookupOptions) net.HostName.LookupError!void {
    @panic("Io.netLookup not implemented");
}
