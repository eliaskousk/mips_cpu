library ieee;
use ieee.std_logic_1164.all;

entity alu_mult_top_tb is
end alu_mult_top_tb;

architecture Behavioral of alu_mult_top_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component alu_mult_top
        port(clk   : in  std_logic;
             rst   : in  std_logic;
             start : in  std_logic;
             X     : in  std_logic_vector(31 downto 0);
             Y     : in  std_logic_vector(31 downto 0);
             P_HI  : out std_logic_vector(31 downto 0);
             P_LO  : out std_logic_vector(31 downto 0);
             Fail  : out std_logic);
    end component alu_mult_top;

    --Inputs
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    signal start        : std_logic := '0';
    signal X            : std_logic_vector(31 downto 0) := (others => '0');
    signal Y            : std_logic_vector(31 downto 0) := (others => '0');

    --Outputs
    signal P_HI         : std_logic_vector(31 downto 0);
    signal P_LO         : std_logic_vector(31 downto 0);
    signal Fail         : std_logic;

    -- Clock period definitions
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: alu_mult_top
        port map(clk   => clk,
                 rst   => rst,
                 start => start,
                 X     => X,
                 Y     => Y,
                 P_HI  => P_HI,
                 P_LO  => P_LO,
                 Fail  => Fail);

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
        -- hold reset state for 20 ns.
        wait for 20 ns;

        rst <= '1';
        wait for clk_period * 2.5;
        rst <= '0';

        wait;
    end process;

end Behavioral;
