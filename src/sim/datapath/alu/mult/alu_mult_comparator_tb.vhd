library ieee;
use ieee.std_logic_1164.all;

entity alu_mult_comparator_tb is
end alu_mult_comparator_tb;

architecture Behavioral of alu_mult_comparator_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component alu_mult_comparator
        port(clk        : in  std_logic;
             rst        : in  std_logic;
             bist_check : in  std_logic;
             bist_mode  : in  std_logic_vector(1 downto 0);
             data_in_hi : in  std_logic_vector(31 downto 0);
             data_in_lo : in  std_logic_vector(31 downto 0);
             result     : out std_logic);
    end component alu_mult_comparator;

    --Inputs
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    signal bist_check   : std_logic := '0';
    signal bist_mode    : std_logic_vector(1 downto 0)  := (others => '0');
    signal data_in_hi   : std_logic_vector(31 downto 0) := (others => '0');
    signal data_in_lo   : std_logic_vector(31 downto 0) := (others => '0');

    --Outputs
    signal result       : std_logic;

    -- Clock period definitions
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
   uut: alu_mult_comparator
       port map(clk        => clk,
                rst        => rst,
                bist_check => bist_check,
                bist_mode  => bist_mode,
                data_in_hi => data_in_hi,
                data_in_lo => data_in_lo,
                result     => result);

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

        rst <= '1';
        wait for clk_period * 3;
        rst <= '0';

        -- ========
        -- Disabled
        -- ========

        -- Check is enabled but in the standard mode the result
        -- should be always '0' regardless of the input signature
        data_in_hi <= X"AAAAAAAA";
        data_in_lo <= X"BBBBBBBB";
        bist_check <= '1';
        bist_mode  <= "00";
        wait for clk_period;

        -- Same if check is disabled, regardless of mode or signature
        data_in_hi <= X"AAAAAAAA";
        data_in_lo <= X"BBBBBBBB";
        bist_check <= '0';
        bist_mode  <= "00";
        wait for clk_period;

        -- ====
        -- LFSR
        -- ====

        -- Check LFSR signature with wrong signature
        data_in_hi <= X"33333333";
        data_in_lo <= X"44444444";
        bist_check <= '1';
        bist_mode  <= "01";
        wait for clk_period;

        -- Check LFSR signature with correct signature
        data_in_hi <= X"AAAAAAAA";
        data_in_lo <= X"BBBBBBBB";
        bist_check <= '1';
        bist_mode  <= "01";
        wait for clk_period;

        -- =======
        -- Counter
        -- =======

        -- Check Counter signature with wrong signature
        data_in_hi <= X"55555555";
        data_in_lo <= X"66666666";
        bist_check <= '1';
        bist_mode  <= "10";
        wait for clk_period;

        -- Check Counter signature with correct signature
        data_in_hi <= X"CCCCCCCC";
        data_in_lo <= X"DDDDDDDD";
        bist_check <= '1';
        bist_mode  <= "10";
        wait for clk_period;

        -- ====
        -- ATPG
        -- ====

        -- Check ATPG signature with wrong signature
        data_in_hi <= X"77777777";
        data_in_lo <= X"88888888";
        bist_check <= '1';
        bist_mode  <= "11";
        wait for clk_period;

        -- Check ATPG signature with correct signature
        data_in_hi <= X"EEEEEEEE";
        data_in_lo <= X"FFFFFFFF";
        bist_check <= '1';
        bist_mode  <= "11";
        wait for clk_period;

        wait;
    end process;

end Behavioral;
