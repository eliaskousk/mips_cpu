library ieee;
use ieee.std_logic_1164.all;

library UNISIM;
use UNISIM.vcomponents.all;

-- Only XST supports RAM inference
-- Infers Single Port Block Ram

entity im_bram_512x32_0 is 
    port(   clk : in  std_logic;
            we  : in  std_logic;
            en  : in  std_logic;
            ssr : in  std_logic;
            a   : in  std_logic_vector(8 downto 0);
            di  : in  std_logic_vector(31 downto 0);
            do  : out std_logic_vector(31 downto 0);
            dop : out std_logic_vector(3 downto 0));
end im_bram_512x32_0;

    -- 512 x 32 RAM Bank

architecture Structural of im_bram_512x32_0 is 

begin

    Rinst : RAMB16_S36
    generic map (
        INIT        => X"000000000",    --  Value of output RAM registers at startup
        SRVAL       => X"000000000",    --  Ouput value upon SSR assertion
        WRITE_MODE  => "WRITE_FIRST",   --  WRITE_FIRST, READ_FIRST or NO_CHANGE

        -- The following INIT_xx declarations specify the initial contents of the RAM

        -- Address 0 to 127
        INIT_00 => X"2405ffffac24000824048000ac23000424030001ac2200002402111100000820",
        INIT_01 => X"ac2800189428000eac2700148427000eac2600108c26000cac25000c3c05ffff",
        INIT_02 => X"204b1111a026002ca4260028ac260024ac2a0020902a000fac29001c8029000f",
        INIT_03 => X"384f5555ac2e003c344e4444ac2d0038304d3333ac2c0034244c2222ac2b0030",
        INIT_04 => X"020b9823ac32004c020c9022ac310048016c8821ac300044016c8020ac2f0040",
        INIT_05 => X"0045b826ac36005c00adb027ac3500580091a825ac34005400b0a024ac330050",
        INIT_06 => X"0180001301600011ac3900680000c812ac3800640000c01000ab0018ac370060",
        INIT_07 => X"ac3d00780343e804ac3c00740004e0c3ac3b00700004d8c2ac3a006c0003d0c0",
        INIT_08 => X"ac27008828c7bbbbac2600843c06aaaaac3f00800344f807ac3e007c0344f006",
        INIT_09 => X"0162582110670002ac2a009400a6502bac29009000c5482aac28008c2ca8bbbb",
        INIT_0A => X"1c600002ac2b00a00162582118600002ac2b009c0162582114670002ac2b0098",
        INIT_0B => X"ac2b00ac0162582104610002ac2b00a80162582104600002ac2b00a401625821",
        INIT_0C => X"ac2b00b4016258210180f809240c01a0ac2b00b00162582101800008240c0190",
        INIT_0D => X"01625821C0000000ac2b00bc016258210c00006eac2b00b8016258210800006b",
        INIT_0E => X"00000000000000000000000000000000000000000000000000000000ac2b00c0",
        INIT_0F => X"0000000000000000000000000000000000000000000000000000000000000000",

        -- Address 128 to 255
        INIT_10 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_11 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_12 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_13 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_14 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_15 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_16 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_17 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_18 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_19 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_1A => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_1B => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_1C => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_1D => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_1E => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_1F => X"0000000000000000000000000000000000000000000000000000000000000000",

        -- Address 256 to 383
        INIT_20 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_21 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_22 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_25 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_26 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_27 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_28 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_29 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_2A => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_2B => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_2C => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_2D => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_2E => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_2F => X"0000000000000000000000000000000000000000000000000000000000000000",

        -- Address 384 to 511
        INIT_30 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_31 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_32 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_33 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_35 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_38 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_39 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_3A => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_3B => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_3D => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",
        INIT_3F => X"000000000000000000000000000000000000000000000000000000000000ffff",
        
        -- The next set of INITP_xx are for the parity bits
        
        -- Address 0 to 127
        INITP_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INITP_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
        
        -- Address 128 to 255
        INITP_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INITP_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
        
        -- Address 256 to 383
        INITP_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INITP_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
        
        -- Address 384 to 511
        INITP_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INITP_07 => X"0000000000000000000000000000000000000000000000000000000000000000")
   
    port map(
        DO      => do,
        DOP     => dop,
        ADDR    => a,
        CLK     => clk,
        DI      => di,
        DIP     => di(7 downto 4),
        EN      => en,
        SSR     => ssr,
        WE      => we);
 
end Structural;
