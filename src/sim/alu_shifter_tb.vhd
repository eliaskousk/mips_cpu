library ieee;
use ieee.std_logic_1164.all;

entity alu_shifter_tb is
end alu_shifter_tb;

architecture Behavioral of alu_shifter_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component alu_shifter
        port(left      : in  std_logic;
             logical   : in  std_logic;
             shift     : in  std_logic_vector(4 downto 0);
             shift_in  : in  std_logic_vector(31 downto 0);
             shift_out : out std_logic_vector(31 downto 0));
    end component alu_shifter;

    --Inputs
    signal left         : std_logic := '0';
    signal logical      : std_logic := '0';
    signal shift        : std_logic_vector(4 downto 0) := (others => '0');
    signal shift_in     : std_logic_vector(31 downto 0) := (others => '0');

    --Outputs
    signal shift_out    : std_logic_vector(31 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: alu_shifter
        port map(left      => left,
                 logical   => logical,
                 shift     => shift,
                 shift_in  => shift_in,
                 shift_out => shift_out);

    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 20 ns.
        wait for 20 ns;

        wait;
    end process;

end Behavioral;
