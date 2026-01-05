const loadexec = @import("../sdk/psploadexec.zig");
const threadman = @import("../sdk/pspthreadman.zig");

var requestedExit: bool = false;

//Check if exit is requested
pub fn isExitRequested() bool {
    return requestedExit;
}

//Exit
export fn exit_callback(arg1: c_int, arg2: c_int, common: ?*anyopaque) callconv(.c) c_int {
    _ = arg1;
    _ = arg2;
    _ = common;
    requestedExit = true;
    loadexec.sceKernelExitGame();
    return 0;
}

//Thread for home button exit thread.
export fn exit_callback_thread(args: usize, argp: ?*anyopaque) callconv(.c) c_int {
    _ = args;
    _ = argp;

    const cbID = threadman.sceKernelCreateCallback("zig_exit_callback", exit_callback, null);
    var status = loadexec.sceKernelRegisterExitCallback(cbID);

    if (status < 0) {
        @panic("Could not setup a home button callback!");
    }

    status = threadman.sceKernelSleepThreadCB();

    return 0;
}

// This enables the home button exit callback above
pub fn enableHBCB() void {
    const threadID: i32 = threadman.sceKernelCreateThread("zig_exit_callback_thread", exit_callback_thread, 0x11, 0xFA0, .{ .user = true }, null);
    if (threadID >= 0) {
        const stat: i32 = threadman.sceKernelStartThread(threadID, 0, null); //We don't know what stat does.
        _ = stat;
    } else {
        @panic("Could not setup the exit callback thread!");
    }
}
