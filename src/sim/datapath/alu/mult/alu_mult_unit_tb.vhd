library ieee;
use ieee.std_logic_1164.all;

entity alu_mult_unit_tb is
end alu_mult_unit_tb;

architecture Behavioral of alu_mult_unit_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component alu_mult_unit
    	generic(mult_pipe   : boolean := true);
        port(clk  : in  std_logic;
             X    : in  std_logic_vector(31 downto 0);
             Y    : in  std_logic_vector(31 downto 0);
             P_HI : out std_logic_vector(31 downto 0);
             P_LO : out std_logic_vector(31 downto 0));
    end component alu_mult_unit;


    --Inputs
    signal clk  : std_logic := '0';
    signal X    : std_logic_vector(31 downto 0) := (others => '0');
    signal Y    : std_logic_vector(31 downto 0) := (others => '0');

    --Outputs
    signal P_HI : std_logic_vector(31 downto 0);
    signal P_LO : std_logic_vector(31 downto 0);

        -- Clock period definitions
    constant clk_period : time := 20 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: alu_mult_unit
        generic map(mult_pipe => true)
        port map(   clk       => clk,
                    X         => X,
                    Y         => Y,
                    P_HI      => P_HI,
                    P_LO      => P_LO);

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

        X <= X"11111111";
        Y <= X"22222222";
        wait for clk_period * 10;

        wait;
    end process;

end;
