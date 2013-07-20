# =================================
# All instructions assembly program
# =================================
# A simple program illustrating all
# the implemented MIPS instructions
# without any particular purpose
# =================================

        .set noat

        .globl main                             # Call main by SPIM

        .text                                   # Text section

main:   add     $1, $0, $0                      # Reg[01] = x"00000000",        Bus_w = x"00000000",    PC=00 x"00"

        addiu   $2, $0, 0x1111                  # Reg[02] = x"00001111",        Bus_w = x"00001111",    PC=04 x"04"
        sw      $2, 0($1)                       # DM(0)   = x"00001111",        Bus_w = x"00001111",    PC=08 x"08"

        addiu   $3, $0, 0x0001                  # Reg[03] = x"00000001",        Bus_w = x"00000001",    PC=12 x0C
        sw      $3, 4($1)                       # DM(4)   = x"00000001",        Bus_w = x"00000001",    PC=16 x10

        addiu   $4, $0, 0x8000                  # Reg[04] = x"00008000",        Bus_w = x"00008000",    PC=20 x"14"
        sw      $4, 8($1)                       # DM(8)   = x"00008000",        Bus_w = x"00008000",    PC=24 x"18"

        addiu   $5, $0, 0xFFFF                  # Reg[05] = x"0000FFFF",        Bus_w = x"0000FFFF",    PC=28 x"1C"
        lui     $5, 0xFFFF                      # Reg[05] = x"FFFFFFFF",        Bus_w = x"FFFFFFFF",    PC=32 x"20"
        sw      $5, 12($1)                      # DM(12)  = x"FFFFFFFF",        Bus_w = x"FFFFFFFF",    PC=36 x"24"

load:   lw      $6, 12($1)                      # Reg[06] = x"FFFFFFFF",        Bus_w = x"00000000",    PC=40 x"00"
        sw      $6, 16($1)                      # DM(16)  = x"FFFFFFFF",        Bus_w = x"FFFFFFFF",    PC=44 x"24"

        lh      $7, 12($1)                      # Reg[07] = x"0000FFFF",        Bus_w = x"00000000",    PC=48 x"00"
        sw      $7, 20($1)                      # DM(20)  = x"0000FFFF",        Bus_w = x"FFFFFFFF",    PC=52 x"24"

        lhu     $8, 12($1)                      # Reg[08] = x"0000FFFF",        Bus_w = x"00000000",    PC=56 x"00"
        sw      $8, 24($1)                      # DM(24)  = x"0000FFFF",        Bus_w = x"FFFFFFFF",    PC=60 x"24"

        lb      $9, 12($1)                      # Reg[09] = x"000000FF",        Bus_w = x"00000000",    PC=64 x"00"
        sw      $9, 28($1)                      # DM(28)  = x"000000FF",        Bus_w = x"FFFFFFFF",    PC=68 x"24"

        lbu     $10, 12($1)                     # Reg[10] = x"00000000",        Bus_w = x"00000000",    PC=72 x"00"
        sw      $10, 32($1)                     # DM(32)  = x"000000FF",        Bus_w = x"FFFFFFFF",    PC=76 x"24"

store:  sw      $6, 36($1)                      # DM(36)  = x"FFFFFFFF",        Bus_w = x"00001111",    PC=80 x"08"
        sh      $6, 40($1)                      # DM(40)  = x"0000FFFF",        Bus_w = x"00001111",    PC=84 x"08"
        sb      $6, 44($1)                      # DM(44)  = x"000000FF",        Bus_w = x"00001111",    PC=88 x"08"

alu:    addi    $11, $2, 0x1111                 # Reg[11] = x"00002222",        Bus_w = x"00000000",    PC=92 x"00"
        sw      $11, 48($1)                     # DM(48)  = x"00002222",        Bus_w = x"FFFFFFFF",    PC=96 x"24"

        addiu   $12, $2, 0x2222                 # Reg[12] = x"00003333",        Bus_w = x"00000000",    PC=100 x"00"
        sw      $12, 52($1)                     # DM(52)  = x"00003333",        Bus_w = x"FFFFFFFF",    PC=104 x"24"

        andi    $13, $2, 0x3333                 # Reg[13] = x"????????",        Bus_w = x"00000000",    PC=108 x"00"
        sw      $13, 56($1)                     # DM(56)  = x"????????",        Bus_w = x"FFFFFFFF",    PC=112 x"24"

        ori     $14, $2, 0x4444                 # Reg[14] = x"????????",        Bus_w = x"00000000",    PC=116 x"00"
        sw      $14, 60($1)                     # DM(60)  = x"????????",        Bus_w = x"FFFFFFFF",    PC=120 x"24"

        xori    $15, $2, 0x5555                 # Reg[15] = x"????????",        Bus_w = x"00000000",    PC=124 x"00"
        sw      $15, 64($1)                     # DM(64)  = x"????????",        Bus_w = x"FFFFFFFF",    PC=128 x"24"


        add     $16, $11, $12                   # Reg[16] = x"00005555",        Bus_w = x"00000000",    PC=132 x"00"
        sw      $16, 68($1)                     # DM(68)  = x"00005555",        Bus_w = x"FFFFFFFF",    PC=136 x"24"

        addu    $17, $11, $12                   # Reg[17] = x"00005555",        Bus_w = x"00000000",    PC=140 x"00"
        sw      $17, 72($1)                     # DM(72)  = x"00005555",        Bus_w = x"FFFFFFFF",    PC=144 x"24"

        sub     $18, $16, $12                   # Reg[18] = x"00002222",        Bus_w = x"00000000",    PC=148 x"00"
        sw      $18, 76($1)                     # DM(76)  = x"00002222",        Bus_w = x"FFFFFFFF",    PC=152 x"24"

        subu    $19, $16, $11                   # Reg[19] = x"00003333",        Bus_w = x"00000000",    PC=156 x"00"
        sw      $19, 80($1)                     # DM(80)  = x"00003333,         Bus_w = x"FFFFFFFF",    PC=160 x"24"

        and     $20, $5, $16                    # Reg[20] = x"00005555",        Bus_w = x"00000000",    PC=164 x"00"
        sw      $20, 84($1)                     # DM(84)  = x"00005555",        Bus_w = x"FFFFFFFF",    PC=168 x"24"

        or      $21, $4, $17                    # Reg[21] = x"80005555",        Bus_w = x"00000000",    PC=172 x"00"
        sw      $21, 88($1)                     # DM(88)  = x"80005555",        Bus_w = x"FFFFFFFF",    PC=176 x"24"

        nor     $22, $5, $13                    # Reg[22] = x"7FFF6666",        Bus_w = x"00000000",    PC=180 x"00"
        sw      $22, 92($1)                     # DM(92)  = x"7FFF6666",        Bus_w = x"FFFFFFFF",    PC=184 x"24"

        xor     $23, $2, $5                     # Reg[23] = x"80001111",        Bus_w = x"00000000",    PC=188 x"00"
        sw      $23, 96($1)                     # DM(96)  = x"80001111",        Bus_w = x"FFFFFFFF",    PC=192 x"24"

        mult    $5, $11                         # Reg[XX] = x"XXXXXXXX",        Bus_w = x"XXXXXXXX",    PC=196 x"00"

        mfhi    $24                             # Reg[24] = x"00002221",        Bus_w = x"00000000",    PC=200 x"00"
        sw      $24, 100($1)                    # DM(100) = x"00002221",        Bus_w = x"FFFFFFFF",    PC=204 x"24"

        mflo    $25                             # Reg[25] = x"FFFFDDDE",        Bus_w = x"00000000",    PC=208 x"00"
        sw      $25, 104($1)                    # DM(104) = x"FFFFDDDE",        Bus_w = x"FFFFFFFF",    PC=212 x"24"

        mthi    $11                             # Reg[HI] = x"00002222",        Bus_w = x"00000000",    PC=216 x"00"
        mtlo    $12                             # Reg[LO] = x"00003333",        Bus_w = x"00000000",    PC=220 x"00"

shift:  sll     $26, $3, 3                      # Reg[26] = x"00000008",        Bus_w = x"00000000",    PC=224 x"00"
        sw      $26, 108($1)                    # DM(108)  = x"FFFFFFFF",       Bus_w = x"FFFFFFFF",    PC=228 x"24"

        srl     $27, $4, 3                      # Reg[27] = x"10000000",        Bus_w = x"00000000",    PC=232 x"00"
        sw      $27, 112($1)                    # DM(112) = x"10000000",        Bus_w = x"FFFFFFFF",    PC=236 x"24"

        sra     $28, $4, 3                      # Reg[28] = x"F0000000",        Bus_w = x"00000000",    PC=240 x"00"
        sw      $28, 116($1)                    # DM(116) = x"F0000000",        Bus_w = x"FFFFFFFF",    PC=244 x"24"

        sllv    $29, $3, $26                    # Reg[29] = x"00000100",        Bus_w = x"00000000",    PC=248 x"00"
        sw      $29, 120($1)                    # DM(120) = x"00000100",        Bus_w = x"FFFFFFFF",    PC=252 x"24"

        srlv    $30, $4, $26                    # Reg[30] = x"00100000",        Bus_w = x"00000000",    PC=256 x"00"
        sw      $30, 124($1)                    # DM(124) = x"00100000",        Bus_w = x"FFFFFFFF",    PC=260 x"24"

        srav    $31, $4, $26                    # Reg[31] = x"FFF00000",        Bus_w = x"00000000",    PC=264 x"00"
        sw      $31, 128($1)                    # DM(128) = x"FFF00000",        Bus_w = x"FFFFFFFF",    PC=268 x"24"


lui:    lui     $6, 0xAAAA                      # Reg[06] = x"AAAA0000",        Bus_w = x"00000000",    PC=272 x"00"
        sw      $6, 132($1)                     # DM(132) = x"AAAA0000",        Bus_w = x"FFFFFFFF",    PC=276 x"24"

slt:    slti    $7, $6, 0xBBBB                  # Reg[07] = x"00000001",        Bus_w = x"00000000",    PC=280 x"00"
        sw      $7, 136($1)                     # DM(136) = x"00000001",        Bus_w = x"FFFFFFFF",    PC=284 x"24"

        sltiu   $8, $5, 0xBBBB                  # Reg[08] = x"00000000",        Bus_w = x"00000000",    PC=288 x"00"
        sw      $8, 140($1)                     # DM(140) = x"00000000",        Bus_w = x"FFFFFFFF",    PC=292 x"24"

        slt     $9, $6, $5                      # Reg[09] = x"00000001",        Bus_w = x"00000000",    PC=296 x"00"
        sw      $9, 144($1)                     # DM(144) = x"00000001",        Bus_w = x"FFFFFFFF",    PC=300 x"24"

        sltu    $10, $5, $6                     # Reg[10] = x"00000000",        Bus_w = x"00000000",    PC=304 x"00"
        sw      $10, 148($1)                    # DM(148) = x"00000000",        Bus_w = x"FFFFFFFF",    PC=308 x"24"

beq:    beq     $3, $7, bne                     # Branch taken
        addu    $11, $11, $2                    # Reg[11] = x"--------",        Bus_w = x"00000000",    PC=316 x"00"
        sw      $11, 152($1)                    # DM(152) = x"--------",        Bus_w = x"FFFFFFFF",    PC=320 x"24"

bne:    bne     $3, $7, blez                    # Branch not taken
        addu    $11, $11, $2                    # Reg[11] = x"00003333",        Bus_w = x"00000000",    PC=328 x"00"
        sw      $11, 156($1)                    # DM(156) = x"00003333",        Bus_w = x"FFFFFFFF",    PC=332 x"24"

blez:   blez    $3, bgtz                        # Branch not taken
        addu    $11, $11, $2                    # Reg[11] = x"00004444",        Bus_w = x"00000000",    PC=340 x"00"
        sw      $11, 160($1)                    # DM(160) = x"00004444",        Bus_w = x"FFFFFFFF",    PC=344 x"24"

bgtz:   bgtz    $3, bltz                        # Branch taken
        addu    $11, $11, $2                    # Reg[11] = x"--------",        Bus_w = x"00000000",    PC=352 x"00"
        sw      $11, 164($1)                    # DM(164) = x"--------",        Bus_w = x"FFFFFFFF",    PC=356 x"24"

bltz:   bltz    $3, bgez                        # Branch not taken
        addu    $11, $11, $2                    # Reg[11] = x"00005555",        Bus_w = x"00000000",    PC=364 x"00"
        sw      $11, 168($1)                    # DM(168) = x"00005555",        Bus_w = x"FFFFFFFF",    PC=368 x"24"

bgez:   bgez    $3, jr                          # Branch taken
        addu    $11, $11, $2                    # Reg[11] = x"--------",        Bus_w = x"00000000",    PC=376 x"00"
        sw      $11, 172($1)                    # DM(172) = x"--------",        Bus_w = x"FFFFFFFF",    PC=380 x"24"

jr:     addiu   $12, 0x190                      # Reg[12] = x"00000178",        Bus_w = x"00000000",    PC=384 x"00"
        jr      $12                             # Reg[XX] = x"XXXXXXXX",        Bus_w = x"XXXXXXXX",    PC=388 x"00"
        addu    $11, $11, $2                    # Reg[11] = x"--------",        Bus_w = x"00000000",    PC=392 x"00"
        sw      $11, 176($1)                    # DM(176) = x"--------",        Bus_w = x"FFFFFFFF",    PC=396 x"24"

jalr:   addiu   $12, 0x1A0                      # Reg[12] = x"00000188",        Bus_w = x"00000000",    PC=400 x"00"
        jalr    $12                             # Reg[31] = x"00000180",        Bus_w = x"00000000",    PC=404 x"00"
        addu    $11, $11, $2                    # Reg[11] = x"--------",        Bus_w = x"00000000",    PC=408 x"00"
        sw      $11, 180($1)                    # DM(180) = x"--------",        Bus_w = x"FFFFFFFF",    PC=412 x"24"

j:      j       jal                             # Reg[XX] = x"XXXXXXXX",        Bus_w = x"XXXXXXXX",    PC=416 x"00"
        addu    $11, $11, $2                    # Reg[11] = x"--------",        Bus_w = x"00000000",    PC=420 x"00"
        sw      $11, 184($1)                    # DM(184) = x"--------",        Bus_w = x"FFFFFFFF",    PC=424 x"24"

jal:    jal     test                            # Reg[31] = x"00000198",        Bus_w = x"00000000",    PC=428 x"00"
        addu    $11, $11, $2                    # Reg[11] = x"--------",        Bus_w = x"00000000",    PC=432 x"00"
        sw      $11, 188($1)                    # DM(188) = x"--------",        Bus_w = x"FFFFFFFF",    PC=436 x"24"

test:   add     $0, $0, $0                      # Reg[XX] = x"XXXXXXXX",        Bus_w = x"XXXXXXXX",    PC=440 x"00"

end:    addu   $11, $11, $2                     # Reg[11] = x"00006666",        Bus_w = x"00000000",    PC=444 x"00"
        sw     $11, 192($1)                     # DM(192) = x"00006666",        Bus_w = x"FFFFFFFF",    PC=448 x"24"
