library ieee;
use ieee.std_logic_1164.all;

entity npc_mux is
    port(   data_npc_in : in  std_logic_vector(31 downto 0);
            data_imm_in : in  std_logic_vector(31 downto 0);
            data_reg_in : in  std_logic_vector(31 downto 0);
            data_psd_in : in  std_logic_vector(31 downto 0);
            JumpSelect  : in  std_logic_vector(1 downto 0);
            data_out    : out std_logic_vector(31 downto 0));
end npc_mux;

architecture Structural of npc_mux is

begin

    with JumpSelect select

        data_out    <=  data_npc_in when "00",          -- Sequential
                        data_imm_in when "01",          -- Branch
                        data_reg_in when "10",          -- JR and JALR
                        data_psd_in when "11",          -- J  and JAL
                        (others => '-') when others;

end Structural;
