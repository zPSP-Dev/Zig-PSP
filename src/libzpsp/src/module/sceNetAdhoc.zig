// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Initialise the adhoc library.
/// Returns 0 on success, < 0 on error
pub extern fn sceNetAdhocInit() callconv(.c) c_int;

/// Terminate the adhoc library
/// Returns 0 on success, < 0 on error
pub extern fn sceNetAdhocTerm() callconv(.c) c_int;

pub extern fn sceNetAdhocPollSocket() callconv(.c) void;

pub extern fn sceNetAdhocSetSocketAlert() callconv(.c) void;

pub extern fn sceNetAdhocGetSocketAlert() callconv(.c) void;

/// Create a PDP object.
/// `mac` - Your MAC address (from sceWlanGetEtherAddr)
/// `port` - Port to use, lumines uses 0x309
/// `bufsize` - Socket buffer size, lumines sets to 0x400
/// `unk1` - Unknown, lumines sets to 0
/// Returns The ID of the PDP object (< 0 on error)
pub extern fn sceNetAdhocPdpCreate(mac: [*c]u8, port: c_ushort, bufsize: c_uint, unk1: c_int) callconv(.c) c_int;

/// Set a PDP packet to a destination
/// `id` - The ID as returned by ::sceNetAdhocPdpCreate
/// `destMacAddr` - The destination MAC address, can be set to all 0xFF for broadcast
/// `port` - The port to send to
/// `data` - The data to send
/// `len` - The length of the data.
/// `timeout` - Timeout in microseconds.
/// `nonblock` - Set to 0 to block, 1 for non-blocking.
/// Returns Bytes sent, < 0 on error
pub extern fn sceNetAdhocPdpSend(id: c_int, destMacAddr: [*c]u8, port: c_ushort, data: ?*anyopaque, len: c_uint, timeout: c_uint, nonblock: c_int) callconv(.c) c_int;

/// Receive a PDP packet
/// `id` - The ID of the PDP object, as returned by ::sceNetAdhocPdpCreate
/// `srcMacAddr` - Buffer to hold the source mac address of the sender
/// `port` - Buffer to hold the port number of he received data
/// `data` - Data buffer
/// `dataLength` - The length of the data buffer
/// `timeout` - Timeout in microseconds.
/// `nonblock` - Set to 0 to block, 1 for non-blocking.
/// Returns Number of bytes received, < 0 on error.
pub extern fn sceNetAdhocPdpRecv(id: c_int, srcMacAddr: [*c]u8, port: [*c]c_ushort, data: ?*anyopaque, dataLength: ?*anyopaque, timeout: c_uint, nonblock: c_int) callconv(.c) c_int;

/// Delete a PDP object.
/// `id` - The ID returned from ::sceNetAdhocPdpCreate
/// `unk1` - Unknown, set to 0
/// Returns 0 on success, < 0 on error
pub extern fn sceNetAdhocPdpDelete(id: c_int, unk1: c_int) callconv(.c) c_int;

/// Get the status of all PDP objects
/// `size` - Pointer to the size of the stat array (e.g 20 for one structure)
/// `stat` - Pointer to a list of ::pdpStatStruct structures.
/// Returns 0 on success, < 0 on error
pub extern fn sceNetAdhocGetPdpStat(size: [*c]c_int, stat: [*c]c_int) callconv(.c) c_int;

/// Open a PTP connection
/// `srcmac` - Local mac address.
/// `srcport` - Local port.
/// `destmac` - Destination mac.
/// `destport` - Destination port
/// `bufsize` - Socket buffer size
/// `delay` - Interval between retrying (microseconds).
/// `count` - Number of retries.
/// `unk1` - Pass 0.
/// Returns A socket ID on success, < 0 on error.
pub extern fn sceNetAdhocPtpOpen(srcmac: [*c]u8, srcport: c_ushort, destmac: [*c]u8, destport: c_ushort, bufsize: c_uint, delay: c_uint, count: c_int, unk1: c_int) callconv(.c) c_int;

/// Wait for connection created by sceNetAdhocPtpOpen()
/// `id` - A socket ID.
/// `timeout` - Timeout in microseconds.
/// `nonblock` - Set to 0 to block, 1 for non-blocking.
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocPtpConnect(id: c_int, timeout: c_uint, nonblock: c_int) callconv(.c) c_int;

/// Wait for an incoming PTP connection
/// `srcmac` - Local mac address.
/// `srcport` - Local port.
/// `bufsize` - Socket buffer size
/// `delay` - Interval between retrying (microseconds).
/// `count` - Number of retries.
/// `queue` - Connection queue length.
/// `unk1` - Pass 0.
/// Returns A socket ID on success, < 0 on error.
pub extern fn sceNetAdhocPtpListen(srcmac: [*c]u8, srcport: c_ushort, bufsize: c_uint, delay: c_uint, count: c_int, queue: c_int, unk1: c_int) callconv(.c) c_int;

/// Accept an incoming PTP connection
/// `id` - A socket ID.
/// `mac` - Connecting peers mac.
/// `port` - Connecting peers port.
/// `timeout` - Timeout in microseconds.
/// `nonblock` - Set to 0 to block, 1 for non-blocking.
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocPtpAccept(id: c_int, mac: [*c]u8, port: [*c]c_ushort, timeout: c_uint, nonblock: c_int) callconv(.c) c_int;

/// Send data
/// `id` - A socket ID.
/// `data` - Data to send.
/// `datasize` - Size of the data.
/// `timeout` - Timeout in microseconds.
/// `nonblock` - Set to 0 to block, 1 for non-blocking.
/// Returns 0 success, < 0 on error.
pub extern fn sceNetAdhocPtpSend(id: c_int, data: ?*anyopaque, datasize: [*c]c_int, timeout: c_uint, nonblock: c_int) callconv(.c) c_int;

/// Receive data
/// `id` - A socket ID.
/// `data` - Buffer for the received data.
/// `datasize` - Size of the data received.
/// `timeout` - Timeout in microseconds.
/// `nonblock` - Set to 0 to block, 1 for non-blocking.
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocPtpRecv(id: c_int, data: ?*anyopaque, datasize: [*c]c_int, timeout: c_uint, nonblock: c_int) callconv(.c) c_int;

/// Wait for data in the buffer to be sent
/// `id` - A socket ID.
/// `timeout` - Timeout in microseconds.
/// `nonblock` - Set to 0 to block, 1 for non-blocking.
/// Returns A socket ID on success, < 0 on error.
pub extern fn sceNetAdhocPtpFlush(id: c_int, timeout: c_uint, nonblock: c_int) callconv(.c) c_int;

/// Close a socket
/// `id` - A socket ID.
/// `unk1` - Pass 0.
/// Returns A socket ID on success, < 0 on error.
pub extern fn sceNetAdhocPtpClose(id: c_int, unk1: c_int) callconv(.c) c_int;

/// Get the status of all PTP objects
/// `size` - Pointer to the size of the stat array (e.g 20 for one structure)
/// `stat` - Pointer to a list of ::ptpStatStruct structures.
/// Returns 0 on success, < 0 on error
pub extern fn sceNetAdhocGetPtpStat(size: [*c]c_int, stat: [*c]c_int) callconv(.c) c_int;

/// Create own game object type data.
/// `data` - A pointer to the game object data.
/// `size` - Size of the game data.
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocGameModeCreateMaster(data: ?*anyopaque, size: c_int) callconv(.c) c_int;

/// Create peer game object type data.
/// `mac` - The mac address of the peer.
/// `data` - A pointer to the game object data.
/// `size` - Size of the game data.
/// Returns The id of the replica on success, < 0 on error.
pub extern fn sceNetAdhocGameModeCreateReplica(mac: [*c]u8, data: ?*anyopaque, size: c_int) callconv(.c) c_int;

/// Update own game object type data.
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocGameModeUpdateMaster() callconv(.c) c_int;

/// Update peer game object type data.
/// `id` - The id of the replica returned by sceNetAdhocGameModeCreateReplica.
/// `unk1` - Pass 0.
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocGameModeUpdateReplica(id: c_int, unk1: c_int) callconv(.c) c_int;

/// Delete own game object type data.
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocGameModeDeleteMaster() callconv(.c) c_int;

/// Delete peer game object type data.
/// `id` - The id of the replica.
/// Returns 0 on success, < 0 on error.
pub extern fn sceNetAdhocGameModeDeleteReplica(id: c_int) callconv(.c) c_int;

comptime {
    asm (macro.import_module_start("sceNetAdhoc", "0x00090000", "25"));
    asm (macro.import_function("sceNetAdhoc", "0xE1D621D7", "sceNetAdhocInit"));
    asm (macro.import_function("sceNetAdhoc", "0xA62C6F57", "sceNetAdhocTerm"));
    asm (macro.import_function("sceNetAdhoc", "0x7A662D6B", "sceNetAdhocPollSocket"));
    asm (macro.import_function("sceNetAdhoc", "0x73BFD52D", "sceNetAdhocSetSocketAlert"));
    asm (macro.import_function("sceNetAdhoc", "0x4D2CE199", "sceNetAdhocGetSocketAlert"));
    asm (macro.import_function("sceNetAdhoc", "0x6F92741B", "sceNetAdhocPdpCreate"));
    asm (macro.import_function("sceNetAdhoc", "0xABED3790", "sceNetAdhocPdpSend_stub"));
    asm (macro.generic_abi_wrapper("sceNetAdhocPdpSend", 7));
    asm (macro.import_function("sceNetAdhoc", "0xDFE53E03", "sceNetAdhocPdpRecv_stub"));
    asm (macro.generic_abi_wrapper("sceNetAdhocPdpRecv", 7));
    asm (macro.import_function("sceNetAdhoc", "0x7F27BB5E", "sceNetAdhocPdpDelete"));
    asm (macro.import_function("sceNetAdhoc", "0xC7C1FC57", "sceNetAdhocGetPdpStat"));
    asm (macro.import_function("sceNetAdhoc", "0x877F6D66", "sceNetAdhocPtpOpen_stub"));
    asm (macro.generic_abi_wrapper("sceNetAdhocPtpOpen", 8));
    asm (macro.import_function("sceNetAdhoc", "0xFC6FC07B", "sceNetAdhocPtpConnect"));
    asm (macro.import_function("sceNetAdhoc", "0xE08BDAC1", "sceNetAdhocPtpListen_stub"));
    asm (macro.generic_abi_wrapper("sceNetAdhocPtpListen", 7));
    asm (macro.import_function("sceNetAdhoc", "0x9DF81198", "sceNetAdhocPtpAccept_stub"));
    asm (macro.generic_abi_wrapper("sceNetAdhocPtpAccept", 5));
    asm (macro.import_function("sceNetAdhoc", "0x4DA4C788", "sceNetAdhocPtpSend_stub"));
    asm (macro.generic_abi_wrapper("sceNetAdhocPtpSend", 5));
    asm (macro.import_function("sceNetAdhoc", "0x8BEA2B3E", "sceNetAdhocPtpRecv_stub"));
    asm (macro.generic_abi_wrapper("sceNetAdhocPtpRecv", 5));
    asm (macro.import_function("sceNetAdhoc", "0x9AC2EEAC", "sceNetAdhocPtpFlush"));
    asm (macro.import_function("sceNetAdhoc", "0x157E6225", "sceNetAdhocPtpClose"));
    asm (macro.import_function("sceNetAdhoc", "0xB9685118", "sceNetAdhocGetPtpStat"));
    asm (macro.import_function("sceNetAdhoc", "0x7F75C338", "sceNetAdhocGameModeCreateMaster"));
    asm (macro.import_function("sceNetAdhoc", "0x3278AB0C", "sceNetAdhocGameModeCreateReplica"));
    asm (macro.import_function("sceNetAdhoc", "0x98C204C8", "sceNetAdhocGameModeUpdateMaster"));
    asm (macro.import_function("sceNetAdhoc", "0xFA324B4E", "sceNetAdhocGameModeUpdateReplica"));
    asm (macro.import_function("sceNetAdhoc", "0xA0229362", "sceNetAdhocGameModeDeleteMaster"));
    asm (macro.import_function("sceNetAdhoc", "0x0B2228E9", "sceNetAdhocGameModeDeleteReplica"));
}
