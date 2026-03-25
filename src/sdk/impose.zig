// System impose settings (home popup, UMD popup, backlight, etc.)
//
// Wraps:
//   c/module/sceImpose.zig
//
// Note: Most functions in this module are undocumented stubs with no
// parameters or return values. Only the raw C bindings are exposed
// here; wrap individually as signatures become known.

const c = @import("../c/modules.zig");

const impose = c.sceImpose;

pub const get_home_popup = impose.sceImposeGetHomePopup;
pub const get_language_mode = impose.sceImposeGetLanguageMode;
pub const set_language_mode = impose.sceImposeSetLanguageMode;
pub const home_button = impose.sceImposeHomeButton;
pub const set_home_popup = impose.sceImposeSetHomePopup;
pub const set_umd_popup = impose.sceImposeSetUMDPopup;
pub const battery_icon_status = impose.sceImposeBatteryIconStatus;
pub const get_backlight_off_time = impose.sceImposeGetBacklightOffTime;
pub const set_backlight_off_time = impose.sceImposeSetBacklightOffTime;
pub const get_umd_popup = impose.sceImposeGetUMDPopup;
