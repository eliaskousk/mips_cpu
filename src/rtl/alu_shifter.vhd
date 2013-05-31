library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_shifter is
    port(   left        : in  std_logic;
            logical     : in  std_logic;
            shift       : in  std_logic_vector(4 downto 0);
            shift_in    : in  std_logic_vector(31 downto 0);
            shift_out   : out std_logic_vector(31 downto 0));
end alu_shifter;

architecture Behavioral of alu_shifter is

begin

    process(shift_in, shift, left, logical)
        variable shift_n    : natural range 0 to 31;
        variable in_s       : signed (31 downto 0);
        variable in_u       : unsigned (31 downto 0);
        variable SEL        : std_logic_vector(1 downto 0);
    begin

        in_s    := signed(shift_in);
        in_u    := unsigned(shift_in);
        SEL     := logical & left;
        shift_n := to_integer(unsigned(shift));

        case SEL is
            when "00"   => shift_out <= std_logic_vector(SHIFT_RIGHT(in_s, shift_n));
            when "01"   => shift_out <= std_logic_vector(SHIFT_LEFT(in_s, shift_n));
            when "10"   => shift_out <= std_logic_vector(SHIFT_RIGHT(in_u, shift_n));
            when others => shift_out <= std_logic_vector(SHIFT_LEFT(in_u, shift_n));
        end case;

    end process;

end Behavioral;
