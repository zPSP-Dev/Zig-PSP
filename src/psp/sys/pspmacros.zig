const std = @import("std");

fn intToString(comptime int: u32, comptime buf: []u8) ![]const u8 {
    return try std.fmt.bufPrint(buf, "0x{x}", .{int});
}

pub fn import_module_start(comptime module: []const u8, comptime flags_ver: u32) ![]const u8{
    var buf: [20]u8 = undefined;
    var str = try intToString(flags_ver, &buf);
    return (
    \\.set push
	\\.section .rodata.sceResident, "a"
	\\.word   0
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
    ++ str ++ "\n" ++
	\\.word   0x5
	\\.word   __executable_start
	\\.word   __executable_start
	\\.set pop
    );
}

pub fn import_function(comptime module: []const u8, comptime func_id: u32, comptime funcname: []const u8) ![]const u8{
    var buf: [20]u8 = undefined;
    var str = try intToString(func_id, &buf);

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
    ++ str ++ "\n" ++
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