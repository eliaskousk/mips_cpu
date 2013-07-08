library ieee;
use ieee.std_logic_1164.all;

entity dm_control_tb is
end dm_control_tb;

architecture Behavioral of dm_control_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component dm_control
        port(data_mdr_in  : in  std_logic_vector(31 downto 0);
             data_mar_in  : in  std_logic_vector(31 downto 0);
             data_dmd_in  : in  std_logic_vector(31 downto 0);
             DMD_we       : in  std_logic;
             Error        : out std_logic_vector(0 downto 0);
             data_mdr_out : out std_logic_vector(31 downto 0);
             data_dma_out : out std_logic_vector(31 downto 0);
             data_we_out  : out std_logic_vector(3 downto 0);
             data_dmd_out : out std_logic_vector(31 downto 0));
    end component dm_control;

    --Inputs
    signal data_mdr_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal data_mar_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal data_dmd_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal DMD_we       : std_logic := '0';

    --Outputs
    signal Error        : std_logic_vector(0 downto 0);
    signal data_mdr_out : std_logic_vector(31 downto 0);
    signal data_dma_out : std_logic_vector(31 downto 0);
    signal data_we_out  : std_logic_vector(3 downto 0);
    signal data_dmd_out : std_logic_vector(31 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: dm_control
        port map(data_mdr_in  => data_mdr_in,
                 data_mar_in  => data_mar_in,
                 data_dmd_in  => data_dmd_in,
                 DMD_we       => DMD_we,
                 Error        => Error,
                 data_mdr_out => data_mdr_out,
                 data_dma_out => data_dma_out,
                 data_we_out  => data_we_out,
                 data_dmd_out => data_dmd_out);

    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 100 ns.
        wait for 100 ns;

        wait;
    end process;

end Behavioral;
