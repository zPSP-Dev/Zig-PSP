//This satisfies linker issues...
//Aside from that - there's no reason for them to exist.

export fn memset(ptr: [*]u8, value: u32, num: usize) [*]u8 {
    var i: usize = 0;
    while (i < num) : (i += 1) {
        ptr[i] = @as(u8, @truncate(u8, value));
    }
    return ptr;
}

export fn memcpy(dst: [*]u8, src: [*]const u8, num: isize) [*]u8 {
    var i: usize = 0;
    while (i < num) : (i += 1) {
        dst[i] = src[i];
    }
    return dst;
}

export fn memcmp(ptr1: [*]u8, ptr2: [*]u8, num: isize) i32 {
    var i: usize = 0;
    while (i < num) : (i += 1) {
        if (ptr1[i] != ptr2[i]) {
            return ptr1[i] - ptr2[i];
        }
    }
    return 0;
}
