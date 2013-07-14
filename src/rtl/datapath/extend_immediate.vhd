library ieee;
use ieee.std_logic_1164.all;

entity extend_immediate is
    port(   data_in     : in  std_logic_vector(15 downto 0);
            SorZ        : in  std_logic;
            data_out    : out std_logic_vector(31 downto 0));
end extend_immediate;

architecture Structural of extend_immediate is

begin

    data_out(15 downto 0)   <= data_in;
    data_out(31 downto 16)  <= (others => (data_in(15) and SorZ));

end Structural;
