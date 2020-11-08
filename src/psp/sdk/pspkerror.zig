pub const PspKernelErrorCodes = extern enum(c_int) {
    Ok = 0,
    Error = 2147614721,
    Notimp = 2147614722,
    IllegalExpcode = 2147614770,
    ExpHandlerNoUse = 2147614771,
    ExpHandlerUsed = 2147614772,
    SycallTableNoUsed = 2147614773,
    SycallTableUsed = 2147614774,
    IllegalSyscalltable = 2147614775,
    IllegalPrimarySyscallNumber = 2147614776,
    PrimarySyscallNumberInUse = 2147614777,
    IllegalContext = 2147614820,
    IllegalIntrCode = 2147614821,
    Cpudi = 2147614822,
    FoundHandler = 2147614823,
    NotFoundHandler = 2147614824,
    IllegalIntrLevel = 2147614825,
    IllegalAddress = 2147614826,
    IllegalIntrParam = 2147614827,
    IllegalStackAddress = 2147614828,
    AlreadyStackSet = 2147614829,
    NoTimer = 2147614870,
    IllegalTimerid = 2147614871,
    IllegalSource = 2147614872,
    IllegalPrescale = 2147614873,
    TimeBusy = 2147614874,
    TimerNotSetup = 2147614875,
    TimerNotInUse = 2147614876,
    UnitUsed = 2147614880,
    UnitNoUse = 2147614881,
    NoRomDir = 2147614882,
    IdTypeXxist = 2147614920,
    IdTypeNotExist = 2147614921,
    IdTypeNotEmpty = 2147614922,
    UnknownUid = 2147614923,
    UnmatchUidType = 2147614924,
    IdNotExist = 2147614925,
    NotFoundUidFunc = 2147614926,
    UidAlreadyHolder = 2147614927,
    UidNotHolder = 2147614928,
    IllegalPerm = 2147614929,
    IllegalArgument = 2147614930,
    IllegalAddr = 2147614931,
    OutOfRange = 2147614932,
    MemRangeOverlap = 2147614933,
    IllegalPartition = 2147614934,
    PartitionInUse = 2147614935,
    IllegalMemblockType = 2147614936,
    MemblockAllocFailed = 2147614937,
    MemblockResizeLocked = 2147614938,
    MemblockResizeFailed = 2147614939,
    HeapblockAllocFailed = 2147614940,
    HeapAllocFailed = 2147614941,
    IllegalChunkId = 2147614942,
    Nochunk = 2147614943,
    NoFreechunk = 2147614944,
    Linkerr = 2147615020,
    IllegalObject = 2147615021,
    UnknownModule = 2147615022,
    Nofile = 2147615023,
    Fileerr = 2147615024,
    Meminuse = 2147615025,
    PartitionMismatch = 2147615026,
    AlreadyStarted = 2147615027,
    NotStarted = 2147615028,
    AlreadyStopped = 2147615029,
    CanNotStop = 2147615030,
    NotStopped = 2147615031,
    NotRemovable = 2147615032,
    ExclusiveLoad = 2147615033,
    LibraryNotYetLinked = 2147615034,
    LibraryFound = 2147615035,
    LibraryNotFound = 2147615036,
    IllegalLibrary = 2147615037,
    LibraryInUse = 2147615038,
    AlreadyStopping = 2147615039,
    IllegalOffset = 2147615040,
    IllegalPosition = 2147615041,
    IllegalAccess = 2147615042,
    ModuleMgrBusy = 2147615043,
    IllegalFlag = 2147615044,
    CannotGetModulelist = 2147615045,
    ProhibitLoadmoduleDevice = 2147615046,
    ProhibitLoadexecDevice = 2147615047,
    UnsupportedPrxType = 2147615048,
    IllegalPermCall = 2147615049,
    CannotGetModuleInformation = 2147615050,
    IllegalLoadexecBuffer = 2147615051,
    IllegalLoadexecFilename = 2147615052,
    NoExitCallback = 2147615053,
    NoMemory = 2147615120,
    IllegalAttr = 2147615121,
    IllegalEntry = 2147615122,
    IllegalPriority = 2147615123,
    IllegalStackSize = 2147615124,
    IllegalMode = 2147615125,
    IllegalMask = 2147615126,
    IllegalThid = 2147615127,
    UnknownThid = 2147615128,
    UnknownSemid = 2147615129,
    UnknownEvfid = 2147615130,
    UnknownMbxid = 2147615131,
    UnknownVplid = 2147615132,
    UnknownFplid = 2147615133,
    UnknownMppid = 2147615134,
    UnknownAlmid = 2147615135,
    UnknownTeid = 2147615136,
    UnknownCbid = 2147615137,
    Dormant = 2147615138,
    Suspend = 2147615139,
    NotDormant = 2147615140,
    NotSuspend = 2147615141,
    NotWait = 2147615142,
    CanNotWait = 2147615143,
    WaitTimeout = 2147615144,
    WaitCancel = 2147615145,
    ReleaseWait = 2147615146,
    NotifyCallback = 2147615147,
    ThreadTerminated = 2147615148,
    SemaZero = 2147615149,
    SemaOvf = 2147615150,
    EvfCond = 2147615151,
    EvfMulti = 2147615152,
    EvfIlpat = 2147615153,
    MboxNomsg = 2147615154,
    MppFull = 2147615155,
    MppEmpty = 2147615156,
    WaitDelete = 2147615157,
    IllegalMemblock = 2147615158,
    IllegalMemsize = 2147615159,
    IllegalSpadaddr = 2147615160,
    SpadInUse = 2147615161,
    SpadNotInUse = 2147615162,
    IllegalType = 2147615163,
    IllegalSize = 2147615164,
    IllegalCount = 2147615165,
    UnknownVtid = 2147615166,
    IllegalVtid = 2147615167,
    IllegalKtlsid = 2147615168,
    KtlsFull = 2147615169,
    KtlsBusy = 2147615170,
    PmInvalidPriority = 2147615320,
    PmInvalidDevname = 2147615321,
    PmUnknownDevname = 2147615322,
    PmPminfoRegistered = 2147615323,
    PmPminfoUnregistered = 2147615324,
    PmInvalidMajorState = 2147615325,
    PmInvalidRequest = 2147615326,
    PmUnknownRequest = 2147615327,
    PmInvalidUnit = 2147615328,
    PmCannotCancel = 2147615329,
    PmInvalidPminfo = 2147615330,
    PmInvalidArgument = 2147615331,
    PmAlreadyTargetPwrstate = 2147615332,
    PmChangePwrstateFailed = 2147615333,
    PmCannotChangeDevpwrState = 2147615334,
    PmNoSupportDevpwrState = 2147615335,
    DmacRequestFailed = 2147615420,
    DmacRequestDenied = 2147615421,
    DmacOpQueued = 2147615422,
    DmacOpNotQueued = 2147615423,
    DmacOpRunning = 2147615424,
    DmacOpNotAssigned = 2147615425,
    DmacOpTimeout = 2147615426,
    DmacOpFreed = 2147615427,
    DmacOpUsed = 2147615428,
    DmacOpEmpty = 2147615429,
    DmacOpAborted = 2147615430,
    DmacOpError = 2147615431,
    DmacChannelReserved = 2147615432,
    DmacChannelExcluded = 2147615433,
    DmacPrivilegeAddress = 2147615434,
    DmacNotEnoughspace = 2147615435,
    DmacChannelNotAssigned = 2147615436,
    DmacChildOperation = 2147615437,
    DmacTooMuchSize = 2147615438,
    DmacInvalidArgument = 2147615439,
    Mfile = 2147615520,
    Nodev = 2147615521,
    Xdev = 2147615522,
    Badf = 2147615523,
    Inval = 2147615524,
    Unsup = 2147615525,
    AliasUsed = 2147615526,
    CannotMount = 2147615527,
    DriverDeleted = 2147615528,
    AsyncBusy = 2147615529,
    Noasync = 2147615530,
    Regdev = 2147615531,
    Nocwd = 2147615532,
    Nametoolong = 2147615533,
    Nxio = 2147615720,
    Io = 2147615721,
    Nomem = 2147615722,
    StdioNotOpened = 2147615723,
    CacheAlignment = 2147615820,
    Errormax = 2147615821,
};
