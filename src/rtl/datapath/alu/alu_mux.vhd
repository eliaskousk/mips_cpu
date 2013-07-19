library ieee;
use ieee.std_logic_1164.all;

entity alu_mux is
    port(   clk             : in  std_logic;
            rst             : in  std_logic;
            data_regA_in    : in  std_logic_vector(31 downto 0);
            data_regB_in    : in  std_logic_vector(31 downto 0);
            data_imm_in     : in  std_logic_vector(31 downto 0);
            AluSelect       : in  std_logic;
            dataA_out       : out std_logic_vector(31 downto 0);
            dataB_out       : out std_logic_vector(31 downto 0));
end alu_mux;

architecture Structural of alu_mux is

    signal dataA : std_logic_vector(31 downto 0);
    signal dataB : std_logic_vector(31 downto 0);

begin

    dataA <= data_regA_in;

    with AluSelect select

        dataB   <=  data_regB_in    when '1',
                    data_imm_in     when '0',
                    (others => '-') when others;

    -- Register output during the ID stage to minimize the critical path and clock period
    process(clk, rst, dataA, dataB)
    begin

        if(rst = '1') then

            dataA_out <= (others => '0');
            dataB_out <= (others => '0');

        elsif(clk'event and clk = '1') then

            dataA_out <= dataA;
            dataB_out <= dataB;

        end if;

    end process;

end Structural;
