pub const PspDebugPutChar = ?fn ([*c]c_ushort, c_uint) callconv(.C) void;
pub extern fn sceKernelRegisterDebugPutchar(func: PspDebugPutChar) void;
pub extern fn sceKernelGetDebugPutchar() PspDebugPutChar;
pub extern fn Kprintf(format: [*c]const u8, ...) void;
