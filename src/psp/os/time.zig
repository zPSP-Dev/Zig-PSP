// SPDX-License-Identifier: MIT
// Copyright (c) 2015-2020 Zig Contributors
// This file is part of [zig](https://ziglang.org/), which is MIT licensed.
// The MIT license requires this copyright notice to be included in all copies
// and substantial portions of the software.
const std = @import("std");
const builtin = std.builtin;
const assert = std.debug.assert;
const testing = std.testing;
const math = std.math;

usingnamespace @import("../include/psprtc.zig");
usingnamespace @import("../include/pspthreadman.zig");

/// Spurious wakeups are possible and no precision of timing is guaranteed.
/// TODO integrate with evented I/O
pub fn sleep(nanoseconds: u64) void {
    _ = sceKernelDelayThread(@truncate(u32, nanoseconds / 1000));
}

/// Get a calendar timestamp, in seconds, relative to UTC 1970-01-01.
/// Precision of timing depends on the hardware and operating system.
/// The return value is signed because it is possible to have a date that is
/// before the epoch.
/// See `std.os.clock_gettime` for a POSIX timestamp.
pub fn timestamp() i64 {
    var r: u64 = 0;
    _ = sceRtcGetCurrentTick(&r);
    return @intCast(i64, r / sceRtcGetTickResolution());
}

/// Get a calendar timestamp, in milliseconds, relative to UTC 1970-01-01.
/// Precision of timing depends on the hardware and operating system.
/// The return value is signed because it is possible to have a date that is
/// before the epoch.
/// See `std.os.clock_gettime` for a POSIX timestamp.
pub fn milliTimestamp() i64 {
    var r: u64 = 0;
    _ = sceRtcGetCurrentTick(&r);
    return @intCast(i64, r / 1000);
}

/// Get a calendar timestamp, in nanoseconds, relative to UTC 1970-01-01.
/// Precision of timing depends on the hardware and operating system.
/// On Windows this has a maximum granularity of 100 nanoseconds.
/// The return value is signed because it is possible to have a date that is
/// before the epoch.
/// See `std.os.clock_gettime` for a POSIX timestamp.
pub fn nanoTimestamp() i128 {
    var r: u64 = 0;
    _ = sceRtcGetCurrentTick(&r);
    return @intCast(i64, r * 1000);
}

// Divisions of a nanosecond.
pub const ns_per_us = 1000;
pub const ns_per_ms = 1000 * ns_per_us;
pub const ns_per_s = 1000 * ns_per_ms;
pub const ns_per_min = 60 * ns_per_s;
pub const ns_per_hour = 60 * ns_per_min;
pub const ns_per_day = 24 * ns_per_hour;
pub const ns_per_week = 7 * ns_per_day;

// Divisions of a microsecond.
pub const us_per_ms = 1000;
pub const us_per_s = 1000 * us_per_ms;
pub const us_per_min = 60 * us_per_s;
pub const us_per_hour = 60 * us_per_min;
pub const us_per_day = 24 * us_per_hour;
pub const us_per_week = 7 * us_per_day;

// Divisions of a millisecond.
pub const ms_per_s = 1000;
pub const ms_per_min = 60 * ms_per_s;
pub const ms_per_hour = 60 * ms_per_min;
pub const ms_per_day = 24 * ms_per_hour;
pub const ms_per_week = 7 * ms_per_day;

// Divisions of a second.
pub const s_per_min = 60;
pub const s_per_hour = s_per_min * 60;
pub const s_per_day = s_per_hour * 24;
pub const s_per_week = s_per_day * 7;

/// A monotonic high-performance timer.
/// Timer.start() must be called to initialize the struct, which captures
/// the counter frequency on windows and darwin, records the resolution,
/// and gives the user an opportunity to check for the existnece of
/// monotonic clocks without forcing them to check for error on each read.
/// .resolution is in nanoseconds on all platforms but .start_time's meaning
/// depends on the OS. On Windows and Darwin it is a hardware counter
/// value that requires calculation to convert to a meaninful unit.
pub const Timer = struct {
    ///if we used resolution's value when performing the
    ///  performance counter calc on windows/darwin, it would
    ///  be less precise
    frequency: void,
    resolution: u64,
    start_time: u64,

    pub const Error = error{TimerUnsupported};

    /// At some point we may change our minds on RAW, but for now we're
    /// sticking with posix standard MONOTONIC. For more information, see:
    /// https://github.com/ziglang/zig/pull/933
    const monotonic_clock_id = os.CLOCK_MONOTONIC;

    /// Initialize the timer structure.
    /// Can only fail when running in a hostile environment that intentionally injects
    /// error values into syscalls, such as using seccomp on Linux to intercept
    /// `clock_gettime`.
    pub fn start() Timer {
        var r: u64 = 0;
        _ = sceRtcGetCurrentTick(&r);

        return Timer{
            .resolution = sceRtcGetTickResolution(),
            .start_time = r,
            .frequency = {},
        };
    }

    /// Reads the timer value since start or the last reset in nanoseconds
    pub fn read(self: Timer) u64 {
        var clock = clockNative() - self.start_time;
        return self.nativeDurationToNanos(clock);
    }

    /// Resets the timer value to 0/now.
    pub fn reset(self: *Timer) void {
        self.start_time = clockNative();
    }

    /// Returns the current value of the timer in nanoseconds, then resets it
    pub fn lap(self: *Timer) u64 {
        var now = clockNative();
        var lap_time = self.nativeDurationToNanos(now - self.start_time);
        self.start_time = now;
        return lap_time;
    }

    //Gets our current ticker
    fn clockNative() u64 {
        var r: u64 = 0;
        _ = sceRtcGetCurrentTick(&r);
        return r;
    }

    //On PSP... duration = us
    //Therefore duration * ns_per_us
    fn nativeDurationToNanos(self: Timer, duration: u64) u64 {
        return duration * ns_per_us;
    }
};
