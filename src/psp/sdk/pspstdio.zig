usingnamespace @import("psptypes.zig");

// Function to get the current standard in file no
//
// @return The stdin fileno
pub extern fn sceKernelStdin() SceUID;

// Function to get the current standard out file no
//
// @return The stdout fileno
pub extern fn sceKernelStdout() SceUID;

// Function to get the current standard err file no
//
// @return The stderr fileno
pub extern fn sceKernelStderr() SceUID;
