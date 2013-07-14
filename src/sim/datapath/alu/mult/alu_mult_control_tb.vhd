library ieee;
use ieee.std_logic_1164.all;

entity alu_mult_control_tb is
end alu_mult_control_tb;

architecture Behavioral of alu_mult_control_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component alu_mult_control
        port(clk          : in  std_logic;
             rst          : in  std_logic;
             start        : in  std_logic;
             bist_mode    : out std_logic_vector(1 downto 0);
             bist_start   : out std_logic_vector(2 downto 0);
             lfsr_seed_hi : out std_logic_vector(31 downto 0);
             lfsr_seed_lo : out std_logic_vector(31 downto 0));
    end component alu_mult_control;

    --Inputs
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    signal start        : std_logic := '0';

    --Outputs
    signal bist_mode    : std_logic_vector(1 downto 0);
    signal bist_start   : std_logic_vector(2 downto 0);
    signal lfsr_seed_hi : std_logic_vector(31 downto 0);
    signal lfsr_seed_lo : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period  : time := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)

    uut: alu_mult_control
        port map(clk          => clk,
                 rst          => rst,
                 start        => start,
                 bist_mode    => bist_mode,
                 bist_start   => bist_start,
                 lfsr_seed_hi => lfsr_seed_hi,
                 lfsr_seed_lo => lfsr_seed_lo);

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
