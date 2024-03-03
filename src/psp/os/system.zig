const bits = @import("bits.zig");
const fdman = @import("fdman.zig");
const cwd = @import("cwd.zig");
pub var errno: u32 = 0;

fn pspErrToErrno(code: u64) i32 {
    if ((code & 0x80010000) == 0x80010000) {
        errno = @as(u32, @truncate(code & 0xFFFF));
        return -1;
    }
    return @as(i32, @bitCast(@as(u32, @truncate(code))));
}

pub fn getErrno(r: c_int) usize {
    _ = r;
    return errno;
}

const pspiofilemgr = @import("../include/pspiofilemgr.zig");
const pspstdio = @import("../include/pspstdio.zig");
const psprtc = @import("../include/psprtc.zig");

const fd_t = psprtc;

pub fn read(fd: fd_t, ptr: [*]u8, len: usize) i32 {
    if (!fdman.__psp_fdman_fdValid(fd)) {
        errno = bits.EBADF;
        return -1;
    }

    switch (fdman.__psp_descriptormap[fd].?.ftype) {
        .File, .Tty => {
            return pspErrToErrno(@as(u32, @bitCast(pspiofilemgr.sceIoRead(fdman.__psp_descriptormap[fd].?.sce_descriptor, ptr, len))));
        },

        else => {
            @panic("PIPES & SOCKETS ARE NOT IMPLEMENTED YET!");
        },
    }

    errno = bits.EBADF;
    return -1;
}

pub fn write(fd: fd_t, ptr: [*]const u8, len: usize) i32 {
    if (!fdman.__psp_fdman_fdValid(fd)) {
        errno = bits.EBADF;
        return -1;
    }

    switch (fdman.__psp_descriptormap[fd].?.ftype) {
        .File, .Tty => {
            return pspErrToErrno(@as(u32, @bitCast(pspiofilemgr.sceIoWrite(fdman.__psp_descriptormap[fd].?.sce_descriptor, ptr, len))));
        },

        else => {
            @panic("PIPES & SOCKETS ARE NOT IMPLEMENTED YET!");
        },
    }

    errno = bits.EBADF;
    return -1;
}

pub fn __pspOsInit(arg: ?*anyopaque) void {
    fdman.__psp_fdman_init();
    fdman.__psp_init_cwd(arg);
}

const pspthreadman = @import("../include/pspthreadman.zig");
pub fn nanosleep(req: *const bits.timespec, rem: ?*bits.timespec) c_int {
    _ = rem;
    _ = pspthreadman.sceKernelDelayThread(@as(c_uint, @intCast(1000 * 1000 * req.tv_sec + @divTrunc(req.tv_nsec, 1000))));
    return 0;
}

const psputils = @import("../include/psputils.zig");
pub fn _times(t: *bits.time_t) bits.time_t {
    return pspErrToErrno(psputils.sceKernelLibcTime(t));
}

pub fn flock(f: fdman.fd_t, op: c_int) c_int {
    _ = f;
    _ = op;
    return 0;
}
const std = @import("std");

pub fn openat(dir: fd_t, path: [*:0]const u8, flags: u32, mode: u32) c_int {
    if (dir != bits.AT_FDCWD) {
        @panic("Non-FDCWD Not Supported");
    } else {
        //Do stuff;
        var scefd: c_int = 0;
        var fd: c_int = 0;
        var dest: [bits.PATH_MAX + 1]u8 = undefined;

        const stat = fdman.__psp_path_absolute(path, dest[0..], bits.PATH_MAX);
        if (stat < 0) {
            errno = bits.ENAMETOOLONG;
            return -1;
        }

        scefd = pspiofilemgr.sceIoOpen(dest[0..], @as(c_int, @bitCast(flags)), mode);
        if (scefd >= 0) {
            fd = fdman.__psp_fdman_get_new_descriptor();
            if (fd != -1) {
                fdman.__psp_descriptormap[@as(usize, @intCast(fd))].?.sce_descriptor = scefd;
                fdman.__psp_descriptormap[@as(usize, @intCast(fd))].?.ftype = fdman.__psp_fdman_type.File;
                fdman.__psp_descriptormap[@as(usize, @intCast(fd))].?.flags = flags;
                fdman.__psp_descriptormap[@as(usize, @intCast(fd))].?.filename = dest[0..];
                return fd;
            } else {
                _ = pspiofilemgr.sceIoClose(scefd);
                errno = bits.ENOMEM;
                return -1;
            }
        } else {
            return pspErrToErrno(@as(u32, @bitCast(scefd)));
        }

        errno = bits.EBADF;
        return -1;
    }
}

pub fn close(fd: fd_t) c_int {
    var ret: c_int = 0;

    if (!fdman.__psp_fdman_fdValid(fd)) {
        errno = bits.EBADF;
        return -1;
    }

    switch (fdman.__psp_descriptormap[fd].?.ftype) {
        .File, .Tty => {
            if (fdman.__psp_descriptormap[fd].?.ref_count == 1) {
                ret = pspErrToErrno(@as(u32, @bitCast(pspiofilemgr.sceIoClose(fdman.__psp_descriptormap[fd].?.sce_descriptor))));
            }
            fdman.__psp_fdman_release_descriptor(fd);
            return ret;
        },

        else => {
            @panic("PIPES & SOCKETS ARE NOT IMPLEMENTED YET!");
        },
    }

    errno = bits.EBADF;
    return -1;
}

pub fn unlinkat(dir: fd_t, path: [*:0]const u8, flags: u32) c_int {
    _ = flags;
    if (dir != bits.AT_FDCWD) {
        @panic("Non-FDCWD Not Supported");
    }

    var dest: [bits.PATH_MAX + 1]u8 = undefined;

    const stat = fdman.__psp_path_absolute(path, dest[0..], bits.PATH_MAX);
    if (stat < 0) {
        errno = bits.ENAMETOOLONG;
        return -1;
    }

    var fdStat: pspiofilemgr.SceIoStat = undefined;
    _ = pspiofilemgr.sceIoGetstat(dest[0..], &fdStat);

    if (fdStat.st_mode & @intFromEnum(pspiofilemgr.IOAccessModes.FIO_S_IFDIR) != 0) {
        return pspErrToErrno(@as(u32, @bitCast(pspiofilemgr.sceIoRmdir(dest[0..]))));
    } else {
        return pspErrToErrno(@as(u32, @bitCast(pspiofilemgr.sceIoRemove(dest[0..]))));
    }
}

pub fn mkdirat(dir: fd_t, path: [*:0]const u8, mode: u32) c_int {
    if (dir != bits.AT_FDCWD) {
        @panic("Non-FDCWD Not Supported");
    }

    var dest: [bits.PATH_MAX + 1]u8 = undefined;
    const stat = fdman.__psp_path_absolute(path, dest[0..], bits.PATH_MAX);
    if (stat < 0) {
        errno = bits.ENAMETOOLONG;
        return -1;
    }

    return pspErrToErrno(@as(u32, @bitCast(pspiofilemgr.sceIoMkdir(dest[0..], mode))));
}

pub fn fstat(fd: fd_t, stat: *pspiofilemgr.Stat) c_int {
    var psp_stat: pspiofilemgr.SceIoStat = undefined;
    var dest: [bits.PATH_MAX + 1]u8 = undefined;
    var ret: i32 = 0;

    const status = fdman.__psp_path_absolute(@as([*]const u8, @ptrCast(&fdman.__psp_descriptormap[fd].?.filename.?)), dest[0..], bits.PATH_MAX);
    if (status < 0) {
        errno = pspiofilemgr.ENAMETOOLONG;
        return -1;
    }

    @memset(@as([*]u8, @ptrCast(stat))[0..@sizeOf(stat)], 0);
    ret = pspiofilemgr.sceIoGetstat(dest[0..], &psp_stat);
    if (ret < 0) {
        return pspErrToErrno(@as(u32, @bitCast(ret)));
    }

    stat.mode = @as(u32, @bitCast(psp_stat.st_mode));
    stat.st_attr = @as(u64, psp_stat.st_attr);
    stat.size = @as(u64, @bitCast(psp_stat.st_size));
    stat.st_ctime = psp_stat.st_ctime;
    stat.st_atime = psp_stat.st_atime;
    stat.st_mtime = psp_stat.st_mtime;
    stat.st_private = psp_stat.st_private;

    return 0;
}

pub fn faccessat(dir: fd_t, path: [*:0]const u8, mode: u32, flags: u32) c_int {
    _ = mode;
    if (dir != bits.AT_FDCWD) {
        @panic("Non-FDCWD Not Supported");
    }

    var dest: [bits.PATH_MAX + 1]u8 = undefined;
    const stat = fdman.__psp_path_absolute(path, dest[0..], bits.PATH_MAX);
    if (stat < 0) {
        errno = bits.ENAMETOOLONG;
        return -1;
    }

    var fdStat: pspiofilemgr.SceIoStat = undefined;
    const v = pspiofilemgr.sceIoGetstat(dest[0..], &fdStat);
    if (v != 0) {
        return pspErrToErrno(@as(u32, @bitCast(v)));
    }

    if (fdStat.st_mode & pspiofilemgr.S_IFDIR != 0) {
        return 0;
    }
    if (flags & bits.W_OK == 0) {
        return 0;
    }

    errno = bits.EACCES;
    return -1;
}

pub fn lseek(fd: fd_t, off: i64, whence: c_int) c_int {
    if (!fdman.__psp_fdman_fdValid(fd)) {
        errno = bits.EBADF;
        return -1;
    }

    switch (fdman.__psp_descriptormap[fd].?.ftype) {
        .File => {
            std.debug.warn("{}", .{whence});
            //If you need to seek past 4GB, you have a real problem.
            return pspErrToErrno(@as(u32, @bitCast(pspiofilemgr.sceIoLseek32(fdman.__psp_descriptormap[fd].?.sce_descriptor, @as(c_int, @truncate(off)), whence))));
        },

        else => {
            errno = bits.EBADF;
            return -1;
        },
    }
}

pub fn isatty(fd: fd_t) c_int {
    if (!fdman.__psp_fdman_fdValid(fd)) {
        errno = bits.EBADF;
        return -1;
    }

    return @as(c_int, @intCast(@intFromBool(fdman.__psp_fdman_fdType(fd, fdman.__psp_fdman_type.Tty))));
}
