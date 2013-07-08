--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:30:42 07/08/2013
-- Design Name:   
-- Module Name:   /home/Storage/Documents/Development/Projects/mips_cpu/ise/mips_cpu_ise_14.5/alu_mult_mux_tb.vhd
-- Project Name:  mips_cpu_ise_14.5
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alu_mult_mux
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY alu_mult_mux_tb IS
END alu_mult_mux_tb;
 
ARCHITECTURE behavior OF alu_mult_mux_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alu_mult_mux
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         mux_select : IN  std_logic_vector(1 downto 0);
         data_in_normal_hi : IN  std_logic_vector(31 downto 0);
         data_in_normal_lo : IN  std_logic_vector(31 downto 0);
         data_in_lfsr_hi : IN  std_logic_vector(31 downto 0);
         data_in_lfsr_lo : IN  std_logic_vector(31 downto 0);
         data_in_counter_hi : IN  std_logic_vector(31 downto 0);
         data_in_counter_lo : IN  std_logic_vector(31 downto 0);
         data_in_atpg_hi : IN  std_logic_vector(31 downto 0);
         data_in_atpg_lo : IN  std_logic_vector(31 downto 0);
         data_mux_hi : OUT  std_logic_vector(31 downto 0);
         data_mux_lo : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal mux_select : std_logic_vector(1 downto 0) := (others => '0');
   signal data_in_normal_hi : std_logic_vector(31 downto 0) := (others => '0');
   signal data_in_normal_lo : std_logic_vector(31 downto 0) := (others => '0');
   signal data_in_lfsr_hi : std_logic_vector(31 downto 0) := (others => '0');
   signal data_in_lfsr_lo : std_logic_vector(31 downto 0) := (others => '0');
   signal data_in_counter_hi : std_logic_vector(31 downto 0) := (others => '0');
   signal data_in_counter_lo : std_logic_vector(31 downto 0) := (others => '0');
   signal data_in_atpg_hi : std_logic_vector(31 downto 0) := (others => '0');
   signal data_in_atpg_lo : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal data_mux_hi : std_logic_vector(31 downto 0);
   signal data_mux_lo : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alu_mult_mux PORT MAP (
          clk => clk,
          rst => rst,
          mux_select => mux_select,
          data_in_normal_hi => data_in_normal_hi,
          data_in_normal_lo => data_in_normal_lo,
          data_in_lfsr_hi => data_in_lfsr_hi,
          data_in_lfsr_lo => data_in_lfsr_lo,
          data_in_counter_hi => data_in_counter_hi,
          data_in_counter_lo => data_in_counter_lo,
          data_in_atpg_hi => data_in_atpg_hi,
          data_in_atpg_lo => data_in_atpg_lo,
          data_mux_hi => data_mux_hi,
          data_mux_lo => data_mux_lo
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
