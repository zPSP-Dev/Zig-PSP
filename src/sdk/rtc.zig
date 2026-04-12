// Real-time clock -- ticks, calendar, time conversion
//
// Wraps:
//   c/module/sceRtc.zig

const c = @import("../c/modules.zig");
const internal = @import("internal.zig");
const err = @import("errors/rtc.zig");
const check = err.check;
const ci = internal.ci;
const Error = err.Error;

const rtc = c.sceRtc;

pub const DateTime = c.types.ScePspDateTime;
pub const time_t = c.types.time_t;

// -- Tick operations ----------------------------------------------------

pub fn get_tick_resolution() u32 {
    return rtc.sceRtcGetTickResolution();
}

pub fn get_current_tick(tick: *u64) Error!void {
    return check(rtc.sceRtcGetCurrentTick(tick));
}

pub fn get_current_clock(time: *DateTime, tz: i32) Error!void {
    return check(rtc.sceRtcGetCurrentClock(time, @as(c_int, tz)));
}

pub fn get_current_clock_local_time(time: *DateTime) Error!void {
    return check(rtc.sceRtcGetCurrentClockLocalTime(time));
}

pub fn convert_utc_to_local_time(tick_utc: *const u64, tick_local: *u64) Error!void {
    return check(rtc.sceRtcConvertUtcToLocalTime(tick_utc, tick_local));
}

pub fn convert_local_time_to_utc(tick_local: *const u64, tick_utc: *u64) Error!void {
    return check(rtc.sceRtcConvertLocalTimeToUTC(tick_local, tick_utc));
}

// -- Calendar -----------------------------------------------------------

pub fn is_leap_year(year: i32) bool {
    return rtc.sceRtcIsLeapYear(@as(c_int, year)) != 0;
}

pub fn get_days_in_month(year: i32, month: i32) i32 {
    return rtc.sceRtcGetDaysInMonth(@as(c_int, year), @as(c_int, month));
}

/// Returns day of week: 0 = Monday.
pub fn get_day_of_week(year: i32, month: i32, day: i32) i32 {
    return rtc.sceRtcGetDayOfWeek(@as(c_int, year), @as(c_int, month), @as(c_int, day));
}

pub fn check_valid(date: *const DateTime) Error!void {
    return check(rtc.sceRtcCheckValid(date));
}

// -- Conversions --------------------------------------------------------

pub fn set_time_t(date: *DateTime, time: time_t) Error!void {
    return check(rtc.sceRtcSetTime_t(date, time));
}

pub fn get_time_t(date: *const DateTime, time: *time_t) Error!void {
    return check(rtc.sceRtcGetTime_t(date, time));
}

pub fn set_dos_time(date: *DateTime, dos_time: u32) Error!void {
    return check(rtc.sceRtcSetDosTime(date, dos_time));
}

pub fn get_dos_time(date: *DateTime, dos_time: u32) Error!void {
    return check(rtc.sceRtcGetDosTime(date, dos_time));
}

pub fn set_win32_file_time(date: *DateTime, win32_time: *u64) Error!void {
    return check(rtc.sceRtcSetWin32FileTime(date, win32_time));
}

pub fn get_win32_file_time(date: *DateTime, win32_time: *u64) Error!void {
    return check(rtc.sceRtcGetWin32FileTime(date, win32_time));
}

pub fn set_tick(date: *DateTime, tick: *const u64) Error!void {
    return check(rtc.sceRtcSetTick(date, tick));
}

pub fn get_tick(date: *const DateTime, tick: *u64) Error!void {
    return check(rtc.sceRtcGetTick(date, tick));
}

// -- Tick comparison / arithmetic ---------------------------------------

/// Returns <0 if tick1 < tick2, 0 if equal, >0 if tick1 > tick2.
pub fn compare_tick(tick1: *const u64, tick2: *const u64) i32 {
    return rtc.sceRtcCompareTick(tick1, tick2);
}

pub fn tick_add_ticks(dest: *u64, src: *const u64, num: u64) Error!void {
    return check(rtc.sceRtcTickAddTicks(dest, src, num));
}

pub fn tick_add_microseconds(dest: *u64, src: *const u64, num: u64) Error!void {
    return check(rtc.sceRtcTickAddMicroseconds(dest, src, num));
}

pub fn tick_add_seconds(dest: *u64, src: *const u64, num: u64) Error!void {
    return check(rtc.sceRtcTickAddSeconds(dest, src, num));
}

pub fn tick_add_minutes(dest: *u64, src: *const u64, num: u64) Error!void {
    return check(rtc.sceRtcTickAddMinutes(dest, src, num));
}

pub fn tick_add_hours(dest: *u64, src: *const u64, num: i32) Error!void {
    return check(rtc.sceRtcTickAddHours(dest, src, @as(c_int, num)));
}

pub fn tick_add_days(dest: *u64, src: *const u64, num: i32) Error!void {
    return check(rtc.sceRtcTickAddDays(dest, src, @as(c_int, num)));
}

pub fn tick_add_weeks(dest: *u64, src: *const u64, num: i32) Error!void {
    return check(rtc.sceRtcTickAddWeeks(dest, src, @as(c_int, num)));
}

pub fn tick_add_months(dest: *u64, src: *const u64, num: i32) Error!void {
    return check(rtc.sceRtcTickAddMonths(dest, src, @as(c_int, num)));
}

pub fn tick_add_years(dest: *u64, src: *const u64, num: i32) Error!void {
    return check(rtc.sceRtcTickAddYears(dest, src, @as(c_int, num)));
}

// -- Formatting / parsing -----------------------------------------------

pub fn format_rfc2822(buf: [*]u8, utc: *const u64, tz_minutes: i32) Error!void {
    return check(rtc.sceRtcFormatRFC2822(buf, utc, @as(c_int, tz_minutes)));
}

pub fn format_rfc2822_local_time(buf: [*]u8, utc: *const u64) Error!void {
    return check(rtc.sceRtcFormatRFC2822LocalTime(buf, utc));
}

pub fn format_rfc3339(buf: [*]u8, utc: *const u64, tz_minutes: i32) Error!void {
    return check(rtc.sceRtcFormatRFC3339(buf, utc, @as(c_int, tz_minutes)));
}

pub fn format_rfc3339_local_time(buf: [*]u8, utc: *const u64) Error!void {
    return check(rtc.sceRtcFormatRFC3339LocalTime(buf, utc));
}

pub fn parse_date_time(dest_tick: *u64, date_string: [*:0]const u8) Error!void {
    return check(rtc.sceRtcParseDateTime(dest_tick, date_string));
}

pub fn parse_rfc3339(utc: *u64, date_string: [*:0]const u8) Error!void {
    return check(rtc.sceRtcParseRFC3339(utc, date_string));
}
