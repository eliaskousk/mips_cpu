library ieee;
use ieee.std_logic_1164.all;

entity alu_top_tb is
end alu_top_tb;

architecture Behavioral of alu_top_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component alu_top
        generic(mult_pipe : boolean := true);
        port(clk          : in  std_logic;
             rst          : in  std_logic;
             sv           : in  std_logic;
             TestMult     : in  std_logic;
             MT           : in  std_logic;
             HIorLO       : in  std_logic;
             ALUop        : in  std_logic_vector(3 downto 0);
             shamt        : in  std_logic_vector(4 downto 0);
             Bus_A        : in  std_logic_vector(31 downto 0);
             Bus_B        : in  std_logic_vector(31 downto 0);
             Zero         : out std_logic;
             ov           : out std_logic;
             bist_done    : out std_logic;
             bist_fail    : out std_logic;
             Bus_S        : out std_logic_vector(31 downto 0);
             Bus_mult_HI  : out std_logic_vector(31 downto 0);
             Bus_mult_LO  : out std_logic_vector(31 downto 0));
    end component alu_top;

    --Inputs
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    signal sv           : std_logic := '0';
    signal TestMult     : std_logic := '0';
    signal MT           : std_logic := '0';
    signal HIorLO       : std_logic := '0';
    signal ALUop        : std_logic_vector(3 downto 0) := (others => '0');
    signal shamt        : std_logic_vector(4 downto 0) := (others => '0');
    signal Bus_A        : std_logic_vector(31 downto 0) := (others => '0');
    signal Bus_B        : std_logic_vector(31 downto 0) := (others => '0');

    --Outputs
    signal Zero         : std_logic;
    signal ov           : std_logic;
    signal bist_done    : std_logic;
    signal bist_fail    : std_logic;
    signal Bus_S        : std_logic_vector(31 downto 0);
    signal Bus_mult_HI  : std_logic_vector(31 downto 0);
    signal Bus_mult_LO  : std_logic_vector(31 downto 0);

    -- Clock period definitions
    constant clk_period : time := 20 ns;
    constant mult_pipe  : boolean := true;

    constant ADDOP      : std_logic_vector(3 downto 0) := "1000";
    constant ADDUOP     : std_logic_vector(3 downto 0) := "1001";
    constant SUBOP      : std_logic_vector(3 downto 0) := "1010";
    constant SUBUOP     : std_logic_vector(3 downto 0) := "1011";
    constant ANDOP      : std_logic_vector(3 downto 0) := "1100";
    constant OROP       : std_logic_vector(3 downto 0) := "1101";
    constant XOROP      : std_logic_vector(3 downto 0) := "1110";
    constant NOROP      : std_logic_vector(3 downto 0) := "1111";
    constant SLTOP      : std_logic_vector(3 downto 0) := "0110";
    constant SLTUOP     : std_logic_vector(3 downto 0) := "0111";
    constant SLLVOP     : std_logic_vector(3 downto 0) := "0000";
    constant SRLVOP     : std_logic_vector(3 downto 0) := "0010";
    constant SRAVOP     : std_logic_vector(3 downto 0) := "0011";

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: alu_top
        generic map(mult_pipe => mult_pipe)
        port map(clk          => clk,
                 rst          => rst,
                 sv           => sv,
                 TestMult     => TestMult,
                 MT           => MT,
                 HIorLO       => HIorLO,
                 ALUop        => ALUop,
                 shamt        => shamt,
                 Bus_A        => Bus_A,
                 Bus_B        => Bus_B,
                 Zero         => Zero,
                 ov           => ov,
                 bist_done    => bist_done,
                 bist_fail    => bist_fail,
                 Bus_S        => Bus_S,
                 Bus_mult_HI  => Bus_mult_HI,
                 Bus_mult_LO  => Bus_mult_LO);

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '1';
        wait for clk_period/2;
        clk <= '0';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 20 ns.
        wait for 20 ns;

        rst <= '1';
        wait for clk_period * 3;
        rst <= '0';

        shamt       <= (others => '0');
        sv          <= '0';
        TestMult    <= '0';
        MT          <= '0';
        HIorLO      <= '0';

        -- =========
        -- ADD, ADDI
        -- =========

        ALUop <= ADDOP;

        -- should get zero result
        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"00000000";   -- zero
        wait for 20 ns;

        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"0000FFFF";   -- positive number
        wait for 20 ns;

        -- should get negative result
        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"8000FFFF";   -- negative number
        wait for 20 ns;

        -- should get negative result
        Bus_A <= X"0000FFFF";   -- positive number
        Bus_B <= X"8000FFFF";   -- negative number
        wait for 20 ns;

        Bus_A <= X"8000FFFF";   -- negative number
        Bus_B <= X"F000FFFF";   -- positive number
        wait for 20 ns;

        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"7FFFFFFF";   -- max positive number
        wait for 20 ns;

        -- should get negative result
        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"80000000";   -- max negative number
        wait for 20 ns;

        -- should get overflow and negative result
        Bus_A <= X"7FFFFFFF";   -- max positive number
        Bus_B <= X"7FFFFFFF";   -- max positive number
        wait for 20 ns;

        -- should get overflow and zero result
        Bus_A <= X"80000000";   -- max negative number
        Bus_B <= X"80000000";   -- max negative number
        wait for 20 ns;

        -- should get overflow and negative result
        Bus_A <= X"7FFFFFFF";   -- max positive number
        Bus_B <= X"80000000";   -- max negative number
        wait for 20 ns;

        -- should get zero result
        Bus_A <= X"7FFFFFFF";   -- max positive number
        Bus_B <= X"80000001";   -- max negative number minus 1
        wait for 20 ns;

        --------------------------------------------------------

        -- ===========
        -- ADDU, ADDIU
        -- ===========

        ALUop <= ADDUOP;

        -- should get zero result
        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"00000000";   -- zero
        wait for 20 ns;

        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"0000FFFF";   -- number
        wait for 20 ns;

        -- should get positive result
        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"8000FFFF";   -- number
        wait for 20 ns;

        -- should get positive result
        Bus_A <= X"0000FFFF";   -- number
        Bus_B <= X"8000FFFF";   -- number
        wait for 20 ns;

        Bus_A <= X"8000FFFF";   -- number
        Bus_B <= X"F000FFFF";   -- number
        wait for 20 ns;

        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"FFFFFFFF";   -- max number
        wait for 20 ns;

        -- should get positive result
        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"80000000";   -- middle number
        wait for 20 ns;

        -- should get overflow and positive result
        Bus_A <= X"FFFFFFFF";   -- max number
        Bus_B <= X"FFFFFFFF";   -- max number
        wait for 20 ns;

        -- should get overflow and zero result
        Bus_A <= X"80000000";   -- middle number
        Bus_B <= X"80000000";   -- middle number
        wait for 20 ns;

        -- should get overflow and positive result
        Bus_A <= X"FFFFFFFF";   -- max number
        Bus_B <= X"80000000";   -- middle number
        wait for 20 ns;

        -- should get zero result
        Bus_A <= X"FFFFFFFF";   -- max number
        Bus_B <= X"00000001";   -- 1
        wait for 20 ns;

        --------------------------------------------------------

        -- ===
        -- SUB
        -- ===

        ALUop <= SUBOP;

        -- should get zero result
        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"00000000";   -- zero
        wait for 20 ns;

        -- should get negative result
        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"0000FFFF";   -- positive number
        wait for 20 ns;

        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"8000FFFF";   -- negative number
        wait for 20 ns;

        -- should get overflow and negative result
        Bus_A <= X"0000FFFF";   -- positive number
        Bus_B <= X"8000FFFF";   -- negative number
        wait for 20 ns;

        -- should get negative result
        Bus_A <= X"8000FFFF";   -- negative number
        Bus_B <= X"0000FFFF";   -- positive number
        wait for 20 ns;

        -- should get negative result
        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"7FFFFFFF";   -- max positive number
        wait for 20 ns;

        -- should get overflow and negative result
        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"80000000";   -- max negative number
        wait for 20 ns;

        -- should get zero result
        Bus_A <= X"7FFFFFFF";   -- max positive number
        Bus_B <= X"7FFFFFFF";   -- max positive number
        wait for 20 ns;

        -- should get zero result
        Bus_A <= X"80000000";   -- max negative number
        Bus_B <= X"80000000";   -- max negative number
        wait for 20 ns;

        -- should get overflow and negative result
        Bus_A <= X"7FFFFFFF";   -- max positive number
        Bus_B <= X"80000000";   -- max negative number
        wait for 20 ns;

        -- should get overflow and negative result
        Bus_A <= X"7FFFFFFF";   -- max positive number
        Bus_B <= X"80000001";   -- max negative number minus 1
        wait for 20 ns;

        --------------------------------------------------------

        -- ====
        -- SUBU
        -- ====

        ALUop <= SUBUOP;

        -- should get zero result
        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"00000000";   -- zero
        wait for 20 ns;

        -- should get negative result
        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"0000FFFF";   -- number
        wait for 20 ns;

        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"8000FFFF";   -- number
        wait for 20 ns;

        -- should get overflow and negative result
        Bus_A <= X"0000FFFF";   -- number
        Bus_B <= X"8000FFFF";   -- number
        wait for 20 ns;

        -- should get negative result
        Bus_A <= X"8000FFFF";   -- number
        Bus_B <= X"0000FFFF";   -- number
        wait for 20 ns;

        -- should get negative result
        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"FFFFFFFF";   -- max number
        wait for 20 ns;

        -- should get overflow and negative result
        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"80000000";   -- middle number
        wait for 20 ns;

        -- should get zero result
        Bus_A <= X"FFFFFFFF";   -- max number
        Bus_B <= X"FFFFFFFF";   -- max number
        wait for 20 ns;

        -- should get zero result
        Bus_A <= X"80000000";   -- middle number
        Bus_B <= X"80000000";   -- middle number
        wait for 20 ns;

        -- should get overflow and positive result
        Bus_A <= X"FFFFFFFF";   -- max number
        Bus_B <= X"80000000";   -- middle number
        wait for 20 ns;

        -- should get positive result
        Bus_A <= X"FFFFFFFF";   -- max number
        Bus_B <= X"00000001";   -- max number minus 1
        wait for 20 ns;

        --------------------------------------------------------

        -- =========
        -- AND, ANDI
        -- =========

        ALUop <= ANDOP;

        -- should get all 0
        Bus_A <= X"00000000";   -- all 0
        Bus_B <= X"00000000";   -- all 0
        wait for 20 ns;

        -- should get all 0
        Bus_A <= X"00000000";   -- all 0
        Bus_B <= X"FFFFFFFF";   -- all 1
        wait for 20 ns;

        -- should get all 0
        Bus_A <= X"FFFFFFFF";   -- all 1
        Bus_B <= X"00000000";   -- all 0
        wait for 20 ns;

        -- should get all 1
        Bus_A <= X"FFFFFFFF";   -- all 1
        Bus_B <= X"FFFFFFFF";   -- all 1
        wait for 20 ns;

        --------------------------------------------------------

        -- =======
        -- OR, ORI
        -- =======

        ALUop <= OROP;

        -- should get all 0
        Bus_A <= X"00000000";   -- all 0
        Bus_B <= X"00000000";   -- all 0
        wait for 20 ns;

        -- should get all 1
        Bus_A <= X"00000000";   -- all 0
        Bus_B <= X"FFFFFFFF";   -- all 1
        wait for 20 ns;

        -- should get all 1
        Bus_A <= X"FFFFFFFF";   -- all 1
        Bus_B <= X"00000000";   -- all 0
        wait for 20 ns;

        -- should get all 1
        Bus_A <= X"FFFFFFFF";   -- all 1
        Bus_B <= X"FFFFFFFF";   -- all 1
        wait for 20 ns;

        --------------------------------------------------------

        -- =========
        -- XOR, XORI
        -- =========

        ALUop <= XOROP;

        -- should get all 0
        Bus_A <= X"00000000";   -- all 0
        Bus_B <= X"00000000";   -- all 0
        wait for 20 ns;

        -- should get all 1
        Bus_A <= X"00000000";   -- all 0
        Bus_B <= X"FFFFFFFF";   -- all 1
        wait for 20 ns;

        -- should get all 1
        Bus_A <= X"FFFFFFFF";   -- all 1
        Bus_B <= X"00000000";   -- all 0
        wait for 20 ns;

        -- should get all 0
        Bus_A <= X"FFFFFFFF";   -- all 1
        Bus_B <= X"FFFFFFFF";   -- all 1
        wait for 20 ns;

        --------------------------------------------------------

        -- ===
        -- NOR
        -- ===

        ALUop <= NOROP;

        -- should get all 1
        Bus_A <= X"00000000";   -- all 0
        Bus_B <= X"00000000";   -- all 0
        wait for 20 ns;

        -- should get all 0
        Bus_A <= X"00000000";   -- all 0
        Bus_B <= X"FFFFFFFF";   -- all 1
        wait for 20 ns;

        -- should get all 0
        Bus_A <= X"FFFFFFFF";   -- all 1
        Bus_B <= X"00000000";   -- all 0
        wait for 20 ns;

        -- should get all 0
        Bus_A <= X"FFFFFFFF";   -- all 1
        Bus_B <= X"FFFFFFFF";   -- all 1
        wait for 20 ns;

        --------------------------------------------------------

        -- =========
        -- SLT, SLTI
        -- =========

        ALUop <= SLTOP;

        -- should get 0
        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"00000000";   -- zero
        wait for 20 ns;

        -- should get 1
        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"0000FFFF";   -- positive number
        wait for 20 ns;

        -- should get 0
        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"8000FFFF";   -- negative number
        wait for 20 ns;

        -- should get 1
        Bus_A <= X"0000FFFF";   -- positive number
        Bus_B <= X"8000FFFF";   -- negative number
        wait for 20 ns;

        -- should get 1
        Bus_A <= X"8000FFFF";   -- negative number
        Bus_B <= X"0000FFFF";   -- positive number
        wait for 20 ns;

        -- should get 1
        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"7FFFFFFF";   -- max positive number
        wait for 20 ns;

        -- should get 1
        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"80000000";   -- max negative number
        wait for 20 ns;

        -- should get 0
        Bus_A <= X"7FFFFFFF";   -- max positive number
        Bus_B <= X"7FFFFFFF";   -- max positive number
        wait for 20 ns;

        -- should get 0
        Bus_A <= X"80000000";   -- max negative number
        Bus_B <= X"80000000";   -- max negative number
        wait for 20 ns;

        -- should get 1
        Bus_A <= X"7FFFFFFF";   -- max positive number
        Bus_B <= X"80000000";   -- max negative number
        wait for 20 ns;

        -- should get 1
        Bus_A <= X"7FFFFFFF";   -- max positive number
        Bus_B <= X"80000001";   -- max negative number minus 1
        wait for 20 ns;

        --------------------------------------------------------

        -- ===========
        -- SLTU, SLTUI
        -- ===========

        ALUop <= SLTUOP;

        -- should get 0
        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"00000000";   -- zero
        wait for 20 ns;

        -- should get 1
        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"0000FFFF";   -- number
        wait for 20 ns;

        -- should get 1
        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"8000FFFF";   -- number
        wait for 20 ns;

        -- should get 1
        Bus_A <= X"0000FFFF";   -- number
        Bus_B <= X"8000FFFF";   -- number
        wait for 20 ns;

        -- should get 0
        Bus_A <= X"8000FFFF";   -- number
        Bus_B <= X"0000FFFF";   -- number
        wait for 20 ns;

        -- should get 1
        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"FFFFFFFF";   -- max number
        wait for 20 ns;

        -- should get 1
        Bus_A <= X"00000000";   -- zero
        Bus_B <= X"80000000";   -- middle number
        wait for 20 ns;

        -- should get 0
        Bus_A <= X"FFFFFFFF";   -- max number
        Bus_B <= X"FFFFFFFF";   -- max number
        wait for 20 ns;

        -- should get 0
        Bus_A <= X"80000000";   -- middle number
        Bus_B <= X"80000000";   -- middle number
        wait for 20 ns;

        -- should get 0
        Bus_A <= X"FFFFFFFF";   -- max number
        Bus_B <= X"80000000";   -- middle number
        wait for 20 ns;

        -- should get 1
        Bus_A <= X"FFFFFFFE";   -- max number minus 1
        Bus_B <= X"FFFFFFFF";   -- max number
        wait for 20 ns;

        --------------------------------------------------------

        -- ==========================
        -- SLLV (also applies to SLL)
        -- ==========================

        ALUop   <= SLLVOP;
        sv      <= '1';

        -- should get 000000000
        Bus_A <= X"00000000";   -- shift left 0
        Bus_B <= X"00000000";   -- msb, lsb 0
        wait for 20 ns;

        -- should get 000000000
        Bus_A <= X"0000000F";   -- shift left 15
        Bus_B <= X"00000000";   -- msb, lsb 0
        wait for 20 ns;

        ------------------------------------------

        -- should get 00000000
        Bus_A <= X"00000000";   -- shift left 0
        Bus_B <= X"00000001";   -- lsb 1
        wait for 20 ns;

        -- should get 00000002
        Bus_A <= X"00000001";   -- shift left 1
        Bus_B <= X"00000001";   -- lsb 1
        wait for 20 ns;

        -- should get 00000004
        Bus_A <= X"00000002";   -- shift left 2
        Bus_B <= X"00000001";   -- lsb 1
        wait for 20 ns;

        -- should get 00000008
        Bus_A <= X"00000003";   -- shift left 3
        Bus_B <= X"00000001";   -- lsb 1
        wait for 20 ns;

        -- should get 00000010
        Bus_A <= X"00000004";   -- shift left 4
        Bus_B <= X"00000001";   -- lsb 1
        wait for 20 ns;

        -- should get 40000000
        Bus_A <= X"0000001E";   -- shift left 30
        Bus_B <= X"00000001";   -- lsb 1
        wait for 20 ns;

        -- should get 80000000
        Bus_A <= X"0000001F";   -- shift left 31
        Bus_B <= X"00000001";   -- lsb 1
        wait for 20 ns;

        ------------------------------------------

        -- should get 00000002
        Bus_A <= X"00000000";   -- shift left 0
        Bus_B <= X"00000002";   -- next of lsb 1
        wait for 20 ns;

        -- should get 00000004
        Bus_A <= X"00000001";   -- shift left 1
        Bus_B <= X"00000002";   -- next of lsb 1
        wait for 20 ns;

        -- should get 00000008
        Bus_A <= X"00000002";   -- shift left 2
        Bus_B <= X"00000002";   -- next of lsb 1
        wait for 20 ns;

        -- should get 00000010
        Bus_A <= X"00000003";   -- shift left 3
        Bus_B <= X"00000002";   -- next of lsb 1
        wait for 20 ns;

        -- should get 00000020
        Bus_A <= X"00000004";   -- shift right 4
        Bus_B <= X"00000002";   -- next of lsb 1
        wait for 20 ns;

        -- should get 80000000
        Bus_A <= X"0000001E";   -- shift left 30
        Bus_B <= X"00000002";   -- next of lsb 1
        wait for 20 ns;

        -- should get 00000000
        Bus_A <= X"0000001F";   -- shift left 31
        Bus_B <= X"00000002";   -- next of lsb 1
        wait for 20 ns;

        ------------------------------------------

        -- should get 00000001
        Bus_A <= X"00000000";   -- shift left 0
        Bus_B <= X"00000001";   -- lsb 1
        wait for 20 ns;

        -- should get 00000002
        Bus_A <= X"00000001";   -- shift left 1
        Bus_B <= X"00000001";   -- lsb 1
        wait for 20 ns;

        -- should get 00010000
        Bus_A <= X"0000000F";   -- shift left 15
        Bus_B <= X"00000001";   -- lsb 1
        wait for 20 ns;

        -- should get 40000000
        Bus_A <= X"0000001E";   -- shift left 30
        Bus_B <= X"00000001";   -- lsb 1
        wait for 20 ns;

        -- should get 80000000
        Bus_A <= X"0000001F";   -- shift left 31
        Bus_B <= X"00000001";   -- lsb 1
        wait for 20 ns;

        ------------------------------------------

        -- ==========================
        -- SRLV (also applies to SRL)
        -- ==========================

        ALUop   <= SRLVOP;
        sv      <= '1';

        -- should get 000000000
        Bus_A <= X"00000000";   -- shift right 0
        Bus_B <= X"00000000";   -- msb, lsb 0
        wait for 20 ns;

        -- should get 000000000
        Bus_A <= X"0000000F";   -- shift right 15
        Bus_B <= X"00000000";   -- msb, lsb 0
        wait for 20 ns;

        ------------------------------------------

        -- should get 00000000
        Bus_A <= X"00000000";   -- shift right 0
        Bus_B <= X"80000000";   -- msb 1
        wait for 20 ns;

        -- should get 40000000
        Bus_A <= X"00000001";   -- shift right 1
        Bus_B <= X"80000000";   -- msb 1
        wait for 20 ns;

        -- should get 20000000
        Bus_A <= X"00000002";   -- shift right 2
        Bus_B <= X"80000000";   -- msb 1
        wait for 20 ns;

        -- should get 10000000
        Bus_A <= X"00000003";   -- shift right 3
        Bus_B <= X"80000000";   -- msb 1
        wait for 20 ns;

        -- should get 08000000
        Bus_A <= X"00000004";   -- shift right 4
        Bus_B <= X"80000000";   -- msb 1
        wait for 20 ns;

        -- should get 00000010
        Bus_A <= X"0000001E";   -- shift right 30
        Bus_B <= X"80000000";   -- msb 1
        wait for 20 ns;

        -- should get 00000001
        Bus_A <= X"0000001F";   -- shift right 31
        Bus_B <= X"80000000";   -- msb 1
        wait for 20 ns;

        ------------------------------------------

        -- should get 40000000
        Bus_A <= X"00000000";   -- shift right 0
        Bus_B <= X"40000000";   -- next of msb 1
        wait for 20 ns;

        -- should get 20000000
        Bus_A <= X"00000001";   -- shift right 1
        Bus_B <= X"40000000";   -- next of msb 1
        wait for 20 ns;

        -- should get 10000000
        Bus_A <= X"00000002";   -- shift right 2
        Bus_B <= X"40000000";   -- next of msb 1
        wait for 20 ns;

        -- should get 08000000
        Bus_A <= X"00000003";   -- shift right 3
        Bus_B <= X"40000000";   -- next of msb 1
        wait for 20 ns;

        -- should get 04000000
        Bus_A <= X"00000004";   -- shift right 4
        Bus_B <= X"40000000";   -- next of msb 1
        wait for 20 ns;

        -- should get 00000001
        Bus_A <= X"0000001E";   -- shift right 30
        Bus_B <= X"40000000";   -- next of msb 1
        wait for 20 ns;

        -- should get 00000000
        Bus_A <= X"0000001F";   -- shift right 31
        Bus_B <= X"40000000";   -- next of msb 1
        wait for 20 ns;

        ------------------------------------------

        -- should get 00000001
        Bus_A <= X"00000000";   -- shift right 0
        Bus_B <= X"00000001";   -- lsb 1
        wait for 20 ns;

        -- should get 00000000
        Bus_A <= X"00000001";   -- shift right 1
        Bus_B <= X"00000001";   -- lsb 1
        wait for 20 ns;

        -- should get 00000000
        Bus_A <= X"0000000F";   -- shift right 15
        Bus_B <= X"00000001";   -- lsb 1
        wait for 20 ns;

        -- should get 00000000
        Bus_A <= X"0000001E";   -- shift right 30
        Bus_B <= X"00000001";   -- lsb 1
        wait for 20 ns;

        -- should get 00000000
        Bus_A <= X"0000001F";   -- shift right 31
        Bus_B <= X"00000001";   -- lsb 1
        wait for 20 ns;

        ------------------------------------------

        -- ==========================
        -- SRAV (also applies to SRA)
        -- ==========================

        ALUop   <= SRAVOP;
        sv      <= '1';

        -- should get 000000000
        Bus_A <= X"00000000";   -- shift right 0
        Bus_B <= X"00000000";   -- msb, lsb 0
        wait for 20 ns;

        -- should get 000000000
        Bus_A <= X"0000000F";   -- shift right 15
        Bus_B <= X"00000000";   -- msb, lsb 0
        wait for 20 ns;

        ------------------------------------------

        -- should get 80000000
        Bus_A <= X"00000000";   -- shift right 0
        Bus_B <= X"80000000";   -- msb 1
        wait for 20 ns;

        -- should get C0000000
        Bus_A <= X"00000001";   -- shift right 1
        Bus_B <= X"80000000";   -- msb 1
        wait for 20 ns;

        -- should get E0000000
        Bus_A <= X"00000002";   -- shift right 2
        Bus_B <= X"80000000";   -- msb 1
        wait for 20 ns;

        -- should get F0000000
        Bus_A <= X"00000003";   -- shift right 3
        Bus_B <= X"80000000";   -- msb 1
        wait for 20 ns;

        -- should get F8000000
        Bus_A <= X"00000004";   -- shift right 4
        Bus_B <= X"80000000";   -- msb 1
        wait for 20 ns;

        -- should get FFFFFFFE
        Bus_A <= X"0000001E";   -- shift right 30
        Bus_B <= X"80000000";   -- msb 1
        wait for 20 ns;

        -- should get FFFFFFFF
        Bus_A <= X"0000001F";   -- shift right 31
        Bus_B <= X"80000000";   -- msb 1
        wait for 20 ns;

        ------------------------------------------

        -- should get 40000000
        Bus_A <= X"00000000";   -- shift right 0
        Bus_B <= X"40000000";   -- next of msb 1
        wait for 20 ns;

        -- should get 20000000
        Bus_A <= X"00000001";   -- shift right 1
        Bus_B <= X"40000000";   -- next of msb 1
        wait for 20 ns;

        -- should get 10000000
        Bus_A <= X"00000002";   -- shift right 2
        Bus_B <= X"40000000";   -- next of msb 1
        wait for 20 ns;

        -- should get 08000000
        Bus_A <= X"00000003";   -- shift right 3
        Bus_B <= X"40000000";   -- next of msb 1
        wait for 20 ns;

        -- should get 04000000
        Bus_A <= X"00000004";   -- shift right 4
        Bus_B <= X"40000000";   -- next of msb 1
        wait for 20 ns;

        -- should get 00000001
        Bus_A <= X"0000001E";   -- shift right 30
        Bus_B <= X"40000000";   -- next of msb 1
        wait for 20 ns;

        -- should get 00000000
        Bus_A <= X"0000001F";   -- shift right 31
        Bus_B <= X"40000000";   -- next of msb 1
        wait for 20 ns;

        ------------------------------------------

        -- should get 00000001
        Bus_A <= X"00000000";   -- shift right 0
        Bus_B <= X"00000001";   -- lsb 1
        wait for 20 ns;

        -- should get 00000000
        Bus_A <= X"00000001";   -- shift right 1
        Bus_B <= X"00000001";   -- lsb 1
        wait for 20 ns;

        -- should get 00000000
        Bus_A <= X"0000000F";   -- shift right 15
        Bus_B <= X"00000001";   -- lsb 1
        wait for 20 ns;

        -- should get 00000000
        Bus_A <= X"0000001E";   -- shift right 30
        Bus_B <= X"00000001";   -- lsb 1
        wait for 20 ns;

        -- should get 00000000
        Bus_A <= X"0000001F";   -- shift right 31
        Bus_B <= X"00000001";   -- lsb 1
        wait for 20 ns;

        ------------------------------------------

        wait;
    end process;

end Behavioral;
