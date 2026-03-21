# std.Io VTable Implementation Status

Tracking implementation progress for the PSP `std.Io` vtable in `src/utils/Io.zig`.

## Summary

| Category | Implemented | Total | Progress |
|---|---|---|---|
| Async/Concurrency | 0 | 10 | 0% |
| Cancellation/Sync | 1 | 5 | 20% |
| Operate (mux I/O) | 2 | 4 | 50% |
| Batch | 0 | 3 | 0% |
| Directory | 6 | 26 | 23% |
| File | 1 | 28 | 4% |
| Stderr | 3 | 3 | 100% |
| Process | 0 | 9 | 0% |
| Child | 0 | 2 | 0% |
| Time/Random | 0 | 5 | 0% |
| Progress | 0 | 1 | 0% |
| Network | 0 | 16 | 0% |
| **Total** | **13** | **112** | **12%** |

---

## Async/Concurrency (0/10)

- [ ] `crashHandler`
- [ ] `async`
- [ ] `concurrent`
- [ ] `await`
- [ ] `cancel`
- [ ] `groupAsync`
- [ ] `groupConcurrent`
- [ ] `groupAwait`
- [ ] `groupCancel`
- [ ] `recancel`

## Cancellation/Synchronization (1/5)

- [x] `swapCancelProtection`
- [ ] `checkCancel`
- [ ] `futexWait`
- [ ] `futexWaitUncancelable`
- [ ] `futexWake`

## Operate — Multiplexed I/O (2/4)

- [x] `operate(.file_read_streaming)` — `sceIoRead`
- [x] `operate(.file_write_streaming)` — `sceIoWrite`
- [ ] `operate(.device_io_control)`
- [ ] `operate(.net_receive)`

## Batch (0/3)

- [ ] `batchAwaitAsync`
- [ ] `batchAwaitConcurrent`
- [ ] `batchCancel`

## Directory (6/26)

### Implemented

- [x] `dirCreateDir` — `sceIoMkdir`
- [x] `dirOpenDir` — `sceIoDopen`
- [x] `dirCreateFile` — `sceIoOpen`
- [x] `dirOpenFile` — `sceIoOpen`
- [x] `dirClose` — `sceIoDclose`
- [x] `dirRead` — `sceIoDread`

### Unimplemented — feasible on PSP

- [ ] `dirCreateDirPath` — recursive mkdir via `sceIoMkdir`
- [ ] `dirCreateDirPathOpen` — mkdir + dopen
- [ ] `dirStat` — `sceIoGetstat`
- [ ] `dirStatFile` — `sceIoGetstat`
- [ ] `dirAccess` — `sceIoGetstat`
- [ ] `dirCreateFileAtomic` — write-to-temp + rename
- [ ] `dirRealPath`
- [ ] `dirRealPathFile`
- [ ] `dirDeleteFile` — `sceIoRemove`
- [ ] `dirDeleteDir` — `sceIoRmdir`
- [ ] `dirRename` — `sceIoRename`
- [ ] `dirRenamePreserve`
- [ ] `dirSetPermissions` — `sceIoChstat`
- [ ] `dirSetFilePermissions` — `sceIoChstat`
- [ ] `dirSetTimestamps` — `sceIoChstat`

### Unimplemented — N/A on PSP (no kernel support)

- [ ] `dirSymLink`
- [ ] `dirReadLink`
- [ ] `dirSetOwner`
- [ ] `dirSetFileOwner`
- [ ] `dirHardLink`

## File (1/28)

### Implemented

- [x] `fileClose` — `sceIoClose`

### Unimplemented — feasible on PSP

- [ ] `fileStat` — `sceIoGetstat`
- [ ] `fileLength` — `sceIoLseek` to end
- [ ] `fileWritePositional` — `sceIoLseek` + `sceIoWrite`
- [ ] `fileWriteFileStreaming` — read/write loop
- [ ] `fileWriteFilePositional` — seek + read/write loop
- [ ] `fileReadPositional` — `sceIoLseek` + `sceIoRead`
- [ ] `fileSeekBy` — `sceIoLseek` (SEEK_CUR)
- [ ] `fileSeekTo` — `sceIoLseek` (SEEK_SET)
- [ ] `fileSync` — `sceIoSync`
- [ ] `fileIsTty` — check against stdin/stdout/stderr fds
- [ ] `fileSetLength` — `sceIoLseek` + truncate
- [ ] `fileSetPermissions` — `sceIoChstat`
- [ ] `fileSetTimestamps` — `sceIoChstat`
- [ ] `fileRealPath`

### Unimplemented — N/A on PSP (no kernel support)

- [ ] `fileEnableAnsiEscapeCodes`
- [ ] `fileSupportsAnsiEscapeCodes`
- [ ] `fileSetOwner`
- [ ] `fileLock`
- [ ] `fileTryLock`
- [ ] `fileUnlock`
- [ ] `fileDowngradeLock`
- [ ] `fileHardLink`
- [ ] `fileMemoryMapCreate`
- [ ] `fileMemoryMapDestroy`
- [ ] `fileMemoryMapSetLength`
- [ ] `fileMemoryMapRead`
- [ ] `fileMemoryMapWrite`

## Stderr (3/3)

- [x] `lockStderr`
- [x] `tryLockStderr`
- [x] `unlockStderr`

## Process (0/9)

All N/A — PSP has no process model. Could stub `processCurrentPath` with `sceIoGetThreadCwd`.

- [ ] `processExecutableOpen`
- [ ] `processExecutablePath`
- [ ] `processCurrentPath` — `sceIoGetThreadCwd`
- [ ] `processSetCurrentDir` — `sceIoChdir`
- [ ] `processSetCurrentPath` — `sceIoChdir`
- [ ] `processReplace`
- [ ] `processReplacePath`
- [ ] `processSpawn`
- [ ] `processSpawnPath`

## Child (0/2)

N/A — PSP has no child process model.

- [ ] `childWait`
- [ ] `childKill`

## Time/Random (0/5)

- [ ] `now` — `sceRtcGetCurrentTick`
- [ ] `clockResolution` — `sceRtcGetTickResolution`
- [ ] `sleep` — `sceKernelDelayThread`
- [ ] `random` — `sceKernelUtilsMt19937UInt`
- [ ] `randomSecure` — no hardware RNG; could use MT19937

## Progress (0/1)

- [ ] `progressParentFile`

## Network (0/16)

PSP has WiFi networking via `sceNet*` — these are feasible but require the WLAN module to be loaded.

- [ ] `netListenIp`
- [ ] `netAccept`
- [ ] `netBindIp`
- [ ] `netConnectIp`
- [ ] `netListenUnix` — N/A
- [ ] `netConnectUnix` — N/A
- [ ] `netSocketCreatePair` — N/A
- [ ] `netSend`
- [ ] `netRead`
- [ ] `netWrite`
- [ ] `netWriteFile`
- [ ] `netClose`
- [ ] `netShutdown`
- [ ] `netInterfaceNameResolve`
- [ ] `netInterfaceName`
- [ ] `netLookup`
