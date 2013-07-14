library ieee;
use ieee.std_logic_1164.all;

entity alu_mux is
    port(   data_regA_in    : in  std_logic_vector(31 downto 0);
            data_regB_in    : in  std_logic_vector(31 downto 0);
            data_imm_in     : in  std_logic_vector(31 downto 0);
            AluSelect       : in  std_logic;
            dataA_out       : out std_logic_vector(31 downto 0);
            dataB_out       : out std_logic_vector(31 downto 0));
end alu_mux;

architecture Structural of alu_mux is

begin

    dataA_out <= data_regA_in;

    with AluSelect select

        dataB_out   <=  data_regB_in    when '1',
                        data_imm_in     when '0',
                        (others => '-') when others;

end Structural;
