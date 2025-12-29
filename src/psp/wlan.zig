const c = @import("libzpsp").sceWlanDrv;

// Determine if the wlan device is currently powered on
//
// @return 0 if off, 1 if on
pub fn wlanDevIsPowerOn() bool {
    return c.sceWlanDevIsPowerOn() == 1;
}

// Determine the state of the Wlan power switch
//
// @return 0 if off, 1 if on
pub fn wlanGetSwitchState() bool {
    return c.sceWlanGetSwitchState() == 1;
}

// Get the Ethernet Address of the wlan controller
//
// @param etherAddr - pointer to a buffer of u8 (NOTE: it only writes to 6 bytes, but
// requests 8 so pass it 8 bytes just in case)
// @return 0 on success, < 0 on error
pub fn wlanGetEtherAddr(etherAddr: []u8) !void {
    const res = c.sceWlanGetEtherAddr(etherAddr);
    if (res < 0) {
        return error.WLANEthernetFailed;
    }
}
