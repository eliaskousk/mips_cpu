library ieee;
use ieee.std_logic_1164.all;

entity alu_mult_control_tb is
end alu_mult_control_tb;

architecture Behavioral of alu_mult_control_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component alu_mult_control
        port(clk            : in  std_logic;
             rst            : in  std_logic;
             bist_init      : in  std_logic;
             bist_finish    : in  std_logic_vector(2 downto 0);
             bist_check     : out std_logic;
             bist_mode      : out std_logic_vector(1 downto 0);
             bist_enable    : out std_logic_vector(2 downto 0);
             lfsr_seed_hi   : out std_logic_vector(31 downto 0);
             lfsr_seed_lo   : out std_logic_vector(31 downto 0));
    end component alu_mult_control;

    --Inputs
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    signal bist_init    : std_logic := '0';
    signal bist_finish  : std_logic_vector(2 downto 0) := (others => '0');
    

    --Outputs
    signal bist_check   : std_logic;
    signal bist_mode    : std_logic_vector(1 downto 0);
    signal bist_enable  : std_logic_vector(2 downto 0);
    signal lfsr_seed_hi : std_logic_vector(31 downto 0);
    signal lfsr_seed_lo : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period  : time := 20 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)

    uut: alu_mult_control
        port map(clk          => clk,
                 rst          => rst,
                 bist_init    => bist_init,
                 bist_finish  => bist_finish,
                 bist_check   => bist_check,
                 bist_mode    => bist_mode,
                 bist_enable  => bist_enable,
                 lfsr_seed_hi => lfsr_seed_hi,
                 lfsr_seed_lo => lfsr_seed_lo);

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

        -- Should not start the tests
        bist_init <= '0';
        wait for clk_period * 3;

        -- Start the tests
        bist_init <= '1';

        bist_finish <= "000";
        wait for clk_period * 3;

        bist_finish <= "001";
        wait for clk_period * 3;
        
        bist_finish <= "011";
        wait for clk_period * 3;
        
        bist_finish <= "111";
        wait for clk_period * 3;

        wait;
    end process;

end Behavioral;
