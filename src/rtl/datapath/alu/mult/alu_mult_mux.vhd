library ieee;
use ieee.std_logic_1164.all;

entity alu_mult_mux is
    port (
        clk                 : in std_logic;
        rst                 : in std_logic;
        mux_select          : in std_logic_vector(1 downto 0);
        data_in_normal_hi   : in std_logic_vector(31 downto 0);
        data_in_normal_lo   : in std_logic_vector(31 downto 0);
        data_in_lfsr_hi     : in std_logic_vector(31 downto 0);
        data_in_lfsr_lo     : in std_logic_vector(31 downto 0);
        data_in_counter_hi  : in std_logic_vector(31 downto 0);
        data_in_counter_lo  : in std_logic_vector(31 downto 0);
        data_in_atpg_hi     : in std_logic_vector(31 downto 0);
        data_in_atpg_lo     : in std_logic_vector(31 downto 0);
        data_mux_hi         : out std_logic_vector(31 downto 0);
        data_mux_lo         : out std_logic_vector(31 downto 0));
end entity alu_mult_mux;

architecture Behavioral of alu_mult_mux is

    signal hi : std_logic_vector(31 downto 0);
    signal lo : std_logic_vector(31 downto 0);

begin

    with mux_select select

        hi <=   data_in_normal_hi   when "00",          -- Normal operation
                data_in_lfsr_hi     when "01",          -- LFSR
                data_in_counter_hi  when "10",          -- Counter
                data_in_atpg_hi     when "11",          -- ATPG
                (others => '-')     when others;

    with mux_select select

        lo <=   data_in_normal_lo   when "00",          -- Normal operation
                data_in_lfsr_lo     when "01",          -- LFSR
                data_in_counter_lo  when "10",          -- Counter
                data_in_atpg_lo     when "11",          -- ATPG
                (others => '-')     when others;

    -- Register the selected HI and LO to reduce the critical path and improve cpu frequency
    -- MULT will now need 2 clock cycles to complete (control_fsm considers the extra clock cycle as WB stage
    -- or second cycle of EX where WB happens depending on which way you see it)

    process(clk, rst)
    begin

        if(rst = '1') then

            data_mux_hi <= (others => '0');
            data_mux_lo <= (others => '0');

        elsif(clk'event and clk = '1') then

            data_mux_hi <= hi;
            data_mux_lo <= lo;

        end if;

    end process;

end architecture Behavioral;
