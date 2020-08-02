usingnamespace @import("sys/pspkernel.zig");

extern const __lib_ent_top:  [*c]u8;
extern const __lib_ent_bottom: [*c]u8;
extern const __lib_stub_top: [*c]u8;
extern const __lib_stub_bottom: [*c]u8;

export const module_info: SceModuleInfo align(16) linksection(".rodata.sceModuleInfo") = SceModuleInfo {
    .modattribute = PSP_MODULE_USER,
    .modversion = [2]u8{0, 1},
    .modname = "APP".* ++ [_]u8{0} ** (27 - "APP".*.len),
    .terminal = 0,
    .gp_value = _gp,
    .ent_top = __lib_ent_top,
    .ent_end = __lib_ent_bottom,
    .stub_top = __lib_stub_top,
    .stub_end = __lib_stub_bottom,
};