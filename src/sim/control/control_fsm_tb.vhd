library ieee;
use ieee.std_logic_1164.all;

entity control_fsm_tb is
end control_fsm_tb;

architecture Behavioral of control_fsm_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component control_fsm
        port(clk       : in  std_logic;
             rst       : in  std_logic;
             OPCODE    : in  std_logic_vector(5 downto 0);
             FUNCT     : in  std_logic_vector(5 downto 0);
             PC_write  : out std_logic;
             IR_write  : out std_logic;
             MAR_write : out std_logic;
             DMD_write : out std_logic;
             RF_write  : out std_logic);
    end component control_fsm;

    --Inputs
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    signal OPCODE       : std_logic_vector(5 downto 0) := (others => '0');
    signal FUNCT        : std_logic_vector(5 downto 0) := (others => '0');

    --Outputs
    signal PC_write     : std_logic;
    signal IR_write     : std_logic;
    signal MAR_write    : std_logic;
    signal DMD_write    : std_logic;
    signal RF_write     : std_logic;

    -- Clock period definitions
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: control_fsm
        port map(clk       => clk,
                 rst       => rst,
                 OPCODE    => OPCODE,
                 FUNCT     => FUNCT,
                 PC_write  => PC_write,
                 IR_write  => IR_write,
                 MAR_write => MAR_write,
                 DMD_write => DMD_write,
                 RF_write  => RF_write);

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

        rst <= '1';
        wait for clk_period * 2.5;
        rst <= '0';

        -- SLL (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "000000";
        wait for clk_period * 4;

        -- SRL (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "000010";

        -- Fill the rest

        wait;
    end process;

end Behavioral;
