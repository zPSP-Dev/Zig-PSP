usingnamespace @import("psptypes.zig");

pub const time_t = u32;
const struct_unnamed_5 = extern struct {
    year: u16,
    month: u16,
    day: u16,
    hour: u16,
    minutes: u16,
    seconds: u16,
    microseconds: u32,
};
pub const pspTime = struct_unnamed_5;


pub const enum_pspRtcCheckValidErrors = extern enum(c_int) {
    PSP_TIME_INVALID_YEAR = -1,
    PSP_TIME_INVALID_MONTH = -2,
    PSP_TIME_INVALID_DAY = -3,
    PSP_TIME_INVALID_HOUR = -4,
    PSP_TIME_INVALID_MINUTES = -5,
    PSP_TIME_INVALID_SECONDS = -6,
    PSP_TIME_INVALID_MICROSECONDS = -7,
    _,
};
pub extern fn sceRtcGetTickResolution(...) u32;
pub extern fn sceRtcGetCurrentTick(tick: [*c]u64) c_int;
pub extern fn sceRtcGetCurrentClock(time: [*c]pspTime, tz: c_int) c_int;
pub extern fn sceRtcGetCurrentClockLocalTime(time: [*c]pspTime) c_int;
pub extern fn sceRtcConvertUtcToLocalTime(tickUTC: [*c]const u64, tickLocal: [*c]u64) c_int;
pub extern fn sceRtcConvertLocalTimeToUTC(tickLocal: [*c]const u64, tickUTC: [*c]u64) c_int;
pub extern fn sceRtcIsLeapYear(year: c_int) c_int;
pub extern fn sceRtcGetDaysInMonth(year: c_int, month: c_int) c_int;
pub extern fn sceRtcGetDayOfWeek(year: c_int, month: c_int, day: c_int) c_int;
pub extern fn sceRtcCheckValid(date: [*c]const pspTime) c_int;
pub extern fn sceRtcSetTick(date: [*c]pspTime, tick: [*c]const u64) c_int;
pub extern fn sceRtcGetTick(date: [*c]const pspTime, tick: [*c]u64) c_int;
pub extern fn sceRtcCompareTick(tick1: [*c]const u64, tick2: [*c]const u64) c_int;
pub extern fn sceRtcTickAddTicks(destTick: [*c]u64, srcTick: [*c]const u64, numTicks: u64) c_int;
pub extern fn sceRtcTickAddMicroseconds(destTick: [*c]u64, srcTick: [*c]const u64, numMS: u64) c_int;
pub extern fn sceRtcTickAddSeconds(destTick: [*c]u64, srcTick: [*c]const u64, numSecs: u64) c_int;
pub extern fn sceRtcTickAddMinutes(destTick: [*c]u64, srcTick: [*c]const u64, numMins: u64) c_int;
pub extern fn sceRtcTickAddHours(destTick: [*c]u64, srcTick: [*c]const u64, numHours: c_int) c_int;
pub extern fn sceRtcTickAddDays(destTick: [*c]u64, srcTick: [*c]const u64, numDays: c_int) c_int;
pub extern fn sceRtcTickAddWeeks(destTick: [*c]u64, srcTick: [*c]const u64, numWeeks: c_int) c_int;
pub extern fn sceRtcTickAddMonths(destTick: [*c]u64, srcTick: [*c]const u64, numMonths: c_int) c_int;
pub extern fn sceRtcTickAddYears(destTick: [*c]u64, srcTick: [*c]const u64, numYears: c_int) c_int;
pub extern fn sceRtcSetTime_t(date: [*c]pspTime, time: time_t) c_int;
pub extern fn sceRtcGetTime_t(date: [*c]const pspTime, time: [*c]time_t) c_int;
pub extern fn sceRtcSetDosTime(date: [*c]pspTime, dosTime: u32) c_int;
pub extern fn sceRtcGetDosTime(date: [*c]pspTime, dosTime: u32) c_int;
pub extern fn sceRtcSetWin32FileTime(date: [*c]pspTime, win32Time: [*c]u64) c_int;
pub extern fn sceRtcGetWin32FileTime(date: [*c]pspTime, win32Time: [*c]u64) c_int;
pub extern fn sceRtcParseDateTime(destTick: [*c]u64, dateString: [*c]const u8) c_int;
pub extern fn sceRtcFormatRFC2822(pszDateTime: [*c]u8, pUtc: [*c]const u64, iTimeZoneMinutes: c_int) c_int;
pub extern fn sceRtcFormatRFC2822LocalTime(pszDateTime: [*c]u8, pUtc: [*c]const u64) c_int;
pub extern fn sceRtcFormatRFC3339(pszDateTime: [*c]u8, pUtc: [*c]const u64, iTimeZoneMinutes: c_int) c_int;
pub extern fn sceRtcFormatRFC3339LocalTime(pszDateTime: [*c]u8, pUtc: [*c]const u64) c_int;
pub extern fn sceRtcParseRFC3339(pUtc: [*c]u64, pszDateTime: [*c]const u8) c_int;

pub const pspRtcCheckValidErrors = enum_pspRtcCheckValidErrors;

const macro = @import("pspmacros.zig");


comptime{
    asm(macro.import_module_start("sceRtc", "0x40010000", "40"));
    asm(macro.import_function("sceRtc", "0xC41C2853", "sceRtcGetTickResolution"));
    asm(macro.import_function("sceRtc", "0x3F7AD767", "sceRtcGetCurrentTick"));
    asm(macro.import_function("sceRtc", "0x029CA3B3", "sceRtc_029CA3B3"));
    asm(macro.import_function("sceRtc", "0x4CFA57B0", "sceRtcGetCurrentClock"));
    asm(macro.import_function("sceRtc", "0xE7C27D1B", "sceRtcGetCurrentClockLocalTime"));
    asm(macro.import_function("sceRtc", "0x34885E0D", "sceRtcConvertUtcToLocalTime"));
    asm(macro.import_function("sceRtc", "0x779242A2", "sceRtcConvertLocalTimeToUTC"));
    asm(macro.import_function("sceRtc", "0x42307A17", "sceRtcIsLeapYear"));
    asm(macro.import_function("sceRtc", "0x05EF322C", "sceRtcGetDaysInMonth"));
    asm(macro.import_function("sceRtc", "0x57726BC1", "sceRtcGetDayOfWeek"));
    asm(macro.import_function("sceRtc", "0x4B1B5E82", "sceRtcCheckValid"));
    asm(macro.import_function("sceRtc", "0x3A807CC8", "sceRtcSetTime_t"));
    asm(macro.import_function("sceRtc", "0x27C4594C", "sceRtcGetTime_t"));
    asm(macro.import_function("sceRtc", "0xF006F264", "sceRtcSetDosTime"));
    asm(macro.import_function("sceRtc", "0x36075567", "sceRtcGetDosTime"));
    asm(macro.import_function("sceRtc", "0x7ACE4C04", "sceRtcSetWin32FileTime"));
    asm(macro.import_function("sceRtc", "0xCF561893", "sceRtcGetWin32FileTime"));
    asm(macro.import_function("sceRtc", "0x7ED29E40", "sceRtcSetTick"));
    asm(macro.import_function("sceRtc", "0x6FF40ACC", "sceRtcGetTick"));
    asm(macro.import_function("sceRtc", "0x9ED0AE87", "sceRtcCompareTick"));
    asm(macro.import_function("sceRtc", "0x44F45E05", "sceRtcTickAddTicks"));
    asm(macro.import_function("sceRtc", "0x26D25A5D", "sceRtcTickAddMicroseconds"));
    asm(macro.import_function("sceRtc", "0xF2A4AFE5", "sceRtcTickAddSeconds"));
    asm(macro.import_function("sceRtc", "0xE6605BCA", "sceRtcTickAddMinutes"));
    asm(macro.import_function("sceRtc", "0x26D7A24A", "sceRtcTickAddHours"));
    asm(macro.import_function("sceRtc", "0xE51B4B7A", "sceRtcTickAddDays"));
    asm(macro.import_function("sceRtc", "0xCF3A2CA8", "sceRtcTickAddWeeks"));
    asm(macro.import_function("sceRtc", "0xDBF74F1B", "sceRtcTickAddMonths"));
    asm(macro.import_function("sceRtc", "0x42842C77", "sceRtcTickAddYears"));
    asm(macro.import_function("sceRtc", "0xC663B3B9", "sceRtcFormatRFC2822"));
    asm(macro.import_function("sceRtc", "0x7DE6711B", "sceRtcFormatRFC2822LocalTime"));
    asm(macro.import_function("sceRtc", "0x0498FB3C", "sceRtcFormatRFC3339"));
    asm(macro.import_function("sceRtc", "0x27F98543", "sceRtcFormatRFC3339LocalTime"));
    asm(macro.import_function("sceRtc", "0xDFBC5F16", "sceRtcParseDateTime"));
    asm(macro.import_function("sceRtc", "0x28E1E988", "sceRtcParseRFC3339"));
    asm(macro.import_function("sceRtc", "0x011F03C1", "sceRtcGetAccumulativeTime"));
    asm(macro.import_function("sceRtc", "0x1909C99B", "sceRtcSetTime64_t"));
    asm(macro.import_function("sceRtc", "0x203CEB0D", "sceRtcGetLastReincarnatedTime"));
    asm(macro.import_function("sceRtc", "0x62685E98", "sceRtcGetLastAdjustedTime"));
    asm(macro.import_function("sceRtc", "0xE1C93E47", "sceRtcGetTime64_t"));
}