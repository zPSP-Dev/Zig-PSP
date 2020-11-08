pub const STDIN_FILENO = 0;
pub const STDOUT_FILENO = 1;
pub const STDERR_FILENO = 2;

pub const timespec = struct {
    tv_sec: isize,
    tv_nsec: isize,
};

pub const fd_t = usize;
pub const ino_t = u64;
pub const mode_t = u32;

pub const PATH_MAX = 1024;

pub const EPERM = 1; // Not super-user
pub const ENOENT = 2; // No such file or directory
pub const ESRCH = 3; // No such process
pub const EINTR = 4; // Interrupted system call
pub const EIO = 5; // I/O error
pub const ENXIO = 6; // No such device or address
pub const E2BIG = 7; // Arg list too long
pub const ENOEXEC = 8; // Exec format error
pub const EBADF = 9; // Bad file number
pub const ECHILD = 10; // No children
pub const EAGAIN = 11; // No more processes
pub const ENOMEM = 12; // Not enough core
pub const EACCES = 13; // Permission denied
pub const EFAULT = 14; // Bad address
pub const ENOTBLK = 15; // Block device required
pub const EBUSY = 16; // Mount device busy
pub const EEXIST = 17; // File exists
pub const EXDEV = 18; // Cross-device link
pub const ENODEV = 19; // No such device
pub const ENOTDIR = 20; // Not a directory
pub const EISDIR = 21; // Is a directory
pub const EINVAL = 22; // Invalid argument
pub const ENFILE = 23; // Too many open files in system
pub const EMFILE = 24; // Too many open files
pub const ENOTTY = 25; // Not a typewriter
pub const ETXTBSY = 26; // Text file busy
pub const EFBIG = 27; // File too large
pub const ENOSPC = 28; // No space left on device
pub const ESPIPE = 29; // Illegal seek
pub const EROFS = 30; // Read only file system
pub const EMLINK = 31; // Too many links
pub const EPIPE = 32; // Broken pipe
pub const EDOM = 33; // Math arg out of domain of func
pub const ERANGE = 34; // Math result not representable
pub const ENOMSG = 35; // No message of desired type
pub const EIDRM = 36; // Identifier removed
pub const ECHRNG = 37; // Channel number out of range
pub const EL2NSYNC = 38; // Level 2 not synchronized
pub const EL3HLT = 39; // Level 3 halted
pub const EL3RST = 40; // Level 3 reset
pub const ELNRNG = 41; // Link number out of range
pub const EUNATCH = 42; // Protocol driver not attached
pub const ENOCSI = 43; // No CSI structure available
pub const EL2HLT = 44; // Level 2 halted
pub const EDEADLK = 45; // Deadlock condition
pub const ENOLCK = 46; // No record locks available
pub const EBADE = 50; // Invalid exchange
pub const EBADR = 51; // Invalid request descriptor
pub const EXFULL = 52; // Exchange full
pub const ENOANO = 53; // No anode
pub const EBADRQC = 54; // Invalid request code
pub const EBADSLT = 55; // Invalid slot
pub const EDEADLOCK = 56; // File locking deadlock error
pub const EBFONT = 57; // Bad font file fmt
pub const ENOSTR = 60; // Device not a stream
pub const ENODATA = 61; // No data (for no delay io)
pub const ETIME = 62; // Timer expired
pub const ENOSR = 63; // Out of streams resources
pub const ENONET = 64; // Machine is not on the network
pub const ENOPKG = 65; // Package not installed
pub const EREMOTE = 66; // The object is remote
pub const ENOLINK = 67; // The link has been severed
pub const EADV = 68; // Advertise error
pub const ESRMNT = 69; // Srmount error
pub const ECOMM = 70; // Communication error on send
pub const EPROTO = 71; // Protocol error
pub const EMULTIHOP = 74; // Multihop attempted
pub const ELBIN = 75; // Inode is remote (not really error)
pub const EDOTDOT = 76; // Cross mount point (not really error)
pub const EBADMSG = 77; // Trying to read unreadable message
pub const EFTYPE = 79; // Inappropriate file type or format
pub const ENOTUNIQ = 80; // Given log. name not unique
pub const EBADFD = 81; // f.d. invalid for this operation
pub const EREMCHG = 82; // Remote address changed
pub const ELIBACC = 83; // Can't access a needed shared lib
pub const ELIBBAD = 84; // Accessing a corrupted shared lib
pub const ELIBSCN = 85; // .lib section in a.out corrupted
pub const ELIBMAX = 86; // Attempting to link in too many libs
pub const ELIBEXEC = 87; // Attempting to exec a shared library
pub const ENOSYS = 88; // Function not implemented
pub const ENMFILE = 89; // No more files
pub const ENOTEMPTY = 90; // Directory not empty
pub const ENAMETOOLONG = 91; // File or path name too long
pub const ELOOP = 92; // Too many symbolic links
pub const EOPNOTSUPP = 95; // Operation not supported on transport endpoint
pub const EPFNOSUPPORT = 96; // Protocol family not supported
pub const ECONNRESET = 104; // Connection reset by peer
pub const ENOBUFS = 105; // No buffer space available
pub const EAFNOSUPPORT = 106; // Address family not supported by protocol family
pub const EPROTOTYPE = 107; // Protocol wrong type for socket
pub const ENOTSOCK = 108; // Socket operation on non-socket
pub const ENOPROTOOPT = 109; // Protocol not available
pub const ESHUTDOWN = 110; // Can't send after socket shutdown
pub const ECONNREFUSED = 111; // Connection refused
pub const EADDRINUSE = 112; // Address already in use
pub const ECONNABORTED = 113; // Connection aborted
pub const ENETUNREACH = 114; // Network is unreachable
pub const ENETDOWN = 115; // Network interface is not configured
pub const ETIMEDOUT = 116; // Connection timed out
pub const EHOSTDOWN = 117; // Host is down
pub const EHOSTUNREACH = 118; // Host is unreachable
pub const EINPROGRESS = 119; // Connection already in progress
pub const EALREADY = 120; // Socket already connected
pub const EDESTADDRREQ = 121; // Destination address required
pub const EMSGSIZE = 122; // Message too long
pub const EPROTONOSUPPORT = 123; // Unknown protocol
pub const ESOCKTNOSUPPORT = 124; // Socket type not supported
pub const EADDRNOTAVAIL = 125; // Address not available
pub const ENETRESET = 126;
pub const EISCONN = 127; // Socket is already connected
pub const ENOTCONN = 128; // Socket is not connected
pub const ETOOMANYREFS = 129;
pub const EPROCLIM = 130;
pub const EUSERS = 131;
pub const EDQUOT = 132;
pub const ESTALE = 133;
pub const ENOTSUP = 134; // Not supported
pub const ENOMEDIUM = 135; // No medium (in tape drive)
pub const ENOSHARE = 136; // No such host or network path
pub const ECASECLASH = 137; // Filename exists with different case
pub const EILSEQ = 138;
pub const EOVERFLOW = 139; // Value too large for defined data type

// From cygwin32.
pub const EWOULDBLOCK = EAGAIN; // Operation would block

pub const __ELASTERROR = 2000; // Users can add values starting here

pub const CLOCK_REALTIME = 0;
pub const CLOCK_MONOTONIC = 1;
pub const CLOCK_PROCESS_CPUTIME_ID = 2;
pub const CLOCK_THREAD_CPUTIME_ID = 3;
pub const CLOCK_MONOTONIC_RAW = 4;
pub const CLOCK_REALTIME_COARSE = 5;
pub const CLOCK_MONOTONIC_COARSE = 6;
pub const CLOCK_BOOTTIME = 7;
pub const CLOCK_REALTIME_ALARM = 8;
pub const CLOCK_BOOTTIME_ALARM = 9;
pub const CLOCK_SGI_CYCLE = 10;
pub const CLOCK_TAI = 11;

pub const O_TRUNC = 0x0400;
pub const O_RDWR = O_RDONLY | O_WRONLY;
pub const SEEK_END = 2;
pub const O_EXCL = 0x0800;
pub const O_RDONLY = 0x0001;
pub const O_NBLOCK = 0x0004;
pub const SEEK_CUR = 1;
pub const O_DIROPEN = 0x0008;
pub const O_CREAT = 0x0200;
pub const O_WRONLY = 0x0002;
pub const O_NOWAIT = 0x8000;
pub const SEEK_SET = 0;
pub const O_APPEND = 0x0100;
pub const O_CLOEXEC = 0; //Don't do anything
pub const O_NOCTTY = 0; //Don't do anything
pub const R_OK = 1;
pub const W_OK = 1;
pub const F_OK = 1;
pub const X_OK = 1;

pub const LOCK_SH = 1;
pub const LOCK_EX = 2;
pub const LOCK_UN = 8;
pub const LOCK_NB = 4;

/// Special value used to indicate openat should use the current working directory
pub const AT_FDCWD = 0x1234;

/// Do not follow symbolic links
pub const AT_SYMLINK_NOFOLLOW = 0x100;

/// Remove directory instead of unlinking file
pub const AT_REMOVEDIR = 0x200;

/// Follow symbolic links.
pub const AT_SYMLINK_FOLLOW = 0x400;

/// Suppress terminal automount traversal
pub const AT_NO_AUTOMOUNT = 0x800;

/// Allow empty relative pathname
pub const AT_EMPTY_PATH = 0x1000;

/// Type of synchronisation required from statx()
pub const AT_STATX_SYNC_TYPE = 0x6000;

/// - Do whatever stat() does
pub const AT_STATX_SYNC_AS_STAT = 0x0000;

/// - Force the attributes to be sync'd with the server
pub const AT_STATX_FORCE_SYNC = 0x2000;

/// - Don't sync attributes with the server
pub const AT_STATX_DONT_SYNC = 0x4000;

/// Apply to the entire subtree
pub const AT_RECURSIVE = 0x8000;

usingnamespace @import("../sdk/pspiofilemgr.zig");
usingnamespace @import("../sdk/psptypes.zig");
pub const Stat = struct {
    mode: u32,
    st_attr: c_uint,
    size: u64,
    st_ctime: ScePspDateTime,
    st_atime: ScePspDateTime,
    st_mtime: ScePspDateTime,
    st_private: [6]c_uint,
    ino: ino_t,

    pub fn atime(self: Stat) timespec {
        return timespec{ .tv_sec = self.st_atime.second, .tv_nsec = @bitCast(isize, self.st_atime.microsecond) * 1000 };
    }
    pub fn mtime(self: Stat) timespec {
        return timespec{ .tv_sec = self.st_mtime.second, .tv_nsec = @bitCast(isize, self.st_mtime.microsecond) * 1000 };
    }
    pub fn ctime(self: Stat) timespec {
        return timespec{ .tv_sec = self.st_ctime.second, .tv_nsec = @bitCast(isize, self.st_ctime.microsecond) * 1000 };
    }
};

pub const S_IFBLK = 524288;
pub const S_IFCHR = 262144;
pub const S_IFIFO = 131072;
pub const S_IFSOCK = 65536;
pub const S_IFMT = 61440;
pub const S_IFLNK = 16384;
pub const S_IFDIR = 4096;
pub const S_IFREG = 8192;
pub const S_ISUID = 2048;
pub const S_ISGID = 1024;
pub const S_ISVTX = 512;
pub const S_IRWXU = 448;
pub const S_IRUSR = 256;
pub const S_IWUSR = 128;
pub const S_IXUSR = 64;
pub const S_IRWXG = 56;
pub const S_IRGRP = 32;
pub const S_IWGRP = 16;
pub const S_IXGRP = 8;
pub const S_IRWXO = 7;
pub const S_IROTH = 4;
pub const S_IWOTH = 2;
pub const S_IXOTH = 1;
