// File I/O and standard streams
//
// Wraps:
//   c/module/IoFileMgrForUser.zig
//   c/module/StdioForUser.zig

const c = @import("../c/modules.zig");
const internal = @import("internal.zig");
const check = internal.check;
const checkPositive = internal.checkPositive;
const fromCode = internal.fromCode;
const ci = internal.ci;
const Error = internal.Error;

// -- Re-exported types --------------------------------------------------

pub const SceUID = c.types.SceUID;
pub const SceIoStat = c.types.SceIoStat;
pub const SceIoDirent = c.types.SceIoDirent;

// -- Enums --------------------------------------------------------------

pub const OpenFlags = packed struct(u32) {
    read: bool = false,
    write: bool = false,
    nblock: bool = false,
    dir_open: bool = false,
    _pad0: u4 = 0,
    append: bool = false,
    create: bool = false,
    truncate: bool = false,
    excl: bool = false,
    _pad1: u3 = 0,
    no_wait: bool = false,
    _pad2: u16 = 0,
};

pub const SeekWhence = enum(c_int) {
    set = 0,
    cur = 1,
    end = 2,
};

pub const IoAssignPerms = enum(c_int) {
    rdwr = 0,
    rdonly = 1,
};

// -- File operations ----------------------------------------------------

pub fn open(file: [*:0]const u8, flags: OpenFlags, mode: u32) Error!SceUID {
    return checkPositive(SceUID, c.IoFileMgrForUser.sceIoOpen(@ptrCast(file), @bitCast(flags), @bitCast(mode)));
}

pub fn open_async(file: [*:0]const u8, flags: OpenFlags, mode: u32) Error!SceUID {
    return checkPositive(SceUID, c.IoFileMgrForUser.sceIoOpenAsync(@ptrCast(file), @bitCast(flags), @bitCast(mode)));
}

pub fn close(fd: SceUID) Error!void {
    return check(c.IoFileMgrForUser.sceIoClose(fd));
}

pub fn close_async(fd: SceUID) Error!void {
    return check(c.IoFileMgrForUser.sceIoCloseAsync(fd));
}

pub fn read(fd: SceUID, buf: []u8) Error!usize {
    return checkPositive(usize, c.IoFileMgrForUser.sceIoRead(fd, buf.ptr, buf.len));
}

pub fn read_async(fd: SceUID, buf: []u8) Error!void {
    return check(c.IoFileMgrForUser.sceIoReadAsync(fd, buf.ptr, buf.len));
}

pub fn write(fd: SceUID, buf: []const u8) Error!usize {
    return checkPositive(usize, c.IoFileMgrForUser.sceIoWrite(fd, buf.ptr, buf.len));
}

pub fn write_async(fd: SceUID, buf: []const u8) Error!void {
    return check(c.IoFileMgrForUser.sceIoWriteAsync(fd, buf.ptr, buf.len));
}

/// Seek using 64-bit offset.
pub fn lseek(fd: SceUID, offset: i64, whence: SeekWhence) i64 {
    return c.IoFileMgrForUser.sceIoLseek(fd, offset, @intFromEnum(whence));
}

pub fn lseek_async(fd: SceUID, offset: i64, whence: SeekWhence) Error!void {
    return check(c.IoFileMgrForUser.sceIoLseekAsync(fd, offset, @intFromEnum(whence)));
}

/// Seek using 32-bit offset.
pub fn lseek32(fd: SceUID, offset: i32, whence: SeekWhence) Error!i32 {
    const ret = c.IoFileMgrForUser.sceIoLseek32(fd, @as(c_int, offset), @intFromEnum(whence));
    return checkPositive(i32, ret);
}

pub fn lseek32_async(fd: SceUID, offset: i32, whence: SeekWhence) Error!void {
    return check(c.IoFileMgrForUser.sceIoLseek32Async(fd, @as(c_int, offset), @intFromEnum(whence)));
}

// -- Ioctl --------------------------------------------------------------

pub fn ioctl(fd: SceUID, cmd: u32, indata: ?*anyopaque, inlen: u32, outdata: ?*anyopaque, outlen: u32) Error!void {
    return check(c.IoFileMgrForUser.sceIoIoctl(fd, cmd, indata, ci(inlen), outdata, ci(outlen)));
}

pub fn ioctl_async(fd: SceUID, cmd: u32, indata: ?*anyopaque, inlen: u32, outdata: ?*anyopaque, outlen: u32) Error!void {
    return check(c.IoFileMgrForUser.sceIoIoctlAsync(fd, cmd, indata, ci(inlen), outdata, ci(outlen)));
}

// -- Directory operations -----------------------------------------------

pub fn dopen(dirname: [*:0]const u8) Error!SceUID {
    return checkPositive(SceUID, c.IoFileMgrForUser.sceIoDopen(@ptrCast(dirname)));
}

/// Read a directory entry. Returns the entry, or null if no more entries.
pub fn dread(fd: SceUID, dir: *SceIoDirent) Error!bool {
    const ret = c.IoFileMgrForUser.sceIoDread(fd, dir);
    if (ret < 0) {
        @branchHint(.unlikely);
        return fromCode(@bitCast(ret));
    }
    return ret > 0;
}

pub fn dclose(fd: SceUID) Error!void {
    return check(c.IoFileMgrForUser.sceIoDclose(fd));
}

// -- Filesystem operations ----------------------------------------------

pub fn remove(file: [*:0]const u8) Error!void {
    return check(c.IoFileMgrForUser.sceIoRemove(@ptrCast(file)));
}

pub fn mkdir(dir: [*:0]const u8, mode: u32) Error!void {
    return check(c.IoFileMgrForUser.sceIoMkdir(@ptrCast(dir), @bitCast(mode)));
}

pub fn rmdir(path: [*:0]const u8) Error!void {
    return check(c.IoFileMgrForUser.sceIoRmdir(@ptrCast(path)));
}

pub fn chdir(path: [*:0]const u8) Error!void {
    return check(c.IoFileMgrForUser.sceIoChdir(@ptrCast(path)));
}

pub fn rename(oldname: [*:0]const u8, newname: [*:0]const u8) Error!void {
    return check(c.IoFileMgrForUser.sceIoRename(@ptrCast(oldname), @ptrCast(newname)));
}

pub fn sync(device: [*:0]const u8, unk: u32) Error!void {
    return check(c.IoFileMgrForUser.sceIoSync(@ptrCast(device), unk));
}

pub fn getstat(file: [*:0]const u8, stat: *SceIoStat) Error!void {
    return check(c.IoFileMgrForUser.sceIoGetstat(@ptrCast(file), stat));
}

pub fn chstat(file: [*:0]const u8, stat: *SceIoStat, bits: u32) Error!void {
    return check(c.IoFileMgrForUser.sceIoChstat(@ptrCast(file), stat, ci(bits)));
}

// -- Device operations --------------------------------------------------

pub fn devctl(dev: [*:0]const u8, cmd: u32, indata: ?*anyopaque, inlen: u32, outdata: ?*anyopaque, outlen: u32) Error!void {
    return check(c.IoFileMgrForUser.sceIoDevctl(@ptrCast(dev), cmd, indata, ci(inlen), outdata, ci(outlen)));
}

pub fn get_dev_type(fd: SceUID) Error!u32 {
    return checkPositive(u32, c.IoFileMgrForUser.sceIoGetDevType(fd));
}

pub fn assign(dev1: [*:0]const u8, dev2: [*:0]const u8, dev3: [*:0]const u8, mode: IoAssignPerms, unk1: ?*anyopaque, unk2: usize) Error!void {
    return check(c.IoFileMgrForUser.sceIoAssign(@ptrCast(dev1), @ptrCast(dev2), @ptrCast(dev3), @intFromEnum(mode), unk1, @intCast(unk2)));
}

pub fn unassign(dev: [*:0]const u8) Error!void {
    return check(c.IoFileMgrForUser.sceIoUnassign(@ptrCast(dev)));
}

// -- Async management ---------------------------------------------------

pub fn poll_async(fd: SceUID, res: *i64) Error!void {
    return check(c.IoFileMgrForUser.sceIoPollAsync(fd, res));
}

pub fn wait_async(fd: SceUID, res: *i64) Error!void {
    return check(c.IoFileMgrForUser.sceIoWaitAsync(fd, res));
}

pub fn wait_async_cb(fd: SceUID, res: *i64) Error!void {
    return check(c.IoFileMgrForUser.sceIoWaitAsyncCB(fd, res));
}

pub fn get_async_stat(fd: SceUID, poll: bool, res: *i64) Error!void {
    return check(c.IoFileMgrForUser.sceIoGetAsyncStat(fd, @intFromBool(poll), res));
}

pub fn change_async_priority(fd: SceUID, pri: i32) Error!void {
    return check(c.IoFileMgrForUser.sceIoChangeAsyncPriority(fd, @as(c_int, pri)));
}

pub fn set_async_callback(fd: SceUID, cb: SceUID, argp: ?*anyopaque) Error!void {
    return check(c.IoFileMgrForUser.sceIoSetAsyncCallback(fd, cb, argp));
}

pub fn cancel(fd: SceUID) Error!void {
    return check(c.IoFileMgrForUser.sceIoCancel(fd));
}

// -- Standard streams (StdioForUser) ------------------------------------

pub fn stdin() SceUID {
    return c.StdioForUser.sceKernelStdin();
}

pub fn stdout() SceUID {
    return c.StdioForUser.sceKernelStdout();
}

pub fn stderr() SceUID {
    return c.StdioForUser.sceKernelStderr();
}
