// Tier 1: Raw C stub bindings
pub const c = @import("c/modules.zig");

// GU types promoted to top level
const _pspgutypes = @import("sdk/pspgutypes.zig");
pub const GuPixelFormat = _pspgutypes.GuPixelFormat;
pub const GuPrimitive = _pspgutypes.GuPrimitive;
pub const GuClutMode = _pspgutypes.GuClutMode;
pub const GuTextureDataLayout = _pspgutypes.GuTextureDataLayout;
pub const PatchPrimitive = _pspgutypes.PatchPrimitive;
pub const GuState = _pspgutypes.GuState;
pub const MatrixMode = _pspgutypes.MatrixMode;
pub const SplineMode = _pspgutypes.SplineMode;
pub const ShadeModel = _pspgutypes.ShadeModel;
pub const GuLogicalOperation = _pspgutypes.GuLogicalOperation;
pub const TextureFilter = _pspgutypes.TextureFilter;
pub const TextureMapMode = _pspgutypes.TextureMapMode;
pub const TextureLevelMode = _pspgutypes.TextureLevelMode;
pub const TextureProjectionMapMode = _pspgutypes.TextureProjectionMapMode;
pub const GuTexWrapMode = _pspgutypes.GuTexWrapMode;
pub const FrontFaceDirection = _pspgutypes.FrontFaceDirection;
pub const AlphaFunc = _pspgutypes.AlphaFunc;
pub const StencilFunc = _pspgutypes.StencilFunc;
pub const ColorFunc = _pspgutypes.ColorFunc;
pub const DepthFunc = _pspgutypes.DepthFunc;
pub const TextureEffect = _pspgutypes.TextureEffect;
pub const TextureColorComponent = _pspgutypes.TextureColorComponent;
pub const MipmapLevel = _pspgutypes.MipmapLevel;
pub const BlendOp = _pspgutypes.BlendOp;
pub const BlendFactor = _pspgutypes.BlendFactor;
pub const StencilOperation = _pspgutypes.StencilOperation;
pub const LightMode = _pspgutypes.LightMode;
pub const GuLightType = _pspgutypes.GuLightType;
pub const GuContextType = _pspgutypes.GuContextType;
pub const GuQueueMode = _pspgutypes.GuQueueMode;
pub const GuSyncMode = _pspgutypes.GuSyncMode;
pub const GuCallbackId = _pspgutypes.GuCallbackId;
pub const GuSignalBehavior = _pspgutypes.GuSignalBehavior;
pub const ClearBitFlags = _pspgutypes.ClearBitFlags;
pub const GuLightBitFlags = _pspgutypes.GuLightBitFlags;
pub const VertexType = _pspgutypes.VertexType;

// Shared PSP types promoted to top level
const _types = @import("c/types.zig");
pub const SceBool = _types.SceBool;
pub const SceUID = _types.SceUID;
pub const SceMode = _types.SceMode;
pub const SceIores = _types.SceIores;
pub const ScePspFVector2 = _types.ScePspFVector2;
pub const ScePspFVector3 = _types.ScePspFVector3;
pub const ScePspFVector4 = _types.ScePspFVector4;
pub const ScePspIVector2 = _types.ScePspIVector2;
pub const ScePspIVector3 = _types.ScePspIVector3;
pub const ScePspIVector4 = _types.ScePspIVector4;
pub const ScePspFMatrix4 = _types.ScePspFMatrix4;
pub const ScePspIMatrix4 = _types.ScePspIMatrix4;
pub const ScePspDateTime = _types.ScePspDateTime;

// Tier 2: Top-level sce-prefix re-exports
const _pspgu = @import("sdk/pspgu.zig");
pub const sceGuInit = _pspgu.sceGuInit;
pub const sceGuTerm = _pspgu.sceGuTerm;
pub const sceGuStart = _pspgu.sceGuStart;
pub const sceGuFinish = _pspgu.sceGuFinish;
pub const sceGuFinishId = _pspgu.sceGuFinishId;
pub const sceGuSync = _pspgu.sceGuSync;
pub const guFinish = _pspgu.guFinish;
pub const guSync = _pspgu.guSync;
pub const guSwapBuffers = _pspgu.guSwapBuffers;
pub const guSwapBuffersBehaviour = _pspgu.guSwapBuffersBehaviour;
pub const guSwapBuffersCallback = _pspgu.guSwapBuffersCallback;
pub const sceGuSendList = _pspgu.sceGuSendList;
pub const sceGuCallList = _pspgu.sceGuCallList;
pub const sceGuCallMode = _pspgu.sceGuCallMode;
pub const sceGuCheckList = _pspgu.sceGuCheckList;
pub const sceGuGetMemory = _pspgu.sceGuGetMemory;
pub const sceGuDrawBuffer = _pspgu.sceGuDrawBuffer;
pub const sceGuDrawBufferList = _pspgu.sceGuDrawBufferList;
pub const sceGuDispBuffer = _pspgu.sceGuDispBuffer;
pub const sceGuDepthBuffer = _pspgu.sceGuDepthBuffer;
pub const sceGuDisplay = _pspgu.sceGuDisplay;
pub const sceGuSwapBuffers = _pspgu.sceGuSwapBuffers;
pub const sceGuSetCallback = _pspgu.sceGuSetCallback;
pub const sceGuOffset = _pspgu.sceGuOffset;
pub const sceGuViewport = _pspgu.sceGuViewport;
pub const sceGuScissor = _pspgu.sceGuScissor;
pub const sceGuDepthRange = _pspgu.sceGuDepthRange;
pub const sceGuDepthOffset = _pspgu.sceGuDepthOffset;
pub const sceGuEnable = _pspgu.sceGuEnable;
pub const sceGuDisable = _pspgu.sceGuDisable;
pub const sceGuSetStatus = _pspgu.sceGuSetStatus;
pub const sceGuGetStatus = _pspgu.sceGuGetStatus;
pub const sceGuSetAllStatus = _pspgu.sceGuSetAllStatus;
pub const sceGuGetAllStatus = _pspgu.sceGuGetAllStatus;
pub const sceGuClear = _pspgu.sceGuClear;
pub const sceGuClearColor = _pspgu.sceGuClearColor;
pub const sceGuClearDepth = _pspgu.sceGuClearDepth;
pub const sceGuClearStencil = _pspgu.sceGuClearStencil;
pub const sceGuDrawArray = _pspgu.sceGuDrawArray;
pub const sceGuDrawArrayN = _pspgu.sceGuDrawArrayN;
pub const sceGuDrawBezier = _pspgu.sceGuDrawBezier;
pub const sceGuDrawSpline = _pspgu.sceGuDrawSpline;
pub const sceGuBeginObject = _pspgu.sceGuBeginObject;
pub const sceGuEndObject = _pspgu.sceGuEndObject;
pub const sceGuDepthFunc = _pspgu.sceGuDepthFunc;
pub const sceGuDepthMask = _pspgu.sceGuDepthMask;
pub const sceGuFrontFace = _pspgu.sceGuFrontFace;
pub const sceGuShadeModel = _pspgu.sceGuShadeModel;
pub const sceGuFog = _pspgu.sceGuFog;
pub const sceGuPixelMask = _pspgu.sceGuPixelMask;
pub const sceGuLogicalOp = _pspgu.sceGuLogicalOp;
pub const sceGuAlphaFunc = _pspgu.sceGuAlphaFunc;
pub const sceGuStencilFunc = _pspgu.sceGuStencilFunc;
pub const sceGuStencilOp = _pspgu.sceGuStencilOp;
pub const sceGuBlendFunc = _pspgu.sceGuBlendFunc;
pub const sceGuColorFunc = _pspgu.sceGuColorFunc;
pub const sceGuColorMaterial = _pspgu.sceGuColorMaterial;
pub const sceGuColor = _pspgu.sceGuColor;
pub const sceGuAmbient = _pspgu.sceGuAmbient;
pub const sceGuAmbientColor = _pspgu.sceGuAmbientColor;
pub const sceGuMaterial = _pspgu.sceGuMaterial;
pub const sceGuModelColor = _pspgu.sceGuModelColor;
pub const sceGuSpecular = _pspgu.sceGuSpecular;
pub const sceGuLight = _pspgu.sceGuLight;
pub const sceGuLightAtt = _pspgu.sceGuLightAtt;
pub const sceGuLightColor = _pspgu.sceGuLightColor;
pub const sceGuLightMode = _pspgu.sceGuLightMode;
pub const sceGuLightSpot = _pspgu.sceGuLightSpot;
pub const sceGuMorphWeight = _pspgu.sceGuMorphWeight;
pub const sceGuTexMode = _pspgu.sceGuTexMode;
pub const sceGuTexImage = _pspgu.sceGuTexImage;
pub const sceGuTexFunc = _pspgu.sceGuTexFunc;
pub const sceGuTexFilter = _pspgu.sceGuTexFilter;
pub const sceGuTexScale = _pspgu.sceGuTexScale;
pub const sceGuTexOffset = _pspgu.sceGuTexOffset;
pub const sceGuTexWrap = _pspgu.sceGuTexWrap;
pub const sceGuTexFlush = _pspgu.sceGuTexFlush;
pub const sceGuTexSync = _pspgu.sceGuTexSync;
pub const sceGuTexEnvColor = _pspgu.sceGuTexEnvColor;
pub const sceGuTexLevelMode = _pspgu.sceGuTexLevelMode;
pub const sceGuTexMapMode = _pspgu.sceGuTexMapMode;
pub const sceGuTexProjMapMode = _pspgu.sceGuTexProjMapMode;
pub const sceGuTexSlope = _pspgu.sceGuTexSlope;
pub const sceGuClutLoad = _pspgu.sceGuClutLoad;
pub const sceGuClutMode = _pspgu.sceGuClutMode;
pub const sceGuCopyImage = _pspgu.sceGuCopyImage;
pub const sceGuSetDither = _pspgu.sceGuSetDither;
pub const sceGuSetMatrix = _pspgu.sceGuSetMatrix;
pub const sceGuPatchDivide = _pspgu.sceGuPatchDivide;
pub const sceGuPatchFrontFace = _pspgu.sceGuPatchFrontFace;
pub const sceGuPatchPrim = _pspgu.sceGuPatchPrim;
pub const sceGuSignal = _pspgu.sceGuSignal;
pub const sceGuBreak = _pspgu.sceGuBreak;
pub const sceGuContinue = _pspgu.sceGuContinue;

const _pspgum = @import("sdk/pspgum.zig");
pub const sceGumMatrixMode = _pspgum.sceGumMatrixMode;
pub const sceGumLoadIdentity = _pspgum.sceGumLoadIdentity;
pub const sceGumLoadMatrix = _pspgum.sceGumLoadMatrix;
pub const sceGumStoreMatrix = _pspgum.sceGumStoreMatrix;
pub const sceGumPushMatrix = _pspgum.sceGumPushMatrix;
pub const sceGumPopMatrix = _pspgum.sceGumPopMatrix;
pub const sceGumMultMatrix = _pspgum.sceGumMultMatrix;
pub const sceGumUpdateMatrix = _pspgum.sceGumUpdateMatrix;
pub const sceGumRotateX = _pspgum.sceGumRotateX;
pub const sceGumRotateY = _pspgum.sceGumRotateY;
pub const sceGumRotateZ = _pspgum.sceGumRotateZ;
pub const sceGumRotateXYZ = _pspgum.sceGumRotateXYZ;
pub const sceGumRotateZYX = _pspgum.sceGumRotateZYX;
pub const sceGumScale = _pspgum.sceGumScale;
pub const sceGumTranslate = _pspgum.sceGumTranslate;
pub const sceGumOrtho = _pspgum.sceGumOrtho;
pub const sceGumPerspective = _pspgum.sceGumPerspective;
pub const sceGumFullInverse = _pspgum.sceGumFullInverse;
pub const sceGumFastInverse = _pspgum.sceGumFastInverse;
pub const sceGumDrawArray = _pspgum.sceGumDrawArray;
pub const sceGumDrawArrayN = _pspgum.sceGumDrawArrayN;
pub const sceGumDrawBezier = _pspgum.sceGumDrawBezier;
pub const sceGumDrawSpline = _pspgum.sceGumDrawSpline;

const _pspge = @import("sdk/pspge.zig");
pub const sceGeEdramGetSize = _pspge.sceGeEdramGetSize;
pub const sceGeEdramGetAddr = _pspge.sceGeEdramGetAddr;
pub const sceGeEdramSetAddrTranslation = _pspge.sceGeEdramSetAddrTranslation;
pub const sceGeGetCmd = _pspge.sceGeGetCmd;
pub const sceGeGetMtx = _pspge.sceGeGetMtx;
pub const sceGeGetStack = _pspge.sceGeGetStack;
pub const sceGeSaveContext = _pspge.sceGeSaveContext;
pub const sceGeRestoreContext = _pspge.sceGeRestoreContext;
pub const sceGeListEnQueue = _pspge.sceGeListEnQueue;
pub const sceGeListEnQueueHead = _pspge.sceGeListEnQueueHead;
pub const sceGeListDeQueue = _pspge.sceGeListDeQueue;
pub const sceGeListUpdateStallAddr = _pspge.sceGeListUpdateStallAddr;
pub const sceGeListSync = _pspge.sceGeListSync;
pub const sceGeDrawSync = _pspge.sceGeDrawSync;
pub const sceGeBreak = _pspge.sceGeBreak;
pub const sceGeContinue = _pspge.sceGeContinue;
pub const sceGeSetCallback = _pspge.sceGeSetCallback;
pub const sceGeUnsetCallback = _pspge.sceGeUnsetCallback;

const _pspctrl = @import("sdk/pspctrl.zig");
pub const sceCtrlSetSamplingCycle = _pspctrl.sceCtrlSetSamplingCycle;
pub const sceCtrlGetSamplingCycle = _pspctrl.sceCtrlGetSamplingCycle;
pub const sceCtrlSetSamplingMode = _pspctrl.sceCtrlSetSamplingMode;
pub const sceCtrlGetSamplingMode = _pspctrl.sceCtrlGetSamplingMode;
pub const sceCtrlPeekBufferPositive = _pspctrl.sceCtrlPeekBufferPositive;
pub const sceCtrlPeekBufferNegative = _pspctrl.sceCtrlPeekBufferNegative;
pub const sceCtrlReadBufferPositive = _pspctrl.sceCtrlReadBufferPositive;
pub const sceCtrlReadBufferNegative = _pspctrl.sceCtrlReadBufferNegative;
pub const sceCtrlPeekLatch = _pspctrl.sceCtrlPeekLatch;
pub const sceCtrlReadLatch = _pspctrl.sceCtrlReadLatch;
pub const sceCtrlSetIdleCancelThreshold = _pspctrl.sceCtrlSetIdleCancelThreshold;
pub const sceCtrlGetIdleCancelThreshold = _pspctrl.sceCtrlGetIdleCancelThreshold;

const _pspdisplay = @import("sdk/pspdisplay.zig");
pub const sceDisplaySetMode = _pspdisplay.sceDisplaySetMode;
pub const sceDisplayGetMode = _pspdisplay.sceDisplayGetMode;
pub const sceDisplayGetFramePerSec = _pspdisplay.sceDisplayGetFramePerSec;
pub const sceDisplaySetHoldMode = _pspdisplay.sceDisplaySetHoldMode;
pub const sceDisplaySetResumeMode = _pspdisplay.sceDisplaySetResumeMode;
pub const sceDisplaySetFrameBuf = _pspdisplay.sceDisplaySetFrameBuf;
pub const sceDisplayGetFrameBuf = _pspdisplay.sceDisplayGetFrameBuf;
pub const sceDisplayIsForeground = _pspdisplay.sceDisplayIsForeground;
pub const sceDisplayGetVcount = _pspdisplay.sceDisplayGetVcount;
pub const sceDisplayIsVblank = _pspdisplay.sceDisplayIsVblank;
pub const sceDisplayWaitVblank = _pspdisplay.sceDisplayWaitVblank;
pub const sceDisplayWaitVblankCB = _pspdisplay.sceDisplayWaitVblankCB;
pub const sceDisplayWaitVblankStart = _pspdisplay.sceDisplayWaitVblankStart;
pub const sceDisplayWaitVblankStartCB = _pspdisplay.sceDisplayWaitVblankStartCB;
pub const sceDisplayGetCurrentHcount = _pspdisplay.sceDisplayGetCurrentHcount;
pub const sceDisplayGetAccumulatedHcount = _pspdisplay.sceDisplayGetAccumulatedHcount;

const _psploadexec = @import("sdk/psploadexec.zig");
pub const sceKernelLoadExec = _psploadexec.sceKernelLoadExec;
pub const sceKernelExitGame = _psploadexec.sceKernelExitGame;
pub const sceKernelExitGameWithStatus = _psploadexec.sceKernelExitGameWithStatus;
pub const sceKernelRegisterExitCallback = _psploadexec.sceKernelRegisterExitCallback;

const _pspthreadman = @import("sdk/pspthreadman.zig");
pub const sceKernelCreateCallback = _pspthreadman.sceKernelCreateCallback;
pub const sceKernelDeleteCallback = _pspthreadman.sceKernelDeleteCallback;
pub const sceKernelNotifyCallback = _pspthreadman.sceKernelNotifyCallback;
pub const sceKernelCancelCallback = _pspthreadman.sceKernelCancelCallback;
pub const sceKernelGetCallbackCount = _pspthreadman.sceKernelGetCallbackCount;
pub const sceKernelCheckCallback = _pspthreadman.sceKernelCheckCallback;
pub const sceKernelReferCallbackStatus = _pspthreadman.sceKernelReferCallbackStatus;
pub const sceKernelSleepThread = _pspthreadman.sceKernelSleepThread;
pub const sceKernelSleepThreadCB = _pspthreadman.sceKernelSleepThreadCB;
pub const sceKernelWakeupThread = _pspthreadman.sceKernelWakeupThread;
pub const sceKernelCancelWakeupThread = _pspthreadman.sceKernelCancelWakeupThread;
pub const sceKernelSuspendThread = _pspthreadman.sceKernelSuspendThread;
pub const sceKernelResumeThread = _pspthreadman.sceKernelResumeThread;
pub const sceKernelWaitThreadEnd = _pspthreadman.sceKernelWaitThreadEnd;
pub const sceKernelWaitThreadEndCB = _pspthreadman.sceKernelWaitThreadEndCB;
pub const sceKernelDelayThread = _pspthreadman.sceKernelDelayThread;
pub const sceKernelDelayThreadCB = _pspthreadman.sceKernelDelayThreadCB;
pub const sceKernelCreateSema = _pspthreadman.sceKernelCreateSema;
pub const sceKernelDeleteSema = _pspthreadman.sceKernelDeleteSema;
pub const sceKernelSignalSema = _pspthreadman.sceKernelSignalSema;
pub const sceKernelWaitSema = _pspthreadman.sceKernelWaitSema;
pub const sceKernelWaitSemaCB = _pspthreadman.sceKernelWaitSemaCB;
pub const sceKernelPollSema = _pspthreadman.sceKernelPollSema;
pub const sceKernelCreateEventFlag = _pspthreadman.sceKernelCreateEventFlag;
pub const sceKernelDeleteEventFlag = _pspthreadman.sceKernelDeleteEventFlag;
pub const sceKernelSetEventFlag = _pspthreadman.sceKernelSetEventFlag;
pub const sceKernelClearEventFlag = _pspthreadman.sceKernelClearEventFlag;
pub const sceKernelWaitEventFlag = _pspthreadman.sceKernelWaitEventFlag;
pub const sceKernelWaitEventFlagCB = _pspthreadman.sceKernelWaitEventFlagCB;
pub const sceKernelPollEventFlag = _pspthreadman.sceKernelPollEventFlag;

const _pspsysmem = @import("sdk/pspsysmem.zig");
pub const sceKernelMaxFreeMemSize = _pspsysmem.sceKernelMaxFreeMemSize;
pub const sceKernelTotalFreeMemSize = _pspsysmem.sceKernelTotalFreeMemSize;
pub const sceKernelAllocPartitionMemory = _pspsysmem.sceKernelAllocPartitionMemory;
pub const sceKernelFreePartitionMemory = _pspsysmem.sceKernelFreePartitionMemory;
pub const sceKernelGetBlockHeadAddr = _pspsysmem.sceKernelGetBlockHeadAddr;
pub const sceKernelDevkitVersion = _pspsysmem.sceKernelDevkitVersion;
pub const sceKernelPrintf = _pspsysmem.sceKernelPrintf;

const _pspmodulemgr = @import("sdk/pspmodulemgr.zig");
pub const sceKernelLoadModule = _pspmodulemgr.sceKernelLoadModule;
pub const sceKernelLoadModuleMs = _pspmodulemgr.sceKernelLoadModuleMs;
pub const sceKernelLoadModuleByID = _pspmodulemgr.sceKernelLoadModuleByID;
pub const sceKernelStartModule = _pspmodulemgr.sceKernelStartModule;
pub const sceKernelStopModule = _pspmodulemgr.sceKernelStopModule;
pub const sceKernelUnloadModule = _pspmodulemgr.sceKernelUnloadModule;
pub const sceKernelSelfStopUnloadModule = _pspmodulemgr.sceKernelSelfStopUnloadModule;
pub const sceKernelStopUnloadSelfModule = _pspmodulemgr.sceKernelStopUnloadSelfModule;
pub const sceKernelQueryModuleInfo = _pspmodulemgr.sceKernelQueryModuleInfo;
pub const sceKernelGetModuleIdList = _pspmodulemgr.sceKernelGetModuleIdList;
pub const sceKernelGetModuleIdByAddress = _pspmodulemgr.sceKernelGetModuleIdByAddress;

const _pspaudio = @import("sdk/pspaudio.zig");
pub const sceAudioChReserve = _pspaudio.sceAudioChReserve;
pub const sceAudioChRelease = _pspaudio.sceAudioChRelease;
pub const sceAudioOutput = _pspaudio.sceAudioOutput;
pub const sceAudioOutputBlocking = _pspaudio.sceAudioOutputBlocking;

const _pspatrac3 = @import("sdk/pspatrac3.zig");
pub const sceAtracGetAtracID = _pspatrac3.sceAtracGetAtracID;
pub const sceAtracSetDataAndGetID = _pspatrac3.sceAtracSetDataAndGetID;

const _psprtc = @import("sdk/psprtc.zig");
pub const sceRtcGetTickResolution = _psprtc.sceRtcGetTickResolution;
pub const sceRtcGetCurrentTick = _psprtc.sceRtcGetCurrentTick;
pub const sceRtcGetCurrentClock = _psprtc.sceRtcGetCurrentClock;
pub const sceRtcGetCurrentClockLocalTime = _psprtc.sceRtcGetCurrentClockLocalTime;
pub const sceRtcConvertUtcToLocalTime = _psprtc.sceRtcConvertUtcToLocalTime;
pub const sceRtcConvertLocalTimeToUtc = _psprtc.sceRtcConvertLocalTimeToUtc;

const _psppower = @import("sdk/psppower.zig");
pub const scePowerIsPowerOnline = _psppower.scePowerIsPowerOnline;
pub const scePowerIsBatteryExist = _psppower.scePowerIsBatteryExist;
pub const scePowerIsBatteryCharging = _psppower.scePowerIsBatteryCharging;
pub const scePowerGetBatteryChargingStatus = _psppower.scePowerGetBatteryChargingStatus;
pub const scePowerIsLowBattery = _psppower.scePowerIsLowBattery;
pub const scePowerGetBatteryLifePercent = _psppower.scePowerGetBatteryLifePercent;
pub const scePowerGetBatteryLifeTime = _psppower.scePowerGetBatteryLifeTime;
pub const scePowerGetBatteryTemp = _psppower.scePowerGetBatteryTemp;
pub const scePowerGetCpuClockFrequency = _psppower.scePowerGetCpuClockFrequency;
pub const scePowerGetBusClockFrequency = _psppower.scePowerGetBusClockFrequency;
pub const scePowerSetClockFrequency = _psppower.scePowerSetClockFrequency;
pub const scePowerLock = _psppower.scePowerLock;
pub const scePowerUnlock = _psppower.scePowerUnlock;
pub const scePowerRebootDevice = _psppower.scePowerRebootDevice;
pub const scePowerRegisterCallback = _psppower.scePowerRegisterCallback;
pub const scePowerUnregisterCallback = _psppower.scePowerUnregisterCallback;

const _pspumd = @import("sdk/pspumd.zig");
pub const sceUmdCheckMedium = _pspumd.sceUmdCheckMedium;
pub const sceUmdGetDiscInfo = _pspumd.sceUmdGetDiscInfo;
pub const sceUmdActivate = _pspumd.sceUmdActivate;
pub const sceUmdDeactivate = _pspumd.sceUmdDeactivate;
pub const sceUmdWaitDriveStat = _pspumd.sceUmdWaitDriveStat;
pub const sceUmdWaitDriveStatCB = _pspumd.sceUmdWaitDriveStatCB;
pub const sceUmdCancelWaitDriveStat = _pspumd.sceUmdCancelWaitDriveStat;
pub const sceUmdGetDriveStat = _pspumd.sceUmdGetDriveStat;
pub const sceUmdGetErrorStat = _pspumd.sceUmdGetErrorStat;
pub const sceUmdRegisterUMDCallBack = _pspumd.sceUmdRegisterUMDCallBack;
pub const sceUmdUnRegisterUMDCallBack = _pspumd.sceUmdUnRegisterUMDCallBack;

const _pspio = @import("sdk/pspiofilemgr.zig");
pub const sceIoOpen = _pspio.sceIoOpen;
pub const sceIoOpenAsync = _pspio.sceIoOpenAsync;
pub const sceIoClose = _pspio.sceIoClose;
pub const sceIoCloseAsync = _pspio.sceIoCloseAsync;
pub const sceIoRead = _pspio.sceIoRead;
pub const sceIoReadAsync = _pspio.sceIoReadAsync;
pub const sceIoWrite = _pspio.sceIoWrite;
pub const sceIoWriteAsync = _pspio.sceIoWriteAsync;
pub const sceIoLseek = _pspio.sceIoLseek;
pub const sceIoLseekAsync = _pspio.sceIoLseekAsync;
pub const sceIoLseek32 = _pspio.sceIoLseek32;
pub const sceIoLseek32Async = _pspio.sceIoLseek32Async;
pub const sceIoRemove = _pspio.sceIoRemove;
pub const sceIoMkdir = _pspio.sceIoMkdir;
pub const sceIoRmdir = _pspio.sceIoRmdir;
pub const sceIoChdir = _pspio.sceIoChdir;
pub const sceIoRename = _pspio.sceIoRename;
pub const sceIoDopen = _pspio.sceIoDopen;
pub const sceIoDread = _pspio.sceIoDread;
pub const sceIoDclose = _pspio.sceIoDclose;

const _psphprm = @import("sdk/psphprm.zig");
pub const sceHprmPeekCurrentKey = _psphprm.sceHprmPeekCurrentKey;
pub const sceHprmPeekLatch = _psphprm.sceHprmPeekLatch;
pub const sceHprmReadLatch = _psphprm.sceHprmReadLatch;
pub const sceHprmIsHeadphoneExist = _psphprm.sceHprmIsHeadphoneExist;
pub const sceHprmIsRemoteExist = _psphprm.sceHprmIsRemoteExist;

const _pspwlan = @import("sdk/pspwlan.zig");
pub const sceWlanDevIsPowerOn = _pspwlan.sceWlanDevIsPowerOn;
pub const sceWlanGetSwitchState = _pspwlan.sceWlanGetSwitchState;
pub const sceWlanGetEtherAddr = _pspwlan.sceWlanGetEtherAddr;

const _psputility = @import("sdk/psputility.zig");
pub const sceUtilityLoadNetModule = _psputility.sceUtilityLoadNetModule;
pub const sceUtilityUnloadNetModule = _psputility.sceUtilityUnloadNetModule;
pub const sceUtilityLoadModule = _psputility.sceUtilityLoadModule;
pub const sceUtilityUnloadModule = _psputility.sceUtilityUnloadModule;
pub const sceUtilityNetconfInitStart = _psputility.sceUtilityNetconfInitStart;
pub const sceUtilityNetconfUpdate = _psputility.sceUtilityNetconfUpdate;
pub const sceUtilityNetconfGetStatus = _psputility.sceUtilityNetconfGetStatus;
pub const sceUtilityNetconfShutdownStart = _psputility.sceUtilityNetconfShutdownStart;

// psputils — source from UtilsForUser (NID stubs) not psputils.zig (bare extern)
const _uu = c.UtilsForUser;
pub const sceKernelUtilsMt19937Init        = _uu.sceKernelUtilsMt19937Init;
pub const sceKernelUtilsMt19937UInt        = _uu.sceKernelUtilsMt19937UInt;
pub const sceKernelUtilsMd5Digest          = _uu.sceKernelUtilsMd5Digest;
pub const sceKernelUtilsMd5BlockInit       = _uu.sceKernelUtilsMd5BlockInit;
pub const sceKernelUtilsMd5BlockUpdate     = _uu.sceKernelUtilsMd5BlockUpdate;
pub const sceKernelUtilsMd5BlockResult     = _uu.sceKernelUtilsMd5BlockResult;
pub const sceKernelUtilsSha1Digest         = _uu.sceKernelUtilsSha1Digest;
pub const sceKernelUtilsSha1BlockInit      = _uu.sceKernelUtilsSha1BlockInit;
pub const sceKernelUtilsSha1BlockUpdate    = _uu.sceKernelUtilsSha1BlockUpdate;
pub const sceKernelUtilsSha1BlockResult    = _uu.sceKernelUtilsSha1BlockResult;
pub const sceKernelLibcTime                = _uu.sceKernelLibcTime;
pub const sceKernelLibcClock               = _uu.sceKernelLibcClock;
pub const sceKernelLibcGettimeofday        = _uu.sceKernelLibcGettimeofday;
pub const sceKernelDcacheWritebackAll              = _uu.sceKernelDcacheWritebackAll;
pub const sceKernelDcacheWritebackInvalidateAll    = _uu.sceKernelDcacheWritebackInvalidateAll;
pub const sceKernelDcacheWritebackRange            = _uu.sceKernelDcacheWritebackRange;
pub const sceKernelDcacheWritebackInvalidateRange  = _uu.sceKernelDcacheWritebackInvalidateRange;
pub const sceKernelDcacheInvalidateRange           = _uu.sceKernelDcacheInvalidateRange;
pub const sceKernelIcacheInvalidateAll             = _uu.sceKernelIcacheInvalidateAll;
pub const sceKernelIcacheInvalidateRange           = _uu.sceKernelIcacheInvalidateRange;

// Tier 3: Snake_case sub-namespaces

pub const gu = struct {
    pub const types = @import("sdk/pspgutypes.zig");
    const _gu = @import("sdk/pspgu.zig");
    // Init / term
    pub const init = _gu.sceGuInit;
    pub const term = _gu.sceGuTerm;
    // Display list management
    pub const start = _gu.sceGuStart;
    pub const finish = _gu.guFinish;
    pub const finish_list = _gu.sceGuFinish;
    pub const finish_id = _gu.sceGuFinishId;
    pub const sync = _gu.guSync;
    pub const sync_raw = _gu.sceGuSync;
    pub const send_list = _gu.sceGuSendList;
    pub const call_list = _gu.sceGuCallList;
    pub const call_mode = _gu.sceGuCallMode;
    pub const check_list = _gu.sceGuCheckList;
    pub const get_memory = _gu.sceGuGetMemory;
    // Buffer setup
    pub const draw_buffer = _gu.sceGuDrawBuffer;
    pub const draw_buffer_list = _gu.sceGuDrawBufferList;
    pub const disp_buffer = _gu.sceGuDispBuffer;
    pub const depth_buffer = _gu.sceGuDepthBuffer;
    // Display control
    pub const display = _gu.sceGuDisplay;
    pub const swap_buffers = _gu.guSwapBuffers;
    pub const swap_buffers_raw = _gu.sceGuSwapBuffers;
    pub const swap_buffers_behaviour = _gu.guSwapBuffersBehaviour;
    pub const swap_buffers_callback = _gu.guSwapBuffersCallback;
    pub const set_callback = _gu.sceGuSetCallback;
    // Viewport / scissor
    pub const offset = _gu.sceGuOffset;
    pub const viewport = _gu.sceGuViewport;
    pub const scissor = _gu.sceGuScissor;
    pub const depth_range = _gu.sceGuDepthRange;
    pub const depth_offset = _gu.sceGuDepthOffset;
    // State enable / disable
    pub const enable = _gu.sceGuEnable;
    pub const disable = _gu.sceGuDisable;
    pub const set_status = _gu.sceGuSetStatus;
    pub const get_status = _gu.sceGuGetStatus;
    pub const set_all_status = _gu.sceGuSetAllStatus;
    pub const get_all_status = _gu.sceGuGetAllStatus;
    // Clear
    pub const clear = _gu.sceGuClear;
    pub const clear_color = _gu.sceGuClearColor;
    pub const clear_depth = _gu.sceGuClearDepth;
    pub const clear_stencil = _gu.sceGuClearStencil;
    // Draw
    pub const draw_array = _gu.sceGuDrawArray;
    pub const draw_array_n = _gu.sceGuDrawArrayN;
    pub const draw_bezier = _gu.sceGuDrawBezier;
    pub const draw_spline = _gu.sceGuDrawSpline;
    pub const begin_object = _gu.sceGuBeginObject;
    pub const end_object = _gu.sceGuEndObject;
    // Depth
    pub const depth_func = _gu.sceGuDepthFunc;
    pub const depth_mask = _gu.sceGuDepthMask;
    // Rasterization
    pub const front_face = _gu.sceGuFrontFace;
    pub const shade_model = _gu.sceGuShadeModel;
    pub const fog = _gu.sceGuFog;
    pub const pixel_mask = _gu.sceGuPixelMask;
    pub const logical_op = _gu.sceGuLogicalOp;
    // Alpha / stencil / blend
    pub const alpha_func = _gu.sceGuAlphaFunc;
    pub const stencil_func = _gu.sceGuStencilFunc;
    pub const stencil_op = _gu.sceGuStencilOp;
    pub const blend_func = _gu.sceGuBlendFunc;
    pub const color_func = _gu.sceGuColorFunc;
    pub const color_material = _gu.sceGuColorMaterial;
    // Color / material
    pub const color = _gu.sceGuColor;
    pub const ambient = _gu.sceGuAmbient;
    pub const ambient_color = _gu.sceGuAmbientColor;
    pub const material = _gu.sceGuMaterial;
    pub const model_color = _gu.sceGuModelColor;
    pub const specular = _gu.sceGuSpecular;
    // Lighting
    pub const light = _gu.sceGuLight;
    pub const light_att = _gu.sceGuLightAtt;
    pub const light_color = _gu.sceGuLightColor;
    pub const light_mode = _gu.sceGuLightMode;
    pub const light_spot = _gu.sceGuLightSpot;
    pub const morph_weight = _gu.sceGuMorphWeight;
    // Texture
    pub const tex_mode = _gu.sceGuTexMode;
    pub const tex_image = _gu.sceGuTexImage;
    pub const tex_func = _gu.sceGuTexFunc;
    pub const tex_filter = _gu.sceGuTexFilter;
    pub const tex_scale = _gu.sceGuTexScale;
    pub const tex_offset = _gu.sceGuTexOffset;
    pub const tex_wrap = _gu.sceGuTexWrap;
    pub const tex_flush = _gu.sceGuTexFlush;
    pub const tex_sync = _gu.sceGuTexSync;
    pub const tex_env_color = _gu.sceGuTexEnvColor;
    pub const tex_level_mode = _gu.sceGuTexLevelMode;
    pub const tex_map_mode = _gu.sceGuTexMapMode;
    pub const tex_proj_map_mode = _gu.sceGuTexProjMapMode;
    pub const tex_slope = _gu.sceGuTexSlope;
    // CLUT
    pub const clut_load = _gu.sceGuClutLoad;
    pub const clut_mode = _gu.sceGuClutMode;
    // Image copy
    pub const copy_image = _gu.sceGuCopyImage;
    // Dither / matrix
    pub const set_dither = _gu.sceGuSetDither;
    pub const set_matrix = _gu.sceGuSetMatrix;
    // Patch
    pub const patch_divide = _gu.sceGuPatchDivide;
    pub const patch_front_face = _gu.sceGuPatchFrontFace;
    pub const patch_prim = _gu.sceGuPatchPrim;
    // Signal / break / continue
    pub const signal = _gu.sceGuSignal;
    pub const @"break" = _gu.sceGuBreak;
    pub const @"continue" = _gu.sceGuContinue;
    // Low-level command helpers
    pub const send_commandi = _gu.sendCommandi;
    pub const send_commandf = _gu.sendCommandf;
    pub const send_commandi_stall = _gu.sendCommandiStall;
    pub const reset_values = _gu.resetValues;
};

pub const gum = struct {
    const _gum = @import("sdk/pspgum.zig");
    pub const matrix_mode = _gum.sceGumMatrixMode;
    pub const load_identity = _gum.sceGumLoadIdentity;
    pub const load_matrix = _gum.sceGumLoadMatrix;
    pub const store_matrix = _gum.sceGumStoreMatrix;
    pub const push_matrix = _gum.sceGumPushMatrix;
    pub const pop_matrix = _gum.sceGumPopMatrix;
    pub const mult_matrix = _gum.sceGumMultMatrix;
    pub const update_matrix = _gum.sceGumUpdateMatrix;
    pub const rotate_x = _gum.sceGumRotateX;
    pub const rotate_y = _gum.sceGumRotateY;
    pub const rotate_z = _gum.sceGumRotateZ;
    pub const rotate_xyz = _gum.sceGumRotateXYZ;
    pub const rotate_zyx = _gum.sceGumRotateZYX;
    pub const scale = _gum.sceGumScale;
    pub const translate = _gum.sceGumTranslate;
    pub const ortho = _gum.sceGumOrtho;
    pub const perspective = _gum.sceGumPerspective;
    pub const full_inverse = _gum.sceGumFullInverse;
    pub const fast_inverse = _gum.sceGumFastInverse;
    pub const draw_array = _gum.sceGumDrawArray;
    pub const draw_array_n = _gum.sceGumDrawArrayN;
    pub const draw_bezier = _gum.sceGumDrawBezier;
    pub const draw_spline = _gum.sceGumDrawSpline;
};

pub const ge = struct {
    const _ge = @import("sdk/pspge.zig");
    pub const edram_get_size = _ge.sceGeEdramGetSize;
    pub const edram_get_addr = _ge.sceGeEdramGetAddr;
    pub const edram_set_addr_translation = _ge.sceGeEdramSetAddrTranslation;
    pub const get_cmd = _ge.sceGeGetCmd;
    pub const get_mtx = _ge.sceGeGetMtx;
    pub const get_stack = _ge.sceGeGetStack;
    pub const save_context = _ge.sceGeSaveContext;
    pub const restore_context = _ge.sceGeRestoreContext;
    pub const list_en_queue = _ge.sceGeListEnQueue;
    pub const list_en_queue_head = _ge.sceGeListEnQueueHead;
    pub const list_de_queue = _ge.sceGeListDeQueue;
    pub const list_update_stall_addr = _ge.sceGeListUpdateStallAddr;
    pub const list_sync = _ge.sceGeListSync;
    pub const draw_sync = _ge.sceGeDrawSync;
    pub const @"break" = _ge.sceGeBreak;
    pub const @"continue" = _ge.sceGeContinue;
    pub const set_callback = _ge.sceGeSetCallback;
    pub const unset_callback = _ge.sceGeUnsetCallback;
};

pub const ctrl = struct {
    const _ctrl = @import("sdk/pspctrl.zig");
    pub const set_sampling_cycle = _ctrl.sceCtrlSetSamplingCycle;
    pub const get_sampling_cycle = _ctrl.sceCtrlGetSamplingCycle;
    pub const set_sampling_mode = _ctrl.sceCtrlSetSamplingMode;
    pub const get_sampling_mode = _ctrl.sceCtrlGetSamplingMode;
    pub const peek_buffer_positive = _ctrl.sceCtrlPeekBufferPositive;
    pub const peek_buffer_negative = _ctrl.sceCtrlPeekBufferNegative;
    pub const read_buffer_positive = _ctrl.sceCtrlReadBufferPositive;
    pub const read_buffer_negative = _ctrl.sceCtrlReadBufferNegative;
    pub const peek_latch = _ctrl.sceCtrlPeekLatch;
    pub const read_latch = _ctrl.sceCtrlReadLatch;
    pub const set_idle_cancel_threshold = _ctrl.sceCtrlSetIdleCancelThreshold;
    pub const get_idle_cancel_threshold = _ctrl.sceCtrlGetIdleCancelThreshold;
};

pub const display = struct {
    const _display = @import("sdk/pspdisplay.zig");
    pub const PspDisplayPixelFormats = _display.PspDisplayPixelFormats;
    pub const PspDisplaySetBufSync = _display.PspDisplaySetBufSync;
    pub const set_mode = _display.sceDisplaySetMode;
    pub const get_mode = _display.sceDisplayGetMode;
    pub const get_frame_per_sec = _display.sceDisplayGetFramePerSec;
    pub const set_hold_mode = _display.sceDisplaySetHoldMode;
    pub const set_resume_mode = _display.sceDisplaySetResumeMode;
    pub const set_frame_buf = _display.sceDisplaySetFrameBuf;
    pub const get_frame_buf = _display.sceDisplayGetFrameBuf;
    pub const is_foreground = _display.sceDisplayIsForeground;
    pub const get_vcount = _display.sceDisplayGetVcount;
    pub const is_vblank = _display.sceDisplayIsVblank;
    pub const wait_vblank = _display.sceDisplayWaitVblank;
    pub const wait_vblank_cb = _display.sceDisplayWaitVblankCB;
    pub const wait_vblank_start = _display.sceDisplayWaitVblankStart;
    pub const wait_vblank_start_cb = _display.sceDisplayWaitVblankStartCB;
    pub const get_current_hcount = _display.sceDisplayGetCurrentHcount;
    pub const get_accumulated_hcount = _display.sceDisplayGetAccumulatedHcount;
};

pub const kernel = struct {
    // From psploadexec
    const _loadexec = @import("sdk/psploadexec.zig");
    pub const load_exec = _loadexec.sceKernelLoadExec;
    pub const exit_game = _loadexec.sceKernelExitGame;
    pub const exit_game_with_status = _loadexec.sceKernelExitGameWithStatus;
    pub const register_exit_callback = _loadexec.sceKernelRegisterExitCallback;
    // From pspthreadman
    const _threadman = @import("sdk/pspthreadman.zig");
    pub const create_callback = _threadman.sceKernelCreateCallback;
    pub const delete_callback = _threadman.sceKernelDeleteCallback;
    pub const notify_callback = _threadman.sceKernelNotifyCallback;
    pub const cancel_callback = _threadman.sceKernelCancelCallback;
    pub const get_callback_count = _threadman.sceKernelGetCallbackCount;
    pub const check_callback = _threadman.sceKernelCheckCallback;
    pub const refer_callback_status = _threadman.sceKernelReferCallbackStatus;
    pub const sleep_thread = _threadman.sceKernelSleepThread;
    pub const sleep_thread_cb = _threadman.sceKernelSleepThreadCB;
    pub const wakeup_thread = _threadman.sceKernelWakeupThread;
    pub const cancel_wakeup_thread = _threadman.sceKernelCancelWakeupThread;
    pub const suspend_thread = _threadman.sceKernelSuspendThread;
    pub const resume_thread = _threadman.sceKernelResumeThread;
    pub const wait_thread_end = _threadman.sceKernelWaitThreadEnd;
    pub const wait_thread_end_cb = _threadman.sceKernelWaitThreadEndCB;
    pub const delay_thread = _threadman.sceKernelDelayThread;
    pub const delay_thread_cb = _threadman.sceKernelDelayThreadCB;
    pub const create_sema = _threadman.sceKernelCreateSema;
    pub const delete_sema = _threadman.sceKernelDeleteSema;
    pub const signal_sema = _threadman.sceKernelSignalSema;
    pub const wait_sema = _threadman.sceKernelWaitSema;
    pub const wait_sema_cb = _threadman.sceKernelWaitSemaCB;
    pub const poll_sema = _threadman.sceKernelPollSema;
    pub const create_event_flag = _threadman.sceKernelCreateEventFlag;
    pub const delete_event_flag = _threadman.sceKernelDeleteEventFlag;
    pub const set_event_flag = _threadman.sceKernelSetEventFlag;
    pub const clear_event_flag = _threadman.sceKernelClearEventFlag;
    pub const wait_event_flag = _threadman.sceKernelWaitEventFlag;
    pub const wait_event_flag_cb = _threadman.sceKernelWaitEventFlagCB;
    pub const poll_event_flag = _threadman.sceKernelPollEventFlag;
    // From pspsysmem
    const _sysmem = @import("sdk/pspsysmem.zig");
    pub const max_free_mem_size = _sysmem.sceKernelMaxFreeMemSize;
    pub const total_free_mem_size = _sysmem.sceKernelTotalFreeMemSize;
    pub const alloc_partition_memory = _sysmem.sceKernelAllocPartitionMemory;
    pub const free_partition_memory = _sysmem.sceKernelFreePartitionMemory;
    pub const get_block_head_addr = _sysmem.sceKernelGetBlockHeadAddr;
    pub const devkit_version = _sysmem.sceKernelDevkitVersion;
    pub const printf = _sysmem.sceKernelPrintf;
    // From pspmodulemgr
    const _modulemgr = @import("sdk/pspmodulemgr.zig");
    pub const load_module = _modulemgr.sceKernelLoadModule;
    pub const load_module_ms = _modulemgr.sceKernelLoadModuleMs;
    pub const load_module_by_id = _modulemgr.sceKernelLoadModuleByID;
    pub const start_module = _modulemgr.sceKernelStartModule;
    pub const stop_module = _modulemgr.sceKernelStopModule;
    pub const unload_module = _modulemgr.sceKernelUnloadModule;
    pub const self_stop_unload_module = _modulemgr.sceKernelSelfStopUnloadModule;
    pub const stop_unload_self_module = _modulemgr.sceKernelStopUnloadSelfModule;
    pub const query_module_info = _modulemgr.sceKernelQueryModuleInfo;
    pub const get_module_id_list = _modulemgr.sceKernelGetModuleIdList;
    pub const get_module_id_by_address = _modulemgr.sceKernelGetModuleIdByAddress;
};

pub const audio = struct {
    const _audio = @import("sdk/pspaudio.zig");
    pub const ch_reserve = _audio.sceAudioChReserve;
    pub const ch_release = _audio.sceAudioChRelease;
    pub const output = _audio.sceAudioOutput;
    pub const output_blocking = _audio.sceAudioOutputBlocking;
};

pub const atrac3 = struct {
    const _atrac3 = @import("sdk/pspatrac3.zig");
    pub const get_atrac_id = _atrac3.sceAtracGetAtracID;
    pub const set_data_and_get_id = _atrac3.sceAtracSetDataAndGetID;
};

pub const rtc = struct {
    const _rtc = @import("sdk/psprtc.zig");
    pub const get_tick_resolution = _rtc.sceRtcGetTickResolution;
    pub const get_current_tick = _rtc.sceRtcGetCurrentTick;
    pub const get_current_clock = _rtc.sceRtcGetCurrentClock;
    pub const get_current_clock_local_time = _rtc.sceRtcGetCurrentClockLocalTime;
    pub const convert_utc_to_local_time = _rtc.sceRtcConvertUtcToLocalTime;
    pub const convert_local_time_to_utc = _rtc.sceRtcConvertLocalTimeToUtc;
};

pub const power = struct {
    const _power = @import("sdk/psppower.zig");
    pub const is_power_online = _power.scePowerIsPowerOnline;
    pub const is_battery_exist = _power.scePowerIsBatteryExist;
    pub const is_battery_charging = _power.scePowerIsBatteryCharging;
    pub const get_battery_charging_status = _power.scePowerGetBatteryChargingStatus;
    pub const is_low_battery = _power.scePowerIsLowBattery;
    pub const get_battery_life_percent = _power.scePowerGetBatteryLifePercent;
    pub const get_battery_life_time = _power.scePowerGetBatteryLifeTime;
    pub const get_battery_temp = _power.scePowerGetBatteryTemp;
    pub const get_cpu_clock_frequency = _power.scePowerGetCpuClockFrequency;
    pub const get_bus_clock_frequency = _power.scePowerGetBusClockFrequency;
    pub const set_clock_frequency = _power.scePowerSetClockFrequency;
    pub const lock = _power.scePowerLock;
    pub const unlock = _power.scePowerUnlock;
    pub const reboot_device = _power.scePowerRebootDevice;
    pub const register_callback = _power.scePowerRegisterCallback;
    pub const unregister_callback = _power.scePowerUnregisterCallback;
};

pub const umd = struct {
    const _umd = @import("sdk/pspumd.zig");
    pub const check_medium = _umd.sceUmdCheckMedium;
    pub const get_disc_info = _umd.sceUmdGetDiscInfo;
    pub const activate = _umd.sceUmdActivate;
    pub const deactivate = _umd.sceUmdDeactivate;
    pub const wait_drive_stat = _umd.sceUmdWaitDriveStat;
    pub const wait_drive_stat_cb = _umd.sceUmdWaitDriveStatCB;
    pub const cancel_wait_drive_stat = _umd.sceUmdCancelWaitDriveStat;
    pub const get_drive_stat = _umd.sceUmdGetDriveStat;
    pub const get_error_stat = _umd.sceUmdGetErrorStat;
    pub const register_umd_callback = _umd.sceUmdRegisterUMDCallBack;
    pub const unregister_umd_callback = _umd.sceUmdUnRegisterUMDCallBack;
};

pub const io = struct {
    const _io = @import("sdk/pspiofilemgr.zig");
    pub const open = _io.sceIoOpen;
    pub const open_async = _io.sceIoOpenAsync;
    pub const close = _io.sceIoClose;
    pub const close_async = _io.sceIoCloseAsync;
    pub const read = _io.sceIoRead;
    pub const read_async = _io.sceIoReadAsync;
    pub const write = _io.sceIoWrite;
    pub const write_async = _io.sceIoWriteAsync;
    pub const lseek = _io.sceIoLseek;
    pub const lseek_async = _io.sceIoLseekAsync;
    pub const lseek32 = _io.sceIoLseek32;
    pub const lseek32_async = _io.sceIoLseek32Async;
    pub const remove = _io.sceIoRemove;
    pub const mkdir = _io.sceIoMkdir;
    pub const rmdir = _io.sceIoRmdir;
    pub const chdir = _io.sceIoChdir;
    pub const rename = _io.sceIoRename;
    pub const dopen = _io.sceIoDopen;
    pub const dread = _io.sceIoDread;
    pub const dclose = _io.sceIoDclose;
};

pub const hprm = struct {
    const _hprm = @import("sdk/psphprm.zig");
    pub const peek_current_key = _hprm.sceHprmPeekCurrentKey;
    pub const peek_latch = _hprm.sceHprmPeekLatch;
    pub const read_latch = _hprm.sceHprmReadLatch;
    pub const is_headphone_exist = _hprm.sceHprmIsHeadphoneExist;
    pub const is_remote_exist = _hprm.sceHprmIsRemoteExist;
};

pub const wlan = struct {
    const _wlan = @import("sdk/pspwlan.zig");
    pub const dev_is_power_on = _wlan.sceWlanDevIsPowerOn;
    pub const get_switch_state = _wlan.sceWlanGetSwitchState;
    pub const get_ether_addr = _wlan.sceWlanGetEtherAddr;
};

pub const utility = struct {
    const _utility = @import("sdk/psputility.zig");
    pub const load_net_module = _utility.sceUtilityLoadNetModule;
    pub const unload_net_module = _utility.sceUtilityUnloadNetModule;
    pub const load_module = _utility.sceUtilityLoadModule;
    pub const unload_module = _utility.sceUtilityUnloadModule;
    pub const net_conf_init_start = _utility.sceUtilityNetconfInitStart;
    pub const net_conf_update = _utility.sceUtilityNetconfUpdate;
    pub const net_conf_get_status = _utility.sceUtilityNetconfGetStatus;
    pub const net_conf_shutdown_start = _utility.sceUtilityNetconfShutdownStart;
};

pub const utils = struct {
    // Types — sourced from c.types via psputils.zig re-exports
    const _t = @import("sdk/psputils.zig");
    pub const SceKernelUtilsMt19937Context = _t.SceKernelUtilsMt19937Context;
    pub const SceKernelUtilsMd5Context     = _t.SceKernelUtilsMd5Context;
    pub const SceKernelUtilsSha1Context    = _t.SceKernelUtilsSha1Context;
    pub const time_t     = _t.time_t;
    pub const clock_t    = _t.clock_t;
    pub const timezone   = _t.timezone;
    pub const timeval    = _t.timeval;

    // All function calls go through c.UtilsForUser so NID stubs are always emitted.
    const _u = c.UtilsForUser;

    // Mersenne Twister PRNG
    pub fn mt19937_init(ctx: *SceKernelUtilsMt19937Context, seed: u32) !i32 {
        const res = _u.sceKernelUtilsMt19937Init(ctx, seed);
        if (res < 0) return error.Unexpected;
        return res;
    }
    pub const mt19937_uint = _u.sceKernelUtilsMt19937UInt;
    // MD5
    pub fn md5_digest(data: [*]u8, size: u32, digest: [*]u8) !i32 {
        const res = _u.sceKernelUtilsMd5Digest(data, size, digest);
        if (res < 0) return error.Unexpected;
        return res;
    }
    pub fn md5_block_init(ctx: *SceKernelUtilsMd5Context) !i32 {
        const res = _u.sceKernelUtilsMd5BlockInit(ctx);
        if (res < 0) return error.Unexpected;
        return res;
    }
    pub fn md5_block_update(ctx: *SceKernelUtilsMd5Context, data: [*]u8, size: u32) !i32 {
        const res = _u.sceKernelUtilsMd5BlockUpdate(ctx, data, size);
        if (res < 0) return error.Unexpected;
        return res;
    }
    pub fn md5_block_result(ctx: *SceKernelUtilsMd5Context, digest: [*]u8) !i32 {
        const res = _u.sceKernelUtilsMd5BlockResult(ctx, digest);
        if (res < 0) return error.Unexpected;
        return res;
    }
    // SHA1
    pub fn sha1_digest(data: [*]u8, size: u32, digest: [*]u8) !i32 {
        const res = _u.sceKernelUtilsSha1Digest(data, size, digest);
        if (res < 0) return error.Unexpected;
        return res;
    }
    pub fn sha1_block_init(ctx: *SceKernelUtilsSha1Context) !i32 {
        const res = _u.sceKernelUtilsSha1BlockInit(ctx);
        if (res < 0) return error.Unexpected;
        return res;
    }
    pub fn sha1_block_update(ctx: *SceKernelUtilsSha1Context, data: [*]u8, size: u32) !i32 {
        const res = _u.sceKernelUtilsSha1BlockUpdate(ctx, data, size);
        if (res < 0) return error.Unexpected;
        return res;
    }
    pub fn sha1_block_result(ctx: *SceKernelUtilsSha1Context, digest: [*]u8) !i32 {
        const res = _u.sceKernelUtilsSha1BlockResult(ctx, digest);
        if (res < 0) return error.Unexpected;
        return res;
    }
    // libc-style time
    pub const libc_time         = _u.sceKernelLibcTime;
    pub const libc_clock        = _u.sceKernelLibcClock;
    pub const libc_gettimeofday = _u.sceKernelLibcGettimeofday;
    // Cache maintenance
    pub const dcache_writeback_all              = _u.sceKernelDcacheWritebackAll;
    pub const dcache_writeback_invalidate_all   = _u.sceKernelDcacheWritebackInvalidateAll;
    pub const dcache_writeback_range            = _u.sceKernelDcacheWritebackRange;
    pub const dcache_writeback_invalidate_range = _u.sceKernelDcacheWritebackInvalidateRange;
    pub const dcache_invalidate_range           = _u.sceKernelDcacheInvalidateRange;
    pub const icache_invalidate_all             = _u.sceKernelIcacheInvalidateAll;
    pub const icache_invalidate_range           = _u.sceKernelIcacheInvalidateRange;
};

// Utility layer (unchanged)
pub const extra = struct {
    pub const allocator = @import("utils/allocator.zig");
    pub const constants = @import("utils/constants.zig");
    pub const debug = @import("utils/debug.zig");
    pub const module = @import("utils/module.zig");
    pub const utils = @import("utils/utils.zig");
    pub const vram = @import("utils/vram.zig");
};
