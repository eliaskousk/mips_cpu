#!/bin/sh
#
# -------------------------------------------
# Create instruction words from assembly file
# -------------------------------------------

TOOLCHAIN=/opt/mipscross/bin
PLAIN_FNAME=$1
ASM_FILE=${PLAIN_FNAME}.s

${TOOLCHAIN}/mipsel-unknown-linux-gnu-as -O0 -mips3 -o ${PLAIN_FNAME}.o ${ASM_FILE}
${TOOLCHAIN}/mipsel-unknown-linux-gnu-ld -EL -Ttext 0x000000 -emain -Map ${PLAIN_FNAME}.map -s -N -o ${PLAIN_FNAME} ${PLAIN_FNAME}.o
${TOOLCHAIN}/mipsel-unknown-linux-gnu-objdump --prefix-address --show-raw-insn --disassemble --disassemble-zeroes ${PLAIN_FNAME} > ${PLAIN_FNAME}.disasm
cat ${PLAIN_FNAME}.disasm | tail -n+5 | cut -f1 | cut -f2 -d' ' > simple.code
tools/create_image tools/imem_template.vhd program/${PLAIN_FNAME}.code im_bram_512x32_0.vhd
