library ieee;
use ieee.std_logic_1164.all;

entity mips_cpu_top is
    port (  clk     : in  std_logic;
            rst     : in  std_logic;
            IR      : out std_logic_vector(31 downto 0);
            PC      : out std_logic_vector(31 downto 0);
            DMA     : out std_logic_vector(31 downto 0);
            DMD     : out std_logic_vector(31 downto 0);
            W       : out std_logic_vector(31 downto 0);
            ALU     : out std_logic_vector(31 downto 0);
            HI      : out std_logic_vector(31 downto 0);
            LO      : out std_logic_vector(31 downto 0);
            ZE      : out std_logic;
            NE      : out std_logic;
            OV      : out std_logic;
            FL      : out std_logic;
            ER      : out std_logic);
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
        port(   OPCODE      : in  std_logic_vector(5 downto 0);
                FUNCT       : in  std_logic_vector(5 downto 0);
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
        port(   clk         : in  std_logic;
                rst         : in  std_logic;
                OPCODE      : in  std_logic_vector(5 downto 0);
                FUNCT       : in  std_logic_vector(5 downto 0);
                PC_write    : out std_logic;
                IR_write    : out std_logic;
                MAR_write   : out std_logic;
                DMD_write   : out std_logic;
                RF_write    : out std_logic);
    end component;

    component datapath_top is
        port(   clk             : in  std_logic;
                rst             : in  std_logic;
                PC_write        : in  std_logic;
                RF_write        : in  std_logic;
                MAR_write       : in  std_logic;
                DMD_write       : in  std_logic;
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
                Bus_FLAGSout    : out std_logic_vector(4 downto 0);
                Bus_PCout       : out std_logic_vector(31 downto 0);
                Bus_ALUout      : out std_logic_vector(31 downto 0);
                Bus_MULTHIout   : out std_logic_vector(31 downto 0);
                Bus_MULTLOout   : out std_logic_vector(31 downto 0);
                Bus_Wout        : out std_logic_vector(31 downto 0);
                Bus_DMWEout     : out std_logic_vector(3 downto 0);
                Bus_DMAout      : out std_logic_vector(31 downto 0);
                Bus_DMDout      : out std_logic_vector(31 downto 0));
    end component;

    signal PC_write     : std_logic;
    signal IR_write     : std_logic;
    signal RF_write     : std_logic;
    signal MAR_write    : std_logic;
    signal DMD_write    : std_logic;
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
    signal Bus_Flags    : std_logic_vector(4 downto 0);
    signal Bus_PCout    : std_logic_vector(31 downto 0);
    signal Bus_IRin     : std_logic_vector(31 downto 0);
    signal Bus_DMWE     : std_logic_vector(3 downto 0);
    signal Bus_DMA      : std_logic_vector(31 downto 0);
    signal Bus_DMDin    : std_logic_vector(31 downto 0);
    signal Bus_DMDout   : std_logic_vector(31 downto 0);

    begin

    INSTMEM : im_bram_top
    port map(   clk         => clk,
                en          => IR_write,
                address     => Bus_PCout(12 downto 2),
                data_out    => Bus_IRin);

    DATAMEM : dm_bram_top
    port map(   clk         => clk,
                en          => "1111",
                we          => Bus_DMWE,
                ssr         => "0000",
                address     => Bus_DMA(12 downto 2),
                data_in     => Bus_DMDin,
                data_out    => Bus_DMDout);

    CONTROLCOMB : control_comb
    port map(   OPCODE      => opcode,
                FUNCT       => funct,
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
    port map(   clk         => clk,
                rst         => rst,
                OPCODE      => opcode,
                FUNCT       => funct,
                PC_write    => PC_write,
                IR_write    => IR_write,
                MAR_write   => MAR_write,
                DMD_write   => DMD_write,
                RF_write    => RF_write);

    DATAPATH : datapath_top
    port map(   clk             => clk,
                rst             => rst,
                PC_write        => PC_write,
                RF_write        => RF_write,
                MAR_write       => MAR_write,
                DMD_write       => DMD_write,
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
                Bus_PCout       => Bus_PCout,
                Bus_ALUout      => ALU,
                Bus_MULTHIout   => HI,
                Bus_MULTLOout   => LO,
                Bus_FLAGSout    => Bus_Flags,
                Bus_Wout        => W,
                Bus_DMWEout     => Bus_DMWE,
                Bus_DMAout      => Bus_DMA,
                Bus_DMDout      => Bus_DMDin);

    IR      <= Bus_IRin;
    PC      <= Bus_PCout;
    DMA     <= Bus_DMA;
    DMD     <= Bus_DMDout;
    ZE      <= Bus_Flags(0);
    NE      <= Bus_Flags(1);
    OV      <= Bus_Flags(2);
    FL      <= Bus_Flags(3);
    ER      <= Bus_Flags(4);

end Structural;
