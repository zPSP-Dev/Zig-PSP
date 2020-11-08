pub const PspGeContext = extern struct {
    context: [512]c_uint,
};

pub const SceGeStack = extern struct {
    stack: [8]c_uint,
};

pub const PspGeCallback = ?fn (c_int, ?*c_void) callconv(.C) void;
pub const PspGeCallbackData = extern struct {
    signal_func: PspGeCallback,
    signal_arg: ?*c_void,
    finish_func: PspGeCallback,
    finish_arg: ?*c_void,
};

pub const PspGeListArgs = extern struct {
    size: c_uint,
    context: [*c]PspGeContext,
    numStacks: u32,
    stacks: [*c]SceGeStack,
};

pub const PspGeBreakParam = extern struct {
    buf: [4]c_uint,
};

pub const PspGeMatrixTypes = extern enum(c_int) {
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

pub const PspGeStack = extern struct {
    stack: [8]c_uint,
};

pub const PspGeListState = extern enum(c_int) {
    Done = 0,
    Queued = 1,
    DrawingDone = 2,
    StallReached = 3,
    CancelDone = 4,
};

// Get the size of VRAM.
//
// @return The size of VRAM (in bytes).
pub extern fn sceGeEdramGetSize() c_uint;

// Get the eDRAM address.
//
// @return A pointer to the base of the eDRAM.
pub extern fn sceGeEdramGetAddr() ?*c_void;

// Retrieve the current value of a GE command.
//
// @param cmd - The GE command register to retrieve (0 to 0xFF, both included).
//
// @return The value of the GE command, < 0 on error.
pub extern fn sceGeGetCmd(cmd: c_int) c_uint;

// Retrieve a matrix of the given type.
//
// @param type - One of ::PspGeMatrixTypes.
// @param matrix - Pointer to a variable to store the matrix.
//
// @return < 0 on error.
pub extern fn sceGeGetMtx(typec: c_int, matrix: ?*c_void) c_int;

// Save the GE's current state.
//
// @param context - Pointer to a ::PspGeContext.
//
// @return < 0 on error.
pub extern fn sceGeSaveContext(context: [*c]PspGeContext) c_int;

// Restore a previously saved GE context.
//
// @param context - Pointer to a ::PspGeContext.
//
// @return < 0 on error.
pub extern fn sceGeRestoreContext(context: [*c]const PspGeContext) c_int;

// Enqueue a display list at the tail of the GE display list queue.
//
// @param list - The head of the list to queue.
// @param stall - The stall address.
// If NULL then no stall address is set and the list is transferred immediately.
// @param cbid - ID of the callback set by calling sceGeSetCallback
// @param arg - Structure containing GE context buffer address
//
// @return The ID of the queue, < 0 on error.
pub extern fn sceGeListEnQueue(list: ?*const c_void, stall: ?*c_void, cbid: c_int, arg: [*c]PspGeListArgs) c_int;

// Enqueue a display list at the head of the GE display list queue.
//
// @param list - The head of the list to queue.
// @param stall - The stall address.
// If NULL then no stall address is set and the list is transferred immediately.
// @param cbid - ID of the callback set by calling sceGeSetCallback
// @param arg - Structure containing GE context buffer address
//
// @return The ID of the queue, < 0 on error.
pub extern fn sceGeListEnQueueHead(list: ?*const c_void, stall: ?*c_void, cbid: c_int, arg: [*c]PspGeListArgs) c_int;

// Cancel a queued or running list.
//
// @param qid - The ID of the queue.
//
// @return < 0 on error.
pub extern fn sceGeListDeQueue(qid: c_int) c_int;

// Update the stall address for the specified queue.
//
// @param qid - The ID of the queue.
// @param stall - The new stall address.
//
// @return < 0 on error
pub extern fn sceGeListUpdateStallAddr(qid: c_int, stall: ?*c_void) c_int;

// Wait for syncronisation of a list.
//
// @param qid - The queue ID of the list to sync.
// @param syncType - 0 if you want to wait for the list to be completed, or 1 if you just want to peek the actual state.
//
// @return The specified queue status, one of ::PspGeListState.
pub extern fn sceGeListSync(qid: c_int, syncType: c_int) c_int;

// Wait for drawing to complete.
//
// @param syncType - 0 if you want to wait for the drawing to be completed, or 1 if you just want to peek the state of the display list currently being executed.
//
// @return The current queue status, one of ::PspGeListState.
pub extern fn sceGeDrawSync(syncType: c_int) c_int;

// Register callback handlers for the the GE.
//
// @param cb - Configured callback data structure.
//
// @return The callback ID, < 0 on error.
pub extern fn sceGeSetCallback(cb: *PspGeCallbackData) c_int;

// Unregister the callback handlers.
//
// @param cbid - The ID of the callbacks, returned by sceGeSetCallback().
//
// @return < 0 on error
pub extern fn sceGeUnsetCallback(cbid: c_int) c_int;

// Interrupt drawing queue.
//
// @param mode - If set to 1, reset all the queues.
// @param pParam - Unused (just K1-checked).
//
// @return The stopped queue ID if mode isn't set to 0, otherwise 0, and < 0 on error.
pub extern fn sceGeBreak(mode: c_int, pParam: [*c]PspGeBreakParam) c_int;

// Restart drawing queue.
//
// @return < 0 on error.
pub extern fn sceGeContinue() c_int;

// Set the eDRAM address translation mode.
//
// @param width - 0 to not set the translation width, otherwise 512, 1024, 2048 or 4096.
//
// @return The previous width if it was set, otherwise 0, < 0 on error.
pub extern fn sceGeEdramSetAddrTranslation(width: c_int) c_int;
