const std = @import("std");

const kernel = @import("../sdk/kernel.zig");

const debug = @import("debug.zig");
const psp_allocator = @import("allocator.zig");
const pool_allocator = @import("pool_allocator.zig");
const psp_io = @import("Io.zig");

const root = @import("root");

//If there's an issue this is the internal exit (wait 10 seconds and exit).
pub fn exitErr() void {
    //Hang for 10 seconds for error reporting
    kernel.delay_thread(10 * 1000 * 1000) catch {};
    //Exit out.
    kernel.exit_game();
}

// const has_std_os = if (@hasDecl(root, "os")) true else false;
const bad_main_ret = @compileError("Where is this from?!");

//This calls your main function as a thread.
pub fn _module_main_thread(argc: usize, argv: ?*anyopaque) callconv(.c) c_int {
    const fn_info = @typeInfo(@TypeOf(root.main)).@"fn";

    // Extract arg0 (program path) from the PSP argument buffer.
    // On PSP, argv points to packed null-terminated strings; the first
    // is the executable path (e.g. "ms0:/PSP/GAME/APP/EBOOT.PBP").
    const arg0: ?[*:0]const u8 = if (argv != null and argc > 0)
        @ptrCast(@alignCast(argv.?))
    else
        null;

    psp_io.init(arg0);

    // Allocate a large heap block from the PSP kernel. Size is user-configurable
    // via `pub const psp_heap_kb_size: u32 = N;` in the root source file, or
    // defaults to all available memory minus a 512 KB reserve.
    const heap_kb: u32 = if (@hasDecl(root, "psp_heap_kb_size")) root.psp_heap_kb_size else 0;
    const heap_size: usize = if (heap_kb > 0)
        @as(usize, heap_kb) * 1024
    else
        kernel.max_free_mem_size() -| (512 * 1024);

    const heap_uid = kernel.alloc_partition_memory(.user, "psp_heap", .mem_low, heap_size, null) catch return 1;
    defer kernel.free_partition_memory(heap_uid) catch {};

    const heap_base: [*]u8 = @ptrCast(kernel.get_block_head_addr(heap_uid) orelse return 1);
    var pool = pool_allocator.PoolAlloc.init(heap_base[0..heap_size], "psp_heap");

    // PSP is freestanding: Args.vector is void, Environ.block is GlobalBlock.
    var arena_allocator = std.heap.ArenaAllocator.init(psp_allocator.psp_page_allocator);
    defer arena_allocator.deinit();

    const init: std.process.Init = .{
        .minimal = .{
            .args = .{ .vector = &.{} },
            .environ = .{ .block = .empty },
        },
        .arena = &arena_allocator,
        .gpa = pool.allocator(),
        .io = psp_io.psp_io,
        .environ_map = undefined,
        .preopens = .empty,
    };

    switch (@typeInfo(fn_info.return_type.?)) {
        .noreturn => {
            if (fn_info.params.len == 0)
                root.main()
            else if (fn_info.params[0].type.? == std.process.Init.Minimal)
                root.main(init.minimal)
            else
                root.main(init);
        },
        .void => {
            if (fn_info.params.len == 0)
                root.main()
            else if (fn_info.params[0].type.? == std.process.Init.Minimal)
                root.main(init.minimal)
            else
                root.main(init);
            return 0;
        },
        .int => |info| {
            if (info.bits != 8 or info.is_signed) @compileError(bad_main_ret);
            return if (fn_info.params.len == 0)
                root.main()
            else if (fn_info.params[0].type.? == std.process.Init.Minimal)
                root.main(init.minimal)
            else
                root.main(init);
        },
        .error_union => {
            const main_result = if (fn_info.params.len == 0)
                root.main()
            else if (fn_info.params[0].type.? == std.process.Init.Minimal)
                root.main(init.minimal)
            else
                root.main(init);

            const result = main_result catch |err| {
                debug.print("ERROR CAUGHT: {s}\n", .{@errorName(err)});
                if (@errorReturnTrace()) |trace| {
                    debug.printTrace(trace);
                } else {
                    debug.print("(no return trace available)\n", .{});
                }
                debug.print("Exiting in 10 seconds...", .{});
                exitErr();
                return 1;
            };
            switch (@typeInfo(@TypeOf(result))) {
                .void => return 0,
                .int => |info| {
                    if (info.bits != 8) @compileError(bad_main_ret);
                    return result;
                },
                else => @compileError(bad_main_ret),
            }
        },
        else => @compileError(bad_main_ret),
    }

    if (debug.exitOnEnd) {
        kernel.exit_game();
    }
    return 0;
}

//Stub!
//
//Modified BSD License
//====================
//
//_Copyright (c) `2020`, `Hayden Kowalchuk`_
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
//THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
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
    return try std.fmt.bufPrint(buf, "{}", .{int});
}

const ModuleAttributes = packed struct(u16) {
    no_stop: bool = false, // PSP_MODULE_NO_STOP
    single_load: bool = false, // PSP_MODULE_SINGLE_LOAD
    single_start: bool = false, // PSP_MODULE_SINGLE_START

    _nibble0_rest: u1 = 0,
    _nibble1_unknown: u4 = 0,
    _nibble2_unknown: u4 = 0,

    mode: enum(u4) {
        User = 0, // PSP_MODULE_USER
        Kernel = 0x1, // PSP_MODULE_KERNEL
    },
};

pub fn module_info(comptime name: []const u8, comptime module_attributes: ModuleAttributes, comptime major: u8, comptime minor: u8) []const u8 {
    const MaxNameLength = 27;

    const attrib: u16 = @bitCast(module_attributes);

    std.debug.assert(name.len <= MaxNameLength);
    const padding_bytes = MaxNameLength - name.len;

    return (
        \\.section .rodata.sceModuleInfo, "a", @progbits
        \\module_info:
        \\.align 5
    ++ std.fmt.comptimePrint("\n.hword {d}\n", .{attrib}) //
    ++ std.fmt.comptimePrint(".byte {d}\n", .{major}) //
    ++ std.fmt.comptimePrint(".byte {d}\n", .{minor}) //
    ++ std.fmt.comptimePrint(".ascii \"{s}\"\n", .{name}) //
    ++ std.fmt.comptimePrint(".space {d}\n", .{padding_bytes}) ++ //
        \\.byte 0
        \\.word _gp
        \\.word __lib_ent_top
        \\.word __lib_ent_bottom
        \\.word __lib_stub_top
        \\.word __lib_stub_bottom
    );
}

// const pspos = @import("../pspos.zig");
//Entry point - launches main through the thread above.
pub export fn module_start(argc: c_uint, argv: ?*anyopaque) c_int {
    const stack_size: u32 = if (@hasDecl(root, "psp_stack_size")) root.psp_stack_size else 256 * 1024;
    const thid = kernel.create_thread("zig_user_main", _module_main_thread, 0x20, @intCast(stack_size), .{ .vfpu = true, .user = true }, null) catch return -1;
    kernel.start_thread(thid, argc, argv) catch return -1;
    return 0;
}
