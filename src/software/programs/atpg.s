# =================================
# ATPG assembly p$og$am
# =================================
# 
# =================================

        .set noat

        .globl main             # Call main by SPIM

        .text                   # Text section

        lui     $6, 0x3555      # Correct result
        ori     $6, $6, 0x5555
        addi    $5, $0, 0x6C    # Vector limit = 108
        lui     $22, 1800       # Mask
        ori     $22, 2
        addi    $23, $0, 0
        addi    $1, $0, 0       # Temp = 0

atpg:   lw      $2, $1(0x180)   # First vector address
        lw      $3, $1(0x330)   # Last vector address
        mult    $2, $3
        mfhi    $2
        mflo    $3
        xor     $3, $2, $3

misr:   sll     $24, $23, 31
        sra     $25, $24, 31
        and     $25, $25, $22
        xor     $23, $23, $25
        srl     $23, $23, $24
        addu    $23, $23, $24
        xor     $23, $23, $3
        addi    $1, $1, 4       # Increment address
        addi    $7, $7, 1
        bne     $7, $5, atpg
        sub     $7, $6, $23     # Check output with correct result

end:
