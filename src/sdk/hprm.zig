// Headphone remote -- HPRM button input
//
// Wraps:
//   c/module/sceHprm.zig

const int = @import("errors/hprm.zig");
const check = int.check;
const module = @import("../c/modules.zig").sceHprm;

/// Bitmask of headphone remote keys.
pub const Key = enum(u32) {
    playpause = 1,
    forward = 4,
    back = 8,
    vol_up = 16,
    vol_down = 32,
    hold = 128,
};

/// Latch data from the headphone remote.
/// Each field represents a different latch state for the key bitmaps.
pub const LatchData = struct {
    /// Keys newly pressed since last read.
    pressed: u32,
    /// Keys newly released since last read.
    released: u32,
    /// Keys currently held.
    held: u32,
    /// Reserved / unknown.
    reserved: u32,
};

pub const Error = int.Error;

pub fn register_callback() void {
    module.sceHprmRegisterCallback();
}

pub fn unregister_callback() void {
    module.sceHprmUnregisterCallback();
}

/// Determines whether the remote is plugged in.
pub fn is_remote_exist() bool {
    return module.sceHprmIsRemoteExist() != 0;
}

/// Determines whether the headphones are plugged in.
pub fn is_headphone_exist() bool {
    return module.sceHprmIsHeadphoneExist() != 0;
}

/// Determines whether the microphone is plugged in.
pub fn is_microphone_exist() bool {
    return module.sceHprmIsMicrophoneExist() != 0;
}

/// Peek at the current key being pressed on the remote.
/// Returns the key bitmap (bitwise OR of `Key` values).
pub fn peek_current_key() Error!u32 {
    var key: u32 = undefined;
    try check(module.sceHprmPeekCurrentKey(&key));
    return key;
}

/// Peek at the current latch data without consuming it.
pub fn peek_latch() Error!LatchData {
    var buf: [4]u32 = undefined;
    try check(module.sceHprmPeekLatch(&buf));
    return .{
        .pressed = buf[0],
        .released = buf[1],
        .held = buf[2],
        .reserved = buf[3],
    };
}

/// Read the current latch data, consuming it.
pub fn read_latch() Error!LatchData {
    var buf: [4]u32 = undefined;
    try check(module.sceHprmReadLatch(&buf));
    return .{
        .pressed = buf[0],
        .released = buf[1],
        .held = buf[2],
        .reserved = buf[3],
    };
}
