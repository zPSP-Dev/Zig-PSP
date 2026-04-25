//! PSP hardware model detection.
//!
//! Populated once at startup from kernel.max_free_mem_size(); see
//! src/utils/module.zig.

/// PSP hardware model.
pub const PspModel = enum {
    /// PSP-1000 ("Phat") -- 32 MB system RAM.
    phat,
    /// PSP-2000/3000/N1000 ("Slim" and later) -- 64 MB system RAM.
    slim,
};

/// Threshold (bytes) used to discriminate Phat from Slim.
/// Phat's hard ceiling is 32 MB of system RAM; Slim+ reports far more.
/// Anything >= 32 MB free at boot must be Slim+.
const slim_threshold_bytes: usize = 32 * 1024 * 1024;

var detected: PspModel = .phat;
var boot_max_free: usize = 0;

/// Internal: called once during startup with the result of
/// kernel.max_free_mem_size(). Not intended for user code.
pub fn _set_from_max_free(bytes: usize) void {
    boot_max_free = bytes;
    detected = if (bytes >= slim_threshold_bytes) .slim else .phat;
}

/// Returns the detected PSP model. Valid after startup runs
/// (i.e. anywhere user code executes).
pub fn current() PspModel {
    return detected;
}

/// Returns the max-free-mem value sampled at boot, in bytes.
pub fn boot_max_free_mem_size() usize {
    return boot_max_free;
}
