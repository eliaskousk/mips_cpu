library ieee;
use ieee.std_logic_1164.all;

-- LW   $s1, 100($s2)   Load word
-- SW   $s1, 100($s2)   Store word

-- LB   $s1, 100($s2)   Load byte (sign extend)
-- LBU  $s1, 100($s2)   Load byte unsigned (zero extend)
-- LH   $s1, 100($s2)   Load halfword (sign extend)
-- LHU  $s1, 100($s2)   Load halfword unsigned (zero extend)
-- SB   $s1, 100($s2)   Load least significant byte (LSB)
-- SH   $s1, 100($s2)   Load least significant halfword (LSH)

-- ADDI $t1, $s1, 3     Addition immediate (sign extend)
-- ADDIU$t1, $s1, 3     Addition immediate (sign extend)
-- ANDI $t1, $s1, 3     AND immediate (zero extend)
-- ORI  $t1, $s1, 3     OR immediate (zero extend)
-- XORI $t1, $s1, 3     XOR immediate (zero extend)

-- ADD  $s1, $s2, $s3   Addition (signed numbers - with overflow)
-- ADDU $s1, $s2, $s3   Addition (unsigned numbers - without overflow)

-- SUB  $s1, $s2, $s3   Subtract (signed numbers - with overflow)
-- SUBU $s1, $s2, $s3   Subtract (unsigned numbers - without overflow)

-- MULT $s1, $s2        Multiply (signed numbers)

-- AND  $r1, $r2, $r3   Bitwise AND
-- OR   $r1, $r2, $r3   Bitwise OR
-- NOR  $r1, $r2, $r3   Bitwise NOR
-- XOR  $r1, $r2, $r3   Bitwise XOR

-- MFHI $t1             Move from Hi
-- MFLO $t1             Move from Lo
-- MTHI $t1             Move to Hi
-- MTLO $t1             Move to Lo

-- SLL  $s1, $s2, 3     Shift left logical (constant shifts)
-- SRL  $s1, $s2, 3     Shift right logical (constant shifts)
-- SRA  $s1, $s2, 3     Shift right arithmetic (constant shifts with sign extension)

-- SLLV $s1, $s2, 3     Shift left logical variable (variable shifts)
-- SRLV $s1, $s2, 3     Shift right logical variable (variable shifts)
-- SRAV $s1, $s2, 3     Shift right arithmetic variable (variable shifts with sign extension)

-- LUI  $t1, 100        Load upper immediate

-- SLTI $t0, $s0, 10    Set less than immediate (signed numbers)
-- SLTIU$t0, $s0, 10    Set less than unsigned immediate (unsigned numbers)

-- SLT  $t0, $s0, $s1   Set less than (signed numbers)
-- SLTU $t0, $s0, $s1   Set less than unsigned (unsigned numbers)

-- BEQ  $s1, $s2, L     Branch on equal
-- BNE  $s1, $s2, L     Branch on not equal

-- BLEZ $s1, L          Branch on <= 0
-- BGTZ $s1, L          Branch on > 0
-- BLTZ $s1, L          Branch on < 0
-- BGEZ $s1, L          Branch on >= 0

-- JR   $t0             Jump register
-- JALR $t0             Jump and link register

-- J    target          Jump
-- JAL  target          Jump and link

-- TEST                 Halt cpu and test multiplier


entity control_comb is
    port(   OPCODE      : in  std_logic_vector(5 downto 0);
            FUNCT       : in  std_logic_vector(5 downto 0);
            SorZ        : out std_logic;
            BorI        : out std_logic;
            ALUop       : out std_logic_vector(3 downto 0);
            sv          : out std_logic;
            MF          : out std_logic;
            MT          : out std_logic;
            HIorLO      : out std_logic;
            DMorALU     : out std_logic;
            DMWT        : out std_logic_vector(2 downto 0);
            Link        : out std_logic;
            RorI        : out std_logic;
            BranchType  : out std_logic_vector(1 downto 0);
            NEorEQ      : out std_logic;
            RTZero      : out std_logic;
            Jump        : out std_logic;
            JumpPSD     : out std_logic;
            TestMult    : out std_logic);
end control_comb;

architecture Behavioral of control_comb is

    -- OPCODE definition as constants
    constant RTYPE  : std_logic_vector(5 downto 0) := "000000"; -- 0x00
    constant BLTZ   : std_logic_vector(5 downto 0) := "000001"; -- 0x01
    --constant BGEZ   : std_logic_vector(5 downto 0) := "000001"; -- 0x01
    constant J      : std_logic_vector(5 downto 0) := "000010"; -- 0x02
    constant JAL    : std_logic_vector(5 downto 0) := "000011"; -- 0x03
    constant BEQ    : std_logic_vector(5 downto 0) := "000100"; -- 0x04
    constant BNE    : std_logic_vector(5 downto 0) := "000101"; -- 0x05
    constant BLEZ   : std_logic_vector(5 downto 0) := "000110"; -- 0x06
    constant BGTZ   : std_logic_vector(5 downto 0) := "000111"; -- 0x07
    constant ADDI   : std_logic_vector(5 downto 0) := "001000"; -- 0x08
    constant ADDIU  : std_logic_vector(5 downto 0) := "001001"; -- 0x09
    constant SLTI   : std_logic_vector(5 downto 0) := "001010"; -- 0x0A
    constant SLTIU  : std_logic_vector(5 downto 0) := "001011"; -- 0x0B
    constant ANDI   : std_logic_vector(5 downto 0) := "001100"; -- 0x0C
    constant ORI    : std_logic_vector(5 downto 0) := "001101"; -- 0x0D
    constant XORI   : std_logic_vector(5 downto 0) := "001110"; -- 0x0E
    constant LUI    : std_logic_vector(5 downto 0) := "001111"; -- 0x0F
    constant LB     : std_logic_vector(5 downto 0) := "100000"; -- 0x20
    constant LH     : std_logic_vector(5 downto 0) := "100001"; -- 0x21
    constant LW     : std_logic_vector(5 downto 0) := "100011"; -- 0x23
    constant LBU    : std_logic_vector(5 downto 0) := "100100"; -- 0x24
    constant LHU    : std_logic_vector(5 downto 0) := "100101"; -- 0x25
    constant SB     : std_logic_vector(5 downto 0) := "101000"; -- 0x28
    constant SH     : std_logic_vector(5 downto 0) := "101001"; -- 0x29
    constant SW     : std_logic_vector(5 downto 0) := "101011"; -- 0x2B
    constant TEST   : std_logic_vector(5 downto 0) := "110000"; -- 0x30

    -- FUNCT definition as constants
    constant SLLR   : std_logic_vector(5 downto 0) := "000000"; -- 0x00
    constant SRLR   : std_logic_vector(5 downto 0) := "000010"; -- 0x02
    constant SRAR   : std_logic_vector(5 downto 0) := "000011"; -- 0x03
    constant SLLVR  : std_logic_vector(5 downto 0) := "000100"; -- 0x04
    constant SRLVR  : std_logic_vector(5 downto 0) := "000110"; -- 0x06
    constant SRAVR  : std_logic_vector(5 downto 0) := "000111"; -- 0x07
    constant JR     : std_logic_vector(5 downto 0) := "001000"; -- 0x08
    constant JALR   : std_logic_vector(5 downto 0) := "001001"; -- 0x09
    constant MFHI   : std_logic_vector(5 downto 0) := "010000"; -- 0x10
    constant MTHI   : std_logic_vector(5 downto 0) := "010001"; -- 0x11
    constant MFLO   : std_logic_vector(5 downto 0) := "010010"; -- 0x12
    constant MTLO   : std_logic_vector(5 downto 0) := "010011"; -- 0x13
    constant MULTR  : std_logic_vector(5 downto 0) := "011000"; -- 0x18
    constant ADDR   : std_logic_vector(5 downto 0) := "100000"; -- 0x20
    constant ADDRU  : std_logic_vector(5 downto 0) := "100001"; -- 0x21
    constant SUBR   : std_logic_vector(5 downto 0) := "100010"; -- 0x22
    constant SUBRU  : std_logic_vector(5 downto 0) := "100011"; -- 0x23
    constant ANDR   : std_logic_vector(5 downto 0) := "100100"; -- 0x24
    constant ORR    : std_logic_vector(5 downto 0) := "100101"; -- 0x25
    constant XORR   : std_logic_vector(5 downto 0) := "100110"; -- 0x26
    constant NORR   : std_logic_vector(5 downto 0) := "100111"; -- 0x27
    constant SLTR   : std_logic_vector(5 downto 0) := "101010"; -- 0x2A
    constant SLTRU  : std_logic_vector(5 downto 0) := "101011"; -- 0x2B

begin

    cntr_comb: process (OPCODE, FUNCT)
    begin

        -- OUTPUT initialization

        SorZ        <= '0';
        BorI        <= '0';
        ALUop       <= "0000";
        sv          <= '0';
        MF          <= '0';
        MT          <= '0';
        HIorLO      <= '0';
        DMorALU     <= '0';
        DMWT        <= "000";
        Link        <= '0';
        RorI        <= '0';
        BranchType  <=  "00";
        NEorEQ      <= '0';
        RTZero      <= '0';
        Jump        <= '0';
        JumpPSD     <= '0';
        TestMult    <= '0';

        case OPCODE is

            when TEST =>
                SorZ        <= '-';
                BorI        <= '-';
                ALUop       <= "-";
                sv          <= '-';
                MF          <= '-';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '-';
                DMWT        <= "---";
                Link        <= '-';
                RorI        <= '-';
                BranchType  <=  "--";
                NEorEQ      <= '-';
                RTZero      <= '-';
                Jump        <= '-';
                JumpPSD     <= '-';
                TestMult    <= '1';

            when LW =>
                SorZ        <= '1';
                BorI        <= '0';
                ALUop       <= "1001";
                sv          <= '-';
                MF          <= '0';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '1';
                DMWT        <= "100";
                Link        <= '0';
                RorI        <= '0';
                BranchType  <= "00";
                NEorEQ      <= '-';
                RTZero      <= '-';
                Jump        <= '0';
                JumpPSD     <= '-';
                TestMult    <= '0';

            when LH =>
                SorZ        <= '1';
                BorI        <= '0';
                ALUop       <= "1001";
                sv          <= '-';
                MF          <= '0';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '1';
                DMWT        <= "011";
                Link        <= '0';
                RorI        <= '0';
                BranchType  <= "00";
                NEorEQ      <= '-';
                RTZero      <= '-';
                Jump        <= '0';
                JumpPSD     <= '-';
                TestMult    <= '0';

            when LHU =>
                SorZ        <= '1';
                BorI        <= '0';
                ALUop       <= "1001";
                sv          <= '-';
                MF          <= '0';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '1';
                DMWT        <= "010";
                Link        <= '0';
                RorI        <= '0';
                BranchType  <= "00";
                NEorEQ      <= '-';
                RTZero      <= '-';
                Jump        <= '0';
                JumpPSD     <= '-';
                TestMult    <= '0';

            when LB =>
                SorZ        <= '1';
                BorI        <= '0';
                ALUop       <= "1001";
                sv          <= '-';
                MF          <= '0';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '1';
                DMWT        <= "001";
                Link        <= '0';
                RorI        <= '0';
                BranchType  <= "00";
                NEorEQ      <= '-';
                RTZero      <= '-';
                Jump        <= '0';
                JumpPSD     <= '-';
                TestMult    <= '0';

            when LBU =>
                SorZ        <= '1';
                BorI        <= '0';
                ALUop       <= "1001";
                sv          <= '-';
                MF          <= '0';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '1';
                DMWT        <= "000";
                Link        <= '0';
                RorI        <= '0';
                BranchType  <= "00";
                NEorEQ      <= '-';
                RTZero      <= '-';
                Jump        <= '0';
                JumpPSD     <= '-';
                TestMult    <= '0';

            when SW =>
                SorZ        <= '1';
                BorI        <= '0';
                ALUop       <= "1001";
                sv          <= '-';
                MF          <= '-';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '-';
                DMWT        <= "100";
                Link        <= '-';
                RorI        <= '-';
                BranchType  <= "00";
                NEorEQ      <= '-';
                RTZero      <= '-';
                Jump        <= '0';
                JumpPSD     <= '-';
                TestMult    <= '0';

            when SH =>
                SorZ        <= '1';
                BorI        <= '0';
                ALUop       <= "1001";
                sv          <= '-';
                MF          <= '-';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '-';
                DMWT        <= "011";
                Link        <= '-';
                RorI        <= '-';
                BranchType  <= "00";
                NEorEQ      <= '-';
                RTZero      <= '-';
                Jump        <= '0';
                JumpPSD     <= '-';
                TestMult    <= '0';

            when SB =>
                SorZ        <= '1';
                BorI        <= '0';
                ALUop       <= "1001";
                sv          <= '-';
                MF          <= '-';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '-';
                DMWT        <= "001";
                Link        <= '-';
                RorI        <= '-';
                BranchType  <= "00";
                NEorEQ      <= '-';
                RTZero      <= '-';
                Jump        <= '0';
                JumpPSD     <= '-';
                TestMult    <= '0';

            when BLTZ =>
    --      when BGEZ =>
                SorZ        <= '1';
                BorI        <= '1';
                ALUop       <= "1010";
                sv          <= '-';
                MF          <= '-';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '-';
                DMWT        <= "---";
                Link        <= '-';
                RorI        <= '-';
                BranchType  <= "11";
                NEorEQ      <= '1';     -- Wrong for BLTZ
                RTZero      <= '1';
                Jump        <= '0';
                JumpPSD     <= '-';
                TestMult    <= '0';

            when BLEZ =>
                SorZ        <= '1';
                BorI        <= '1';
                ALUop       <= "1010";
                sv          <= '-';
                MF          <= '-';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '-';
                DMWT        <= "---";
                Link        <= '-';
                RorI        <= '-';
                BranchType  <= "10";
                NEorEQ      <= '0';
                RTZero      <= '-';
                Jump        <= '0';
                JumpPSD     <= '-';
                TestMult    <= '0';

            when BGTZ =>
                SorZ        <= '1';
                BorI        <= '1';
                ALUop       <= "1010";
                sv          <= '-';
                MF          <= '-';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '-';
                DMWT        <= "---";
                Link        <= '-';
                RorI        <= '-';
                BranchType  <= "10";
                NEorEQ      <= '1';
                RTZero      <= '-';
                Jump        <= '0';
                JumpPSD     <= '-';
                TestMult    <= '0';

            when BEQ =>
                SorZ        <= '1';
                BorI        <= '1';
                ALUop       <= "1010";
                sv          <= '-';
                MF          <= '-';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '-';
                DMWT        <= "---";
                Link        <= '-';
                RorI        <= '-';
                BranchType  <= "01";
                NEorEQ      <= '0';
                RTZero      <= '-';
                Jump        <= '0';
                JumpPSD     <= '-';
                TestMult    <= '0';

            when BNE =>
                SorZ        <= '1';
                BorI        <= '1';
                ALUop       <= "1010";
                sv          <= '-';
                MF          <= '-';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '-';
                DMWT        <= "---";
                Link        <= '-';
                RorI        <= '-';
                BranchType  <= "01";
                NEorEQ      <= '1';
                RTZero      <= '-';
                Jump        <= '0';
                JumpPSD     <= '-';
                TestMult    <= '0';

            when ADDI =>
                SorZ        <= '1';
                BorI        <= '0';
                ALUop       <= "1000";
                sv          <= '-';
                MF          <= '0';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '0';
                DMWT        <= "---";
                Link        <= '0';
                RorI        <= '0';
                BranchType  <= "00";
                NEorEQ      <= '-';
                RTZero      <= '-';
                Jump        <= '0';
                JumpPSD     <= '-';
                TestMult    <= '0';

            when ADDIU =>
                SorZ        <= '1';
                BorI        <= '0';
                ALUop       <= "1001";
                sv          <= '-';
                MF          <= '0';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '0';
                DMWT        <= "---";
                Link        <= '0';
                RorI        <= '0';
                BranchType  <= "00";
                NEorEQ      <= '-';
                RTZero      <= '-';
                Jump        <= '0';
                JumpPSD     <= '-';
                TestMult    <= '0';

            when SLTI =>
                SorZ        <= '1';
                BorI        <= '0';
                ALUop       <= "0110";
                sv          <= '-';
                MF          <= '0';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '0';
                DMWT        <= "---";
                Link        <= '0';
                RorI        <= '0';
                BranchType  <= "00";
                NEorEQ      <= '-';
                RTZero      <= '-';
                Jump        <= '0';
                JumpPSD     <= '-';
                TestMult    <= '0';

            when SLTIU =>
                SorZ        <= '1';
                BorI        <= '0';
                ALUop       <= "0111";
                sv          <= '-';
                MF          <= '0';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '0';
                DMWT        <= "---";
                Link        <= '0';
                RorI        <= '0';
                BranchType  <= "00";
                NEorEQ      <= '-';
                RTZero      <= '-';
                Jump        <= '0';
                JumpPSD     <= '-';
                TestMult    <= '0';

            when ANDI =>
                SorZ        <= '0';
                BorI        <= '0';
                ALUop       <= "1100";
                sv          <= '-';
                MF          <= '0';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '0';
                DMWT        <= "---";
                Link        <= '0';
                RorI        <= '0';
                BranchType  <= "00";
                NEorEQ      <= '-';
                RTZero      <= '-';
                Jump        <= '0';
                JumpPSD     <= '-';
                TestMult    <= '0';

            when ORI =>
                SorZ        <= '0';
                BorI        <= '0';
                ALUop       <= "1101";
                sv          <= '-';
                MF          <= '0';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '0';
                DMWT        <= "---";
                Link        <= '0';
                RorI        <= '0';
                BranchType  <= "00";
                NEorEQ      <= '-';
                RTZero      <= '-';
                Jump        <= '0';
                JumpPSD     <= '-';
                TestMult    <= '0';

            when XORI =>
                SorZ        <= '0';
                BorI        <= '0';
                ALUop       <= "1110";
                sv          <= '-';
                MF          <= '0';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '0';
                DMWT        <= "---";
                Link        <= '0';
                RorI        <= '0';
                BranchType  <= "00";
                NEorEQ      <= '-';
                RTZero      <= '-';
                Jump        <= '0';
                JumpPSD     <= '-';
                TestMult    <= '0';

            when LUI =>
                SorZ        <= '0';
                BorI        <= '0';
                ALUop       <= "0000";
                sv          <= '-';
                MF          <= '0';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '0';
                DMWT        <= "---";
                Link        <= '0';
                RorI        <= '0';
                BranchType  <= "00";
                NEorEQ      <= '-';
                RTZero      <= '-';
                Jump        <= '0';
                JumpPSD     <= '-';
                TestMult    <= '0';

            when J =>
                SorZ        <= '-';
                BorI        <= '-';
                ALUop       <= "----";
                sv          <= '-';
                MF          <= '-';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '-';
                DMWT        <= "---";
                Link        <= '-';
                RorI        <= '-';
                BranchType  <= "--";
                NEorEQ      <= '-';
                RTZero      <= '-';
                Jump        <= '1';
                JumpPSD     <= '1';
                TestMult    <= '0';

            when JAL =>
                SorZ        <= '-';
                BorI        <= '-';
                ALUop       <= "----";
                sv          <= '-';
                MF          <= '-';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '-';
                DMWT        <= "---";
                Link        <= '1';
                RorI        <= '1';
                BranchType  <= "--";
                NEorEQ      <= '-';
                RTZero      <= '-';
                Jump        <= '1';
                JumpPSD     <= '1';
                TestMult    <= '0';

            when RTYPE =>

                case FUNCT is

                    when ADDR =>
                        SorZ        <= '-';
                        BorI        <= '1';
                        ALUop       <= "1000";
                        sv          <= '-';
                        MF          <= '0';
                        MT          <= '-';
                        HIorLO      <= '-';
                        DMorALU     <= '0';
                        DMWT        <= "---";
                        Link        <= '0';
                        RorI        <= '1';
                        BranchType  <= "00";
                        NEorEQ      <= '-';
                        RTZero      <= '-';
                        Jump        <= '0';
                        JumpPSD     <= '-';
                        TestMult    <= '0';

                    when ADDRU =>
                        SorZ        <= '-';
                        BorI        <= '1';
                        ALUop       <= "1001";
                        sv          <= '-';
                        MF          <= '0';
                        MT          <= '-';
                        HIorLO      <= '-';
                        DMorALU     <= '0';
                        DMWT        <= "---";
                        Link        <= '0';
                        RorI        <= '1';
                        BranchType  <= "00";
                        NEorEQ      <= '-';
                        RTZero      <= '-';
                        Jump        <= '0';
                        JumpPSD     <= '-';
                        TestMult    <= '0';

                    when SUBR =>
                        SorZ        <= '-';
                        BorI        <= '1';
                        ALUop       <= "1010";
                        sv          <= '-';
                        MF          <= '0';
                        MT          <= '-';
                        HIorLO      <= '-';
                        DMorALU     <= '0';
                        DMWT        <= "---";
                        Link        <= '0';
                        RorI        <= '1';
                        BranchType  <= "00";
                        NEorEQ      <= '-';
                        RTZero      <= '-';
                        Jump        <= '0';
                        JumpPSD     <= '-';
                        TestMult    <= '0';

                    when SUBRU =>
                        SorZ        <= '-';
                        BorI        <= '1';
                        ALUop       <= "1011";
                        sv          <= '-';
                        MF          <= '0';
                        MT          <= '-';
                        HIorLO      <= '-';
                        DMorALU     <= '0';
                        DMWT        <= "---";
                        Link        <= '0';
                        RorI        <= '1';
                        BranchType  <= "00";
                        NEorEQ      <= '-';
                        RTZero      <= '-';
                        Jump        <= '0';
                        JumpPSD     <= '-';
                        TestMult    <= '0';

                    when MULTR =>
                        SorZ        <= '-';
                        BorI        <= '1';
                        ALUop       <= "----";
                        sv          <= '-';
                        MF          <= '-';
                        MT          <= '-';
                        HIorLO      <= '-';
                        DMorALU     <= '0';
                        DMWT        <= "---";
                        Link        <= '-';
                        RorI        <= '-';
                        BranchType  <= "00";
                        NEorEQ      <= '-';
                        RTZero      <= '-';
                        Jump        <= '0';
                        JumpPSD     <= '-';
                        TestMult    <= '0';

                    when MFHI =>
                        SorZ        <= '-';
                        BorI        <= '-';
                        ALUop       <= "----";
                        sv          <= '-';
                        MF          <= '1';
                        MT          <= '-';
                        HIorLO      <= '1';
                        DMorALU     <= '-';
                        DMWT        <= "---";
                        Link        <= '0';
                        RorI        <= '1';
                        BranchType  <= "00";
                        NEorEQ      <= '-';
                        RTZero      <= '-';
                        Jump        <= '0';
                        JumpPSD     <= '-';
                        TestMult    <= '0';

                    when MTHI =>
                        SorZ        <= '-';
                        BorI        <= '-';
                        ALUop       <= "----";
                        sv          <= '-';
                        MF          <= '-';
                        MT          <= '1';
                        HIorLO      <= '1';
                        DMorALU     <= '-';
                        DMWT        <= "---";
                        Link        <= '-';
                        RorI        <= '-';
                        BranchType  <= "00";
                        NEorEQ      <= '-';
                        RTZero      <= '-';
                        Jump        <= '0';
                        JumpPSD     <= '-';
                        TestMult    <= '0';

                    when MFLO =>
                        SorZ        <= '-';
                        BorI        <= '-';
                        ALUop       <= "----";
                        sv          <= '-';
                        MF          <= '1';
                        MT          <= '-';
                        HIorLO      <= '0';
                        DMorALU     <= '-';
                        DMWT        <= "---";
                        Link        <= '0';
                        RorI        <= '1';
                        BranchType  <= "00";
                        NEorEQ      <= '-';
                        RTZero      <= '-';
                        Jump        <= '0';
                        JumpPSD     <= '-';
                        TestMult    <= '0';

                    when MTLO =>
                        SorZ        <= '-';
                        BorI        <= '-';
                        ALUop       <= "----";
                        sv          <= '-';
                        MF          <= '-';
                        MT          <= '1';
                        HIorLO      <= '0';
                        DMorALU     <= '-';
                        DMWT        <= "---";
                        Link        <= '-';
                        RorI        <= '-';
                        BranchType  <= "00";
                        NEorEQ      <= '-';
                        RTZero      <= '-';
                        Jump        <= '0';
                        JumpPSD     <= '-';
                        TestMult    <= '0';

                    when ANDR =>
                        SorZ        <= '-';
                        BorI        <= '1';
                        ALUop       <= "1100";
                        sv          <= '-';
                        MF          <= '0';
                        MT          <= '-';
                        HIorLO      <= '-';
                        DMorALU     <= '0';
                        DMWT        <= "---";
                        Link        <= '0';
                        RorI        <= '1';
                        BranchType  <= "00";
                        NEorEQ      <= '-';
                        RTZero      <= '-';
                        Jump        <= '0';
                        JumpPSD     <= '-';
                        TestMult    <= '0';

                    when ORR =>
                        SorZ        <= '-';
                        BorI        <= '1';
                        ALUop       <= "1101";
                        sv          <= '-';
                        MF          <= '0';
                        MT          <= '-';
                        HIorLO      <= '-';
                        DMorALU     <= '0';
                        DMWT        <= "---";
                        Link        <= '0';
                        RorI        <= '1';
                        BranchType  <= "00";
                        NEorEQ      <= '-';
                        RTZero      <= '-';
                        Jump        <= '0';
                        JumpPSD     <= '-';
                        TestMult    <= '0';

                    when XORR =>
                        SorZ        <= '-';
                        BorI        <= '1';
                        ALUop       <= "1110";
                        sv          <= '-';
                        MF          <= '0';
                        MT          <= '-';
                        HIorLO      <= '-';
                        DMorALU     <= '0';
                        DMWT        <= "---";
                        Link        <= '0';
                        RorI        <= '1';
                        BranchType  <= "00";
                        NEorEQ      <= '-';
                        RTZero      <= '-';
                        Jump        <= '0';
                        JumpPSD     <= '-';
                        TestMult    <= '0';

                    when NORR =>
                        SorZ        <= '-';
                        BorI        <= '1';
                        ALUop       <= "1111";
                        sv          <= '-';
                        MF          <= '0';
                        MT          <= '-';
                        HIorLO      <= '-';
                        DMorALU     <= '0';
                        DMWT        <= "---";
                        Link        <= '0';
                        RorI        <= '1';
                        BranchType  <= "00";
                        NEorEQ      <= '-';
                        RTZero      <= '-';
                        Jump        <= '0';
                        JumpPSD     <= '-';
                        TestMult    <= '0';

                    when SLTR =>
                        SorZ        <= '-';
                        BorI        <= '1';
                        ALUop       <= "0110";
                        sv          <= '-';
                        MF          <= '0';
                        MT          <= '-';
                        HIorLO      <= '-';
                        DMorALU     <= '0';
                        DMWT        <= "---";
                        Link        <= '0';
                        RorI        <= '1';
                        BranchType  <= "00";
                        NEorEQ      <= '-';
                        RTZero      <= '-';
                        Jump        <= '0';
                        JumpPSD     <= '-';
                        TestMult    <= '0';

                    when SLTRU =>
                        SorZ        <= '-';
                        BorI        <= '1';
                        ALUop       <= "0111";
                        sv          <= '-';
                        MF          <= '0';
                        MT          <= '-';
                        HIorLO      <= '-';
                        DMorALU     <= '0';
                        DMWT        <= "---";
                        Link        <= '0';
                        RorI        <= '1';
                        BranchType  <= "00";
                        NEorEQ      <= '-';
                        RTZero      <= '-';
                        Jump        <= '0';
                        JumpPSD     <= '-';
                        TestMult    <= '0';

                    when SLLR =>
                        SorZ        <= '-';
                        BorI        <= '1';
                        ALUop       <= "0000";
                        sv          <= '0';
                        MF          <= '0';
                        MT          <= '-';
                        HIorLO      <= '-';
                        DMorALU     <= '0';
                        DMWT        <= "---";
                        Link        <= '0';
                        RorI        <= '1';
                        BranchType  <= "00";
                        NEorEQ      <= '-';
                        RTZero      <= '-';
                        Jump        <= '0';
                        JumpPSD     <= '-';
                        TestMult    <= '0';

                    when SRLR =>
                        SorZ        <= '-';
                        BorI        <= '1';
                        ALUop       <= "0010";
                        sv          <= '0';
                        MF          <= '0';
                        MT          <= '-';
                        HIorLO      <= '-';
                        DMorALU     <= '0';
                        DMWT        <= "---";
                        Link        <= '0';
                        RorI        <= '1';
                        BranchType  <= "00";
                        NEorEQ      <= '-';
                        RTZero      <= '-';
                        Jump        <= '0';
                        JumpPSD     <= '-';
                        TestMult    <= '0';

                    when SRAR =>
                        SorZ        <= '-';
                        BorI        <= '1';
                        ALUop       <= "0011";
                        sv          <= '0';
                        MF          <= '0';
                        MT          <= '-';
                        HIorLO      <= '-';
                        DMorALU     <= '0';
                        DMWT        <= "---";
                        Link        <= '0';
                        RorI        <= '1';
                        BranchType  <= "00";
                        NEorEQ      <= '-';
                        RTZero      <= '-';
                        Jump        <= '0';
                        JumpPSD     <= '-';
                        TestMult    <= '0';

                    when SLLVR =>
                        SorZ        <= '-';
                        BorI        <= '1';
                        ALUop       <= "0000";
                        sv          <= '1';
                        MF          <= '0';
                        MT          <= '-';
                        HIorLO      <= '-';
                        DMorALU     <= '0';
                        DMWT        <= "---";
                        Link        <= '0';
                        RorI        <= '1';
                        BranchType  <= "00";
                        NEorEQ      <= '-';
                        RTZero      <= '-';
                        Jump        <= '0';
                        JumpPSD     <= '-';
                        TestMult    <= '0';

                    when SRLVR =>
                        SorZ        <= '-';
                        BorI        <= '1';
                        ALUop       <= "0010";
                        sv          <= '1';
                        MF          <= '0';
                        MT          <= '-';
                        HIorLO      <= '-';
                        DMorALU     <= '0';
                        DMWT        <= "---";
                        Link        <= '0';
                        RorI        <= '1';
                        BranchType  <= "00";
                        NEorEQ      <= '-';
                        RTZero      <= '-';
                        Jump        <= '0';
                        JumpPSD     <= '-';
                        TestMult    <= '0';

                    when SRAVR =>
                        SorZ        <= '-';
                        BorI        <= '1';
                        ALUop       <= "0011";
                        sv          <= '1';
                        MF          <= '0';
                        MT          <= '-';
                        HIorLO      <= '-';
                        DMorALU     <= '0';
                        DMWT        <= "---";
                        Link        <= '0';
                        RorI        <= '1';
                        BranchType  <= "00";
                        NEorEQ      <= '-';
                        RTZero      <= '-';
                        Jump        <= '0';
                        JumpPSD     <= '-';
                        TestMult    <= '0';

                    when JR =>
                        SorZ        <= '-';
                        BorI        <= '-';
                        ALUop       <= "----";
                        sv          <= '-';
                        MF          <= '-';
                        MT          <= '-';
                        HIorLO      <= '-';
                        DMorALU     <= '-';
                        DMWT        <= "---";
                        Link        <= '-';
                        RorI        <= '-';
                        BranchType  <= "--";
                        NEorEQ      <= '-';
                        RTZero      <= '-';
                        Jump        <= '1';
                        JumpPSD     <= '0';
                        TestMult    <= '0';

                    when JALR =>
                        SorZ        <= '-';
                        BorI        <= '-';
                        ALUop       <= "----";
                        sv          <= '-';
                        MF          <= '-';
                        MT          <= '-';
                        HIorLO      <= '-';
                        DMorALU     <= '-';
                        DMWT        <= "---";
                        Link        <= '1';
                        RorI        <= '1';
                        BranchType  <= "--";
                        NEorEQ      <= '-';
                        RTZero      <= '-';
                        Jump        <= '1';
                        JumpPSD     <= '0';
                        TestMult    <= '0';

                    when others =>
                        SorZ        <= '-';
                        BorI        <= '-';
                        ALUop       <= "----";
                        sv          <= '-';
                        MF          <= '-';
                        MT          <= '-';
                        HIorLO      <= '-';
                        DMorALU     <= '-';
                        DMWT        <= "---";
                        Link        <= '-';
                        RorI        <= '-';
                        BranchType  <= "--";
                        NEorEQ      <= '-';
                        RTZero      <= '-';
                        Jump        <= '-';
                        JumpPSD     <= '-';
                        TestMult    <= '-';

                end case;

            when others =>
                SorZ        <= '-';
                BorI        <= '-';
                ALUop       <= "----";
                sv          <= '-';
                MF          <= '-';
                MT          <= '-';
                HIorLO      <= '-';
                DMorALU     <= '-';
                DMWT        <= "---";
                Link        <= '-';
                RorI        <= '-';
                BranchType  <= "--";
                NEorEQ      <= '-';
                RTZero      <= '-';
                Jump        <= '-';
                JumpPSD     <= '-';
                TestMult    <= '-';

        end case;

    end process;

end Behavioral;
