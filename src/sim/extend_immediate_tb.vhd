library ieee;
use ieee.std_logic_1164.all;

entity extend_immediate_tb is
end extend_immediate_tb;

architecture Behavioral of extend_immediate_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component extend_immediate
        port(data_in  : in  std_logic_vector(15 downto 0);
             SorZ     : in  std_logic;
             data_out : out std_logic_vector(31 downto 0));
    end component extend_immediate;

    --Inputs
    signal data_in  : std_logic_vector(15 downto 0) := (others => '0');
    signal SorZ     : std_logic := '0';

    --Outputs
    signal data_out : std_logic_vector(31 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: extend_immediate
        port map(data_in  => data_in,
                 SorZ     => SorZ,
                 data_out => data_out);

    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 100 ns.
        wait for 100 ns;

        wait;
    end process;

end Behavioral;
