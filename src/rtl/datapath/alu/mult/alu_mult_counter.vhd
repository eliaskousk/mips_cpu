library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_mult_counter is
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        enable      : in  std_logic;
        finish      : out std_logic;
        data_out_hi : out std_logic_vector(31 downto 0);
        data_out_lo : out std_logic_vector(31 downto 0));
end entity alu_mult_counter;

architecture Behavioral of alu_mult_counter is

    signal counter      : std_logic_vector(7 downto 0);
    signal counter_hi   : std_logic_vector(3 downto 0);
    signal counter_lo   : std_logic_vector(3 downto 0);

begin

    process (clk, rst, enable)
    begin
        if(rst = '1') then
            counter <= (others => '0');
            finish  <= '0';
        else
            if (clk'event and clk='1') then
                if enable = '0' then
                    counter <= (others => '0');
                    finish  <= '0';
                elsif enable = '1' and counter = X"FF" then
                    counter <= (others => '0');
                    finish  <= '1';
                else
                    counter <= std_logic_vector(unsigned(counter) + 1);
                    finish  <= '0';
                end if;
            end if;
        end if;
    end process;

    counter_hi  <= counter(7 downto 4);
    counter_lo  <= counter(3 downto 0);

    data_out_hi <= counter_hi & counter_hi & counter_hi & counter_hi & counter_hi & counter_hi & counter_hi & counter_hi;
    data_out_lo <= counter_lo & counter_lo & counter_lo & counter_lo & counter_lo & counter_lo & counter_lo & counter_lo;

end architecture Behavioral;
