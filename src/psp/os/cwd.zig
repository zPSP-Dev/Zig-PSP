const bits = @import("bits.zig");
const system = @import("system.zig");

var __psp_cwd: [bits.PATH_MAX + 1]u8 = [_]u8{0} ** (bits.PATH_MAX + 1);

pub fn __psp_init_cwd(path: ?*anyopaque) void {
    if (path != null) {
        var base_path: [bits.PATH_MAX + 1]u8 = undefined;
        var end: ?[*]u8 = null;

        _ = strncpy(@as(?[*]u8, @ptrCast(&base_path)), @as([*]const u8, @ptrCast(path)), bits.PATH_MAX);
        base_path[bits.PATH_MAX] = 0;
        end = strrchr(@as([*]u8, @ptrCast(base_path[0..])), '/');
        if (end != null) {
            (end.? + 1).* = 0;
            _ = chdir(base_path[0..]);
        }
    }
}

pub fn strncpy(dest: ?[*]u8, src: [*]const u8, num: usize) ?[*]u8 {
    if (dest == null) {
        return null;
    }

    var ptr = dest.?;
    var ptr2 = src;

    var i: isize = @as(isize, @intCast(num));
    while (ptr[0] != 0 and i >= 0) : (i -= 1) {
        ptr[0] = ptr2[0];
        ptr += 1;
        ptr2 += 1;
    }

    ptr[0] = 0;
    return ptr;
}

pub fn strrchr(c: [*]u8, tbf: u8) ?[*]u8 {
    var found: ?[*]u8 = null;

    var i: usize = 0;
    while (c[i] != 0) : (i += 1) {
        if (c[i] == tbf) {
            found = @as([*]u8, @ptrCast(&c[i]));
        }
    }

    return found;
}

const pspiofilemgr = @import("../sdk/pspiofilemgr.zig");

pub fn chdir(path: [*]const u8) c_int {
    var dest: [bits.PATH_MAX + 1]u8 = undefined;
    var uid: c_int = 0;

    if (__psp_path_absolute(path, dest[0..], bits.PATH_MAX) < 0) {
        pspiofilemgr.errno = bits.ENAMETOOLONG;
        return -1;
    }

    uid = pspiofilemgr.sceIoDopen(dest[0..]);
    if (uid < 0) {
        pspiofilemgr.errno = bits.ENOTDIR;
        return -1;
    }
    _ = pspiofilemgr.sceIoDclose(uid);

    _ = pspiofilemgr.sceIoChdir(dest[0..]);
    _ = strcpy(__psp_cwd[0..], dest[0..]);
    return 0;
}

// Like strcpy, but returns 0 if the string doesn't fit
pub fn __psp_safe_strcpy(out: [*]u8, in: [*]const u8, maxlen: usize) c_int {
    var ptr = out;
    var ptr2 = in;

    var len: usize = maxlen;
    while (len > 0 and ptr2[0] != 0) : (len -= 1) {
        ptr[0] = ptr2[0];
        ptr += 1;
        ptr2 += 1;
    }

    if (len < 1) return 0;
    ptr[0] = 0;
    return 1;
}

const std = @import("std");
pub fn __psp_path_absolute(in: [*]const u8, out: [*]u8, len: usize) c_int {
    var dr: isize = 0;

    // See what the relative URL starts with
    dr = __psp_get_drive(in);

    if (dr > 0 and in[@as(usize, @intCast(dr))] == '/') {
        //It starts with "drive:/", so it's already absolute
        if (__psp_safe_strcpy(out, in, len) == 0)
            return -1;
    } else if (in[0] == '/') {
        // It's absolute, but missing the drive, so use cwd's drive
        if (strlen(__psp_cwd[0..]) >= len)
            return -2;
        _ = strcpy(out, __psp_cwd[0..]);
        dr = __psp_get_drive(out);
        out[@as(usize, @intCast(dr))] = 0;
        if (__psp_safe_strcat(out, in, len) == 0)
            return -3;
    } else {
        // It's not absolute, so append it to the current cwd
        if (strlen(__psp_cwd[0..]) >= len)
            return -4;
        _ = strcpy(out, __psp_cwd[0..]);

        const stat = __psp_safe_strcat(out, "/", len);
        if (stat == 0) {
            return -6;
        }
        if (__psp_safe_strcat(out, in, len) == 0)
            return -7;
    }

    // Now normalize the pathname portion
    dr = __psp_get_drive(out);
    if (dr < 0) dr = 0;
    return __psp_path_normalize(out + @as(usize, @intCast(dr)), @as(usize, @intCast(@as(isize, @intCast(len)) - dr)));
}

pub fn __psp_get_drive(d: [*]const u8) c_int {
    var i: usize = 0;

    while (d[i] != 0) : (i += 1) {
        if (!((d[i] >= 'a' and d[i] <= 'z') or (d[i] >= '0' and d[i] <= '9')))
            break;
    }
    if (d[i] == ':') return @as(c_int, @intCast(i + 1));
    return -1;
}

pub fn strcpy(destination: ?[*]u8, source: [*]const u8) ?[*]u8 {
    // return if no memory is allocated to the destination
    if (destination == null) {
        return null;
    }

    // take a pointer pointing to the beginning of destination string
    var ptr = destination.?;
    var ptr2 = source;

    // copy the C-string pointed by source into the array
    // pointed by destination
    while (ptr2[0] != 0) {
        ptr[0] = ptr2[0];
        ptr += 1;
        ptr2 += 1;
    }

    // include the terminating null character
    ptr[0] = 0;

    // destination is returned by standard strcpy()
    return ptr;
}

pub fn strlen(s: [*]const u8) usize {
    var i: usize = 0;
    while (s[i] != 0) : (i += 1) {}
    return i;
}

pub fn __psp_safe_strcat(out: [*]u8, in: [*]const u8, maxlen: usize) c_int {
    var len = maxlen;
    var ptr = out;
    while (ptr[0] != 0) : (len -= 1) {
        ptr += 1;
    }

    return __psp_safe_strcpy(ptr, in, len);
}

pub fn __psp_path_normalize(out: [*]u8, len: usize) c_int {
    var i: isize = 0;
    var j: isize = 0;
    var first: usize = 0;
    var next: usize = 0;

    // First append "/" to make the rest easier */
    if (__psp_safe_strcat(out, "/", len) == 0) return -10;

    // Convert "//" to "/" */
    while (out[@as(usize, @intCast(i)) + 1] != 0) : (i += 1) {
        if (out[@as(usize, @intCast(i))] == '/' and out[@as(usize, @intCast(i)) + 1] == '/') {
            j = i + 1;
            while (out[@as(usize, @intCast(j))] != 0) : (j += 1) {
                out[@as(usize, @intCast(j))] = out[@as(usize, @intCast(j + 1))];
            }
            i -= 1;
        }
    }

    // Convert "/./" to "/" */
    i = 0;
    while (out[@as(usize, @intCast(i))] != 0 and out[@as(usize, @intCast(i + 1))] != 0 and out[@as(usize, @intCast(i + 2))] != 0) : (i += 1) {
        if (out[@as(usize, @intCast(i))] == '/' and out[@as(usize, @intCast(i + 1))] == '.' and out[@as(usize, @intCast(i + 2))] == '/') {
            j = i + 1;
            while (out[@as(usize, @intCast(j))] != 0) : (j += 1) {
                out[@as(usize, @intCast(j))] = out[@as(usize, @intCast(j + 2))];
            }
            i -= 1;
        }
    }

    // Convert "/asdf/../" to "/" until we can't anymore.  Also
    // convert leading "/../" to "/" */
    first = 0;
    next = 0;

    while (true) {
        // If a "../" follows, remove it and the parent */
        if (out[next + 1] != 0 and out[next + 1] == '.' and
            out[next + 2] != 0 and out[next + 2] == '.' and
            out[next + 3] != 0 and out[next + 3] == '/')
        {
            j = 0;
            while (out[first + @as(usize, @intCast(j + 1))] != 0) : (j += 1) {
                out[first + @as(usize, @intCast(j + 1))] = out[next + @as(usize, @intCast(j + 4))];
            }
            first = 0;
            next = 0;
            continue;
        }

        // Find next slash */
        first = next;
        next = first + 1;
        while (out[next] != 0 and out[next] != '/') : (next += 1) {
            continue;
        }
        if (out[next] == 0) break;
    }

    // Remove trailing "/" */
    i = 1;
    while (out[@as(usize, @intCast(i))] != 0) : (i += 1) {
        continue;
    }

    if (i >= 1 and out[@as(usize, @intCast(i - 1))] == '/')
        out[@as(usize, @intCast(i - 1))] = 0;

    return 0;
}
