library ieee;
use ieee.std_logic_1164.all;

entity rf_mux_tb is
end rf_mux_tb;

architecture Behavioral of rf_mux_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component rf_mux
        port(data_alu_in : in  std_logic_vector(31 downto 0);
             data_dm_in  : in  std_logic_vector(31 downto 0);
             data_npc_in : in  std_logic_vector(31 downto 0);
             data_mlo_in : in  std_logic_vector(31 downto 0);
             data_mhi_in : in  std_logic_vector(31 downto 0);
             Link        : in  std_logic;
             DMorALU     : in  std_logic;
             MF          : in  std_logic;
             HIorLO      : in  std_logic;
             data_out    : out std_logic_vector(31 downto 0));
    end component rf_mux;

    --Inputs
    signal data_alu_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal data_dm_in   : std_logic_vector(31 downto 0) := (others => '0');
    signal data_npc_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal data_mlo_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal data_mhi_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal Link         : std_logic := '0';
    signal DMorALU      : std_logic := '0';
    signal MF           : std_logic := '0';
    signal HIorLO       : std_logic := '0';

    --Outputs
    signal data_out     : std_logic_vector(31 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: rf_mux
        port map(data_alu_in => data_alu_in,
                 data_dm_in  => data_dm_in,
                 data_npc_in => data_npc_in,
                 data_mlo_in => data_mlo_in,
                 data_mhi_in => data_mhi_in,
                 Link        => Link,
                 DMorALU     => DMorALU,
                 MF          => MF,
                 HIorLO      => HIorLO,
                 data_out    => data_out);

    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 100 ns.
        wait for 100 ns;

        wait;
    end process;

end Behavioral;
