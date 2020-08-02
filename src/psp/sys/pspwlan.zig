pub extern fn sceWlanDevIsPowerOn() c_int;
pub extern fn sceWlanGetSwitchState() c_int;
pub extern fn sceWlanGetEtherAddr(etherAddr: [*c]u8) c_int;
pub extern fn sceWlanDevAttach() c_int;
pub extern fn sceWlanDevDetach() c_int;
