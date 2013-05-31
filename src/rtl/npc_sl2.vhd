library ieee;
use ieee.std_logic_1164.all;

entity npc_sl2 is
    port(   data_in     : in  std_logic_vector(31 downto 0);
            data_out    : out std_logic_vector(31 downto 0));
end npc_sl2;

architecture Structural of npc_sl2 is

begin

    data_out    <= data_in(29 downto 0) & "00";

end Structural;
