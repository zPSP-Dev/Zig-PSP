const ge = @import("../sdk/ge.zig");
const commands = @import("commands.zig");
const debug = @import("debug.zig");

pub const Error = ge.Error;
pub const ListArgs = ge.ListArgs;
pub const ListState = ge.ListState;
pub const SyncBehavior = ge.SyncBehavior;

const ptr_value = commands.ptr_value;

pub fn list_enqueue(list: ?*const anyopaque, stall: ?*anyopaque, cbid: i32, arg: ?*ListArgs) Error!i32 {
    debug.log_list_call("sceGeListEnqueue", list, stall);
    const qid = try ge.list_enqueue(list, stall, cbid, arg);
    debug.remember_queue(qid, list, stall);
    return qid;
}

pub fn list_enqueue_head(list: ?*const anyopaque, stall: ?*anyopaque, cbid: i32, arg: ?*ListArgs) Error!i32 {
    debug.log_list_call("sceGeListEnqueueHead", list, stall);
    const qid = try ge.list_enqueue_head(list, stall, cbid, arg);
    debug.remember_queue(qid, list, stall);
    return qid;
}

pub fn list_dequeue(qid: i32) Error!void {
    debug.log("sceGeListDequeue(qid={d})\n", .{qid});
    try ge.list_dequeue(qid);
}

pub fn list_update_stall_addr(qid: i32, stall: ?*anyopaque) Error!void {
    debug.log("sceGeListUpdateStallAddr(qid={d}, stall=0x{X})\n", .{ qid, ptr_value(stall) });
    debug.remember_queue_end(qid, stall);
    try ge.list_update_stall_addr(qid, stall);
}

pub fn list_sync(qid: i32, sync_type: SyncBehavior) ListState {
    const state = ge.list_sync(qid, sync_type);
    debug.log("sceGeListSync(qid={d}, sync={s}) -> {s}\n", .{ qid, @tagName(sync_type), @tagName(state) });
    return state;
}

pub fn draw_sync(sync_type: SyncBehavior) ListState {
    const state = ge.draw_sync(sync_type);
    debug.log("sceGeDrawSync(sync={s}) -> {s}\n", .{ @tagName(sync_type), @tagName(state) });
    return state;
}
