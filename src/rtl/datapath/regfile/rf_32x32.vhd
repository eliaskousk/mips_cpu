library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rf_32x32 is
    port(   clk         : in  std_logic;
            RegWrite    : in  std_logic;
            RegImmNot   : in  std_logic;
            RTZero      : in  std_logic;
            rs          : in  std_logic_vector(4 downto 0);
            rt          : in  std_logic_vector(4 downto 0);
            rd          : in  std_logic_vector(4 downto 0);
            dataW_in    : in  std_logic_vector(31 downto 0);
            dataA_out   : out std_logic_vector(31 downto 0);
            dataB_out   : out std_logic_vector(31 downto 0));
end rf_32x32;

architecture Behavioral of rf_32x32 is

    type ram_distr is array (0 to 31) of std_logic_vector(31 downto 0);
    signal regfile  : ram_distr := (others => (others=>'0'));
    signal rd_a     : std_logic_vector(4 downto 0);
    signal rs_a     : std_logic_vector(4 downto 0);
    signal rt_a     : std_logic_vector(4 downto 0);

begin

    rd_a    <= rd when RegImmNot = '1' else rt;
    rs_a    <= rs;
    rt_a    <= (others => '0') when RTZero = '1' else rt;

    process(clk, RegWrite, rd_a, rs_a, rt_a, dataW_in, regfile)
    begin

        -- Single Port Write (Synchronous)
        if(rising_edge(clk))then
            if(RegWrite = '1' and rd_a /= "00000") then
                regfile(to_integer(unsigned(rd_a))) <= dataW_in;
            end if;
        end if;

        -- Dual Port Read (Asynchronous, infers distributed ram)
        dataA_out <= regfile(to_integer(unsigned(rs_a)));
        dataB_out <= regfile(to_integer(unsigned(rt_a)));

    end process;

end Behavioral;
