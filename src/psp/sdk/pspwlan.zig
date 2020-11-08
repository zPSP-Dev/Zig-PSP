// Determine if the wlan device is currently powered on
//
// @return 0 if off, 1 if on
pub extern fn sceWlanDevIsPowerOn() c_int;

pub fn wlanDevIsPowerOn() bool {
    return sceWlanDevIsPowerOn() == 1;
}

// Determine the state of the Wlan power switch
//
// @return 0 if off, 1 if on
pub extern fn sceWlanGetSwitchState() c_int;

pub fn wlanGetSwitchState() bool {
    return sceWlanGetSwitchState() == 1;
}

// Get the Ethernet Address of the wlan controller
//
// @param etherAddr - pointer to a buffer of u8 (NOTE: it only writes to 6 bytes, but
// requests 8 so pass it 8 bytes just in case)
// @return 0 on success, < 0 on error
pub extern fn sceWlanGetEtherAddr(etherAddr: [*c]u8) c_int;

pub fn wlanGetEtherAddr(etherAddr: []u8) !void {
    var res = sceWlanGetEtherAddr(etherAddr);
    if (res < 0) {
        return error.Unexpected;
    }
}
