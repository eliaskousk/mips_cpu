# =================================
# Counter SBST assembly program
# =================================

# =================================

        .set noat

        .globl main             # Call main by SPIM

        .text                   # Text section

main:   lui     $6, 0x1234      # Correct result
        ori     $6, $6, 0x5678
        addi    $5, $0, 256     # Vector limit = 256
        lui     $22, 1800       # Mask
        ori     $22, 2
        addi    $23, $0, 0
        addi    $2, $0, 0       # Temp = 0
        addi    $1, $0, 1       # Counter = 1

count:  add     $2, $1, $0      # Set 7 downto 0
        sll     $2, $2, 8
        ori     $2, $2, $1      # Set 15 downto 0
        sll     $2, $2, 8
        or      $2, $2, $1      # Set 23 downto 0
        sll     $2, $2, 8
        or      $2, $2, $1      # Set 31 downto 0
        mult    $2, $2
        mfhi    $3
        mflo    $4
        xor     $4, $4, $3

misr:   sll     $24, $23, 31
        sra     $25, $24, 31
        and     $25, $25, $22
        xor     $23, $23, $25
        srl     $23, $23, 1
        addu    $23, $23, $24
        xor     $23, $23, $4    # Signature on $23
        addi    $1, $1, 1
        bne     $1, $5, count
        sub     $7, $6, $23     # Check output with correct result

end:
