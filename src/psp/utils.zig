usingnamespace @import("sys/pspthreadman.zig");
usingnamespace @import("sys/psploadexec.zig");
usingnamespace @import("sys/psptypes.zig");

var requestedExit : bool = false;

pub fn isRunning() bool{
    return requestedExit;
}

export fn exitCB(arg1 : c_int, arg2 : c_int, common: ?*c_void) c_int{
    requestedExit = true;
    return 0;
}

export fn cbThread(args: SceSize, argp: ?*c_void) c_int{

    var cbID : i32 = sceKernelCreateCallback("zig_exit_callback", exitCB, null);
    var status = sceKernelRegisterExitCallback(cbID);

    if(status < 0){
        //Error case

        //TODO: PANIC!
        sceKernelExitGame();
    }

    status = sceKernelSleepThreadCB();

    return 0;
}

pub fn enableHomeButton() void {
    var threadID : i32 = sceKernelCreateThread("zig_callback_updater", cbThread, 0x11, 0xFA0, @enumToInt(PspThreadAttributes.PSP_THREAD_ATTR_USER), null); 
    if(threadID >= 0){
        var stat: i32 = sceKernelStartThread(threadID, 0, null); //We don't know what stat does.
    }else{
        //Error case

        //TODO: PANIC!
        sceKernelExitGame();
    }
}