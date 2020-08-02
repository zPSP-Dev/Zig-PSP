pub extern fn sceKernelRegisterDefaultExceptionHandler(func: ?*c_void) c_int;
pub extern fn sceKernelRegisterExceptionHandler(exno: c_int, func: ?*c_void) c_int;
pub extern fn sceKernelRegisterPriorityExceptionHandler(exno: c_int, priority: c_int, func: ?*c_void) c_int;