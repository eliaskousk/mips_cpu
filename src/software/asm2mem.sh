#!/bin/sh
#
# -------------------------------------------
# Create instruction words from assembly file
# -------------------------------------------

PLAIN_FNAME = $1
ASM_FILE = "PLAIN_FNAME".s

as -O0 -mips3 -mno-div-checks   -o "PLAIN_FNAME".o "ASM_FILE"
ld -EB -Ttext 0x000000 -eentry -Map "PLAIN_FNAME".map -s -N -o "PLAIN_FNAME" "PLAIN_FNAME".o
objdump  --prefix-address --show-raw-insn --disassemble --disassemble-zeroes "PLAIN_FNAME" > "PLAIN_FNAME".disasm
