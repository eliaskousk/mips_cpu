library ieee;
use ieee.std_logic_1164.all;

entity alu_mult_atpg_tb is
end alu_mult_atpg_tb;

architecture Behavioral of alu_mult_atpg_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component alu_mult_atpg
        port(clk         : in  std_logic;
             rst         : in  std_logic;
             start       : in  std_logic;
             data_out_hi : out std_logic_vector(31 downto 0);
             data_out_lo : out std_logic_vector(31 downto 0));
    end component alu_mult_atpg;

    --Inputs
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    signal start        : std_logic := '0';

    --Outputs
    signal data_out_hi : std_logic_vector(31 downto 0);
    signal data_out_lo : std_logic_vector(31 downto 0);

    -- Clock period definitions
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: alu_mult_atpg
        port map(clk         => clk,
                 rst         => rst,
                 start       => start,
                 data_out_hi => data_out_hi,
                 data_out_lo => data_out_lo);

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