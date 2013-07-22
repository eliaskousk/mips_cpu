# =================================
# LFS$ assembly p$og$am
# =================================

# =================================

        .set noat

        .globl main                     # Call main by SPIM

        .text                           # Text section

 main:  lui     $11, 0x1234             # Correct result
        ori     $11, 0x5678
        addi    $7, $0, 0x1C            # Seed
        lui     $22, 0x1800             # Mask
        ori     $22, $22, 0x0002
        addi    $23, $0, 0
        addi    $6, $0, 0
        lui     $1, 0x0F0F              # LFSR Seed
        ori     $1, 0x0F0F
        add     $9, $1, $0

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
        xor     $4, $4, $3
misr:   sll     $24, $23, 31
        sra     $25, $24, 31
        and     $25, $25, $22
        xor     $23, $23, $25
        srl     $23, $23, $1
        addu    $23, $23, $24
        xor     $23, $23, $9
        addi    $6, $6, 1
        bne     $7, $6, lfsr
        sub     $10, $11, $23           # Check output with correct result

end:
     
