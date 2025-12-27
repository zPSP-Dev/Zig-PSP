// THIS FILE IS AUTO-GENERATED
const types = @import("../types.zig");
const macro = @import("../macro.zig");

/// Get the resolution of the tick counter
/// Returns # of ticks per second
pub extern fn sceRtcGetTickResolution() callconv(.c) u32;

/// Get current tick count
/// `tick` - pointer to u64 to receive tick count
/// Returns 0 on success, < 0 on error
pub extern fn sceRtcGetCurrentTick(tick: [*c]u64) callconv(.c) c_int;

pub extern fn sceRtc_029CA3B3() callconv(.c) void;

/// Get current tick count, adjusted for local time zone
/// `time` - pointer to ScePspDateTime struct to receive time
/// `tz` - time zone to adjust to (minutes from UTC)
/// Returns 0 on success, < 0 on error
pub extern fn sceRtcGetCurrentClock(time: [*c]c_int, tz: c_int) callconv(.c) c_int;

/// Get current local time into a ScePspDateTime struct
/// `time` - pointer to ScePspDateTime struct to receive time
/// Returns 0 on success, < 0 on error
pub extern fn sceRtcGetCurrentClockLocalTime(time: [*c]c_int) callconv(.c) c_int;

/// Convert a UTC-based tickcount into a local time tick count
/// `tickUTC` - pointer to u64 tick in UTC time
/// `tickLocal` - pointer to u64 to receive tick in local time
/// Returns 0 on success, < 0 on error
pub extern fn sceRtcConvertUtcToLocalTime(tickUTC: [*c]const u64, tickLocal: [*c]u64) callconv(.c) c_int;

/// Convert a local time based tickcount into a UTC-based tick count
/// `tickLocal` - pointer to u64 tick in local time
/// `tickUTC` - pointer to u64 to receive tick in UTC based time
/// Returns 0 on success, < 0 on error
pub extern fn sceRtcConvertLocalTimeToUTC(tickLocal: [*c]const u64, tickUTC: [*c]u64) callconv(.c) c_int;

/// Check if a year is a leap year
/// `year` - year to check if is a leap year
/// Returns 1 on leapyear, 0 if not
pub extern fn sceRtcIsLeapYear(year: c_int) callconv(.c) c_int;

/// Get number of days in a specific month
/// `year` - year in which to check (accounts for leap year)
/// `month` - month to get number of days for
/// Returns # of days in month, <0 on error (?)
pub extern fn sceRtcGetDaysInMonth(year: c_int, month: c_int) callconv(.c) c_int;

/// Get day of the week for a date
/// `year` - year in which to check (accounts for leap year)
/// `month` - month that day is in
/// `day` - day to get day of week for
/// Returns day of week with 0 representing Monday
pub extern fn sceRtcGetDayOfWeek(year: c_int, month: c_int, day: c_int) callconv(.c) c_int;

/// Validate pspDate component ranges
/// `date` - pointer to pspDate struct to be checked
/// Returns 0 on success, one of ::pspRtcCheckValidErrors on error
pub extern fn sceRtcCheckValid(date: [*c]const c_int) callconv(.c) c_int;

pub extern fn sceRtcSetTime_t(date: [*c]c_int, time: c_int) callconv(.c) c_int;

pub extern fn sceRtcGetTime_t(date: [*c]const c_int, time: [*c]c_int) callconv(.c) c_int;

pub extern fn sceRtcSetDosTime(date: [*c]c_int, dosTime: u32) callconv(.c) c_int;

pub extern fn sceRtcGetDosTime(date: [*c]c_int, dosTime: u32) callconv(.c) c_int;

pub extern fn sceRtcSetWin32FileTime(date: [*c]c_int, win32Time: [*c]u64) callconv(.c) c_int;

pub extern fn sceRtcGetWin32FileTime(date: [*c]c_int, win32Time: [*c]u64) callconv(.c) c_int;

/// Set a ScePspDateTime struct based on ticks
/// `date` - pointer to ScePspDateTime struct to set
/// `tick` - pointer to ticks to convert
/// Returns 0 on success, < 0 on error
pub extern fn sceRtcSetTick(date: [*c]c_int, tick: [*c]const u64) callconv(.c) c_int;

/// Set ticks based on a ScePspDateTime struct
/// `date` - pointer to ScePspDateTime to convert
/// `tick` - pointer to tick to set
/// Returns 0 on success, < 0 on error
/// Get the resolution of the tick counter
/// Returns # of ticks per second
pub extern fn sceRtcGetTick(date: [*c]const c_int, tick: [*c]u64) callconv(.c) c_int;

/// Compare two ticks
/// `tick1` - pointer to first tick
/// `tick2` - poiinter to second tick
/// Returns 0 on equal, <0 when tick1 < tick2, >0 when tick1 > tick2
pub extern fn sceRtcCompareTick(tick1: [*c]const u64, tick2: [*c]const u64) callconv(.c) c_int;

/// Add two ticks
/// `destTick` - pointer to tick to hold result
/// `srcTick` - pointer to source tick
/// `numTicks` - number of ticks to add
/// Returns 0 on success, <0 on error
pub extern fn sceRtcTickAddTicks(destTick: [*c]u64, srcTick: [*c]const u64, numTicks: u64) callconv(.c) c_int;

/// Add an amount of ms to a tick
/// `destTick` - pointer to tick to hold result
/// `srcTick` - pointer to source tick
/// `numMS` - number of ms to add
/// Returns 0 on success, <0 on error
pub extern fn sceRtcTickAddMicroseconds(destTick: [*c]u64, srcTick: [*c]const u64, numMS: u64) callconv(.c) c_int;

/// Add an amount of seconds to a tick
/// `destTick` - pointer to tick to hold result
/// `srcTick` - pointer to source tick
/// `numSecs` - number of seconds to add
/// Returns 0 on success, <0 on error
pub extern fn sceRtcTickAddSeconds(destTick: [*c]u64, srcTick: [*c]const u64, numSecs: u64) callconv(.c) c_int;

/// Add an amount of minutes to a tick
/// `destTick` - pointer to tick to hold result
/// `srcTick` - pointer to source tick
/// `numMins` - number of minutes to add
/// Returns 0 on success, <0 on error
pub extern fn sceRtcTickAddMinutes(destTick: [*c]u64, srcTick: [*c]const u64, numMins: u64) callconv(.c) c_int;

/// Add an amount of hours to a tick
/// `destTick` - pointer to tick to hold result
/// `srcTick` - pointer to source tick
/// `numHours` - number of hours to add
/// Returns 0 on success, <0 on error
pub extern fn sceRtcTickAddHours(destTick: [*c]u64, srcTick: [*c]const u64, numHours: c_int) callconv(.c) c_int;

/// Add an amount of days to a tick
/// `destTick` - pointer to tick to hold result
/// `srcTick` - pointer to source tick
/// `numDays` - number of days to add
/// Returns 0 on success, <0 on error
pub extern fn sceRtcTickAddDays(destTick: [*c]u64, srcTick: [*c]const u64, numDays: c_int) callconv(.c) c_int;

/// Add an amount of weeks to a tick
/// `destTick` - pointer to tick to hold result
/// `srcTick` - pointer to source tick
/// `numWeeks` - number of weeks to add
/// Returns 0 on success, <0 on error
pub extern fn sceRtcTickAddWeeks(destTick: [*c]u64, srcTick: [*c]const u64, numWeeks: c_int) callconv(.c) c_int;

/// Add an amount of months to a tick
/// `destTick` - pointer to tick to hold result
/// `srcTick` - pointer to source tick
/// `numMonths` - number of months to add
/// Returns 0 on success, <0 on error
pub extern fn sceRtcTickAddMonths(destTick: [*c]u64, srcTick: [*c]const u64, numMonths: c_int) callconv(.c) c_int;

/// Add an amount of years to a tick
/// `destTick` - pointer to tick to hold result
/// `srcTick` - pointer to source tick
/// `numYears` - number of years to add
/// Returns 0 on success, <0 on error
pub extern fn sceRtcTickAddYears(destTick: [*c]u64, srcTick: [*c]const u64, numYears: c_int) callconv(.c) c_int;

/// Format Tick-representation UTC time in RFC2822 format
pub extern fn sceRtcFormatRFC2822(pszDateTime: [*c]c_char, pUtc: [*c]const u64, iTimeZoneMinutes: c_int) callconv(.c) c_int;

/// Format Tick-representation UTC time in RFC2822 format
pub extern fn sceRtcFormatRFC2822LocalTime(pszDateTime: [*c]c_char, pUtc: [*c]const u64) callconv(.c) c_int;

/// Format Tick-representation UTC time in RFC3339(ISO8601) format
pub extern fn sceRtcFormatRFC3339(pszDateTime: [*c]c_char, pUtc: [*c]const u64, iTimeZoneMinutes: c_int) callconv(.c) c_int;

/// Format Tick-representation UTC time in RFC3339(ISO8601) format
pub extern fn sceRtcFormatRFC3339LocalTime(pszDateTime: [*c]c_char, pUtc: [*c]const u64) callconv(.c) c_int;

pub extern fn sceRtcParseDateTime(destTick: [*c]u64, dateString: [*c]const c_char) callconv(.c) c_int;

/// Parse time information represented in RFC3339 format
pub extern fn sceRtcParseRFC3339(pUtc: [*c]u64, pszDateTime: [*c]const c_char) callconv(.c) c_int;

pub extern fn sceRtcGetAccumulativeTime() callconv(.c) void;

pub extern fn sceRtcSetTime64_t() callconv(.c) void;

pub extern fn sceRtcGetLastReincarnatedTime() callconv(.c) void;

pub extern fn sceRtcGetLastAdjustedTime() callconv(.c) void;

pub extern fn sceRtcGetTime64_t() callconv(.c) void;

comptime {
    asm (macro.import_module_start("sceRtc", "0x40010000", "40"));
    asm (macro.import_function("sceRtc", "0xC41C2853", "sceRtcGetTickResolution"));
    asm (macro.import_function("sceRtc", "0x3F7AD767", "sceRtcGetCurrentTick"));
    asm (macro.import_function("sceRtc", "0x029CA3B3", "sceRtc_029CA3B3"));
    asm (macro.import_function("sceRtc", "0x4CFA57B0", "sceRtcGetCurrentClock"));
    asm (macro.import_function("sceRtc", "0xE7C27D1B", "sceRtcGetCurrentClockLocalTime"));
    asm (macro.import_function("sceRtc", "0x34885E0D", "sceRtcConvertUtcToLocalTime"));
    asm (macro.import_function("sceRtc", "0x779242A2", "sceRtcConvertLocalTimeToUTC"));
    asm (macro.import_function("sceRtc", "0x42307A17", "sceRtcIsLeapYear"));
    asm (macro.import_function("sceRtc", "0x05EF322C", "sceRtcGetDaysInMonth"));
    asm (macro.import_function("sceRtc", "0x57726BC1", "sceRtcGetDayOfWeek"));
    asm (macro.import_function("sceRtc", "0x4B1B5E82", "sceRtcCheckValid"));
    asm (macro.import_function("sceRtc", "0x3A807CC8", "sceRtcSetTime_t"));
    asm (macro.import_function("sceRtc", "0x27C4594C", "sceRtcGetTime_t"));
    asm (macro.import_function("sceRtc", "0xF006F264", "sceRtcSetDosTime"));
    asm (macro.import_function("sceRtc", "0x36075567", "sceRtcGetDosTime"));
    asm (macro.import_function("sceRtc", "0x7ACE4C04", "sceRtcSetWin32FileTime"));
    asm (macro.import_function("sceRtc", "0xCF561893", "sceRtcGetWin32FileTime"));
    asm (macro.import_function("sceRtc", "0x7ED29E40", "sceRtcSetTick"));
    asm (macro.import_function("sceRtc", "0x6FF40ACC", "sceRtcGetTick"));
    asm (macro.import_function("sceRtc", "0x9ED0AE87", "sceRtcCompareTick"));
    asm (macro.import_function("sceRtc", "0x44F45E05", "sceRtcTickAddTicks"));
    asm (macro.import_function("sceRtc", "0x26D25A5D", "sceRtcTickAddMicroseconds"));
    asm (macro.import_function("sceRtc", "0xF2A4AFE5", "sceRtcTickAddSeconds"));
    asm (macro.import_function("sceRtc", "0xE6605BCA", "sceRtcTickAddMinutes"));
    asm (macro.import_function("sceRtc", "0x26D7A24A", "sceRtcTickAddHours"));
    asm (macro.import_function("sceRtc", "0xE51B4B7A", "sceRtcTickAddDays"));
    asm (macro.import_function("sceRtc", "0xCF3A2CA8", "sceRtcTickAddWeeks"));
    asm (macro.import_function("sceRtc", "0xDBF74F1B", "sceRtcTickAddMonths"));
    asm (macro.import_function("sceRtc", "0x42842C77", "sceRtcTickAddYears"));
    asm (macro.import_function("sceRtc", "0xC663B3B9", "sceRtcFormatRFC2822"));
    asm (macro.import_function("sceRtc", "0x7DE6711B", "sceRtcFormatRFC2822LocalTime"));
    asm (macro.import_function("sceRtc", "0x0498FB3C", "sceRtcFormatRFC3339"));
    asm (macro.import_function("sceRtc", "0x27F98543", "sceRtcFormatRFC3339LocalTime"));
    asm (macro.import_function("sceRtc", "0xDFBC5F16", "sceRtcParseDateTime"));
    asm (macro.import_function("sceRtc", "0x28E1E988", "sceRtcParseRFC3339"));
    asm (macro.import_function("sceRtc", "0x011F03C1", "sceRtcGetAccumulativeTime"));
    asm (macro.import_function("sceRtc", "0x1909C99B", "sceRtcSetTime64_t"));
    asm (macro.import_function("sceRtc", "0x203CEB0D", "sceRtcGetLastReincarnatedTime"));
    asm (macro.import_function("sceRtc", "0x62685E98", "sceRtcGetLastAdjustedTime"));
    asm (macro.import_function("sceRtc", "0xE1C93E47", "sceRtcGetTime64_t"));
}
