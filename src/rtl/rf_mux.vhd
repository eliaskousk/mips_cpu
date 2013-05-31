library ieee;
use ieee.std_logic_1164.all;

entity rf_mux is
    port(   data_alu_in : in  std_logic_vector(31 downto 0);
            data_dm_in  : in  std_logic_vector(31 downto 0);
            data_npc_in : in  std_logic_vector(31 downto 0);
            data_mlo_in : in  std_logic_vector(31 downto 0);
            data_mhi_in : in  std_logic_vector(31 downto 0);
            Link        : in  std_logic;
            DMorALU     : in  std_logic;
            MF          : in  std_logic;
            HIorLO      : in  std_logic;
            data_out    : out std_logic_vector(31 downto 0));
end rf_mux;

architecture Behavioral of rf_mux is

begin

    process(DMorALU, Link, MF, HIorLO)
    begin

    if(DMorALU = '0') then
        data_out <= data_alu_in;
    elsif(DMorALU = '1') then
        data_out <= data_dm_in;
    end if;

    if(Link = '1') then
        data_out <= data_npc_in;
    elsif(MF = '1') then
        if(HIorLO = '0') then
            data_out <= data_mlo_in;
        else
            data_out <= data_mhi_in;
        end if;
    end if;

    end process;


end Behavioral;

--  OLD STUFF
--
--  signal WriteSelect : std_logic_vector(3 downto 0);
--
--  WriteSelect <= HIorLO & MF & Link & DMorALU;
--
--    with WriteSelect select
--        
--        data_out        <=      data_alu_in  when "-000",
--                                data_dm_in   when "-001",
--                                data_npc_in  when "--1-",
--                                data_mlo_in  when "010-",
--                                data_mhi_in  when "110-",
--                                (others => '-') when others;
