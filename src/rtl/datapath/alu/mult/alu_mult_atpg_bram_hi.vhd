library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_mult_atpg_bram_hi is
    port(   clk         : in  std_logic;
            en          : in  std_logic;
            address     : in  std_logic_vector(6 downto 0);
            data_vector : out std_logic_vector(31 downto 0));
end alu_mult_atpg_bram_hi;

architecture Structural of alu_mult_atpg_bram_hi is

    type atpg_rom is array (0 to 127) of std_logic_vector(31 downto 0);

    constant vectors_hi: atpg_rom := (
        "00000000000000000000000000000000",
        "01000000010010001010010000011001",
        "01010010000011101000100100100101",
        "10001000101111111110010010010000",
        "01010011111010000000010001100010",
        "00010001000010010010010000000001",
        "01000101010001110010010010010000",
        "00100001111111111011110010001010",
        "00100000010000001101010010000010",
        "01000010000011100010000000010000",
        "01101101100000001000010001110000",
        "11000000000000001101010010000010",
        "01010001100010010010000001111100",
        "00100010010000010010011000000001",
        "10010010010010010011101111101100",
        "01010010000000011100110100101111",
        "11101010010010010010010010010000",
        "01000001001000010001100010000000",
        "00111000010000101001100001011001",
        "10100010001101010000010010000000",
        "10101010000010001100010010000000",
        "11010100000010000010001010010010",
        "00101100010010010011100000010000",
        "01101010000000010010010010010001",
        "01110000000000000010010011101000",
        "11011010001010010010001100010010",
        "01000011100010000010000010000001",
        "01000010010000010001101101100111",
        "01010010010010000010001100000100",
        "00010001101010000010000000000000",
        "01000000000000001101011100110111",
        "00111010000010010001011001011010",
        "01010001001010010010001010000000",
        "11100100010011010001100111111100",
        "11011000001010001001010010010010",
        "01010010000000001101010010000000",
        "00000010011110000000000010010000",
        "01001101010010010010010001010000",
        "01110000011010010001010010000000",
        "01001010000000000011000010010000",
        "01111001100010111000010011100000",
        "01000010010010000010000000100111",
        "01101100111010010010001010000000",
        "11110010010010011111010000011011",
        "01010010000000000001101011101101",
        "00100010010010010010010011101100",
        "01000010000010000010001010010010",
        "11110011101000010000000010011100",
        "11100000010010001100010000000000",
        "01010000100100110010010000010001",
        "00000010001100010011110110101111",
        "01000010000010010000011100010001",
        "11011010101010100001000010010010",
        "01010001010010010010011111100110",
        "00001000000001101010000000010000",
        "01010010000010011010010000001011",
        "01100010001000010000000010010010",
        "01010000001100010010011110110110",
        "10010000010010001010010010000000",
        "00000010001100010000000010000010",
        "01000010001100010000000000010000",
        "00010010001100010000000000000000",
        "00000010000001101010010000010001",
        "11010100110111000010000011100000",
        "01001010000000000010010010110111",
        "00100010000000010001111110101111",
        "11110011100010010010010010010000",
        "01010010010010010010011001010000",
        "01010010010001000010101111111110",
        "00010010000010011101010000000010",
        "10000010000010011101010010010010",
        "01011101010010000000010000101101",
        "01101010000010000011100010010000",
        "01001010010010010001110110110100",
        "00110000111000011101010010000010",
        "00100010010010011001010011011011",
        "11100010011101010010000010000000",
        "10111000000010000010000011100000",
        "00010000010010001010101111101110",
        "01000010000010000010001010010010",
        "00000000010010010011101010010001",
        "01010000010010001100010010010000",
        "00010010010001101010010011101111",
        "11110010000010010000001110110101",
        "01001010001100010001010000010010",
        "00100000010011010000010010010011",
        "01000110000000010000000010010000",
        "01000000010010001010000000000010",
        "00010000001100010000010011111111",
        "01000000010001101010000011101101",
        "01001010010010010000010011101111",
        "11100000010010010000010010100011",
        "10010000010010010010001010010000",
        "00111100110001011110000011100000",
        "11000000100100011000011100000010",
        "10000001001000010010011101010010",
        "10000000000010010000001101010010",
        "10001100000010010000000010000000",
        "01000010010010010000110100111101",
        "00001100000010011100000000000010",
        "10100000011110010000000010010000",
        "11100010101110000010010011100000",
        "10110011110001010010010010010000",
        "01010000001100001100001100110111",
        "10010010010000010001010010000000",
        "00011101001010010010010010010000",
        "11110010000010010001100101110101",
        "01010010001111010010010010010000",
        others => X"00000000");

begin

    process(clk, address)
    begin
        if(clk'event and clk = '1') then
            if en = '1' then
                data_vector <= vectors_hi(to_integer(unsigned(address)));
            else
                data_vector <= (others =>  '-');
            end if;
        end if;
    end process;

end Structural;
