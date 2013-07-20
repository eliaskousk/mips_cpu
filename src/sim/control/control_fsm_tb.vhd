library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_fsm_tb is
end control_fsm_tb;

architecture Behavioral of control_fsm_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component control_fsm
        generic(mult_pipe : boolean := true);
        port(clk          : in  std_logic;
             rst          : in  std_logic;
             OPCODE       : in  std_logic_vector(5 downto 0);
             FUNCT        : in  std_logic_vector(5 downto 0);
             PC_write     : out std_logic;
             IR_write     : out std_logic;
             MAR_write    : out std_logic;
             DMD_write    : out std_logic;
             RF_write     : out std_logic;
             HI_write     : out std_logic;
             LO_write     : out std_logic);
    end component control_fsm;

    --Inputs
    signal clk                  : std_logic := '0';
    signal rst                  : std_logic := '0';
    signal OPCODE               : std_logic_vector(5 downto 0) := (others => '0');
    signal FUNCT                : std_logic_vector(5 downto 0) := (others => '0');

    --Outputs
    signal PC_write             : std_logic;
    signal IR_write             : std_logic;
    signal MAR_write            : std_logic;
    signal DMD_write            : std_logic;
    signal RF_write             : std_logic;
    signal HI_write             : std_logic;
    signal LO_write             : std_logic;

    signal mult_cycles_total    : std_logic_vector(3 downto 0);

    -- Clock period definitions
    constant clk_period : time := 20 ns;
    constant mult_pipe  : boolean := true;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: control_fsm
        generic map(mult_pipe  => mult_pipe)
        port map(clk           => clk,
                 rst           => rst,
                 OPCODE        => OPCODE,
                 FUNCT         => FUNCT,
                 PC_write      => PC_write,
                 IR_write      => IR_write,
                 MAR_write     => MAR_write,
                 DMD_write     => DMD_write,
                 RF_write      => RF_write,
                 HI_write      => HI_write,
                 LO_write      => LO_write);

    -- Clock process definitions
    clk_process: process
    begin
        clk <= '1';
        wait for clk_period/2;
        clk <= '0';
        wait for clk_period/2;
    end process;

    mult_process: process
    begin
        if(mult_pipe = true) then
            mult_cycles_total <= "1000";
        else
            mult_cycles_total <= "0101";
        end if;
        
        wait;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 20 ns.
        wait for 20 ns;

        rst <= '1';
        wait for clk_period * 3;
        rst <= '0';

        -- BLTZ  (4 clock cycles)
        OPCODE  <= "000001";
        FUNCT   <= "000000";
        wait for clk_period * 4;

        -- J     (3 clock cycles)
        OPCODE  <= "000010";
        FUNCT   <= "000000";
        wait for clk_period * 3;

        -- JAL   (3 clock cycles)
        OPCODE  <= "000011";
        FUNCT   <= "000000";
        wait for clk_period * 3;

        -- BEQ   (4 clock cycles)
        OPCODE  <= "000100";
        FUNCT   <= "000000";
        wait for clk_period * 4;

        -- BNE   (4 clock cycles)
        OPCODE  <= "000101"; 
        FUNCT   <= "000000";
        wait for clk_period * 4;

        -- BLEZ  (4 clock cycles)
        OPCODE  <= "000110";
        FUNCT   <= "000000";
        wait for clk_period * 4;

        -- BLEZ  (4 clock cycles)
        OPCODE  <= "000111";
        FUNCT   <= "000000";
        wait for clk_period * 4;

        -- ADDI  (4 clock cycles)
        OPCODE  <= "001000";
        FUNCT   <= "000000";
        wait for clk_period * 4;

        -- ADDIU (4 clock cycles)
        OPCODE  <= "001001";
        FUNCT   <= "000000";
        wait for clk_period * 4;

        -- SLTI  (4 clock cycles)
        OPCODE  <= "001010";
        FUNCT   <= "000000";
        wait for clk_period * 4;

        -- SLTIU (4 clock cycles)
        OPCODE  <= "001011";
        FUNCT   <= "000000";
        wait for clk_period * 4;

        -- ANDI  (4 clock cycles)
        OPCODE  <= "001100";
        FUNCT   <= "000000";
        wait for clk_period * 4;

        -- ORI   (4 clock cycles)
        OPCODE  <= "001101";
        FUNCT   <= "000000";
        wait for clk_period * 4;

        -- XORI  (4 clock cycles)
        OPCODE  <= "001110";
        FUNCT   <= "000000";
        wait for clk_period * 4;

        -- LUI   (4 clock cycles)
        OPCODE  <= "001111";
        FUNCT   <= "000000";
        wait for clk_period * 4;

        -- LB    (5 clock cycles)
        OPCODE  <= "100000";
        FUNCT   <= "000000";
        wait for clk_period * 5;

        -- LH    (5 clock cycles)
        OPCODE  <= "100001";
        FUNCT   <= "000000";
        wait for clk_period * 5;

        -- LW    (5 clock cycles)
        OPCODE  <= "100011";
        FUNCT   <= "000000";
        wait for clk_period * 5;

        -- LBU   (5 clock cycles)
        OPCODE  <= "100100";
        FUNCT   <= "000000";
        wait for clk_period * 5;

        -- LHU   (5 clock cycles)
        OPCODE  <= "100101";
        FUNCT   <= "000000";
        wait for clk_period * 5;

        -- SB    (4 clock cycles)
        OPCODE  <= "101000";
        FUNCT   <= "000000";
        wait for clk_period * 4;

        -- SH    (4 clock cycles)
        OPCODE  <= "101001";
        FUNCT   <= "000000";
        wait for clk_period * 4;

        -- SW    (4 clock cycles)
        OPCODE  <= "101011";
        FUNCT   <= "000000";
        wait for clk_period * 4;

        -- TEST  (4 clock cycles)
        OPCODE  <= "110000";
        FUNCT   <= "000000";
        wait for clk_period * 4;

        -- SLL (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "000000";
        wait for clk_period * 4;

        -- SRL (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "000010";
        wait for clk_period * 4;

        -- SRA (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "000011";
        wait for clk_period * 4;

        -- SLLV (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "000100";
        wait for clk_period * 4;

        -- SRLV (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "000110";
        wait for clk_period * 4;

        -- SRAV (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "000111";
        wait for clk_period * 4;

        -- JR   (3 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "001000";
        wait for clk_period * 3;

        -- JALR (3 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "001001";
        wait for clk_period * 3;

        -- MFHI (2 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "010000";
        wait for clk_period * 2;

        -- MTHI (3 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "010001";
        wait for clk_period * 3;

        -- MFLO (2 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "010010";
        wait for clk_period * 2;

        -- MTLO (3 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "010011";
        wait for clk_period * 3;

        -- MULT (7 total cycles for pipelined or 4 for normal multiplier)
        OPCODE  <= "000000";
        FUNCT   <= "011000";
        wait for clk_period * to_integer(unsigned(mult_cycles_total));

        -- ADD  (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "100000";
        wait for clk_period * 4;

        -- ADDU (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "100001";
        wait for clk_period * 4; 

        -- SUB  (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "100010";
        wait for clk_period * 4;

        -- SUBU (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "100011";
        wait for clk_period * 4;

        -- AND  (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "100100";
        wait for clk_period * 4;

        -- OR   (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "100101";
        wait for clk_period * 4;

        -- XOR  (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "100110";
        wait for clk_period * 4;

        -- NOR  (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "100111";
        wait for clk_period * 4;

        -- SLT  (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "101010";
        wait for clk_period * 4;

        -- SLTU (4 clock cycles)
        OPCODE  <= "000000";
        FUNCT   <= "101011";
        wait for clk_period * 4;

        wait;
    end process;

end Behavioral;
