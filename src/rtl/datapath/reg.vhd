library ieee;
use ieee.std_logic_1164.all;

entity reg is
    generic ( W         :   integer := 32);
    port(   clk         :   in  std_logic;
            rst         :   in  std_logic;
            data_in     :   in  std_logic_vector(W - 1 downto 0);
            data_out    :   out std_logic_vector(W - 1 downto 0));
end reg;

architecture Behavioral of reg is

begin

    process(clk, rst)
    begin

        if(rst = '1') then

            data_out <= (others => '0');

        elsif(clk'event and clk = '1') then

            data_out <= data_in;

        end if;

    end process;

end Behavioral;
