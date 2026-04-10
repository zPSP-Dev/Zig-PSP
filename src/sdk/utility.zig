// System utility dialogs, module loading, and system parameters
//
// Wraps:
//   c/module/sceUtility.zig
//   c/module/sceUtility_netparam_internal.zig

const c = @import("../c/modules.zig");
const internal = @import("internal.zig");
const check = internal.check;
const ci = internal.ci;
const Error = internal.Error;

const util = c.sceUtility;
const netparam = c.sceUtility_netparam_internal;

// -- Re-exported types --------------------------------------------------

pub const DialogCommon = c.types.pspUtilityDialogCommon;
pub const SavedataParam = c.types.SceUtilitySavedataParam;
pub const OskParams = c.types.SceUtilityOskParams;
pub const GameSharingParams = c.types.pspUtilityGameSharingParams;
pub const NetconfData = c.types.pspUtilityNetconfData;
pub const MsgDialogParams = c.types.pspUtilityMsgDialogParams;
pub const HtmlViewerParam = c.types.pspUtilityHtmlViewerParam;
pub const NetData = c.types.netData;

// -- Enums --------------------------------------------------------------

pub const DialogState = enum(c_int) {
    none = 0,
    init = 1,
    visible = 2,
    quit = 3,
    finished = 4,
    _,
};

pub const NetModule = enum(c_int) {
    common = 1,
    adhoc = 2,
    inet = 3,
    parseuri = 4,
    parsehttp = 5,
    http = 6,
    ssl = 7,
};

pub const AvModule = enum(c_int) {
    avcodec = 0,
    sascore = 1,
    atrac3plus = 2,
    mpegbase = 3,
    mp3 = 4,
    vaudio = 5,
    aac = 6,
    g729 = 7,
};

pub const UsbModule = enum(c_int) {
    pspcm = 1,
    acc = 2,
    mic = 3,
    cam = 4,
    gps = 5,
};

pub const SystemParamId = enum(c_int) {
    string_nickname = 1,
    int_adhoc_channel = 2,
    int_wlan_powersave = 3,
    int_date_format = 4,
    int_time_format = 5,
    int_timezone = 6,
    int_daylightsavings = 7,
    int_language = 8,
    int_unknown = 9,
};

// -- Game sharing -------------------------------------------------------

pub fn game_sharing_init_start(params: *GameSharingParams) Error!void {
    return check(util.sceUtilityGameSharingInitStart(params));
}

pub fn game_sharing_shutdown_start() void {
    util.sceUtilityGameSharingShutdownStart();
}

pub fn game_sharing_update(n: u32) void {
    util.sceUtilityGameSharingUpdate(ci(n));
}

pub fn game_sharing_get_status() DialogState {
    return @enumFromInt(util.sceUtilityGameSharingGetStatus());
}

// -- Network configuration dialog ---------------------------------------

pub fn netconf_init_start(data: *NetconfData) Error!void {
    return check(util.sceUtilityNetconfInitStart(data));
}

pub fn netconf_shutdown_start() Error!void {
    return check(util.sceUtilityNetconfShutdownStart());
}

pub fn netconf_update(n: u32) Error!void {
    return check(util.sceUtilityNetconfUpdate(ci(n)));
}

pub fn netconf_get_status() DialogState {
    return @enumFromInt(util.sceUtilityNetconfGetStatus());
}

// -- Savedata -----------------------------------------------------------

pub fn savedata_init_start(params: *SavedataParam) Error!void {
    return check(util.sceUtilitySavedataInitStart(params));
}

pub fn savedata_shutdown_start() Error!void {
    return check(util.sceUtilitySavedataShutdownStart());
}

pub fn savedata_update(n: u32) void {
    util.sceUtilitySavedataUpdate(ci(n));
}

pub fn savedata_get_status() DialogState {
    return @enumFromInt(util.sceUtilitySavedataGetStatus());
}

// -- Message dialog -----------------------------------------------------

pub fn msg_dialog_init_start(params: *MsgDialogParams) Error!void {
    return check(util.sceUtilityMsgDialogInitStart(params));
}

pub fn msg_dialog_shutdown_start() void {
    util.sceUtilityMsgDialogShutdownStart();
}

pub fn msg_dialog_update(n: u32) void {
    util.sceUtilityMsgDialogUpdate(ci(n));
}

pub fn msg_dialog_get_status() DialogState {
    return @enumFromInt(util.sceUtilityMsgDialogGetStatus());
}

pub fn msg_dialog_abort() Error!void {
    return check(util.sceUtilityMsgDialogAbort());
}

// -- On-screen keyboard ------------------------------------------------

pub fn osk_init_start(params: *OskParams) Error!void {
    return check(util.sceUtilityOskInitStart(params));
}

pub fn osk_shutdown_start() Error!void {
    return check(util.sceUtilityOskShutdownStart());
}

pub fn osk_update(n: u32) Error!void {
    return check(util.sceUtilityOskUpdate(ci(n)));
}

pub fn osk_get_status() DialogState {
    return @enumFromInt(util.sceUtilityOskGetStatus());
}

// -- HTML viewer --------------------------------------------------------

pub fn html_viewer_init_start(params: *HtmlViewerParam) Error!void {
    return check(util.sceUtilityHtmlViewerInitStart(params));
}

pub fn html_viewer_shutdown_start() Error!void {
    return check(util.sceUtilityHtmlViewerShutdownStart());
}

pub fn html_viewer_update(n: u32) Error!void {
    return check(util.sceUtilityHtmlViewerUpdate(ci(n)));
}

pub fn html_viewer_get_status() DialogState {
    return @enumFromInt(util.sceUtilityHtmlViewerGetStatus());
}

// -- System parameters --------------------------------------------------

pub fn set_system_param_int(id: SystemParamId, value: i32) Error!void {
    return check(util.sceUtilitySetSystemParamInt(@intFromEnum(id), @as(c_int, value)));
}

pub fn set_system_param_string(id: SystemParamId, str: [*:0]const u8) Error!void {
    return check(util.sceUtilitySetSystemParamString(@intFromEnum(id), str));
}

pub fn get_system_param_int(id: SystemParamId) Error!i32 {
    var value: c_int = undefined;
    check(util.sceUtilityGetSystemParamInt(@intFromEnum(id), &value)) catch return error.Unexpected;
    return @intCast(value);
}

pub fn get_system_param_string(id: SystemParamId, buf: []u8) Error!void {
    return check(util.sceUtilityGetSystemParamString(@intFromEnum(id), buf.ptr, @intCast(buf.len)));
}

// -- Net parameters -----------------------------------------------------

pub fn check_net_param(id: u32) Error!void {
    return check(util.sceUtilityCheckNetParam(ci(id)));
}

pub fn get_net_param(conf: u32, param: u32, data: *NetData) Error!void {
    return check(util.sceUtilityGetNetParam(ci(conf), ci(param), data));
}

pub fn create_net_param(conf: u32) Error!void {
    return check(netparam.sceUtilityCreateNetParam(ci(conf)));
}

pub fn delete_net_param(conf: u32) Error!void {
    return check(netparam.sceUtilityDeleteNetParam(ci(conf)));
}

pub fn copy_net_param(src: u32, dest: u32) Error!void {
    return check(netparam.sceUtilityCopyNetParam(ci(src), ci(dest)));
}

pub fn set_net_param(param: u32, val: ?*const anyopaque) Error!void {
    return check(netparam.sceUtilitySetNetParam(ci(param), val));
}

// -- Module loading -----------------------------------------------------

pub fn load_net_module(module: NetModule) Error!void {
    return check(util.sceUtilityLoadNetModule(@intFromEnum(module)));
}

pub fn unload_net_module(module: NetModule) Error!void {
    return check(util.sceUtilityUnloadNetModule(@intFromEnum(module)));
}

pub fn load_av_module(module: AvModule) Error!void {
    return check(util.sceUtilityLoadAvModule(@intFromEnum(module)));
}

pub fn unload_av_module(module: AvModule) Error!void {
    return check(util.sceUtilityUnloadAvModule(@intFromEnum(module)));
}

pub fn load_usb_module(module: UsbModule) Error!void {
    return check(util.sceUtilityLoadUsbModule(@intFromEnum(module)));
}

pub fn unload_usb_module(module: UsbModule) Error!void {
    return check(util.sceUtilityUnloadUsbModule(@intFromEnum(module)));
}

pub fn load_module(module: c_int) Error!void {
    return check(util.sceUtilityLoadModule(module));
}

pub fn unload_module(module: c_int) Error!void {
    return check(util.sceUtilityUnloadModule(module));
}
