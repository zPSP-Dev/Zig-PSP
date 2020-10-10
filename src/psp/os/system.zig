usingnamespace @import("bits.zig");
usingnamespace @import("fdman.zig");
var errno : u32 = 0;

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

pub fn __pspOsInit() void {
    __psp_fdman_init();
}

usingnamespace @import("../include/pspthreadman.zig");
pub fn nanosleep(req: *const timespec, rem: ?*timespec) c_int {
    _ = sceKernelDelayThread(@intCast(c_uint, 1000 * 1000 * req.tv_sec + @divTrunc(req.tv_nsec, 1000)));
    return 0;
}

