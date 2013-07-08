library ieee;
use ieee.std_logic_1164.all;

entity alu_top_tb is
end alu_top_tb;

architecture Behavioral of alu_top_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component alu_top
        port(clk         : in  std_logic;
             rst         : in  std_logic;
             sv          : in  std_logic;
             TestMult    : in  std_logic;
             mult_mode   : in  std_logic;
             ALUop       : in  std_logic_vector(3 downto 0);
             shamt       : in  std_logic_vector(4 downto 0);
             Bus_A       : in  std_logic_vector(31 downto 0);
             Bus_B       : in  std_logic_vector(31 downto 0);
             Zero        : out std_logic;
             ov          : out std_logic;
             Bus_S       : out std_logic_vector(31 downto 0);
             Bus_mult_HI : out std_logic_vector(31 downto 0);
             Bus_mult_LO : out std_logic_vector(31 downto 0));
    end component alu_top;

    --Inputs
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    signal sv           : std_logic := '0';
    signal TestMult     : std_logic := '0';
    signal mult_mode    : std_logic := '0';
    signal ALUop        : std_logic_vector(3 downto 0) := (others => '0');
    signal shamt        : std_logic_vector(4 downto 0) := (others => '0');
    signal Bus_A        : std_logic_vector(31 downto 0) := (others => '0');
    signal Bus_B        : std_logic_vector(31 downto 0) := (others => '0');

    --Outputs
    signal Zero         : std_logic;
    signal ov           : std_logic;
    signal Bus_S        : std_logic_vector(31 downto 0);
    signal Bus_mult_HI  : std_logic_vector(31 downto 0);
    signal Bus_mult_LO  : std_logic_vector(31 downto 0);

    -- Clock period definitions
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: alu_top
        port map(clk         => clk,
                 rst         => rst,
                 sv          => sv,
                 TestMult    => TestMult,
                 mult_mode   => mult_mode,
                 ALUop       => ALUop,
                 shamt       => shamt,
                 Bus_A       => Bus_A,
                 Bus_B       => Bus_B,
                 Zero        => Zero,
                 ov          => ov,
                 Bus_S       => Bus_S,
                 Bus_mult_HI => Bus_mult_HI,
                 Bus_mult_LO => Bus_mult_LO);

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 100 ns.
        wait for 100 ns;

        rst <= '1';
        wait for clk_period * 2.5;
        rst <= '0';

        wait;
    end process;

end Behavioral;
