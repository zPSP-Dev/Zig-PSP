zig build-obj src/main.zig -target mipsel-freestanding-none -I../psp/sdk/include -I../psp/include/
#zig cc -c src/moduleinfo.c -target mipsel-freestanding-none -I../psp/sdk/include -I../psp/include/
ld.lld -L../psp/lib -T../psp/lib/linkfile.ld -lpsp -lc ../psp/lib/prxexports.o main.o -o a.elf -emit-relocs --eh-frame-hdr --no-gc-sections
../bin/psp-prxgen a.elf a.prx
mksfo HELLO PARAM.SFO
pack-pbp EBOOT.PBP PARAM.SFO NULL NULL NULL NULL NULL a.prx NULL