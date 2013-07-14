library ieee;
use ieee.std_logic_1164.all;

entity rf_32x32_tb is
end rf_32x32_tb;

architecture Behavioral of rf_32x32_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component rf_32x32
        port(clk       : in  std_logic;
             rst       : in  std_logic;
             RegWrite  : in  std_logic;
             RegImmNot : in  std_logic;
             RTZero    : in  std_logic;
             rs        : in  std_logic_vector(4 downto 0);
             rt        : in  std_logic_vector(4 downto 0);
             rd        : in  std_logic_vector(4 downto 0);
             dataW_in  : in  std_logic_vector(31 downto 0);
             dataA_out : out std_logic_vector(31 downto 0);
             dataB_out : out std_logic_vector(31 downto 0));
    end component rf_32x32;

    --Inputs
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    signal RegWrite     : std_logic := '0';
    signal RegImmNot    : std_logic := '0';
    signal RTZero       : std_logic := '0';
    signal rs           : std_logic_vector(4 downto 0) := (others => '0');
    signal rt           : std_logic_vector(4 downto 0) := (others => '0');
    signal rd           : std_logic_vector(4 downto 0) := (others => '0');
    signal dataW_in     : std_logic_vector(31 downto 0) := (others => '0');

    --Outputs
    signal dataA_out    : std_logic_vector(31 downto 0);
    signal dataB_out    : std_logic_vector(31 downto 0);

    -- Clock period definitions
    constant clk_period : time := 20 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: rf_32x32
        port map(clk       => clk,
                 rst       => rst,
                 RegWrite  => RegWrite,
                 RegImmNot => RegImmNot,
                 RTZero    => RTZero,
                 rs        => rs,
                 rt        => rt,
                 rd        => rd,
                 dataW_in  => dataW_in,
                 dataA_out => dataA_out,
                 dataB_out => dataB_out);

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

        -- Write and read all registers

        for i in 0 to 31 loop

            -- =====
            -- Setup
            -- =====

            -- Select read (rs, rt) and write (rd) registers
            rs          <= std_logic_vector(i, 5);
            rt          <= std_logic_vector(i + 1, 5);
            rd          <= std_logic_vector(i, 5);

            -- ===================================
            -- Try to write with RegWrite disabled
            -- ===================================

            wait until (clk'event and clk = '1');

            wait for clk_period / 6; -- The test patterns change after clock edge

            -- Write to rd register (default)
            RegImmNot   <= '1';

            -- Disable writes
            RegWrite    <= '0';

            -- Set write value (half 0, half 1)
            dataW_in    <= X"0000FFFF";

            -- ==========
            -- Write ones
            -- ==========

            wait until (clk'event and clk = '1');

            wait for clk_period / 6; -- The test patterns change after clock edge

            -- Write to rd register
            RegImmNot   <= '1';

            -- Enable writes
            RegWrite    <= '1';

            -- Set write value (all 1)
            dataW_in    <= X"FFFFFFFF";

            -- ============================
            -- Write register number (LSBs)
            -- ============================

            wait until (clk'event and clk = '1');

            wait for clk_period / 6; -- The test patterns change after clock edge

            -- Write to rd register
            RegImmNot               <= '1';

            -- Enable writes
            RegWrite                <= '1';

            -- Set write value in right halfword (the register's number)
            dataW_in(4 downto 0)    <= std_logic_vector(i, 5);
            dataW_in(31 downto 5)   <= (others => '0');

            -- ============================
            -- Write register number (MSBs)
            -- ============================

            wait until (clk'event and clk = '1');

            wait for clk_period / 6; -- The test patterns change after clock edge

            -- Write to rt instead of rd register
            RegImmNot               <= '0';

            -- Enable writes
            RegWrite                <= '1';

            -- Set write value in left halfword (the register's number)
            dataW_in(31 downto 24)  <= (others => '0');
            dataW_in(23 downto 16)  <= std_logic_vector(i, 5);
            dataW_in(15 downto 0)   <= (others => '0');

            -- =========
            -- Read only
            -- =========

            wait until (clk'event and clk = '1');

            wait for clk_period / 6; -- The test patterns change after clock edge

            -- Write to rd register
            RegImmNot   <= '1';

            -- Disable writes
            RegWrite    <= '0';

            dataW_in    <= (others => '-');

        end loop;

        wait;
    end process;

end Behavioral;
