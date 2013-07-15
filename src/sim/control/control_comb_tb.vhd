library ieee;
use ieee.std_logic_1164.all;

entity control_comb_tb is
end control_comb_tb;

architecture Behavioral of control_comb_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component control_comb
        port(OPCODE     : in  std_logic_vector(5 downto 0);
             FUNCT      : in  std_logic_vector(5 downto 0);
             SorZ       : out std_logic;
             BorI       : out std_logic;
             ALUop      : out std_logic_vector(3 downto 0);
             sv         : out std_logic;
             MF         : out std_logic;
             MT         : out std_logic;
             HIorLO     : out std_logic;
             DMorALU    : out std_logic;
             Link       : out std_logic;
             RorI       : out std_logic;
             BranchType : out std_logic_vector(1 downto 0);
             NEorEQ     : out std_logic;
             Jump       : out std_logic;
             JumpPSD    : out std_logic;
             TestMult   : out std_logic);
    end component control_comb;

    --Inputs
    signal OPCODE       : std_logic_vector(5 downto 0) := (others => '0');
    signal FUNCT        : std_logic_vector(5 downto 0) := (others => '0');

    --Outputs
    signal SorZ         : std_logic;
    signal BorI         : std_logic;
    signal ALUop        : std_logic_vector(3 downto 0);
    signal sv           : std_logic;
    signal MF           : std_logic;
    signal MT           : std_logic;
    signal HIorLO       : std_logic;
    signal DMorALU      : std_logic;
    signal Link         : std_logic;
    signal RorI         : std_logic;
    signal BranchType   : std_logic_vector(1 downto 0);
    signal NEorEQ       : std_logic;
    signal Jump         : std_logic;
    signal JumpPSD      : std_logic;
    signal TestMult     : std_logic;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: control_comb
        port map(OPCODE     => OPCODE,
                 FUNCT      => FUNCT,
                 SorZ       => SorZ,
                 BorI       => BorI,
                 ALUop      => ALUop,
                 sv         => sv,
                 MF         => MF,
                 MT         => MT,
                 HIorLO     => HIorLO,
                 DMorALU    => DMorALU,
                 Link       => Link,
                 RorI       => RorI,
                 BranchType => BranchType,
                 NEorEQ     => NEorEQ,
                 Jump       => Jump,
                 JumpPSD    => JumpPSD,
                 TestMult   => TestMult);

    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 20 ns.
        wait for 20 ns;

        -- BLTZ  (4 clock cycles)
        OPCODE  <= "000001";
        FUNCT   <= "000000";
        wait for 20 ns * 4;

        -- J     (3 clock cycles)
        OPCODE  <= "000010";
        FUNCT   <= "000000";
        wait for 20 ns * 3;

        -- JAL   (3 clock cycles)
        OPCODE  <= "000011";
        FUNCT   <= "000000";
        wait for 20 ns * 3;

        -- BEQ   (4 clock cycles)
        OPCODE  <= "000100";
        FUNCT   <= "000000";
        wait for 20 ns * 4;

        -- BNE   (4 clock cycles)
        OPCODE  <= "000101";
        FUNCT   <= "000000";
        wait for 20 ns * 4;

        -- BLEZ  (4 clock cycles)
        OPCODE  <= "000110";
        FUNCT   <= "000000";
        wait for 20 ns * 4;

        -- BLEZ  (4 clock cycles)
        OPCODE  <= "000111";
        FUNCT   <= "000000";
        wait for 20 ns * 4;

        -- ADDI  (4 clock cycles)
        OPCODE  <= "001000";
        FUNCT   <= "000000";
        wait for 20 ns * 4;

        -- ADDIU (4 clock cycles)
        OPCODE  <= "001001";
        FUNCT   <= "000000";
        wait for 20 ns * 4;

        -- SLTI  (4 clock cycles)
        OPCODE  <= "001010";
        FUNCT   <= "000000";
        wait for 20 ns * 4;

        -- SLTIU (4 clock cycles)
        OPCODE  <= "001011";
        FUNCT   <= "000000";
        wait for 20 ns * 4;

        -- ANDI  (4 clock cycles)
        OPCODE  <= "001100";
        FUNCT   <= "000000";
        wait for 20 ns * 4;

        -- ORI   (4 clock cycles)
        OPCODE  <= "001101";
        FUNCT   <= "000000";
        wait for 20 ns * 4;

        -- XORI  (4 clock cycles)
        OPCODE  <= "001110";
        FUNCT   <= "000000";
        wait for 20 ns * 4;

        -- LUI   (4 clock cycles)
        OPCODE  <= "001111";
        FUNCT   <= "000000";
        wait for 20 ns * 4;

        -- LB    (5 clock cycles)
        OPCODE  <= "100000";
        FUNCT   <= "000000";
        wait for 20 ns * 5;

        -- LH    (5 clock cycles)
        OPCODE  <= "100001";
        FUNCT   <= "000000";
        wait for 20 ns * 5;

        -- LW    (5 clock cycles)
        OPCODE  <= "100011";
        FUNCT   <= "000000";
        wait for 20 ns * 5;

        -- LBU   (5 clock cycles)
        OPCODE  <= "100100";
        FUNCT   <= "000000";
        wait for 20 ns * 5;

        -- LHU   (5 clock cycles)
        OPCODE  <= "100101";
        FUNCT   <= "000000";
        wait for 20 ns * 5;

        -- SB    (4 clock cycles)
        OPCODE  <= "101000";
        FUNCT   <= "000000";
        wait for 20 ns * 4;

        -- SH    (4 clock cycles)
        OPCODE  <= "101001";
        FUNCT   <= "000000";
        wait for 20 ns * 4;

        -- SW    (4 clock cycles)
        OPCODE  <= "101011";
        FUNCT   <= "000000";
        wait for 20 ns * 4;

        -- TEST  (4 clock cycles)
        OPCODE  <= "110000";
        FUNCT   <= "000000";
        wait for 20 ns * 4;

        -- SLL (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "000000";
        wait for 20 ns * 4;

        -- SRL (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "000010";
        wait for 20 ns * 4;

        -- SRA (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "000011";
        wait for 20 ns * 4;

        -- SLLV (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "000100";
        wait for 20 ns * 4;

        -- SRLV (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "000110";
        wait for 20 ns * 4;

        -- SRAV (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "000111";
        wait for 20 ns * 4;

        -- JR   (3 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "001000";
        wait for 20 ns * 3;

        -- JALR (3 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "001001";
        wait for 20 ns * 3;

        -- MFHI (2 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "010000";
        wait for 20 ns * 2;

        -- MTHI (3 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "010001";
        wait for 20 ns * 3;

        -- MFLO (2 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "010010";
        wait for 20 ns * 2;

        -- MTLO (3 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "010011";
        wait for 20 ns * 3;

        -- MULT (3 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "011000";
        wait for 20 ns * 3;

        -- ADD  (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "100000";
        wait for 20 ns * 4;

        -- ADDU (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "100001";
        wait for 20 ns * 4; 

        -- SUB  (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "100010";
        wait for 20 ns * 4;

        -- SUBU (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "100011";
        wait for 20 ns * 4;

        -- AND  (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "100100";
        wait for 20 ns * 4;

        -- OR   (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "100101";
        wait for 20 ns * 4;

        -- XOR  (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "100110";
        wait for 20 ns * 4;

        -- NOR  (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "100111"; 
        wait for 20 ns * 4;

        -- SLT  (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "101010";
        wait for 20 ns * 4;

        -- SLTU (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "101011";
        wait for 20 ns * 4;

        wait;
    end process;

end Behavioral;
