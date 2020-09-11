usingnamespace @import("../include/pspthreadman.zig");
usingnamespace @import("../include/psploadexec.zig");
usingnamespace @import("../include/psptypes.zig");

pub usingnamespace @import("allocator.zig");
pub usingnamespace @import("vram.zig");


//Sets requested exit instead of exiting.
pub var altBehaviour : bool = false;

var requestedExit : bool = false;

//Check if exit is requested
pub fn isRunning() bool{
    return requestedExit;
}

//Don't exit
export fn altCB(arg1 : c_int, arg2 : c_int, common: ?*c_void) c_int{
    requestedExit = true;
    return 0;
}

//Exit
export fn exitCB(arg1 : c_int, arg2 : c_int, common: ?*c_void) c_int{
    requestedExit = true;
    sceKernelExitGame();
    return 0;
}

//Thread for home button exit thread.
export fn cbThread(args: SceSize, argp: ?*c_void) c_int{

    var cbID : i32 = -1;
    
    if(altBehaviour){
        cbID = sceKernelCreateCallback("zig_exit_callback", altCB, null);
    }else{
        cbID = sceKernelCreateCallback("zig_exit_callback", exitCB, null);
    }
    var status = sceKernelRegisterExitCallback(cbID);

    if(status < 0){
        @panic("Could not setup a home button callback!");
    }

    status = sceKernelSleepThreadCB();

    return 0;
}

//This enables the home button exit callback above
pub fn enableHBCB() void {
    var threadID : i32 = sceKernelCreateThread("zig_callback_updater", cbThread, 0x11, 0xFA0, @enumToInt(PspThreadAttributes.PSP_THREAD_ATTR_USER), null); 
    if(threadID >= 0){
        var stat: i32 = sceKernelStartThread(threadID, 0, null); //We don't know what stat does.
    }else{
        @panic("Could not setup a home button callback thread!");
    }
}
