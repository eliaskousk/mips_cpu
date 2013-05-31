library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity npc_psd is
    port(   dataP_in    : in  std_logic_vector(3 downto 0);
            dataA_in    : in  std_logic_vector(25 downto 0);
            data_out    : out std_logic_vector(31 downto 0));
end npc_psd;

architecture Structural of npc_psd is

begin

    data_out <= dataP_in & dataA_in & "00";

end Structural;
