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
        sw      $2, 0($1)                       # DM(0)   = x"00001111",        Bus_w = x"XXXXXXXX",    PC=08 x"08"

        addiu   $3, $0, 0x0001                  # Reg[03] = x"00000001",        Bus_w = x"00000001",    PC=12 x"0C"
        sw      $3, 4($1)                       # DM(4)   = x"00000001",        Bus_w = x"XXXXXXXX",    PC=16 x"10"

        addiu   $4, $0, 0x8000                  # Reg[04] = x"FFFF8000",        Bus_w = x"FFFF8000",    PC=20 x"14"
        sw      $4, 8($1)                       # DM(8)   = x"FFFF8000",        Bus_w = x"XXXXXXXX",    PC=24 x"18"

        addiu   $5, $0, 0xFFFF                  # Reg[05] = x"FFFFFFFF",        Bus_w = x"FFFFFFFF",    PC=28 x"1C"
        lui     $5, 0xFFFF                      # Reg[05] = x"FFFF0000",        Bus_w = x"FFFF0000",    PC=32 x"20"
        sw      $5, 12($1)                      # DM(12)  = x"FFFF0000",        Bus_w = x"XXXXXXXX",    PC=36 x"24"

load:   lw      $6, 12($1)                      # Reg[06] = x"FFFF0000",        Bus_w = x"FFFF0000",    PC=40 x"28"
        sw      $6, 16($1)                      # DM(16)  = x"FFFF0000",        Bus_w = x"XXXXXXXX",    PC=44 x"2C"

        lh      $7, 14($1)                      # Reg[07] = x"0000FFFF",        Bus_w = x"0000FFFF",    PC=48 x"30"
        sw      $7, 20($1)                      # DM(20)  = x"0000FFFF",        Bus_w = x"XXXXXXXX",    PC=52 x"34"

        lhu     $8, 14($1)                      # Reg[08] = x"0000FFFF",        Bus_w = x"0000FFFF",    PC=56 x"38"
        sw      $8, 24($1)                      # DM(24)  = x"0000FFFF",        Bus_w = x"XXXXXXXX",    PC=60 x"3C"

        lb      $9, 15($1)                      # Reg[09] = x"000000FF",        Bus_w = x"000000FF",    PC=64 x"40"
        sw      $9, 28($1)                      # DM(28)  = x"000000FF",        Bus_w = x"XXXXXXXX",    PC=68 x"44"

        lbu     $10, 15($1)                     # Reg[10] = x"000000FF",        Bus_w = x"000000FF",    PC=72 x"48"
        sw      $10, 32($1)                     # DM(32)  = x"000000FF",        Bus_w = x"XXXXXXXX",    PC=76 x"4C"

store:  sw      $6, 36($1)                      # DM(36)  = x"FFFF0000",        Bus_w = x"XXXXXXXX",    PC=80 x"50"
        sh      $6, 40($1)                      # DM(40)  = x"00000000",        Bus_w = x"XXXXXXXX",    PC=84 x"54"
        sb      $6, 44($1)                      # DM(44)  = x"00000000",        Bus_w = x"XXXXXXXX",    PC=88 x"58"

alu:    addi    $11, $2, 0x1111                 # Reg[11] = x"00002222",        Bus_w = x"00002222",    PC=92 x"5C"
        sw      $11, 48($1)                     # DM(48)  = x"00002222",        Bus_w = x"XXXXXXXX",    PC=96 x"60"

        addiu   $12, $2, 0x2222                 # Reg[12] = x"00003333",        Bus_w = x"00003333",    PC=100 x"64"
        sw      $12, 52($1)                     # DM(52)  = x"00003333",        Bus_w = x"XXXXXXXX",    PC=104 x"68"

        andi    $13, $2, 0x3333                 # Reg[13] = x"00001111",        Bus_w = x"00001111",    PC=108 x"6C"
        sw      $13, 56($1)                     # DM(56)  = x"00001111",        Bus_w = x"XXXXXXXX",    PC=112 x"70"

        ori     $14, $2, 0x4444                 # Reg[14] = x"00005555",        Bus_w = x"00005555",    PC=116 x"74"
        sw      $14, 60($1)                     # DM(60)  = x"00005555",        Bus_w = x"XXXXXXXX",    PC=120 x"78"

        xori    $15, $2, 0x5555                 # Reg[15] = x"00004444",        Bus_w = x"00004444",    PC=124 x"7C"
        sw      $15, 64($1)                     # DM(64)  = x"00004444",        Bus_w = x"XXXXXXXX",    PC=128 x"80"


        add     $16, $11, $12                   # Reg[16] = x"00005555",        Bus_w = x"00005555",    PC=132 x"84"
        sw      $16, 68($1)                     # DM(68)  = x"00005555",        Bus_w = x"XXXXXXXX",    PC=136 x"88"

        addu    $17, $11, $12                   # Reg[17] = x"00005555",        Bus_w = x"00005555",    PC=140 x"8C"
        sw      $17, 72($1)                     # DM(72)  = x"00005555",        Bus_w = x"XXXXXXXX",    PC=144 x"90"

        sub     $18, $16, $12                   # Reg[18] = x"00002222",        Bus_w = x"00002222",    PC=148 x"94"
        sw      $18, 76($1)                     # DM(76)  = x"00002222",        Bus_w = x"XXXXXXXX",    PC=152 x"98"

        subu    $19, $16, $11                   # Reg[19] = x"00003333",        Bus_w = x"00003333",    PC=156 x"9C"
        sw      $19, 80($1)                     # DM(80)  = x"00003333,         Bus_w = x"XXXXXXXX",    PC=160 x"A0"

        and     $20, $5, $16                    # Reg[20] = x"00000000",        Bus_w = x"00000000",    PC=164 x"A4"
        sw      $20, 84($1)                     # DM(84)  = x"00000000",        Bus_w = x"XXXXXXXX",    PC=168 x"A8"

        or      $21, $4, $17                    # Reg[21] = x"FFFFD555",        Bus_w = x"FFFFD555",    PC=172 x"AC"
        sw      $21, 88($1)                     # DM(88)  = x"FFFD5555",        Bus_w = x"XXXXXXXX",    PC=176 x"B0"

        nor     $22, $5, $13                    # Reg[22] = x"0000EEEE",        Bus_w = x"0000EEEE",    PC=180 x"B4"
        sw      $22, 92($1)                     # DM(92)  = x"0000EEEE",        Bus_w = x"XXXXXXXX",    PC=184 x"B8"

        xor     $23, $2, $5                     # Reg[23] = x"FFFF1111",        Bus_w = x"FFFF1111",    PC=188 x"BC"
        sw      $23, 96($1)                     # DM(96)  = x"FFFF1111",        Bus_w = x"XXXXXXXX",    PC=192 x"C0"

        mult    $5, $11                         # Reg[XX] = x"XXXXXXXX",        Bus_w = x"XXXXXXXX",    PC=196 x"C4"

        mfhi    $24                             # Reg[24] = x"FFFFFFFF",        Bus_w = x"FFFFFFFF",    PC=200 x"C8"
        sw      $24, 100($1)                    # DM(100) = x"FFFFFFFF",        Bus_w = x"XXXXXXXX",    PC=204 x"CC"

        mflo    $25                             # Reg[25] = x"DDDE0000",        Bus_w = x"DDDE0000",    PC=208 x"D0"
        sw      $25, 104($1)                    # DM(104) = x"DDDE0000",        Bus_w = x"XXXXXXXX",    PC=212 x"D4"

        mthi    $11                             # Reg[HI] = x"00002222",        Bus_w = x"XXXX2222",    PC=216 x"D8"
        mtlo    $12                             # Reg[LO] = x"00003333",        Bus_w = x"XXXXXXXX",    PC=220 x"DC"

shift:  sll     $26, $3, 3                      # Reg[26] = x"00000008",        Bus_w = x"00000008",    PC=224 x"E0"
        sw      $26, 108($1)                    # DM(108) = x"00000008",        Bus_w = x"XXXXXXXX",    PC=228 x"E4"

        srl     $27, $4, 3                      # Reg[27] = x"1FFFF000",        Bus_w = x"1FFFF000",    PC=232 x"E8"
        sw      $27, 112($1)                    # DM(112) = x"1FFFF000",        Bus_w = x"XXXXXXXX",    PC=236 x"EC"

        sra     $28, $4, 3                      # Reg[28] = x"FFFFF000",        Bus_w = x"FFFFF000",    PC=240 x"F0"
        sw      $28, 116($1)                    # DM(116) = x"FFFFF000",        Bus_w = x"XXXXXXXX",    PC=244 x"F4"

        sllv    $29, $3, $26                    # Reg[29] = x"00000100",        Bus_w = x"00000100",    PC=248 x"F8"
        sw      $29, 120($1)                    # DM(120) = x"00000100",        Bus_w = x"XXXXXXXX",    PC=252 x"FC"

        srlv    $30, $4, $26                    # Reg[30] = x"00FFFF80",        Bus_w = x"00FFFF80",    PC=256 x"100"
        sw      $30, 124($1)                    # DM(124) = x"00FFFF80",        Bus_w = x"XXXXXXXX",    PC=260 x"104"

        srav    $31, $4, $26                    # Reg[31] = x"FFFFFF80",        Bus_w = x"FFFFFF80",    PC=264 x"108"
        sw      $31, 128($1)                    # DM(128) = x"FFFFFF80",        Bus_w = x"XXXXXXXX",    PC=268 x"10C"


lui:    lui     $6, 0xAAAA                      # Reg[06] = x"AAAA0000",        Bus_w = x"AAAA0000",    PC=272 x"110"
        sw      $6, 132($1)                     # DM(132) = x"AAAA0000",        Bus_w = x"XXXXXXXX",    PC=276 x"114"

slt:    slti    $7, $6, 0xBBBB                  # Reg[07] = x"00000001",        Bus_w = x"00000001",    PC=280 x"118"
        sw      $7, 136($1)                     # DM(136) = x"00000001",        Bus_w = x"XXXXXXXX",    PC=284 x"11C"

        sltiu   $8, $5, 0xBBBB                  # Reg[08] = x"00000001",        Bus_w = x"00000001",    PC=288 x"120"
        sw      $8, 140($1)                     # DM(140) = x"00000001",        Bus_w = x"XXXXXXXX",    PC=292 x"124"

        slt     $9, $6, $5                      # Reg[09] = x"00000001",        Bus_w = x"00000001",    PC=296 x"128"
        sw      $9, 144($1)                     # DM(144) = x"00000001",        Bus_w = x"XXXXXXXX",    PC=300 x"12C"

        sltu    $10, $5, $6                     # Reg[10] = x"00000000",        Bus_w = x"00000000",    PC=304 x"130"
        sw      $10, 148($1)                    # DM(148) = x"00000000",        Bus_w = x"XXXXXXXX",    PC=308 x"134"

beq:    beq     $3, $7, 0x150                   # Branch taken                  Bus_w = x"XXXXXXXX",    PC=312 x"138"
        addu    $11, $11, $2                    # Reg[11] = x"00002222",        Bus_w = x"XXXXXXXX",    PC=316 x"13C"
        sw      $11, 152($1)                    # DM(152) = x"00000000",        Bus_w = x"XXXXXXXX",    PC=320 x"140"

bne:    bne     $3, $7, 0x160                   # Branch not taken              Bus_w = x"XXXXXXXX",    PC=324 x"144"
        addu    $11, $11, $2                    # Reg[11] = x"00003333",        Bus_w = x"00003333",    PC=328 x"148"
        sw      $11, 156($1)                    # DM(156) = x"00003333",        Bus_w = x"XXXXXXXX",    PC=332 x"14C"

blez:   blez    $3, 0x170                       # Branch not taken              Bus_w = x"XXXXXXXX",    PC=336 x"150"
        addu    $11, $11, $2                    # Reg[11] = x"00004444",        Bus_w = x"00004444",    PC=340 x"154"
        sw      $11, 160($1)                    # DM(160) = x"00004444",        Bus_w = x"XXXXXXXX",    PC=344 x"158"

bgtz:   bgtz    $3, 0x180                       # Branch taken                  Bus_w = x"XXXXXXXX",    PC=348 x"15C"
        addu    $11, $11, $2                    # Reg[11] = x"00004444",        Bus_w = x"XXXXXXXX",    PC=352 x"160"
        sw      $11, 164($1)                    # DM(164) = x"00000000",        Bus_w = x"XXXXXXXX",    PC=356 x"164"

bltz:   bltz    $3, 0x190                       # Branch not taken              Bus_w = x"XXXXXXXX",    PC=360 x"168"
        addu    $11, $11, $2                    # Reg[11] = x"00005555",        Bus_w = x"00005555",    PC=364 x"16C"
        sw      $11, 168($1)                    # DM(168) = x"00005555",        Bus_w = x"XXXXXXXX",    PC=368 x"170"

bgez:   bgez    $3, 0x1A0                       # Branch taken                  Bus_w = x"XXXXXXXX",    PC=372 x"174"
        addu    $11, $11, $2                    # Reg[11] = x"00005555",        Bus_w = x"XXXXXXXX",    PC=376 x"178"
        sw      $11, 172($1)                    # DM(172) = x"00000000",        Bus_w = x"XXXXXXXX",    PC=380 x"17C"

jr:     addiu   $12, $0, 0x190                  # Reg[12] = x"00000190",        Bus_w = x"00000190",    PC=384 x"180"
        jr      $12                             # Reg[XX] = x"XXXXXXXX",        Bus_w = x"XXXXXXXX",    PC=388 x"184"
        addu    $11, $11, $2                    # Reg[11] = x"00005555",        Bus_w = x"XXXXXXXX",    PC=392 x"188"
        sw      $11, 176($1)                    # DM(176) = x"00000000",        Bus_w = x"XXXXXXXX",    PC=396 x"18C"

jalr:   addiu   $12, $0, 0x1A0                  # Reg[12] = x"000001A0",        Bus_w = x"000001A0",    PC=400 x"190"
        jalr    $12                             # Reg[31] = x"00000198",        Bus_w = x"00000198",    PC=404 x"194"
        addu    $11, $11, $2                    # Reg[11] = x"00005555",        Bus_w = x"XXXXXXXX",    PC=408 x"198"
        sw      $11, 180($1)                    # DM(180) = x"00000000",        Bus_w = x"XXXXXXXX",    PC=412 x"19C"

j:      j       0x1AC                           # Reg[XX] = x"XXXXXXXX",        Bus_w = x"XXXXXXXX",    PC=416 x"1A0"
        addu    $11, $11, $2                    # Reg[11] = x"00005555",        Bus_w = x"XXXXXXXX",    PC=420 x"1A4"
        sw      $11, 184($1)                    # DM(184) = x"00000000",        Bus_w = x"XXXXXXXX",    PC=424 x"1A8"

jal:    jal     0x1B8                           # Reg[31] = x"000001B0",        Bus_w = x"000001B0",    PC=428 x"1AC"
        addu    $11, $11, $2                    # Reg[11] = x"00005555",        Bus_w = x"XXXXXXXX",    PC=432 x"1B0"
        sw      $11, 188($1)                    # DM(188) = x"00000000",        Bus_w = x"XXXXXXXX",    PC=436 x"1B4"

test:   add     $0, $0, $0                      # Reg[XX] = x"XXXXXXXX",        Bus_w = x"XXXXXXXX",    PC=440 x"1B8"

end:    addu    $11, $11, $2                    # Reg[11] = x"00006666",        Bus_w = x"00006666",    PC=444 x"1BC"
        sw      $11, 192($1)                    # DM(192) = x"00006666",        Bus_w = x"XXXXXXXX",    PC=448 x"1C0"
