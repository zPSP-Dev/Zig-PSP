const kernel = @import("../sdk/kernel.zig");

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
    kernel.exit_game();
    return 0;
}

//Thread for home button exit thread.
export fn exit_callback_thread(args: usize, argp: ?*anyopaque) callconv(.c) c_int {
    _ = args;
    _ = argp;

    const cbID = kernel.create_callback("zig_exit_callback", exit_callback, null) catch
        @panic("Could not setup a home button callback!");
    kernel.register_exit_callback(cbID) catch
        @panic("Could not setup a home button callback!");

    kernel.sleep_thread_cb() catch {};

    return 0;
}

// This enables the home button exit callback above
pub fn enableHBCB() void {
    const threadID = kernel.create_thread("zig_exit_callback_thread", exit_callback_thread, 0x11, 0xFA0, .{ .user = true }, null) catch
        @panic("Could not setup the exit callback thread!");
    kernel.start_thread(threadID, 0, null) catch {};
}
