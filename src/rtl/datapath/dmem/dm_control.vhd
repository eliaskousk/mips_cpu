library ieee;
use ieee.std_logic_1164.all;

entity dm_control is
    port(   data_mdr_in     : in  std_logic_vector(31 downto 0);
            data_mar_in     : in  std_logic_vector(31 downto 0);
            data_dmd_in     : in  std_logic_vector(31 downto 0);
            DMWT            : in  std_logic_vector(2 downto 0);
            DMD_re          : in  std_logic;
            DMD_we          : in  std_logic;
            Error           : out std_logic_vector(0 downto 0);
            data_mdr_out    : out std_logic_vector(31 downto 0);
            data_dma_out    : out std_logic_vector(31 downto 0);
            data_we_out     : out std_logic_vector(3 downto 0);
            data_dmd_out    : out std_logic_vector(31 downto 0));
end dm_control;

architecture Behavioral of dm_control is

    signal lsbits       : std_logic_vector(1 downto 0);
    signal data_read    : std_logic_vector(31 downto 0);
    signal data_write   : std_logic_vector(31 downto 0);
    signal data_we      : std_logic_vector(3 downto 0);
    signal data_error   : std_logic;

begin

    lsbits      <= data_mar_in(1 downto 0);

    Error(0)    <= data_error when (DMD_re = '1' or DMD_we = '1') else '0';

    process(DMWT, lsbits, data_mar_in)
    begin

        -- Check address alignment

        if(DMWT(2) = '1' and  lsbits /= "00") then                          -- Unaligned LW, SW
            data_dma_out    <= (others => '0');
            data_error      <= '1';
        elsif(DMWT(1) = '1' and (lsbits = "01" or lsbits = "11")) then    -- Unaligned LH, LHU, SH
            data_dma_out    <= (others => '0');
            data_error      <= '1';
        else
            data_dma_out    <= data_mar_in;
            data_error      <= '0';                                         -- LB, LBU, SB and All aligned LW, SW, LH, LHU, SH
        end if;

    end process;

    process(DMWT, lsbits, data_dmd_in, data_mdr_in, data_we)
    begin

        data_read   <= (others => '-');
        data_write  <= (others => '-');
        data_we     <= "0000";

        -- Read or write the correct bytes

        if(DMWT(2) = '1') then      -- LW, SW
            data_read   <= data_dmd_in;
            data_write  <= data_mdr_in;
            data_we     <= "1111";
        elsif(DMWT(1) = '1') then   -- LH, LHU, SH
            if(lsbits = "00") then
                data_read(15 downto 0)      <= data_dmd_in(15 downto 0);
                data_read(31 downto 16)     <= (others => (data_dmd_in(15) and DMWT(0)));

                data_write(15 downto 0) <= data_mdr_in(15 downto 0);
                data_write(31 downto 16)    <= (others => (data_mdr_in(15) and DMWT(0)));
                data_we                     <= "0011";
            elsif(lsbits = "10") then
                data_read(15 downto 0)      <= data_dmd_in(31 downto 16);
                data_read(31 downto 16)     <= (others => (data_dmd_in(31) and DMWT(0)));

                data_write(15 downto 0)     <= data_mdr_in(31 downto 16);
                data_write(31 downto 16)    <= (others => (data_mdr_in(31) and DMWT(0)));
                data_we                     <= "1100";
            end if;
            
        elsif(DMWT(1) = '0') then   -- LB, LBU, SB
            if(lsbits = "00") then
                data_read(7 downto 0)   <= data_dmd_in(7 downto 0);
                data_read(31 downto 8)  <= (others => (data_dmd_in(7) and DMWT(0)));
                
                data_write(7 downto 0)  <= data_mdr_in(7 downto 0);
                data_write(31 downto 8) <= (others => '0');
                data_we                 <= "0001";

            elsif(lsbits = "01") then
                data_read(7 downto 0)   <= data_dmd_in(15 downto 8);
                data_read(31 downto 8)  <= (others => (data_dmd_in(15) and DMWT(0)));
                
                data_write(7 downto 0)  <= (others => '0');
                data_write(15 downto 8) <= data_mdr_in(7 downto 0);
                data_write(31 downto 16) <= (others => '0');
                data_we                 <= "0010";
            elsif(lsbits = "10") then
                data_read(7 downto 0)   <= data_dmd_in(23 downto 16);
                data_read(31 downto 8)  <= (others => (data_dmd_in(23) and DMWT(0)));
                
                data_write(15 downto 0) <= (others => '0');
                data_write(23 downto 16) <= data_mdr_in(7 downto 0);
                data_write(31 downto 24) <= (others => '0');
                data_we                  <= "0100";
            elsif(lsbits = "11") then
                data_read(7 downto 0)   <= data_dmd_in(31 downto 24);
                data_read(31 downto 8)  <= (others => (data_dmd_in(31) and DMWT(0)));
                
                data_write(23 downto 0) <= (others => '0');
                data_write(31 downto 24) <= data_mdr_in(7 downto 0);
                data_we                 <= "1000";
            end if;            
        end if;
    end process;

    process(DMD_we, data_write, data_read, data_we, data_error)
    begin

        -- Load or store the data (do nothing on error error)

        if(DMD_we = '1' and data_error = '0') then
            data_we_out     <= data_we;
            data_dmd_out    <= data_write;
            data_mdr_out    <= (others => '-');
        elsif(DMD_we = '0' and data_error = '0') then
            data_we_out     <= (others => '0');
            data_dmd_out    <= (others => '-');
            data_mdr_out    <= data_read;
        else
            data_we_out     <= (others => '0');
            data_dmd_out    <= (others => '-');
            data_mdr_out    <= (others => '-');
        end if;

    end process;

end Behavioral;
