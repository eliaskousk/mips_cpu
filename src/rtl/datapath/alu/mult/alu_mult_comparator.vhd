library ieee;
use ieee.std_logic_1164.all;

entity alu_mult_comparator is
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        bist_check  : in  std_logic;
        bist_mode   : in  std_logic_vector(1 downto 0);
        data_in_hi  : in  std_logic_vector(31 downto 0);
        data_in_lo  : in  std_logic_vector(31 downto 0);
        fail        : out std_logic);
end entity alu_mult_comparator;

architecture Behavioral of alu_mult_comparator is

    constant lfsr_hi_correct    : std_logic_vector(31 downto 0) := X"AAAAAAAA";
    constant lfsr_lo_correct    : std_logic_vector(31 downto 0) := X"BBBBBBBB";
    constant counter_hi_correct : std_logic_vector(31 downto 0) := X"CCCCCCCC";
    constant counter_lo_correct : std_logic_vector(31 downto 0) := X"DDDDDDDD";
    constant atpg_hi_correct    : std_logic_vector(31 downto 0) := X"EEEEEEEE";
    constant atpg_lo_correct    : std_logic_vector(31 downto 0) := X"FFFFFFFF";

begin

    process (clk, rst, bist_check, bist_mode, data_in_hi, data_in_lo)
    begin
        if(rst = '1') then
            fail <= '0';
        else
            if (clk'event and clk='1') then
                if bist_check = '1' then
                    if(bist_mode = "01" and (data_in_hi /= lfsr_hi_correct or data_in_lo /= lfsr_lo_correct)) then
                        fail <= '1';
                    elsif(bist_mode = "10" and (data_in_hi /= counter_hi_correct or data_in_lo /= counter_lo_correct)) then
                        fail <= '1';
                    elsif(bist_mode = "11" and (data_in_hi /= atpg_hi_correct or data_in_lo /= atpg_lo_correct)) then
                        fail <= '1';
                    else
                        fail <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;

end architecture Behavioral;
