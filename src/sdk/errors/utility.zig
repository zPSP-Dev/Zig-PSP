// Utility facility error codes (sceUtility, savedata, modules).
// Sourced from PPSSPP ErrorCodes.h.

const kernel = @import("kernel.zig");

pub const KernelError = kernel.KernelError;

pub const FacilityError = error{
    // sceUtility (0x80110001-0x80110502)
    InvalidStatus,
    InvalidParamSize,
    WrongType,
    StringTooLong,
    InvalidSystemParamId,
    InvalidAdhocChannel,
    MsgdialogBadoption,
    MsgdialogErrorcodeinvalid,

    // Savedata (0x80110300-0x801103Cb)
    SavedataErrorType,
    SavedataLoadNoMs,
    SavedataLoadEjectMs,
    SavedataLoadAccessError,
    SavedataLoadDataBroken,
    SavedataLoadNoData,
    SavedataLoadParam,
    SavedataLoadFileNotFound,
    SavedataLoadInternal,
    SavedataRwNoMemstick,
    SavedataRwMemstickFull,
    SavedataRwDataBroken,
    SavedataRwNoData,
    SavedataRwBadParams,
    SavedataRwFileNotFound,
    SavedataRwBadStatus,
    SavedataSaveNoMs,
    SavedataSaveEjectMs,
    SavedataSaveMsNospace,
    SavedataSaveMsProtected,
    SavedataSaveAccessError,
    SavedataSaveParam,
    SavedataSaveNoUmd,
    SavedataSaveWrongUmd,
    SavedataSaveInternal,
    SavedataDeleteNoMs,
    SavedataDeleteEjectMs,
    SavedataDeleteMsProtected,
    SavedataDeleteAccessError,
    SavedataDeleteNoData,
    SavedataDeleteParam,
    SavedataDeleteInternal,
    SavedataSizesNoMs,
    SavedataSizesEjectMs,
    SavedataSizesAccessError,
    SavedataSizesNoData,
    SavedataSizesParam,
    SavedataSizesNoUmd,
    SavedataSizesWrongUmd,
    SavedataSizesInternal,

    // NetParam (0x80110601-0x80110604)
    NetparamBadNetconf,
    NetparamBadParam,

    // AV Module (0x80110F01-0x80110F03)
    AvModuleBadId,
    AvModuleAlreadyLoaded,
    AvModuleNotLoaded,

    // Module (0x80111101-0x80111103)
    ModuleBadId,
    ModuleAlreadyLoaded,
    ModuleNotLoaded,

    // Gamedata (0x80111901-0x80111908)
    GamedataMemstickRemoved,
    GamedataMemstickWriteProtected,
    GamedataInvalidMode,
};

pub const Error = FacilityError || KernelError || error{Unexpected};

pub fn fromCode(code: u32) ?FacilityError {
    return switch (code) {
        // sceUtility
        0x80110001 => error.InvalidStatus,
        0x80110004 => error.InvalidParamSize,
        0x80110005 => error.WrongType,
        0x80110102 => error.StringTooLong,
        0x80110103 => error.InvalidSystemParamId,
        0x80110104 => error.InvalidAdhocChannel,
        0x80110501 => error.MsgdialogBadoption,
        0x80110502 => error.MsgdialogErrorcodeinvalid,

        // Savedata
        0x80110300 => error.SavedataErrorType,
        0x80110301 => error.SavedataLoadNoMs,
        0x80110302 => error.SavedataLoadEjectMs,
        0x80110305 => error.SavedataLoadAccessError,
        0x80110306 => error.SavedataLoadDataBroken,
        0x80110307 => error.SavedataLoadNoData,
        0x80110308 => error.SavedataLoadParam,
        0x80110309 => error.SavedataLoadFileNotFound,
        0x8011030b => error.SavedataLoadInternal,
        0x80110321 => error.SavedataRwNoMemstick,
        0x80110323 => error.SavedataRwMemstickFull,
        0x80110326 => error.SavedataRwDataBroken,
        0x80110327 => error.SavedataRwNoData,
        0x80110328 => error.SavedataRwBadParams,
        0x80110329 => error.SavedataRwFileNotFound,
        0x8011032c => error.SavedataRwBadStatus,
        0x80110381 => error.SavedataSaveNoMs,
        0x80110382 => error.SavedataSaveEjectMs,
        0x80110383 => error.SavedataSaveMsNospace,
        0x80110384 => error.SavedataSaveMsProtected,
        0x80110385 => error.SavedataSaveAccessError,
        0x80110388 => error.SavedataSaveParam,
        0x80110389 => error.SavedataSaveNoUmd,
        0x8011038a => error.SavedataSaveWrongUmd,
        0x8011038b => error.SavedataSaveInternal,
        0x80110341 => error.SavedataDeleteNoMs,
        0x80110342 => error.SavedataDeleteEjectMs,
        0x80110344 => error.SavedataDeleteMsProtected,
        0x80110345 => error.SavedataDeleteAccessError,
        0x80110347 => error.SavedataDeleteNoData,
        0x80110348 => error.SavedataDeleteParam,
        0x8011034b => error.SavedataDeleteInternal,
        0x801103c1 => error.SavedataSizesNoMs,
        0x801103c2 => error.SavedataSizesEjectMs,
        0x801103c5 => error.SavedataSizesAccessError,
        0x801103c7 => error.SavedataSizesNoData,
        0x801103c8 => error.SavedataSizesParam,
        0x801103c9 => error.SavedataSizesNoUmd,
        0x801103ca => error.SavedataSizesWrongUmd,
        0x801103cb => error.SavedataSizesInternal,

        // NetParam
        0x80110601 => error.NetparamBadNetconf,
        0x80110604 => error.NetparamBadParam,

        // AV Module
        0x80110f01 => error.AvModuleBadId,
        0x80110f02 => error.AvModuleAlreadyLoaded,
        0x80110f03 => error.AvModuleNotLoaded,

        // Module
        0x80111101 => error.ModuleBadId,
        0x80111102 => error.ModuleAlreadyLoaded,
        0x80111103 => error.ModuleNotLoaded,

        // Gamedata
        0x80111901 => error.GamedataMemstickRemoved,
        0x80111903 => error.GamedataMemstickWriteProtected,
        0x80111908 => error.GamedataInvalidMode,

        else => null,
    };
}

pub fn translate(code: u32) Error {
    if (fromCode(code)) |e| return e;
    if (kernel.fromCode(code)) |e| return e;
    return error.Unexpected;
}

pub fn check(ret: c_int) Error!void {
    if (ret < 0) {
        @branchHint(.unlikely);
        return translate(@bitCast(ret));
    }
}

pub fn checkPositive(comptime T: type, ret: c_int) Error!T {
    if (ret < 0) {
        @branchHint(.unlikely);
        return translate(@bitCast(ret));
    }
    const i: i32 = @intCast(ret);
    return @bitCast(i);
}
