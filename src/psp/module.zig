usingnamespace @import("sys/pspthreadman.zig");
usingnamespace @import("sys/psptypes.zig");

const DEFAULT_THREAD_PRIORITY : i32 =  32;
const DEFAULT_THREAD_ATTRIBUTE : u32 = PSP_THREAD_ATTR_USER | PSP_THREAD_ATTR_VFPU; //USER & VFPU
const DEFAULT_THREAD_STACK_KB_SIZE : i32 = 256;
const DEFAULT_MAIN_THREAD_NAME : [*c]const u8 = "user_main";

pub extern fn main(argc: SceSize, argv: ?*c_void) c_int;

fn _module_main_thread(argc: SceSize, argv: ?*c_void) callconv(.C) c_int {
    return main(argc, argv);
}

pub export fn module_start(argc: c_uint, argv: ?*c_void) c_int {
    var thid : SceUID = 0;
    thid = sceKernelCreateThread(DEFAULT_MAIN_THREAD_NAME, _module_main_thread, DEFAULT_THREAD_PRIORITY, DEFAULT_THREAD_STACK_KB_SIZE * 1024, DEFAULT_THREAD_ATTRIBUTE, 0);
    return sceKernelStartThread(thid, argc, argv);   
}