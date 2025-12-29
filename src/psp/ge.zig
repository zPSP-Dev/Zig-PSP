const libzpsp = @import("libzpsp");
const module = libzpsp.sceGe_user;

pub const BreakParam = libzpsp.types.PspGeBreakParam;
pub const CallbackData = libzpsp.types.PspGeCallbackData;
pub const Context = libzpsp.types.PspGeContext;
pub const ListArgs = libzpsp.types.PspGeListArgs;
pub const Stack = libzpsp.types.PspGeStack;

pub const MatrixTypes = enum(c_int) {
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

pub const ListState = enum(c_int) {
    Done = 0,
    Queued = 1,
    DrawingDone = 2,
    StallReached = 3,
    CancelDone = 4,
};

pub const SyncBehavior = enum(c_int) {
    Wait = 0,
    NoWait = 1,
};

/// Get the size of VRAM.
/// Returns The size of VRAM (in bytes).
pub fn edram_get_size() usize {
    return module.sceGeEdramGetSize();
}

/// Get the eDRAM address.
/// Returns A pointer to the base of the eDRAM.
pub fn edram_get_addr() ?*anyopaque {
    return module.sceGeEdramGetAddr();
}

/// Set the eDRAM address translation mode.
/// `width` - 0 to not set the translation width, otherwise 512, 1024, 2048 or 4096.
/// Returns The previous width if it was set, otherwise 0, < 0 on error.
pub fn edram_set_addr_translation(width: u32) !void {
    if (module.sceGeEdramSetAddrTranslation(@bitCast(width)) < 0) {
        return error.SetAddrTranslationFailed;
    }
}

/// Retrieve the current value of a GE command.
/// `cmd` - The GE command register to retrieve (0 to 0xFF, both included).
/// Returns The value of the GE command, < 0 on error.
pub fn get_cmd(cmd: c_int) !u32 {
    const result = module.sceGeGetCmd(cmd);
    if (result < 0) {
        return error.GetCmdFailed;
    }
    return result;
}

/// Retrieve a matrix of the given type.
/// `type` - One of ::PspGeMatrixTypes.
/// `matrix` - Pointer to a variable to store the matrix.
/// Returns < 0 on error.
pub fn get_matrix(matrix_type: MatrixTypes, matrix: ?*anyopaque) !void {
    if (module.sceGeGetMtx(@intFromEnum(matrix_type), matrix) < 0) {
        return error.GetMatrixFailed;
    }
}

/// Retrieve the stack of the display list currently being executed.
/// `stackId` - The ID of the stack to retrieve.
/// `stack` - Pointer to a structure to store the stack, or NULL to not store it.
/// Returns The number of stacks of the current display list, < 0 on error.
pub fn get_stack(stackId: c_int, stack: *Stack) !usize {
    const result = module.sceGeGetStack(stackId, @ptrCast(stack));
    if (result < 0) {
        return error.GetStackFailed;
    }
    return result;
}

/// Save the GE's current state.
/// `context` - Pointer to a ::PspGeContext.
/// Returns < 0 on error.
pub fn save_context(context: *Context) !void {
    if (module.sceGeSaveContext(@ptrCast(context)) < 0) {
        return error.SaveContextFailed;
    }
}

/// Restore a previously saved GE context.
/// `context` - Pointer to a ::PspGeContext.
/// Returns < 0 on error.
pub fn restore_context(context: *const Context) !void {
    if (module.sceGeRestoreContext(@ptrCast(context)) < 0) {
        return error.RestoreContextFailed;
    }
}

/// Enqueue a display list at the tail of the GE display list queue.
/// `list` - The head of the list to queue.
/// `stall` - The stall address.
/// If NULL then no stall address is set and the list is transferred immediately.
/// `cbid` - ID of the callback set by calling sceGeSetCallback
/// `arg` - Structure containing GE context buffer address
/// Returns The ID of the queue, < 0 on error.
pub fn list_enqueue(list: ?*const anyopaque, stall: ?*anyopaque, cbid: c_int, arg: ?*ListArgs) !c_int {
    const result = module.sceGeListEnQueue(list, stall, cbid, @ptrCast(arg));
    if (result < 0) {
        return error.EnqueueFailed;
    }
    return result;
}

/// Enqueue a display list at the head of the GE display list queue.
/// `list` - The head of the list to queue.
/// `stall` - The stall address.
/// If NULL then no stall address is set and the list is transferred immediately.
/// `cbid` - ID of the callback set by calling sceGeSetCallback
/// `arg` - Structure containing GE context buffer address
/// Returns The ID of the queue, < 0 on error.
pub fn list_enqueue_head(list: ?*const anyopaque, stall: ?*anyopaque, cbid: c_int, arg: *ListArgs) c_int {
    const result = module.sceGeListEnQueueHead(list, stall, cbid, @ptrCast(arg));
    if (result < 0) {
        return error.EnqueueFailed;
    }
    return result;
}

/// Cancel a queued or running list.
/// `qid` - The ID of the queue.
/// Returns < 0 on error.
pub fn list_dequeue(qid: c_int) !void {
    if (module.sceGeListDeQueue(qid) < 0) {
        return error.DequeueFailed;
    }
}

/// Update the stall address for the specified queue.
/// `qid` - The ID of the queue.
/// `stall` - The new stall address.
/// Returns < 0 on error
pub fn list_update_stall_addr(qid: c_int, stall: ?*anyopaque) !void {
    if (module.sceGeListUpdateStallAddr(qid, stall) < 0) {
        return error.UpdateStallAddrFailed;
    }
}

/// Wait for syncronisation of a list.
/// `qid` - The queue ID of the list to sync.
/// `syncType` - 0 if you want to wait for the list to be completed, or 1 if you just want to peek the actual state.
/// Returns The specified queue status, one of ::PspGeListState.
pub fn list_sync(qid: c_int, syncType: SyncBehavior) ListState {
    return @enumFromInt(module.sceGeListSync(qid, @intFromEnum(syncType)));
}

/// Wait for drawing to complete.
/// `syncType` - 0 if you want to wait for the drawing to be completed, or 1 if you just want to peek the state of the display list currently being executed.
/// Returns The current queue status, one of ::PspGeListState.
pub fn draw_sync(syncType: SyncBehavior) ListState {
    return @enumFromInt(module.sceGeDrawSync(@intFromEnum(syncType)));
}

/// Interrupt drawing queue.
/// `mode` - If set to 1, reset all the queues.
/// `pParam` - Unused (just K1-checked).
/// Returns The stopped queue ID if mode isn't set to 0, otherwise 0, and < 0 on error.
pub fn @"break"(mode: c_int, pParam: *BreakParam) !c_int {
    const result = module.sceGeBreak(mode, pParam);
    if (result < 0) {
        return error.BreakFailed;
    }
    return result;
}

/// Restart drawing queue.
/// Returns < 0 on error.
pub fn @"continue"() !void {
    if (module.sceGeContinue() < 0) {
        return error.ContinueFailed;
    }
}

/// Register callback handlers for the the GE.
/// `cb` - Configured callback data structure.
/// Returns The callback ID, < 0 on error.
pub fn set_callback(cb: CallbackData) !c_int {
    const result = module.sceGeSetCallback(@constCast(&cb));
    if (result < 0) {
        return error.CallbackRegistrationFailed;
    }
    return result;
}

/// Unregister the callback handlers.
/// `cbid` - The ID of the callbacks, returned by sceGeSetCallback().
/// Returns < 0 on error
pub fn unset_callback(cbid: c_int) !void {
    if (module.sceGeUnsetCallback(cbid) < 0) {
        return error.CallbackUnregistrationFailed;
    }
}

/// Sets the EDRAM size to be enabled.
/// `size -size    The size (0x200000 or 0x400000). Will return an error if 0x400000 is specified for the PSP FAT.`
/// Returns Zero on success, otherwise less than zero.
pub fn edram_set_size(size: c_int) !void {
    if (module.sceGeEdramSetSize(size) < 0) {
        return error.EdramSizeSetFailed;
    }
}
