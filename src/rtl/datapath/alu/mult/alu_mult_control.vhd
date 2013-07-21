library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_mult_control is
    port (
        clk             : in  std_logic;
        rst             : in  std_logic;
        bist_init       : in  std_logic;
        bist_finish     : in  std_logic_vector(2 downto 0);
        bist_start      : out std_logic;
        bist_check      : out std_logic;
        bist_mode       : out std_logic_vector(1 downto 0);
        bist_enable     : out std_logic_vector(2 downto 0);
        lfsr_seed_hi    : out std_logic_vector(31 downto 0);
        lfsr_seed_lo    : out std_logic_vector(31 downto 0));
end entity alu_mult_control;

architecture Behavioral of alu_mult_control is

    type state_type is (s0, s1, s2, s3a, s3b, s4, s5, s6, s7);
    signal state, next_state : state_type;

    constant seed_hi : std_logic_vector(31 downto 0)    := X"01234567"; -- Insert LFSR HI seed here
    constant seed_lo : std_logic_vector(31 downto 0)    := X"89ABCDEF"; -- Insert LFSR LO seed here
    
    constant before_cycles_normal   : std_logic_vector(2 downto 0) := "100";
    constant before_cycles_atpg     : std_logic_vector(2 downto 0) := "101";
    constant after_cycles           : std_logic_vector(2 downto 0) := "011";

    signal bist_method      : std_logic_vector(1 downto 0);
    signal bist_active      : std_logic_vector(2 downto 0);
    signal bist_done        : std_logic;
    signal before_counter   : std_logic_vector(2 downto 0);
    signal after_counter    : std_logic_vector(2 downto 0);
    

begin

    -- =================================
    -- Registered process, updates state
    -- =================================

    registered: process (clk, rst)
    begin

        if(rst = '1') then

            state           <= s0;
            bist_done       <= '0';
            before_counter  <= (others => '0');
            after_counter   <= (others => '0');
            bist_method     <= (others => '0');
            bist_active     <= (others => '0');

        elsif(clk'event and clk = '1') then
        
            case state is
            
                when s1     =>      if(bist_method = "11") then
                                        bist_method <= (others => '0');
                                    else
                                        bist_method <= std_logic_vector(unsigned(bist_method) + 1);
                                    end if;
            
                when s2     =>      case bist_method is
                                        when "00" => bist_active <= "000";
                                        when "01" => bist_active <= "001";
                                        when "10" => bist_active <= "010";
                                        when "11" => bist_active <= "100";
                                        when others => bist_active <= "000";
                                    end case;
                
                when s3a    =>      if(before_counter = before_cycles_normal) then
                                        before_counter <= (others => '0');
                                    else
                                        before_counter <= std_logic_vector(unsigned(before_counter) + 1);
                                    end if;

                when s3b    =>      if(before_counter = before_cycles_atpg) then
                                        before_counter <= (others => '0');
                                    else
                                        before_counter <= std_logic_vector(unsigned(before_counter) + 1);
                                    end if;
            
                when s6     =>      if(after_counter = after_cycles) then
                                        after_counter <= (others => '0');
                                    else
                                        after_counter <= std_logic_vector(unsigned(after_counter) + 1);
                                    end if;

                when s7   =>        if(bist_method = "11") then
                                        bist_done <= '1';
                                    end if;

                when others => null;

            end case;

            bist_mode <= bist_method;

            state <= next_state;

        end if;

    end process registered;

    -- =====================================================================
    -- Combinational process, changes state based on current state and input
    -- =====================================================================

    combinational : process (state, bist_init, bist_finish, bist_method, bist_done, before_counter, after_counter)
    begin

        next_state <= state;

        case state is

                -- ==============
                -- COMMAND STATES
                -- ==============

                -- Normal operation
                when s0 =>      if bist_init = '1' and bist_done = '0' then
                                    next_state <= s1;
                                else
                                    next_state <= s0;
                                end if;

                -- BIST
                
                -- Main BIST loop for all 3 methods (LFSR, Counter, ATPG)
                when s1 =>      if(bist_done = '1') then
                                    next_state <= s0;
                                else
                                    next_state <= s2;
                                end if;

                -- Init BIST method
                when s2 =>      if(bist_method /= "11") then
                                    next_state <= s3a;
                                else
                                    next_state <= s3b;
                                end if;
        
                -- Wait for the first multiplier result
                when s3a =>      if(before_counter = before_cycles_normal) then
                                    next_state <= s4;
                                else
                                    next_state <= s3a;
                                end if;

                -- Wait for the first multiplier result
                when s3b =>      if(before_counter = before_cycles_atpg) then
                                    next_state <= s4;
                                else
                                    next_state <= s3b;
                                end if;

                -- Start BIST method
                when s4 =>      next_state <= s5;

                -- BIST method loop
                when s5 =>      if bist_finish /= "000" then
                                    next_state <= s6;
                                else
                                    next_state <= s5;
                                end if;

                -- Wait for the last MISR signature that captured up to the last multiplier result
                when s6 =>      if(after_counter = after_cycles) then
                                    next_state <= s7;
                                else
                                    next_state <= s6;
                                end if;

                -- Check signature and go to next method
                when s7 =>      next_state <= s1;

                -- Not needed because all states are covered
                --when others =>  next_state <= s0;

        end case;

    end process combinational;

    -- ============
    -- Output Logic
    -- ============

    bist_start  <= '1' when state = s4 else '0';
    bist_check  <= '1' when state = s7 else '0';
    bist_enable <= "000" when state = s0 else bist_active;

    lfsr_seed_hi    <= seed_hi;
    lfsr_seed_lo    <= seed_lo;

end architecture Behavioral;
