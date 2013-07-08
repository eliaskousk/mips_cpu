library ieee;
use ieee.std_logic_1164.all;

entity npc_psd_tb is
end npc_psd_tb;

architecture Behavioral of npc_psd_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component npc_psd
        port(dataP_in : in  std_logic_vector(3 downto 0);
             dataA_in : in  std_logic_vector(25 downto 0);
             data_out : out std_logic_vector(31 downto 0));
    end component npc_psd;

    --Inputs
    signal dataP_in : std_logic_vector(3 downto 0) := (others => '0');
    signal dataA_in : std_logic_vector(25 downto 0) := (others => '0');

    --Outputs
    signal data_out : std_logic_vector(31 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: npc_psd
        port map(dataP_in => dataP_in,
                 dataA_in => dataA_in,
                 data_out => data_out);

    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 20 ns.
        wait for 20 ns;

        dataP_in <= "0010";
        dataA_in <= "00" & X"AAAAAA";
        wait for 20 ns;

        dataP_in <= "1000";
        dataA_in <= "01" & X"BBBBBB";
        wait for 20 ns;

        dataP_in <= "1111";
        dataA_in <= "11" & X"FFFFFF";
        wait for 20 ns;

        wait;
    end process;

end Behavioral;
