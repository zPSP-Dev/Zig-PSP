const c = @import("../c/modules.zig");

pub const time_t = c.types.time_t;
pub const ScePspDateTime = c.types.ScePspDateTime;

pub const pspTime = ScePspDateTime;
pub const pspRtcCheckValidErrors = enum(c_int) {
    PSP_TIME_INVALID_YEAR = -1,
    PSP_TIME_INVALID_MONTH = -2,
    PSP_TIME_INVALID_DAY = -3,
    PSP_TIME_INVALID_HOUR = -4,
    PSP_TIME_INVALID_MINUTES = -5,
    PSP_TIME_INVALID_SECONDS = -6,
    PSP_TIME_INVALID_MICROSECONDS = -7,
    _,
};

pub extern fn sceRtcGetTickResolution() u32;
pub extern fn sceRtcGetCurrentTick(tick: *u64) c_int;
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
