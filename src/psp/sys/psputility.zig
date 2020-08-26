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

pub const ModuleNet = extern enum(c_int){
    Common = 1,
    Adhoc = 2,
    Inet = 3,
    Parseuri = 4,
    Parsehttp = 5,
    Http = 6,
    Ssl = 7
};

pub const ModuleUSB = extern enum(c_int){
    Pspcm = 1,
    Acc = 2,
    Mic = 3,
    Cam = 4,
    Gps = 5,
};

pub const NetParam = extern enum(c_int){
    Name = 0,
    Ssid = 1,
    Secure = 2,
    Wepkey = 3,
    IsStaticIp = 4,
    Ip = 5,
    Netmask = 6,
    Route = 7,
    ManualDns = 8,
    Primarydns = 9,
    Secondarydns = 10,
    ProxyUser = 11,
    ProxyPass = 12,
    UseProxy = 13,
    ProxyServer = 14,
    ProxyPort = 15,
    Unknown1 = 16,
    Unknown2 = 17
};

pub const SystemParamID = extern enum(c_int){
    StringNickname = 1,
    IntAdhocChannel = 2,
    IntWlanPowersave = 3,
    IntDateFormat = 4,
    IntTimeFormat = 5,
    IntTimezone = 6,
    IntDaylightsavings = 7,
    IntLanguage = 8,
    IntUnknown = 9
};

pub const ModuleAV = extern enum(c_int){
    Avcodec = 0,
    Sascore = 1,
    Atrac3plus = 2,
    Mpegbase = 3,
    Mp3 = 4,
    Vaudio = 5,
    Aac = 6,
    G729 = 7
};

pub const SystemParamLanguage = extern enum(c_int){
    Japanese = 0,
    English = 1,
    French = 2,
    Spanish = 3,
    German = 4,
    Italian = 5,
    Dutch = 6,
    Portuguese = 7,
    Russian = 8,
    Korean = 9,
    ChineseTraditional = 10,
    ChineseSimplified = 11,
};

pub const SystemParamTime = extern enum(c_int){
    Format24Hr = 0,
    Format12Hr = 1
};

pub const UtilityAccept = extern enum(c_int){
    Circle = 0,
    Cross = 1
};

pub const SystemParamAdhoc = extern enum(c_int){
    ChannelAutomatic = 0,
    Channel1 = 1,
    Channel6 = 6,
    Channel11 = 11,
};

pub const NetParamError = extern enum(c_int){
    BadNetconf = 0x80110601,
    BadParam = 0x80110604
};

pub const SystemParamWlanPowerSave = extern enum(c_int){
    Off = 0,
    On = 1
};

pub const SystemParamDaylightSavings = extern enum(c_int){
    Std = 0,
    Saving = 1
};

pub const SystemParamDateFormat = extern enum(c_int){
    YYYYMMDD = 0,
    MMDDYYYY = 1,
    DDMMYYYY = 2
};

pub const SystemParamRetVal = extern enum(c_int){
    Ok = 0,
    Fail = 0x80110103
};

pub const ModuleNP = extern enum(c_int){
    Common = 0x0400,
    Service = 0x0401,
    Matching2 = 0x0402,
    Drm = 0x0500,
    Irda = 0x0600
};


const macro = @import("pspmacros.zig");

comptime{
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