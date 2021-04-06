const std = @import("std");
const io = std.io;
const mem = std.mem;
const process = std.process;
const fs = std.fs;

//The standard header structure for a PBP File
//This includes a 4 byte signature, followed by the 4 byte version number
//Then ends with an offset table for its component files.
pub const PbpHeader = struct{
    signature: [4]u8,
    version: [4]u8,
    offset: [8]u32,
};

//The default file names of the PBP components
pub var default_file_names : [8][]const u8 =  [8][]const u8{
   "PARAM.SFO",
   "ICON0.PNG",
   "ICON1.PMF",
   "PIC0.PNG",
   "PIC1.PNG",
   "SND0.AT3",
   "DATA.PSP",
   "DATA.PSAR"
};

//Reads a PBP Header file
pub fn readHeader(file: fs.File) !PbpHeader {
    var header : PbpHeader = undefined;

    var instream = file.reader();

    var bytes_read = try instream.read(header.signature[0..]);
    
    if(bytes_read != 4 and std.mem.eql(u8, header.signature[1..], "PBP")){
        std.debug.warn("Could not read the header!", .{});
        return error.BadHeader;
    }

    bytes_read = try instream.read(header.version[0..]);
    if(bytes_read != 4){
        std.debug.warn("Could not read the header!", .{});
        return error.BadHeader;
    }

    var i : usize = 0;
    while(i < 8) : (i += 1){
        header.offset[i] = try instream.readIntNative(u32);
    }

    std.debug.warn("Valid Header!\n\n", .{});
    return header;
}
