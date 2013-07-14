library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity npc_inc is
    port(   data_in     : in  std_logic_vector(31 downto 0);
            data_out    : out std_logic_vector(31 downto 0));
end npc_inc;

architecture Structural of npc_inc is

    constant four : unsigned(31 downto 0) := (2 => '1', others => '0');

begin

    data_out <= std_logic_vector(unsigned(data_in) + four);

end Structural;
