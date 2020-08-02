const struct_unnamed_1 = extern struct {
    size: c_uint,
    language: c_int,
    buttonSwap: c_int,
    graphicsThread: c_int,
    accessThread: c_int,
    fontThread: c_int,
    soundThread: c_int,
    result: c_int,
    reserved: [4]c_int,
};
pub const pspUtilityDialogCommon = struct_unnamed_1;
const enum_unnamed_2 = extern enum(c_int) {
    PSP_UTILITY_MSGDIALOG_MODE_ERROR = 0,
    PSP_UTILITY_MSGDIALOG_MODE_TEXT = 1,
    _,
};
pub const pspUtilityMsgDialogMode = enum_unnamed_2;
const enum_unnamed_3 = extern enum(c_int) {
    PSP_UTILITY_MSGDIALOG_OPTION_ERROR = 0,
    PSP_UTILITY_MSGDIALOG_OPTION_TEXT = 1,
    PSP_UTILITY_MSGDIALOG_OPTION_YESNO_BUTTONS = 16,
    PSP_UTILITY_MSGDIALOG_OPTION_DEFAULT_NO = 256,
    _,
};
pub const pspUtilityMsgDialogOption = enum_unnamed_3;
const enum_unnamed_4 = extern enum(c_int) {
    PSP_UTILITY_MSGDIALOG_RESULT_UNKNOWN1 = 0,
    PSP_UTILITY_MSGDIALOG_RESULT_YES = 1,
    PSP_UTILITY_MSGDIALOG_RESULT_NO = 2,
    PSP_UTILITY_MSGDIALOG_RESULT_BACK = 3,
    _,
};
pub const pspUtilityMsgDialogPressed = enum_unnamed_4;
pub const struct__pspUtilityMsgDialogParams = extern struct {
    base: pspUtilityDialogCommon,
    unknown: c_int,
    mode: pspUtilityMsgDialogMode,
    errorValue: c_uint,
    message: [512]u8,
    options: c_int,
    buttonPressed: pspUtilityMsgDialogPressed,
};
pub const pspUtilityMsgDialogParams = struct__pspUtilityMsgDialogParams;
pub extern fn sceUtilityMsgDialogInitStart(params: [*c]pspUtilityMsgDialogParams) c_int;
pub extern fn sceUtilityMsgDialogShutdownStart() void;
pub extern fn sceUtilityMsgDialogGetStatus() c_int;
pub extern fn sceUtilityMsgDialogUpdate(n: c_int) void;
pub extern fn sceUtilityMsgDialogAbort() c_int;

pub const enum_pspUtilityNetconfActions = extern enum(c_int) {
    PSP_NETCONF_ACTION_CONNECTAP,
    PSP_NETCONF_ACTION_DISPLAYSTATUS,
    PSP_NETCONF_ACTION_CONNECT_ADHOC,
    _,
};
pub const struct_pspUtilityNetconfAdhoc = extern struct {
    name: [8]u8,
    timeout: c_uint,
};
pub const struct__pspUtilityNetconfData = extern struct {
    base: pspUtilityDialogCommon,
    action: c_int,
    adhocparam: [*c]struct_pspUtilityNetconfAdhoc,
    hotspot: c_int,
    hotspot_connected: c_int,
    wifisp: c_int,
};
pub const pspUtilityNetconfData = struct__pspUtilityNetconfData;
pub extern fn sceUtilityNetconfInitStart(data: [*c]pspUtilityNetconfData) c_int;
pub extern fn sceUtilityNetconfShutdownStart() c_int;
pub extern fn sceUtilityNetconfUpdate(unknown: c_int) c_int;
pub extern fn sceUtilityNetconfGetStatus() c_int;
const union_unnamed_9 = extern union {
    asUint: u32_7,
    asString: [128]u8,
};
pub const netData = union_unnamed_9;
pub extern fn sceUtilityCheckNetParam(id: c_int) c_int;
pub extern fn sceUtilityGetNetParam(conf: c_int, param: c_int, data: [*c]netData) c_int;
pub extern fn sceUtilityCreateNetParam(conf: c_int) c_int;
pub extern fn sceUtilitySetNetParam(param: c_int, val: ?*const c_void) c_int;
pub extern fn sceUtilityCopyNetParam(src: c_int, dest: c_int) c_int;
pub extern fn sceUtilityDeleteNetParam(conf: c_int) c_int;


const enum_unnamed_10 = extern enum(c_int) {
    PSP_UTILITY_SAVEDATA_AUTOLOAD = 0,
    PSP_UTILITY_SAVEDATA_AUTOSAVE = 1,
    PSP_UTILITY_SAVEDATA_LOAD = 2,
    PSP_UTILITY_SAVEDATA_SAVE = 3,
    PSP_UTILITY_SAVEDATA_LISTLOAD = 4,
    PSP_UTILITY_SAVEDATA_LISTSAVE = 5,
    PSP_UTILITY_SAVEDATA_LISTDELETE = 6,
    PSP_UTILITY_SAVEDATADELETE = 7,
    _,
};
pub const PspUtilitySavedataMode = enum_unnamed_10;
const enum_unnamed_11 = extern enum(c_int) {
    PSP_UTILITY_SAVEDATA_FOCUS_UNKNOWN = 0,
    PSP_UTILITY_SAVEDATA_FOCUS_FIRSTLIST = 1,
    PSP_UTILITY_SAVEDATA_FOCUS_LASTLIST = 2,
    PSP_UTILITY_SAVEDATA_FOCUS_LATEST = 3,
    PSP_UTILITY_SAVEDATA_FOCUS_OLDEST = 4,
    PSP_UTILITY_SAVEDATA_FOCUS_UNKNOWN2 = 5,
    PSP_UTILITY_SAVEDATA_FOCUS_UNKNOWN3 = 6,
    PSP_UTILITY_SAVEDATA_FOCUS_FIRSTEMPTY = 7,
    PSP_UTILITY_SAVEDATA_FOCUS_LASTEMPTY = 8,
    _,
};
pub const PspUtilitySavedataFocus = enum_unnamed_11;
pub const struct_PspUtilitySavedataSFOParam = extern struct {
    title: [128]u8,
    savedataTitle: [128]u8,
    detail: [1024]u8,
    parentalLevel: u8,
    unknown: [3]u8,
};
pub const PspUtilitySavedataSFOParam = struct_PspUtilitySavedataSFOParam;
pub const struct_PspUtilitySavedataFileData = extern struct {
    buf: ?*c_void,
    bufSize: SceSize,
    size: SceSize,
    unknown: c_int,
};
pub const PspUtilitySavedataFileData = struct_PspUtilitySavedataFileData;
pub const struct_PspUtilitySavedataListSaveNewData = extern struct {
    icon0: PspUtilitySavedataFileData,
    title: [*c]u8,
};
pub const PspUtilitySavedataListSaveNewData = struct_PspUtilitySavedataListSaveNewData;
pub const struct_SceUtilitySavedataParam = extern struct {
    base: pspUtilityDialogCommon,
    mode: PspUtilitySavedataMode,
    unknown1: c_int,
    overwrite: c_int,
    gameName: [13]u8,
    reserved: [3]u8,
    saveName: [20]u8,
    saveNameList: [*c][20]u8,
    fileName: [13]u8,
    reserved1: [3]u8,
    dataBuf: ?*c_void,
    dataBufSize: SceSize,
    dataSize: SceSize,
    sfoParam: PspUtilitySavedataSFOParam,
    icon0FileData: PspUtilitySavedataFileData,
    icon1FileData: PspUtilitySavedataFileData,
    pic1FileData: PspUtilitySavedataFileData,
    snd0FileData: PspUtilitySavedataFileData,
    newData: [*c]PspUtilitySavedataListSaveNewData,
    focus: PspUtilitySavedataFocus,
    unknown2: [4]c_int,
};
pub const SceUtilitySavedataParam = struct_SceUtilitySavedataParam;
pub extern fn sceUtilitySavedataInitStart(params: [*c]SceUtilitySavedataParam) c_int;
pub extern fn sceUtilitySavedataGetStatus() c_int;
pub extern fn sceUtilitySavedataShutdownStart() c_int;
pub extern fn sceUtilitySavedataUpdate(unknown: c_int) void;
const enum_unnamed_12 = extern enum(c_int) {
    PSP_UTILITY_GAMESHARING_MODE_SINGLE = 1,
    PSP_UTILITY_GAMESHARING_MODE_MULTIPLE = 2,
    _,
};
pub const pspUtilityGameSharingMode = enum_unnamed_12;
const enum_unnamed_13 = extern enum(c_int) {
    PSP_UTILITY_GAMESHARING_DATA_TYPE_FILE = 1,
    PSP_UTILITY_GAMESHARING_DATA_TYPE_MEMORY = 2,
    _,
};
pub const pspUtilityGameSharingDataType = enum_unnamed_13;
pub const struct__pspUtilityGameSharingParams = extern struct {
    base: pspUtilityDialogCommon,
    unknown1: c_int,
    unknown2: c_int,
    name: [8]u8,
    unknown3: c_int,
    unknown4: c_int,
    unknown5: c_int,
    result: c_int,
    filepath: [*c]u8,
    mode: pspUtilityGameSharingMode,
    datatype: pspUtilityGameSharingDataType,
    data: ?*c_void,
    datasize: c_uint,
};
pub const pspUtilityGameSharingParams = struct__pspUtilityGameSharingParams;
pub extern fn sceUtilityGameSharingInitStart(params: [*c]pspUtilityGameSharingParams) c_int;
pub extern fn sceUtilityGameSharingShutdownStart() void;
pub extern fn sceUtilityGameSharingGetStatus() c_int;
pub extern fn sceUtilityGameSharingUpdate(n: c_int) void;
pub const enum_pspUtilityHtmlViewerDisconnectModes = extern enum(c_int) {
    PSP_UTILITY_HTMLVIEWER_DISCONNECTMODE_ENABLE = 0,
    PSP_UTILITY_HTMLVIEWER_DISCONNECTMODE_DISABLE = 1,
    PSP_UTILITY_HTMLVIEWER_DISCONNECTMODE_CONFIRM = 2,
    _,
};
pub const enum_pspUtilityHtmlViewerInterfaceModes = extern enum(c_int) {
    PSP_UTILITY_HTMLVIEWER_INTERFACEMODE_FULL = 0,
    PSP_UTILITY_HTMLVIEWER_INTERFACEMODE_LIMITED = 1,
    PSP_UTILITY_HTMLVIEWER_INTERFACEMODE_NONE = 2,
    _,
};
pub const enum_pspUtilityHtmlViewerCookieModes = extern enum(c_int) {
    PSP_UTILITY_HTMLVIEWER_COOKIEMODE_DISABLED = 0,
    PSP_UTILITY_HTMLVIEWER_COOKIEMODE_ENABLED = 1,
    PSP_UTILITY_HTMLVIEWER_COOKIEMODE_CONFIRM = 2,
    PSP_UTILITY_HTMLVIEWER_COOKIEMODE_DEFAULT = 3,
    _,
};
pub const enum_pspUtilityHtmlViewerTextSizes = extern enum(c_int) {
    PSP_UTILITY_HTMLVIEWER_TEXTSIZE_LARGE = 0,
    PSP_UTILITY_HTMLVIEWER_TEXTSIZE_NORMAL = 1,
    PSP_UTILITY_HTMLVIEWER_TEXTSIZE_SMALL = 2,
    _,
};
pub const enum_pspUtilityHtmlViewerDisplayModes = extern enum(c_int) {
    PSP_UTILITY_HTMLVIEWER_DISPLAYMODE_NORMAL = 0,
    PSP_UTILITY_HTMLVIEWER_DISPLAYMODE_FIT = 1,
    PSP_UTILITY_HTMLVIEWER_DISPLAYMODE_SMART_FIT = 2,
    _,
};
pub const enum_pspUtilityHtmlViewerConnectModes = extern enum(c_int) {
    PSP_UTILITY_HTMLVIEWER_CONNECTMODE_LAST = 0,
    PSP_UTILITY_HTMLVIEWER_CONNECTMODE_MANUAL_ONCE = 1,
    PSP_UTILITY_HTMLVIEWER_CONNECTMODE_MANUAL_ALL = 2,
    _,
};
pub const enum_pspUtilityHtmlViewerOptions = extern enum(c_int) {
    PSP_UTILITY_HTMLVIEWER_OPEN_SCE_START_PAGE = 1,
    PSP_UTILITY_HTMLVIEWER_DISABLE_STARTUP_LIMITS = 2,
    PSP_UTILITY_HTMLVIEWER_DISABLE_EXIT_DIALOG = 4,
    PSP_UTILITY_HTMLVIEWER_DISABLE_CURSOR = 8,
    PSP_UTILITY_HTMLVIEWER_DISABLE_DOWNLOAD_COMPLETE_DIALOG = 16,
    PSP_UTILITY_HTMLVIEWER_DISABLE_DOWNLOAD_START_DIALOG = 32,
    PSP_UTILITY_HTMLVIEWER_DISABLE_DOWNLOAD_DESTINATION_DIALOG = 64,
    PSP_UTILITY_HTMLVIEWER_LOCK_DOWNLOAD_DESTINATION_DIALOG = 128,
    PSP_UTILITY_HTMLVIEWER_DISABLE_TAB_DISPLAY = 256,
    PSP_UTILITY_HTMLVIEWER_ENABLE_ANALOG_HOLD = 512,
    PSP_UTILITY_HTMLVIEWER_ENABLE_FLASH = 1024,
    PSP_UTILITY_HTMLVIEWER_DISABLE_LRTRIGGER = 2048,
    _,
};
pub const struct_pspUtilityHtmlViewerParam = extern struct {
    base: pspUtilityDialogCommon,
    memaddr: ?*c_void,
    memsize: c_uint,
    unknown1: c_int,
    unknown2: c_int,
    initialurl: [*c]u8,
    numtabs: c_uint,
    interfacemode: c_uint,
    options: c_uint,
    dldirname: [*c]u8,
    dlfilename: [*c]u8,
    uldirname: [*c]u8,
    ulfilename: [*c]u8,
    cookiemode: c_uint,
    unknown3: c_uint,
    homeurl: [*c]u8,
    textsize: c_uint,
    displaymode: c_uint,
    connectmode: c_uint,
    disconnectmode: c_uint,
    memused: c_uint,
    unknown4: [10]c_int,
};
pub const pspUtilityHtmlViewerParam = struct_pspUtilityHtmlViewerParam;
pub extern fn sceUtilityHtmlViewerInitStart(params: [*c]pspUtilityHtmlViewerParam) c_int;
pub extern fn sceUtilityHtmlViewerShutdownStart() c_int;
pub extern fn sceUtilityHtmlViewerUpdate(n: c_int) c_int;
pub extern fn sceUtilityHtmlViewerGetStatus() c_int;
pub extern fn sceUtilitySetSystemParamInt(id: c_int, value: c_int) c_int;
pub extern fn sceUtilitySetSystemParamString(id: c_int, str: [*c]const u8) c_int;
pub extern fn sceUtilityGetSystemParamInt(id: c_int, value: [*c]c_int) c_int;
pub extern fn sceUtilityGetSystemParamString(id: c_int, str: [*c]u8, len: c_int) c_int;
pub const enum_SceUtilityOskInputLanguage = extern enum(c_int) {
    PSP_UTILITY_OSK_LANGUAGE_DEFAULT = 0,
    PSP_UTILITY_OSK_LANGUAGE_JAPANESE = 1,
    PSP_UTILITY_OSK_LANGUAGE_ENGLISH = 2,
    PSP_UTILITY_OSK_LANGUAGE_FRENCH = 3,
    PSP_UTILITY_OSK_LANGUAGE_SPANISH = 4,
    PSP_UTILITY_OSK_LANGUAGE_GERMAN = 5,
    PSP_UTILITY_OSK_LANGUAGE_ITALIAN = 6,
    PSP_UTILITY_OSK_LANGUAGE_DUTCH = 7,
    PSP_UTILITY_OSK_LANGUAGE_PORTUGESE = 8,
    PSP_UTILITY_OSK_LANGUAGE_RUSSIAN = 9,
    PSP_UTILITY_OSK_LANGUAGE_KOREAN = 10,
    _,
};
pub const enum_SceUtilityOskState = extern enum(c_int) {
    PSP_UTILITY_OSK_DIALOG_NONE = 0,
    PSP_UTILITY_OSK_DIALOG_INITING = 1,
    PSP_UTILITY_OSK_DIALOG_INITED = 2,
    PSP_UTILITY_OSK_DIALOG_VISIBLE = 3,
    PSP_UTILITY_OSK_DIALOG_QUIT = 4,
    PSP_UTILITY_OSK_DIALOG_FINISHED = 5,
    _,
};
pub const enum_SceUtilityOskResult = extern enum(c_int) {
    PSP_UTILITY_OSK_RESULT_UNCHANGED = 0,
    PSP_UTILITY_OSK_RESULT_CANCELLED = 1,
    PSP_UTILITY_OSK_RESULT_CHANGED = 2,
    _,
};
pub const enum_SceUtilityOskInputType = extern enum(c_int) {
    PSP_UTILITY_OSK_INPUTTYPE_ALL = 0,
    PSP_UTILITY_OSK_INPUTTYPE_LATIN_DIGIT = 1,
    PSP_UTILITY_OSK_INPUTTYPE_LATIN_SYMBOL = 2,
    PSP_UTILITY_OSK_INPUTTYPE_LATIN_LOWERCASE = 4,
    PSP_UTILITY_OSK_INPUTTYPE_LATIN_UPPERCASE = 8,
    PSP_UTILITY_OSK_INPUTTYPE_JAPANESE_DIGIT = 256,
    PSP_UTILITY_OSK_INPUTTYPE_JAPANESE_SYMBOL = 512,
    PSP_UTILITY_OSK_INPUTTYPE_JAPANESE_LOWERCASE = 1024,
    PSP_UTILITY_OSK_INPUTTYPE_JAPANESE_UPPERCASE = 2048,
    PSP_UTILITY_OSK_INPUTTYPE_JAPANESE_HIRAGANA = 4096,
    PSP_UTILITY_OSK_INPUTTYPE_JAPANESE_HALF_KATAKANA = 8192,
    PSP_UTILITY_OSK_INPUTTYPE_JAPANESE_KATAKANA = 16384,
    PSP_UTILITY_OSK_INPUTTYPE_JAPANESE_KANJI = 32768,
    PSP_UTILITY_OSK_INPUTTYPE_RUSSIAN_LOWERCASE = 65536,
    PSP_UTILITY_OSK_INPUTTYPE_RUSSIAN_UPPERCASE = 131072,
    PSP_UTILITY_OSK_INPUTTYPE_KOREAN = 262144,
    PSP_UTILITY_OSK_INPUTTYPE_URL = 524288,
    _,
};
pub const struct__SceUtilityOskData = extern struct {
    unk_00: c_int,
    unk_04: c_int,
    language: c_int,
    unk_12: c_int,
    inputtype: c_int,
    lines: c_int,
    unk_24: c_int,
    desc: [*c]c_ushort,
    intext: [*c]c_ushort,
    outtextlength: c_int,
    outtext: [*c]c_ushort,
    result: c_int,
    outtextlimit: c_int,
};
pub const SceUtilityOskData = struct__SceUtilityOskData;
pub const struct__SceUtilityOskParams = extern struct {
    base: pspUtilityDialogCommon,
    datacount: c_int,
    data: [*c]SceUtilityOskData,
    state: c_int,
    unk_60: c_int,
};
pub const SceUtilityOskParams = struct__SceUtilityOskParams;
pub extern fn sceUtilityOskInitStart(params: [*c]SceUtilityOskParams) c_int;
pub extern fn sceUtilityOskShutdownStart() c_int;
pub extern fn sceUtilityOskUpdate(n: c_int) c_int;
pub extern fn sceUtilityOskGetStatus() c_int;
pub extern fn sceUtilityLoadNetModule(module: c_int) c_int;
pub extern fn sceUtilityUnloadNetModule(module: c_int) c_int;
pub extern fn sceUtilityLoadAvModule(module: c_int) c_int;
pub extern fn sceUtilityUnloadAvModule(module: c_int) c_int;
pub extern fn sceUtilityLoadUsbModule(module: c_int) c_int;
pub extern fn sceUtilityUnloadUsbModule(module: c_int) c_int;
pub extern fn sceUtilityLoadModule(module: c_int) c_int;
pub extern fn sceUtilityUnloadModule(module: c_int) c_int;
const enum_unnamed_14 = extern enum(c_int) {
    PSP_UTILITY_DIALOG_NONE = 0,
    PSP_UTILITY_DIALOG_INIT = 1,
    PSP_UTILITY_DIALOG_VISIBLE = 2,
    PSP_UTILITY_DIALOG_QUIT = 3,
    PSP_UTILITY_DIALOG_FINISHED = 4,
    _,
};
pub const pspUtilityDialogState = enum_unnamed_14;

pub const _pspUtilityMsgDialogParams = struct__pspUtilityMsgDialogParams;
pub const pspUtilityNetconfActions = enum_pspUtilityNetconfActions;
pub const pspUtilityNetconfAdhoc = struct_pspUtilityNetconfAdhoc;
pub const _pspUtilityNetconfData = struct__pspUtilityNetconfData;
pub const _pspUtilityGameSharingParams = struct__pspUtilityGameSharingParams;
pub const pspUtilityHtmlViewerDisconnectModes = enum_pspUtilityHtmlViewerDisconnectModes;
pub const pspUtilityHtmlViewerInterfaceModes = enum_pspUtilityHtmlViewerInterfaceModes;
pub const pspUtilityHtmlViewerCookieModes = enum_pspUtilityHtmlViewerCookieModes;
pub const pspUtilityHtmlViewerTextSizes = enum_pspUtilityHtmlViewerTextSizes;
pub const pspUtilityHtmlViewerDisplayModes = enum_pspUtilityHtmlViewerDisplayModes;
pub const pspUtilityHtmlViewerConnectModes = enum_pspUtilityHtmlViewerConnectModes;
pub const pspUtilityHtmlViewerOptions = enum_pspUtilityHtmlViewerOptions;
pub const SceUtilityOskInputLanguage = enum_SceUtilityOskInputLanguage;
pub const SceUtilityOskState = enum_SceUtilityOskState;
pub const SceUtilityOskResult = enum_SceUtilityOskResult;
pub const SceUtilityOskInputType = enum_SceUtilityOskInputType;
pub const _SceUtilityOskData = struct__SceUtilityOskData;
pub const _SceUtilityOskParams = struct__SceUtilityOskParams;

pub const PSP_MODULE_NET_PARSEURI = 0x0103;
pub const PSP_SYSTEMPARAM_ID_INT_DAYLIGHTSAVINGS = 7;
pub const PSP_SYSTEMPARAM_LANGUAGE_CHINESE_TRADITIONAL = 10;
pub const PSP_SYSTEMPARAM_TIME_FORMAT_24HR = 0;
pub const PSP_SYSTEMPARAM_ID_STRING_NICKNAME = 1;
pub const PSP_UTILITY_ACCEPT_CROSS = 1;
pub const PSP_USB_MODULE_MIC = 3;
pub const PSP_NETPARAM_USE_PROXY = 13;
pub const PSP_AV_MODULE_AAC = 6;
pub const PSP_SYSTEMPARAM_RETVAL_OK = 0;
pub const PSP_AV_MODULE_ATRAC3PLUS = 2;
pub const PSP_MODULE_NET_COMMON = 0x0100;
pub const PSP_MODULE_AV_ATRAC3PLUS = 0x0302;
pub const PSP_NETPARAM_NETMASK = 6;
pub const PSP_UTILITY_ACCEPT_CIRCLE = 0;
pub const PSP_MODULE_NP_COMMON = 0x0400;
pub const PSP_NETPARAM_WEPKEY = 3;
pub const PSP_MODULE_AV_AVCODEC = 0x0300;
pub const PSP_SYSTEMPARAM_LANGUAGE_GERMAN = 4;
pub const PSP_AV_MODULE_G729 = 7;
pub const PSP_SYSTEMPARAM_ID_INT_TIMEZONE = 6;
pub const PSP_SYSTEMPARAM_ID_INT_DATE_FORMAT = 4;
pub const PSP_SYSTEMPARAM_ID_INT_LANGUAGE = 8;
pub const PSP_NETPARAM_UNKNOWN1 = 16;
pub const PSP_MODULE_IRDA = 0x0600;
pub const PSP_SYSTEMPARAM_WLAN_POWERSAVE_OFF = 0;
pub const PSP_MODULE_USB_PSPCM = 0x0200;
pub const PSP_NETPARAM_IP = 5;
pub const PSP_MODULE_AV_MP3 = 0x0304;
pub const PSP_NET_MODULE_COMMON = 1;
pub const PSP_NETPARAM_MANUAL_DNS = 8;
pub const PSP_SYSTEMPARAM_DAYLIGHTSAVINGS_STD = 0;
pub const PSP_NETPARAM_PRIMARYDNS = 9;
pub const PSP_USB_MODULE_GPS = 5;
pub const PSP_MODULE_NP_SERVICE = 0x0401;
pub const PSP_SYSTEMPARAM_LANGUAGE_RUSSIAN = 8;
pub const PSP_AV_MODULE_SASCORE = 1;
pub const PSP_MODULE_NET_PARSEHTTP = 0x0104;
pub const PSP_AV_MODULE_VAUDIO = 5;
pub const PSP_SYSTEMPARAM_LANGUAGE_CHINESE_SIMPLIFIED = 11;
pub const PSP_NETPARAM_ROUTE = 7;
pub const PSP_SYSTEMPARAM_LANGUAGE_FRENCH = 2;
pub const PSP_NETPARAM_PROXY_USER = 11;
pub const PSP_NETPARAM_SSID = 1;
pub const PSP_SYSTEMPARAM_ID_INT_ADHOC_CHANNEL = 2;
pub const PSP_NETPARAM_SECONDARYDNS = 10;
pub const PSP_MODULE_AV_SASCORE = 0x0301;
pub const PSP_NETPARAM_ERROR_BAD_NETCONF = 0x80110601;
pub const PSP_SYSTEMPARAM_ADHOC_CHANNEL_AUTOMATIC = 0;
pub const PSP_SYSTEMPARAM_LANGUAGE_SPANISH = 3;
pub const PSP_NET_MODULE_HTTP = 6;
pub const PSP_SYSTEMPARAM_LANGUAGE_JAPANESE = 0;
pub const PSP_SYSTEMPARAM_LANGUAGE_PORTUGUESE = 7;
pub const PSP_NETPARAM_PROXY_SERVER = 14;
pub const PSP_NET_MODULE_SSL = 7;
pub const PSP_NETPARAM_PROXY_PORT = 15;
pub const PSP_SYSTEMPARAM_RETVAL_FAIL = 0x80110103;
pub const PSP_MODULE_AV_MPEGBASE = 0x0303;
pub const PSP_USB_MODULE_PSPCM = 1;
pub const PSP_NETPARAM_IS_STATIC_IP = 4;
pub const PSP_SYSTEMPARAM_DATE_FORMAT_DDMMYYYY = 2;
pub const PSP_MODULE_USB_MIC = 0x0201;
pub const PSP_AV_MODULE_MPEGBASE = 3;
pub const PSP_SYSTEMPARAM_ADHOC_CHANNEL_11 = 11;
pub const PSP_NET_MODULE_PARSEURI = 4;
pub const PSP_SYSTEMPARAM_DATE_FORMAT_YYYYMMDD = 0;
pub const PSP_SYSTEMPARAM_DAYLIGHTSAVINGS_SAVING = 1;
pub const PSP_MODULE_AV_AAC = 0x0306;
pub const PSP_SYSTEMPARAM_ADHOC_CHANNEL_1 = 1;
pub const PSP_MODULE_USB_CAM = 0x0202;
pub const PSP_SYSTEMPARAM_LANGUAGE_ITALIAN = 5;
pub const PSP_MODULE_AV_G729 = 0x0307;
pub const PSP_SYSTEMPARAM_ID_INT_TIME_FORMAT = 5;
pub const PSP_NETPARAM_UNKNOWN2 = 17;
pub const PSP_SYSTEMPARAM_TIME_FORMAT_12HR = 1;
pub const PSP_SYSTEMPARAM_ADHOC_CHANNEL_6 = 6;
pub const PSP_MODULE_NET_ADHOC = 0x0101;
pub const PSP_SYSTEMPARAM_WLAN_POWERSAVE_ON = 1;
pub const PSP_MODULE_AV_VAUDIO = 0x0305;
pub const PSP_SYSTEMPARAM_ID_INT_WLAN_POWERSAVE = 3;
pub const PSP_NETPARAM_PROXY_PASS = 12;
pub const PSP_SYSTEMPARAM_DATE_FORMAT_MMDDYYYY = 1;
pub const PSP_NET_MODULE_INET = 3;
pub const PSP_MODULE_NET_INET = 0x0102;
pub const PSP_AV_MODULE_MP3 = 4;
pub const PSP_MODULE_NET_SSL = 0x0106;
pub const PSP_NETPARAM_SECURE = 2;
pub const PSP_MODULE_NET_HTTP = 0x0105;
pub const PSP_USB_MODULE_CAM = 4;
pub const PSP_MODULE_NP_MATCHING2 = 0x0402;
pub const PSP_SYSTEMPARAM_LANGUAGE_DUTCH = 6;
pub const PSP_AV_MODULE_AVCODEC = 0;
pub const PSP_NETPARAM_ERROR_BAD_PARAM = 0x80110604;
pub const PSP_NET_MODULE_ADHOC = 2;
pub const PSP_MODULE_NP_DRM = 0x0500;
pub const PSP_MODULE_USB_GPS = 0x0203;
pub const PSP_SYSTEMPARAM_ID_INT_UNKNOWN = 9;
pub const PSP_SYSTEMPARAM_LANGUAGE_ENGLISH = 1;
pub const PSP_NETPARAM_NAME = 0;
pub const PSP_NET_MODULE_PARSEHTTP = 5;
pub const PSP_USB_MODULE_ACC = 2;
pub const PSP_SYSTEMPARAM_LANGUAGE_KOREAN = 9;
