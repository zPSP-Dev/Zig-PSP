usingnamespace @import("psptypes.zig");

pub const struct_SceModule = packed struct {
    next: [*c]struct_SceModule,
    attribute: c_ushort,
    version: [2]u8,
    modname: [27]u8,
    terminal: u8,
    unknown1: c_uint,
    unknown2: c_uint,
    modid: SceUID,
    unknown3: [4]c_uint,
    ent_top: ?*c_void,
    ent_size: c_uint,
    stub_top: ?*c_void,
    stub_size: c_uint,
    unknown4: [4]c_uint,
    entry_addr: c_uint,
    gp_value: c_uint,
    text_addr: c_uint,
    text_size: c_uint,
    data_size: c_uint,
    bss_size: c_uint,
    nsegment: c_uint,
    segmentaddr: [4]c_uint,
    segmentsize: [4]c_uint,
};
pub const SceModule = struct_SceModule;
pub const struct_SceLibraryEntryTable = extern struct {
    libname: [*c]const u8,
    version: [2]u8,
    attribute: c_ushort,
    len: u8,
    vstubcount: u8,
    stubcount: c_ushort,
    entrytable: ?*c_void,
};
pub const SceLibraryEntryTable = struct_SceLibraryEntryTable;
pub const struct_SceLibraryStubTable = extern struct {
    libname: [*c]const u8,
    version: [2]u8,
    attribute: c_ushort,
    len: u8,
    vstubcount: u8,
    stubcount: c_ushort,
    nidtable: [*c]c_uint,
    stubtable: ?*c_void,
    vstubtable: ?*c_void,
};
pub const SceLibraryStubTable = struct_SceLibraryStubTable;
pub extern fn sceKernelFindModuleByName(modname: [*c]const u8) [*c]SceModule;
pub extern fn sceKernelFindModuleByAddress(addr: c_uint) [*c]SceModule;
pub extern fn sceKernelFindModuleByUID(modid: SceUID) [*c]SceModule;
pub extern fn sceKernelModuleCount() c_int;
pub extern fn sceKernelIcacheClearAll() void;
