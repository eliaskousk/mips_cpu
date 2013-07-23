library ieee;
use ieee.std_logic_1164.all;

entity mips_cpu_top is
    generic(mult_pipe   : boolean := true);
    port (  clk         : in  std_logic;
            rst            : in  std_logic;
            PC             : out std_logic_vector(31 downto 0);
            IR             : out std_logic_vector(31 downto 0);
            DMADDR         : out std_logic_vector(31 downto 0);
            DMWE           : out std_logic_vector(3 downto 0);
            DMREAD         : out std_logic_vector(31 downto 0);
            DMWRITE        : out std_logic_vector(31 downto 0);       
            DMERROR        : out std_logic;
            RFWRITE        : out std_logic_vector(31 downto 0);
            ALU            : out std_logic_vector(31 downto 0);
            HI             : out std_logic_vector(31 downto 0);
            LO             : out std_logic_vector(31 downto 0);
            ZERO           : out std_logic;
            NEGATIVE       : out std_logic;
            OVERFLOW       : out std_logic;
            BISTSTART      : out std_logic;
            BISTDONE       : out std_logic;
            BISTFAIL       : out std_logic);
end mips_cpu_top;

architecture Structural of mips_cpu_top is

    component im_bram_top is
        port(   clk         : in  std_logic;
                en          : in  std_logic;
                address     : in  std_logic_vector(10 downto 0);
                data_out    : out std_logic_vector(31 downto 0));
    end component;

    component dm_bram_top is
        port(   clk         : in  std_logic;
                en          : in  std_logic_vector(3 downto 0);
                we          : in  std_logic_vector(3 downto 0);
                ssr         : in  std_logic_vector(3 downto 0);
                address     : in  std_logic_vector(10 downto 0);
                data_in     : in  std_logic_vector(31 downto 0);
                data_out    : out std_logic_vector(31 downto 0));
    end component;

    component control_comb is
        generic(mult_pipe   : boolean := true);
        port(   clk         : in  std_logic;
                rst         : in  std_logic;
                OPCODE      : in  std_logic_vector(5 downto 0);
                FUNCT       : in  std_logic_vector(5 downto 0);
                RT          : in  std_logic_vector(4 downto 0);
                SorZ        : out std_logic;
                BorI        : out std_logic;
                ALUop       : out std_logic_vector(3 downto 0);
                sv          : out std_logic;
                MF          : out std_logic;
                MT          : out std_logic;
                HIorLO      : out std_logic;
                DMorALU     : out std_logic;
                DMWT        : out  std_logic_vector(2 downto 0);
                Link        : out std_logic;
                RorI        : out std_logic;
                BranchType  : out std_logic_vector(1 downto 0);
                NEorEQ      : out std_logic;
                RTZero      : out std_logic;
                Jump        : out std_logic;
                JumpPSD     : out std_logic;
                TestMult    : out std_logic);
    end component;

    component control_fsm is
        generic(mult_pipe   : boolean := true);
        port(   clk         : in  std_logic;
                rst         : in  std_logic;
                OPCODE      : in  std_logic_vector(5 downto 0);
                FUNCT       : in  std_logic_vector(5 downto 0);
                PC_write    : out std_logic;
                IR_write    : out std_logic;
                MAR_write   : out std_logic;
                DMD_read    : out std_logic;
                DMD_write   : out std_logic;
                RF_write    : out std_logic;
                HILO_write  : out std_logic);
    end component;

    component datapath_top is
        generic(mult_pipe       : boolean := true);
        port(   clk             : in  std_logic;
                rst             : in  std_logic;
                PC_write        : in  std_logic;
                RF_write        : in  std_logic;
                MAR_write       : in  std_logic;
                DMD_read        : in  std_logic;
                DMD_write       : in  std_logic;
                HILO_write      : in  std_logic;
                RorI            : in  std_logic;
                SorZ            : in  std_logic;
                BorI            : in  std_logic;
                sv              : in  std_logic;
                MF              : in  std_logic;
                MT              : in  std_logic;
                HIorLO          : in  std_logic;
                Jump            : in  std_logic;
                JumpPSD         : in  std_logic;
                BranchType      : in  std_logic_vector(1 downto 0);
                NEorEQ          : in  std_logic;
                RTZero          : in  std_logic;
                Link            : in  std_logic;
                DMorALU         : in  std_logic;
                DMWT            : in  std_logic_vector(2 downto 0);
                TestMult        : in  std_logic;
                ALUop           : in  std_logic_vector(3 downto 0);
                Bus_IRin        : in  std_logic_vector(31 downto 0);
                Bus_DMDin       : in std_logic_vector(31 downto 0);
                opcode          : out std_logic_vector(5 downto 0);
                funct           : out std_logic_vector(5 downto 0);
                rt              : out std_logic_vector(4 downto 0);
                Bus_FLAGSout    : out std_logic_vector(5 downto 0);
                Bus_PCout       : out std_logic_vector(31 downto 0);
                Bus_ALUout      : out std_logic_vector(31 downto 0);
                Bus_HIout       : out std_logic_vector(31 downto 0);
                Bus_LOout       : out std_logic_vector(31 downto 0);
                Bus_Wout        : out std_logic_vector(31 downto 0);
                Bus_DMWEout     : out std_logic_vector(3 downto 0);
                Bus_DMAout      : out std_logic_vector(31 downto 0);
                Bus_DMDout      : out std_logic_vector(31 downto 0));
    end component;

    signal PC_write     : std_logic;
    signal IR_write     : std_logic;
    signal RF_write     : std_logic;
    signal MAR_write    : std_logic;
    signal DMD_read     : std_logic;
    signal DMD_write    : std_logic;
    signal HILO_write   : std_logic;
    signal RorI         : std_logic;
    signal SorZ         : std_logic;
    signal BorI         : std_logic;
    signal sv           : std_logic;
    signal MF           : std_logic;
    signal MT           : std_logic;
    signal HIorLO       : std_logic;
    signal Jump         : std_logic;
    signal JumpPSD      : std_logic;
    signal BranchType   : std_logic_vector(1 downto 0);
    signal NEorEQ       : std_logic;
    signal RTZero       : std_logic;
    signal Link         : std_logic;
    signal DMorALU      : std_logic;
    signal DMWT         : std_logic_vector(2 downto 0);
    signal TestMult     : std_logic;

    signal ALUop        : std_logic_vector(3 downto 0);
    signal opcode       : std_logic_vector(5 downto 0);
    signal funct        : std_logic_vector(5 downto 0);
    signal rt           : std_logic_vector(4 downto 0);
    signal Bus_Flags    : std_logic_vector(5 downto 0);
    signal Bus_PCout    : std_logic_vector(31 downto 0);
    signal Bus_IRin     : std_logic_vector(31 downto 0);
    signal Bus_DMWE     : std_logic_vector(3 downto 0);
    signal Bus_DMA      : std_logic_vector(31 downto 0);
    signal Bus_DMDin    : std_logic_vector(31 downto 0);
    signal Bus_DMDout   : std_logic_vector(31 downto 0);
    signal Bus_Wout     : std_logic_vector(31 downto 0);
    
    signal dm_enable    : std_logic_vector(3 downto 0);

    begin

    dm_enable <=  (others => DMD_read or DMD_write);

    INSTMEM : im_bram_top
    port map(   clk         => clk,
                en          => IR_write,
                address     => Bus_PCout(12 downto 2),
                data_out    => Bus_IRin);

    DATAMEM : dm_bram_top
    port map(   clk         => clk,
                en          => dm_enable,
                we          => Bus_DMWE,
                ssr         => "0000",
                address     => Bus_DMA(12 downto 2),
                data_in     => Bus_DMDin,
                data_out    => Bus_DMDout);

    CONTROLCOMB : control_comb
    generic map(mult_pipe   => mult_pipe)
    port map(   clk         => clk,
                rst         => rst,
                OPCODE      => opcode,
                FUNCT       => funct,
                RT          => rt,
                SorZ        => SorZ,
                BorI        => BorI,
                ALUop       => ALUop,
                sv          => sv,
                MF          => MF,
                MT          => MT,
                HIorLO      => HIorLO,
                DMorALU     => DMorALU,
                DMWT        => DMWT,
                Link        => Link,
                RorI        => RorI,
                BranchType  => BranchType,
                NEorEQ      => NEorEQ,
                RTZero      => RTZero,
                Jump        => Jump,
                JumpPSD     => JumpPSD,
                TestMult    => TestMult);

    CONTROLFSM : control_fsm
    generic map(mult_pipe   => mult_pipe)
    port map(   clk         => clk,
                rst         => rst,
                OPCODE      => opcode,
                FUNCT       => funct,
                PC_write    => PC_write,
                IR_write    => IR_write,
                MAR_write   => MAR_write,
                DMD_read    => DMD_read,
                DMD_write   => DMD_write,
                RF_write    => RF_write,
                HILO_write  => HILO_write);

    DATAPATH : datapath_top
    generic map(mult_pipe       => mult_pipe)
    port map(   clk             => clk,
                rst             => rst,
                PC_write        => PC_write,
                RF_write        => RF_write,
                MAR_write       => MAR_write,
                DMD_read        => DMD_read,
                DMD_write       => DMD_write,
                HILO_write      => HILO_write,
                RorI            => RorI,
                SorZ            => SorZ,
                BorI            => BorI,
                sv              => sv,
                MF              => MF,
                MT              => MT,
                HIorLO          => HIorLO,
                Jump            => Jump,
                JumpPSD         => JumpPSD,
                BranchType      => BranchType,
                NEorEQ          => NEorEQ,
                RTZero          => RTZero,
                Link            => Link,
                DMorALU         => DMorALU,
                DMWT            => DMWT,
                ALUop           => ALUop,
                TestMult        => TestMult,
                Bus_IRin        => Bus_IRin,
                Bus_DMDin       => Bus_DMDout,
                opcode          => opcode,
                funct           => funct,
                rt              => rt,
                Bus_PCout       => Bus_PCout,
                Bus_ALUout      => ALU,
                Bus_HIout       => HI,
                Bus_LOout       => LO,
                Bus_FLAGSout    => Bus_Flags,
                Bus_Wout        => Bus_Wout,
                Bus_DMWEout     => Bus_DMWE,
                Bus_DMAout      => Bus_DMA,
                Bus_DMDout      => Bus_DMDin);

    -- Outputs

    PC          <= Bus_PCout;
    IR          <= Bus_IRin;
    DMADDR      <= Bus_DMA;
    DMWE        <= Bus_DMWE;
    DMREAD      <= Bus_DMDout;
    DMWRITE     <= Bus_DMDin;
    DMERROR     <= Bus_Flags(5);
    RFWRITE     <= Bus_Wout;
    ZERO        <= Bus_Flags(0);
    NEGATIVE    <= Bus_Flags(1);
    OVERFLOW    <= Bus_Flags(2);
    BISTSTART   <= TestMult;
    BISTDONE    <= Bus_Flags(3);
    BISTFAIL    <= Bus_Flags(4);

end Structural;
