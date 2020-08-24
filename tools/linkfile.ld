/*
Based on PSPSDK:

Copyright (c) 2005  adresd
Copyright (c) 2005  Marcus R. Brown
Copyright (c) 2005  James Forshaw
Copyright (c) 2005  John Kelley
Copyright (c) 2005  Jesper Svennevid
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. The names of the authors may not be used to endorse or promote products
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHORS ``AS IS'' AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

ENTRY(module_start)
SECTIONS
{
   PROVIDE (__executable_start = 0x0); 
   
  .interp         : { *(.interp) }
  .dynamic        : { *(.dynamic) }
  .hash           : { *(.hash) }
  .dynsym         : { *(.dynsym) }
  .dynstr         : { *(.dynstr) }
  .gnu.version    : { *(.gnu.version) }
  .gnu.version_d  : { *(.gnu.version_d) }
  .gnu.version_r  : { *(.gnu.version_r) }
  .rel.text       : { *(.rel.text .rel.text.* .rel.gnu.linkonce.t.*) }
  .rela.text      : { *(.rela.text .rela.text.* .rela.gnu.linkonce.t.*) }
  .rel.init       : { *(.rel.init) }
  .rela.init      : { *(.rela.init) }
  .rel.fini       : { *(.rel.fini) }
  .rela.fini      : { *(.rela.fini) }
  /* PSP-specific relocations. */
  .rel.sceStub.text   : { *(.rel.sceStub.text) *(SORT(.rel.sceStub.text.*)) }
  .rel.lib.ent.top    : { *(.rel.lib.ent.top) }
  .rel.lib.ent        : { *(.rel.lib.ent) }
  .rel.lib.ent.btm    : { *(.rel.lib.ent.btm) }
  .rel.lib.stub.top   : { *(.rel.lib.stub.top) }
  .rel.lib.stub       : { *(.rel.lib.stub) }
  .rel.lib.stub.btm   : { *(.rel.lib.stub.btm) }
  .rel.rodata.sceModuleInfo   : { *(.rel.rodata.sceModuleInfo) }
  .rel.rodata.sceResident     : { *(.rel.rodata.sceResident) }
  .rel.rodata.sceNid          : { *(.rel.rodata.sceNid) }
  .rel.rodata.sceVstub        : { *(.rel.rodata.sceVstub) *(SORT(.rel.rodata.sceVstub.*)) }
  .rel.rodata     : { *(.rel.rodata .rel.rodata.* .rel.gnu.linkonce.r.*) }
  .rela.rodata    : { *(.rela.rodata .rela.rodata.* .rela.gnu.linkonce.r.*) }
  .rel.data.rel.ro   : { *(.rel.data.rel.ro*) }
  .rela.data.rel.ro   : { *(.rel.data.rel.ro*) }
  .rel.data       : { *(.rel.data .rel.data.* .rel.gnu.linkonce.d.*) }
  .rela.data      : { *(.rela.data .rela.data.* .rela.gnu.linkonce.d.*) }
  .rel.tdata	  : { *(.rel.tdata .rel.tdata.* .rel.gnu.linkonce.td.*) }
  .rela.tdata	  : { *(.rela.tdata .rela.tdata.* .rela.gnu.linkonce.td.*) }
  .rel.tbss	  : { *(.rel.tbss .rel.tbss.* .rel.gnu.linkonce.tb.*) }
  .rela.tbss	  : { *(.rela.tbss .rela.tbss.* .rela.gnu.linkonce.tb.*) }
  .rel.ctors      : { *(.rel.ctors) }
  .rela.ctors     : { *(.rela.ctors) }
  .rel.dtors      : { *(.rel.dtors) }
  .rela.dtors     : { *(.rela.dtors) }
  .rel.got        : { *(.rel.got) }
  .rela.got       : { *(.rela.got) }
  .rel.sdata      : { *(.rel.sdata .rel.sdata.* .rel.gnu.linkonce.s.*) }
  .rela.sdata     : { *(.rela.sdata .rela.sdata.* .rela.gnu.linkonce.s.*) }
  .rel.sbss       : { *(.rel.sbss .rel.sbss.* .rel.gnu.linkonce.sb.*) }
  .rela.sbss      : { *(.rela.sbss .rela.sbss.* .rela.gnu.linkonce.sb.*) }
  .rel.sdata2     : { *(.rel.sdata2 .rel.sdata2.* .rel.gnu.linkonce.s2.*) }
  .rela.sdata2    : { *(.rela.sdata2 .rela.sdata2.* .rela.gnu.linkonce.s2.*) }
  .rel.sbss2      : { *(.rel.sbss2 .rel.sbss2.* .rel.gnu.linkonce.sb2.*) }
  .rela.sbss2     : { *(.rela.sbss2 .rela.sbss2.* .rela.gnu.linkonce.sb2.*) }
  .rel.bss        : { *(.rel.bss .rel.bss.* .rel.gnu.linkonce.b.*) }
  .rela.bss       : { *(.rela.bss .rela.bss.* .rela.gnu.linkonce.b.*) }
  .rel.plt        : { *(.rel.plt) }
  .rela.plt       : { *(.rela.plt) }

   .text 0 : { *(.text .text.*) }
   /* PSP library stub functions. */
   .sceStub.text : { *(.sceStub.text) *(SORT(.sceStub.text.*)) }

   /* PSP library entry table and library stub table. */
   .lib.ent.top    : { *(.lib.ent.top) }
   .lib.ent        : { *(.lib.ent) }
   .lib.ent.btm    : { *(.lib.ent.btm) }
   .lib.stub.top   : { *(.lib.stub.top) }
   .lib.stub       : { *(.lib.stub) }
   .lib.stub.btm   : { *(.lib.stub.btm) }

   /* PSP read-only data for module info, NIDs, and Vstubs.  The
    .rodata.sceModuleInfo section must appear before the .rodata section
     otherwise it would get absorbed into .rodata and the PSP bootloader
     would be unable to locate the module info structure. */
   .rodata.sceModuleInfo    : { *(.rodata.sceModuleInfo) }
   .rodata.sceResident      : { *(.rodata.sceResident) }
   .rodata.sceNid           : { KEEP (*(.rodata.sceNid)) }
   .rodata.sceVstub         : { *(.rodata.sceVstub) *(SORT(.rodata.sceVstub.*)) }

   /*Debug Data*/
   /* Stabs debugging sections.  */
   .stab          0 : { *(.stab) }
   .stabstr       0 : { *(.stabstr) }
   .stab.excl     0 : { *(.stab.excl) }
   .stab.exclstr  0 : { *(.stab.exclstr) }
   .stab.index    0 : { *(.stab.index) }
   .stab.indexstr 0 : { *(.stab.indexstr) }
   .comment       0 : { *(.comment) }

   /* DWARF debug sections.
     Symbols in the DWARF debugging sections are relative to the beginning
     of the section so we begin them at 0.  */
   /* DWARF 5 section */
   .debug_info 0 : { *(.debug_info) }
   .debug_pubnames 0 : { *(.debug_pubnames) }
   .debug_pubtypes 0 : { *(.debug_pubtypes) }
   .debug_frame 0 : { *(.debug_frame) }
   .debug_line 0 : { *(.debug_line) }
   .debug_loc 0 : { *(.debug_loc) }
   .debug_aranges 0 : { *(.debug_aranges) }
   .debug_ranges 0 : { *(.debug_ranges) }

   /DISCARD/ : { *(.comment) *(.pdr) }
}