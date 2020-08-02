pub const struct_UsbInterface = extern struct {
    expect_interface: c_int,
    unk8: c_int,
    num_interface: c_int,
};
pub const struct_UsbEndpoint = extern struct {
    endpnum: c_int,
    unk2: c_int,
    unk3: c_int,
};
pub const struct_StringDescriptor = packed struct {
    bLength: u8,
    bDescriptorType: u8,
    bString: [32]c_short,
};
pub const struct_DeviceDescriptor = packed struct {
    bLength: u8,
    bDescriptorType: u8,
    bcdUSB: c_ushort,
    bDeviceClass: u8,
    bDeviceSubClass: u8,
    bDeviceProtocol: u8,
    bMaxPacketSize: u8,
    idVendor: c_ushort,
    idProduct: c_ushort,
    bcdDevice: c_ushort,
    iManufacturer: u8,
    iProduct: u8,
    iSerialNumber: u8,
    bNumConfigurations: u8,
};
pub const struct_ConfigDescriptor = packed struct {
    bLength: u8,
    bDescriptorType: u8,
    wTotalLength: c_ushort,
    bNumInterfaces: u8,
    bConfigurationValue: u8,
    iConfiguration: u8,
    bmAttributes: u8,
    bMaxPower: u8,
};
pub const struct_InterfaceDescriptor = packed struct {
    bLength: u8,
    bDescriptorType: u8,
    bInterfaceNumber: u8,
    bAlternateSetting: u8,
    bNumEndpoints: u8,
    bInterfaceClass: u8,
    bInterfaceSubClass: u8,
    bInterfaceProtocol: u8,
    iInterface: u8,
};
pub const struct_EndpointDescriptor = packed struct {
    bLength: u8,
    bDescriptorType: u8,
    bEndpointAddress: u8,
    bmAttributes: u8,
    wMaxPacketSize: c_ushort,
    bInterval: u8,
};
pub const struct_UsbInterfaces = extern struct {
    infp: [2][*c]struct_InterfaceDescriptor,
    num: c_uint,
};
pub const struct_UsbConfiguration = extern struct {
    confp: [*c]struct_ConfigDescriptor,
    infs: [*c]struct_UsbInterfaces,
    infp: [*c]struct_InterfaceDescriptor,
    endp: [*c]struct_EndpointDescriptor,
};
pub const struct_Config = extern struct {
    pconfdesc: ?*c_void,
    pinterfaces: ?*c_void,
    pinterdesc: ?*c_void,
    pendp: ?*c_void,
};
pub const struct_ConfDesc = extern struct {
    desc: [12]u8,
    pinterfaces: ?*c_void,
};
pub const struct_Interfaces = extern struct {
    pinterdesc: [2]?*c_void,
    intcount: c_uint,
};
pub const struct_InterDesc = extern struct {
    desc: [12]u8,
    pendp: ?*c_void,
    pad: [32]u8,
};
pub const struct_Endp = extern struct {
    desc: [16]u8,
};
pub const struct_UsbData = packed struct {
    devdesc: [20]u8,
    config: struct_Config,
    confdesc: struct_ConfDesc,
    pad1: [8]u8,
    interfaces: struct_Interfaces,
    interdesc: struct_InterDesc,
    endp: [4]struct_Endp,
};
pub const struct_DeviceRequest = packed struct {
    bmRequestType: u8,
    bRequest: u8,
    wValue: c_ushort,
    wIndex: c_ushort,
    wLength: c_ushort,
};
pub const struct_UsbDriver = extern struct {
    name: [*c]const u8,
    endpoints: c_int,
    endp: [*c]struct_UsbEndpoint,
    intp: [*c]struct_UsbInterface,
    devp_hi: ?*c_void,
    confp_hi: ?*c_void,
    devp: ?*c_void,
    confp: ?*c_void,
    str: [*c]struct_StringDescriptor,
    recvctl: ?fn (c_int, c_int, [*c]struct_DeviceRequest) callconv(.C) c_int,
    func28: ?fn (c_int, c_int, c_int) callconv(.C) c_int,
    attach: ?fn (c_int, ?*c_void, ?*c_void) callconv(.C) c_int,
    detach: ?fn (c_int, c_int, c_int) callconv(.C) c_int,
    unk34: c_int,
    start_func: ?fn (c_int, ?*c_void) callconv(.C) c_int,
    stop_func: ?fn (c_int, ?*c_void) callconv(.C) c_int,
    link: [*c]struct_UsbDriver,
};
pub const struct_UsbdDeviceReq = extern struct {
    endp: [*c]struct_UsbEndpoint,
    data: ?*c_void,
    size: c_int,
    unkc: c_int,
    func: ?*c_void,
    recvsize: c_int,
    retcode: c_int,
    unk1c: c_int,
    arg: ?*c_void,
    link: ?*c_void,
};
pub extern fn sceUsbbdRegister(drv: [*c]struct_UsbDriver) c_int;
pub extern fn sceUsbbdUnregister(drv: [*c]struct_UsbDriver) c_int;
pub extern fn sceUsbbdClearFIFO(endp: [*c]struct_UsbEndpoint) c_int;
pub extern fn sceUsbbdReqCancelAll(endp: [*c]struct_UsbEndpoint) c_int;
pub extern fn sceUsbbdStall(endp: [*c]struct_UsbEndpoint) c_int;
pub extern fn sceUsbbdReqSend(req: [*c]struct_UsbdDeviceReq) c_int;
pub extern fn sceUsbbdReqRecv(req: [*c]struct_UsbdDeviceReq) c_int;

pub const UsbInterface = struct_UsbInterface;
pub const UsbEndpoint = struct_UsbEndpoint;
pub const StringDescriptor = struct_StringDescriptor;
pub const DeviceDescriptor = struct_DeviceDescriptor;
pub const ConfigDescriptor = struct_ConfigDescriptor;
pub const InterfaceDescriptor = struct_InterfaceDescriptor;
pub const EndpointDescriptor = struct_EndpointDescriptor;
pub const UsbInterfaces = struct_UsbInterfaces;
pub const UsbConfiguration = struct_UsbConfiguration;
pub const Config = struct_Config;
pub const ConfDesc = struct_ConfDesc;
pub const Interfaces = struct_Interfaces;
pub const InterDesc = struct_InterDesc;
pub const Endp = struct_Endp;
pub const UsbData = struct_UsbData;
pub const DeviceRequest = struct_DeviceRequest;
pub const UsbDriver = struct_UsbDriver;
pub const UsbdDeviceReq = struct_UsbdDeviceReq;
