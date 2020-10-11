usingnamespace @import("bits.zig");
usingnamespace @import("fdman.zig");
usingnamespace @import("cwd.zig");
pub var errno : u32 = 0;

fn pspErrToErrno(code: u32) i32{
    if ((code & 0x80010000) == 0x80010000) {
        errno = code & 0xFFFF;
        return -1;
    }
    return @bitCast(i32, code);
}

pub fn getErrno(r: c_int) usize {
    return errno;
}


usingnamespace @import("../include/pspiofilemgr.zig");
usingnamespace @import("../include/pspstdio.zig");
usingnamespace @import("../include/psprtc.zig");

pub fn read(fd: fd_t, ptr: [*]u8, len: usize) i32 {
    if(!__psp_fdman_fdValid(fd)){
        errno = EBADF;
        return -1;
    }

    switch(__psp_descriptormap[fd].?.ftype){
        .File, .Tty => {
            return pspErrToErrno(@bitCast(u32, sceIoRead(__psp_descriptormap[fd].?.sce_descriptor, ptr, len)));
        },

        else =>{
            @panic("PIPES & SOCKETS ARE NOT IMPLEMENTED YET!");
        }
    }

    errno = EBADF;
    return -1;

    errno = EBADF;
    return -1;
}

pub fn write(fd: fd_t, ptr: [*]const u8, len: usize) i32 {
    if(!__psp_fdman_fdValid(fd)){
        errno = EBADF;
        return -1;
    }

    switch(__psp_descriptormap[fd].?.ftype){
        .File, .Tty => {
            return pspErrToErrno(@bitCast(u32, sceIoWrite(__psp_descriptormap[fd].?.sce_descriptor, ptr, len)));
        },

        else =>{
            @panic("PIPES & SOCKETS ARE NOT IMPLEMENTED YET!");
        }
    }

    errno = EBADF;
    return -1;
}

pub fn __pspOsInit(arg: ?*c_void) void {
    __psp_fdman_init();
    __psp_init_cwd(arg);
}

usingnamespace @import("../include/pspthreadman.zig");
pub fn nanosleep(req: *const timespec, rem: ?*timespec) c_int {
    _ = sceKernelDelayThread(@intCast(c_uint, 1000 * 1000 * req.tv_sec + @divTrunc(req.tv_nsec, 1000)));
    return 0;
}

usingnamespace @import("../include/psputils.zig");
pub fn _times (t: *time_t) time_t {
    return pspErrToErrno(sceKernelLibcTime(t));
} 

pub fn flock(f: fd_t, op: c_int) c_int{
    return 0;
}
const std = @import("std");

pub fn openat(dir: fd_t, path: [*:0]const u8, flags: u32, mode: u32) c_int{
    if(dir != AT_FDCWD){
        @panic("Non-FDCWD Not Supported");
    }else{
        //Do stuff;
        
        var scefd : c_int = 0;
        var fd : c_int = 0;
        var dest : [PATH_MAX + 1]u8 = undefined;

        var stat = __psp_path_absolute(path, dest[0..], PATH_MAX);
        if(stat < 0) {
            errno = ENAMETOOLONG;
            return -1;
        }

        scefd = sceIoOpen(dest[0..], @bitCast(c_int, flags), mode);
        if (scefd >= 0) {
            fd = __psp_fdman_get_new_descriptor();
            if (fd != -1) {
                __psp_descriptormap[@intCast(usize, fd)].?.sce_descriptor = scefd;
                __psp_descriptormap[@intCast(usize, fd)].?.ftype = __psp_fdman_type.File;
                __psp_descriptormap[@intCast(usize, fd)].?.flags = flags;
                __psp_descriptormap[@intCast(usize, fd)].?.filename = dest[0..];
                return fd;
            }else{
                _ = sceIoClose(scefd);
                errno = ENOMEM;
                return -1;
            }
        }else{
            return pspErrToErrno(@bitCast(u32, scefd));
        }

        errno = EBADF;
        return -1;
    }
}

pub fn close(fd: fd_t) c_int {
    var ret: c_int = 0;

    if(!__psp_fdman_fdValid(fd)){
        errno = EBADF;
        return -1;
    }

    switch(__psp_descriptormap[fd].?.ftype){
        .File, .Tty => {
            if (__psp_descriptormap[fd].?.ref_count == 1) {
                ret = pspErrToErrno(@bitCast(u32, sceIoClose(__psp_descriptormap[fd].?.sce_descriptor)));
            }
            __psp_fdman_release_descriptor(fd);
            return ret;
        },

        else =>{
            @panic("PIPES & SOCKETS ARE NOT IMPLEMENTED YET!");
        }
    }
    
    errno = EBADF;
    return -1;
}
