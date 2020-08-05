usingnamespace @import("sys/pspthreadman.zig");
usingnamespace @import("sys/psptypes.zig");

usingnamespace @import("debug.zig");
usingnamespace @import("utils.zig");
const root = @import("root");
const std = @import("std");

pub fn _module_main_thread(argc: SceSize, argv: ?*c_void) callconv(.C) c_int {
    switch (@typeInfo(@TypeOf(root.main).ReturnType)) {
        .NoReturn => {
            root.main();
        },
        .Void => {
            root.main();
            return 0;
        },
        .Int => |info| {
            if (info.bits != 8) {
                @compileError(bad_main_ret);
            }
            return root.main();
        },
        .ErrorUnion => {
            const result = root.main() catch |err| {

                //Will fail to print if the error is an OOM
                var psp_allocator = &PSPAllocator.init().allocator;
                const string = std.fmt.allocPrint(psp_allocator, "error caught: {}\n", .{@errorName(err)}) catch unreachable;
                print(string);

                //TODO: DUMP STACK TRACE

                //if (@errorReturnTrace()) |trace| {
                //    std.debug.dumpStackTrace(trace.*);
                //}

                return 1;
            };
            switch (@typeInfo(@TypeOf(result))) {
                .Void => return 0,
                .Int => |info| {
                    if (info.bits != 8) {
                        @compileError(bad_main_ret);
                    }
                    return result;
                },
                else => @compileError(bad_main_ret),
            }
        },
        else => @compileError(bad_main_ret),
    }
    return 0;
}

pub const module_start_struct = struct {
    export fn module_start(argc: c_uint, argv: ?*c_void) c_int {
        var thid : SceUID = 0;
        thid = sceKernelCreateThread("user_main", _module_main_thread, 0x20, 256 * 1024, @enumToInt(PspThreadAttributes.PSP_THREAD_ATTR_USER) | @enumToInt(PspThreadAttributes.PSP_THREAD_ATTR_VFPU), 0);
        return sceKernelStartThread(thid, argc, argv);   
    }
};