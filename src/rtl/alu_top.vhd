library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity alu_top is
    port(   clk         : in  std_logic;
            rst         : in  std_logic;
            sv          : in  std_logic;
            TestMult    : in  std_logic;
            mult_mode   : in  std_logic;
            ALUop       : in  std_logic_vector(3 downto 0);
            shamt       : in  std_logic_vector(4 downto 0);
            Bus_A       : in  std_logic_vector(31 downto 0);
            Bus_B       : in  std_logic_vector(31 downto 0);
            Zero        : out std_logic;
            ov          : out std_logic;
            Bus_S       : out std_logic_vector(31 downto 0);
            Bus_mult    : out std_logic_vector(63 downto 0));
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
        port(   clk     : in  std_logic;
                rst     : in  std_logic;
                sel     : in  std_logic;
                seed    : in  std_logic_vector(63 downto 0);
                X       : in  std_logic_vector(31 downto 0);
                Y       : in  std_logic_vector(31 downto 0);
                P       : out std_logic_vector(63 downto 0);
                Fail    : out std_logic);
    end component;

    signal tmp_result: std_logic_vector(63 downto 0);
    signal L_out,A_out,Sh_out,SLT_out, output: std_logic_vector(31 downto 0);
    signal shift: std_logic_vector(4 downto 0);
    signal left,logical: std_logic;

begin

    MULT : alu_mult_top
    port map(   clk         => clk,
                rst         => rst,
                sel         => TestMult,
                seed        => X"0000000000000000",
                X           => Bus_A,
                Y           => Bus_B,
                P           => tmp_result,
                Fail        => open);

    SHIFTER : alu_shifter
    port map(   left        => left,
                logical     => logical,
                shift       => shift,
                shift_in    => Bus_B,
                shift_out   => output);

    shift <= Bus_A(4 downto 0) when (sv='1') else shamt;
    Bus_mult <= tmp_result when ( ALUop(1 downto 0)= "00") else (others=>'Z');
    Zero <= '1' when (A_out = X"00000000") else '0';

    process(Bus_A,Bus_B,ALUop,output)

        variable tmp_add_sub: std_logic_vector(32 downto 0);

    begin

        ov <= '0';
        SLT_out <= (others=>'X');
        A_out <= (others=>'X');

        -- Shift
        left <='0';
        logical <='1';

        case ALUop(1 downto 0) is
            when "00" =>
                L_out <= Bus_A and Bus_B;
                left <='1';
                Sh_out <= output;
                tmp_add_sub := (Bus_A(31) & Bus_A)+(Bus_B(31) & Bus_B);
                A_out <= tmp_add_sub(31 downto 0);
                ov <= (Bus_A(31) and Bus_B(31) and (not A_out(31))) or ((not Bus_A(31)) and (not Bus_B(31)) and A_out(31));
        ---Truncate 2 MSBits
            when "01" =>
                L_out <= Bus_A or Bus_B;
                Sh_out <= (others=>'X');
                tmp_add_sub := ('0' & Bus_A)+('0' & Bus_B);
                A_out <= tmp_add_sub(31 downto 0);
                ov <= tmp_add_sub(32);
            when "10" =>
                L_out <= Bus_A xor Bus_B;
                Sh_out <= output;
                tmp_add_sub := (Bus_A(31) & Bus_A) - (Bus_B(31) & Bus_B);
                A_out <= tmp_add_sub(31 downto 0);
                if((Bus_A(31) xor Bus_B(31)) = '1') then
                    SLT_out <= "000" & X"0000000" & Bus_A(31);
                else 
                    SLT_out <= "000" & X"0000000" & tmp_add_sub(31);
                end if;
                ov <= ((not Bus_A(31)) and Bus_B(31) and A_out(31)) or (Bus_A(31) and (not Bus_B(31)) and (not A_out(31)));
            when "11" =>
                L_out <= Bus_A nor Bus_B;
                logical <= '0';
                Sh_out <= output;
                tmp_add_sub := ('0' & Bus_A)-('0' & Bus_B);
                A_out <= tmp_add_sub(31 downto 0);
                SLT_out <= "000" & X"0000000" & tmp_add_sub(32);
                ov <= tmp_add_sub(32);
            when others =>
                    L_out <= (others=>'X');
        end case;

    end process;

    process(Sh_out,SLT_out,A_out,L_out,ALUop(3 downto 2))
    begin
    -- Mux
        case ALUop(3 downto 2) is
            -- Shift
            when "00" =>
                Bus_S <= Sh_out;
            -- SLT
            when "01" =>
                Bus_S <= SLT_out;
            -- Arithmetic
            when "10" =>
                Bus_S <= A_out;
            -- Logical
            when "11" =>
                Bus_S <= L_out;
            when others =>	 
                Bus_S <= A_out;
            end case;
    end process;

end Behavioral;
