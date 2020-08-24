const std = @import("std");

pub fn import_module_start(comptime module: []const u8, comptime flags_ver: []const u8, comptime count: []const u8) []const u8{
    return (
    \\.set push
    \\.set noreorder
    \\.section .rodata.sceResident, "a"
\\__stub_modulestr_
    ++ module ++ ":\n" ++ 
    \\.asciz  "
    ++ module ++ "\"\n" ++
    \\.align  2
    \\.section .lib.stub, "a", @progbits
    \\.global __stub_module_
    ++ module ++ "\n" ++
\\__stub_module_
    ++ module ++ ":\n" ++
    \\.word   __stub_modulestr_
    ++ module ++ "\n" ++
    \\.word   
    ++ flags_ver ++ "\n" ++
    \\.hword   0x5
    \\.hword 
    ++ count ++ "\n" ++
    \\.word   __stub_idtable_
    ++ module ++ "\n" ++
    \\.word   __stub_text_
    ++ module ++ "\n" ++
    \\.section .rodata.sceNid, "a"
\\__stub_idtable_
    ++ module ++ ":\n" ++
    \\.section .sceStub.text, "ax", @progbits
\\__stub_text_
    ++ module ++ ":\n" ++
    \\.set pop
    );
}

pub fn import_function(comptime module: []const u8, comptime func_id: []const u8, comptime funcname: []const u8) []const u8{
    return (
    \\.set push
    \\.set noreorder

    \\.extern __stub_module_
    ++ module ++ "\n" ++
    \\.section .sceStub.text, "ax", @progbits
    \\.globl 
    ++ funcname ++ "\n" ++
    \\.type   
    ++ funcname ++ ", @function\n" ++
    \\.ent    
    ++ funcname ++ ", 0\n" ++
funcname ++ ":\n" ++
    \\.word   __stub_module_
    ++ module ++ "\n" ++
    \\.word   
    ++ func_id ++ "\n" ++
    \\.end    
    ++ funcname ++ "\n" ++
    \\.size   
    ++ funcname ++ ", .-" ++ funcname ++ "\n" ++
    \\.section .rodata.sceNid, "a"
    \\.word   
    ++ str ++ "\n" ++
    \\.set pop
    );
}
pub fn import_function2(comptime module: []const u8, comptime func_id: []const u8, comptime funcname: []const u8) []const u8{
    return (
    \\.set push
    \\.set noreorder

    \\.section .sceStub.text, "ax", @progbits
    \\.globl 
    ++ funcname ++ "\n" ++
    \\.type   
    ++ funcname ++ ", @function\n" ++
    \\.ent    
    ++ funcname ++ ", 0\n" ++
funcname ++ ":\n" ++
    \\jr $ra
    \\nop
    \\.end    
    ++ funcname ++ "\n" ++
    \\.size   
    ++ funcname ++ ", .-" ++ funcname ++ "\n" ++
    \\.section .rodata.sceNid, "a"
    \\.word   
    ++ func_id ++ "\n" ++
    \\.set pop
    );
}