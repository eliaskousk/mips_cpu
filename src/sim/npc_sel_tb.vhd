library ieee;
use ieee.std_logic_1164.all;

entity npc_sel_tb is
end npc_sel_tb;

architecture Behavioral of npc_sel_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component npc_sel
        port(Jump       : in  std_logic;
             JumpPSD    : in  std_logic;
             BranchType : in  std_logic_vector(1 downto 0);
             NEorEQ     : in  std_logic;
             Zero       : in  std_logic;
             Negative   : in  std_logic;
             JumpSelect : out std_logic_vector(1 downto 0));
    end component npc_sel;

    --Inputs
    signal Jump         : std_logic := '0';
    signal JumpPSD      : std_logic := '0';
    signal BranchType   : std_logic_vector(1 downto 0) := (others => '0');
    signal NEorEQ       : std_logic := '0';
    signal Zero         : std_logic := '0';
    signal Negative     : std_logic := '0';

    --Outputs
    signal JumpSelect   : std_logic_vector(1 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: npc_sel
        port map(Jump       => Jump,
                 JumpPSD    => JumpPSD,
                 BranchType => BranchType,
                 NEorEQ     => NEorEQ,
                 Zero       => Zero,
                 Negative   => Negative,
                 JumpSelect => JumpSelect);

    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 100 ns.
        wait for 100 ns;

        wait;
    end process;

end Behavioral;
