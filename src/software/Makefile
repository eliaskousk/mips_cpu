# ===============================
# MIPS CPU Software Makefile v0.2
# -------------------------------
# Creates instruction memory VHDL
# files for all the assembly
# programs
# ===============================

MIPS_CROSS = /opt/mipscross/bin
TOOLS_DIR = ./tools
PROGRAMS_DIR = ./programs
PROGRAMS_BUILD_DIR = $(PROGRAMS_DIR)/build

GCC = gcc -Wall -O -g
GCC_MIPS  = $(MIPS_CROSS)/mips-unknown-linux-gnu-gcc -O2 -Wall -c -s
AS_MIPS   = $(MIPS_CROSS)/mips-unknown-linux-gnu-as
LD_MIPS   = $(MIPS_CROSS)/mips-unknown-linux-gnu-ld
DUMP_MIPS = $(MIPS_CROSS)/mips-unknown-linux-gnu-objdump
RM = rm -f


all: tools programs

clean:
	-$(RM) $(PROGRAMS_BUILD_DIR)/* $(TOOLS_DIR)/create_imem
	echo Clean Done

# =====
# Tools
# =====

tools : $(TOOLS_DIR)create_imem
	echo Tools built

$(TOOLS_DIR)create_imem: tools/create_imem.c
	@$(CC) -o tools/create_imem tools/create_imem.c

# ========
# Programs
# ========

programs: full matrix simple fibonacci lfsr counter atpg misr 


full: $(PROGRAMS_BUILD_DIR)/full.code $(TOOLS_DIR)create_imem
	$(TOOLS_DIR)/create_imem tools/imem_template.vhd $(PROGRAMS_BUILD_DIR)/$@.code ../rtl/imem/im_bram_512x32_0_$@.vhd

matrix: $(PROGRAMS_BUILD_DIR)/matrix.code $(TOOLS_DIR)create_imem
	$(TOOLS_DIR)/create_imem tools/imem_template.vhd $(PROGRAMS_BUILD_DIR)/$@.code ../rtl/imem/im_bram_512x32_0_$@.vhd

simple: $(PROGRAMS_BUILD_DIR)/simple.code $(TOOLS_DIR)create_imem
	$(TOOLS_DIR)/create_imem tools/imem_template.vhd $(PROGRAMS_BUILD_DIR)/$@.code ../rtl/imem/im_bram_512x32_0_$@.vhd

fibonacci: $(PROGRAMS_BUILD_DIR)/fibonacci.code $(TOOLS_DIR)create_imem
	$(TOOLS_DIR)/create_imem tools/imem_template.vhd $(PROGRAMS_BUILD_DIR)/$@.code ../rtl/imem/im_bram_512x32_0_$@.vhd

lfsr: $(PROGRAMS_BUILD_DIR)/lfsr.code $(TOOLS_DIR)create_imem
	$(TOOLS_DIR)/create_imem tools/imem_template.vhd $(PROGRAMS_BUILD_DIR)/$@.code ../rtl/imem/im_bram_512x32_0_$@.vhd

counter: $(PROGRAMS_BUILD_DIR)/counter.code $(TOOLS_DIR)create_imem
	$(TOOLS_DIR)/create_imem tools/imem_template.vhd $(PROGRAMS_BUILD_DIR)/$@.code ../rtl/imem/im_bram_512x32_0_$@.vhd

atpg: $(PROGRAMS_BUILD_DIR)/atpg.code $(TOOLS_DIR)create_imem
	$(TOOLS_DIR)/create_imem tools/imem_template.vhd $(PROGRAMS_BUILD_DIR)/$@.code ../rtl/imem/im_bram_512x32_0_$@.vhd

misr: $(PROGRAMS_BUILD_DIR)/misr.code $(TOOLS_DIR)create_imem
	$(TOOLS_DIR)/create_imem tools/imem_template.vhd $(PROGRAMS_BUILD_DIR)/$@.code ../rtl/imem/im_bram_512x32_0_$@.vhd


$(PROGRAMS_BUILD_DIR)/%.code: $(PROGRAMS_DIR)/%.s
	$(AS_MIPS) -O0 -mips3 -o $(PROGRAMS_BUILD_DIR)/$*.o $<
	$(LD_MIPS) -EB -Ttext 0x00000000 -emain -Map $(PROGRAMS_BUILD_DIR)/$*.map -s -N -o $(PROGRAMS_BUILD_DIR)/$* $(PROGRAMS_BUILD_DIR)/$*.o
	$(DUMP_MIPS) --prefix-address --show-raw-insn --disassemble --disassemble-zeroes $(PROGRAMS_BUILD_DIR)/$* > $(PROGRAMS_BUILD_DIR)/$*.disasm
	cat $(PROGRAMS_BUILD_DIR)/$*.disasm | tail -n+6 | sed '/nop/d' | cut -f1 | cut -f2 -d' ' > $(PROGRAMS_BUILD_DIR)/$*.code
