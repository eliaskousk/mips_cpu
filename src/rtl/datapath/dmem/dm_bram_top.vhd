library ieee;
use ieee.std_logic_1164.all;

--- 2K X 32 RAM (parallel concatenation of four 2Kx8 block RAMs)

entity dm_bram_top is
    port(   clk         : in  std_logic;
            en          : in  std_logic_vector(3 downto 0);
            we          : in  std_logic_vector(3 downto 0);
            ssr         : in  std_logic_vector(3 downto 0);
            address     : in  std_logic_vector(10 downto 0);
            data_in     : in  std_logic_vector(31 downto 0);
            data_out    : out std_logic_vector(31 downto 0));
end dm_bram_top;

architecture Structural of dm_bram_top is

    component dm_bram_2Kx8 is 
        port(   clk : in  std_logic;
                we  : in  std_logic;
                en	: in  std_logic;
                ssr	: in  std_logic;
                dop : out std_logic_vector(0 downto 0);
                a   : in  std_logic_vector(10 downto 0);
                di  : in  std_logic_vector (7  downto 0);
                do  : out std_logic_vector(7 downto 0));
    end component;

begin

    GenDM : for I in 0 to 3 generate

            DM : dm_bram_2Kx8
            port map(
                        clk => clk,
                        we  => we(I),
                        en  => en(I),
                        ssr => ssr(I),
                        a   => address,
                        di  => data_in(((8*I)+7) downto (8*I)),
                        do  => data_out(((8*I)+7) downto (8*I)),
                        dop => open);

    end generate GenDM;

end Structural;
