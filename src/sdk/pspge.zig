const c = @import("../c/modules.zig");
const module = c.sceGe_user;

pub const PspGeBreakParam = c.types.PspGeBreakParam;
pub const PspGeCallbackData = c.types.PspGeCallbackData;
pub const PspGeContext = c.types.PspGeContext;
pub const PspGeListArgs = c.types.PspGeListArgs;
pub const PspGeStack = c.types.PspGeStack;

pub const PspGeMatrixTypes = enum(c_int) {
    Bone0 = 0,
    Bone1 = 1,
    Bone2 = 2,
    Bone3 = 3,
    Bone4 = 4,
    Bone5 = 5,
    Bone6 = 6,
    Bone7 = 7,
    World = 8,
    View = 9,
    Projection = 10,
    Texgen = 11,
};

pub const PspGeListState = enum(c_int) {
    Done = 0,
    Queued = 1,
    DrawingDone = 2,
    StallReached = 3,
    CancelDone = 4,
};

pub const PspGeSyncBehavior = enum(c_int) {
    Wait = 0,
    NoWait = 1,
};

/// Get the size of VRAM.
/// Returns The size of VRAM (in bytes).
pub fn sceGeEdramGetSize() usize {
    return module.sceGeEdramGetSize();
}

/// Get the eDRAM address.
/// Returns A pointer to the base of the eDRAM.
pub fn sceGeEdramGetAddr() ?*anyopaque {
    return module.sceGeEdramGetAddr();
}

/// Set the eDRAM address translation mode.
/// `width` - 0 to not set the translation width, otherwise 512, 1024, 2048 or 4096.
/// Returns The previous width if it was set, otherwise 0, < 0 on error.
pub fn sceGeEdramSetAddrTranslation(width: c_int) c_int {
    return module.sceGeEdramSetAddrTranslation(width);
}

/// Retrieve the current value of a GE command.
/// `cmd` - The GE command register to retrieve (0 to 0xFF, both included).
/// Returns The value of the GE command, < 0 on error.
pub fn sceGeGetCmd(cmd: c_int) c_uint {
    return module.sceGeGetCmd(cmd);
}

/// Retrieve a matrix of the given type.
/// `type` - One of ::PspGeMatrixTypes.
/// `matrix` - Pointer to a variable to store the matrix.
/// Returns < 0 on error.
pub fn sceGeGetMtx(matrix_type: PspGeMatrixTypes, matrix: ?*anyopaque) c_int {
    return module.sceGeGetMtx(@intFromEnum(matrix_type), matrix);
}

/// Retrieve the stack of the display list currently being executed.
/// `stackId` - The ID of the stack to retrieve.
/// `stack` - Pointer to a structure to store the stack, or NULL to not store it.
/// Returns The number of stacks of the current display list, < 0 on error.
pub fn sceGeGetStack(stackId: c_int, stack: [*c]PspGeStack) c_int {
    return module.sceGeGetStack(stackId, stack);
}

/// Save the GE's current state.
/// `context` - Pointer to a ::PspGeContext.
/// Returns < 0 on error.
pub fn sceGeSaveContext(context: [*c]PspGeContext) c_int {
    return module.sceGeSaveContext(context);
}

/// Restore a previously saved GE context.
/// `context` - Pointer to a ::PspGeContext.
/// Returns < 0 on error.
pub fn sceGeRestoreContext(context: [*c]const PspGeContext) c_int {
    return module.sceGeRestoreContext(context);
}

/// Enqueue a display list at the tail of the GE display list queue.
/// `list` - The head of the list to queue.
/// `stall` - The stall address.
/// If NULL then no stall address is set and the list is transferred immediately.
/// `cbid` - ID of the callback set by calling sceGeSetCallback
/// `arg` - Structure containing GE context buffer address
/// Returns The ID of the queue, < 0 on error.
pub fn sceGeListEnQueue(list: ?*const anyopaque, stall: ?*anyopaque, cbid: c_int, arg: [*c]PspGeListArgs) c_int {
    return module.sceGeListEnQueue(list, stall, cbid, arg);
}

/// Enqueue a display list at the head of the GE display list queue.
/// `list` - The head of the list to queue.
/// `stall` - The stall address.
/// If NULL then no stall address is set and the list is transferred immediately.
/// `cbid` - ID of the callback set by calling sceGeSetCallback
/// `arg` - Structure containing GE context buffer address
/// Returns The ID of the queue, < 0 on error.
pub fn sceGeListEnQueueHead(list: ?*const anyopaque, stall: ?*anyopaque, cbid: c_int, arg: [*c]PspGeListArgs) c_int {
    return module.sceGeListEnQueueHead(list, stall, cbid, arg);
}

/// Cancel a queued or running list.
/// `qid` - The ID of the queue.
/// Returns < 0 on error.
pub fn sceGeListDeQueue(qid: c_int) c_int {
    return module.sceGeListDeQueue(qid);
}

/// Update the stall address for the specified queue.
/// `qid` - The ID of the queue.
/// `stall` - The new stall address.
/// Returns < 0 on error
pub fn sceGeListUpdateStallAddr(qid: c_int, stall: ?*anyopaque) c_int {
    return module.sceGeListUpdateStallAddr(qid, stall);
}

/// Wait for syncronisation of a list.
/// `qid` - The queue ID of the list to sync.
/// `syncType` - 0 if you want to wait for the list to be completed, or 1 if you just want to peek the actual state.
/// Returns The specified queue status, one of ::PspGeListState.
pub fn sceGeListSync(qid: c_int, syncType: PspGeSyncBehavior) PspGeListState {
    return @enumFromInt(module.sceGeListSync(qid, @intFromEnum(syncType)));
}

/// Wait for drawing to complete.
/// `syncType` - 0 if you want to wait for the drawing to be completed, or 1 if you just want to peek the state of the display list currently being executed.
/// Returns The current queue status, one of ::PspGeListState.
pub fn sceGeDrawSync(syncType: PspGeSyncBehavior) PspGeListState {
    return @enumFromInt(module.sceGeDrawSync(@intFromEnum(syncType)));
}

/// Interrupt drawing queue.
/// `mode` - If set to 1, reset all the queues.
/// `pParam` - Unused (just K1-checked).
/// Returns The stopped queue ID if mode isn't set to 0, otherwise 0, and < 0 on error.
pub fn sceGeBreak(mode: c_int, pParam: [*c]PspGeBreakParam) c_int {
    return module.sceGeBreak(mode, pParam);
}

/// Restart drawing queue.
/// Returns < 0 on error.
pub fn sceGeContinue() c_int {
    return module.sceGeContinue();
}

/// Register callback handlers for the the GE.
/// `cb` - Configured callback data structure.
/// Returns The callback ID, < 0 on error.
pub fn sceGeSetCallback(cb: PspGeCallbackData) c_int {
    return module.sceGeSetCallback(@constCast(&cb));
}

/// Unregister the callback handlers.
/// `cbid` - The ID of the callbacks, returned by sceGeSetCallback().
/// Returns < 0 on error
pub fn sceGeUnsetCallback(cbid: c_int) c_int {
    return module.sceGeUnsetCallback(cbid);
}

/// Sets the EDRAM size to be enabled.
/// `size -size    The size (0x200000 or 0x400000). Will return an error if 0x400000 is specified for the PSP FAT.`
/// Returns Zero on success, otherwise less than zero.
pub fn sceGeEdramSetSize(size: c_int) c_int {
    return module.sceGeEdramSetSize(size);
}
