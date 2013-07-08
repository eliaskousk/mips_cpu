library ieee;
use ieee.std_logic_1164.all;

entity npc_sl2_tb is
end npc_sl2_tb;

architecture Behavioral of npc_sl2_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component npc_sl2
        port(data_in  : in  std_logic_vector(31 downto 0);
             data_out : out std_logic_vector(31 downto 0));
    end component npc_sl2;

    --Inputs
    signal data_in  : std_logic_vector(31 downto 0) := (others => '0');

    --Outputs
    signal data_out : std_logic_vector(31 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: npc_sl2
        port map(data_in  => data_in,
                 data_out => data_out);

    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 100 ns.
        wait for 100 ns;

        wait;
    end process;

end Behavioral;
