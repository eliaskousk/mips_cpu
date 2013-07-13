library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_mult_counter is
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        start       : in std_logic;
        data_out_hi : out std_logic_vector(31 downto 0);
        data_out_lo : out std_logic_vector(31 downto 0));
end entity alu_mult_counter;

architecture Behavioral of alu_mult_counter is

    signal counter  : std_logic_vector(6 downto 0);

begin

    process (clk)

    begin

        if(rst = '1') then

            counter <= (others => '0');

        else

            if (clk'event and clk='1') then

                if start = '1' then
                    counter <= (others => '0');
                else
                    counter <= std_logic_vector(unsigned(counter) + 1);
                end if;

            end if;

        end if;

    end process;

    data_out_hi(31 downto 7)    <= (others => '0');
    data_out_hi(6 downto 0)     <= counter;

    data_out_lo(31 downto 7)    <= (others => '0');
    data_out_lo(6 downto 0)     <= counter;

end architecture Behavioral;
