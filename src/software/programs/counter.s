# =================================
# Counter SBST assembly program
# =================================

        .set noat

        .globl main                     # Call main by SPIM

        .text                           # Text section

main:   #lui     $10, 0xF4DA            # Correct result HI
        #ori     $10, $10, 0x9748 
        #lui     $11, 0xF9DB            # Correct result LO
        #ori     $11, $11, 0xB48A

        lui     $10, 0x00000            # Correct result 32 bits (Edit this!)
        ori     $10, $10, 0x0000

        addi    $12, $0, 256            # Counter limit = 256

        # Prepare registers for MISR
        lui     $22, 0x1800
        ori     $22, $22, 0x0002
        not     $23, $0

        add     $1, $0, $0              # i = 0
        add     $2, $0, $0

count:  add     $2, $1, $0              # Set 0th byte
        sll     $2, $2, 8
        or      $2, $2, $1              # Set 1st byte
        sll     $2, $2, 8
        or      $2, $2, $1              # Set 2nd byte
        sll     $2, $2, 8
        or      $2, $2, $1              # Set 3rd byte
        mult    $2, $2
        mfhi    $3
        mflo    $4
        xor     $13, $3, $4

misr:   sll     $24, $23, 0x001f  
        sra     $25, $24, 0x001f  
        and     $25, $25, $22
        xor     $23, $23, $25
        srl     $23, $23, 0x0001
        addu    $23, $23, $24
        xor     $23, $23, $13

        addi    $1, $1, 1
        bne     $1, $12, count
        slt     $13, $10, $23           # Check misr signature in $23 with correct result

end:
