usingnamespace @import("sys/pspthreadman.zig");
usingnamespace @import("sys/psptypes.zig");

extern fn main(argc: SceSize, argv: ?*c_void) c_int;

fn _module_main_thread(argc: SceSize, argv: ?*c_void) callconv(.C) c_int {
    return main(argc, argv);
}

pub export fn module_start(argc: c_uint, argv: ?*c_void) c_int {
    var thid : SceUID = 0;
    thid = sceKernelCreateThread("user_main", _module_main_thread, 0x20, 256 * 1024, PSP_THREAD_ATTR_USER | PSP_THREAD_ATTR_VFPU, 0);
    return sceKernelStartThread(thid, argc, argv);   
}