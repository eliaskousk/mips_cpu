library ieee;
use ieee.std_logic_1164.all;

entity alu_mult_lfsr is
    port(   clk         : in  std_logic;
            rst         : in  std_logic;
            start       : in  std_logic;
            seed_hi     : in  std_logic_vector(31 downto 0);
            seed_lo     : in  std_logic_vector(31 downto 0);
            data_out_hi : out std_logic_vector(31 downto 0);
            data_out_lo : out std_logic_vector(31 downto 0));
end alu_mult_lfsr;

architecture Behavioral of alu_mult_lfsr is

    signal lfsr_reg : std_logic_vector(63 downto 0);

begin

    process (clk, rst)
        variable lfsr_tap : std_logic;
    begin

        if(rst = '1') then

            lfsr_reg <= (others => '0');

        else

            if (clk'event and clk = '1') then

                if start = '1' then
                    lfsr_reg(63 downto 32)  <= seed_hi;
                    lfsr_reg(31 downto 0)   <= seed_lo;
                else
                    lfsr_tap    := lfsr_reg(0) xor lfsr_reg(1) xor lfsr_reg(3) xor lfsr_reg(4);
                    lfsr_reg    <= lfsr_reg(62 downto 0) & lfsr_tap;
                end if;

            end if;

        end if;

    end process;

    data_out_hi <= lfsr_reg(63 downto 32);
    data_out_lo <= lfsr_reg(31 downto 0);

end Behavioral;
