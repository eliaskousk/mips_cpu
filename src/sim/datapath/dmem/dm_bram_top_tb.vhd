library ieee;
use ieee.std_logic_1164.all;

entity dm_bram_top_tb is
end dm_bram_top_tb;

architecture Behavioral of dm_bram_top_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component dm_bram_top
        port(clk      : in  std_logic;
             en       : in  std_logic_vector(3 downto 0);
             we       : in  std_logic_vector(3 downto 0);
             ssr      : in  std_logic_vector(3 downto 0);
             address  : in  std_logic_vector(10 downto 0);
             data_in  : in  std_logic_vector(31 downto 0);
             data_out : out std_logic_vector(31 downto 0));
    end component dm_bram_top;

    --Inputs
    signal clk          : std_logic := '0';
    signal en           : std_logic_vector(3 downto 0) := (others => '0');
    signal we           : std_logic_vector(3 downto 0) := (others => '0');
    signal ssr          : std_logic_vector(3 downto 0) := (others => '0');
    signal address      : std_logic_vector(10 downto 0) := (others => '0');
    signal data_in      : std_logic_vector(31 downto 0) := (others => '0');

    --Outputs
    signal data_out     : std_logic_vector(31 downto 0);

    -- Clock period definitions
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: dm_bram_top
        port map(clk      => clk,
                 en       => en,
                 we       => we,
                 ssr      => ssr,
                 address  => address,
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
         
        en <= "1111";
        ssr <= "0000";
        
        -- Writes

        we      <= "1111";
        
        address <= "000" & X"00";
        data_in <= X"00000000";
        wait for clk_period * 1;
        
        address <= "000" & X"01";
        data_in <= X"00000000";
        wait for clk_period * 1;
        
        -- Fill the rest writes

        -- End writes
        
        -- Reads

        we      <= "0000";
        
        address <= "000" & X"00";
        data_in <= X"00000000";
        wait for clk_period * 1;
        
        address <= "000" & X"01";
        data_in <= X"00000000";
        wait for clk_period * 1;
        
        -- Fill the rest reads
        
        -- End reads

        wait;
    end process;

end Behavioral;
