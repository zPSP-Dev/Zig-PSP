usingnamespace @import("psptypes.zig");

pub extern var PspInterruptNames: [67][*c]const u8;

pub const enum_PspInterrupts = extern enum(c_int) {
    PSP_GPIO_INT = 4,
    PSP_ATA_INT = 5,
    PSP_UMD_INT = 6,
    PSP_MSCM0_INT = 7,
    PSP_WLAN_INT = 8,
    PSP_AUDIO_INT = 10,
    PSP_I2C_INT = 12,
    PSP_SIRCS_INT = 14,
    PSP_SYSTIMER0_INT = 15,
    PSP_SYSTIMER1_INT = 16,
    PSP_SYSTIMER2_INT = 17,
    PSP_SYSTIMER3_INT = 18,
    PSP_THREAD0_INT = 19,
    PSP_NAND_INT = 20,
    PSP_DMACPLUS_INT = 21,
    PSP_DMA0_INT = 22,
    PSP_DMA1_INT = 23,
    PSP_MEMLMD_INT = 24,
    PSP_GE_INT = 25,
    PSP_VBLANK_INT = 30,
    PSP_MECODEC_INT = 31,
    PSP_HPREMOTE_INT = 36,
    PSP_MSCM1_INT = 60,
    PSP_MSCM2_INT = 61,
    PSP_THREAD1_INT = 65,
    PSP_INTERRUPT_INT = 66,
    _,
};

pub const enum_PspSubInterrupts = extern enum(c_int) {
    PSP_GPIO_SUBINT = 4,
    PSP_ATA_SUBINT = 5,
    PSP_UMD_SUBINT = 6,
    PSP_DMACPLUS_SUBINT = 21,
    PSP_GE_SUBINT = 25,
    PSP_DISPLAY_SUBINT = 30,
    _,
};
pub extern fn sceKernelCpuSuspendIntr() c_uint;
pub extern fn sceKernelCpuResumeIntr(flags: c_uint) void;
pub extern fn sceKernelCpuResumeIntrWithSync(flags: c_uint) void;
pub extern fn sceKernelIsCpuIntrSuspended(flags: c_uint) c_int;
pub extern fn sceKernelIsCpuIntrEnable() c_int;
pub extern fn sceKernelRegisterSubIntrHandler(intno: c_int, no: c_int, handler: ?*c_void, arg: ?*c_void) c_int;
pub extern fn sceKernelReleaseSubIntrHandler(intno: c_int, no: c_int) c_int;
pub extern fn sceKernelEnableSubIntr(intno: c_int, no: c_int) c_int;
pub extern fn sceKernelDisableSubIntr(intno: c_int, no: c_int) c_int;
pub const struct_tag_IntrHandlerOptionParam = extern struct {
    size: c_int,
    entry: u32_3,
    common: u32_3,
    gp: u32_3,
    intr_code: u16_2,
    sub_count: u16_2,
    intr_level: u16_2,
    enabled: u16_2,
    calls: u32_3,
    field_1C: u32_3,
    total_clock_lo: u32_3,
    total_clock_hi: u32_3,
    min_clock_lo: u32_3,
    min_clock_hi: u32_3,
    max_clock_lo: u32_3,
    max_clock_hi: u32_3,
};
pub const PspIntrHandlerOptionParam = struct_tag_IntrHandlerOptionParam;
pub extern fn QueryIntrHandlerInfo(intr_code: SceUID, sub_intr_code: SceUID, data: [*c]PspIntrHandlerOptionParam) c_int;
pub extern fn sceKernelRegisterIntrHandler(intno: c_int, no: c_int, handler: ?*c_void, arg1: ?*c_void, arg2: ?*c_void) c_int;
pub extern fn sceKernelReleaseIntrHandler(intno: c_int) c_int;
pub extern fn sceKernelEnableIntr(intno: c_int) c_int;
pub extern fn sceKernelDisableIntr(intno: c_int) c_int;
pub extern fn sceKernelIsIntrContext() c_int;

pub const PspInterrupts = enum_PspInterrupts;
pub const PspSubInterrupts = enum_PspSubInterrupts;
pub const tag_IntrHandlerOptionParam = struct_tag_IntrHandlerOptionParam;
