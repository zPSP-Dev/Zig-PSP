__asm__ (                                                       \
	"    .set push\n"                                               \
	"    .section .lib.ent.top, \"a\", @progbits\n"                 \
	"    .align 2\n"                                                \
	"    .word 0\n"                                                 \
	"__lib_ent_top:\n"                                              \
	"    .section .lib.ent.btm, \"a\", @progbits\n"                 \
	"    .align 2\n"                                                \
	"__lib_ent_bottom:\n"                                           \
	"    .word 0\n"                                                 \
	"    .section .lib.stub.top, \"a\", @progbits\n"                \
	"    .align 2\n"                                                \
	"    .word 0\n"                                                 \
	"__lib_stub_top:\n"                                             \
	"    .section .lib.stub.btm, \"a\", @progbits\n"                \
	"    .align 2\n"                                                \
	"__lib_stub_bottom:\n"                                          \
	"    .word 0\n"                                                 \
	"    .set pop\n"                                                \
	"    .text\n"													\
);

typedef struct _scemoduleinfo {
	unsigned short		modattribute;
	unsigned char		modversion[2];
	char			modname[27];
	char			terminal;
	void *			gp_value;
	void *			ent_top;
	void *			ent_end;
	void *			stub_top;
	void *			stub_end;
} SceModuleInfo;

extern char __lib_ent_top[], __lib_ent_bottom[];
extern char __lib_stub_top[], __lib_stub_bottom[];
extern char _gp[];

#define xstr(s) str(s)
#define str(s) #s
SceModuleInfo module_info __attribute__((section(".rodata.sceModuleInfo"), aligned(16), unused)) = {
	0, { PSP_ZIG_APP_VER_MAJ, PSP_ZIG_APP_VER_MIN}, xstr(PSP_ZIG_APP_NAME), 0, _gp,
	__lib_ent_top, __lib_ent_bottom,                            
	__lib_stub_top, __lib_stub_bottom                           
};


extern void* module_start;
static const unsigned int __syslib_exports[4] __attribute__((section(".rodata.sceResident"))) = {
	0xD632ACDB,
	0xF01D73A7,
	(unsigned int) &module_start,
	(unsigned int) &module_info,
};

struct _PspLibraryEntry {
	const char *	name;
	unsigned short	version;
	unsigned short	attribute;
	unsigned char	entLen;
	unsigned char	varCount;
	unsigned short	funcCount;
	void *			entrytable;
}; 

const struct _PspLibraryEntry __library_exports[1] __attribute__((section(".lib.ent"), used)) = {
	{ 0, 0x0000, 0x8000, 4, 1, 1, (void*)(&__syslib_exports) },
};
