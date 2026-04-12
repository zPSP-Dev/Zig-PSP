// WLAN driver -- WiFi hardware control
//
// Wraps:
//   c/module/sceWlanDrv.zig
//   c/module/sceWlanDrv_lib.zig

const c = @import("../c/modules.zig");
const err = @import("errors/wlan.zig");
const check = err.check;
const Error = err.Error;

const drv = c.sceWlanDrv;
const lib = c.sceWlanDrv_lib;

// -- sceWlanDrv --------------------------------------------------------

pub fn is_power_on() bool {
    return drv.sceWlanDevIsPowerOn() != 0;
}

pub fn get_switch_state() bool {
    return drv.sceWlanGetSwitchState() != 0;
}

pub fn get_ether_addr(addr: *[8]u8) Error!void {
    return check(drv.sceWlanGetEtherAddr(addr));
}

// -- sceWlanDrv_lib ----------------------------------------------------

pub fn dev_attach() Error!void {
    return check(lib.sceWlanDevAttach());
}

pub fn dev_detach() Error!void {
    return check(lib.sceWlanDevDetach());
}

// Undocumented stubs
pub const dev_is_game_mode = lib.sceWlanDevIsGameMode;
pub const gp_prev_establish_active = lib.sceWlanGPPrevEstablishActive;
pub const gp_send = lib.sceWlanGPSend;
pub const gp_recv = lib.sceWlanGPRecv;
pub const gp_register_callback = lib.sceWlanGPRegisterCallback;
pub const gp_unregister_callback = lib.sceWlanGPUnRegisterCallback;
pub const dev_set_gpio = lib.sceWlanDevSetGPIO;
pub const dev_get_state_gpio = lib.sceWlanDevGetStateGPIO;
