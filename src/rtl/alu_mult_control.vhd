library ieee;
use ieee.std_logic_1164.all;

entity alu_mult_control is
    port (
        clk             : in  std_logic;
        rst             : in  std_logic;
        start           : in  std_logic;
        bist_mode       : out std_logic_vector(1 downto 0);
        bist_start      : out std_logic_vector(2 downto 0);
        lfsr_seed_hi    : out std_logic_vector(31 downto 0);
        lfsr_seed_lo    : out std_logic_vector(31 downto 0));
end entity alu_mult_control;

architecture Behavioral of alu_mult_control is

    type state_type is (s0, s1, s2, s3);
    signal state, next_state : state_type;

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

    combinational : process (state, start)
    begin

        next_state <= state;

        case state is

                -- ==============
                -- COMMAND STATES
                -- ==============

                -- Normal operation
                when s0 =>      if start = '1' then
                                    next_state <= s1;
                                else
                                    next_state <= s0;
                                end if;

                -- LFSR
                when s1 =>      next_state <= s1;

                -- Counter
                when s2 =>      next_state <= s2;

                -- ATPG
                when s3 =>      next_state <= s3;

                --when others =>  next_state <= s0;

        end case;

    end process combinational;

    -- ============
    -- Output Logic
    -- ============

    bist_mode   <= "01" when state = s1 else "10" when state = s2 else "11" when state = s3 else "00";
    bist_start  <= "001" when state = s1 else "010" when state = s2 else "100" when state = s3 else "00";

    lfsr_seed_hi    <= (others => '0'); -- Insert LFSR HI seed here
    lfsr_seed_lo    <= (others => '0'); -- Insert LFSR LO seed here

end architecture Behavioral;
