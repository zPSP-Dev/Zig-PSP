
pub const struct_PspGeContext = extern struct {
    context: [512]c_uint,
};
pub const PspGeContext = struct_PspGeContext;
const struct_unnamed_5 = extern struct {
    stack: [8]c_uint,
};
pub const SceGeStack = struct_unnamed_5;
pub const PspGeCallback = ?fn (c_int, ?*c_void) callconv(.C) void;
pub const struct_PspGeCallbackData = extern struct {
    signal_func: PspGeCallback,
    signal_arg: ?*c_void,
    finish_func: PspGeCallback,
    finish_arg: ?*c_void,
};
pub const PspGeCallbackData = struct_PspGeCallbackData;
pub const struct_PspGeListArgs = extern struct {
    size: c_uint,
    context: [*c]PspGeContext,
    numStacks: u32,
    stacks: [*c]SceGeStack,
};
pub const PspGeListArgs = struct_PspGeListArgs;
pub const struct_PspGeBreakParam = extern struct {
    buf: [4]c_uint,
};
pub const PspGeBreakParam = struct_PspGeBreakParam;
pub extern fn sceGeEdramGetSize() c_uint;
pub extern fn sceGeEdramGetAddr() ?*c_void;
pub extern fn sceGeGetCmd(cmd: c_int) c_uint;

pub const enum_PspGeMatrixTypes = extern enum(c_int) {
    PSP_GE_MATRIX_BONE0 = 0,
    PSP_GE_MATRIX_BONE1 = 1,
    PSP_GE_MATRIX_BONE2 = 2,
    PSP_GE_MATRIX_BONE3 = 3,
    PSP_GE_MATRIX_BONE4 = 4,
    PSP_GE_MATRIX_BONE5 = 5,
    PSP_GE_MATRIX_BONE6 = 6,
    PSP_GE_MATRIX_BONE7 = 7,
    PSP_GE_MATRIX_WORLD = 8,
    PSP_GE_MATRIX_VIEW = 9,
    PSP_GE_MATRIX_PROJECTION = 10,
    PSP_GE_MATRIX_TEXGEN = 11,
    _,
};
pub const PspGeMatrixTypes = enum_PspGeMatrixTypes;
pub extern fn sceGeGetMtx(typec: c_int, matrix: ?*c_void) c_int;
const struct_unnamed_6 = extern struct {
    stack: [8]c_uint,
};
pub const PspGeStack = struct_unnamed_6;
pub extern fn sceGeGetStack(stackId: c_int, stack: [*c]PspGeStack) c_int;
pub extern fn sceGeSaveContext(context: [*c]PspGeContext) c_int;
pub extern fn sceGeRestoreContext(context: [*c]const PspGeContext) c_int;
pub extern fn sceGeListEnQueue(list: ?*const c_void, stall: ?*c_void, cbid: c_int, arg: [*c]PspGeListArgs) c_int;
pub extern fn sceGeListEnQueueHead(list: ?*const c_void, stall: ?*c_void, cbid: c_int, arg: [*c]PspGeListArgs) c_int;
pub extern fn sceGeListDeQueue(qid: c_int) c_int;
pub extern fn sceGeListUpdateStallAddr(qid: c_int, stall: ?*c_void) c_int;

pub const enum_PspGeListState = extern enum(c_int) {
    PSP_GE_LIST_DONE = 0,
    PSP_GE_LIST_QUEUED = 1,
    PSP_GE_LIST_DRAWING_DONE = 2,
    PSP_GE_LIST_STALL_REACHED = 3,
    PSP_GE_LIST_CANCEL_DONE = 4,
    _,
};
pub const PspGeListState = enum_PspGeListState;
pub extern fn sceGeListSync(qid: c_int, syncType: c_int) c_int;
pub extern fn sceGeDrawSync(syncType: c_int) c_int;
pub extern fn sceGeSetCallback(cb: [*c]PspGeCallbackData) c_int;
pub extern fn sceGeUnsetCallback(cbid: c_int) c_int;
pub extern fn sceGeBreak(mode: c_int, pParam: [*c]PspGeBreakParam) c_int;
pub extern fn sceGeContinue() c_int;
pub extern fn sceGeEdramSetAddrTranslation(width: c_int) c_int;

const macro = @import("pspmacros.zig");

comptime{
    asm(macro.import_module_start("sceGe_user", "0x40010000", "18"));
    asm(macro.import_function("sceGe_user", "0x1F6752AD", "sceGeEdramGetSize"));
    asm(macro.import_function("sceGe_user", "0xE47E40E4", "sceGeEdramGetAddr"));
    asm(macro.import_function("sceGe_user", "0xB77905EA", "sceGeEdramSetAddrTranslation"));
    asm(macro.import_function("sceGe_user", "0xDC93CFEF", "sceGeGetCmd"));
    asm(macro.import_function("sceGe_user", "0x57C8945B", "sceGeGetMtx"));
    asm(macro.import_function("sceGe_user", "0xE66CB92E", "sceGeGetStack"));
    asm(macro.import_function("sceGe_user", "0x438A385A", "sceGeSaveContext"));
    asm(macro.import_function("sceGe_user", "0x0BF608FB", "sceGeRestoreContext"));
    asm(macro.import_function("sceGe_user", "0xAB49E76A", "sceGeListEnQueue"));
    asm(macro.import_function("sceGe_user", "0x1C0D95A6", "sceGeListEnQueueHead"));
    asm(macro.import_function("sceGe_user", "0x5FB86AB0", "sceGeListDeQueue"));
    asm(macro.import_function("sceGe_user", "0xE0D68148", "sceGeListUpdateStallAddr"));
    asm(macro.import_function("sceGe_user", "0x03444EB4", "sceGeListSync"));
    asm(macro.import_function("sceGe_user", "0xB287BD61", "sceGeDrawSync"));
    asm(macro.import_function("sceGe_user", "0xB448EC0D", "sceGeBreak"));
    asm(macro.import_function("sceGe_user", "0x4C06E472", "sceGeContinue"));
    asm(macro.import_function("sceGe_user", "0xA4FC06A4", "sceGeSetCallback"));
    asm(macro.import_function("sceGe_user", "0x05DB22CE", "sceGeUnsetCallback"));
}