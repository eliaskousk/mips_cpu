library ieee;
use ieee.std_logic_1164.all;

entity alu_mult_misr is
    port(   clk             : in  std_logic;
            rst             : in  std_logic;
            data_in_hi      : in  std_logic_vector(31 downto 0);
            data_in_lo      : in  std_logic_vector(31 downto 0);
            signature_hi    : out std_logic_vector(31 downto 0);
            signature_lo    : out std_logic_vector(31 downto 0));
end alu_mult_misr;

architecture Behavioral of alu_mult_misr is

    signal lfsr_reg : std_logic_vector(63 downto 0);
    signal data_in  : std_logic_vector(63 downto 0);

begin

    data_in <= data_in_hi & data_in_lo;

    process (clk)
        variable lfsr_tap : std_logic;
    begin

    if (clk'event and clk = '1') then
        if rst = '1' then
            lfsr_reg <= data_in;
        else
            lfsr_tap    := lfsr_reg(0) xor lfsr_reg(1) xor lfsr_reg(3) xor lfsr_reg(4);
            lfsr_reg    <= (lfsr_reg(62 downto 0) & lfsr_tap) xor data_in;
        end if;
    end if;

    end process;

    signature_hi    <= lfsr_reg(63 downto 32);
    signature_lo    <= lfsr_reg(31 downto 0);

end Behavioral;
