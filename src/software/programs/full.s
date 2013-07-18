# =================================
# All instructions assembly program
# =================================
# A simple program illustrating all
# the implemented MIPS instructions
# without any particular purpose
# =================================

        .text                       # Text section
        .globl main                 # Call main by SPIM

main:   lw      $s1, 100($s2)
        sw      $s1, 100($s2)

        lb      $s1, 100($s2)
        lbu     $s1, 100($s2)
        lh      $s1, 100($s2)
        lhu     $s1, 100($s2)
        sb      $s1, 100($s2)
        sh      $s1, 100($s2)

        addiu   $t1, $s1, 3
        addiu   $t1, $s1, 3
        andi    $t1, $s1, 3
        ori     $t1, $s1, 3
        xori    $t1, $s1, 3

        add     $s1, $s2, $s3
        addu    $s1, $s2, $s3

        sub     $s1, $s2, $s3
        subu    $s1, $s2, $s3

        mult    $s1, $s2

        and     $s1, $s2, $s3
        or      $s1, $s2, $s3
        nor     $s1, $s2, $s3
        xor     $s1, $s2, $s3

        mfhi    $t1
        mflo    $t1
        mthi    $t1
        mtlo    $t1

        sll     $s1, $s2, 3
        srl     $s1, $s2, 3
        sra     $s1, $s2, 3

        sllv    $s1, $s2, $s3
        srlv    $s1, $s2, $s3
        srav    $s1, $s2, $s3

        lui     $t1, 100

        slti    $t0, $s0, 10
        sltiu   $t0, $s0, 10

        slt     $t0, $s0, $s1
        sltu    $t0, $s0, $s1

        beq     $s1, $s2, end
        bne     $s1, $s2, end

        blez    $s1, end
        bgtz    $s1, end
        bltz    $s1, end
        bgez    $s1, end

        jr      $t0
        jalr    $t0

        j       end
        jal     end

#        test

end:
