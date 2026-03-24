const std = @import("std");

pub fn import_module_start(comptime module: []const u8, comptime flags_ver: []const u8, comptime count: []const u8) []const u8 {
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

pub fn import_function(comptime module: []const u8, comptime func_id: []const u8, comptime funcname: []const u8) []const u8 {
    _ = module;
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

/// ABI wrapper for PSP functions of the form (i32, i64, trailing...).
///
/// Standard MIPS o32 (what Zig emits) aligns i64 to an even register pair, producing:
///   $a0=arg1  $a1=<gap>  $a2=i64_lo  $a3=i64_hi  [sp+16=trailing1  sp+20=trailing2]
///
/// The PSP kernel expects packed layout with no alignment gap:
///   $a0=arg1  $a1=i64_lo  $a2=i64_hi  $a3=trailing1  $t0=trailing2
///
/// This wrapper removes the gap and loads stack args into the right registers
/// before tail-calling the NID stub. trailing_args is the count of args after the i64.
pub fn i64_abi_wrapper(comptime funcname: []const u8, comptime trailing_args: u8) []const u8 {
    var load_trailing: []const u8 = undefined;
    if (trailing_args == 0) {
        load_trailing = "";
    } else if (trailing_args == 1) {
        load_trailing = "lw    $a3,16($sp)\n";
    } else if (trailing_args == 2) {
        load_trailing = "lw    $a3,16($sp)\nlw    $t0,20($sp)\n";
    } else {
        @compileError("i64_abi_wrapper: trailing_args must be 0, 1, or 2");
    }

    return (
        \\.section .text, "a"
        \\.global 
    ++ funcname ++ "\n" ++ funcname ++ ":\n" ++
        // Remove the o32 alignment gap: shift i64 from $a2:$a3 down to $a1:$a2.
        // Moves happen before $sp is adjusted so trailing lw offsets stay valid.
        \\move  $a1,$a2
        \\move  $a2,$a3
    ++ "\n" ++ load_trailing ++
        \\addiu $sp,$sp,-24
        \\sw    $ra,0($sp)
        \\jal 
    ++ funcname ++ "_stub\n" ++
        \\nop
        \\lw    $ra,0($sp)
        \\addiu $sp,$sp,24
        \\jr    $ra
        \\nop
    );
}

//INFO: https://people.eecs.berkeley.edu/~pattrsn/61CS99/lectures/lec24-args.pdf
//Excellent source on >4 MIPS calls.
//This is a generic wrapper for 5-7 func calls
pub fn generic_abi_wrapper(comptime funcname: []const u8, comptime argc: u8) []const u8 {

    //Add new stack space... How to calculate: 4 bytes * (num args + ra)
    var stackAlloc: []const u8 = undefined;
    //Conversely free it
    var stackFree: []const u8 = undefined;

    //Load the registers depending on arg count
    var regLoad: []const u8 = undefined;

    if (argc == 5) {
        stackAlloc = "add   $sp,$sp,-24\n";
        stackFree = "add   $sp,$sp,24\n";
        regLoad = (
            \\lw    $t0,16($sp) //Store arg5 from stack to t0
        );
    } else if (argc == 6) {
        stackAlloc = "add   $sp,$sp,-28\n";
        stackFree = "add   $sp,$sp,28\n";
        regLoad = (
            \\lw    $t0,16($sp) //Store arg5 from stack to t0
            \\lw    $t1,20($sp) //Store arg6 from stack to t1
        );
    } else if (argc == 7) {
        stackAlloc = "add   $sp,$sp,-32\n";
        stackFree = "add   $sp,$sp,32\n";
        regLoad = (
            \\lw    $t0,16($sp) //Store arg5 from stack to t0
            \\lw    $t1,20($sp) //Store arg6 from stack to t1
            \\lw    $t2,24($sp) //Store arg7 from stack to t2
        );
    } else if (argc == 8) {
        stackAlloc = "add   $sp,$sp,-36\n";
        stackFree = "add   $sp,$sp,36\n";
        regLoad = (
            \\lw    $t0,16($sp) //Store arg5 from stack to t0
            \\lw    $t1,20($sp) //Store arg6 from stack to t1
            \\lw    $t2,24($sp) //Store arg7 from stack to t2
            \\lw    $t3,28($sp) //Store arg8 from stack to t3
        );
    } else if (argc == 9) {
        stackAlloc = "add   $sp,$sp,-40\n";
        stackFree = "add   $sp,$sp,40\n";
        regLoad = (
            \\lw    $t0,16($sp) //Store arg5 from stack to t0
            \\lw    $t1,20($sp) //Store arg6 from stack to t1
            \\lw    $t2,24($sp) //Store arg7 from stack to t2
            \\lw    $t3,28($sp) //Store arg8 from stack to t3
            \\lw    $t4,32($sp) //Store arg9 from stack to t4 TODO: CHECK THIS!!!
        );
    } else {
        @compileError("Bad argc for generic ABI wrapper");
    }

    return (
        \\.section .text, "a"
        \\.global 
    ++ funcname ++ "\n" ++ funcname ++ ":\n" ++ regLoad ++ "\n" ++ stackAlloc ++
        //Preserve return
        \\sw    $ra,0($sp)  
        \\jal 
        //Call the alias
    ++ funcname ++ "_stub\n" ++ "\n" ++
        //Set correct return address
        \\lw    $ra, 0($sp) 
    ++ "\n" ++ stackFree ++
        //Return
        \\jr    $ra 
    );
}
