// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Init the game sharing
/// `params` - game sharing parameters
/// Returns 0 on success, < 0 on error.
pub extern fn sceUtilityGameSharingInitStart(params: [*c]c_int) callconv(.C) c_int;

/// Shutdown game sharing.
pub extern fn sceUtilityGameSharingShutdownStart() callconv(.C) void;

/// Refresh the GUI for game sharing
/// `n` - unknown, pass 1
pub extern fn sceUtilityGameSharingUpdate(n: c_int) callconv(.C) void;

/// Get the current status of game sharing.
/// Returns 2 if the GUI is visible (you need to call sceUtilityGameSharingGetStatus).
/// 3 if the user cancelled the dialog, and you need to call sceUtilityGameSharingShutdownStart.
/// 4 if the dialog has been successfully shut down.
pub extern fn sceUtilityGameSharingGetStatus() callconv(.C) c_int;

pub extern fn sceNetplayDialogInitStart() callconv(.C) void;

pub extern fn sceNetplayDialogShutdownStart() callconv(.C) void;

pub extern fn sceNetplayDialogUpdate() callconv(.C) void;

pub extern fn sceNetplayDialogGetStatus() callconv(.C) void;

/// Init the Network Configuration Dialog Utility
/// `data` - pointer to pspUtilityNetconfData to be initialized
/// Returns 0 on success, < 0 on error
pub extern fn sceUtilityNetconfInitStart(data: [*c]c_int) callconv(.C) c_int;

/// Shutdown the Network Configuration Dialog Utility
/// Returns 0 on success, < 0 on error
pub extern fn sceUtilityNetconfShutdownStart() callconv(.C) c_int;

/// Update the Network Configuration Dialog GUI
/// `unknown` - unknown; set to 1
/// Returns 0 on success, < 0 on error
pub extern fn sceUtilityNetconfUpdate(unknown: c_int) callconv(.C) c_int;

/// Get the status of a running Network Configuration Dialog
/// Returns one of pspUtilityDialogState on success, < 0 on error
pub extern fn sceUtilityNetconfGetStatus() callconv(.C) c_int;

/// Saves or Load savedata to/from the passed structure
/// After having called this continue calling sceUtilitySavedataGetStatus to
/// check if the operation is completed
/// `params` - savedata parameters
/// Returns 0 on success
pub extern fn sceUtilitySavedataInitStart(params: [*c]c_int) callconv(.C) c_int;

/// Shutdown the savedata utility. after calling this continue calling
/// ::sceUtilitySavedataGetStatus to check when it has shutdown
/// Returns 0 on success
pub extern fn sceUtilitySavedataShutdownStart() callconv(.C) c_int;

/// Refresh status of the savedata function
/// `unknown` - unknown, pass 1
pub extern fn sceUtilitySavedataUpdate(unknown: c_int) callconv(.C) void;

/// Check the current status of the saving/loading/shutdown process
/// Continue calling this to check current status of the process
/// before calling this call also sceUtilitySavedataUpdate
/// Returns 2 if the process is still being processed.
/// 3 on save/load success, then you can call sceUtilitySavedataShutdownStart.
/// 4 on complete shutdown.
pub extern fn sceUtilitySavedataGetStatus() callconv(.C) c_int;

pub extern fn sceUtility_2995D020() callconv(.C) void;

pub extern fn sceUtility_B62A4061() callconv(.C) void;

pub extern fn sceUtility_ED0FAD38() callconv(.C) void;

pub extern fn sceUtility_88BC7406() callconv(.C) void;

/// Create a message dialog
/// `params` - dialog parameters
/// Returns 0 on success
pub extern fn sceUtilityMsgDialogInitStart(params: [*c]c_int) callconv(.C) c_int;

/// Remove a message dialog currently active.  After calling this
/// function you need to keep calling GetStatus and Update until
/// you get a status of 4.
pub extern fn sceUtilityMsgDialogShutdownStart() callconv(.C) void;

/// Refresh the GUI for a message dialog currently active
/// `n` - unknown, pass 1
pub extern fn sceUtilityMsgDialogUpdate(n: c_int) callconv(.C) void;

/// Get the current status of a message dialog currently active.
/// Returns 2 if the GUI is visible (you need to call sceUtilityMsgDialogGetStatus).
/// 3 if the user cancelled the dialog, and you need to call sceUtilityMsgDialogShutdownStart.
/// 4 if the dialog has been successfully shut down.
pub extern fn sceUtilityMsgDialogGetStatus() callconv(.C) c_int;

/// Create an on-screen keyboard
/// `params` - OSK parameters.
/// Returns < 0 on error.
pub extern fn sceUtilityOskInitStart(params: [*c]c_int) callconv(.C) c_int;

/// Remove a currently active keyboard. After calling this function you must
/// poll sceUtilityOskGetStatus() until it returns PSP_UTILITY_DIALOG_NONE.
/// Returns < 0 on error.
pub extern fn sceUtilityOskShutdownStart() callconv(.C) c_int;

/// Refresh the GUI for a keyboard currently active
/// `n` - Unknown, pass 1.
/// Returns < 0 on error.
pub extern fn sceUtilityOskUpdate(n: c_int) callconv(.C) c_int;

/// Get the status of a on-screen keyboard currently active.
/// Returns the current status of the keyboard. See ::pspUtilityDialogState for details.
pub extern fn sceUtilityOskGetStatus() callconv(.C) c_int;

/// Set Integer System Parameter
/// `id` - which parameter to set
/// `value` - integer value to set
/// Returns 0 on success, PSP_SYSTEMPARAM_RETVAL_FAIL on failure
pub extern fn sceUtilitySetSystemParamInt(id: c_int, value: c_int) callconv(.C) c_int;

/// Set String System Parameter
/// `id` - which parameter to set
/// `str` - char * value to set
/// Returns 0 on success, PSP_SYSTEMPARAM_RETVAL_FAIL on failure
pub extern fn sceUtilitySetSystemParamString(id: c_int, str: [*c]const c_char) callconv(.C) c_int;

/// Get Integer System Parameter
/// `id` - which parameter to get
/// `value` - pointer to integer value to place result in
/// Returns 0 on success, PSP_SYSTEMPARAM_RETVAL_FAIL on failure
pub extern fn sceUtilityGetSystemParamInt(id: c_int, value: [*c]c_int) callconv(.C) c_int;

/// Get String System Parameter
/// `id` - which parameter to get
/// `str` - char * buffer to place result in
/// `len` - length of str buffer
/// Returns 0 on success, PSP_SYSTEMPARAM_RETVAL_FAIL on failure
pub extern fn sceUtilityGetSystemParamString(id: c_int, str: [*c]c_char, len: c_int) callconv(.C) c_int;

/// Check existance of a Net Configuration
/// `id` - id of net Configuration (1 to n)
/// Returns 0 on success,
pub extern fn sceUtilityCheckNetParam(id: c_int) callconv(.C) c_int;

/// Get Net Configuration Parameter
/// `conf` - Net Configuration number (1 to n)
/// (0 returns valid but seems to be a copy of the last config requested)
/// `param` - which parameter to get
/// `data` - parameter data
/// Returns 0 on success,
pub extern fn sceUtilityGetNetParam(conf: c_int, param: c_int, data: [*c]c_int) callconv(.C) c_int;

/// Load a network module (PRX) from user mode.
/// Load PSP_NET_MODULE_COMMON and PSP_NET_MODULE_INET
/// to use infrastructure WifI (via an access point).
/// Available on firmware 2.00 and higher only.
/// `module` - module number to load (PSP_NET_MODULE_xxx)
/// Returns 0 on success, < 0 on error
pub extern fn sceUtilityLoadNetModule(module: c_int) callconv(.C) c_int;

/// Unload a network module (PRX) from user mode.
/// Available on firmware 2.00 and higher only.
/// `module` - module number be unloaded
/// Returns 0 on success, < 0 on error
pub extern fn sceUtilityUnloadNetModule(module: c_int) callconv(.C) c_int;

/// Load an audio/video module (PRX) from user mode.
/// Available on firmware 2.00 and higher only.
/// `module` - module number to load (PSP_AV_MODULE_xxx)
/// Returns 0 on success, < 0 on error
pub extern fn sceUtilityLoadAvModule(module: c_int) callconv(.C) c_int;

/// Unload an audio/video module (PRX) from user mode.
/// Available on firmware 2.00 and higher only.
/// `module` - module number to be unloaded
/// Returns 0 on success, < 0 on error
pub extern fn sceUtilityUnloadAvModule(module: c_int) callconv(.C) c_int;

/// Load a usb module (PRX) from user mode.
/// Available on firmware 2.70 and higher only.
/// `module` - module number to load (PSP_USB_MODULE_xxx)
/// Returns 0 on success, < 0 on error
pub extern fn sceUtilityLoadUsbModule(module: c_int) callconv(.C) c_int;

/// Unload a usb module (PRX) from user mode.
/// Available on firmware 2.70 and higher only.
/// `module` - module number to be unloaded
/// Returns 0 on success, < 0 on error
pub extern fn sceUtilityUnloadUsbModule(module: c_int) callconv(.C) c_int;

/// Abort a message dialog currently active
pub extern fn sceUtilityMsgDialogAbort() callconv(.C) c_int;

/// Refresh the GUI for html viewer
/// `n` - unknown, pass 1
pub extern fn sceUtilityHtmlViewerUpdate(n: c_int) callconv(.C) c_int;

/// Get the current status of the html viewer.
/// Returns 2 if the GUI is visible (you need to call sceUtilityHtmlViewerGetStatus).
/// 3 if the user cancelled the dialog, and you need to call sceUtilityHtmlViewerShutdownStart.
/// 4 if the dialog has been successfully shut down.
pub extern fn sceUtilityHtmlViewerGetStatus() callconv(.C) c_int;

/// Init the html viewer
/// `params` - html viewer parameters
/// Returns 0 on success, < 0 on error.
pub extern fn sceUtilityHtmlViewerInitStart(params: [*c]c_int) callconv(.C) c_int;

/// Shutdown html viewer.
pub extern fn sceUtilityHtmlViewerShutdownStart() callconv(.C) c_int;

/// Load a module (PRX) from user mode.
/// `module` - module to load (PSP_MODULE_xxx)
/// Returns 0 on success, < 0 on error
pub extern fn sceUtilityLoadModule(module: c_int) callconv(.C) c_int;

/// Unload a module (PRX) from user mode.
/// `module` - module to unload (PSP_MODULE_xxx)
/// Returns 0 on success, < 0 on error
pub extern fn sceUtilityUnloadModule(module: c_int) callconv(.C) c_int;

pub extern fn sceUtilityScreenshotInitStart() callconv(.C) void;

pub extern fn sceUtilityScreenshotShutdownStart() callconv(.C) void;

pub extern fn sceUtilityScreenshotUpdate() callconv(.C) void;

pub extern fn sceUtilityScreenshotGetStatus() callconv(.C) void;

pub extern fn sceUtilityScreenshotContStart() callconv(.C) void;

pub extern fn sceUtilityNpSigninInitStart() callconv(.C) void;

pub extern fn sceUtilityNpSigninShutdownStart() callconv(.C) void;

pub extern fn sceUtilityNpSigninUpdate() callconv(.C) void;

pub extern fn sceUtilityNpSigninGetStatus() callconv(.C) void;

comptime {
    asm(macro.import_module_start("sceUtility", "0x40010000", "56"));
    asm(macro.import_function("sceUtility", "0xC492F751", "sceUtilityGameSharingInitStart"));
    asm(macro.import_function("sceUtility", "0xEFC6F80F", "sceUtilityGameSharingShutdownStart"));
    asm(macro.import_function("sceUtility", "0x7853182D", "sceUtilityGameSharingUpdate"));
    asm(macro.import_function("sceUtility", "0x946963F3", "sceUtilityGameSharingGetStatus"));
    asm(macro.import_function("sceUtility", "0x3AD50AE7", "sceNetplayDialogInitStart"));
    asm(macro.import_function("sceUtility", "0xBC6B6296", "sceNetplayDialogShutdownStart"));
    asm(macro.import_function("sceUtility", "0x417BED54", "sceNetplayDialogUpdate"));
    asm(macro.import_function("sceUtility", "0xB6CEE597", "sceNetplayDialogGetStatus"));
    asm(macro.import_function("sceUtility", "0x4DB1E739", "sceUtilityNetconfInitStart"));
    asm(macro.import_function("sceUtility", "0xF88155F6", "sceUtilityNetconfShutdownStart"));
    asm(macro.import_function("sceUtility", "0x91E70E35", "sceUtilityNetconfUpdate"));
    asm(macro.import_function("sceUtility", "0x6332AA39", "sceUtilityNetconfGetStatus"));
    asm(macro.import_function("sceUtility", "0x50C4CD57", "sceUtilitySavedataInitStart"));
    asm(macro.import_function("sceUtility", "0x9790B33C", "sceUtilitySavedataShutdownStart"));
    asm(macro.import_function("sceUtility", "0xD4B95FFB", "sceUtilitySavedataUpdate"));
    asm(macro.import_function("sceUtility", "0x8874DBE0", "sceUtilitySavedataGetStatus"));
    asm(macro.import_function("sceUtility", "0x2995D020", "sceUtility_2995D020"));
    asm(macro.import_function("sceUtility", "0xB62A4061", "sceUtility_B62A4061"));
    asm(macro.import_function("sceUtility", "0xED0FAD38", "sceUtility_ED0FAD38"));
    asm(macro.import_function("sceUtility", "0x88BC7406", "sceUtility_88BC7406"));
    asm(macro.import_function("sceUtility", "0x2AD8E239", "sceUtilityMsgDialogInitStart"));
    asm(macro.import_function("sceUtility", "0x67AF3428", "sceUtilityMsgDialogShutdownStart"));
    asm(macro.import_function("sceUtility", "0x95FC253B", "sceUtilityMsgDialogUpdate"));
    asm(macro.import_function("sceUtility", "0x9A1C91D7", "sceUtilityMsgDialogGetStatus"));
    asm(macro.import_function("sceUtility", "0xF6269B82", "sceUtilityOskInitStart"));
    asm(macro.import_function("sceUtility", "0x3DFAEBA9", "sceUtilityOskShutdownStart"));
    asm(macro.import_function("sceUtility", "0x4B85C861", "sceUtilityOskUpdate"));
    asm(macro.import_function("sceUtility", "0xF3F76017", "sceUtilityOskGetStatus"));
    asm(macro.import_function("sceUtility", "0x45C18506", "sceUtilitySetSystemParamInt"));
    asm(macro.import_function("sceUtility", "0x41E30674", "sceUtilitySetSystemParamString"));
    asm(macro.import_function("sceUtility", "0xA5DA2406", "sceUtilityGetSystemParamInt"));
    asm(macro.import_function("sceUtility", "0x34B78343", "sceUtilityGetSystemParamString"));
    asm(macro.import_function("sceUtility", "0x5EEE6548", "sceUtilityCheckNetParam"));
    asm(macro.import_function("sceUtility", "0x434D4B3A", "sceUtilityGetNetParam"));
    asm(macro.import_function("sceUtility", "0x1579a159", "sceUtilityLoadNetModule"));
    asm(macro.import_function("sceUtility", "0x64d50c56", "sceUtilityUnloadNetModule"));
    asm(macro.import_function("sceUtility", "0xC629AF26", "sceUtilityLoadAvModule"));
    asm(macro.import_function("sceUtility", "0xF7D8D092", "sceUtilityUnloadAvModule"));
    asm(macro.import_function("sceUtility", "0x0D5BC6D2", "sceUtilityLoadUsbModule"));
    asm(macro.import_function("sceUtility", "0xF64910F0", "sceUtilityUnloadUsbModule"));
    asm(macro.import_function("sceUtility", "0x4928BD96", "sceUtilityMsgDialogAbort"));
    asm(macro.import_function("sceUtility", "0x05AFB9E4", "sceUtilityHtmlViewerUpdate"));
    asm(macro.import_function("sceUtility", "0xBDA7D894", "sceUtilityHtmlViewerGetStatus"));
    asm(macro.import_function("sceUtility", "0xCDC3AA41", "sceUtilityHtmlViewerInitStart"));
    asm(macro.import_function("sceUtility", "0xF5CE1134", "sceUtilityHtmlViewerShutdownStart"));
    asm(macro.import_function("sceUtility", "0x2A2B3DE0", "sceUtilityLoadModule"));
    asm(macro.import_function("sceUtility", "0xE49BFE92", "sceUtilityUnloadModule"));
    asm(macro.import_function("sceUtility", "0x0251B134", "sceUtilityScreenshotInitStart"));
    asm(macro.import_function("sceUtility", "0xF9E0008C", "sceUtilityScreenshotShutdownStart"));
    asm(macro.import_function("sceUtility", "0xAB083EA9", "sceUtilityScreenshotUpdate"));
    asm(macro.import_function("sceUtility", "0xD81957B7", "sceUtilityScreenshotGetStatus"));
    asm(macro.import_function("sceUtility", "0x86A03A27", "sceUtilityScreenshotContStart"));
    asm(macro.import_function("sceUtility", "0x16D02AF0", "sceUtilityNpSigninInitStart"));
    asm(macro.import_function("sceUtility", "0xE19C97D6", "sceUtilityNpSigninShutdownStart"));
    asm(macro.import_function("sceUtility", "0xF3FBC572", "sceUtilityNpSigninUpdate"));
    asm(macro.import_function("sceUtility", "0x86ABDB1B", "sceUtilityNpSigninGetStatus"));
}
