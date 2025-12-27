// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Get the size of VRAM.
/// Returns The size of VRAM (in bytes).
pub extern fn sceGeEdramGetSize() callconv(.c) c_uint;

/// Get the eDRAM address.
/// Returns A pointer to the base of the eDRAM.
pub extern fn sceGeEdramGetAddr() callconv(.c) ?*anyopaque;

/// Set the eDRAM address translation mode.
/// `width` - 0 to not set the translation width, otherwise 512, 1024, 2048 or 4096.
/// Returns The previous width if it was set, otherwise 0, < 0 on error.
pub extern fn sceGeEdramSetAddrTranslation(width: c_int) callconv(.c) c_int;

/// Retrieve the current value of a GE command.
/// `cmd` - The GE command register to retrieve (0 to 0xFF, both included).
/// Returns The value of the GE command, < 0 on error.
pub extern fn sceGeGetCmd(cmd: c_int) callconv(.c) c_uint;

/// Retrieve a matrix of the given type.
/// `type` - One of ::PspGeMatrixTypes.
/// `matrix` - Pointer to a variable to store the matrix.
/// Returns < 0 on error.
pub extern fn sceGeGetMtx(type: c_int, matrix: ?*anyopaque) callconv(.c) c_int;

/// Retrieve the stack of the display list currently being executed.
/// `stackId` - The ID of the stack to retrieve.
/// `stack` - Pointer to a structure to store the stack, or NULL to not store it.
/// Returns The number of stacks of the current display list, < 0 on error.
pub extern fn sceGeGetStack(stackId: c_int, stack: [*c]types.PspGeStack) callconv(.c) c_int;

/// Save the GE's current state.
/// `context` - Pointer to a ::PspGeContext.
/// Returns < 0 on error.
pub extern fn sceGeSaveContext(context: [*c]types.PspGeContext) callconv(.c) c_int;

/// Restore a previously saved GE context.
/// `context` - Pointer to a ::PspGeContext.
/// Returns < 0 on error.
pub extern fn sceGeRestoreContext(context: [*c]const types.PspGeContext) callconv(.c) c_int;

/// Enqueue a display list at the tail of the GE display list queue.
/// `list` - The head of the list to queue.
/// `stall` - The stall address.
/// If NULL then no stall address is set and the list is transferred immediately.
/// `cbid` - ID of the callback set by calling sceGeSetCallback
/// `arg` - Structure containing GE context buffer address
/// Returns The ID of the queue, < 0 on error.
pub extern fn sceGeListEnQueue(list: ?*const anyopaque, stall: ?*anyopaque, cbid: c_int, arg: [*c]types.PspGeListArgs) callconv(.c) c_int;

/// Enqueue a display list at the head of the GE display list queue.
/// `list` - The head of the list to queue.
/// `stall` - The stall address.
/// If NULL then no stall address is set and the list is transferred immediately.
/// `cbid` - ID of the callback set by calling sceGeSetCallback
/// `arg` - Structure containing GE context buffer address
/// Returns The ID of the queue, < 0 on error.
pub extern fn sceGeListEnQueueHead(list: ?*const anyopaque, stall: ?*anyopaque, cbid: c_int, arg: [*c]types.PspGeListArgs) callconv(.c) c_int;

/// Cancel a queued or running list.
/// `qid` - The ID of the queue.
/// Returns < 0 on error.
pub extern fn sceGeListDeQueue(qid: c_int) callconv(.c) c_int;

/// Update the stall address for the specified queue.
/// `qid` - The ID of the queue.
/// `stall` - The new stall address.
/// Returns < 0 on error
pub extern fn sceGeListUpdateStallAddr(qid: c_int, stall: ?*anyopaque) callconv(.c) c_int;

/// Wait for syncronisation of a list.
/// `qid` - The queue ID of the list to sync.
/// `syncType` - 0 if you want to wait for the list to be completed, or 1 if you just want to peek the actual state.
/// Returns The specified queue status, one of ::PspGeListState.
pub extern fn sceGeListSync(qid: c_int, syncType: c_int) callconv(.c) c_int;

/// Wait for drawing to complete.
/// `syncType` - 0 if you want to wait for the drawing to be completed, or 1 if you just want to peek the state of the display list currently being executed.
/// Returns The current queue status, one of ::PspGeListState.
pub extern fn sceGeDrawSync(syncType: c_int) callconv(.c) c_int;

/// Interrupt drawing queue.
/// `mode` - If set to 1, reset all the queues.
/// `pParam` - Unused (just K1-checked).
/// Returns The stopped queue ID if mode isn't set to 0, otherwise 0, and < 0 on error.
pub extern fn sceGeBreak(mode: c_int, pParam: [*c]types.PspGeBreakParam) callconv(.c) c_int;

/// Restart drawing queue.
/// Returns < 0 on error.
pub extern fn sceGeContinue() callconv(.c) c_int;

/// Register callback handlers for the the GE.
/// `cb` - Configured callback data structure.
/// Returns The callback ID, < 0 on error.
pub extern fn sceGeSetCallback(cb: [*c]types.PspGeCallbackData) callconv(.c) c_int;

/// Unregister the callback handlers.
/// `cbid` - The ID of the callbacks, returned by sceGeSetCallback().
/// Returns < 0 on error
pub extern fn sceGeUnsetCallback(cbid: c_int) callconv(.c) c_int;

/// Sets the EDRAM size to be enabled.
/// `size -size    The size (0x200000 or 0x400000). Will return an error if 0x400000 is specified for the PSP FAT.`
/// Returns Zero on success, otherwise less than zero.
pub extern fn sceGeEdramSetSize(size: c_int) callconv(.c) c_int;

comptime {
    asm (macro.import_module_start("sceGe_user", "0x40010000", "19"));
    asm (macro.import_function("sceGe_user", "0x1F6752AD", "sceGeEdramGetSize"));
    asm (macro.import_function("sceGe_user", "0xE47E40E4", "sceGeEdramGetAddr"));
    asm (macro.import_function("sceGe_user", "0xB77905EA", "sceGeEdramSetAddrTranslation"));
    asm (macro.import_function("sceGe_user", "0xDC93CFEF", "sceGeGetCmd"));
    asm (macro.import_function("sceGe_user", "0x57C8945B", "sceGeGetMtx"));
    asm (macro.import_function("sceGe_user", "0xE66CB92E", "sceGeGetStack"));
    asm (macro.import_function("sceGe_user", "0x438A385A", "sceGeSaveContext"));
    asm (macro.import_function("sceGe_user", "0x0BF608FB", "sceGeRestoreContext"));
    asm (macro.import_function("sceGe_user", "0xAB49E76A", "sceGeListEnQueue"));
    asm (macro.import_function("sceGe_user", "0x1C0D95A6", "sceGeListEnQueueHead"));
    asm (macro.import_function("sceGe_user", "0x5FB86AB0", "sceGeListDeQueue"));
    asm (macro.import_function("sceGe_user", "0xE0D68148", "sceGeListUpdateStallAddr"));
    asm (macro.import_function("sceGe_user", "0x03444EB4", "sceGeListSync"));
    asm (macro.import_function("sceGe_user", "0xB287BD61", "sceGeDrawSync"));
    asm (macro.import_function("sceGe_user", "0xB448EC0D", "sceGeBreak"));
    asm (macro.import_function("sceGe_user", "0x4C06E472", "sceGeContinue"));
    asm (macro.import_function("sceGe_user", "0xA4FC06A4", "sceGeSetCallback"));
    asm (macro.import_function("sceGe_user", "0x05DB22CE", "sceGeUnsetCallback"));
    asm (macro.import_function("sceGe_user", "0x5BAA5439", "sceGeEdramSetSize"));
}
