library ieee;
use ieee.std_logic_1164.all;

entity alu_mult_comparator is
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        enable      : in  std_logic;
        data_in_hi  : in  std_logic_vector(31 downto 0);
        data_in_lo  : in  std_logic_vector(31 downto 0);
        result      : out std_logic);
end entity alu_mult_comparator;

architecture Behavioral of alu_mult_comparator is

begin

    result <= '0';

end architecture Behavioral;
