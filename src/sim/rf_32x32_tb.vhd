library ieee;
use ieee.std_logic_1164.all;

entity rf_32x32_tb is
end rf_32x32_tb;

architecture Behavioral of rf_32x32_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component rf_32x32
        port(clk       : in  std_logic;
             RegWrite  : in  std_logic;
             RegImmNot : in  std_logic;
             rs        : in  std_logic_vector(4 downto 0);
             rt        : in  std_logic_vector(4 downto 0);
             rd        : in  std_logic_vector(4 downto 0);
             dataW_in  : in  std_logic_vector(31 downto 0);
             dataA_out : out std_logic_vector(31 downto 0);
             dataB_out : out std_logic_vector(31 downto 0));
    end component rf_32x32;

    --Inputs
    signal clk          : std_logic := '0';
    signal RegWrite     : std_logic := '0';
    signal RegImmNot    : std_logic := '0';
    signal rs           : std_logic_vector(4 downto 0) := (others => '0');
    signal rt           : std_logic_vector(4 downto 0) := (others => '0');
    signal rd           : std_logic_vector(4 downto 0) := (others => '0');
    signal dataW_in     : std_logic_vector(31 downto 0) := (others => '0');

    --Outputs
    signal dataA_out    : std_logic_vector(31 downto 0);
    signal dataB_out    : std_logic_vector(31 downto 0);

    -- Clock period definitions
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: rf_32x32
        port map(clk       => clk,
                 RegWrite  => RegWrite,
                 RegImmNot => RegImmNot,
                 rs        => rs,
                 rt        => rt,
                 rd        => rd,
                 dataW_in  => dataW_in,
                 dataA_out => dataA_out,
                 dataB_out => dataB_out);

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
        -- hold reset state for 20 ns.
        wait for 20 ns;

        

        wait;
    end process;

end Behavioral;
