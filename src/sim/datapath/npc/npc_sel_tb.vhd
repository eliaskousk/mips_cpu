library ieee;
use ieee.std_logic_1164.all;

entity npc_sel_tb is
end npc_sel_tb;

architecture Behavioral of npc_sel_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component npc_sel
        port(Jump       : in  std_logic;
             JumpPSD    : in  std_logic;
             BranchType : in  std_logic_vector(1 downto 0);
             NEorEQ     : in  std_logic;
             Zero       : in  std_logic;
             Negative   : in  std_logic;
             JumpSelect : out std_logic_vector(1 downto 0));
    end component npc_sel;

    --Inputs
    signal Jump         : std_logic := '0';
    signal JumpPSD      : std_logic := '0';
    signal BranchType   : std_logic_vector(1 downto 0) := (others => '0');
    signal NEorEQ       : std_logic := '0';
    signal Zero         : std_logic := '0';
    signal Negative     : std_logic := '0';

    --Outputs
    signal JumpSelect   : std_logic_vector(1 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: npc_sel
        port map(Jump       => Jump,
                 JumpPSD    => JumpPSD,
                 BranchType => BranchType,
                 NEorEQ     => NEorEQ,
                 Zero       => Zero,
                 Negative   => Negative,
                 JumpSelect => JumpSelect);

    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 20 ns.
        wait for 20 ns;

        -- Sequential   (JumpSelect will be set to "00")
        
        Jump        <= '0';
        JumpPSD     <= '-';
        BranchType  <= "00";
        NEorEQ      <= '-';
        Zero        <= '-';
        Negative    <= '-';
        wait for 20 ns;
        
        -- Branch       (JumpSelect will be set to "01")

        -- ===
        -- BEQ
        -- ===

        -- BEQ T
        Jump        <= '0';
        JumpPSD     <= '-';
        BranchType  <= "01";
        NEorEQ      <= '0';
        Zero        <= '1';
        Negative    <= '-';
        wait for 20 ns;

        -- BEQ F (results in Sequential)
        Jump        <= '0';
        JumpPSD     <= '-';
        BranchType  <= "01";
        NEorEQ      <= '0';
        Zero        <= '0';
        Negative    <= '-';
        wait for 20 ns;
        
        -- ===
        -- BNE
        -- ===

        -- BNE T
        Jump        <= '0';
        JumpPSD     <= '-';
        BranchType  <= "01";
        NEorEQ      <= '1';
        Zero        <= '0';
        Negative    <= '-';
        wait for 20 ns;
        
        -- BNE F (results in Sequential)
        Jump        <= '0';
        JumpPSD     <= '-';
        BranchType  <= "01";
        NEorEQ      <= '1';
        Zero        <= '1';
        Negative    <= '-';
        wait for 20 ns;
        
        -- ====
        -- BLEZ
        -- ====
        
        --BLEZ T
        Jump        <= '0';
        JumpPSD     <= '-';
        BranchType  <= "10";
        NEorEQ      <= '0';
        Zero        <= '1';
        Negative    <= '1';
        wait for 20 ns;
        
        -- BLEZ T
        Jump        <= '0';
        JumpPSD     <= '-';
        BranchType  <= "10";
        NEorEQ      <= '0';
        Zero        <= '1';
        Negative    <= '0';
        wait for 20 ns;
        
        -- BLEZ T
        Jump        <= '0';
        JumpPSD     <= '-';
        BranchType  <= "10";
        NEorEQ      <= '0';
        Zero        <= '0';
        Negative    <= '1';
        wait for 20 ns;
        
        -- BLEZ F (results in sequential)
        Jump        <= '0';
        JumpPSD     <= '-';
        BranchType  <= "10";
        NEorEQ      <= '0';
        Zero        <= '0';
        Negative    <= '0';
        wait for 20 ns;
        
        -- ====
        -- BGTZ
        -- ====
        
        -- BGTZ T
        Jump        <= '0';
        JumpPSD     <= '-';
        BranchType  <= "10";
        NEorEQ      <= '1';
        Zero        <= '0';
        Negative    <= '0';
        wait for 20 ns;
        
        -- BGTZ F (results (in sequential)
        Jump        <= '0';
        JumpPSD     <= '-';
        BranchType  <= "10";
        NEorEQ      <= '1';
        Zero        <= '0';
        Negative    <= '1';
        wait for 20 ns;

        -- BGTZ F (results (in sequential)
        Jump        <= '0';
        JumpPSD     <= '-';
        BranchType  <= "10";
        NEorEQ      <= '1';
        Zero        <= '1';
        Negative    <= '0';
        wait for 20 ns;
        
        -- BGTZ F (results (in sequential)
        Jump        <= '0';
        JumpPSD     <= '-';
        BranchType  <= "10";
        NEorEQ      <= '1';
        Zero        <= '1';
        Negative    <= '1';
        wait for 20 ns;
        
        -- ====
        -- BLTZ
        -- ====
        
        --BLTZ T
        Jump        <= '0';
        JumpPSD     <= '-';
        BranchType  <= "11";
        NEorEQ      <= '0';
        Zero        <= '-';
        Negative    <= '1';
        wait for 20 ns;
        
        -- BLTZ F (results in sequential)
        Jump        <= '0';
        JumpPSD     <= '-';
        BranchType  <= "11";
        NEorEQ      <= '0';
        Zero        <= '-';
        Negative    <= '0';
        wait for 20 ns;
        
        -- ====
        -- BGEZ
        -- ====
        
        -- BGEZ T
        Jump        <= '0';
        JumpPSD     <= '-';
        BranchType  <= "11";
        NEorEQ      <= '1';
        Zero        <= '-';
        Negative    <= '0';
        wait for 20 ns;
        
        -- BGEZ F (results (in sequential)
        Jump        <= '0';
        JumpPSD     <= '-';
        BranchType  <= "11";
        NEorEQ      <= '1';
        Zero        <= '-';
        Negative    <= '1';
        wait for 20 ns;

        -- JR and JALR  (JumpSelect will be set to "10")

        Jump        <= '1';
        JumpPSD     <= '0';
        BranchType  <= "--";
        NEorEQ      <= '-';
        Zero        <= '-';
        Negative    <= '-';
        wait for 20 ns;
        
        -- J  and JAL   (JumpSelect will be set to "11")

        Jump        <= '1';
        JumpPSD     <= '1';
        BranchType  <= "--";
        NEorEQ      <= '-';
        Zero        <= '-';
        Negative    <= '-';
        wait for 20 ns;
        
        wait;
    end process;

end Behavioral;
