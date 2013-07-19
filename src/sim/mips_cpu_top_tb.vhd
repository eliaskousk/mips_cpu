library ieee;
use ieee.std_logic_1164.all;

entity mips_cpu_top_tb is
end mips_cpu_top_tb;

architecture Behavioral of mips_cpu_top_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component mips_cpu_top
        generic(mult_pipe   : boolean := true);
        port(clk            : in  std_logic;
             rst            : in  std_logic;
             IR             : out std_logic_vector(31 downto 0);
             PC             : out std_logic_vector(31 downto 0);
             DMA            : out std_logic_vector(31 downto 0);
             DMD            : out std_logic_vector(31 downto 0);
             W              : out std_logic_vector(31 downto 0);
             ALU            : out std_logic_vector(31 downto 0);
             HI             : out std_logic_vector(31 downto 0);
             LO             : out std_logic_vector(31 downto 0);
             ZE             : out std_logic;
             NE             : out std_logic;
             OV             : out std_logic;
             ER             : out std_logic);
    end component mips_cpu_top;

    --Inputs
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';

    --Outputs
    signal IR           : std_logic_vector(31 downto 0);
    signal PC           : std_logic_vector(31 downto 0);
    signal DMA          : std_logic_vector(31 downto 0);
    signal DMD          : std_logic_vector(31 downto 0);
    signal W            : std_logic_vector(31 downto 0);
    signal ALU          : std_logic_vector(31 downto 0);
    signal HI           : std_logic_vector(31 downto 0);
    signal LO           : std_logic_vector(31 downto 0);
    signal ZE           : std_logic;
    signal NE           : std_logic;
    signal OV           : std_logic;
    signal ER           : std_logic;

    -- Clock period definitions
    constant clk_period : time := 20 ns;
    
    -- Set multiplier mode
    constant mult_pipe : boolean := true;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: mips_cpu_top
        generic map(mult_pipe => true)
        port map(clk          => clk,
                 rst          => rst,
                 IR           => IR,
                 PC           => PC,
                 DMA          => DMA,
                 DMD          => DMD,
                 W            => W,
                 ALU          => ALU,
                 HI           => HI,
                 LO           => LO,
                 ZE           => ZE,
                 NE           => NE,
                 OV           => OV,
                 ER           => ER);

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
