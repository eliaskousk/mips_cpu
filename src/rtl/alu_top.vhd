library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_top is
    port(   clk         : in  std_logic;
            rst         : in  std_logic;
            sv          : in  std_logic;
            TestMult    : in  std_logic;
            MT          : in  std_logic;
            HIorLO      : in  std_logic;
            ALUop       : in  std_logic_vector(3 downto 0);
            shamt       : in  std_logic_vector(4 downto 0);
            Bus_A       : in  std_logic_vector(31 downto 0);
            Bus_B       : in  std_logic_vector(31 downto 0);
            Zero        : out std_logic;
            ov          : out std_logic;
            Fail        : out std_logic;
            Bus_S       : out std_logic_vector(31 downto 0);
            Bus_mult_HI : out std_logic_vector(31 downto 0);
            Bus_mult_LO : out std_logic_vector(31 downto 0));
end alu_top;

architecture Behavioral of alu_top is

    component alu_shifter is
        port(   left        : in  std_logic;
                logical     : in  std_logic;
                shift       : in  std_logic_vector(4 downto 0);
                shift_in    : in  std_logic_vector(31 downto 0);
                shift_out   : out std_logic_vector(31 downto 0));
    end component;

    component alu_mult_top is
        port(   clk         : in  std_logic;
                rst         : in  std_logic;
                bist_init   : in  std_logic;
                X           : in  std_logic_vector(31 downto 0);
                Y           : in  std_logic_vector(31 downto 0);
                P_HI        : out std_logic_vector(31 downto 0);
                P_LO        : out std_logic_vector(31 downto 0);
                bist_result : out std_logic);
    end component;

    signal tmp_result_hi    : std_logic_vector(31 downto 0);
    signal tmp_result_lo    : std_logic_vector(31 downto 0);
    signal L_out            : std_logic_vector(31 downto 0);
    signal A_out            : std_logic_vector(31 downto 0);
    signal Sh_out           : std_logic_vector(31 downto 0);
    signal SLT_out          : std_logic_vector(31 downto 0);
    signal output           : std_logic_vector(31 downto 0);
    signal shift            : std_logic_vector(4 downto 0);
    signal left             : std_logic;
    signal logical          : std_logic;

begin

    MULT : alu_mult_top
    port map(   clk         => clk,
                rst         => rst,
                bist_init   => TestMult,
                X           => Bus_A,
                Y           => Bus_B,
                P_HI        => tmp_result_hi,
                P_LO        => tmp_result_lo,
                bist_result => Fail);

    SHIFTER : alu_shifter
    port map(   left        => left,
                logical     => logical,
                shift       => shift,
                shift_in    => Bus_B,
                shift_out   => output);

    shift       <= Bus_A(4 downto 0) when (sv = '1') else shamt;
    Bus_mult_HI <= tmp_result_hi when (ALUop(1 downto 0) = "00" and MT = '0') else Bus_A when (MT = '1' and HIorLO = '1') else (others => 'Z');
    Bus_mult_LO <= tmp_result_lo when (ALUop(1 downto 0) = "00" and MT = '0') else Bus_A when (MT = '1' and HIorLO = '0') else (others => 'Z');
    Zero        <= '1' when (A_out = X"00000000") else '0';

    process(Bus_A, Bus_B, ALUop, output)
        variable tmp_add_sub: std_logic_vector(32 downto 0);
    begin

        ov      <= '0';
        SLT_out <= (others=>'X');
        A_out   <= (others=>'X');

        -- Shift
        left    <='0';
        logical <='1';

        case ALUop(1 downto 0) is

            when "00" =>

                tmp_add_sub := std_logic_vector(signed(Bus_A(31) & Bus_A) + signed(Bus_B(31) & Bus_B));

                Sh_out      <= output;
                A_out       <= tmp_add_sub(31 downto 0);
                L_out       <= Bus_A and Bus_B;

                left        <='1';
                ov          <= (Bus_A(31) and Bus_B(31) and (not A_out(31)))
                                or ((not Bus_A(31)) and (not Bus_B(31)) and A_out(31));

            --Truncate 2 MSBits
            when "01" =>

                tmp_add_sub := std_logic_vector(unsigned('0' & Bus_A) + unsigned('0' & Bus_B));

                Sh_out      <= (others=>'X');
                A_out       <= tmp_add_sub(31 downto 0);
                L_out       <= Bus_A or Bus_B;

                ov          <= tmp_add_sub(32);

            when "10" =>

                tmp_add_sub := std_logic_vector(signed(Bus_A(31) & Bus_A) - signed(Bus_B(31) & Bus_B));

                if((Bus_A(31) xor Bus_B(31)) = '1') then
                    SLT_out <= "000" & X"0000000" & Bus_A(31);
                else 
                    SLT_out <= "000" & X"0000000" & tmp_add_sub(31);
                end if;

                Sh_out      <= output;
                A_out       <= tmp_add_sub(31 downto 0);
                L_out       <= Bus_A xor Bus_B;

                ov          <= ((not Bus_A(31)) and Bus_B(31) and A_out(31))
                                or (Bus_A(31) and (not Bus_B(31)) and (not A_out(31)));

            when "11" =>

                tmp_add_sub := std_logic_vector(unsigned('0' & Bus_A) - unsigned('0' & Bus_B));

                Sh_out      <= output;
                SLT_out     <= "000" & X"0000000" & tmp_add_sub(32);
                A_out       <= tmp_add_sub(31 downto 0);
                L_out       <= Bus_A nor Bus_B;

                logical     <= '0';
                ov          <= tmp_add_sub(32);

            when others =>

                L_out       <= (others=>'X');

        end case;

    end process;

    process(Sh_out, SLT_out, A_out, L_out, ALUop(3 downto 2))
    begin
        -- Mux
        case ALUop(3 downto 2) is
            when "00"   =>  Bus_S <= Sh_out;    -- Shift
            when "01"   =>  Bus_S <= SLT_out;   -- SLT
            when "10"   =>  Bus_S <= A_out;     -- Arithmetic
            when "11"   =>  Bus_S <= L_out;     -- Logical
            when others =>  Bus_S <= A_out;
        end case;
    end process;

end Behavioral;
