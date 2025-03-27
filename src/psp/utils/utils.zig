const psp = @import("psp");
const psptypes = @import("psp");
const pspthreadman = @import("../sdk/pspthreadman.zig");

var requestedExit: bool = false;

//Check if exit is requested
pub fn isRunning() bool {
    return requestedExit;
}

//Exit
export fn exitCB(arg1: c_int, arg2: c_int, common: ?*anyopaque) c_int {
    _ = arg1;
    _ = arg2;
    _ = common;
    requestedExit = true;
    psp.sceKernelExitGame();
    return 0;
}

//Thread for home button exit thread.
export fn cbThread(args: psptypes.SceSize, argp: ?*anyopaque) c_int {
    _ = args;
    _ = argp;
    var cbID: i32 = -1;

    cbID = psp.sceKernelCreateCallback(@ptrCast("zig_exit_callback"), @bitCast(@intFromPtr(&exitCB)), null);
    var status = psp.sceKernelRegisterExitCallback(cbID);

    if (status < 0) {
        @panic("Could not setup a home button callback!");
    }

    status = psp.sceKernelSleepThreadCB();

    return 0;
}

//This enables the home button exit callback above
pub fn enableHBCB() void {
    const threadID: i32 = psp.sceKernelCreateThread(@ptrCast("zig_callback_updater"), @bitCast(@intFromPtr(&cbThread)), 0x11, 0xFA0, @intFromEnum(pspthreadman.PspThreadAttributes.PSP_THREAD_ATTR_USER), null);
    if (threadID >= 0) {
        const stat: i32 = psp.sceKernelStartThread(threadID, 0, null); //We don't know what stat does.
        _ = stat;
    } else {
        @panic("Could not setup a home button callback thread!");
    }
}
