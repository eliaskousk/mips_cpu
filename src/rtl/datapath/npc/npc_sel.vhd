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

    process(BranchType, Zero, NEorEQ, Negative)
    begin

        if(BranchType = "00") then              -- Sequential
            BranchSelect <= '0';
        elsif(BranchType = "01") then           -- BEQ, BNE
            BranchSelect <= Zero xor NEorEQ;
        elsif(BranchType = "10") then           -- BLEZ, BGTZ
            BranchSelect <= ((not NEorEQ) and (Zero or Negative)) or ((NEorEQ) and (Zero nor Negative));
        elsif(BranchType = "11") then           -- BLTZ, BGEZ
            BranchSelect <= Negative xor NEorEQ;
        end if;

    end process;
    
    JumpSelect(1) <= Jump;
    
    JumpSelect(0) <= BranchSelect when Jump = '0' else
                     JumpPSD when Jump = '1' else
                     '0';

end Behavioral;
