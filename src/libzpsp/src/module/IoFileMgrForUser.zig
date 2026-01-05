// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Poll for asyncronous completion.
/// `fd` - The file descriptor which is current performing an asynchronous action.
/// `res` - The result of the async action.
/// Returns < 0 on error.
pub extern fn sceIoPollAsync(fd: types.SceUID, res: [*c]i64) callconv(.c) c_int;

/// Wait for asyncronous completion.
/// `fd` - The file descriptor which is current performing an asynchronous action.
/// `res` - The result of the async action.
/// Returns < 0 on error.
pub extern fn sceIoWaitAsync(fd: types.SceUID, res: [*c]i64) callconv(.c) c_int;

/// Wait for asyncronous completion (with callbacks).
/// `fd` - The file descriptor which is current performing an asynchronous action.
/// `res` - The result of the async action.
/// Returns < 0 on error.
pub extern fn sceIoWaitAsyncCB(fd: types.SceUID, res: [*c]i64) callconv(.c) c_int;

/// Get the asyncronous completion status.
/// `fd` - The file descriptor which is current performing an asynchronous action.
/// `poll` - If 0 then waits for the status, otherwise it polls the fd.
/// `res` - The result of the async action.
/// Returns < 0 on error.
pub extern fn sceIoGetAsyncStat(fd: types.SceUID, poll: c_int, res: [*c]i64) callconv(.c) c_int;

/// Change the priority of the asynchronous thread.
/// `fd` - The opened fd on which the priority should be changed.
/// `pri` - The priority of the thread.
/// Returns < 0 on error.
pub extern fn sceIoChangeAsyncPriority(fd: types.SceUID, pri: c_int) callconv(.c) c_int;

/// Sets a callback for the asynchronous action.
/// `fd` - The filedescriptor currently performing an asynchronous action.
/// `cb` - The UID of the callback created with ::sceKernelCreateCallback
/// `argp` - Pointer to an argument to pass to the callback.
/// Returns < 0 on error.
pub extern fn sceIoSetAsyncCallback(fd: types.SceUID, cb: types.SceUID, argp: ?*anyopaque) callconv(.c) c_int;

/// Delete a descriptor
/// `
/// sceIoClose(fd);
/// `
/// `fd` - File descriptor to close
/// Returns < 0 on error
pub extern fn sceIoClose(fd: types.SceUID) callconv(.c) c_int;

/// Delete a descriptor (asynchronous)
/// `fd` - File descriptor to close
/// Returns < 0 on error
pub extern fn sceIoCloseAsync(fd: types.SceUID) callconv(.c) c_int;

/// Open or create a file for reading or writing
/// @par Example1: Open a file for reading
/// `
/// if(!(fd = sceIoOpen("device:/path/to/file", O_RDONLY, 0777)) {
/// // error
/// }
/// `
/// @par Example2: Open a file for writing, creating it if it doesnt exist
/// `
/// if(!(fd = sceIoOpen("device:/path/to/file", O_WRONLY|O_CREAT, 0777)) {
/// // error
/// }
/// `
/// `file` - Pointer to a string holding the name of the file to open
/// `flags` - Libc styled flags that are or'ed together
/// `mode` - File access mode.
/// Returns A non-negative integer is a valid fd, anything else an error
pub extern fn sceIoOpen(file: [*c]const c_char, flags: c_int, mode: types.SceMode) callconv(.c) types.SceUID;

/// Open or create a file for reading or writing (asynchronous)
/// `file` - Pointer to a string holding the name of the file to open
/// `flags` - Libc styled flags that are or'ed together
/// `mode` - File access mode.
/// Returns A non-negative integer is a valid fd, anything else an error
pub extern fn sceIoOpenAsync(file: [*c]const c_char, flags: c_int, mode: types.SceMode) callconv(.c) types.SceUID;

/// Read input
/// @par Example:
/// `
/// bytes_read = sceIoRead(fd, data, 100);
/// `
/// `fd` - Opened file descriptor to read from
/// `data` - Pointer to the buffer where the read data will be placed
/// `size` - Size of the read in bytes
/// Returns The number of bytes read
pub extern fn sceIoRead(fd: types.SceUID, data: ?*anyopaque, size: usize) callconv(.c) c_int;

/// Read input (asynchronous)
/// @par Example:
/// `
/// bytes_read = sceIoRead(fd, data, 100);
/// `
/// `fd` - Opened file descriptor to read from
/// `data` - Pointer to the buffer where the read data will be placed
/// `size` - Size of the read in bytes
/// Returns < 0 on error.
pub extern fn sceIoReadAsync(fd: types.SceUID, data: ?*anyopaque, size: usize) callconv(.c) c_int;

/// Write output
/// @par Example:
/// `
/// bytes_written = sceIoWrite(fd, data, 100);
/// `
/// `fd` - Opened file descriptor to write to
/// `data` - Pointer to the data to write
/// `size` - Size of data to write
/// Returns The number of bytes written
pub extern fn sceIoWrite(fd: types.SceUID, data: ?*const anyopaque, size: usize) callconv(.c) c_int;

/// Write output (asynchronous)
/// `fd` - Opened file descriptor to write to
/// `data` - Pointer to the data to write
/// `size` - Size of data to write
/// Returns < 0 on error.
pub extern fn sceIoWriteAsync(fd: types.SceUID, data: ?*const anyopaque, size: usize) callconv(.c) c_int;

/// Reposition read/write file descriptor offset
/// @par Example:
/// `
/// pos = sceIoLseek(fd, -10, SEEK_END);
/// `
/// `fd` - Opened file descriptor with which to seek
/// `offset` - Relative offset from the start position given by whence
/// `whence` - Set to SEEK_SET to seek from the start of the file, SEEK_CUR
/// seek from the current position and SEEK_END to seek from the end.
/// Returns The position in the file after the seek.
pub extern fn sceIoLseek(fd: types.SceUID, offset: i64, whence: c_int) callconv(.c) i64;

/// Reposition read/write file descriptor offset (asynchronous)
/// `fd` - Opened file descriptor with which to seek
/// `offset` - Relative offset from the start position given by whence
/// `whence` - Set to SEEK_SET to seek from the start of the file, SEEK_CUR
/// seek from the current position and SEEK_END to seek from the end.
/// Returns < 0 on error. Actual value should be passed returned by the ::sceIoWaitAsync call.
pub extern fn sceIoLseekAsync(fd: types.SceUID, offset: i64, whence: c_int) callconv(.c) c_int;

/// Reposition read/write file descriptor offset (32bit mode)
/// @par Example:
/// `
/// pos = sceIoLseek32(fd, -10, SEEK_END);
/// `
/// `fd` - Opened file descriptor with which to seek
/// `offset` - Relative offset from the start position given by whence
/// `whence` - Set to SEEK_SET to seek from the start of the file, SEEK_CUR
/// seek from the current position and SEEK_END to seek from the end.
/// Returns The position in the file after the seek.
pub extern fn sceIoLseek32(fd: types.SceUID, offset: c_int, whence: c_int) callconv(.c) c_int;

/// Reposition read/write file descriptor offset (32bit mode, asynchronous)
/// `fd` - Opened file descriptor with which to seek
/// `offset` - Relative offset from the start position given by whence
/// `whence` - Set to SEEK_SET to seek from the start of the file, SEEK_CUR
/// seek from the current position and SEEK_END to seek from the end.
/// Returns < 0 on error.
pub extern fn sceIoLseek32Async(fd: types.SceUID, offset: c_int, whence: c_int) callconv(.c) c_int;

/// Perform an ioctl on a device.
/// `fd` - Opened file descriptor to ioctl to
/// `cmd` - The command to send to the device
/// `indata` - A data block to send to the device, if NULL sends no data
/// `inlen` - Length of indata, if 0 sends no data
/// `outdata` - A data block to receive the result of a command, if NULL receives no data
/// `outlen` - Length of outdata, if 0 receives no data
/// Returns 0 on success, < 0 on error
pub extern fn sceIoIoctl(fd: types.SceUID, cmd: c_uint, indata: ?*anyopaque, inlen: c_int, outdata: ?*anyopaque, outlen: c_int) callconv(.c) c_int;

/// Perform an ioctl on a device. (asynchronous)
/// `fd` - Opened file descriptor to ioctl to
/// `cmd` - The command to send to the device
/// `indata` - A data block to send to the device, if NULL sends no data
/// `inlen` - Length of indata, if 0 sends no data
/// `outdata` - A data block to receive the result of a command, if NULL receives no data
/// `outlen` - Length of outdata, if 0 receives no data
/// Returns 0 on success, < 0 on error
pub extern fn sceIoIoctlAsync(fd: types.SceUID, cmd: c_uint, indata: ?*anyopaque, inlen: c_int, outdata: ?*anyopaque, outlen: c_int) callconv(.c) c_int;

/// Open a directory
/// @par Example:
/// `
/// int dfd;
/// dfd = sceIoDopen("device:/");
/// if(dfd >= 0)
/// { Do something with the file descriptor }
/// `
/// `dirname` - The directory to open for reading.
/// Returns If >= 0 then a valid file descriptor, otherwise a Sony error code.
pub extern fn sceIoDopen(dirname: [*c]const c_char) callconv(.c) types.SceUID;

/// Reads an entry from an opened file descriptor.
/// `fd` - Already opened file descriptor (using sceIoDopen)
/// `dir` - Pointer to an io_dirent_t structure to hold the file information
/// Returns Read status
/// -   0 - No more directory entries left
/// - > 0 - More directory entired to go
/// - < 0 - Error
pub extern fn sceIoDread(fd: types.SceUID, dir: [*c]types.SceIoDirent) callconv(.c) c_int;

/// Close an opened directory file descriptor
/// `fd` - Already opened file descriptor (using sceIoDopen)
/// Returns < 0 on error
pub extern fn sceIoDclose(fd: types.SceUID) callconv(.c) c_int;

/// Remove directory entry
/// `file` - Path to the file to remove
/// Returns < 0 on error
pub extern fn sceIoRemove(file: [*c]const c_char) callconv(.c) c_int;

/// Make a directory file
/// `dir`
/// `mode` - Access mode.
/// Returns Returns the value 0 if its succesful otherwise -1
pub extern fn sceIoMkdir(dir: [*c]const c_char, mode: types.SceMode) callconv(.c) c_int;

/// Remove a directory file
/// `path` - Removes a directory file pointed by the string path
/// Returns Returns the value 0 if its succesful otherwise -1
pub extern fn sceIoRmdir(path: [*c]const c_char) callconv(.c) c_int;

/// Change the current directory.
/// `path` - The path to change to.
/// Returns < 0 on error.
pub extern fn sceIoChdir(path: [*c]const c_char) callconv(.c) c_int;

/// Synchronise the file data on the device.
/// `device` - The device to synchronise (e.g. msfat0:)
/// `unk` - Unknown
pub extern fn sceIoSync(device: [*c]const c_char, unk: c_uint) callconv(.c) c_int;

/// Get the status of a file.
/// `file` - The path to the file.
/// `stat` - A pointer to an io_stat_t structure.
/// Returns < 0 on error.
pub extern fn sceIoGetstat(file: [*c]const c_char, stat: [*c]types.SceIoStat) callconv(.c) c_int;

/// Change the status of a file.
/// `file` - The path to the file.
/// `stat` - A pointer to an io_stat_t structure.
/// `bits` - Bitmask defining which bits to change.
/// Returns < 0 on error.
pub extern fn sceIoChstat(file: [*c]const c_char, stat: [*c]types.SceIoStat, bits: c_int) callconv(.c) c_int;

/// Change the name of a file
/// `oldname` - The old filename
/// `newname` - The new filename
/// Returns < 0 on error.
pub extern fn sceIoRename(oldname: [*c]const c_char, newname: [*c]const c_char) callconv(.c) c_int;

/// Send a devctl command to a device.
/// @par Example: Sending a simple command to a device (not a real devctl)
/// `
/// sceIoDevctl("ms0:", 0x200000, indata, 4, NULL, NULL);
/// `
/// `dev` - String for the device to send the devctl to (e.g. "ms0:")
/// `cmd` - The command to send to the device
/// `indata` - A data block to send to the device, if NULL sends no data
/// `inlen` - Length of indata, if 0 sends no data
/// `outdata` - A data block to receive the result of a command, if NULL receives no data
/// `outlen` - Length of outdata, if 0 receives no data
/// Returns 0 on success, < 0 on error
pub extern fn sceIoDevctl(dev: [*c]const c_char, cmd: c_uint, indata: ?*anyopaque, inlen: c_int, outdata: ?*anyopaque, outlen: c_int) callconv(.c) c_int;

/// Get the device type of the currently opened file descriptor.
/// `fd` - The opened file descriptor.
/// Returns < 0 on error. Otherwise the device type?
pub extern fn sceIoGetDevType(fd: types.SceUID) callconv(.c) c_int;

/// Assigns one IO device to another (I guess)
/// `dev1` - The device name to assign.
/// `dev2` - The block device to assign from.
/// `dev3` - The filesystem device to mape the block device to dev1
/// `mode` - Read/Write mode. One of IoAssignPerms.
/// `unk1` - Unknown, set to NULL.
/// `unk2` - Unknown, set to 0.
/// Returns < 0 on error.
/// @par Example: Reassign flash0 in read/write mode.
/// `
/// sceIoUnassign("flash0");
/// sceIoAssign("flash0", "lflash0:0,0", "flashfat0:", IOASSIGN_RDWR, NULL, 0);
/// `
pub extern fn sceIoAssign(dev1: [*c]const c_char, dev2: [*c]const c_char, dev3: [*c]const c_char, mode: c_int, unk1: ?*anyopaque, unk2: c_long) callconv(.c) c_int;

/// Unassign an IO device.
/// `dev` - The device to unassign.
/// Returns < 0 on error
/// @par Example: See ::sceIoAssign
pub extern fn sceIoUnassign(dev: [*c]const c_char) callconv(.c) c_int;

/// Cancel an asynchronous operation on a file descriptor.
/// `fd` - The file descriptor to perform cancel on.
/// Returns < 0 on error.
pub extern fn sceIoCancel(fd: types.SceUID) callconv(.c) c_int;

comptime {
    asm (macro.import_module_start("IoFileMgrForUser", "0x40010000", "36"));
    asm (macro.import_function("IoFileMgrForUser", "0x3251EA56", "sceIoPollAsync"));
    asm (macro.import_function("IoFileMgrForUser", "0xE23EEC33", "sceIoWaitAsync"));
    asm (macro.import_function("IoFileMgrForUser", "0x35DBD746", "sceIoWaitAsyncCB"));
    asm (macro.import_function("IoFileMgrForUser", "0xCB05F8D6", "sceIoGetAsyncStat"));
    asm (macro.import_function("IoFileMgrForUser", "0xB293727F", "sceIoChangeAsyncPriority"));
    asm (macro.import_function("IoFileMgrForUser", "0xA12A0514", "sceIoSetAsyncCallback"));
    asm (macro.import_function("IoFileMgrForUser", "0x810C4BC3", "sceIoClose"));
    asm (macro.import_function("IoFileMgrForUser", "0xFF5940B6", "sceIoCloseAsync"));
    asm (macro.import_function("IoFileMgrForUser", "0x109F50BC", "sceIoOpen"));
    asm (macro.import_function("IoFileMgrForUser", "0x89AA9906", "sceIoOpenAsync"));
    asm (macro.import_function("IoFileMgrForUser", "0x6A638D83", "sceIoRead"));
    asm (macro.import_function("IoFileMgrForUser", "0xA0B5A7C2", "sceIoReadAsync"));
    asm (macro.import_function("IoFileMgrForUser", "0x42EC03AC", "sceIoWrite"));
    asm (macro.import_function("IoFileMgrForUser", "0x0FACAB19", "sceIoWriteAsync"));
    asm (macro.import_function("IoFileMgrForUser", "0x27EB27B8", "sceIoLseek"));
    asm (macro.import_function("IoFileMgrForUser", "0x71B19E77", "sceIoLseekAsync"));
    asm (macro.import_function("IoFileMgrForUser", "0x68963324", "sceIoLseek32"));
    asm (macro.import_function("IoFileMgrForUser", "0x1B385D8F", "sceIoLseek32Async"));
    asm (macro.import_function("IoFileMgrForUser", "0x63632449", "sceIoIoctl_stub"));
    asm (macro.generic_abi_wrapper("sceIoIoctl", 6));
    asm (macro.import_function("IoFileMgrForUser", "0xE95A012B", "sceIoIoctlAsync_stub"));
    asm (macro.generic_abi_wrapper("sceIoIoctlAsync", 6));
    asm (macro.import_function("IoFileMgrForUser", "0xB29DDF9C", "sceIoDopen"));
    asm (macro.import_function("IoFileMgrForUser", "0xE3EB004C", "sceIoDread"));
    asm (macro.import_function("IoFileMgrForUser", "0xEB092469", "sceIoDclose"));
    asm (macro.import_function("IoFileMgrForUser", "0xF27A9C51", "sceIoRemove"));
    asm (macro.import_function("IoFileMgrForUser", "0x06A70004", "sceIoMkdir"));
    asm (macro.import_function("IoFileMgrForUser", "0x1117C65F", "sceIoRmdir"));
    asm (macro.import_function("IoFileMgrForUser", "0x55F4717D", "sceIoChdir"));
    asm (macro.import_function("IoFileMgrForUser", "0xAB96437F", "sceIoSync"));
    asm (macro.import_function("IoFileMgrForUser", "0xACE946E8", "sceIoGetstat"));
    asm (macro.import_function("IoFileMgrForUser", "0xB8A740F4", "sceIoChstat"));
    asm (macro.import_function("IoFileMgrForUser", "0x779103A0", "sceIoRename"));
    asm (macro.import_function("IoFileMgrForUser", "0x54F5FB11", "sceIoDevctl_stub"));
    asm (macro.generic_abi_wrapper("sceIoDevctl", 6));
    asm (macro.import_function("IoFileMgrForUser", "0x08BD7374", "sceIoGetDevType"));
    asm (macro.import_function("IoFileMgrForUser", "0xB2A628C1", "sceIoAssign_stub"));
    asm (macro.generic_abi_wrapper("sceIoAssign", 6));
    asm (macro.import_function("IoFileMgrForUser", "0x6D08A871", "sceIoUnassign"));
    asm (macro.import_function("IoFileMgrForUser", "0xE8BC6571", "sceIoCancel"));
}
