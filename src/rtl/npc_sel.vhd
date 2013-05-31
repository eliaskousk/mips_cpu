library ieee;
use ieee.std_logic_1164.all;

entity npc_sel is
    port(   Jump        : in  std_logic;
            JumpPSD     : in  std_logic;
            BranchType  : in  std_logic_vector(1 downto 0);
            NEorEQ      : in  std_logic;
            Zero        : in  std_logic;
            Negative    : in  std_logic;
            JumpSelect  : out std_logic_vector(1 downto 0));
end npc_sel;

architecture Behavioral of npc_sel is

    signal BranchSelect : std_logic;

begin

    process(BranchType)
    begin

        if(BranchType = "00") then
            BranchSelect <= '0';
        elsif(BranchType = "01") then
            BranchSelect <= Zero xor NEorEQ;
        elsif(BranchType = "10") then
            BranchSelect <= Zero xnor Negative;
        elsif(BranchType = "11") then
            BranchSelect <= Negative xor NEorEQ;
        end if;

    end process;
    
    JumpSelect(1) <= Jump;
    
    JumpSelect(0) <= BranchSelect when Jump = '0' else
                     JumpPSD when Jump = '1' else
                     '0';

end Behavioral;

-- OLD STUFF
--
--    JumpSelect <= Jump & ((Zero xor Negative) and Branch);

--    process(Jump, JumpPSD, BranchSelect)
--    begin
--
--        if(Jump = '0' and BranchSelect = '0') then
--            JumpSelect <= "00";                         -- Sequential
--        elsif(Jump = '0' and BranchSelect = '1') then
--            JumpSelect <= "01";                         -- Branch
--        elsif(Jump = '1' and JumpPSD = '0') then
--            JumpSelect <= "10";                         -- JR and JALR
--        elsif(Jump = '1' and JumpPSD = '1') then
--            JumpSelect <= "11";                         -- J  and JAL
--        else
--            JumpSelect <= "00";
--        end if;
--
--    end process;