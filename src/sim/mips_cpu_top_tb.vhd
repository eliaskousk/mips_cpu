library ieee;
use ieee.std_logic_1164.all;

entity mips_cpu_top_tb is
end mips_cpu_top_tb;

architecture Behavioral of mips_cpu_top_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component mips_cpu_top
        port(clk            : in  std_logic;
             rst            : in  std_logic;
             PC             : out std_logic_vector(31 downto 0);
             IR             : out std_logic_vector(31 downto 0);
             DMADDR         : out std_logic_vector(31 downto 0);
             DMWE           : out std_logic_vector(3 downto 0);
             DMREAD         : out std_logic_vector(31 downto 0);
             DMWRITE        : out std_logic_vector(31 downto 0);       
             DMERROR        : out std_logic;
             RFWRITE        : out std_logic_vector(31 downto 0);
             ALU            : out std_logic_vector(31 downto 0);
             HI             : out std_logic_vector(31 downto 0);
             LO             : out std_logic_vector(31 downto 0);
             ZERO           : out std_logic;
             NEGATIVE       : out std_logic;
             OVERFLOW       : out std_logic;
             BISTSTART      : out std_logic;
             BISTDONE       : out std_logic;
             BISTFAIL       : out std_logic);
    end component mips_cpu_top;

    --Inputs
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';

    --Outputs
    signal PC           : std_logic_vector(31 downto 0);
    signal IR           : std_logic_vector(31 downto 0);
    signal DMADDR       : std_logic_vector(31 downto 0);
    signal DMWE         : std_logic_vector(3 downto 0);
    signal DMREAD       : std_logic_vector(31 downto 0);
    signal DMWRITE      : std_logic_vector(31 downto 0);
    signal DMERROR      : std_logic;
    signal RFWRITE      : std_logic_vector(31 downto 0);
    signal ALU          : std_logic_vector(31 downto 0);
    signal HI           : std_logic_vector(31 downto 0);
    signal LO           : std_logic_vector(31 downto 0);
    signal ZERO         : std_logic;
    signal NEGATIVE     : std_logic;
    signal OVERFLOW     : std_logic;
    signal BISTSTART    : std_logic;
    signal BISTDONE     : std_logic;
    signal BISTFAIL     : std_logic;

    -- Clock period definitions
    constant clk_period : time := 20 ns;
    
    -- Set multiplier mode
    constant mult_pipe : boolean := true;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: mips_cpu_top
        port map(clk          => clk,
                 rst          => rst,
                 PC           => PC,
                 IR           => IR,
                 DMADDR       => DMADDR,
                 DMREAD       => DMREAD,
                 DMWE         => DMWE,
                 DMWRITE      => DMWRITE,
                 DMERROR      => DMERROR,
                 RFWRITE      => RFWRITE,
                 ALU          => ALU,
                 HI           => HI,
                 LO           => LO,
                 ZERO         => ZERO,
                 NEGATIVE     => NEGATIVE,
                 OVERFLOW     => OVERFLOW,
                 BISTSTART    => BISTSTART,
                 BISTDONE     => BISTDONE,
                 BISTFAIL     => BISTFAIL);

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
