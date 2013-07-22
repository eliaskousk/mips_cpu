library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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

-- AND  $r1, $r2, $r3   Bitwise AND
-- OR   $r1, $r2, $r3   Bitwise OR
-- NOR  $r1, $r2, $r3   Bitwise NOR
-- XOR  $r1, $r2, $r3   Bitwise XOR

-- MULT $r1, $r2        Multiply (signed numbers)

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

entity control_fsm is
    generic(mult_pipe   : boolean := true);
    port(   clk         : in  std_logic;
            rst         : in  std_logic;
            OPCODE      : in  std_logic_vector(5 downto 0);
            FUNCT       : in  std_logic_vector(5 downto 0);
            PC_write    : out std_logic;
            IR_write    : out std_logic;
            MAR_write   : out std_logic;
            DMD_read    : out std_logic;
            DMD_write   : out std_logic;
            RF_write    : out std_logic;
            HILO_write    : out std_logic);
end control_fsm;

architecture Behavioral of control_fsm is

    -- state definition
    type control_states is (S0, S1, S2A, S2B, S2C, S2D, S2E, S2F, S3, S4A, S4B, S4C);
    signal current_state, next_state : control_states;

    -- OPCODE definition as constants
    constant RTYPE  : std_logic_vector(5 downto 0) := "000000"; -- 0x00
    constant BLTZ   : std_logic_vector(5 downto 0) := "000001"; -- 0x01
    --constant BGEZ   : std_logic_vector(5 downto 0) := "000001"; -- 0x01   -- Don't need it because it has the same opcode
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

    signal mult_counter : std_logic_vector(1 downto 0);
    signal mult_cycles  : std_logic_vector(1 downto 0);

begin

    -- Multiplier cycles

    pipelined: if (mult_pipe = true) generate

        -- Pipelined multiplier (4 clock cycles latency)

        mult_cycles <= "11";

    end generate;

    normal: if(mult_pipe = false) generate

         -- Normal Multiplier (1 clock cycle latency)

         mult_cycles <= "00";

    end generate;

    -- common synchronous process for all FSMs
    SYNCHR: process (clk, rst)
    begin

        if(rst = '1') then
            mult_counter    <= (others => '0');
            
            current_state   <= S0; -- initial state
            
        elsif(clk'event and clk = '1') then
        
            case current_state is

                when S0 =>      mult_counter <= (others => '0');    

                when S2D =>     if(mult_counter = mult_cycles) then
                                    mult_counter <= (others => '0');
                                else
                                    mult_counter <= std_logic_vector(unsigned(mult_counter) + 1);
                                end if;

                when others =>  null;

                end case;    
        
            current_state <= next_state;
        end if;

    end process;

    -- asynchronous process to create output logic and next state logic
    ASYNCHR: process (current_state, OPCODE, FUNCT, mult_counter)
    begin

        -- Next state is by default the current_state
        next_state <= current_state;

        case current_state is

            when S0 =>      -- IF
                
                next_state <= S1;

            when S1 =>      -- ID

                case OPCODE is

                    when BLTZ   =>  next_state  <= S2B;
                    -- when BGEZ   =>  next_state  <= S2B;
                    when J      =>  next_state  <= S4C;
                    when JAL    =>  next_state  <= S4A;
                    when BEQ    =>  next_state  <= S2B;
                    when BNE    =>  next_state  <= S2B;
                    when BLEZ   =>  next_state  <= S2B;
                    when BGTZ   =>  next_state  <= S2B;
                    when ADDI   =>  next_state  <= S2B;
                    when ADDIU  =>  next_state  <= S2B;
                    when SLTI   =>  next_state  <= S2B;
                    when SLTIU  =>  next_state  <= S2B;
                    when ANDI   =>  next_state  <= S2B;
                    when ORI    =>  next_state  <= S2B;
                    when XORI   =>  next_state  <= S2B;
                    when LUI    =>  next_state  <= S2B;
                    when LW     =>  next_state  <= S2A;
                    when LH     =>  next_state  <= S2A;
                    when LHU    =>  next_state  <= S2A;
                    when LB     =>  next_state  <= S2A;
                    when LBU    =>  next_state  <= S2A;
                    when SW     =>  next_state  <= S2A;
                    when SH     =>  next_state  <= S2A;
                    when SB     =>  next_state  <= S2A;
                    when TEST   =>  next_state  <= S1;
                    when RTYPE =>

                        case FUNCT is

                            when SLLR   =>  next_state  <= S2B;
                            when SRLR   =>  next_state  <= S2B;
                            when SRAR   =>  next_state  <= S2B;
                            when SLLVR  =>  next_state  <= S2B;
                            when SRLVR  =>  next_state  <= S2B;
                            when SRAVR  =>  next_state  <= S2B;
                            when JR     =>  next_state  <= S4C;
                            when JALR   =>  next_state  <= S4A;
                            when MFHI   =>  next_state  <= S4A;
                            when MFLO   =>  next_state  <= S4A;
                            when MTHI   =>  next_state  <= S2F;
                            when MTLO   =>  next_state  <= S2F;
                            when MULTR  =>  next_state  <= S2C;
                            when ADDR   =>  next_state  <= S2B;
                            when ADDRU  =>  next_state  <= S2B;
                            when SUBR   =>  next_state  <= S2B;
                            when SUBRU  =>  next_state  <= S2B;
                            when ANDR   =>  next_state  <= S2B;
                            when ORR    =>  next_state  <= S2B;
                            when XORR   =>  next_state  <= S2B;
                            when NORR   =>  next_state  <= S2B;
                            when SLTR   =>  next_state  <= S2B;
                            when SLTRU  =>  next_state  <= S2B;
                            when others =>  next_state  <= S0;

                        end case;

                    when others =>  next_state  <= S0;

                end case;

            when S2A =>      -- EX (LW, LH, LHU, LB, LBU & SW, SH, SB)

                case OPCODE is

                    when LW  =>     next_state  <= S3;
                    when LH  =>     next_state  <= S3;
                    when LHU =>     next_state  <= S3;
                    when LB  =>     next_state  <= S3;
                    when LBU =>     next_state  <= S3;
                    when SW  =>     next_state  <= S4B;
                    when SH  =>     next_state  <= S4B;
                    when SB  =>     next_state  <= S4B;
                    when others =>  next_state  <= S0;

                end case;

            when S2B =>      -- EX (Normal)

                case OPCODE is  

                    when BLTZ   =>  next_state  <= S4C;
    --              when BGEZ   =>  next_state  <= S4C;
                    when BEQ    =>  next_state  <= S4C;
                    when BNE    =>  next_state  <= S4C;
                    when BLEZ   =>  next_state  <= S4C;
                    when BGTZ   =>  next_state  <= S4C;
                    when ADDI   =>  next_state  <= S4A;
                    when ADDIU  =>  next_state  <= S4A;
                    when SLTI   =>  next_state  <= S4A;
                    when SLTIU  =>  next_state  <= S4A;
                    when ANDI   =>  next_state  <= S4A;
                    when ORI    =>  next_state  <= S4A;
                    when XORI   =>  next_state  <= S4A;
                    when LUI    =>  next_state  <= S4A;
                    when RTYPE  =>  next_state  <= S4A;
                    when others =>  next_state  <= S0;

                end case;
            
            when S2C =>     next_state <= S2D;

            when S2D =>    if(mult_counter = mult_cycles) then     -- EX (MULT)
                                next_state <= S2E;                 -- 4 cycles here for pipelined multiplier
                            else                                   -- 1 cycle here for normal multiplier
                                next_state  <= S2D;
                            end if;

            when S2E =>     next_state  <= S0;  -- EX & WB (MULT)
            
            when S2F =>     next_state  <= S0;  -- EX & WB (MTHI, MTLO)

            when S3 =>      next_state  <= S4A; -- MEM (LW, LH, LHU, LB, LBU)

            when S4A =>     next_state  <= S0;  -- WB (Normal)
            when S4B =>     next_state  <= S0;  -- WB (SW, SH, SB)
            when S4C =>     next_state  <= S0;  -- WB (Jumps without link and Branches)

            -- Other case not needed because we have a path for all the states
            -- when others =>  next_state    <= S0;

        end case;

    end process;

    -- combinational logic for outputs

    IR_write    <=  '1' when current_state = S0 else
                    '0';

    MAR_write   <=  '1' when current_state = S2A else
                    '0';

    DMD_read    <=  '1' when current_state = S3 else
                    '0';

    DMD_write   <=  '1' when current_state = S4B else
                    '0';

    RF_write    <=  '1' when current_state = S4A else
                    '0';

    PC_write    <=  '1' when current_state = S2E
                            or current_state = S2F
                            or current_state = S4A
                            or current_state = S4B
                            or current_state = S4C else
                    '0';

    HILO_write    <=  '1' when current_state = S2E
                            or current_state = S2F else
                    '0';

end Behavioral;
