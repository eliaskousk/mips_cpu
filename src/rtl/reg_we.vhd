library ieee;
use ieee.std_logic_1164.all;

entity reg_we is
    generic(    W       : integer := 32);
    port(   clk         : in  std_logic;
            rst         : in  std_logic;
            we          : in  std_logic;
            data_in     : in  std_logic_vector(W - 1 downto 0);
            data_out    : out std_logic_vector(W - 1 downto 0));
end reg_we;

architecture Behavioral of reg_we is

begin

    process(clk, rst)
    begin

        if(rst = '1') then

            data_out <= (others => '0');

        elsif(clk'event and clk = '1') then

            if(we = '1') then

                data_out <= data_in;

            end if;

        end if;

    end process;

end Behavioral;
