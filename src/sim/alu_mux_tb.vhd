library ieee;
use ieee.std_logic_1164.all;

entity alu_mux_tb is
end alu_mux_tb;

architecture Behavioral of alu_mux_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component alu_mux
        port(data_regA_in : in  std_logic_vector(31 downto 0);
             data_regB_in : in  std_logic_vector(31 downto 0);
             data_imm_in  : in  std_logic_vector(31 downto 0);
             AluSelect    : in  std_logic;
             dataA_out    : out std_logic_vector(31 downto 0);
             dataB_out    : out std_logic_vector(31 downto 0));
    end component alu_mux;

    --Inputs
    signal data_regA_in : std_logic_vector(31 downto 0) := (others => '0');
    signal data_regB_in : std_logic_vector(31 downto 0) := (others => '0');
    signal data_imm_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal AluSelect    : std_logic := '0';

    --Outputs
    signal dataA_out    : std_logic_vector(31 downto 0);
    signal dataB_out    : std_logic_vector(31 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: alu_mux
        port map(data_regA_in => data_regA_in,
                 data_regB_in => data_regB_in,
                 data_imm_in  => data_imm_in,
                 AluSelect    => AluSelect,
                 dataA_out    => dataA_out,
                 dataB_out    => dataB_out);

    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 100 ns.
        wait for 100 ns;

        wait;
    end process;

end Behavioral;
