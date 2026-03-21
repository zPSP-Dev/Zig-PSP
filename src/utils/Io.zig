const std = @import("std");

const Io = std.Io;
const Dir = std.Io.Dir;
const File = std.Io.File;
const Terminal = std.Io.Terminal;
const net = std.Io.net;

const stdio = @import("../c/module/StdioForUser.zig");

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

fn crashHandler(_: ?*anyopaque) void {
    @panic("Io.crashHandler not implemented");
}

// MAGIC GLOBAL STATE BLOCK
var cancel_protection: std.Io.CancelProtection = .unblocked;
var stderr_locked: bool = false;
const SceUID = @import("../c/types.zig").SceUID;
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

// FUNCTION BLOCK

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

fn swapCancelProtection(_: ?*anyopaque, new: Io.CancelProtection) Io.CancelProtection {
    const old = cancel_protection;
    cancel_protection = new;
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

const io_mgr = @import("../c/module/IoFileMgrForUser.zig");

fn pspWrite(fd: SceUID, buf: []const u8) error{WriteFailed}!usize {
    const ret = io_mgr.sceIoWrite(fd, buf.ptr, buf.len);
    if (ret < 0) return error.WriteFailed;
    return @intCast(ret);
}

fn operate(_: ?*anyopaque, op: Io.Operation) Io.Cancelable!Io.Operation.Result {
    switch (op) {
        .device_io_control => @panic("Io.operate: Device io_ctl Not Implemented"),
        .net_receive => @panic("Io.operate: net_receive Not Implemented"),
        .file_read_streaming => @panic("Io.operate: file_read_streaming Not Implemented"),
        .file_write_streaming => |w| {
            const fd = w.file.handle;
            if (fd == 2) @panic("A!");
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

fn batchAwaitAsync(_: ?*anyopaque, _: *Io.Batch) Io.Cancelable!void {
    @panic("Io.batchAwaitAsync not implemented");
}

fn batchAwaitConcurrent(_: ?*anyopaque, _: *Io.Batch, _: Io.Timeout) Io.Batch.AwaitConcurrentError!void {
    @panic("Io.batchAwaitConcurrent not implemented");
}

fn batchCancel(_: ?*anyopaque, _: *Io.Batch) void {
    @panic("Io.batchCancel not implemented");
}

fn dirCreateDir(_: ?*anyopaque, _: Dir, _: []const u8, _: Dir.Permissions) Dir.CreateDirError!void {
    @panic("Io.dirCreateDir not implemented");
}

fn dirCreateDirPath(_: ?*anyopaque, _: Dir, _: []const u8, _: Dir.Permissions) Dir.CreateDirPathError!Dir.CreatePathStatus {
    @panic("Io.dirCreateDirPath not implemented");
}

fn dirCreateDirPathOpen(_: ?*anyopaque, _: Dir, _: []const u8, _: Dir.Permissions, _: Dir.OpenOptions) Dir.CreateDirPathOpenError!Dir {
    @panic("Io.dirCreateDirPathOpen not implemented");
}

fn dirOpenDir(_: ?*anyopaque, _: Dir, _: []const u8, _: Dir.OpenOptions) Dir.OpenError!Dir {
    @panic("Io.dirOpenDir not implemented");
}

fn dirStat(_: ?*anyopaque, _: Dir) Dir.StatError!Dir.Stat {
    @panic("Io.dirStat not implemented");
}

fn dirStatFile(_: ?*anyopaque, _: Dir, _: []const u8, _: Dir.StatFileOptions) Dir.StatFileError!File.Stat {
    @panic("Io.dirStatFile not implemented");
}

fn dirAccess(_: ?*anyopaque, _: Dir, _: []const u8, _: Dir.AccessOptions) Dir.AccessError!void {
    @panic("Io.dirAccess not implemented");
}

fn dirCreateFile(_: ?*anyopaque, _: Dir, _: []const u8, _: File.CreateFlags) File.OpenError!File {
    @panic("Io.dirCreateFile not implemented");
}

fn dirCreateFileAtomic(_: ?*anyopaque, _: Dir, _: []const u8, _: Dir.CreateFileAtomicOptions) Dir.CreateFileAtomicError!File.Atomic {
    @panic("Io.dirCreateFileAtomic not implemented");
}

fn dirOpenFile(_: ?*anyopaque, _: Dir, _: []const u8, _: File.OpenFlags) File.OpenError!File {
    @panic("Io.dirOpenFile not implemented");
}

fn dirClose(_: ?*anyopaque, _: []const Dir) void {
    @panic("Io.dirClose not implemented");
}

fn dirRead(_: ?*anyopaque, _: *Dir.Reader, _: []Dir.Entry) Dir.Reader.Error!usize {
    @panic("Io.dirRead not implemented");
}

fn dirRealPath(_: ?*anyopaque, _: Dir, _: []u8) Dir.RealPathError!usize {
    @panic("Io.dirRealPath not implemented");
}

fn dirRealPathFile(_: ?*anyopaque, _: Dir, _: []const u8, _: []u8) Dir.RealPathFileError!usize {
    @panic("Io.dirRealPathFile not implemented");
}

fn dirDeleteFile(_: ?*anyopaque, _: Dir, _: []const u8) Dir.DeleteFileError!void {
    @panic("Io.dirDeleteFile not implemented");
}

fn dirDeleteDir(_: ?*anyopaque, _: Dir, _: []const u8) Dir.DeleteDirError!void {
    @panic("Io.dirDeleteDir not implemented");
}

fn dirRename(_: ?*anyopaque, _: Dir, _: []const u8, _: Dir, _: []const u8) Dir.RenameError!void {
    @panic("Io.dirRename not implemented");
}

fn dirRenamePreserve(_: ?*anyopaque, _: Dir, _: []const u8, _: Dir, _: []const u8) Dir.RenamePreserveError!void {
    @panic("Io.dirRenamePreserve not implemented");
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
    @panic("Io.dirSetPermissions not implemented");
}

fn dirSetFilePermissions(_: ?*anyopaque, _: Dir, _: []const u8, _: File.Permissions, _: Dir.SetFilePermissionsOptions) Dir.SetFilePermissionsError!void {
    @panic("Io.dirSetFilePermissions not implemented");
}

fn dirSetTimestamps(_: ?*anyopaque, _: Dir, _: []const u8, _: Dir.SetTimestampsOptions) Dir.SetTimestampsError!void {
    @panic("Io.dirSetTimestamps not implemented");
}

fn dirHardLink(_: ?*anyopaque, _: Dir, _: []const u8, _: Dir, _: []const u8, _: Dir.HardLinkOptions) Dir.HardLinkError!void {
    @panic("Io.dirHardLink not implemented");
}

fn fileStat(_: ?*anyopaque, _: File) File.StatError!File.Stat {
    @panic("Io.fileStat not implemented");
}

fn fileLength(_: ?*anyopaque, _: File) File.LengthError!u64 {
    @panic("Io.fileLength not implemented");
}

fn fileClose(_: ?*anyopaque, _: []const File) void {
    @panic("Io.fileClose not implemented");
}

fn fileWritePositional(_: ?*anyopaque, _: File, _: []const u8, _: []const []const u8, _: usize, _: u64) File.WritePositionalError!usize {
    @panic("Io.fileWritePositional not implemented");
}

fn fileWriteFileStreaming(_: ?*anyopaque, _: File, _: []const u8, _: *Io.File.Reader, _: Io.Limit) File.Writer.WriteFileError!usize {
    @panic("Io.fileWriteFileStreaming not implemented");
}

fn fileWriteFilePositional(_: ?*anyopaque, _: File, _: []const u8, _: *Io.File.Reader, _: Io.Limit, _: u64) File.WriteFilePositionalError!usize {
    @panic("Io.fileWriteFilePositional not implemented");
}

fn fileReadPositional(_: ?*anyopaque, _: File, _: []const []u8, _: u64) File.ReadPositionalError!usize {
    @panic("Io.fileReadPositional not implemented");
}

fn fileSeekBy(_: ?*anyopaque, _: File, _: i64) File.SeekError!void {
    @panic("Io.fileSeekBy not implemented");
}

fn fileSeekTo(_: ?*anyopaque, _: File, _: u64) File.SeekError!void {
    @panic("Io.fileSeekTo not implemented");
}

fn fileSync(_: ?*anyopaque, _: File) File.SyncError!void {
    @panic("Io.fileSync not implemented");
}

fn fileIsTty(_: ?*anyopaque, _: File) Io.Cancelable!bool {
    @panic("Io.fileIsTty not implemented");
}

fn fileEnableAnsiEscapeCodes(_: ?*anyopaque, _: File) File.EnableAnsiEscapeCodesError!void {
    @panic("Io.fileEnableAnsiEscapeCodes not implemented");
}

fn fileSupportsAnsiEscapeCodes(_: ?*anyopaque, _: File) Io.Cancelable!bool {
    @panic("Io.fileSupportsAnsiEscapeCodes not implemented");
}

fn fileSetLength(_: ?*anyopaque, _: File, _: u64) File.SetLengthError!void {
    @panic("Io.fileSetLength not implemented");
}

fn fileSetOwner(_: ?*anyopaque, _: File, _: ?File.Uid, _: ?File.Gid) File.SetOwnerError!void {
    @panic("Io.fileSetOwner not implemented");
}

fn fileSetPermissions(_: ?*anyopaque, _: File, _: File.Permissions) File.SetPermissionsError!void {
    @panic("Io.fileSetPermissions not implemented");
}

fn fileSetTimestamps(_: ?*anyopaque, _: File, _: File.SetTimestampsOptions) File.SetTimestampsError!void {
    @panic("Io.fileSetTimestamps not implemented");
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
    @panic("Io.fileRealPath not implemented");
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

fn processExecutableOpen(_: ?*anyopaque, _: File.OpenFlags) std.process.OpenExecutableError!File {
    @panic("Io.processExecutableOpen not implemented");
}

fn processExecutablePath(_: ?*anyopaque, _: []u8) std.process.ExecutablePathError!usize {
    @panic("Io.processExecutablePath not implemented");
}

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

fn processCurrentPath(_: ?*anyopaque, _: []u8) std.process.CurrentPathError!usize {
    @panic("Io.processCurrentPath not implemented");
}

fn processSetCurrentDir(_: ?*anyopaque, _: Dir) std.process.SetCurrentDirError!void {
    @panic("Io.processSetCurrentDir not implemented");
}

fn processSetCurrentPath(_: ?*anyopaque, _: []const u8) std.process.SetCurrentPathError!void {
    @panic("Io.processSetCurrentPath not implemented");
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

fn now(_: ?*anyopaque, _: Io.Clock) Io.Timestamp {
    @panic("Io.now not implemented");
}

fn clockResolution(_: ?*anyopaque, _: Io.Clock) Io.Clock.ResolutionError!Io.Duration {
    @panic("Io.clockResolution not implemented");
}

fn sleep(_: ?*anyopaque, _: Io.Timeout) Io.Cancelable!void {
    @panic("Io.sleep not implemented");
}

fn random(_: ?*anyopaque, _: []u8) void {
    @panic("Io.random not implemented");
}

fn randomSecure(_: ?*anyopaque, _: []u8) Io.RandomSecureError!void {
    @panic("Io.randomSecure not implemented");
}

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
