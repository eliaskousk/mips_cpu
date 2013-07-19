library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_mult_unit is
	generic(mult_pipe   : boolean := true);
    port(   clk         : in std_logic;
            X           : in std_logic_vector(31 downto 0);
            Y           : in std_logic_vector(31 downto 0);
            P_HI        : out std_logic_vector(31 downto 0);
            P_LO        : out std_logic_vector(31 downto 0));
            
            attribute mult_style: string;
            attribute mult_style of alu_mult_unit: entity is "pipe_lut";
end alu_mult_unit;

architecture Structural of alu_mult_unit is

    signal X_signed     : signed(31 downto 0);
    signal X_signed_r1  : signed(31 downto 0);
    signal Y_signed     : signed(31 downto 0);
    signal Y_signed_r1  : signed(31 downto 0);
    signal P_signed     : signed(63 downto 0);
    signal P_signed_r1  : signed(63 downto 0);
    signal P_signed_r2  : signed(63 downto 0);
    signal P_signed_r3  : signed(63 downto 0);
    signal P_vector     : std_logic_vector(63 downto 0);

begin

    X_signed    <= signed(X);
    Y_signed    <= signed(Y);

    pipelined: if (mult_pipe = true) generate
    
        -- Pipelined multiplier (4 clock cycles latency)

        process(clk)
        begin
            if(clk'event and clk = '1') then
                X_signed_r1 <= X_signed;
                Y_signed_r1 <= Y_signed;
                P_signed_r1 <= X_signed * Y_signed;
                P_signed_r2 <= P_signed_r1;
                P_signed_r3 <= P_signed_r2;
                P_signed    <= P_signed_r3;
            end if;
        end process;

    end generate;
    
    normal: if(mult_pipe = false) generate

         -- Normal Multiplier (1 clock cycle latency)

         P_signed <= X_signed * Y_signed;

    end generate;
    
    -- Convert for output
    P_vector    <= std_logic_vector(P_signed);
    P_HI        <= P_vector(63 downto 32);
    P_LO        <= P_vector(31 downto 0);

end Structural;
