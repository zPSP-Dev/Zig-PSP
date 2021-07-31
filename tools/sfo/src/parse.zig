const std = @import("std");
const process = std.process;
usingnamespace @import("common.zig");
const io = std.io;
const mem = std.mem;
const fs = std.fs;

const json = std.json;

const T = struct {
    title: []const u8,
    properties: []Property,
    
    const Property = struct{
        key: []const u8,
        val: Union,
    };
    const Union = union(enum){
        dw: u32,
        str: []const u8 
    };
};

pub fn parseSFO() !void {
    //Get args
    var arg_it = process.args();

    // Skip executable
    _ = arg_it.skip();
    // Skip command
    _ = arg_it.skip();

    //Allocator setup
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;

    var map = std.StringHashMap(i32).init(allocator);
    defer map.deinit();

    _ = try map.put("BOOTABLE", PSP_TYPE_VAL);
    _ = try map.put("CATEGORY", PSP_TYPE_STR);
    _ = try map.put("DISC_ID", PSP_TYPE_STR);
    _ = try map.put("DISC_NUMBER", PSP_TYPE_VAL);
    _ = try map.put("DISC_VERSION", PSP_TYPE_STR);
    _ = try map.put("DRIVER_PATH", PSP_TYPE_STR);
    _ = try map.put("LANGUAGE", PSP_TYPE_STR);
    _ = try map.put("PARENTAL_LEVEL", PSP_TYPE_VAL);
    _ = try map.put("PSP_SYSTEM_VER", PSP_TYPE_STR);
    _ = try map.put("REGION", PSP_TYPE_VAL);
    _ = try map.put("SAVEDATA_DETAIL", PSP_TYPE_STR);
    _ = try map.put("SAVEDATA_DIRECTORY", PSP_TYPE_STR);
    _ = try map.put("SAVEDATA_FILE_LIST", PSP_TYPE_BIN);
    _ = try map.put("SAVEDATA_PARAMS", PSP_TYPE_BIN);
    _ = try map.put("SAVEDATA_TITLE", PSP_TYPE_STR);
    _ = try map.put("TITLE", PSP_TYPE_STR);
    _ = try map.put("TITLE_0", PSP_TYPE_STR);
    _ = try map.put("TITLE_2", PSP_TYPE_STR);
    _ = try map.put("TITLE_3", PSP_TYPE_STR);
    _ = try map.put("TITLE_4", PSP_TYPE_STR);
    _ = try map.put("TITLE_5", PSP_TYPE_STR);
    _ = try map.put("TITLE_6", PSP_TYPE_STR);
    _ = try map.put("TITLE_7", PSP_TYPE_STR);
    _ = try map.put("TITLE_8", PSP_TYPE_STR);
    _ = try map.put("UPDATER_VER", PSP_TYPE_STR);
    _ = try map.put("MEMSIZE", PSP_TYPE_VAL);

    var inputFile = try (arg_it.next(allocator) orelse{
        std.debug.warn("Usage: sfotool parse <input.json> <output.SFO>\n", .{});
        return;
    });

    if(std.mem.eql(u8, inputFile, "-h")){
        std.debug.warn("Usage: sfotool parse <input.json> <output.SFO>\n", .{});
        return;
    }

    var outputFile = try (arg_it.next(allocator) orelse{
        std.debug.warn("Usage: sfotool parse <input.json> <output.SFO>\n", .{});
        return;
    });

    if(std.mem.eql(u8, outputFile, "-h")){
        std.debug.warn("Usage: sfotool parse <input.json> <output.SFO>\n", .{});
        return;
    }

    //Copy the defaults into a value array
    var i : usize = 0;
    while(i < 8) : (i += 1){
        gVals[i] = g_defaults[i];
    }
    var totalProps : usize = 9;

    var inFile = try fs.cwd().openFile(inputFile, fs.File.OpenFlags{.read = true});
    defer inFile.close();

    //Parse json
    var buf: [std.mem.page_size]u8 = undefined;
    const fileSize = try inFile.reader().readAll(buf[0..]);
    const filestr = buf[0..fileSize];

    const options = std.json.ParseOptions{ .allocator = allocator };
    
    const r = try std.json.parse(T, &std.json.TokenStream.init(filestr), options);
    
    gVals[i] = EntryContainer{
        .name = "TITLE",
        .typec = PSP_TYPE_STR,
        .value  = 0,
        .data  = r.title,
    };
    i += 1;

    var z : usize = 0;
    while(z < r.properties.len) : (z += 1){
        var val = map.get(r.properties[z].key);

        var f : usize = 0;
        var overwrit : bool = false;
        
        while(f < 9) : (f += 1){
            if(std.mem.eql(u8, gVals[f].name, r.properties[z].key)){
                std.debug.warn("Overwriting {s}!\n", .{r.properties[z].key});
                gVals[f] = EntryContainer{
                    .name = r.properties[z].key,
                    .typec = val.?,
                    .value = if(val.? == PSP_TYPE_VAL) r.properties[z].val.dw else 0,
                    .data = if(val.? == PSP_TYPE_STR) r.properties[z].val.str else null,
                };
                overwrit = true;
                break;
            }
            //Otherwise it's unique!
        }

        if(overwrit){
            continue;
        }

        if(val != null){
            gVals[i] = EntryContainer{
                .name = r.properties[z].key,
                .typec = val.?,
                .value = if(val.? == PSP_TYPE_VAL) r.properties[z].val.dw else 0,
                .data = if(val.? == PSP_TYPE_STR) r.properties[z].val.str else null,
            };
            i += 1;
            totalProps += 1;
        }else{
            std.debug.warn("Invalid Key: {s}!\nSkipping...\n", .{r.properties[z].key});
            continue;
        }
    }

    //We use buffers to write to
    var head : [8192]u8 = [_]u8{0} ** 8192;
    var keys : [8192]u8 = [_]u8{0} ** 8192;
    var data : [8192]u8 = [_]u8{0} ** 8192;

    //Tracker pointers
    var h: [*]SFOHeader = undefined;
    var e: [*]SFOEntry = undefined;
    var k: [*]u8 = undefined;
    var d: [*]u8 = undefined;

    h = @ptrCast([*]SFOHeader, &head);
    e = @intToPtr([*]SFOEntry, @ptrToInt(&head) + @sizeOf(SFOHeader));
    k = &keys;
    d = &data;

    //Header layout
    h.*.magic = PSF_MAGIC_NUM;
    h.*.version = PSF_VERSION;
    
    i = 0;
    while(i < totalProps) : (i += 1){
        //Increment count
        h.*.count = @truncate(u32, i) + 1;

        //This name is offset
        e.*.nameofs = @truncate(u16, (@ptrToInt(k) - @ptrToInt(&keys)));
        //This name is offset
        e.*.dataofs = @truncate(u16, (@ptrToInt(d) - @ptrToInt(&data)));

        //Align by 4
        e.*.alignment = 4;

        //What is the type?
        e.*.typec = @intCast(u8, @truncate(i8, gVals[i].typec));

        //Put key inside
        std.mem.copy(u8, keys[(@ptrToInt(k) - @ptrToInt(&keys))..], gVals[i].name);
        k += gVals[i].name.len + 1;

        //Value set
        if(e.*.typec == PSP_TYPE_VAL){
            //Set values in data buffer
            e.*.valsize = 4;
            e.*.totalsize = 4;
            @ptrCast(*u32, @alignCast(4, d)).* = gVals[i].value;
            d += 4;
        }else{
            //Copy string to data buffer
            var totalsize : usize = 0;
            var valsize : usize = 0;

            valsize = gVals[i].data.?.len + 1;
            totalsize = (valsize + 3) & ~@as(usize, 3);
            e.*.valsize = @truncate(u32, valsize);
            e.*.totalsize = @truncate(u32, totalsize);

            @memset(d, 0, totalsize);
            std.mem.copy(u8, data[(@ptrToInt(d) - @ptrToInt(&data))..], gVals[i].data.?);
            d += totalsize;
        }
        e += 1;
    }
    
    //Get the header size
    var head_size : usize = (@ptrToInt(e) - @ptrToInt(&head));
    h.*.keyofs = @truncate(u32, head_size);

    //Calculate key and data size
    var key_size : usize = (@ptrToInt(k) - @ptrToInt(&keys));
    var data_size : usize = (@ptrToInt(d) - @ptrToInt(&data));
    
    //Align keys
    var @"align" : u32 = 3 - @truncate(u32, key_size & 3);
    while (@"align" < 3) {
        k += 1;
        @"align" -%= 1;
    }
    key_size = (@ptrToInt(k) - @ptrToInt(&keys));

    //Value offset is after headers and keys
    h.*.valofs = @truncate(u32, h.*.keyofs + key_size);
    
    //Open File
    var of = try fs.cwd().createFile(outputFile, fs.File.CreateFlags {.truncate = true});
    defer of.close();

    //Write data
    _ = try of.writeAll(head[0..head_size]);
    _ = try of.writeAll(keys[0..key_size]);
    _ = try of.writeAll(data[0..data_size]);

    std.debug.warn("SFO Saved!\n", .{});
}
