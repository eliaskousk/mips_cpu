# =================================
# ATPG assembly program
# =================================

        .set noat

        .globl main                     # Call main by SPIM

        .text                           # Text section

main:   #lui     $10, 0xC921             # Correct result HI
        #ori     $10, $10, 0xB21F
        #lui     $11, 0x4172            # Correct result LO
        #ori     $11, $11, 0x1733

        lui     $10, 0x00000            # Correct result 32 bits
        ori     $10, $10, 0x0000

        addi    $12, $0, 0x6C           # Vector limit = 108

        # Prepare registers for MISR
        lui     $22, 0x1800
        ori     $22, $22, 0x0002
        not     $23, $0

        add     $14, $0, $0             # Address = 0
        add     $1, $0, $0              # i = 0

        lw      $3, 0x000($1)           # First vector address (0)
        lw      $4, 0x1B0($1)           # Last vector address (108th vector X 4 = 432 = 0x1B0)

atpg:   mult    $3, $4
        mfhi    $3
        mflo    $4
        xor     $13, $3, $4

misr:   sll     $24, $23, 31
        sra     $25, $24, 31
        and     $25, $25, $22
        xor     $23, $23, $25
        srl     $23, $23, $24
        addu    $23, $23, $24
        xor     $23, $23, $13

        addi    $14, $14, 4
        addi    $1, $1, 1
        bne     $14, $12, atpg
        sub     $13, $10, $23           # Check misr signature in $23 with correct result
        #sub     $14, $11, $23

end:
