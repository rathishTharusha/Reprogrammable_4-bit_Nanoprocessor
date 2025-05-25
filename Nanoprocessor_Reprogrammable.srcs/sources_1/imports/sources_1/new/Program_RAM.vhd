----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2025 08:12:31 PM
-- Design Name: 
-- Module Name: Program_RAM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Program_RAM is
    Port ( Address : in STD_LOGIC_VECTOR (2 downto 0);
       Data_write: in STD_LOGIC_VECTOR (11 downto 0);
       W_en: in STD_LOGIC;
       Clk: in STD_LOGIC;
       Res : in STD_LOGIC;
       Instruction : out STD_LOGIC_VECTOR (11 downto 0));
end Program_RAM;

architecture Behavioral of Program_RAM is

COMPONENT REG_12bit
    Port ( D : in STD_LOGIC_VECTOR (11 downto 0);
       I : in STD_LOGIC_VECTOR (11 downto 0);
       Res : in STD_LOGIC;
       En: in STD_LOGIC;
       Clk : in STD_LOGIC;
       Y : out STD_LOGIC_VECTOR (11 downto 0));
end COMPONENT;

COMPONENT Decoder_3_to_8
    Port ( I : in STD_LOGIC_VECTOR (2 downto 0);
           En: in STD_LOGIC;
           Y : out STD_LOGIC_VECTOR (7 downto 0));
end COMPONENT;

COMPONENT MUX_8_to_1_12bit 
    Port ( D0 : in STD_LOGIC_VECTOR (11 downto 0);
       D1 : in STD_LOGIC_VECTOR (11 downto 0);
       D2 : in STD_LOGIC_VECTOR (11 downto 0);
       D3 : in STD_LOGIC_VECTOR (11 downto 0);
       D4 : in STD_LOGIC_VECTOR (11 downto 0);
       D5 : in STD_LOGIC_VECTOR (11 downto 0);
       D6 : in STD_LOGIC_VECTOR (11 downto 0);
       D7 : in STD_LOGIC_VECTOR (11 downto 0);
       Sel : in STD_LOGIC_VECTOR (2 downto 0);
       Y : out STD_LOGIC_VECTOR (11 downto 0));
end COMPONENT;
                                            
SIGNAL D0, D1, D2, D3, D4, D5, D6, D7 : std_logic_vector(11 downto 0); 
SIGNAL write: std_logic_vector(7 downto 0);

begin

Decoder_3_to_8_0: Decoder_3_to_8
    port map ( I => Address,
           En => W_en,
           Y => write
);
 
MUX_8_to_1_12bit_0: MUX_8_to_1_12bit 
    port map ( D0 => D0,
       D1 => D1,
       D2 => D2,
       D3 => D3,
       D4 => D4,
       D5 => D5,
       D6 => D6,
       D7 => D7,
       Sel => Address,
       Y => Instruction
);    

REG_12bit_0: REG_12bit
    port map ( D => Data_write,
       I => "100010001010",
       Res => Res,
       En => write(0),
       Clk => Clk,
       Y => D0
       );

REG_12bit_1: REG_12bit
    port map ( D => Data_write,
       I => "100100000001",
       Res => Res,
       En => write(1),
       Clk => Clk,
       Y => D1
       );

REG_12bit_2: REG_12bit
    port map ( D => Data_write,
        I => "010100000000",
       Res => Res,
       En => write(2),
       Clk => Clk,
       Y => D2
       );

REG_12bit_3: REG_12bit
    port map ( D => Data_write,
       I => "000010100000",
       Res => Res,
       En => write(3),
       Clk => Clk,
       Y => D3
       );

REG_12bit_4: REG_12bit
    port map ( D => Data_write,
       I => "110010000111",
       Res => Res,
       En => write(4),
       Clk => Clk,
       Y => D4
       );

REG_12bit_5: REG_12bit
    port map ( D => Data_write,
       I => "110000000011",
       Res => Res,
       En => write(5),
       Clk => Clk,
       Y => D5
       );

REG_12bit_6: REG_12bit
    port map ( D => Data_write,
       I => "000000000000",
       Res => Res,
       En => write(6),
       Clk => Clk,
       Y => D6
       );

REG_12bit_7: REG_12bit
    port map ( D => Data_write,
       I => "000000000000",
       Res => Res,
       En => write(7),
       Clk => Clk,
       Y => D7
       );

       
end Behavioral;
