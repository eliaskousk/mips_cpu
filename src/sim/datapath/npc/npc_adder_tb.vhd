library ieee;
use ieee.std_logic_1164.all;

entity npc_adder_tb is
end npc_adder_tb;

architecture Behavioral of npc_adder_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component npc_adder
        port(dataA_in : in  std_logic_vector(31 downto 0);
             dataB_in : in  std_logic_vector(31 downto 0);
             data_out : out std_logic_vector(31 downto 0));
    end component npc_adder;

    --Inputs
    signal dataA_in : std_logic_vector(31 downto 0) := (others => '0');
    signal dataB_in : std_logic_vector(31 downto 0) := (others => '0');

    --Outputs
    signal data_out : std_logic_vector(31 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: npc_adder
       port map(dataA_in => dataA_in,
                dataB_in => dataB_in,
                data_out => data_out);

    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 20 ns.
        wait for 20 ns;

        dataA_in <= X"AAAAAAAA";
        dataB_in <= X"11111111";
        wait for 20 ns;

        dataA_in <= X"BBBBBBBB";
        dataB_in <= X"11111111";
        wait for 20 ns;

        wait;
    end process;

end Behavioral;
