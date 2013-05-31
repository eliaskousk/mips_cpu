library ieee;
use ieee.std_logic_1164.all;

entity dm_control is
    port(   data_mdr_in     : in  std_logic_vector(31 downto 0);
            data_mar_in     : in  std_logic_vector(31 downto 0);
            data_dmd_in     : in  std_logic_vector(31 downto 0);
            DMD_we          : in  std_logic;
            Error           : out std_logic_vector(0 downto 0);
            data_mdr_out    : out std_logic_vector(31 downto 0);
            data_dma_out    : out std_logic_vector(31 downto 0);
            data_we_out     : out std_logic_vector(3 downto 0);
            data_dmd_out    : out std_logic_vector(31 downto 0));
end dm_control;

architecture Behavioral of dm_control is

begin

    process(data_mdr_in, data_mar_in, data_dmd_in, DMD_we)
    begin

        if(data_mar_in(1 downto 0) = "00") then
            Error           <= "0";
            data_dma_out    <= data_mar_in;
        else
            Error           <= "1";
            data_dma_out    <= (others => '-');
        end if;

        if(DMD_we = '1') then
            data_we_out     <= (others => '1');
            data_dmd_out    <= data_mdr_in;
            data_mdr_out    <= (others => '-');
        else
            data_we_out     <= (others => '0');
            data_dmd_out    <= (others => '-');
            data_mdr_out    <= data_dmd_in;
        end if;

    end process;

end Behavioral;
