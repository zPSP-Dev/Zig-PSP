pub extern fn sceSslInit(unknown1: c_int) c_int;
pub extern fn sceSslEnd() c_int;
pub extern fn sceSslGetUsedMemoryMax(memory: [*c]c_uint) c_int;
pub extern fn sceSslGetUsedMemoryCurrent(memory: [*c]c_uint) c_int;

const macro = @import("pspmacros.zig");

comptime{
    asm(macro.import_module_start("sceSsl", "0x00090011", "4"));
    asm(macro.import_function("sceSsl", "0x0EB43B06", "sceSslGetUsedMemoryCurrent"));
    asm(macro.import_function("sceSsl", "0x191CDEFF", "sceSslEnd"));
    asm(macro.import_function("sceSsl", "0x957ECBE2", "sceSslInit"));
    asm(macro.import_function("sceSsl", "0xB99EDE6A", "sceSslGetUsedMemoryMax"));
}