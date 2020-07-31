const pspkernel = @cImport(@cInclude("pspkernel.h"));

export fn main() void {
    pspkernel.sceKernelExitGame();
}
