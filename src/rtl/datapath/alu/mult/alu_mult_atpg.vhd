library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_mult_atpg is
    port (
        clk             : in  std_logic;
        rst             : in  std_logic;
        enable          : in  std_logic;
        finish          : out std_logic;
        data_out_hi     : out std_logic_vector(31 downto 0);
        data_out_lo     : out std_logic_vector(31 downto 0));
end entity alu_mult_atpg;

architecture Behavioral of alu_mult_atpg is

    component alu_mult_atpg_bram_hi
        port(clk         : in  std_logic;
             en          : in  std_logic;
             address     : in  std_logic_vector(6 downto 0);
             data_vector : out std_logic_vector(31 downto 0));
    end component alu_mult_atpg_bram_hi;

    component alu_mult_atpg_bram_lo
        port(clk         : in  std_logic;
             en          : in  std_logic;
             address     : in  std_logic_vector(6 downto 0);
             data_vector : out std_logic_vector(31 downto 0));
    end component alu_mult_atpg_bram_lo;

    signal address          : std_logic_vector(6 downto 0);
    constant last_address   : std_logic_vector(6 downto 0) := "1101100"; -- Total vectors = 108

begin

    process(clk, rst, enable)
    begin
        if(rst = '1') then
            address <= (others => '0');
            finish  <= '0';
        else
            if (clk'event and clk = '1') then
                if (enable = '0') then
                    address <= (others => '0');
                    finish  <= '0';
                elsif enable = '1' and address = last_address then
                    address <= (others => '0');
                    finish  <= '1';
                else
                    address <= std_logic_vector(unsigned(address) + 1);
                    finish  <= '0';
                end if;
            end if;
        end if;
    end process;

    BRAM_HI : alu_mult_atpg_bram_hi
        port map(clk         => clk,
                 en          => enable,
                 address     => address,
                 data_vector => data_out_hi);

    BRAM_LO : alu_mult_atpg_bram_lo
        port map(clk         => clk,
                 en          => enable,
                 address     => address,
                 data_vector => data_out_lo);


end architecture Behavioral;
