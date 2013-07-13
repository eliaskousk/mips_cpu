library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_mult_atpg is
    port (
        clk             : in std_logic;
        rst             : in std_logic;
        start           : in std_logic;
        data_out_hi     : out std_logic_vector(31 downto 0);
        data_out_lo     : out std_logic_vector(31 downto 0));
end entity alu_mult_atpg;

architecture Behavioral of alu_mult_atpg is

    component alu_mult_atpg_bram_hi is 
        port(   clk : in  std_logic;
                we  : in  std_logic;
                en  : in  std_logic;
                ssr : in  std_logic;
                dop : out std_logic_vector(0 downto 0);
                a   : in  std_logic_vector(6 downto 0);
                di  : in  std_logic_vector (31 downto 0);
                do  : out std_logic_vector(31 downto 0));
    end component;

    component alu_mult_atpg_bram_lo is 
        port(   clk : in  std_logic;
                we  : in  std_logic;
                en  : in  std_logic;
                ssr : in  std_logic;
                dop : out std_logic_vector(0 downto 0);
                a   : in  std_logic_vector(6 downto 0);
                di  : in  std_logic_vector (31 downto 0);
                do  : out std_logic_vector(31 downto 0));
    end component;

    signal address  : std_logic_vector(6 downto 0);

begin

    process(clk)

    begin

        if(rst = '1') then

            address <= (others => '0');

        else

            if (clk'event and clk='1') then

                if start = '1' then
                    address <= (others => '0');
                else
                    address <= std_logic_vector(unsigned(address) + 1);
                end if;

            end if;

        end if;

    end process;


    BRAM_HI : alu_mult_atpg_bram_hi
    port map(
                clk => clk,
                we  => '0',
                en  => start,
                ssr => '0',
                a   => address,
                di  => (others => '0'),
                do  => data_out_hi);

    BRAM_LO : alu_mult_atpg_bram_lo
    port map(
                clk => clk,
                we  => '0',
                en  => start,
                ssr => '0',
                a   => address,
                di  => (others => '0'),
                do  => data_out_lo);


end architecture Behavioral;
