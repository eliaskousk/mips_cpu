library ieee;
use ieee.std_logic_1164.all;

entity npc_inc_tb is
end npc_inc_tb;

architecture Behavioral of npc_inc_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component npc_inc
        port(data_in  : in  std_logic_vector(31 downto 0);
             data_out : out std_logic_vector(31 downto 0));
    end component npc_inc;

    --Inputs
    signal data_in  : std_logic_vector(31 downto 0) := (others => '0');

    --Outputs
    signal data_out : std_logic_vector(31 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: npc_inc
        port map(data_in  => data_in,
                 data_out => data_out);

    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 20 ns.
        wait for 20 ns;

        data_in <= X"00000000";
        wait for 20 ns;

        data_in <= X"AAAAAAAA";
        wait for 20 ns;

        wait;
    end process;

end Behavioral;
