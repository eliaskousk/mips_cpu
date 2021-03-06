library ieee;
use ieee.std_logic_1164.all;

entity alu_mult_lfsr_tb is
end alu_mult_lfsr_tb;

architecture Behavioral of alu_mult_lfsr_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component alu_mult_lfsr
        port(clk         : in  std_logic;
             rst         : in  std_logic;
             enable      : in  std_logic;
             finish      : out std_logic;
             seed_hi     : in  std_logic_vector(31 downto 0);
             seed_lo     : in  std_logic_vector(31 downto 0);
             data_out_hi : out std_logic_vector(31 downto 0);
             data_out_lo : out std_logic_vector(31 downto 0));
    end component alu_mult_lfsr;

    --Inputs
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    signal enable       : std_logic := '0';
    signal seed_hi      : std_logic_vector(31 downto 0) := (others => '0');
    signal seed_lo      : std_logic_vector(31 downto 0) := (others => '0');

    --Outputs
    signal finish       : std_logic;
    signal data_out_hi  : std_logic_vector(31 downto 0);
    signal data_out_lo  : std_logic_vector(31 downto 0);

    -- Clock period definitions
    constant clk_period : time := 20 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: alu_mult_lfsr
        port map(clk         => clk,
                 rst         => rst,
                 enable      => enable,
                 finish      => finish,
                 seed_hi     => seed_hi,
                 seed_lo     => seed_lo,
                 data_out_hi => data_out_hi,
                 data_out_lo => data_out_lo);

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

        seed_hi <= X"01234567";
        seed_lo <= X"89ABCDEF";

        -- Should not start the test
        enable <= '0';
        wait for clk_period * 3;

        -- Start the test with the above seeds
        enable <= '1';

        wait;
    end process;

end Behavioral;
