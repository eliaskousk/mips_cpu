library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_mult_unit is
    port(   X       : in std_logic_vector(31 downto 0);
            Y       : in std_logic_vector(31 downto 0);
            P_HI    : out std_logic_vector(31 downto 0);
            P_LO    : out std_logic_vector(31 downto 0));
end alu_mult_unit;

architecture Structural of alu_mult_unit is

    signal X_signed : signed(31 downto 0);
    signal Y_signed : signed(31 downto 0);
    signal P_signed : signed(63 downto 0);
    signal P_vector : std_logic_vector(63 downto 0);

begin

    X_signed    <= signed(X);
    Y_signed    <= signed(Y);
    P_signed    <= X_signed * Y_signed;
    P_vector    <= std_logic_vector(P_signed);
    P_HI        <= P_vector(63 downto 32);
    P_LO        <= P_vector(31 downto 0);

end Structural;
