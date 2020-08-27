pub const enum_PspHprmKeys = extern enum(c_int) {
    PSP_HPRM_PLAYPAUSE = 1,
    PSP_HPRM_FORWARD = 4,
    PSP_HPRM_BACK = 8,
    PSP_HPRM_VOL_UP = 16,
    PSP_HPRM_VOL_DOWN = 32,
    PSP_HPRM_HOLD = 128,
    _,
};
pub extern fn sceHprmPeekCurrentKey(key: [*c]u32) c_int;
pub extern fn sceHprmPeekLatch(latch: [*c]u32) c_int;
pub extern fn sceHprmReadLatch(latch: [*c]u32) c_int;
pub extern fn sceHprmIsHeadphoneExist() c_int;
pub extern fn sceHprmIsRemoteExist() c_int;
pub extern fn sceHprmIsMicrophoneExist() c_int;

pub const PspHprmKeys = enum_PspHprmKeys;
