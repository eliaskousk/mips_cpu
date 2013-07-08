library ieee;
use ieee.std_logic_1164.all;

entity alu_mult_comparator_tb is
end alu_mult_comparator_tb;

architecture Behavioral of alu_mult_comparator_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component alu_mult_comparator
        port(clk        : in  std_logic;
             rst        : in  std_logic;
             enable     : in  std_logic;
             data_in_hi : in  std_logic_vector(31 downto 0);
             data_in_lo : in  std_logic_vector(31 downto 0);
             result     : out std_logic);
    end component alu_mult_comparator;

    --Inputs
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    signal enable       : std_logic := '0';
    signal data_in_hi   : std_logic_vector(31 downto 0) := (others => '0');
    signal data_in_lo   : std_logic_vector(31 downto 0) := (others => '0');

    --Outputs
    signal result       : std_logic;

    -- Clock period definitions
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
   uut: alu_mult_comparator
       port map(clk        => clk,
                rst        => rst,
                enable     => enable,
                data_in_hi => data_in_hi,
                data_in_lo => data_in_lo,
                result     => result);

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
