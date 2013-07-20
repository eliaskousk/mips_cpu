# ==============================
# Simple assembly program
# ==============================
# A simple program illustrating
# some of the MIPS instructions
# without any particular purpose
# ==============================

        .text                           # Text section

        .globl main                     # Call main by SPIM

main:   addiu   $2, $0, 0x2222          # Reg[02] = x"00002222",                Bus_w = x"00002222"     PC=00 x"00" 
        addiu   $3, $0, 0x5555          # Reg[03] = x"00005555",                Bus_w = x"00005555"     PC=04 x"04"
        subu    $4, $3, $2              # Reg[04] = x"00003333",                Bus_w = x"00003333"     PC=08 x"08"

        addiu   $5, $0, 0x1000          # Reg[05] = x"00001000",                Bus_w = x"00001000"     PC=12 x"0C"

        sw      $0, 0($5)               # DM(1024) = x"00000000",               Bus_w = x"XXXXXXXX"     PC=16 x"10"
        lw      $17, 0($5)              # Reg[17] = x"00000000",                Bus_w = x"00000000"     PC=20 x"14"

        nor     $4, $0, $0              # Reg[04] = x"FFFFFFFF",                Bus_w = x"FFFFFFFF"     PC=24 x"18"
        sw      $4, 4($5)               # DM(1025) = x"FFFFFFFF",               Bus_w = x"XXXXXXXX"     PC=28 x"1C"
        lw      $18, 4($5)              # Reg[18] = x"FFFFFFFF",                Bus_w = x"FFFFFFFF"     PC=32 x"20"

        addiu   $8, $0, 256             # Reg[08] = x"00000100",                Bus_w = x"00000100"     PC=36 x"24"
        addiu   $7, $0, 8               # Reg[07] = x"00000008",                Bus_w = x"00000008"     PC=40 x"28"
        srav    $10, $8, $7             # Reg[10] = x"00000001",                Bus_w = x"00000001"     PC=44 x"2C"

        addiu   $8, $0, 100             # Reg[08] = x"00000064",                Bus_w = x"00000064"     PC=48 x"30"
        jalr    $8                      # Reg[31] = x"00000038", PC = "100"     Bus_w = x"00000038"     PC=52 x"34"
        lw      $9, 8($5)               # Reg[09] = x"0000000A",                Bus_w = x"0000000A"     PC=56 x"38"

        bne     $4, $18, label1         # the condition is not satisfied;       Bus_w = x"XXXXXXXX"     PC=60 x"3C"
        slti    $16, $2, 0x3333         # Reg[16] = x"00000001",                Bus_w = x"00000001"     PC=64 x"40"
        bne     $0, $16, label1         # the condition is satisfied;           Bus_w = x"XXXXXXXX"     PC=68 x"44"
        nor     $4, $0, $0              # Reg[04] = x"FFFFFFFF",                Bus_w = x"FFFFFFFF"     PC=72 x"48"

label1: addiu   $19, $0, 96             # Reg[19] = x"00000060",                Bus_w = x"00000060"     PC=76 x"4C"
        jalr    $19                     # Reg[31] = x"00000054", PC = "96"      Bus_w = x"00000054"     PC=80 x"50"
        addiu   $13, $13, 16            # Reg[13] = x"00000020", inc by 10      Bus_w = x"00000020"     PC=84 x"54"
        slti    $20, $13, 0x00A0        # Reg[20] = x"0000000 1 or 0",          Bus_w = x"00000001"     PC=88 x"58"
        bne     $10, $20, end           # the condition is satisfied;           Bus_w = x"XXXXXXXX"     PC=92 x"5C"
        jr      $31                     # PC = "54", loop until $13 < 160       Bus_w = x"XXXXXXXX"     PC=96 x"60"

func1:  addiu   $6, 2                   # Reg[06] = x"00000001", inc by 2       Bus_w = x"00000002"     PC=100 x"64"
        slti    $20, $6, 0x000A         # Reg[20] = x"0000000 1 or 0",          Bus_w = x"00000001"     PC=104 x"68"
        bne     $0, $20, func1          # check loop condition;                 Bus_w = x"XXXXXXXX"     PC=108 x"6C"
        sw      $6, 8($5)               # DM(1026) = x"0000000A",               Bus_w = x"XXXXXXXX"     PC=112 x"70"
        jr      $31                     # return from func1, PC = "56"          Bus_w = x"XXXXXXXX"     PC=116 x"74"

end:    sw      $13, 12($5)             # DM(1027) = x"000000A0",               Bus_w = x"XXXXXXXX"     PC=120 x"78"
