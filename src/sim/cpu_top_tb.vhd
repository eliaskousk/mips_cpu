library ieee;
use ieee.std_logic_1164.all;

entity cpu_top_tb is
end cpu_top_tb;

architecture Behavioral of cpu_top_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component cpu_top
        port(clk     : in  std_logic;
             rst     : in  std_logic;
             IR      : out std_logic_vector(31 downto 0);
             PC      : out std_logic_vector(31 downto 0);
             DMA     : out std_logic_vector(31 downto 0);
             DMD     : out std_logic_vector(31 downto 0);
             W       : out std_logic_vector(31 downto 0);
             ALUout  : out std_logic_vector(31 downto 0);
             MULTout : out std_logic_vector(63 downto 0);
             ZE      : out std_logic;
             NE      : out std_logic;
             OV      : out std_logic;
             ER      : out std_logic);
    end component cpu_top;

    --Inputs
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';

    --Outputs
    signal IR           : std_logic_vector(31 downto 0);
    signal PC           : std_logic_vector(31 downto 0);
    signal DMA          : std_logic_vector(31 downto 0);
    signal DMD          : std_logic_vector(31 downto 0);
    signal W            : std_logic_vector(31 downto 0);
    signal ALUout       : std_logic_vector(31 downto 0);
    signal MULTout      : std_logic_vector(63 downto 0);
    signal ZE           : std_logic;
    signal NE           : std_logic;
    signal OV           : std_logic;
    signal ER           : std_logic;

    -- Clock period definitions
    constant clk_period : time := 20 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: cpu_top
        port map(clk     => clk,
                 rst     => rst,
                 IR      => IR,
                 PC      => PC,
                 DMA     => DMA,
                 DMD     => DMD,
                 W       => W,
                 ALUout  => ALUout,
                 MULTout => MULTout,
                 ZE      => ZE,
                 NE      => NE,
                 OV      => OV,
                 ER      => ER);

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 100 ns.
        wait for 100 ns;

        rst <= '1';
        wait for clk_period * 2.5;
        rst <= '0';

        wait;
    end process;

end Behavioral;
