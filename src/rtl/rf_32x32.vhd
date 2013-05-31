library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rf_32x32 is
    port(   clk         : in  std_logic;
            RegWrite    : in  std_logic;
            RegImmNot   : in  std_logic;
            rs          : in  std_logic_vector(4 downto 0);
            rt          : in  std_logic_vector(4 downto 0);
            rd          : in  std_logic_vector(4 downto 0);
            dataW_in    : in  std_logic_vector(31 downto 0);
            dataA_out   : out std_logic_vector(31 downto 0);
            dataB_out   : out std_logic_vector(31 downto 0));
end rf_32x32;

architecture Behavioral of rf_32x32 is

    -- Declarations of Register File type & signal

    type Regfile_type is array (natural range<>) of std_logic_vector(31 downto 0);
    signal Regfile_Coff : Regfile_type(0 to 31) := ((others=> (others=>'0')));
    signal Addr_in      : std_logic_vector(4 downto 0);

begin

    process(clk, RegWrite, RegImmNot, rs, rt, rd, dataW_in, Regfile_Coff)
    begin

        -- Regfile_Read Assignments
        dataA_out <= Regfile_Coff(to_integer(unsigned(rs)));
        dataB_out <= Regfile_Coff(to_integer(unsigned(rt)));

        -- Write Address Assignment
        if (RegImmNot = '1') then
            Addr_in <= rd;
        elsif (RegImmNot = '0') then
            Addr_in <= rt;
        end if;

        -- Regfile_Write Assignments
        if(rising_edge(clk))then
            if(RegWrite = '1' and Addr_in /= "00000") then
                Regfile_Coff(to_integer(unsigned(Addr_in))) <= dataW_in;
            end if;
        end if;

    end process;

end Behavioral;
