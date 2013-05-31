library ieee;
use ieee.std_logic_1164.all;

entity alu_mult_top is
    port(   clk     : in  std_logic;
            rst     : in  std_logic;
            sel     : in  std_logic;
            seed    : in  std_logic_vector(63 downto 0);
            X       : in  std_logic_vector(31 downto 0);
            Y       : in  std_logic_vector(31 downto 0);
            P       : out std_logic_vector(63 downto 0);
            Fail    : out std_logic);
end alu_mult_top;

architecture Structural of alu_mult_top is

    component alu_mult_unit is
        port(   X   : in std_logic_vector(31 downto 0);
                Y   : in std_logic_vector(31 downto 0);
                P   : out std_logic_vector(63 downto 0));
    end component;

    component alu_mult_lfsr
        port(   clk         : in  std_logic;
                rst         : in  std_logic;
                seed        : in  std_logic_vector(63 downto 0);
                data_out    : out std_logic_vector(63 downto 0));
    end component;

    component alu_mult_misr
        port(   clk         : in  std_logic;
                rst         : in  std_logic;
                data_in     : in  std_logic_vector(63 downto 0);
                signature   : out std_logic_vector(63 downto 0));
    end component;

    signal lfsr_out     : std_logic_vector(63 downto 0);
    signal X_in         : std_logic_vector(31 downto 0);
    signal Y_in         : std_logic_vector(31 downto 0);
    signal P_out        : std_logic_vector(63 downto 0);

begin

    MULT_UNIT : alu_mult_unit
    port map(   X   => X_in,
                Y   => Y_in,
                P   => P_out);

    LFSR : alu_mult_lfsr
    port map(   clk         => clk,
                rst         => rst,
                seed        => seed,
                data_out    => lfsr_out);

    MISR : alu_mult_misr
    port map(   clk         => clk,
                rst         => rst,
                data_in     => P_out,
                signature   => open);

    with sel select
        X_in    <=      X                        when '0',
                        lfsr_out(63 downto 32)   when '1',
                        (others => '-')          when others;

    with sel select
        Y_in    <=      Y                        when '0',
                        lfsr_out(31 downto 0)    when '1',
                        (others => '-')          when others; 

    P       <= P_out;
    Fail    <= '0';

end Structural;
