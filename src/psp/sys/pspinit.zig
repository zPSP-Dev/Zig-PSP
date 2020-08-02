pub const enum_PSPBootFrom = extern enum(c_int) {
    PSP_BOOT_FLASH = 0,
    PSP_BOOT_DISC = 32,
    PSP_BOOT_MS = 64,
    _,
};

pub const enum_PSPInitApitype = extern enum(c_int) {
    PSP_INIT_APITYPE_DISC = 288,
    PSP_INIT_APITYPE_DISC_UPDATER = 289,
    PSP_INIT_APITYPE_MS1 = 320,
    PSP_INIT_APITYPE_MS2 = 321,
    PSP_INIT_APITYPE_MS3 = 322,
    PSP_INIT_APITYPE_MS4 = 323,
    PSP_INIT_APITYPE_MS5 = 324,
    PSP_INIT_APITYPE_VSH1 = 528,
    PSP_INIT_APITYPE_VSH2 = 544,
    _,
};

pub const enum_PSPKeyConfig = extern enum(c_int) {
    PSP_INIT_KEYCONFIG_VSH = 256,
    PSP_INIT_KEYCONFIG_GAME = 512,
    PSP_INIT_KEYCONFIG_POPS = 768,
    _,
};
pub extern fn sceKernelInitApitype(...) c_int;
pub extern fn sceKernelInitFileName(...) [*c]u8;
pub extern fn sceKernelBootFrom(...) c_int;
pub extern fn InitForKernel_7233B5BC(...) c_int;

pub const PSPBootFrom = enum_PSPBootFrom;
pub const PSPInitApitype = enum_PSPInitApitype;
pub const PSPKeyConfig = enum_PSPKeyConfig;
