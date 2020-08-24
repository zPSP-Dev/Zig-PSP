usingnamespace @import("../sys/psploadexec.zig");
usingnamespace @import("../sys/pspthreadman.zig");
usingnamespace @import("../sys/psptypes.zig");

usingnamespace @import("debug.zig");
usingnamespace @import("utils.zig");

const builtin = @import("builtin");
const root = @import("root");
const std = @import("std");

//If there's an issue this is the internal exit (wait 10 seconds and exit).
pub fn exitErr() void {
    //Hang for 10 seconds for error reporting
    var stat = sceKernelDelayThread(10 * 1000 * 1000);
    //Exit out.
    sceKernelExitGame();
}

//This calls your main function as a thread.
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

                print("ERROR CAUGHT: ");
                print(@errorName(err));

                print("\nZig-PSP doesn't support stack traces - yet.\n");
                print("Exiting in 10 seconds...");
                //TODO: DUMP STACK TRACE
                //if (@errorReturnTrace()) |trace| {
                //    std.debug.dumpStackTrace(trace.*);
                //}
                
                exitErr();
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

    if(exitOnEnd){
        sceKernelExitGame();
    }
    return 0;
}

//This includes the module stub assembly which is required - cannot be done in Zig afaik.
comptime{
    asm(@embedFile("./stub.S"));
}

//This structure exists in order to guarantee module_start is included - which is the PSP entry point.
pub const module_start_struct = struct {
    //Entry point - launches main through the thread above.
    export fn module_start(argc: c_uint, argv: ?*c_void) c_int {
        //var thid : SceUID = sceKernelCreateThread("user_main", _module_main_thread, 0x20, 256 * 1024, 0b10000000000000000100000000000000, 0);
        
        //if(thid < 0){
        //    screenInit();
        //    print("\nZig Init Failed!\n");
        //    
        //    var buf: [20]u8 = undefined;
        //    printFormat("\n{d}\n", .{thid}) catch unreachable;
        //    print("Exiting in 10 seconds...");
        //    exitErr();
        //    return 1;
        //}

        //return sceKernelStartThread(thid, argc, argv);
        return _module_main_thread(argc, argv);
    }
};