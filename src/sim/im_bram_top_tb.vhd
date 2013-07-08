library ieee;
use ieee.std_logic_1164.all;

entity im_bram_top_tb is
end im_bram_top_tb;

architecture Behavioral of im_bram_top_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component im_bram_top
        port(clk      : in  std_logic;
             en       : in  std_logic;
             address  : in  std_logic_vector(10 downto 0);
             data_out : out std_logic_vector(31 downto 0));
    end component im_bram_top;

    --Inputs
    signal clk          : std_logic := '0';
    signal en           : std_logic := '0';
    signal address      : std_logic_vector(10 downto 0) := (others => '0');

    --Outputs
    signal data_out     : std_logic_vector(31 downto 0);

    -- Clock period definitions
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: im_bram_top
        port map(clk      => clk,
                 en       => en,
                 address  => address,
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
        
        en      <= '1';
        
        address <= "00000000000";
        wait for clk_period * 1;
        
        address <= "00000000001";
        wait for clk_period * 1;

        -- Add more

        wait;
    end process;

end Behavioral;
