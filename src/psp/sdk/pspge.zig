pub const PspGeContext = extern struct {
    context: [512]c_uint,
};

pub const SceGeStack = extern struct {
    stack: [8]c_uint,
};

pub const PspGeCallback = ?*const fn (c_int, ?*anyopaque) callconv(.C) void;
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

pub const PspGeMatrixTypes = enum(c_int) {
    Bone0 = 0,
    Bone1 = 1,
    Bone2 = 2,
    Bone3 = 3,
    Bone4 = 4,
    Bone5 = 5,
    Bone6 = 6,
    Bone7 = 7,
    World = 8,
    View = 9,
    Projection = 10,
    Texgen = 11,
};

pub const PspGeStack = extern struct {
    stack: [8]c_uint,
};

pub const PspGeListState = enum(c_int) {
    Done = 0,
    Queued = 1,
    DrawingDone = 2,
    StallReached = 3,
    CancelDone = 4,
};
