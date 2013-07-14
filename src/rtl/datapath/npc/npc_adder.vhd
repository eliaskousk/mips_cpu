library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity npc_adder is
    port(   dataA_in    : in  std_logic_vector(31 downto 0);
            dataB_in    : in  std_logic_vector(31 downto 0);
            data_out    : out std_logic_vector(31 downto 0));
end npc_adder;

architecture Structural of npc_adder is

begin

    data_out <= std_logic_vector(unsigned(dataA_in) + unsigned(dataB_in));

end Structural;
