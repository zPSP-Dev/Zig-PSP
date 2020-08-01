const psp = @import("psp/pspsdk.zig");
const builtin = @import("builtin");

comptime{
    asm(
        \\.set push
        \\.section .lib.ent.top, "a", @progbits
        \\  .align 2
        \\  .word 0
        \\__lib_ent_top:
        \\  .section .lib.ent.btm, "a", @progbits
        \\  .align 2
        \\__lib_ent_bottom:
        \\.word 0
        \\  .section .lib.stub.top, "a", @progbits
        \\  .align 2
        \\.word 0
        \\__lib_stub_top:
        \\  .section .lib.stub.btm, "a", @progbits
        \\  .align 2
        \\__lib_stub_bottom:
        \\  .word 0
        \\  .set pop
        \\.text
        );
        
    asm(
        \\.data
        \\.globl module_info
        \\.section .rodata.sceModuleInfo
        \\module_info:
        \\    .align 5
        \\    .hword 0
        \\    .byte 1
        \\    .byte 0
        \\    .ascii "ASM"
        \\    .space 27 - 3
        \\    .byte 0
        \\    .word _gp
        \\    .word __lib_ent_top
        \\    .word __lib_ent_bottom
        \\    .word __lib_stub_top
        \\    .word __lib_stub_bottom
    );
}

pub export fn main(arg_argc: c_int, arg_argv: [*c][*c]u8) c_int {

    psp.sceKernelExitGame();
    return 0;
}
