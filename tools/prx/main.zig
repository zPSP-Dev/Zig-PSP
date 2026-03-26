// zprxgen: Zig implementation of psp-prxgen
// Converts a MIPS ELF executable into a PSP PRX (Program Relocatable Executable).
//
// PRX output layout:
//   ELF Header (52 bytes)
//   Program Headers (PT_LOAD + PT_PRX_RELOC, 2x 32 bytes)
//   Allocated section data  (16-byte aligned from end of PH)
//   Section Headers
//   Relocation data
//   Section header string table

const std = @import("std");

// -- ELF constants ------------------------------------------------------------

const ELF_MAGIC: u32 = 0x464C457F;
const ELF_EXEC_TYPE: u16 = 0x0002;
const ELF_PRX_TYPE: u16 = 0xFFA0;
const ELF_MACHINE_MIPS: u16 = 0x0008;

const SHT_NULL: u32 = 0;
const SHT_PROGBITS: u32 = 1;
const SHT_SYMTAB: u32 = 2;
const SHT_STRTAB: u32 = 3;
const SHT_REL: u32 = 9;
const SHT_PRXRELOC: u32 = 0x700000A0;
const PT_PRX_RELOC: u32 = 0x700000A0;

const SHF_ALLOC: u32 = 2;
const SHF_EXECINSTR: u32 = 4;
const SHF_MERGE: u32 = 0x10;
const SHF_STRINGS: u32 = 0x20;

const R_MIPS_HI16: u8 = 5;
const R_MIPS_LO16: u8 = 6;
const R_MIPS_PC16: u8 = 10;

// On-disk sizes (all little-endian)
const EHDR_SIZE: u32 = 52;
const SHDR_SIZE: u32 = 40;
const PHDR_SIZE: u32 = 32;
const REL_SIZE: u32 = 8;
const SYM_SIZE: u32 = 16;

const PSP_MODULE_INFO_NAME = ".rodata.sceModuleInfo";
const PSP_MODULE_REMOVE_REL = ".rel.sceStub.text";
const ELF_SH_STRTAB = ".shstrtab";

// -- On-disk ELF structures (little-endian) -----------------------------------

const Elf32_Ehdr = extern struct {
    e_magic: u32,
    e_class: u8,
    e_data: u8,
    e_idver: u8,
    e_pad: [9]u8,
    e_type: u16,
    e_machine: u16,
    e_version: u32,
    e_entry: u32,
    e_phoff: u32,
    e_shoff: u32,
    e_flags: u32,
    e_ehsize: u16,
    e_phentsize: u16,
    e_phnum: u16,
    e_shentsize: u16,
    e_shnum: u16,
    e_shstrndx: u16,
};

const Elf32_Shdr = extern struct {
    sh_name: u32,
    sh_type: u32,
    sh_flags: u32,
    sh_addr: u32,
    sh_offset: u32,
    sh_size: u32,
    sh_link: u32,
    sh_info: u32,
    sh_addralign: u32,
    sh_entsize: u32,
};

const Elf32_Phdr = extern struct {
    p_type: u32,
    p_offset: u32,
    p_vaddr: u32,
    p_paddr: u32,
    p_filesz: u32,
    p_memsz: u32,
    p_flags: u32,
    p_align: u32,
};

const Elf32_Rel = extern struct {
    r_offset: u32,
    r_info: u32,
};

const Elf32_Sym = extern struct {
    st_name: u32,
    st_value: u32,
    st_size: u32,
    st_info: u8,
    st_other: u8,
    st_shndx: u16,
};

comptime {
    std.debug.assert(@sizeOf(Elf32_Ehdr) == EHDR_SIZE);
    std.debug.assert(@sizeOf(Elf32_Shdr) == SHDR_SIZE);
    std.debug.assert(@sizeOf(Elf32_Phdr) == PHDR_SIZE);
    std.debug.assert(@sizeOf(Elf32_Rel) == REL_SIZE);
    std.debug.assert(@sizeOf(Elf32_Sym) == SYM_SIZE);
}

// -- Working data structures ---------------------------------------------------

const ElfSection = struct {
    name_idx: u32,
    shtype: u32,
    flags: u32,
    addr: u32,
    offset: u32,
    size: u32,
    link: u32,
    info: u32,
    addralign: u32,
    entsize: u32,
    /// Slice into the raw ELF buffer
    data: []u8,
    /// Slice into the section string table (set during loadSections)
    name: []const u8,
    /// Output section index (after reindex)
    out_index: u32,
    /// For relocation sections: index into sections[] of the target section
    ref_idx: ?usize,
    /// Whether this section appears in the output
    output: bool,
};

const ElfHeader = struct {
    magic: u32,
    class: u8,
    data: u8,
    idver: u8,
    elf_type: u16,
    machine: u16,
    version: u32,
    entry: u32,
    phoff: u32,
    shoff: u32,
    flags: u32,
    ehsize: u16,
    phentsize: u16,
    phnum: u16,
    shentsize: u16,
    shnum: u16,
    shstrndx: u16,
};

const Layout = struct {
    out_sects: u32,
    alloc_size: u32,
    mem_size: u32,
    reloc_size: u32,
    str_size: u32,
    ph_base: u32,
    alloc_base: u32,
    sh_base: u32,
    reloc_base: u32,
    shstr_base: u32,
    total_size: u32,
};

// -- Helpers -------------------------------------------------------------------

fn lw(data: []const u8, offset: usize) u32 {
    return std.mem.readInt(u32, data[offset..][0..4], .little);
}

fn lh(data: []const u8, offset: usize) u16 {
    return std.mem.readInt(u16, data[offset..][0..2], .little);
}

fn sw(data: []u8, offset: usize, val: u32) void {
    std.mem.writeInt(u32, data[offset..][0..4], val, .little);
}

fn sh(data: []u8, offset: usize, val: u16) void {
    std.mem.writeInt(u16, data[offset..][0..2], val, .little);
}

fn alignUp(val: u32, alignment: u32) u32 {
    return (val + alignment - 1) & ~(alignment - 1);
}

fn elfRelSym(r_info: u32) u32 {
    return r_info >> 8;
}

fn elfRelType(r_info: u32) u8 {
    return @truncate(r_info & 0xFF);
}

// -- Load & validate -----------------------------------------------------------

fn loadFile(allocator: std.mem.Allocator, io: std.Io, path: []const u8) ![]u8 {
    var file = std.Io.Dir.cwd().openFile(io, path, .{}) catch |err| {
        std.debug.print("Error: could not open file '{s}': {}\n", .{ path, err });
        return err;
    };
    defer file.close(io);
    var buffer: [4096]u8 = undefined;
    var reader = file.reader(io, &buffer);
    const data = try reader.interface.allocRemaining(allocator, .unlimited);
    if (data.len < EHDR_SIZE) {
        std.debug.print("Error: file too small to be an ELF\n", .{});
        allocator.free(data);
        return error.InvalidElf;
    }
    return data;
}

fn validateHeader(data: []const u8) !ElfHeader {
    const h = std.mem.bytesAsValue(Elf32_Ehdr, data[0..EHDR_SIZE]);
    const head = ElfHeader{
        .magic = std.mem.littleToNative(u32, h.e_magic),
        .class = h.e_class,
        .data = h.e_data,
        .idver = h.e_idver,
        .elf_type = std.mem.littleToNative(u16, h.e_type),
        .machine = std.mem.littleToNative(u16, h.e_machine),
        .version = std.mem.littleToNative(u32, h.e_version),
        .entry = std.mem.littleToNative(u32, h.e_entry),
        .phoff = std.mem.littleToNative(u32, h.e_phoff),
        .shoff = std.mem.littleToNative(u32, h.e_shoff),
        .flags = std.mem.littleToNative(u32, h.e_flags),
        .ehsize = std.mem.littleToNative(u16, h.e_ehsize),
        .phentsize = std.mem.littleToNative(u16, h.e_phentsize),
        .phnum = std.mem.littleToNative(u16, h.e_phnum),
        .shentsize = std.mem.littleToNative(u16, h.e_shentsize),
        .shnum = std.mem.littleToNative(u16, h.e_shnum),
        .shstrndx = std.mem.littleToNative(u16, h.e_shstrndx),
    };

    if (head.magic != ELF_MAGIC) {
        std.debug.print("Error: invalid ELF magic\n", .{});
        return error.InvalidElf;
    }
    if (head.elf_type != ELF_EXEC_TYPE and head.elf_type != ELF_PRX_TYPE) {
        std.debug.print("Error: not an EXEC or PRX type ELF\n", .{});
        return error.InvalidElf;
    }
    if (head.machine != ELF_MACHINE_MIPS) {
        std.debug.print("Error: not a MIPS ELF\n", .{});
        return error.InvalidElf;
    }
    if (head.shnum < head.shstrndx) {
        std.debug.print("Error: section count less than string table index\n", .{});
        return error.InvalidElf;
    }
    return head;
}

fn loadSections(
    allocator: std.mem.Allocator,
    data: []u8,
    head: ElfHeader,
) !struct { sections: []ElfSection, modinfo_idx: usize } {
    if (head.shnum == 0) {
        std.debug.print("Error: no sections in ELF\n", .{});
        return error.InvalidElf;
    }

    const sections = try allocator.alloc(ElfSection, head.shnum);
    @memset(std.mem.sliceAsBytes(sections), 0);

    var load_addr: u32 = 0xFFFFFFFF;
    var found_rel = false;

    // Parse all section headers
    for (0..head.shnum) |i| {
        const off = head.shoff + i * head.shentsize;
        const s = std.mem.bytesAsValue(Elf32_Shdr, data[off..][0..SHDR_SIZE]);

        sections[i] = ElfSection{
            .name_idx = std.mem.littleToNative(u32, s.sh_name),
            .shtype = std.mem.littleToNative(u32, s.sh_type),
            .flags = std.mem.littleToNative(u32, s.sh_flags),
            .addr = std.mem.littleToNative(u32, s.sh_addr),
            .offset = std.mem.littleToNative(u32, s.sh_offset),
            .size = std.mem.littleToNative(u32, s.sh_size),
            .link = std.mem.littleToNative(u32, s.sh_link),
            .info = std.mem.littleToNative(u32, s.sh_info),
            .addralign = std.mem.littleToNative(u32, s.sh_addralign),
            .entsize = std.mem.littleToNative(u32, s.sh_entsize),
            .data = if (s.sh_offset != 0) data[s.sh_offset..][0..s.sh_size] else data[0..0],
            .name = "",
            .out_index = @intCast(i),
            .ref_idx = null,
            .output = false,
        };

        if (sections[i].flags & SHF_ALLOC != 0) {
            sections[i].output = true;
            if (sections[i].addr < load_addr) load_addr = sections[i].addr;
        }
    }

    // Get the string table data
    const shstrtab = &sections[head.shstrndx];
    const str_data = shstrtab.data;

    // Second pass: fix up names, mark relocation sections, find modinfo
    var modinfo_idx: ?usize = null;

    for (0..head.shnum) |i| {
        const name_off = sections[i].name_idx;
        // Find null terminator
        var name_end = name_off;
        while (name_end < str_data.len and str_data[name_end] != 0) : (name_end += 1) {}
        sections[i].name = str_data[name_off..name_end];

        const stype = sections[i].shtype;
        const is_rel = (stype == SHT_REL or stype == SHT_PRXRELOC);

        if (is_rel) {
            const target = sections[i].info;
            if (target < head.shnum and sections[target].flags & SHF_ALLOC != 0) {
                sections[i].ref_idx = target;
                sections[i].output = true;
                found_rel = true;
            }
        }

        if (std.mem.eql(u8, sections[i].name, PSP_MODULE_INFO_NAME)) {
            modinfo_idx = i;
        } else if (std.mem.eql(u8, sections[i].name, PSP_MODULE_REMOVE_REL)) {
            sections[i].output = false;
        }
    }

    if (modinfo_idx == null) {
        std.debug.print("Error: no .rodata.sceModuleInfo section found\n", .{});
        return error.InvalidElf;
    }
    if (!found_rel) {
        std.debug.print("Error: no relocation sections found\n", .{});
        return error.InvalidElf;
    }
    if (load_addr != 0) {
        std.debug.print("Error: ELF not based at address 0 (base = 0x{X:0>8})\n", .{load_addr});
        return error.InvalidElf;
    }

    return .{ .sections = sections, .modinfo_idx = modinfo_idx.? };
}

// -- Relocation filtering ------------------------------------------------------

fn processRelocs(allocator: std.mem.Allocator, sections: []ElfSection, head: ElfHeader) !void {
    for (0..head.shnum) |i| {
        if (!sections[i].output) continue;
        if (sections[i].shtype != SHT_REL) continue;

        const link = sections[i].link;
        if (link >= head.shnum) continue;
        if (sections[link].shtype != SHT_SYMTAB) continue;

        const sym_section = &sections[link];
        const sym_count = sym_section.size / SYM_SIZE;
        const sym_data = sym_section.data;

        const rel_count = sections[i].size / REL_SIZE;
        const new_rels = try allocator.alloc(Elf32_Rel, rel_count);
        defer allocator.free(new_rels);

        var out_count: usize = 0;

        for (0..rel_count) |j| {
            const rel_off = j * REL_SIZE;
            const r_offset = lw(sections[i].data, rel_off);
            const r_info = lw(sections[i].data, rel_off + 4);

            const sym_idx = elfRelSym(r_info);
            const rel_type = elfRelType(r_info);

            if (sym_idx >= sym_count) {
                std.debug.print("Warning: ignoring relocation with out-of-range symbol index\n", .{});
                continue;
            }

            const sym_base = sym_idx * SYM_SIZE;
            const st_shndx = lh(sym_data, sym_base + 14);

            // Remove: undefined symbol or PC16 relocation type
            if (st_shndx == 0 or rel_type == R_MIPS_PC16) continue;

            new_rels[out_count] = Elf32_Rel{
                .r_offset = r_offset,
                .r_info = r_info,
            };
            out_count += 1;
        }

        // Ensure each R_MIPS_HI16 is immediately followed by its paired LO16
        // so the PSP kernel's sequential pairing scan works correctly.
        sortHiLoPairs(new_rels[0..out_count]);

        const new_size: u32 = @intCast(out_count * REL_SIZE);
        sections[i].size = new_size;
        if (new_size == 0) {
            sections[i].output = false;
        } else {
            // Always write back: reloc order may have changed even when the
            // entry count did not.
            const bytes = std.mem.sliceAsBytes(new_rels[0..out_count]);
            @memcpy(sections[i].data[0..new_size], bytes);
        }
    }
}

// sortHiLoPairs ensures each R_MIPS_HI16 is immediately followed by its
// canonical paired R_MIPS_LO16 (same symbol index) in the relocation table.
//
// The PSP kernel pairs HI16 with the next LO16 in the relocation table
// (sequential scan, no symbol matching).  When the compiler interleaves
// multiple HI16/LO16 pairs (e.g. HI16_A, HI16_B, LO16_B, LO16_A), the
// kernel would mismatch them, causing wrong address reconstruction and a
// bus-error crash at runtime.  Reordering fixes the pairing without
// changing the meaning of any individual relocation.
fn sortHiLoPairs(rels: []Elf32_Rel) void {
    var i: usize = 0;
    while (i < rels.len) : (i += 1) {
        if (elfRelType(rels[i].r_info) != R_MIPS_HI16) continue;

        const hi_sym = elfRelSym(rels[i].r_info);

        // Find the canonical paired LO16: first unplaced LO16 with the same
        // symbol index after position i.
        var lo_pos: ?usize = null;
        for (i + 1..rels.len) |j| {
            if (elfRelType(rels[j].r_info) == R_MIPS_LO16 and
                elfRelSym(rels[j].r_info) == hi_sym)
            {
                lo_pos = j;
                break;
            }
        }

        if (lo_pos) |lp| {
            if (lp != i + 1) {
                // Move rels[lp] to position i+1 by rotating the slice.
                const lo_entry = rels[lp];
                var k: usize = lp;
                while (k > i + 1) : (k -= 1) {
                    rels[k] = rels[k - 1];
                }
                rels[i + 1] = lo_entry;
            }
            i += 1; // advance past the LO16 we just placed
        }
    }
}

fn reindexSections(sections: []ElfSection) void {
    var idx: u32 = 1;
    for (sections) |*s| {
        if (s.output) {
            s.out_index = idx;
            idx += 1;
        }
    }
}

// -- Layout calculation --------------------------------------------------------

fn calculateLayout(sections: []ElfSection, head: ElfHeader) Layout {
    var out_sects: u32 = 2; // NULL + shstrtab
    var alloc_size: u32 = 0;
    var mem_size: u32 = 0;
    var reloc_size: u32 = 0;
    var str_size: u32 = 1; // one byte for NULL section's empty name

    for (1..head.shnum) |i| {
        const s = &sections[i];
        if (!s.output) continue;

        out_sects += 1;
        str_size += @intCast(s.name.len + 1);

        if (s.shtype == SHT_PROGBITS) {
            const top = s.addr + s.size;
            if (top > alloc_size) alloc_size = top;
            if (top > mem_size) mem_size = top;
        } else if (s.shtype == SHT_REL or s.shtype == SHT_PRXRELOC) {
            reloc_size += s.size;
        } else {
            const top = s.addr + s.size;
            if (top > mem_size) mem_size = top;
        }
    }

    alloc_size = alignUp(alloc_size, 4);
    mem_size = alignUp(mem_size, 4);
    str_size = alignUp(str_size, 4);
    str_size += @intCast(ELF_SH_STRTAB.len + 1);

    const ph_base: u32 = EHDR_SIZE;
    const alloc_base: u32 = alignUp(ph_base + 2 * PHDR_SIZE, 0x10);
    const sh_base: u32 = alloc_base + alloc_size;
    const reloc_base: u32 = sh_base + out_sects * SHDR_SIZE;
    const shstr_base: u32 = reloc_base + reloc_size;
    const total_size: u32 = shstr_base + str_size;

    return Layout{
        .out_sects = out_sects,
        .alloc_size = alloc_size,
        .mem_size = mem_size,
        .reloc_size = reloc_size,
        .str_size = str_size,
        .ph_base = ph_base,
        .alloc_base = alloc_base,
        .sh_base = sh_base,
        .reloc_base = reloc_base,
        .shstr_base = shstr_base,
        .total_size = total_size,
    };
}

// -- Output writers ------------------------------------------------------------

fn writeHeader(out: []u8, src_head: ElfHeader, layout: Layout) void {
    const h = std.mem.bytesAsValue(Elf32_Ehdr, out[0..EHDR_SIZE]);
    h.e_magic = std.mem.nativeToLittle(u32, src_head.magic);
    h.e_class = src_head.class;
    h.e_data = src_head.data;
    h.e_idver = src_head.idver;
    @memset(&h.e_pad, 0);
    h.e_type = std.mem.nativeToLittle(u16, ELF_PRX_TYPE);
    h.e_machine = std.mem.nativeToLittle(u16, src_head.machine);
    h.e_version = std.mem.nativeToLittle(u32, src_head.version);
    h.e_entry = std.mem.nativeToLittle(u32, src_head.entry);
    h.e_phoff = std.mem.nativeToLittle(u32, layout.ph_base);
    h.e_shoff = std.mem.nativeToLittle(u32, layout.sh_base);
    h.e_flags = std.mem.nativeToLittle(u32, src_head.flags);
    h.e_ehsize = std.mem.nativeToLittle(u16, EHDR_SIZE);
    h.e_phentsize = std.mem.nativeToLittle(u16, PHDR_SIZE);
    h.e_phnum = std.mem.nativeToLittle(u16, 2);
    h.e_shentsize = std.mem.nativeToLittle(u16, SHDR_SIZE);
    h.e_shnum = std.mem.nativeToLittle(u16, @intCast(layout.out_sects));
    h.e_shstrndx = std.mem.nativeToLittle(u16, @intCast(layout.out_sects - 1));
}

fn writeProgramHeaders(
    out: []u8,
    sections: []ElfSection,
    modinfo_idx: usize,
    layout: Layout,
) void {
    const modinfo = &sections[modinfo_idx];
    // Read flags from the module info data (first u32)
    const mod_flags = lw(modinfo.data, 0);

    const paddr: u32 = blk: {
        const base = modinfo.addr + layout.alloc_base;
        if (mod_flags & 0x1000 != 0) break :blk 0x80000000 | base;
        break :blk base;
    };

    // PT_LOAD — loadable segment
    const ph0 = std.mem.bytesAsValue(Elf32_Phdr, out[layout.ph_base..][0..PHDR_SIZE]);
    ph0.p_type = std.mem.nativeToLittle(u32, 1); // PT_LOAD
    ph0.p_offset = std.mem.nativeToLittle(u32, layout.alloc_base);
    ph0.p_vaddr = 0;
    ph0.p_paddr = std.mem.nativeToLittle(u32, paddr);
    ph0.p_filesz = std.mem.nativeToLittle(u32, layout.alloc_size);
    ph0.p_memsz = std.mem.nativeToLittle(u32, layout.mem_size);
    ph0.p_flags = std.mem.nativeToLittle(u32, 5); // R + X
    ph0.p_align = std.mem.nativeToLittle(u32, 0x10);

    // PT_PRX_RELOC — tells the PSP kernel where relocation data lives.
    // This bypasses the buggy section-header relocation path which uses an
    // equality check (sh_flags == SHF_ALLOC) that skips sections with
    // additional flags like SHF_EXECINSTR, SHF_MERGE, or SHF_STRINGS.
    const ph1_base = layout.ph_base + PHDR_SIZE;
    const ph1 = std.mem.bytesAsValue(Elf32_Phdr, out[ph1_base..][0..PHDR_SIZE]);
    ph1.p_type = std.mem.nativeToLittle(u32, PT_PRX_RELOC);
    ph1.p_offset = std.mem.nativeToLittle(u32, layout.reloc_base);
    ph1.p_vaddr = 0;
    ph1.p_paddr = 0;
    ph1.p_filesz = std.mem.nativeToLittle(u32, layout.reloc_size);
    ph1.p_memsz = 0;
    ph1.p_flags = 0;
    ph1.p_align = std.mem.nativeToLittle(u32, 4);
}

fn writeAllocData(out: []u8, sections: []ElfSection, head: ElfHeader, layout: Layout) void {
    const base = layout.alloc_base;
    for (0..head.shnum) |i| {
        const s = &sections[i];
        if (!s.output) continue;
        if (s.shtype != SHT_PROGBITS) continue;
        @memcpy(out[base + s.addr ..][0..s.size], s.data[0..s.size]);
    }
}

fn writeSectionHeaders(
    out: []u8,
    sections: []ElfSection,
    head: ElfHeader,
    layout: Layout,
) void {
    // Zero out all section headers
    @memset(out[layout.sh_base..][0 .. layout.out_sects * SHDR_SIZE], 0);

    var reloc_ofs: u32 = layout.reloc_base;
    var str_ofs: u32 = 1; // index 0 is the null byte for the NULL section

    // NULL section is already zeroed, start writing from index 1
    var shdr_ptr: usize = layout.sh_base + SHDR_SIZE;

    for (1..head.shnum) |i| {
        const s = &sections[i];
        if (!s.output) continue;

        const base = shdr_ptr;
        sw(out, base + 0, str_ofs); // sh_name
        str_ofs += @intCast(s.name.len + 1);
        // Strip SHF_MERGE and SHF_STRINGS from allocated sections so the PSP
        // kernel's equality check (sh_flags == SHF_ALLOC) passes for .rodata.
        // These flags are linker hints with no meaning at load time.
        sw(out, base + 8, s.flags & ~(SHF_MERGE | SHF_STRINGS)); // sh_flags
        sw(out, base + 12, s.addr); // sh_addr
        sw(out, base + 20, s.size); // sh_size
        sw(out, base + 24, 0); // sh_link
        sw(out, base + 32, s.addralign); // sh_addralign
        sw(out, base + 36, s.entsize); // sh_entsize

        if (s.shtype == SHT_REL or s.shtype == SHT_PRXRELOC) {
            sw(out, base + 4, SHT_PRXRELOC); // sh_type
            const ref_idx: u32 = if (s.ref_idx) |ri| sections[ri].out_index else 0;
            sw(out, base + 28, ref_idx); // sh_info
            sw(out, base + 16, reloc_ofs); // sh_offset
            reloc_ofs += s.size;
        } else if (s.shtype == SHT_PROGBITS) {
            sw(out, base + 4, SHT_PROGBITS); // sh_type
            sw(out, base + 28, 0); // sh_info
            sw(out, base + 16, layout.alloc_base + s.addr); // sh_offset
        } else {
            sw(out, base + 4, s.shtype); // sh_type
            sw(out, base + 28, 0); // sh_info
            // Point non-PROGBITS non-reloc sections to end of alloc data
            sw(out, base + 16, layout.alloc_base + layout.alloc_size); // sh_offset
        }

        shdr_ptr += SHDR_SIZE;
    }

    // Write the final .shstrtab section header
    sw(out, shdr_ptr + 0, str_ofs); // sh_name (index of ".shstrtab" string)
    sw(out, shdr_ptr + 4, SHT_STRTAB); // sh_type
    sw(out, shdr_ptr + 8, 0); // sh_flags
    sw(out, shdr_ptr + 12, 0); // sh_addr
    sw(out, shdr_ptr + 16, layout.shstr_base); // sh_offset
    sw(out, shdr_ptr + 20, layout.str_size); // sh_size
    sw(out, shdr_ptr + 24, 0); // sh_link
    sw(out, shdr_ptr + 28, 0); // sh_info
    sw(out, shdr_ptr + 32, 1); // sh_addralign
    sw(out, shdr_ptr + 36, 0); // sh_entsize
}

fn writeRelocs(out: []u8, sections: []ElfSection, head: ElfHeader, layout: Layout) void {
    var ptr: usize = layout.reloc_base;
    for (0..head.shnum) |i| {
        const s = &sections[i];
        if (!s.output) continue;
        if (s.shtype != SHT_REL and s.shtype != SHT_PRXRELOC) continue;

        @memcpy(out[ptr..][0..s.size], s.data[0..s.size]);

        // Strip the symbol index from each relocation, keeping only the type byte
        const count = s.size / REL_SIZE;
        for (0..count) |j| {
            const off = ptr + j * REL_SIZE + 4; // offset of r_info
            const r_info = lw(out, off);
            sw(out, off, r_info & 0xFF);
        }

        ptr += s.size;
    }
}

fn writeShstrtab(out: []u8, sections: []ElfSection, head: ElfHeader, layout: Layout) void {
    const base = layout.shstr_base;
    @memset(out[base..][0..layout.str_size], 0);

    var ptr: usize = base + 1; // index 0 is null byte
    for (1..head.shnum) |i| {
        const s = &sections[i];
        if (!s.output) continue;
        @memcpy(out[ptr..][0..s.name.len], s.name);
        ptr += s.name.len + 1; // +1 for null terminator (already zeroed)
    }
    // Write the string table's own name last
    @memcpy(out[ptr..][0..ELF_SH_STRTAB.len], ELF_SH_STRTAB);
}

// -- Allegrex compatibility patches -------------------------------------------

// The PSP Allegrex CPU does not implement MIPS trap instructions (TEQ, TGE,
// TGEU, TLT, TLTU, TNE and their immediate forms), even though they are
// part of the MIPS II ISA.  LLVM's MIPS backend unconditionally emits
//
//   teq $divisor, $zero, 7
//
// before every integer division instruction as a hardware divide-by-zero
// check (equivalent to -mcheck-zero-division in GCC).  On Allegrex this
// raises Exception - Reserved Instruction (CAUSE ExcCode = 10).
//
// We replace every TEQ in executable sections with NOP (SLL $zero,$zero,0).
// TEQ encoding: opcode=SPECIAL(0), funct=0x34; mask = 0xFC00003F == 0x34.
fn patchTrapInstructions(sections: []ElfSection, head: ElfHeader) void {
    for (0..head.shnum) |i| {
        const s = &sections[i];
        if (!s.output) continue;
        if (s.shtype != SHT_PROGBITS) continue;
        if (s.flags & (SHF_ALLOC | SHF_EXECINSTR) != (SHF_ALLOC | SHF_EXECINSTR)) continue;

        const words = s.data.len / 4;
        for (0..words) |j| {
            const word = std.mem.readInt(u32, s.data[j * 4 ..][0..4], .little);
            if (word & 0xFC00003F == 0x00000034) {
                std.mem.writeInt(u32, s.data[j * 4 ..][0..4], 0x00000000, .little);
            }
        }
    }
}

// -- Main pipeline -------------------------------------------------------------

fn run(
    allocator: std.mem.Allocator,
    io: std.Io,
    in_path: []const u8,
    out_path: []const u8,
) !void {
    // Load
    const elf_data = try loadFile(allocator, io, in_path);
    defer allocator.free(elf_data);

    // Parse header
    const head = try validateHeader(elf_data);

    // Parse sections
    const parsed = try loadSections(allocator, elf_data, head);
    const sections = parsed.sections;
    const modinfo_idx = parsed.modinfo_idx;
    defer allocator.free(sections);

    // Filter relocations
    try processRelocs(allocator, sections, head);

    // Replace TEQ (trap-if-equal) instructions with NOP.  Allegrex does not
    // implement MIPS trap instructions; LLVM emits them for div-by-zero checks.
    patchTrapInstructions(sections, head);

    // Renumber kept sections
    reindexSections(sections);

    // Compute output layout
    const layout = calculateLayout(sections, head);

    // Allocate and zero output buffer
    const out_buf = try allocator.alloc(u8, layout.total_size);
    defer allocator.free(out_buf);
    @memset(out_buf, 0);

    // Write each region
    writeHeader(out_buf, head, layout);
    writeProgramHeaders(out_buf, sections, modinfo_idx, layout);
    writeAllocData(out_buf, sections, head, layout);
    writeSectionHeaders(out_buf, sections, head, layout);
    writeRelocs(out_buf, sections, head, layout);
    writeShstrtab(out_buf, sections, head, layout);

    // Write output file
    var out_file = std.Io.Dir.cwd().createFile(io, out_path, .{}) catch |err| {
        std.debug.print("Error: could not create output file '{s}': {}\n", .{ out_path, err });
        return err;
    };
    defer out_file.close(io);
    var buffer_writer: [4096]u8 = undefined;
    var writer = out_file.writer(io, &buffer_writer);
    const io_writer = &writer.interface;
    try io_writer.writeAll(out_buf);
    try io_writer.flush();
}

pub fn main(init: std.process.Init) !void {
    const allocator: std.mem.Allocator = init.arena.allocator();
    const io = init.io;
    const args = (try init.minimal.args.toSlice(allocator))[1..];

    if (args.len != 2) {
        std.debug.print("Usage: zprxgen infile.elf outfile.prx\n", .{});
        std.process.exit(1);
    }

    try run(allocator, io, args[0], args[1]);
}
