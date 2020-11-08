test "" {
    @import("std").meta.refAllDecls(@This());
}

usingnamespace @import("../include/psploadexec.zig");
usingnamespace @import("../include/pspthreadman.zig");
usingnamespace @import("../include/psptypes.zig");
usingnamespace @import("debug.zig");

const root = @import("root");

//If there's an issue this is the internal exit (wait 10 seconds and exit).
pub fn exitErr() void {
    //Hang for 10 seconds for error reporting
    var stat = sceKernelDelayThread(10 * 1000 * 1000);
    //Exit out.
    sceKernelExitGame();
}

const has_std_os = if (@hasDecl(root, "os")) true else false;

//This calls your main function as a thread.
pub fn _module_main_thread(argc: SceSize, argv: ?*c_void) callconv(.C) c_int {
    if (has_std_os) {
        pspos.system.__pspOsInit(argv);
    }

    switch (@typeInfo(@typeInfo(@TypeOf(root.main)).Fn.return_type.?)) {
        .NoReturn => {
            root.main();
        },
        .Void => {
            root.main();
            return 0;
        },
        .Int => |info| {
            if (info.bits != 8 or info.is_signed) {
                @compileError(bad_main_ret);
            }
            return root.main();
        },
        .ErrorUnion => {
            const result = root.main() catch |err| {
                print("ERROR CAUGHT: ");
                print(@errorName(err));
                print("\nExiting in 10 seconds...");

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

    if (exitOnEnd) {
        sceKernelExitGame();
    }
    return 0;
}

//Stub!
//
//Modified BSD License
//====================
//
//_Copyright � `2020`, `Hayden Kowalchuk`_
//_All rights reserved._
//
//Redistribution and use in source and binary forms, with or without
//modification, are permitted provided that the following conditions are met:
//
//1. Redistributions of source code must retain the above copyright
//   notice, this list of conditions and the following disclaimer.
//2. Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
//3. Neither the name of the `<organization>` nor the
//   names of its contributors may be used to endorse or promote products
//   derived from this software without specific prior written permission.
//
//THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS �AS IS� AND
//ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//DISCLAIMED. IN NO EVENT SHALL `Hayden Kowalchuk` BE LIABLE FOR ANY
//DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//    Thanks to mrneo240 (Hayden Kowalchuk) for the help
//
comptime {
    asm (
        \\.data
        \\.globl module_info
        \\.globl __syslib_exports
        \\.globl __library_exports
        \\
        \\.set push
        \\
        \\.section .lib.ent.top, "a", @progbits
        \\    .align 2
        \\    .word 0                                             
        \\__lib_ent_top:
        \\
        \\.section .lib.ent.btm, "a", @progbits
        \\    .align 2
        \\__lib_ent_bottom:
        \\    .word 0
        \\
        \\.section .lib.stub.top, "a", @progbits
        \\    .align 2
        \\    .word 0
        \\__lib_stub_top:
        \\
        \\.section .lib.stub.btm, "a", @progbits
        \\    .align 2
        \\__lib_stub_bottom:
        \\    .word 0
        \\
        \\.set pop
        \\
        \\.section .rodata.sceResident, "a", @progbits
        \\__syslib_exports:
        \\    .word 0xD632ACDB
        \\    .word 0xF01D73A7
        \\    .word module_start
        \\    .word module_info
        \\
        \\.section .lib.ent, "a", @progbits
        \\__library_exports:
        \\    .word 0
        \\    .hword 0
        \\    .hword 0x8000
        \\    .byte 4
        \\    .byte 1
        \\    .hword 1
        \\    .word __syslib_exports
    );
}

fn intToString(int: u32, buf: []u8) ![]const u8 {
    return try @import("std").fmt.bufPrint(buf, "{}", .{int});
}

pub fn module_info(comptime name: []const u8, comptime attrib: u16, comptime major: u8, comptime minor: u8) []const u8 {
    @setEvalBranchQuota(10000);
    var buf: [3]u8 = undefined;

    const maj = intToString(major, &buf) catch unreachable;
    buf = undefined;
    const min = intToString(minor, &buf) catch unreachable;
    buf = undefined;
    const attr = intToString(attrib, &buf) catch unreachable;
    buf = undefined;
    const count = intToString(27 - name.len, &buf) catch unreachable;

    return (
        \\.section .rodata.sceModuleInfo, "a", @progbits
        \\module_info:
        \\.align 5
        \\.hword 
        ++ attr ++ "\n" ++
        \\.byte 
        ++ maj ++ "\n" ++
        \\.byte 
        ++ min ++ "\n" ++
        \\.ascii "
        ++ name ++ "\"\n" ++
        \\.space 
        ++ count ++ "\n" ++
        \\.byte 0
        \\.word _gp
        \\.word __lib_ent_top
        \\.word __lib_ent_bottom
        \\.word __lib_stub_top
        \\.word __lib_stub_bottom
    );
}

const pspos = @import("../pspos.zig");
//Entry point - launches main through the thread above.
pub export fn module_start(argc: c_uint, argv: ?*c_void) c_int {
    var thid: SceUID = sceKernelCreateThread("zig_user_main", _module_main_thread, 0x20, 256 * 1024, 0b10000000000000000100000000000000, 0);
    return sceKernelStartThread(thid, argc, argv);
}
