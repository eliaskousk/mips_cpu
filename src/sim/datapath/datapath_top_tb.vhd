library ieee;
use ieee.std_logic_1164.all;

entity datapath_top_tb is
end datapath_top_tb;

architecture Behavioral of datapath_top_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component datapath_top
        generic(mult_pipe   : boolean := true);
        port(clk            : in  std_logic;
             rst            : in  std_logic;
             PC_write       : in  std_logic;
             RF_write       : in  std_logic;
             MAR_write      : in  std_logic;
             DMD_write      : in  std_logic;
             HI_write       : in  std_logic;
             LO_write       : in  std_logic;
             RorI           : in  std_logic;
             SorZ           : in  std_logic;
             BorI           : in  std_logic;
             sv             : in  std_logic;
             MF             : in  std_logic;
             MT             : in  std_logic;
             HIorLO         : in  std_logic;
             Jump           : in  std_logic;
             JumpPSD        : in  std_logic;
             BranchType     : in  std_logic_vector(1 downto 0);
             NEorEQ         : in  std_logic;
             Link           : in  std_logic;
             DMorALU        : in  std_logic;
             TestMult       : in  std_logic;
             ALUop          : in  std_logic_vector(3 downto 0);
             Bus_IRin       : in  std_logic_vector(31 downto 0);
             Bus_DMDin      : in  std_logic_vector(31 downto 0);
             opcode         : out std_logic_vector(5 downto 0);
             funct          : out std_logic_vector(5 downto 0);
             Bus_FLAGSout   : out std_logic_vector(4 downto 0);
             Bus_PCout      : out std_logic_vector(31 downto 0);
             Bus_ALUout     : out std_logic_vector(31 downto 0);
             Bus_HIout      : out std_logic_vector(31 downto 0);
             Bus_LOout      : out std_logic_vector(31 downto 0);
             Bus_Wout       : out std_logic_vector(31 downto 0);
             Bus_DMWEout    : out std_logic_vector(3 downto 0);
             Bus_DMAout     : out std_logic_vector(31 downto 0);
             Bus_DMDout     : out std_logic_vector(31 downto 0));
    end component datapath_top;

    --Inputs
    signal clk              : std_logic := '0';
    signal rst              : std_logic := '0';
    signal PC_write         : std_logic := '0';
    signal RF_write         : std_logic := '0';
    signal MAR_write        : std_logic := '0';
    signal DMD_write        : std_logic := '0';
    signal HI_write         : std_logic := '0';
    signal LO_write         : std_logic := '0';
    signal RorI             : std_logic := '0';
    signal SorZ             : std_logic := '0';
    signal BorI             : std_logic := '0';
    signal sv               : std_logic := '0';
    signal MF               : std_logic := '0';
    signal MT               : std_logic := '0';
    signal HIorLO           : std_logic := '0';
    signal Jump             : std_logic := '0';
    signal JumpPSD          : std_logic := '0';
    signal BranchType       : std_logic_vector(1 downto 0) := (others => '0');
    signal NEorEQ           : std_logic := '0';
    signal Link             : std_logic := '0';
    signal DMorALU          : std_logic := '0';
    signal TestMult         : std_logic := '0';
    signal ALUop            : std_logic_vector(3 downto 0) := (others => '0');
    signal Bus_IRin         : std_logic_vector(31 downto 0) := (others => '0');
    signal Bus_DMDin        : std_logic_vector(31 downto 0) := (others => '0');

    --Outputs
    signal opcode           : std_logic_vector(5 downto 0);
    signal funct            : std_logic_vector(5 downto 0);
    signal Bus_FLAGSout     : std_logic_vector(4 downto 0);
    signal Bus_PCout        : std_logic_vector(31 downto 0);
    signal Bus_ALUout       : std_logic_vector(31 downto 0);
    signal Bus_HIout        : std_logic_vector(31 downto 0);
    signal Bus_LOout        : std_logic_vector(31 downto 0);
    signal Bus_Wout         : std_logic_vector(31 downto 0);
    signal Bus_DMWEout      : std_logic_vector(3 downto 0);
    signal Bus_DMAout       : std_logic_vector(31 downto 0);
    signal Bus_DMDout       : std_logic_vector(31 downto 0);

    -- Clock period definitions
    constant clk_period     : time := 20 ns;
    constant mult_pipe      : boolean := true;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: datapath_top
        generic map(mult_pipe   => mult_pipe)
        port map(clk            => clk,
                 rst            => rst,
                 PC_write       => PC_write,
                 RF_write       => RF_write,
                 MAR_write      => MAR_write,
                 DMD_write      => DMD_write,
                 HI_write       => HI_write,
                 LO_write       => LO_write,
                 RorI           => RorI,
                 SorZ           => SorZ,
                 BorI           => BorI,
                 sv             => sv,
                 MF             => MF,
                 MT             => MT,
                 HIorLO         => HIorLO,
                 Jump           => Jump,
                 JumpPSD        => JumpPSD,
                 BranchType     => BranchType,
                 NEorEQ         => NEorEQ,
                 Link           => Link,
                 DMorALU        => DMorALU,
                 TestMult       => TestMult,
                 ALUop          => ALUop,
                 Bus_IRin       => Bus_IRin,
                 Bus_DMDin      => Bus_DMDin,
                 opcode         => opcode,
                 funct          => funct,
                 Bus_FLAGSout   => Bus_FLAGSout,
                 Bus_PCout      => Bus_PCout,
                 Bus_ALUout     => Bus_ALUout,
                 Bus_HIout      => Bus_HIout,
                 Bus_LOout      => Bus_LOout,
                 Bus_Wout       => Bus_Wout,
                 Bus_DMWEout    => Bus_DMWEout,
                 Bus_DMAout     => Bus_DMAout,
                 Bus_DMDout     => Bus_DMDout);

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '1';
        wait for clk_period/2;
        clk <= '0';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 20 ns.
        wait for 20 ns;

        rst <= '1';
        wait for clk_period * 3;
        rst <= '0';

        wait;
    end process;

end Behavioral;
