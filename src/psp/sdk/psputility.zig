pub const PspUtilityDialogCommon = extern struct {
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

pub const PspUtilityMsgDialogMode = extern enum(c_int) {
    Error = 0,
    Text = 1,
    _,
};
const PspUtilityMsgDialogOption = extern enum(c_int) {
    Error = 0,
    Text = 1,
    YesNoButtons = 16,
    DefaultNo = 256,
};

pub const PspUtilityMsgDialogPressed = extern enum(c_int) {
    Unknown1 = 0,
    Yes = 1,
    No = 2,
    Back = 3,
};
pub const PspUtilityMsgDialogParams = extern struct {
    base: PspUtilityDialogCommon,
    unknown: c_int,
    mode: PspUtilityMsgDialogMode,
    errorValue: c_uint,
    message: [512]u8,
    options: c_int,
    buttonPressed: PspUtilityMsgDialogPressed,
};
pub extern fn sceUtilityMsgDialogInitStart(params: *PspUtilityMsgDialogParams) c_int;
pub extern fn sceUtilityMsgDialogShutdownStart() void;
pub extern fn sceUtilityMsgDialogGetStatus() c_int;
pub extern fn sceUtilityMsgDialogUpdate(n: c_int) void;
pub extern fn sceUtilityMsgDialogAbort() c_int;

pub const PspUtilityNetconfActions = extern enum(c_int) {
    ConnectAp,
    DisplayStatus,
    ConnectAdhoc,
};
pub const PspUtilityNetconfAdhoc = extern struct {
    name: [8]u8,
    timeout: c_uint,
};
pub const PspUtilityNetconfData = extern struct {
    base: PspUtilityDialogCommon,
    action: c_int,
    adhocparam: *PspUtilityNetconfAdhoc,
    hotspot: c_int,
    hotspot_connected: c_int,
    wifisp: c_int,
};

pub extern fn sceUtilityNetconfInitStart(data: *PspUtilityNetconfData) c_int;
pub extern fn sceUtilityNetconfShutdownStart() c_int;
pub extern fn sceUtilityNetconfUpdate(unknown: c_int) c_int;
pub extern fn sceUtilityNetconfGetStatus() c_int;
const NetData = extern union {
    asUint: u32_7,
    asString: [128]u8,
};

pub extern fn sceUtilityCheckNetParam(id: c_int) c_int;
pub extern fn sceUtilityGetNetParam(conf: c_int, param: c_int, data: *NetData) c_int;
pub extern fn sceUtilityCreateNetParam(conf: c_int) c_int;
pub extern fn sceUtilitySetNetParam(param: c_int, val: ?*const c_void) c_int;
pub extern fn sceUtilityCopyNetParam(src: c_int, dest: c_int) c_int;
pub extern fn sceUtilityDeleteNetParam(conf: c_int) c_int;

const PspUtilitySavedataMode = extern enum(c_int) {
    Autoload = 0,
    Autosave = 1,
    Load = 2,
    Save = 3,
    ListLoad = 4,
    ListSave = 5,
    ListDelete = 6,
    Delete = 7,
    _,
};

const PspUtilitySavedataFocus = extern enum(c_int) {
    Unknown = 0,
    FirstList = 1,
    LastList = 2,
    Latest = 3,
    Oldest = 4,
    Unknown2 = 5,
    Unknown3 = 6,
    FirstEmpty = 7,
    LastEmpty = 8,
    _,
};

pub const PspUtilitySavedataSFOParam = extern struct {
    title: [128]u8,
    savedataTitle: [128]u8,
    detail: [1024]u8,
    parentalLevel: u8,
    unknown: [3]u8,
};

pub const PspUtilitySavedataFileData = extern struct {
    buf: ?*c_void,
    bufSize: SceSize,
    size: SceSize,
    unknown: c_int,
};

pub const PspUtilitySavedataListSaveNewData = extern struct {
    icon0: PspUtilitySavedataFileData,
    title: [*c]u8,
};

pub const SceUtilitySavedataParam = extern struct {
    base: PspUtilityDialogCommon,
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
pub extern fn sceUtilitySavedataInitStart(params: *SceUtilitySavedataParam) c_int;
pub extern fn sceUtilitySavedataGetStatus() c_int;
pub extern fn sceUtilitySavedataShutdownStart() c_int;
pub extern fn sceUtilitySavedataUpdate(unknown: c_int) void;

pub extern fn sceUtilityGameSharingInitStart(params: *PspUtilityGameSharingParams) c_int;
pub extern fn sceUtilityGameSharingShutdownStart() void;
pub extern fn sceUtilityGameSharingGetStatus() c_int;
pub extern fn sceUtilityGameSharingUpdate(n: c_int) void;

pub extern fn sceUtilityHtmlViewerInitStart(params: *PspUtilityHtmlViewerParam) c_int;
pub extern fn sceUtilityHtmlViewerShutdownStart() c_int;
pub extern fn sceUtilityHtmlViewerUpdate(n: c_int) c_int;
pub extern fn sceUtilityHtmlViewerGetStatus() c_int;
pub extern fn sceUtilitySetSystemParamInt(id: c_int, value: c_int) c_int;
pub extern fn sceUtilitySetSystemParamString(id: c_int, str: [*c]const u8) c_int;
pub extern fn sceUtilityGetSystemParamInt(id: c_int, value: [*c]c_int) c_int;
pub extern fn sceUtilityGetSystemParamString(id: c_int, str: [*c]u8, len: c_int) c_int;

pub extern fn sceUtilityOskInitStart(params: *SceUtilityOskParams) c_int;
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

pub const PspUtilityDialogState = extern enum(c_int) {
    None = 0,
    Init = 1,
    Visible = 2,
    Quit = 3,
    Finished = 4,
};

pub const SceUtilityOskInputType = extern enum(c_int) {
    All = 0,
    LatinDigit = 1,
    LatinSymbol = 2,
    LatinLowercase = 4,
    LatinUppercase = 8,
    JapaneseDigit = 256,
    JapaneseSymbol = 512,
    JapaneseLowercase = 1024,
    JapaneseUppercase = 2048,
    JapaneseHiragana = 4096,
    JapaneseHalfKatakana = 8192,
    JapaneseKatakana = 16384,
    JapaneseKanji = 32768,
    RussianLowercase = 65536,
    RussianUppercase = 131072,
    Korean = 262144,
    Url = 524288,
};

pub const SceUtilityOskInputLanguage = extern enum(c_int) {
    Default = 0,
    Japanese = 1,
    English = 2,
    French = 3,
    Spanish = 4,
    German = 5,
    Italian = 6,
    Dutch = 7,
    Portugese = 8,
    Russian = 9,
    Korean = 10,
};
pub const SceUtilityOskState = extern enum(c_int) {
    None = 0,
    Initing = 1,
    Inited = 2,
    Visible = 3,
    Quit = 4,
    Finished = 5,
};
pub const SceUtilityOskResult = extern enum(c_int) {
    Unchanged = 0,
    Cancelled = 1,
    Changed = 2,
};

pub const PspUtilityHtmlViewerDisconnectModes = extern enum(c_int) {
    Enable = 0,
    Disable = 1,
    Confirm = 2,
    _,
};
pub const PspUtilityHtmlViewerInterfaceModes = extern enum(c_int) {
    Full = 0,
    Limited = 1,
    None = 2,
    _,
};
pub const PspUtilityHtmlViewerCookieModes = extern enum(c_int) {
    Disabled = 0,
    Enabled = 1,
    Confirm = 2,
    Default = 3,
    _,
};
pub const PspUtilityGameSharingMode = extern enum(c_int) {
    Single = 1,
    Multiple = 2,
    _,
};

pub const PspUtilityGameSharingDataType = extern enum(c_int) {
    File = 1,
    Memory = 2,
    _,
};

pub const PspUtilityGameSharingParams = extern struct {
    base: PspUtilityDialogCommon,
    unknown1: c_int,
    unknown2: c_int,
    name: [8]u8,
    unknown3: c_int,
    unknown4: c_int,
    unknown5: c_int,
    result: c_int,
    filepath: [*c]u8,
    mode: PspUtilityGameSharingMode,
    datatype: PspUtilityGameSharingDataType,
    data: ?*c_void,
    datasize: c_uint,
};

pub const PspUtilityHtmlViewerTextSizes = extern enum(c_int) {
    Large = 0,
    Normal = 1,
    Small = 2,
    _,
};
pub const PspUtilityHtmlViewerDisplayModes = extern enum(c_int) {
    Normal = 0,
    Fit = 1,
    SmartFit = 2,
    _,
};
pub const PspUtilityHtmlViewerConnectModes = extern enum(c_int) {
    Last = 0,
    ManualOnce = 1,
    ManualAll = 2,
    _,
};
pub const PspUtilityHtmlViewerOptions = extern enum(c_int) {
    OpenSceStartPage = 1,
    DisableStartupLimits = 2,
    DisableExitDialog = 4,
    DisableCursor = 8,
    DisableDownloadCompleteDialog = 16,
    DisableDownloadStartDialog = 32,
    DisableDownloadDestinationDialog = 64,
    LockDownloadDestinationDialog = 128,
    DisableTabDisplay = 256,
    EnableAnalogHold = 512,
    EnableFlash = 1024,
    DisableLRTrigger = 2048,
};
pub const PspUtilityHtmlViewerParam = extern struct {
    base: PspUtilityDialogCommon,
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

pub const SceUtilityOskData = extern struct {
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

pub const SceUtilityOskParams = extern struct {
    base: PspUtilityDialogCommon,
    datacount: c_int,
    data: [*c]SceUtilityOskData,
    state: c_int,
    unk_60: c_int,
};

pub const ModuleNet = extern enum(c_int) {
    Common = 1, Adhoc = 2, Inet = 3, Parseuri = 4, Parsehttp = 5, Http = 6, Ssl = 7
};

pub const ModuleUSB = extern enum(c_int) {
    Pspcm = 1,
    Acc = 2,
    Mic = 3,
    Cam = 4,
    Gps = 5,
};

pub const NetParam = extern enum(c_int) {
    Name = 0, Ssid = 1, Secure = 2, Wepkey = 3, IsStaticIp = 4, Ip = 5, Netmask = 6, Route = 7, ManualDns = 8, Primarydns = 9, Secondarydns = 10, ProxyUser = 11, ProxyPass = 12, UseProxy = 13, ProxyServer = 14, ProxyPort = 15, Unknown1 = 16, Unknown2 = 17
};

pub const SystemParamID = extern enum(c_int) {
    StringNickname = 1, IntAdhocChannel = 2, IntWlanPowersave = 3, IntDateFormat = 4, IntTimeFormat = 5, IntTimezone = 6, IntDaylightsavings = 7, IntLanguage = 8, IntUnknown = 9
};

pub const ModuleAV = extern enum(c_int) {
    Avcodec = 0, Sascore = 1, Atrac3plus = 2, Mpegbase = 3, Mp3 = 4, Vaudio = 5, Aac = 6, G729 = 7
};

pub const SystemParamLanguage = extern enum(c_int) {
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

pub const SystemParamTime = extern enum(c_int) {
    Format24Hr = 0, Format12Hr = 1
};

pub const UtilityAccept = extern enum(c_int) {
    Circle = 0, Cross = 1
};

pub const SystemParamAdhoc = extern enum(c_int) {
    ChannelAutomatic = 0,
    Channel1 = 1,
    Channel6 = 6,
    Channel11 = 11,
};

pub const NetParamError = extern enum(c_int) {
    BadNetconf = 0x80110601, BadParam = 0x80110604
};

pub const SystemParamWlanPowerSave = extern enum(c_int) {
    Off = 0, On = 1
};

pub const SystemParamDaylightSavings = extern enum(c_int) {
    Std = 0, Saving = 1
};

pub const SystemParamDateFormat = extern enum(c_int) {
    YYYYMMDD = 0, MMDDYYYY = 1, DDMMYYYY = 2
};

pub const SystemParamRetVal = extern enum(c_int) {
    Ok = 0, Fail = 0x80110103
};

pub const ModuleNP = extern enum(c_int) {
    Common = 0x0400, Service = 0x0401, Matching2 = 0x0402, Drm = 0x0500, Irda = 0x0600
};
