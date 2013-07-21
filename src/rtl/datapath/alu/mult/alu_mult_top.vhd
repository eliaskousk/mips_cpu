library ieee;
use ieee.std_logic_1164.all;

entity alu_mult_top is
    generic(mult_pipe   : boolean := true);
    port(   clk         : in  std_logic;
            rst         : in  std_logic;
            bist_init   : in  std_logic;
            X           : in  std_logic_vector(31 downto 0);
            Y           : in  std_logic_vector(31 downto 0);
            P_HI        : out std_logic_vector(31 downto 0);
            P_LO        : out std_logic_vector(31 downto 0);
            bist_fail   : out std_logic);
end alu_mult_top;

architecture Structural of alu_mult_top is

    component alu_mult_control
        port(clk          : in  std_logic;
             rst          : in  std_logic;
             bist_init    : in  std_logic;
             bist_finish  : in  std_logic_vector(2 downto 0);
             bist_start   : out std_logic;
             bist_check   : out std_logic;
             bist_mode    : out std_logic_vector(1 downto 0);
             bist_enable  : out std_logic_vector(2 downto 0);
             lfsr_seed_hi : out std_logic_vector(31 downto 0);
             lfsr_seed_lo : out std_logic_vector(31 downto 0));
    end component alu_mult_control;

    component alu_mult_lfsr
        port(clk         : in  std_logic;
             rst         : in  std_logic;
             enable      : in  std_logic;
             finish      : out std_logic;
             seed_hi     : in  std_logic_vector(31 downto 0);
             seed_lo     : in  std_logic_vector(31 downto 0);
             data_out_hi : out std_logic_vector(31 downto 0);
             data_out_lo : out std_logic_vector(31 downto 0));
    end component alu_mult_lfsr;

    component alu_mult_counter
        port(clk         : in  std_logic;
             rst         : in  std_logic;
             enable      : in  std_logic;
             finish      : out std_logic;
             data_out_hi : out std_logic_vector(31 downto 0);
             data_out_lo : out std_logic_vector(31 downto 0));
    end component alu_mult_counter;

    component alu_mult_atpg
        port(clk         : in  std_logic;
             rst         : in  std_logic;
             enable      : in  std_logic;
             finish      : out std_logic;
             data_out_hi : out std_logic_vector(31 downto 0);
             data_out_lo : out std_logic_vector(31 downto 0));
    end component alu_mult_atpg;

    component alu_mult_mux
        port(
             clk                : in std_logic;
             rst                : in std_logic;
             mux_select         : in  std_logic_vector(1 downto 0);
             data_in_normal_hi  : in  std_logic_vector(31 downto 0);
             data_in_normal_lo  : in  std_logic_vector(31 downto 0);
             data_in_lfsr_hi    : in  std_logic_vector(31 downto 0);
             data_in_lfsr_lo    : in  std_logic_vector(31 downto 0);
             data_in_counter_hi : in  std_logic_vector(31 downto 0);
             data_in_counter_lo : in  std_logic_vector(31 downto 0);
             data_in_atpg_hi    : in  std_logic_vector(31 downto 0);
             data_in_atpg_lo    : in  std_logic_vector(31 downto 0);
             data_mux_hi        : out std_logic_vector(31 downto 0);
             data_mux_lo        : out std_logic_vector(31 downto 0));
    end component alu_mult_mux;

    component alu_mult_unit
        generic(mult_pipe   : boolean := true);
        port(   clk         : in std_logic;
                X           : in std_logic_vector(31 downto 0);
                Y           : in std_logic_vector(31 downto 0);
                P_HI        : out std_logic_vector(31 downto 0);
                P_LO        : out std_logic_vector(31 downto 0));
    end component alu_mult_unit;

    component alu_mult_misr
        port(clk          : in  std_logic;
             rst          : in  std_logic;
             data_in_hi   : in  std_logic_vector(31 downto 0);
             data_in_lo   : in  std_logic_vector(31 downto 0);
             signature_hi : out std_logic_vector(31 downto 0);
             signature_lo : out std_logic_vector(31 downto 0));
    end component alu_mult_misr;

    component alu_mult_comparator
        port(clk        : in  std_logic;
             rst        : in  std_logic;
             bist_check : in  std_logic;
             bist_mode  : in  std_logic_vector(1 downto 0);
             data_in_hi : in  std_logic_vector(31 downto 0);
             data_in_lo : in  std_logic_vector(31 downto 0);
             fail       : out std_logic);
    end component alu_mult_comparator;

    signal data_in_lfsr_hi      : std_logic_vector(31 downto 0);
    signal data_in_lfsr_lo      : std_logic_vector(31 downto 0);
    signal data_in_counter_hi   : std_logic_vector(31 downto 0);
    signal data_in_counter_lo   : std_logic_vector(31 downto 0);
    signal data_in_atpg_hi      : std_logic_vector(31 downto 0);
    signal data_in_atpg_lo      : std_logic_vector(31 downto 0);
    signal data_mux_hi          : std_logic_vector(31 downto 0);
    signal data_mux_lo          : std_logic_vector(31 downto 0);
    signal product_hi           : std_logic_vector(31 downto 0);
    signal product_lo           : std_logic_vector(31 downto 0);
    signal signature_hi         : std_logic_vector(31 downto 0);
    signal signature_lo         : std_logic_vector(31 downto 0);
    signal lfsr_seed_hi         : std_logic_vector(31 downto 0);
    signal lfsr_seed_lo         : std_logic_vector(31 downto 0);
    signal bist_finish          : std_logic_vector(2 downto 0);
    signal bist_enable          : std_logic_vector(2 downto 0);
    signal bist_mode            : std_logic_vector(1 downto 0);
    signal bist_check           : std_logic;
    signal bist_start           : std_logic;

begin

    MULT_CONTROL : alu_mult_control
        port map(clk          => clk,
                 rst          => rst,
                 bist_init    => bist_init,
                 bist_finish  => bist_finish,
                 bist_start   => bist_start,
                 bist_check   => bist_check,
                 bist_mode    => bist_mode,
                 bist_enable  => bist_enable,
                 lfsr_seed_hi => lfsr_seed_hi,
                 lfsr_seed_lo => lfsr_seed_lo);

    MULT_LFSR : alu_mult_lfsr
        port map(clk         => clk,
                 rst         => rst,
                 enable      => bist_enable(0),
                 finish      => bist_finish(0),
                 seed_hi     => lfsr_seed_hi,
                 seed_lo     => lfsr_seed_lo,
                 data_out_hi => data_in_lfsr_hi,
                 data_out_lo => data_in_lfsr_lo);

    MULT_COUNTER : alu_mult_counter
        port map(clk         => clk,
                 rst         => rst,
                 enable      => bist_enable(1),
                 finish      => bist_finish(1),
                 data_out_hi => data_in_counter_hi,
                 data_out_lo => data_in_counter_lo);

    MULT_ATPG : alu_mult_atpg
        port map(clk         => clk,
                 rst         => rst,
                 enable      => bist_enable(2),
                 finish      => bist_finish(2),
                 data_out_hi => data_in_atpg_hi,
                 data_out_lo => data_in_atpg_lo);

    MULT_MUX : alu_mult_mux
        port map(clk                => clk,
                 rst                => rst,
                 mux_select         => bist_mode,
                 data_in_normal_hi  => X,
                 data_in_normal_lo  => Y,
                 data_in_lfsr_hi    => data_in_lfsr_hi,
                 data_in_lfsr_lo    => data_in_lfsr_lo,
                 data_in_counter_hi => data_in_counter_hi,
                 data_in_counter_lo => data_in_counter_lo,
                 data_in_atpg_hi    => data_in_atpg_hi,
                 data_in_atpg_lo    => data_in_atpg_lo,
                 data_mux_hi        => data_mux_hi,
                 data_mux_lo        => data_mux_lo);

    MULT_UNIT : alu_mult_unit
        generic map(mult_pipe   => mult_pipe)
        port map(clk            => clk,
                 X              => data_mux_hi,
                 Y              => data_mux_lo,
                 P_HI           => product_hi,
                 P_LO           => product_lo);

    MULT_MISR : alu_mult_misr
        port map(clk          => clk,
                 rst          => bist_start,
                 data_in_hi   => product_hi,
                 data_in_lo   => product_lo,
                 signature_hi => signature_hi,
                 signature_lo => signature_lo);

    MULT_COMPARATOR : alu_mult_comparator
        port map(clk        => clk,
                 rst        => rst,
                 bist_check => bist_check,
                 bist_mode  => bist_mode,
                 data_in_hi => signature_hi,
                 data_in_lo => signature_lo,
                 fail       => bist_fail);

    P_HI        <= product_hi;
    P_LO        <= product_lo;

end Structural;
