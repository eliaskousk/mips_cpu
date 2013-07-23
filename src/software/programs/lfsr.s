# =================================
# LFSR assembly program
# =================================

        .set noat

        .globl main                     # Call main by SPIM

        .text                           # Text section

main:   #lui     $10, 0xC018            # Correct result HI
        #ori     $10, $10, 0xCB25
        #lui     $11, 0x1750            # Correct result LO
        #ori     $11, $11, 0xF803

        lui     $10, 0x00000            # Correct result 32 bits
        ori     $10, $10, 0x0000

        lui     $15, 0x0123             # LFSR Seed
        ori     $15, $15, 0x4567
        lui     $16, 0x89AB             # LFSR Seed
        ori     $16, $16, 0xCDEF

        addi    $12, $0, 0x64           # Last vector before repeat

        # Prepare registers for MISR
        lui     $22, 0x1800
        ori     $22, $22, 0x0002
        not     $23, $0
        addi    $6, $0, 0
        add     $9, $1, $0

        addi    $1, $0, 0               # i = 0

lfsr:   andi    $2, $9, 1
        andi    $3, $9, 2
        andi    $4, $9, 8
        andi    $5, $9, 16
        slr     $3, $3, 1
        slr     $4, $4, 3
        slr     $5, $5, 4
        xor     $2, $2, $3
        xor     $2, $2, $4
        xor     $2, $2, $5
        sll     $9, $9, 1
        or      $9, $9, $2
        mult    $9, $9
        mfhi    $3
        mflo    $4
        xor     $13, $3, $4

misr:   sll     $24, $23, 0x001f  
        sra     $25, $24, 0x001f  
        and     $25, $25, $22
        xor     $23, $23, $25
        srlv    $23, $23, $1
        addu    $23, $23, $24
        xor     $23, $23, $13

        addi    $1, $1, 1
        bne     $14, $12, lfsr
        sub     $13, $10, $23           # Check misr signature in $23 with correct result
        #sub    $14, $11, $23

end:
     
