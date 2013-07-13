library ieee;
use ieee.std_logic_1164.all;

entity control_comb_tb is
end control_comb_tb;

architecture Behavioral of control_comb_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component control_comb
        port(OPCODE     : in  std_logic_vector(5 downto 0);
             FUNCT      : in  std_logic_vector(5 downto 0);
             SorZ       : out std_logic;
             BorI       : out std_logic;
             ALUop      : out std_logic_vector(3 downto 0);
             sv         : out std_logic;
             MF         : out std_logic;
             MT         : out std_logic;
             HIorLO     : out std_logic;
             DMorALU    : out std_logic;
             Link       : out std_logic;
             RorI       : out std_logic;
             BranchType : out std_logic_vector(1 downto 0);
             NEorEQ     : out std_logic;
             Jump       : out std_logic;
             JumpPSD    : out std_logic;
             TestMult   : out std_logic);
    end component control_comb;

    --Inputs
    signal OPCODE       : std_logic_vector(5 downto 0) := (others => '0');
    signal FUNCT        : std_logic_vector(5 downto 0) := (others => '0');

    --Outputs
    signal SorZ         : std_logic;
    signal BorI         : std_logic;
    signal ALUop        : std_logic_vector(3 downto 0);
    signal sv           : std_logic;
    signal MF           : std_logic;
    signal MT           : std_logic;
    signal HIorLO       : std_logic;
    signal DMorALU      : std_logic;
    signal Link         : std_logic;
    signal RorI         : std_logic;
    signal BranchType   : std_logic_vector(1 downto 0);
    signal NEorEQ       : std_logic;
    signal Jump         : std_logic;
    signal JumpPSD      : std_logic;
    signal TestMult     : std_logic;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: control_comb
        port map(OPCODE     => OPCODE,
                 FUNCT      => FUNCT,
                 SorZ       => SorZ,
                 BorI       => BorI,
                 ALUop      => ALUop,
                 sv         => sv,
                 MF         => MF,
                 MT         => MT,
                 HIorLO     => HIorLO,
                 DMorALU    => DMorALU,
                 Link       => Link,
                 RorI       => RorI,
                 BranchType => BranchType,
                 NEorEQ     => NEorEQ,
                 Jump       => Jump,
                 JumpPSD    => JumpPSD,
                 TestMult   => TestMult);

    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 20 ns.
        wait for 20 ns;

        -- SLL (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "000000";
        wait for 20 ns * 4;

        -- SRL (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "000010";
        
        -- Fill the rest (same as control_fsm)

        wait;
    end process;

end Behavioral;
