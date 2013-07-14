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

    process(Link, DMorALU, MF, HIorLO, data_alu_in, data_dm_in, data_mhi_in, data_mlo_in, data_npc_in)
    begin
        if(Link = '0' and MF = '0' and DMorALU = '0') then      -- Write register from ALU
            data_out <= data_alu_in;
        elsif(Link = '0' and MF = '0' and DMorALU = '1') then   -- Write register from DM
            data_out <= data_dm_in;
        elsif(Link = '0' and MF = '1' and HIorLO = '1') then    -- Write register from HI
            data_out <= data_mhi_in;
        elsif(Link = '0' and MF = '1' and HIorLO = '0') then    -- Write register from LO
            data_out <= data_mlo_in;
        elsif(Link = '1') then                                  -- Write register from NPC
            data_out <= data_npc_in;
        else
            data_out <= (others => '-');
        end if;
    end process;

end Behavioral;
