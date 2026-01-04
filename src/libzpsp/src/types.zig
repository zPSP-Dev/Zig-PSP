pub const SceUChar8 = u8;
pub const SceUShort16 = u16;
pub const SceUInt32 = u32;
pub const SceUInt64 = u64;
pub const SceULong64 = u64;
pub const SceChar8 = u8;
pub const SceShort16 = i16;
pub const SceInt32 = i32;
pub const SceInt64 = i64;
pub const SceLong64 = i64;
pub const SceFloat = f32;
pub const SceFloat32 = f32;
pub const SceWChar16 = c_ushort;
pub const SceWChar32 = c_uint;
pub const SceBool = c_int;
pub const SceVoid = anyopaque;
pub const ScePVoid = ?*anyopaque;
pub const ScePspSRect = extern struct {
    x: c_short,
    y: c_short,
    w: c_short,
    h: c_short,
};
pub const ScePspIRect = extern struct {
    x: c_int,
    y: c_int,
    w: c_int,
    h: c_int,
};
pub const ScePspL64Rect = extern struct {
    x: SceLong64,
    y: SceLong64,
    w: SceLong64,
    h: SceLong64,
};
pub const ScePspFRect = extern struct {
    x: f32,
    y: f32,
    w: f32,
    h: f32,
};
pub const ScePspSVector2 = extern struct {
    x: c_short,
    y: c_short,
};
pub const ScePspIVector2 = extern struct {
    x: c_int,
    y: c_int,
};
pub const ScePspL64Vector2 = extern struct {
    x: SceLong64,
    y: SceLong64,
};
pub const ScePspFVector2 = extern struct {
    x: f32,
    y: f32,
};
pub const ScePspVector2 = extern union {
    fv: ScePspFVector2,
    iv: ScePspIVector2,
    f: [2]f32,
    i: [2]c_int,
};
pub const ScePspSVector3 = extern struct {
    x: c_short,
    y: c_short,
    z: c_short,
};
pub const ScePspIVector3 = extern struct {
    x: c_int,
    y: c_int,
    z: c_int,
};
pub const ScePspL64Vector3 = extern struct {
    x: SceLong64,
    y: SceLong64,
    z: SceLong64,
};
pub const ScePspFVector3 = extern struct {
    x: f32,
    y: f32,
    z: f32,
};

pub const ScePspVector3 = extern union {
    fv: ScePspFVector3,
    iv: ScePspIVector3,
    f: [3]f32,
    i: [3]c_int,
};
pub const ScePspSVector4 = extern struct {
    x: c_short,
    y: c_short,
    z: c_short,
    w: c_short,
};
pub const ScePspIVector4 = extern struct {
    x: c_int,
    y: c_int,
    z: c_int,
    w: c_int,
};
pub const ScePspL64Vector4 = extern struct {
    x: SceLong64,
    y: SceLong64,
    z: SceLong64,
    w: SceLong64,
};
pub const ScePspFVector4 = extern struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,
};
pub const ScePspFVector4Unaligned = extern struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,
};
pub const ScePspVector4 = extern union {
    fv: ScePspFVector4,
    iv: ScePspIVector4,
    f: [4]f32,
    i: [4]c_int,
};
pub const ScePspIMatrix2 = extern struct {
    x: ScePspIVector2,
    y: ScePspIVector2,
};
pub const ScePspFMatrix2 = extern struct {
    x: ScePspFVector2,
    y: ScePspFVector2,
};
pub const ScePspMatrix2 = extern union {
    fm: ScePspFMatrix2,
    im: ScePspIMatrix2,
    fv: [2]ScePspFVector2,
    iv: [2]ScePspIVector2,
    v: [2]ScePspVector2,
    f: [2][2]f32,
    i: [2][2]c_int,
};
pub const ScePspIMatrix3 = extern struct {
    x: ScePspIVector3,
    y: ScePspIVector3,
    z: ScePspIVector3,
};
pub const ScePspFMatrix3 = extern struct {
    x: ScePspFVector3,
    y: ScePspFVector3,
    z: ScePspFVector3,
};
pub const ScePspMatrix3 = extern union {
    fm: ScePspFMatrix3,
    im: ScePspIMatrix3,
    fv: [3]ScePspFVector3,
    iv: [3]ScePspIVector3,
    v: [3]ScePspVector3,
    f: [3][3]f32,
    i: [3][3]c_int,
};
pub const ScePspIMatrix4 = extern struct {
    x: ScePspIVector4,
    y: ScePspIVector4,
    z: ScePspIVector4,
    w: ScePspIVector4,
};

pub const ScePspIMatrix4Unaligned = extern struct {
    x: ScePspIVector4,
    y: ScePspIVector4,
    z: ScePspIVector4,
    w: ScePspIVector4,
};

pub const ScePspFMatrix4 = extern struct {
    x: ScePspFVector4,
    y: ScePspFVector4,
    z: ScePspFVector4,
    w: ScePspFVector4,
};
pub const ScePspFMatrix4Unaligned = extern struct {
    x: ScePspFVector4,
    y: ScePspFVector4,
    z: ScePspFVector4,
    w: ScePspFVector4,
};

pub const ScePspMatrix4 = extern union {
    fm: ScePspFMatrix4,
    im: ScePspIMatrix4,
    fv: [4]ScePspFVector4,
    iv: [4]ScePspIVector4,
    v: [4]ScePspVector4,
    f: [4][4]f32,
    i: [4][4]c_int,
};
pub const ScePspFQuaternion = extern struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,
};

pub const ScePspFQuaternionUnaligned = extern struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,
};

pub const ScePspFColor = extern struct {
    r: f32,
    g: f32,
    b: f32,
    a: f32,
};
pub const ScePspFColorUnaligned = extern struct {
    r: f32,
    g: f32,
    b: f32,
    a: f32,
};

pub const ScePspRGBA8888 = c_uint;
pub const ScePspRGBA4444 = c_ushort;
pub const ScePspRGBA5551 = c_ushort;
pub const ScePspRGB565 = c_ushort;
pub const ScePspUnion32 = extern union {
    ui: c_uint,
    i: c_int,
    us: [2]c_ushort,
    s: [2]c_short,
    uc: [4]u8,
    c: [4]u8,
    f: f32,
    rgba8888: ScePspRGBA8888,
    rgba4444: [2]ScePspRGBA4444,
    rgba5551: [2]ScePspRGBA5551,
    rgb565: [2]ScePspRGB565,
};

pub const ScePspUnion64 = extern union {
    ul: SceULong64,
    l: SceLong64,
    ui: [2]c_uint,
    i: [2]c_int,
    us: [4]c_ushort,
    s: [4]c_short,
    uc: [8]u8,
    c: [8]u8,
    f: [2]f32,
    sr: ScePspSRect,
    sv: ScePspSVector4,
    rgba8888: [2]ScePspRGBA8888,
    rgba4444: [4]ScePspRGBA4444,
    rgba5551: [4]ScePspRGBA5551,
    rgb565: [4]ScePspRGB565,
};

pub const ScePspUnion128 = extern union {
    ul: [2]SceULong64,
    l: [2]SceLong64,
    ui: [4]c_uint,
    i: [4]c_int,
    us: [8]c_ushort,
    s: [8]c_short,
    uc: [16]u8,
    c: [16]u8,
    f: [4]f32,
    fr: ScePspFRect,
    ir: ScePspIRect,
    fv: ScePspFVector4,
    iv: ScePspIVector4,
    fq: ScePspFQuaternion,
    fc: ScePspFColor,
    rgba8888: [4]ScePspRGBA8888,
    rgba4444: [8]ScePspRGBA4444,
    rgba5551: [8]ScePspRGBA5551,
    rgb565: [8]ScePspRGB565,
};

pub const SceUID = c_int;
pub const SceSize = c_uint;
pub const SceSSize = c_int;
pub const SceUChar = u8;
pub const SceUInt = c_uint;
pub const SceMode = c_int;
pub const SceOff = SceInt64;
pub const SceIores = SceInt64;

// See also: https://github.com/hrydgard/ppsspp/issues/17464
pub const PspCtrlButtons = packed struct(u32) {
    select: u1,
    l3: u1, // Available on devkits when connecting a dualshock controller
    r3: u1,
    start: u1,

    up: u1,
    right: u1,
    down: u1,
    left: u1,

    l_trigger: u1,
    r_trigger: u1,
    l2: u1, // Available on devkits when connecting a dualshock controller
    r2: u1,

    triangle: u1,
    circle: u1,
    cross: u1,
    square: u1,

    home: u1,
    hold: u1,
    wlan_up: u1,
    remote: u1,

    vol_up: u1,
    vol_down: u1,
    screen: u1,
    note: u1,

    disc: u1,
    memory_stick: u1,
    unknown_b26: u1,
    unknown_b27: u1,

    unknown_b28_31: u4,
};

pub const SceCtrlData = extern struct {
    timeStamp: c_uint,
    buttons: PspCtrlButtons,
    Lx: u8,
    Ly: u8,
    Rsrv: [6]u8,
};

pub const SceCtrlLatch = extern struct {
    uiMake: PspCtrlButtons,
    uiBreak: PspCtrlButtons,
    uiPress: PspCtrlButtons,
    uiRelease: PspCtrlButtons,
};

pub const PspGeContext = extern struct {
    context: [512]c_uint,
};

pub const SceGeStack = extern struct {
    stack: [8]c_uint,
};

pub const PspGeCallback = ?*const fn (c_int, ?*anyopaque) callconv(.c) void;
pub const PspGeCallbackData = extern struct {
    signal_func: PspGeCallback,
    signal_arg: ?*anyopaque,
    finish_func: PspGeCallback,
    finish_arg: ?*anyopaque,
};

pub const PspGeListArgs = extern struct {
    size: c_uint,
    context: [*c]PspGeContext,
    numStacks: u32,
    stacks: [*c]SceGeStack,
};

pub const PspGeBreakParam = extern struct {
    buf: [4]c_uint,
};

pub const PspGeStack = extern struct {
    stack: [8]c_uint,
};

pub const SceKernelLoadExecParam = extern struct {
    size: SceSize,
    args: SceSize,
    argp: ?*anyopaque,
    key: [*c]const u8,
};

pub const SceKernelIdListType = enum(c_int) {
    SCE_KERNEL_TMID_Thread = 1,
    SCE_KERNEL_TMID_Semaphore = 2,
    SCE_KERNEL_TMID_EventFlag = 3,
    SCE_KERNEL_TMID_Mbox = 4,
    SCE_KERNEL_TMID_Vpl = 5,
    SCE_KERNEL_TMID_Fpl = 6,
    SCE_KERNEL_TMID_Mpipe = 7,
    SCE_KERNEL_TMID_Callback = 8,
    SCE_KERNEL_TMID_ThreadEventHandler = 9,
    SCE_KERNEL_TMID_Alarm = 10,
    SCE_KERNEL_TMID_VTimer = 11,
    SCE_KERNEL_TMID_SleepThread = 64,
    SCE_KERNEL_TMID_DelayThread = 65,
    SCE_KERNEL_TMID_SuspendThread = 66,
    SCE_KERNEL_TMID_DormantThread = 67,
    _,
};

pub const SceKernelCallbackFunction = ?*const fn (c_int, c_int, ?*anyopaque) callconv(.c) c_int;
pub const SceKernelCallbackInfo = extern struct {
    size: SceSize,
    name: [32]u8,
    threadId: SceUID,
    callback: SceKernelCallbackFunction,
    common: ?*anyopaque,
    notifyCount: c_int,
    notifyArg: c_int,
};

pub const SceKernelVTimerOptParam = extern struct {
    size: SceSize,
};

pub const SceKernelFplOptParam = extern struct {
    size: SceSize,
};

pub const SceKernelVplOptParam = extern struct {
    size: SceSize,
};

pub const PspEventFlagWaitTypes = enum(c_int) {
    PSP_EVENT_WAITAND = 0,
    PSP_EVENT_WAITOR = 1,
    PSP_EVENT_WAITCLEAR = 32,
    _,
};

pub const SceKernelThreadEventHandler = ?*const fn (c_int, SceUID, ?*anyopaque) callconv(.c) c_int;
pub const SceKernelThreadEventHandlerInfo = extern struct {
    size: SceSize,
    name: [32]u8,
    threadId: SceUID,
    mask: c_int,
    handler: SceKernelThreadEventHandler,
    common: ?*anyopaque,
};

pub const SceKernelVTimerInfo = extern struct {
    size: SceSize,
    name: [32]u8,
    active: c_int,
    base: SceKernelSysClock,
    current: SceKernelSysClock,
    schedule: SceKernelSysClock,
    handler: SceKernelVTimerHandler,
    common: ?*anyopaque,
};

pub const SceKernelFplInfo = extern struct {
    size: SceSize,
    name: [32]u8,
    attr: SceUInt,
    blockSize: c_int,
    numBlocks: c_int,
    freeBlocks: c_int,
    numWaitThreads: c_int,
};

pub const SceKernelSysClock = extern struct {
    low: SceUInt32,
    hi: SceUInt32,
};

pub const SceKernelThreadEntry = ?*const fn (SceSize, ?*anyopaque) callconv(.c) c_int;
pub const SceKernelThreadOptParam = extern struct {
    size: SceSize,
    stackMpid: SceUID,
};
pub const SceKernelThreadInfo = extern struct {
    size: SceSize,
    name: [32]u8,
    attr: SceUInt,
    status: c_int,
    entry: SceKernelThreadEntry,
    stack: ?*anyopaque,
    stackSize: c_int,
    gpReg: ?*anyopaque,
    initPriority: c_int,
    currentPriority: c_int,
    waitType: c_int,
    waitId: SceUID,
    wakeupCount: c_int,
    exitStatus: c_int,
    runClocks: SceKernelSysClock,
    intrPreemptCount: SceUInt,
    threadPreemptCount: SceUInt,
    releaseCount: SceUInt,
};
pub const SceKernelThreadRunStatus = extern struct {
    size: SceSize,
    status: c_int,
    currentPriority: c_int,
    waitType: c_int,
    waitId: c_int,
    wakeupCount: c_int,
    runClocks: SceKernelSysClock,
    intrPreemptCount: SceUInt,
    threadPreemptCount: SceUInt,
    releaseCount: SceUInt,
};

pub const SceKernelSemaOptParam = extern struct {
    size: SceSize,
};
pub const SceKernelSemaInfo = extern struct {
    size: SceSize,
    name: [32]u8,
    attr: SceUInt,
    initCount: c_int,
    currentCount: c_int,
    maxCount: c_int,
    numWaitThreads: c_int,
};
pub const SceKernelEventFlagInfo = extern struct {
    size: SceSize,
    name: [32]u8,
    attr: SceUInt,
    initPattern: SceUInt,
    currentPattern: SceUInt,
    numWaitThreads: c_int,
};
pub const SceKernelEventFlagOptParam = extern struct {
    size: SceSize,
};
pub const SceKernelVTimerHandler = ?*const fn (SceUID, [*c]SceKernelSysClock, [*c]SceKernelSysClock, ?*anyopaque) callconv(.c) SceUInt;
pub const SceKernelVTimerHandlerWide = ?*const fn (SceUID, SceInt64, SceInt64, ?*anyopaque) callconv(.c) SceUInt;

pub const SceKernelMbxOptParam = extern struct {
    size: SceSize,
};
pub const SceKernelMbxInfo = extern struct {
    size: SceSize,
    name: [32]u8,
    attr: SceUInt,
    numWaitThreads: c_int,
    numMessages: c_int,
    firstMessage: ?*anyopaque,
};
pub const SceKernelAlarmHandler = ?*const fn (?*anyopaque) callconv(.c) SceUInt;
pub const SceKernelAlarmInfo = extern struct {
    size: SceSize,
    schedule: SceKernelSysClock,
    handler: SceKernelAlarmHandler,
    common: ?*anyopaque,
};
pub const SceKernelSystemStatus = extern struct {
    size: SceSize,
    status: SceUInt,
    idleClocks: SceKernelSysClock,
    comesOutOfIdleCount: SceUInt,
    threadSwitchCount: SceUInt,
    vfpuSwitchCount: SceUInt,
};
pub const SceKernelMppInfo = extern struct {
    size: SceSize,
    name: [32]u8,
    attr: SceUInt,
    bufSize: c_int,
    freeSize: c_int,
    numSendWaitThreads: c_int,
    numReceiveWaitThreads: c_int,
};
pub const SceKernelVplInfo = extern struct {
    size: SceSize,
    name: [32]u8,
    attr: SceUInt,
    poolSize: c_int,
    freeSize: c_int,
    numWaitThreads: c_int,
};

pub const SceKernelLMOption = extern struct {
    size: SceSize,
    mpidtext: SceUID,
    mpiddata: SceUID,
    flags: c_uint,
    position: u8,
    access: u8,
    creserved: [2]u8,
};

pub const SceKernelSMOption = extern struct {
    size: SceSize,
    mpidstack: SceUID,
    stacksize: SceSize,
    priority: c_int,
    attribute: c_uint,
};

pub const SceKernelModuleInfo = extern struct {
    size: SceSize,
    nsegment: u8,
    reserved: [3]u8,
    segmentaddr: [4]c_int,
    segmentsize: [4]c_int,
    entry_addr: c_uint,
    gp_value: c_uint,
    text_addr: c_uint,
    text_size: c_uint,
    data_size: c_uint,
    bss_size: c_uint,
    attribute: c_ushort,
    version: [2]u8,
    name: [28]u8,
};

pub const time_t = u32;
pub const clock_t = u32;

pub const ScePspDateTime = extern struct {
    year: u16,
    month: u16,
    day: u16,
    hour: u16,
    minutes: u16,
    seconds: u16,
    microseconds: u32,
};

pub const SceKernelUtilsMt19937Context = extern struct {
    count: c_uint,
    state: [624]c_uint,
};

pub const SceKernelUtilsMd5Context = extern struct {
    h: [4]c_uint,
    pad: c_uint,
    usRemains: SceUShort16,
    usComputed: SceUShort16,
    ullTotalLen: SceULong64,
    buf: [64]u8,
};

pub const SceKernelUtilsSha1Context = extern struct {
    h: [5]c_uint,
    usRemains: SceUShort16,
    usComputed: SceUShort16,
    ullTotalLen: SceULong64,
    buf: [64]u8,
};

pub const pdpStatStruct  = extern struct {
    next: [*c]pdpStatStruct,
    pdpId: c_int,
    mac: [6]u8,
    port: c_ushort,
    rcvdData: c_uint,
};

pub const in_addr = extern struct {
    s_addr: u32,
};

pub const SceNetMallocStat  = extern struct {
    pool: c_int,
    maximum: c_int,
    free: c_int,
};
