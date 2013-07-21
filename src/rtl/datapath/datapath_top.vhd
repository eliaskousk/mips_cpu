library ieee;
use ieee.std_logic_1164.all;

entity datapath_top is
    generic(mult_pipe       : boolean := true);
    port(   clk             : in  std_logic;
            rst             : in  std_logic;
            PC_write        : in  std_logic;
            RF_write        : in  std_logic;
            MAR_write       : in  std_logic;
            DMD_read        : in  std_logic;
            DMD_write       : in  std_logic;
            HI_write        : in  std_logic;
            LO_write        : in  std_logic;
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
            Bus_FLAGSout    : out std_logic_vector(4 downto 0);
            Bus_PCout       : out std_logic_vector(31 downto 0);
            Bus_ALUout      : out std_logic_vector(31 downto 0);
            Bus_HIout       : out std_logic_vector(31 downto 0);
            Bus_LOout       : out std_logic_vector(31 downto 0);
            Bus_Wout        : out std_logic_vector(31 downto 0);
            Bus_DMWEout     : out std_logic_vector(3 downto 0);
            Bus_DMAout      : out std_logic_vector(31 downto 0);
            Bus_DMDout      : out std_logic_vector(31 downto 0));
end datapath_top;

architecture Structural of datapath_top is

    component reg_we is
        generic(    W       : integer := 32);
        port(   clk         : in  std_logic;
                rst         : in  std_logic;
                we          : in  std_logic;
                data_in     : in  std_logic_vector(W - 1 downto 0);
                data_out    : out std_logic_vector(W - 1 downto 0));
    end component;

    component reg is
        generic ( W         : integer := 32);
        port(   clk         : in  std_logic;
                rst         : in  std_logic;
                data_in     : in  std_logic_vector(W - 1 downto 0);
                data_out    : out std_logic_vector(W - 1 downto 0));
    end component;

    component rf_32x32 is
        port(   clk         : in  std_logic;
                rst         : in  std_logic;
                RegWrite    : in  std_logic;
                RegImmNot   : in  std_logic;
                RTZero      : in  std_logic;
                rs          : in  std_logic_vector(4 downto 0);
                rt          : in  std_logic_vector(4 downto 0);
                rd          : in  std_logic_vector(4 downto 0);
                dataW_in    : in  std_logic_vector(31 downto 0);
                dataA_out   : out std_logic_vector(31 downto 0);
                dataB_out   : out std_logic_vector(31 downto 0));
    end component;

    component rf_mux is
        port(   data_alu_in : in  std_logic_vector(31 downto 0);
                data_dm_in  : in  std_logic_vector(31 downto 0);
                data_npc_in : in  std_logic_vector(31 downto 0);
                data_mlo_in : in  std_logic_vector(31 downto 0);
                data_mhi_in : in  std_logic_vector(31 downto 0);
                Link        : in  std_logic;
                DMorALU     : in  std_logic;
                MF          : in  std_logic;
                HIorLO      : in  std_logic;
                data_out    : out std_logic_vector(31 downto 0));
    end component;

    component extend_immediate is
        port(   data_in     : in  std_logic_vector(15 downto 0);
                SorZ        : in  std_logic;
                data_out    : out std_logic_vector(31 downto 0));
    end component;

    component npc_adder is
        port(   dataA_in    : in  std_logic_vector(31 downto 0);
                dataB_in    : in  std_logic_vector(31 downto 0);
                data_out    : out std_logic_vector(31 downto 0));
    end component;

    component npc_inc is
        port(   data_in     : in  std_logic_vector(31 downto 0);
                data_out    : out std_logic_vector(31 downto 0));
    end component;

    component npc_sel is
        port(   Jump        : in  std_logic;
                JumpPSD     : in  std_logic;
                BranchType  : in  std_logic_vector(1 downto 0);
                NEorEQ      : in  std_logic;
                Zero        : in  std_logic;
                Negative    : in  std_logic;
                JumpSelect  : out std_logic_vector(1 downto 0));
    end component;

    component npc_mux is
        port(   data_npc_in : in  std_logic_vector(31 downto 0);
                data_imm_in : in  std_logic_vector(31 downto 0);
                data_reg_in : in  std_logic_vector(31 downto 0);
                data_psd_in : in  std_logic_vector(31 downto 0);
                JumpSelect  : in  std_logic_vector(1 downto 0);
                data_out    : out std_logic_vector(31 downto 0));
    end component;

    component npc_psd is
        port(   dataP_in    : in  std_logic_vector(3 downto 0);
                dataA_in    : in  std_logic_vector(25 downto 0);
                data_out    : out std_logic_vector(31 downto 0));
    end component;

    component npc_sl2 is
        port(   data_in     : in  std_logic_vector(31 downto 0);
                data_out    : out std_logic_vector(31 downto 0));
    end component;

    component alu_top is
        generic(mult_pipe   : boolean := true);
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
                bist_fail   : out std_logic;
                Bus_S       : out std_logic_vector(31 downto 0);
                Bus_mult_HI : out std_logic_vector(31 downto 0);
                Bus_mult_LO : out std_logic_vector(31 downto 0));
    end component;

    component alu_mux is
        port(   clk             : in std_logic;
                rst             : in std_logic;
                data_regA_in    : in  std_logic_vector(31 downto 0);
                data_regB_in    : in  std_logic_vector(31 downto 0);
                data_imm_in     : in  std_logic_vector(31 downto 0);
                AluSelect       : in  std_logic;
                dataA_out       : out std_logic_vector(31 downto 0);
                dataB_out       : out std_logic_vector(31 downto 0));
    end component;

    component dm_control is
        port(   data_mdr_in     : in  std_logic_vector(31 downto 0);
                data_mar_in     : in  std_logic_vector(31 downto 0);
                data_dmd_in     : in  std_logic_vector(31 downto 0);
                DMWT            : in  std_logic_vector(2 downto 0);
                DMD_we          : in  std_logic;
                Error           : out std_logic_vector(0 downto 0);
                data_mdr_out    : out std_logic_vector(31 downto 0);
                data_dma_out    : out std_logic_vector(31 downto 0);
                data_we_out     : out std_logic_vector(3 downto 0);
                data_dmd_out    : out std_logic_vector(31 downto 0));
    end component;

    signal Bus_PC       : std_logic_vector(31 downto 0);
    signal Bus_INC      : std_logic_vector(31 downto 0);
    signal Bus_NPC      : std_logic_vector(31 downto 0);
    signal Bus_P        : std_logic_vector(3 downto 0);
    signal Bus_PSD      : std_logic_vector(31 downto 0);
    signal Bus_D        : std_logic_vector(31 downto 0);
    signal Bus_SL2      : std_logic_vector(31 downto 0);
    signal Bus_ADD      : std_logic_vector(31 downto 0);
    signal Bus_M        : std_logic_vector(31 downto 0);
    signal Bus_NPCSEL   : std_logic_vector(1 downto 0);
    signal Bus_NPCMUX   : std_logic_vector(31 downto 0);

    signal Bus_W        : std_logic_vector(31 downto 0);
    signal Bus_RA       : std_logic_vector(31 downto 0);
    signal Bus_RB       : std_logic_vector(31 downto 0);
    signal Bus_A        : std_logic_vector(31 downto 0);
    signal Bus_B        : std_logic_vector(31 downto 0);
    signal Bus_I        : std_logic_vector(31 downto 0);
    signal Bus_EXT      : std_logic_vector(31 downto 0);

    signal Bus_ALUMUXA  : std_logic_vector(31 downto 0);
    signal Bus_ALUMUXB  : std_logic_vector(31 downto 0);
    signal Bus_ALU      : std_logic_vector(31 downto 0);
    signal Bus_MULTHI   : std_logic_vector(31 downto 0);
    signal Bus_MULTLO   : std_logic_vector(31 downto 0);
    signal Bus_ALUFLAGS : std_logic_vector(3 downto 0);
    signal Bus_FLAGS    : std_logic_vector(3 downto 0);
    signal Zero         : std_logic;
    signal Overflow     : std_logic;
    signal bist_fail    : std_logic;

    signal Bus_ALUO     : std_logic_vector(31 downto 0);
    signal Bus_HI       : std_logic_vector(31 downto 0);
    signal Bus_LO       : std_logic_vector(31 downto 0);

    signal Error        : std_logic_vector(0 downto 0);
    signal FlagE        : std_logic_vector(0 downto 0);
    signal Bus_MDRI     : std_logic_vector(31 downto 0);
    signal Bus_MDRO     : std_logic_vector(31 downto 0);
    signal Bus_MAR      : std_logic_vector(31 downto 0);
    signal Bus_SHAMT    : std_logic_vector(4 downto 0);

begin

    opcode          <= Bus_IRin(31 downto 26);
    funct           <= Bus_IRin(5 downto 0);
    rt              <= BUS_IRin(20 downto 16);
    Bus_FLAGSout    <= FlagE(0) & Bus_FLAGS;
    Bus_PCout       <= Bus_PC;
    Bus_ALUout      <= Bus_ALU;
    Bus_HIout   <= Bus_HI;
    Bus_LOout   <= Bus_LO;
    Bus_Wout        <= Bus_W;

    Bus_ALUFLAGS    <= bist_fail & Overflow & Bus_ALU(31) & Zero;

    PC : reg_we
    port map(   clk         => clk,
                rst         => rst,
                we          => PC_write,
                data_in     => Bus_NPCMUX,
                data_out    => Bus_PC);

    NPC : reg
    port map(   clk         => clk,
                rst         => rst,
                data_in     => Bus_INC,
                data_out    => Bus_NPC);

    P : reg
    generic map(    W       => 4)
    port map(   clk         => clk,
                rst         => rst,
                data_in     => Bus_PC(31 downto 28),
                data_out    => Bus_P);

    D : reg
    port map(   clk         => clk,
                rst         => rst,
                data_in     => Bus_PSD,
                data_out    => Bus_D);

    A : reg
    port map(   clk         => clk,
                rst         => rst,
                data_in     => Bus_RA,
                data_out    => Bus_A);

    B : reg
    port map(   clk         => clk,
                rst         => rst,
                data_in     => Bus_RB,
                data_out    => Bus_B);

    I : reg
    port map(   clk         => clk,
                rst         => rst,
                data_in     => Bus_EXT,
                data_out    => Bus_I);

    M : reg
    port map(   clk         => clk,
                rst         => rst,
                data_in     => Bus_ADD,
                data_out    => Bus_M);

    S : reg
    generic map( W          => 5)
    port map(   clk         => clk,
                rst         => rst,
                data_in     => Bus_IRin(10 downto 6),
                data_out    => Bus_SHAMT);

    ALUOUT : reg
    port map(   clk         => clk,
                rst         => rst,
                data_in     => Bus_ALU,
                data_out    => Bus_ALUO);

    HI : reg_we
    port map(   clk         => clk,
                rst         => rst,
                we          => HI_write,
                data_in     => Bus_MULTHI,
                data_out    => Bus_HI);

    LO : reg_we
    port map(   clk         => clk,
                rst         => rst,
                we          => LO_write,
                data_in     => Bus_MULTLO,
                data_out    => Bus_LO);

    FLAGS : reg
    generic map(    W       => 4)
    port map(   clk         => clk,
                rst         => rst,
                data_in     => Bus_ALUFLAGS,
                data_out    => Bus_FLAGS);

    MDRI : reg
    port map(   clk         => clk,
                rst         => rst,
                data_in     => Bus_B,
                data_out    => Bus_MDRI);

    MAR : reg_we
    port map(   clk         => clk,
                rst         => rst,
                we          => MAR_write,
                data_in     => Bus_ALU,
                data_out    => Bus_MAR);

    ERR : reg
    generic map( W          => 1)
    port map(   clk         => clk,
                rst         => rst,
                data_in     => Error,
                data_out    => FlagE);

    RF : rf_32x32
    port map(   clk         => clk,
                rst         => rst,
                RegWrite    => RF_write,
                RegImmNot   => RorI,
                RTZero      => RTZero,
                rs          => Bus_IRin(25 downto 21),
                rt          => Bus_IRin(20 downto 16),
                rd          => Bus_IRin(15 downto 11),
                dataW_in    => Bus_W,
                dataA_out   => Bus_RA,
                dataB_out   => Bus_RB);

    RFMUX : rf_mux
    port map(   data_alu_in => Bus_ALUO,
                data_dm_in  => Bus_MDRO,
                data_npc_in => Bus_NPC,
                data_mlo_in => Bus_LO,
                data_mhi_in => Bus_HI,
                Link        => Link,
                DMorALU     => DMorALU,
                MF          => MF,
                HIorLO      => HIorLO,
                data_out    => Bus_W);
    
    EXTIMM : extend_immediate
    port map(   data_in     => Bus_IRin(15 downto 0),
                SorZ        => SorZ,
                data_out    => Bus_EXT);

    NPCADD : npc_adder 
    port map(   dataA_in    => Bus_NPC,
                dataB_in    => Bus_SL2,
                data_out    => Bus_ADD);

    NPCINC : npc_inc
    port map(   data_in     => Bus_PC,
                data_out    => Bus_INC);

    NPCSEL : npc_sel
    port map(   Jump        => Jump,
                JumpPSD     => JumpPSD,
                BranchType  => BranchType,
                NEorEQ      => NEorEQ,
                Zero        => Bus_FLAGS(0),
                Negative    => Bus_FLAGS(1),
                JumpSelect  => Bus_NPCSEL);

    NPCMUX : npc_mux
    port map(   data_npc_in => Bus_NPC,
                data_imm_in => Bus_M,
                data_reg_in => Bus_A,
                data_psd_in => Bus_D,
                JumpSelect  => Bus_NPCSEL,
                data_out    => Bus_NPCMUX);

    NPCPSD : npc_psd
    port map(   dataP_in    => Bus_P,
                dataA_in    => Bus_IRin(25 downto 0),
                data_out    => Bus_PSD);

    NPCSL2 : npc_sl2
    port map(   data_in     => Bus_I,
                data_out    => Bus_SL2);

    ALU : alu_top
    generic map(mult_pipe   => mult_pipe)
    port map(   clk         => clk,
                rst         => rst,
                sv          => sv,
                TestMult    => TestMult,
                MT          => MT,
                HIorLO      => HIorLO,
                ALUop       => ALUop,
                shamt       => Bus_SHAMT,
                Bus_A       => Bus_ALUMUXA,
                Bus_B       => Bus_ALUMUXB,
                Zero        => Zero,
                ov          => Overflow,
                bist_fail   => bist_fail,
                Bus_S       => Bus_ALU,
                Bus_mult_HI => Bus_MULTHI,
                Bus_mult_LO => Bus_MULTLO);

    ALUMUX : alu_mux
    port map(   clk             => clk,
                rst             => rst,
                data_regA_in    => Bus_A,
                data_regB_in    => Bus_B,
                data_imm_in     => Bus_I,
                AluSelect       => BorI,
                dataA_out       => Bus_ALUMUXA,
                dataB_out       => Bus_ALUMUXB);

    DMCONTROL : dm_control
    port map(   data_mdr_in     => Bus_MDRI,
                data_mar_in     => Bus_MAR,
                data_dmd_in     => Bus_DMDin,
                DMWT            => DMWT,
                DMD_we          => DMD_write,
                Error           => Error,
                data_mdr_out    => Bus_MDRO,
                data_dma_out    => Bus_DMAout,
                data_we_out     => Bus_DMWEout,
                data_dmd_out    => Bus_DMDout);

end Structural;
