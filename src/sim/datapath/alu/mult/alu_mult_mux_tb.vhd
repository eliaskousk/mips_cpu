library ieee;
use ieee.std_logic_1164.all;

entity alu_mult_mux_tb is
end alu_mult_mux_tb;

architecture Behavioral of alu_mult_mux_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component alu_mult_mux
        port(mux_select         : in  std_logic_vector(1 downto 0);
             data_in_normal_hi  : in  std_logic_vector(31 downto 0);
             data_in_normal_lo  : in  std_logic_vector(31 downto 0);
             data_in_lfsr_hi    : in  std_logic_vector(31 downto 0);
             data_in_lfsr_lo    : in  std_logic_vector(31 downto 0);
             data_in_counter_hi : in  std_logic_vector(31 downto 0);
             data_in_counter_lo : in  std_logic_vector(31 downto 0);
             data_in_atpg_hi    : in  std_logic_vector(31 downto 0);
             data_in_atpg_lo    : in  std_logic_vector(31 downto 0);
             data_mux_hi        : out std_logic_vector(31 downto 0);
             data_mux_lo        : out std_logic_vector(31 downto 0));
    end component alu_mult_mux;

    --Inputs
    signal mux_select           : std_logic_vector(1 downto 0) := (others => '0');
    signal data_in_normal_hi    : std_logic_vector(31 downto 0) := (others => '0');
    signal data_in_normal_lo    : std_logic_vector(31 downto 0) := (others => '0');
    signal data_in_lfsr_hi      : std_logic_vector(31 downto 0) := (others => '0');
    signal data_in_lfsr_lo      : std_logic_vector(31 downto 0) := (others => '0');
    signal data_in_counter_hi   : std_logic_vector(31 downto 0) := (others => '0');
    signal data_in_counter_lo   : std_logic_vector(31 downto 0) := (others => '0');
    signal data_in_atpg_hi      : std_logic_vector(31 downto 0) := (others => '0');
    signal data_in_atpg_lo      : std_logic_vector(31 downto 0) := (others => '0');

    --Outputs
    signal data_mux_hi          : std_logic_vector(31 downto 0);
    signal data_mux_lo          : std_logic_vector(31 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: alu_mult_mux
        port map(mux_select         => mux_select,
                 data_in_normal_hi  => data_in_normal_hi,
                 data_in_normal_lo  => data_in_normal_lo,
                 data_in_lfsr_hi    => data_in_lfsr_hi,
                 data_in_lfsr_lo    => data_in_lfsr_lo,
                 data_in_counter_hi => data_in_counter_hi,
                 data_in_counter_lo => data_in_counter_lo,
                 data_in_atpg_hi    => data_in_atpg_hi,
                 data_in_atpg_lo    => data_in_atpg_lo,
                 data_mux_hi        => data_mux_hi,
                 data_mux_lo        => data_mux_lo);

    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 20 ns.
        wait for 20 ns;

        data_in_normal_hi  <= X"11111111";
        data_in_normal_lo  <= X"22222222";
        data_in_lfsr_hi    <= X"AAAAAAAA";
        data_in_lfsr_lo    <= X"BBBBBBBB";
        data_in_counter_hi <= X"CCCCCCCC";
        data_in_counter_lo <= X"DDDDDDDD";
        data_in_atpg_hi    <= X"EEEEEEEE";
        data_in_atpg_lo    <= X"FFFFFFFF";

        mux_select <= "00";
        wait for 20 ns;

        mux_select <= "01";
        wait for 20 ns;

        mux_select <= "10";
        wait for 20 ns;

        mux_select <= "11";
        wait for 20 ns;

        wait;
    end process;

end Behavioral;
