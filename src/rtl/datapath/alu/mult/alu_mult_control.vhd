library ieee;
use ieee.std_logic_1164.all;

entity alu_mult_control is
    port (
        clk             : in  std_logic;
        rst             : in  std_logic;
        bist_init       : in  std_logic;
        bist_finish     : in  std_logic_vector(2 downto 0);
        bist_check      : out std_logic;
        bist_mode       : out std_logic_vector(1 downto 0);
        bist_enable     : out std_logic_vector(2 downto 0);
        lfsr_seed_hi    : out std_logic_vector(31 downto 0);
        lfsr_seed_lo    : out std_logic_vector(31 downto 0));
end entity alu_mult_control;

architecture Behavioral of alu_mult_control is

    type state_type is (s0, s1, s2, s3, s4, s5, s6);
    signal state, next_state : state_type;

    constant seed_hi : std_logic_vector(31 downto 0) := X"01234567"; -- Insert LFSR HI seed here
    constant seed_lo : std_logic_vector(31 downto 0) := X"89ABCDEF"; -- Insert LFSR LO seed here

begin

    -- =================================
    -- Registered process, updates state
    -- =================================

    registered: process (clk, rst)
    begin

        if(rst = '1') then
            state <= s0;
        elsif(clk'event and clk = '1') then
            state <= next_state;
        end if;

    end process registered;

    -- =====================================================================
    -- Combinational process, changes state based on current state and input
    -- =====================================================================

    combinational : process (state, bist_init, bist_finish)
    begin

        next_state <= state;

        case state is

                -- ==============
                -- COMMAND STATES
                -- ==============

                -- Normal operation
                when s0 =>      if bist_init = '1' and bist_finish /= "111" then
                                    next_state <= s1;
                                else
                                    next_state <= s0;
                                end if;

                -- LFSR
                when s1 =>      if bist_finish(0) = '0' then
                                    next_state <= s1;
                                else
                                    next_state <= s2;
                                end if;

                when s2 =>      next_state <= s3;

                -- Counter
                when s3 =>      if bist_finish(1) = '0' then
                                    next_state <= s3;
                                else
                                    next_state <= s4;
                                end if;

                when s4 =>      next_state <= s5;


                -- ATPG
                when s5 =>      if bist_finish(2) = '0' then
                                    next_state <= s5;
                                else
                                    next_state <= s6;
                                end if;

                when s6 =>      next_state <= s0;

                -- Not needed because all states are covered
                --when others =>  next_state <= s0;

        end case;

    end process combinational;

    -- ============
    -- Output Logic
    -- ============

    bist_check  <= '1' when state = s2 or state = s4 or state = s6 else '0';
    bist_mode   <= "01" when state = s1 or state = s2 else "10" when state = s3 or state = s4 else "11" when state = s5 or state = s6 else "00";
    bist_enable <= "001" when state = s1 else "010" when state = s3 else "100" when state = s5 else "000";

    lfsr_seed_hi    <= seed_hi;
    lfsr_seed_lo    <= seed_lo;

end architecture Behavioral;
