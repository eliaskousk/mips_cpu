library ieee;
use ieee.std_logic_1164.all;

entity dm_control_tb is
end dm_control_tb;

architecture Behavioral of dm_control_tb is

    -- Component Declaration for the Unit Under Test (UUT)

    component dm_control
        port(data_mdr_in  : in  std_logic_vector(31 downto 0);
             data_mar_in  : in  std_logic_vector(31 downto 0);
             data_dmd_in  : in  std_logic_vector(31 downto 0);
             DMWT         : in  std_logic_vector(2 downto 0);
             DMD_we       : in  std_logic;
             Error        : out std_logic_vector(0 downto 0);
             data_mdr_out : out std_logic_vector(31 downto 0);
             data_dma_out : out std_logic_vector(31 downto 0);
             data_we_out  : out std_logic_vector(3 downto 0);
             data_dmd_out : out std_logic_vector(31 downto 0));
    end component dm_control;

    --Inputs
    signal data_mdr_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal data_mar_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal data_dmd_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal DMWT         : std_logic_vector(2 downto 0) := (others => '0');
    signal DMD_we       : std_logic := '0';

    --Outputs
    signal Error        : std_logic_vector(0 downto 0);
    signal data_mdr_out : std_logic_vector(31 downto 0);
    signal data_dma_out : std_logic_vector(31 downto 0);
    signal data_we_out  : std_logic_vector(3 downto 0);
    signal data_dmd_out : std_logic_vector(31 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: dm_control
        port map(data_mdr_in  => data_mdr_in,
                 data_mar_in  => data_mar_in,
                 data_dmd_in  => data_dmd_in,
                 DMWT         => DMWT,
                 DMD_we       => DMD_we,
                 Error        => Error,
                 data_mdr_out => data_mdr_out,
                 data_dma_out => data_dma_out,
                 data_we_out  => data_we_out,
                 data_dmd_out => data_dmd_out);

    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 20 ns.
        wait for 20 ns;

        -- =====
        -- =====
        -- Loads
        -- =====
        -- =====

        DMD_we          <= '0';
        
        -- ==
        -- LW
        -- ==

        data_mar_in     <= X"00001000";
        data_dmd_in     <= X"AAAAAAAA";
        DMWT            <= "100";
        wait for 20 ns;
        
        -- ==
        -- LH
        -- ==

        data_dmd_in     <= X"BBBBAAAA";
        DMWT            <= "011";
        
        data_mar_in     <= X"00001000"; -- Right
        wait for 20 ns;
        
        data_mar_in     <= X"00001002"; -- Left
        wait for 20 ns;
        
        -- ===
        -- LHU
        -- ===
        
        data_dmd_in     <= X"BBBBAAAA";
        DMWT            <= "010";

        data_mar_in     <= X"00001000"; -- Right
        wait for 20 ns;
        
        data_mar_in     <= X"00001002"; -- Left
        wait for 20 ns;
        
        -- ==
        -- LB
        -- ==
        
        data_dmd_in     <= X"DDCCBBAA";
        DMWT            <= "001";
        
        data_mar_in     <= X"00001000"; -- 0
        wait for 20 ns;
        
        data_mar_in     <= X"00001001"; -- 1
        wait for 20 ns;
        
        data_mar_in     <= X"00001002"; -- 2
        wait for 20 ns;
        
        data_mar_in     <= X"00001003"; -- 3
        wait for 20 ns;
        
        -- ===
        -- LBU
        -- ===

        data_dmd_in     <= X"DDCCBBAA";
        DMWT            <= "000";
        
        data_mar_in     <= X"00001000"; -- 0
        wait for 20 ns;
        
        data_mar_in     <= X"00001001"; -- 1
        wait for 20 ns;
        
        data_mar_in     <= X"00001002"; -- 2
        wait for 20 ns;
        
        data_mar_in     <= X"00001003"; -- 3
        wait for 20 ns;

        -- ======
        -- ======
        -- Stores
        -- ======
        -- ======

        DMD_we          <= '1';
        data_dmd_in     <= (others => '-');
        
        -- ==
        -- SW
        -- ==
        
        data_mar_in     <= X"00001000";
        data_mdr_in     <= X"AAAAAAAA";
        DMWT            <= "100";
        wait for 20 ns;
        
        -- ==
        -- SH
        -- ==

        data_mdr_in     <= X"BBBBAAAA";
        DMWT            <= "011";

        data_mar_in     <= X"00001000"; -- Right
        wait for 20 ns;
        
        data_mar_in     <= X"00001002"; -- Left
        wait for 20 ns;
               
        -- ==
        -- SB
        -- ==
        
        data_mdr_in     <= X"DDCCBBAA";
        DMWT            <= "001";
        
        data_mar_in     <= X"00001000"; -- 0
        wait for 20 ns;
        
        data_mar_in     <= X"00001001"; -- 1
        wait for 20 ns;
        
        data_mar_in     <= X"00001002"; -- 2
        wait for 20 ns;
        
        data_mar_in     <= X"00001003"; -- 3
        wait for 20 ns;

        wait;
    end process;

end Behavioral;
