pub const PspHprmKeys = extern enum(u8) {
    Playpause = 1,
    Forward = 4,
    Back = 8,
    VolUp = 16,
    VolDown = 32,
    Hold = 128,
};

// Peek at the current being pressed on the remote.
//
// @param key - Pointer to the u32 to receive the key bitmap, should be one or
// more of ::PspHprmKeys
//
// @return < 0 on error
pub extern fn sceHprmPeekCurrentKey(key: [*]u32) c_int;
pub fn hprmPeekCurrentKey(latch: [*]u32) !i32 {
    var res = sceHprmPeekCurrentKey(latch);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Peek at the current latch data.
//
// @param latch - Pointer a to a 4 dword array to contain the latch data.
//
// @return < 0 on error.
pub extern fn sceHprmPeekLatch(latch: [*]u32) c_int;
pub fn hprmPeekLatch(latch: [*]u32) !i32 {
    var res = sceHprmPeekLatch(latch);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Read the current latch data.
//
// @param latch - Pointer a to a 4 dword array to contain the latch data.
//
// @return < 0 on error.
pub extern fn sceHprmReadLatch(latch: [*]u32) c_int;
pub fn hprmReadLatch(latch: [*]u32) !i32 {
    var res = sceHprmReadLatch(latch);
    if (res < 0) {
        return error.Unexpected;
    }
    return res;
}

// Determines whether the headphones are plugged in.
//
// @return 1 if the headphones are plugged in, else 0.
pub extern fn sceHprmIsHeadphoneExist() c_int;
pub fn hprmIsHeadphoneExist() bool {
    return sceHprmIsHeadphoneExist() == 1;
}

// Determines whether the remote is plugged in.
//
// @return 1 if the remote is plugged in, else 0.
pub extern fn sceHprmIsRemoteExist() c_int;
pub fn hprmIsRemoteExist() bool {
    return sceHprmIsRemoteExist() == 1;
}

// Determines whether the microphone is plugged in.
//
// @return 1 if the microphone is plugged in, else 0.
pub extern fn sceHprmIsMicrophoneExist() c_int;
pub fn hprmIsMicrophoneExist() bool {
    return sceHprmIsMicrophoneExist() == 1;
}
