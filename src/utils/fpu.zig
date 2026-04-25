// Allegrex FPU control (FCR31) helpers.
//
// PSP defaults enable FPU exception traps that desktop IEEE-754 hardware does
// not. Operations like 0/0, x/0, or overflow that produce NaN/Inf on x86_64
// will instead fault on PSP unless the enable bits in FCR31 are cleared. The
// thread that runs `main` (spawned by module.zig) clears these bits at entry;
// user-spawned threads start with PSP defaults and can call `setIEEE754`
// themselves if they want desktop-like semantics.

pub const RoundMode = enum(u2) {
    nearest = 0,
    zero = 1,
    pos_inf = 2,
    neg_inf = 3,
};

// Bit-exact mirror of MIPS Allegrex FCR31. Field order matches ascending
// bit position (Zig packed structs lay out the first field at bit 0).
pub const FCR31 = packed struct(u32) {
    rm: RoundMode = .nearest,

    flag_inexact: bool = false,
    flag_underflow: bool = false,
    flag_overflow: bool = false,
    flag_div_zero: bool = false,
    flag_invalid: bool = false,

    enable_inexact: bool = false,
    enable_underflow: bool = false,
    enable_overflow: bool = false,
    enable_div_zero: bool = false,
    enable_invalid: bool = false,

    cause_inexact: bool = false,
    cause_underflow: bool = false,
    cause_overflow: bool = false,
    cause_div_zero: bool = false,
    cause_invalid: bool = false,
    cause_unimplemented: bool = false,

    _reserved_18_22: u5 = 0,

    cc0: bool = false,
    fs: bool = false,
    cc1_7: u7 = 0,
};

pub inline fn getFCR31Raw() u32 {
    return asm volatile ("cfc1 %[ret], $31"
        : [ret] "=r" (-> u32),
    );
}

pub inline fn setFCR31Raw(value: u32) void {
    asm volatile ("ctc1 %[val], $31"
        :
        : [val] "r" (value),
    );
}

pub inline fn getFCR31() FCR31 {
    return @bitCast(getFCR31Raw());
}

pub inline fn setFCR31(fcr: FCR31) void {
    setFCR31Raw(@bitCast(fcr));
}

pub fn getRoundMode() RoundMode {
    return getFCR31().rm;
}

pub fn setRoundMode(mode: RoundMode) void {
    var fcr = getFCR31();
    fcr.rm = mode;
    setFCR31(fcr);
}

// Disable all FPU exception enables, clear flush-to-zero, set round-to-nearest.
// After this, 0/0 -> NaN, x/0 -> +/-Inf, overflow -> Inf, denormals are kept
// (no FTZ) — i.e. desktop IEEE-754 default behavior.
pub fn setIEEE754() void {
    setFCR31(.{});
}

// Restore the FPU enables the PSP normally boots with: trap on invalid,
// divide-by-zero, and overflow. Provided for users porting code that depends
// on these traps; not used by module init.
pub fn setPspDefault() void {
    setFCR31(.{
        .enable_invalid = true,
        .enable_div_zero = true,
        .enable_overflow = true,
    });
}
