library ieee;
use ieee.std_logic_1164.all;

entity alu_mult_unit_tb is
end alu_mult_unit_tb;

architecture Behavioral of alu_mult_unit_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component alu_mult_unit
        port(X    : in  std_logic_vector(31 downto 0);
             Y    : in  std_logic_vector(31 downto 0);
             P_HI : out std_logic_vector(31 downto 0);
             P_LO : out std_logic_vector(31 downto 0));
    end component alu_mult_unit;


    --Inputs
    signal X    : std_logic_vector(31 downto 0) := (others => '0');
    signal Y    : std_logic_vector(31 downto 0) := (others => '0');

    --Outputs
    signal P_HI : std_logic_vector(31 downto 0);
    signal P_LO : std_logic_vector(31 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: alu_mult_unit
        port map(X    => X,
                 Y    => Y,
                 P_HI => P_HI,
                 P_LO => P_LO);

   -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 100 ns.
        wait for 100 ns;

        -- insert stimulus here 

        wait;
    end process;

end;
