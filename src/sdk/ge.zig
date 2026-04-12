// Graphics Engine -- command lists, EDRAM, GE callbacks
//
// Wraps:
//   c/module/sceGe_user.zig

const int = @import("errors/ge.zig");
const internal = @import("internal.zig");
const check = int.check;
const checkPositive = int.checkPositive;
const ci = internal.ci;
const cu = internal.cu;
const c = @import("../c/modules.zig");
const module = c.sceGe_user;

pub const BreakParam = c.types.PspGeBreakParam;
pub const CallbackData = c.types.PspGeCallbackData;
pub const Context = c.types.PspGeContext;
pub const ListArgs = c.types.PspGeListArgs;
pub const Stack = c.types.PspGeStack;

pub const MatrixType = enum(u32) {
    bone0 = 0,
    bone1 = 1,
    bone2 = 2,
    bone3 = 3,
    bone4 = 4,
    bone5 = 5,
    bone6 = 6,
    bone7 = 7,
    world = 8,
    view = 9,
    projection = 10,
    texgen = 11,
};

pub const ListState = enum(u32) {
    done = 0,
    queued = 1,
    drawing_done = 2,
    stall_reached = 3,
    cancel_done = 4,
};

pub const SyncBehavior = enum(u32) {
    wait = 0,
    no_wait = 1,
};

pub const Error = int.Error;

/// Get the size of VRAM in bytes.
pub fn edram_get_size() u32 {
    return module.sceGeEdramGetSize();
}

/// Get a pointer to the base of eDRAM.
pub fn edram_get_addr() ?*anyopaque {
    return module.sceGeEdramGetAddr();
}

/// Set the eDRAM address translation width.
/// `width` - 0 to not set, otherwise 512, 1024, 2048 or 4096.
/// Returns the previous width if it was set, otherwise 0.
pub fn edram_set_addr_translation(width: u32) Error!u32 {
    return checkPositive(u32, module.sceGeEdramSetAddrTranslation(ci(width)));
}

/// Retrieve the current value of a GE command register (0x00-0xFF).
pub fn get_cmd(cmd: u32) u32 {
    return module.sceGeGetCmd(ci(cmd));
}

/// Retrieve a GE matrix.
pub fn get_mtx(matrix_type: MatrixType, matrix: ?*anyopaque) Error!void {
    try check(module.sceGeGetMtx(ci(@intFromEnum(matrix_type)), matrix));
}

/// Retrieve the stack of the display list currently being executed.
/// Returns the number of stacks of the current display list.
pub fn get_stack(stack_id: i32, stack: ?*Stack) Error!u32 {
    return checkPositive(u32, module.sceGeGetStack(stack_id, stack));
}

/// Save the GE's current state.
pub fn save_context(context: *Context) Error!void {
    try check(module.sceGeSaveContext(context));
}

/// Restore a previously saved GE context.
pub fn restore_context(context: *const Context) Error!void {
    try check(module.sceGeRestoreContext(context));
}

/// Enqueue a display list at the tail of the GE display list queue.
/// Returns the queue ID.
pub fn list_enqueue(list: ?*const anyopaque, stall: ?*anyopaque, cbid: i32, arg: ?*ListArgs) Error!i32 {
    return checkPositive(i32, module.sceGeListEnQueue(list, stall, cbid, arg));
}

/// Enqueue a display list at the head of the GE display list queue.
/// Returns the queue ID.
pub fn list_enqueue_head(list: ?*const anyopaque, stall: ?*anyopaque, cbid: i32, arg: ?*ListArgs) Error!i32 {
    return checkPositive(i32, module.sceGeListEnQueueHead(list, stall, cbid, arg));
}

/// Cancel a queued or running list.
pub fn list_dequeue(qid: i32) Error!void {
    try check(module.sceGeListDeQueue(qid));
}

/// Update the stall address for the specified queue.
pub fn list_update_stall_addr(qid: i32, stall: ?*anyopaque) Error!void {
    try check(module.sceGeListUpdateStallAddr(qid, stall));
}

/// Wait for synchronisation of a list.
/// `sync_type` - `.wait` to block until complete, `.no_wait` to peek current state.
/// Returns the queue status.
pub fn list_sync(qid: i32, sync_type: SyncBehavior) ListState {
    return @enumFromInt(cu(module.sceGeListSync(qid, ci(@intFromEnum(sync_type)))));
}

/// Wait for drawing to complete.
/// `sync_type` - `.wait` to block until complete, `.no_wait` to peek current state.
/// Returns the current queue status.
pub fn draw_sync(sync_type: SyncBehavior) ListState {
    return @enumFromInt(cu(module.sceGeDrawSync(ci(@intFromEnum(sync_type)))));
}

/// Interrupt drawing queue.
/// `mode` - If set to 1, reset all queues.
/// Returns the stopped queue ID if mode isn't 0, otherwise 0.
pub fn @"break"(mode: u32, param: ?*BreakParam) Error!u32 {
    return checkPositive(u32, module.sceGeBreak(ci(mode), param));
}

/// Restart drawing queue.
pub fn @"continue"() Error!void {
    try check(module.sceGeContinue());
}

/// Register callback handlers for the GE.
/// Returns the callback ID.
pub fn set_callback(cb: CallbackData) Error!i32 {
    return checkPositive(i32, module.sceGeSetCallback(@constCast(&cb)));
}

/// Unregister the callback handlers.
pub fn unset_callback(cbid: i32) Error!void {
    try check(module.sceGeUnsetCallback(cbid));
}

/// Set the eDRAM size to be enabled.
/// `size` - 0x200000 or 0x400000 (0x400000 returns error on PSP FAT).
pub fn edram_set_size(size: u32) Error!void {
    try check(module.sceGeEdramSetSize(ci(size)));
}
