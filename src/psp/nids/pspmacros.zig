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
