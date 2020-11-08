usingnamespace @import("bits.zig");

pub const __psp_max_fd = 1024;
pub const __psp_fdman_type = enum(u8) {
    File,
    Pipe,
    Socket,
    Tty,
};

pub const __psp_fdman_descriptor = struct {
    filename: ?[]u8,
    ftype: __psp_fdman_type,
    sce_descriptor: c_int,
    flags: u32,
    ref_count: u32,
};

pub fn __psp_fdman_fdValid(fd: fd_t) bool {
    return fd >= 0 and fd < __psp_max_fd and __psp_descriptormap[fd] != null;
}

pub fn __psp_fdman_fdType(fd: fd_t, ftype: __psp_fdman_type) bool {
    return __psp_fdman_fdValid(fd) and __psp_descriptormap[fd].?.ftype == ftype;
}

comptime {
    asm (@embedFile("interrupt.S"));
}

extern fn pspDisableInterrupts() u32;
extern fn pspEnableInterrupts(en: u32) void;

pub var __psp_descriptor_data_pool: [__psp_max_fd]__psp_fdman_descriptor = undefined;
pub var __psp_descriptormap: [__psp_max_fd]?*__psp_fdman_descriptor = undefined;

usingnamespace @import("../include/pspiofilemgr.zig");
usingnamespace @import("../include/pspstdio.zig");
usingnamespace @import("system.zig");

pub fn __psp_fdman_init() void {
    @memset(@ptrCast([*]u8, &__psp_descriptor_data_pool), 0, __psp_max_fd * @sizeOf(__psp_fdman_descriptor));
    @memset(@ptrCast([*]u8, &__psp_descriptormap), 0, __psp_max_fd * @sizeOf(?*__psp_fdman_descriptor));

    var scefd = sceKernelStdin();
    if (scefd >= 0) {
        __psp_descriptormap[0] = &__psp_descriptor_data_pool[0];
        __psp_descriptormap[0].?.sce_descriptor = @bitCast(u32, scefd);
        __psp_descriptormap[0].?.ftype = __psp_fdman_type.Tty;
    }

    scefd = sceKernelStdout();
    if (scefd >= 0) {
        __psp_descriptormap[1] = &__psp_descriptor_data_pool[1];
        __psp_descriptormap[1].?.sce_descriptor = @bitCast(u32, scefd);
        __psp_descriptormap[1].?.ftype = __psp_fdman_type.Tty;
    }

    scefd = sceKernelStderr();
    if (scefd >= 0) {
        __psp_descriptormap[2] = &__psp_descriptor_data_pool[2];
        __psp_descriptormap[2].?.sce_descriptor = @bitCast(u32, scefd);
        __psp_descriptormap[2].?.ftype = __psp_fdman_type.Tty;
    }
}

//Untested:

pub fn __psp_fdman_get_new_descriptor() i32 {
    var i: usize = 0;
    var inten: u32 = 0;

    //Thread safety
    inten = pspDisableInterrupts();

    while (i < __psp_max_fd) : (i += 1) {
        if (__psp_descriptormap[i] == null) {
            __psp_descriptormap[i] = &__psp_descriptor_data_pool[i];
            __psp_descriptormap[i].?.ref_count += 1;
            pspEnableInterrupts(inten);
            return @intCast(i32, i);
        }
    }
    //Unlock
    pspEnableInterrupts(inten);

    errno = ENOMEM;
    return -1;
}

pub fn __psp_fdman_get_dup_descriptor(fd: fd_t) i32 {
    var i: usize = 0;
    var inten: u32 = 0;

    if (!__PSP_IS_FD_VALID(fd)) {
        errno = EBADF;
        return -1;
    }

    inten = pspDisableInterrupts();
    while (i < __psp_max_fd) : (i += 1) {
        if (__psp_descriptormap[i] == NULL) {
            __psp_descriptormap[i] = &__psp_descriptor_data_pool[fd];
            __psp_descriptormap[i].?.ref_count += 1;
            pspEnableInterrupts(inten);
            return i;
        }
    }
    pspEnableInterrupts(inten);

    errno = ENOMEM;
    return -1;
}

pub fn __psp_fdman_release_descriptor(fd: fd_t) void {
    if (!__psp_fdman_fdValid(fd)) {
        errno = EBADF;
        return;
    }

    __psp_descriptormap[fd].?.ref_count -= 1;

    if (__psp_descriptormap[fd].?.ref_count == 0) {
        __psp_descriptormap[fd].?.sce_descriptor = 0;
        __psp_descriptormap[fd].?.filename = null;
        __psp_descriptormap[fd].?.ftype = @intToEnum(__psp_fdman_type, 0);
        __psp_descriptormap[fd].?.flags = 0;
    }
    __psp_descriptormap[fd] = null;
}
