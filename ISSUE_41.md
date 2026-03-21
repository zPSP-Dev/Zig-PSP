# std.Io VTable Implementation Status

Tracking implementation progress for the PSP `std.Io` vtable in `src/utils/Io.zig`.

Only implementable functions are counted — functions that are N/A on PSP (no kernel support, no process model, no async runtime) are listed separately and excluded from totals.

## Summary

| Category | Implemented | Implementable | Progress |
|---|---|---|---|
| Cancellation/Sync | 1 | 1 | 100% |
| Operate (mux I/O) | 2 | 2 | 100% |
| Directory | 17 | 17 | 100% |
| File | 13 | 13 | 100% |
| Stderr | 3 | 3 | 100% |
| Process | 2 | 2 | 100% |
| Time/Random | 5 | 5 | 100% |
| Network | 0 | 13 | 0% |
| **Total** | **43** | **56** | **77%** |

---

## Cancellation/Synchronization (1/1)

- [x] `swapCancelProtection`

## Operate — Multiplexed I/O (2/2)

- [x] `operate(.file_read_streaming)` — `sceIoRead`
- [x] `operate(.file_write_streaming)` — `sceIoWrite`

## Directory (17/17)

- [x] `dirCreateDir` — `sceIoMkdir`
- [x] `dirCreateDirPath` — recursive `sceIoMkdir`
- [x] `dirCreateDirPathOpen` — recursive mkdir + `sceIoDopen`
- [x] `dirOpenDir` — `sceIoDopen`
- [x] `dirStat` — fd→path lookup + `sceIoGetstat`
- [x] `dirStatFile` — `sceIoGetstat`
- [x] `dirAccess` — `sceIoGetstat` (success = accessible)
- [x] `dirCreateFile` — `sceIoOpen` + fd tracking
- [x] `dirOpenFile` — `sceIoOpen` + fd tracking
- [x] `dirClose` — `sceIoDclose`
- [x] `dirRead` — `sceIoDread`
- [x] `dirDeleteFile` — `sceIoRemove`
- [x] `dirDeleteDir` — `sceIoRmdir`
- [x] `dirRename` — `sceIoRename`
- [x] `dirSetPermissions` — no-op (PSP has no meaningful permission model)
- [x] `dirSetFilePermissions` — no-op
- [x] `dirSetTimestamps` — `sceIoChstat` with `ScePspDateTime` conversion

## File (13/13)

- [x] `fileClose` — `sceIoClose` + fd untracking
- [x] `fileStat` — fd→path lookup + `sceIoGetstat`
- [x] `fileLength` — `sceIoLseek` to end and back
- [x] `fileWritePositional` — `sceIoLseek` + `sceIoWrite` + restore
- [x] `fileWriteFileStreaming` — read from `File.Reader` in chunks → `sceIoWrite`
- [x] `fileWriteFilePositional` — seek + read/write loop + restore
- [x] `fileReadPositional` — `sceIoLseek` + `sceIoRead` + restore
- [x] `fileSeekBy` — `sceIoLseek(SEEK_CUR)`
- [x] `fileSeekTo` — `sceIoLseek(SEEK_SET)`
- [x] `fileSync` — `sceIoSync("ms0:", 0)`
- [x] `fileIsTty` — compare fd against stdin/stdout/stderr
- [x] `fileSetPermissions` — no-op
- [x] `fileSetTimestamps` — fd→path + `sceIoChstat` with `ScePspDateTime` conversion

## Stderr (3/3)

- [x] `lockStderr`
- [x] `tryLockStderr`
- [x] `unlockStderr`

## Process (2/2)

- [x] `processCurrentPath` — tracked in module-level buffer (no PSP getcwd syscall)
- [x] `processSetCurrentPath` — `sceIoChdir` + updates tracked cwd

## Time/Random (5/5)

- [x] `now` — `sceRtcGetCurrentTick`, converts PSP epoch (2000-01-01) to Unix epoch nanoseconds
- [x] `clockResolution` — 1 µs (1000 ns) for real/awake/boot clocks
- [x] `sleep` — `sceKernelDelayThread`
- [x] `random` — `sceKernelUtilsMt19937UInt` (lazy-initialized)
- [x] `randomSecure` — same as `random` (PSP has no hardware RNG)

## Network (0/13)

PSP has WiFi networking via `sceNet*` — these are feasible but require the WLAN module to be loaded.

- [ ] `netListenIp`
- [ ] `netAccept`
- [ ] `netBindIp`
- [ ] `netConnectIp`
- [ ] `netSend`
- [ ] `netRead`
- [ ] `netWrite`
- [ ] `netWriteFile`
- [ ] `netClose`
- [ ] `netShutdown`
- [ ] `netInterfaceNameResolve`
- [ ] `netInterfaceName`
- [ ] `netLookup`

---

## N/A on PSP (56 functions — excluded from totals)

<details>
<summary>Click to expand</summary>

### Async/Concurrency (10) — no async runtime on single-core PSP

`crashHandler`, `async`, `concurrent`, `await`, `cancel`, `groupAsync`, `groupConcurrent`, `groupAwait`, `groupCancel`, `recancel`

### Batch (3)

`batchAwaitAsync`, `batchAwaitConcurrent`, `batchCancel`

### Cancellation/Sync (4) — no futex on PSP

`checkCancel`, `futexWait`, `futexWaitUncancelable`, `futexWake`

### Operate (2)

`operate(.device_io_control)`, `operate(.net_receive)`

### Directory (9) — no symlinks, ownership, hard links, realpath, or atomic ops

`dirSymLink`, `dirReadLink`, `dirSetOwner`, `dirSetFileOwner`, `dirHardLink`, `dirRenamePreserve`, `dirCreateFileAtomic`, `dirRealPath`, `dirRealPathFile`

### File (15) — no ANSI codes, locks, ownership, mmap, hard links, realpath, or truncate

`fileEnableAnsiEscapeCodes`, `fileSupportsAnsiEscapeCodes`, `fileSetOwner`, `fileLock`, `fileTryLock`, `fileUnlock`, `fileDowngradeLock`, `fileHardLink`, `fileMemoryMapCreate`, `fileMemoryMapDestroy`, `fileMemoryMapSetLength`, `fileMemoryMapRead`, `fileMemoryMapWrite`, `fileRealPath`, `fileSetLength`

### Process (7) — no process model / no fchdir

`processExecutableOpen`, `processExecutablePath`, `processSetCurrentDir`, `processReplace`, `processReplacePath`, `processSpawn`, `processSpawnPath`

### Child (2) — no child process model

`childWait`, `childKill`

### Network (3) — no Unix sockets

`netListenUnix`, `netConnectUnix`, `netSocketCreatePair`

### Progress (1)

`progressParentFile`

</details>
