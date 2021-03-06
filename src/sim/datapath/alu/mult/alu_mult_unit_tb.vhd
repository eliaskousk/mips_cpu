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
    constant mult_pipe  : boolean := true;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: alu_mult_unit
        generic map(mult_pipe => mult_pipe)
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
        wait for clk_period * 4;
        
        X <= X"22222222";
        Y <= X"33333333";
        wait for clk_period * 4;
        
        X <= X"33333333";
        Y <= X"44444444";
        wait for clk_period * 4;
        
        X <= X"44444444";
        Y <= X"55555555";
        wait for clk_period * 4;
        
        X <= X"55555555";
        Y <= X"66666666";
        wait for clk_period * 4;
        
        X <= X"77777777";
        Y <= X"88888888";
        wait for clk_period * 4;
        
        X <= X"88888888";
        Y <= X"99999999";
        wait for clk_period * 4;
        
        X <= X"99999999";
        Y <= X"AAAAAAAA";
        wait for clk_period * 4;

        wait;
    end process;

end;
