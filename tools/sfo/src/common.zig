pub const PSF_MAGIC_NUM = 0x46535000;
pub const PSF_VERSION = 0x00000101;

pub const SFOHeader = packed struct{
    magic: u32,
    version: u32,
    keyofs: u32,
    valofs: u32,
    count: u32
};

pub const SFOEntry = packed struct{
    nameofs: u16,
    alignment: u8,
    typec: u8,
    valsize: u32,
    totalsize: u32,
    dataofs: u32
};

pub const PSP_TYPE_BIN = 0;
pub const PSP_TYPE_STR = 2;
pub const PSP_TYPE_VAL = 4;

pub const EntryContainer = struct{
    name: []const u8,
    typec: i32,
    value: u32,
    data: ?[]const u8
};

pub const g_defaults : [8]EntryContainer = [8]EntryContainer{
    EntryContainer{ .name = "MEMSIZE",           .typec = PSP_TYPE_VAL, .value  = 1,    .data = null},
    EntryContainer{ .name = "BOOTABLE",         .typec = PSP_TYPE_VAL, .value  = 1,         .data = null },
    EntryContainer{ .name = "CATEGORY",         .typec = PSP_TYPE_STR, .value  = 0,         .data = "MG"},
    EntryContainer{ .name = "DISC_ID",          .typec = PSP_TYPE_STR, .value  = 0,         .data = "UCJS10041"},
    EntryContainer{ .name = "DISC_VERSION",     .typec = PSP_TYPE_STR, .value  = 0,         .data = "1.00"},
    EntryContainer{ .name = "PARENTAL_LEVEL",   .typec = PSP_TYPE_VAL, .value  = 1,         .data = null},
    EntryContainer{ .name = "PSP_SYSTEM_VER",   .typec = PSP_TYPE_STR, .value  = 0,         .data = "1.00"},
    EntryContainer{ .name = "REGION",           .typec = PSP_TYPE_VAL, .value  = 0x8000,    .data = null},
};

pub const MAX_OPTIONS = 256;

pub var gVals : [MAX_OPTIONS]EntryContainer = undefined;
