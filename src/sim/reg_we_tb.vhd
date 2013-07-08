library ieee;
use ieee.std_logic_1164.all;

entity reg_we_tb is
end reg_we_tb;

architecture Behavioral of reg_we_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component reg_we
        generic(W : integer := 32);
        port(clk      : in  std_logic;
             rst      : in  std_logic;
             we       : in  std_logic;
             data_in  : in  std_logic_vector(W - 1 downto 0);
             data_out : out std_logic_vector(W - 1 downto 0));
    end component reg_we;

    --Inputs
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    signal we           : std_logic := '0';
    signal data_in      : std_logic_vector(31 downto 0) := (others => '0');

    --Outputs
    signal data_out     : std_logic_vector(31 downto 0);

    -- Clock period definitions
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: reg_we
        generic map(W => 32)
        port map(clk      => clk,
                 rst      => rst,
                 we       => we,
                 data_in  => data_in,
                 data_out => data_out);

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
        wait for clk_period * 1;
        rst <= '0';

        -- Don't write
        data_in <= X"AAAAAAAA";
        wait for clk_period * 1;

        -- Don't write
        data_in <= X"BBBBBBBB";
        wait for clk_period * 1;

        -- Write
        data_in <= X"CCCCCCCC";
        we      <= '1';
        wait for clk_period * 1;
        we      <= '0';

        -- Don't write
        data_in <= X"DDDDDDDD";
        wait for clk_period * 2;

        -- Write
        data_in <= X"EEEEEEEE";
        we      <= '1';
        wait for clk_period * 3;

        -- Write
        data_in <= X"FFFFFFFF";
        wait for clk_period;
        we      <= '0';


        wait;
    end process;

end Behavioral;
