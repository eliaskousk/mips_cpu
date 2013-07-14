library ieee;
use ieee.std_logic_1164.all;

entity npc_mux_tb is
end npc_mux_tb;

architecture Behavioral of npc_mux_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component npc_mux
        port(data_npc_in : in  std_logic_vector(31 downto 0);
             data_imm_in : in  std_logic_vector(31 downto 0);
             data_reg_in : in  std_logic_vector(31 downto 0);
             data_psd_in : in  std_logic_vector(31 downto 0);
             JumpSelect  : in  std_logic_vector(1 downto 0);
             data_out    : out std_logic_vector(31 downto 0));
    end component npc_mux;

    --Inputs
    signal data_npc_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal data_imm_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal data_reg_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal data_psd_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal JumpSelect   : std_logic_vector(1 downto 0) := (others => '0');

    --Outputs
    signal data_out     : std_logic_vector(31 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: npc_mux
        port map(data_npc_in => data_npc_in,
                 data_imm_in => data_imm_in,
                 data_reg_in => data_reg_in,
                 data_psd_in => data_psd_in,
                 JumpSelect  => JumpSelect,
                 data_out    => data_out);

    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 20 ns.
        wait for 20 ns;

        data_npc_in <= X"AAAAAAAA";
        data_imm_in <= X"BBBBBBBB";
        data_reg_in <= X"CCCCCCCC";
        data_psd_in <= X"DDDDDDDD";

        JumpSelect  <= "00";
        wait for 20 ns;

        JumpSelect  <= "01";
        wait for 20 ns;

        JumpSelect  <= "10";
        wait for 20 ns;

        JumpSelect  <= "11";
        wait for 20 ns;

        wait;
    end process;

end Behavioral;
