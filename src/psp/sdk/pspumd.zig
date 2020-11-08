pub const PspUmdInfo = extern struct {
    size: c_uint,
    typec: c_uint,
};

pub const PspUmdTypes = extern enum(c_int) {
    Game = 16,
    Video = 32,
    Audio = 64,
};

pub const PspUmdState = extern enum(c_int) {
    NotPresent = 1,
    Present = 2,
    Changed = 4,
    Initing = 8,
    Inited = 16,
    Ready = 32,
};

pub const UmdDriveStat = extern enum(c_int) {
    WaitForDISC = 2,
    WaitForINIT = 32,
};
pub const UmdCallback = ?fn (c_int, c_int) callconv(.C) c_int;

// Check whether there is a disc in the UMD drive
//
// @return 0 if no disc present, anything else indicates a disc is inserted.
pub extern fn sceUmdCheckMedium() c_int;

// Get the disc info
//
// @param info - A pointer to a ::pspUmdInfo struct
//
// @return < 0 on error
pub extern fn sceUmdGetDiscInfo(info: *PspUmdInfo) c_int;
pub fn umdGetDiscInfo(info: *PspUmdInfo) !i32 {
    var res = sceUmdGetDiscInfo(info);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Activates the UMD drive
//
// @param unit - The unit to initialise (probably). Should be set to 1.
//
// @param drive - A prefix string for the fs device to mount the UMD on (e.g. "disc0:")
//
// @return < 0 on error
//
// @par Example:
// @code
// // Wait for disc and mount to filesystem
// int i;
// i = sceUmdCheckMedium();
// if(i == 0)
// {
//    sceUmdWaitDriveStat(PSP_UMD_PRESENT);
// }
// sceUmdActivate(1, "disc0:"); // Mount UMD to disc0: file system
// sceUmdWaitDriveStat(PSP_UMD_READY);
// // Now you can access the UMD using standard sceIo functions
// @endcode
pub extern fn sceUmdActivate(unit: c_int, drive: []const u8) c_int;
pub fn umdActivate(unit: c_int, drive: []const u8) !i32 {
    var res = sceUmdActivate(unit, drive);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Deativates the UMD drive
//
// @param unit - The unit to initialise (probably). Should be set to 1.
//
// @param drive - A prefix string for the fs device to mount the UMD on (e.g. "disc0:")
//
// @return < 0 on error
pub extern fn sceUmdDeactivate(unit: c_int, drive: []const u8) c_int;
pub fn umdDeactivate(unit: c_int, drive: []const u8) !i32 {
    var res = sceUmdDeactivate(unit, drive);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Wait for the UMD drive to reach a certain state
//
// @param stat - One or more of ::pspUmdState
//
// @return < 0 on error
pub extern fn sceUmdWaitDriveStat(stat: c_int) c_int;
pub fn umdWaitDriveStat(stat: c_int) !i32 {
    var res = sceUmdWaitDriveStat(stat);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Wait for the UMD drive to reach a certain state
//
// @param stat - One or more of ::pspUmdState
//
// @param timeout - Timeout value in microseconds
//
// @return < 0 on error
pub extern fn sceUmdWaitDriveStatWithTimer(stat: c_int, timeout: c_uint) c_int;
pub fn umdWaitDriveStatWithTimer(stat: c_int, timeout: c_uint) !i32 {
    var res = umdWaitDriveStatWithTimer(stat, timeout);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Wait for the UMD drive to reach a certain state (plus callback)
//
// @param stat - One or more of ::pspUmdState
//
// @param timeout - Timeout value in microseconds
//
// @return < 0 on error
pub extern fn sceUmdWaitDriveStatCB(stat: c_int, timeout: c_uint) c_int;
pub fn umdWaitDriveStatCB(stat: c_int, timeout: c_uint) !i32 {
    var res = sceUmdWaitDriveStatCB(stat, timeout);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

//Cancel a sceUmdWait* call
//
//@return < 0 on error
pub extern fn sceUmdCancelWaitDriveStat() c_int;
pub fn umdCancelWaitDriveStat() !i32 {
    var res = sceUmdCancelWaitDriveStat();
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Get (poll) the current state of the UMD drive
//
// @return < 0 on error, one or more of ::pspUmdState on success
pub extern fn sceUmdGetDriveStat() c_int;
pub fn umdGetDriveStat() !i32 {
    var res = sceUmdGetDriveStat();
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Get the error code associated with a failed event
//
// @return < 0 on error, the error code on success
pub extern fn sceUmdGetErrorStat() c_int;

// Register a callback for the UMD drive
// @note Callback is of type UmdCallback
//
// @param cbid - A callback ID created from sceKernelCreateCallback
// @return < 0 on error
// @par Example:
// @code
// int umd_callback(int unknown, int event)
// {
//      //do something
// }
// int cbid = sceKernelCreateCallback("UMD Callback", umd_callback, NULL);
// sceUmdRegisterUMDCallBack(cbid);
// @endcode
pub extern fn sceUmdRegisterUMDCallBack(cbid: c_int) c_int;
pub fn umdRegisterUMDCallBack(cbid: c_int) !i32 {
    var res = sceUmdRegisterUMDCallBack(cbid);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Un-register a callback for the UMD drive
//
// @param cbid - A callback ID created from sceKernelCreateCallback
//
// @return < 0 on error
pub extern fn sceUmdUnRegisterUMDCallBack(cbid: c_int) c_int;
pub fn umdUnRegisterUMDCallBack(cbid: c_int) !i32 {
    var res = sceUmdUnRegisterUMDCallBack(cbid);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Permit UMD disc being replaced
//
// @return < 0 on error
pub extern fn sceUmdReplacePermit() c_int;
pub fn umdReplacePermit() !i32 {
    var res = sceUmdReplacePermit();
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Prohibit UMD disc being replaced
//
// @return < 0 on error
pub extern fn sceUmdReplaceProhibit() c_int;
pub fn umdReplaceProhibit() !i32 {
    var res = sceUmdReplaceProhibit();
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}
