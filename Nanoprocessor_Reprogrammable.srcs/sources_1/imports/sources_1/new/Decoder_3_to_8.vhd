----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/12/2025 12:16:03 PM
-- Design Name: 
-- Module Name: Decoder_3_to_8 - Behavioral
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

entity Decoder_3_to_8 is
    Port ( I : in STD_LOGIC_VECTOR (2 downto 0);
           En: in STD_LOGIC;
           Y : out STD_LOGIC_VECTOR (7 downto 0));
end Decoder_3_to_8;

architecture Behavioral of Decoder_3_to_8 is

COMPONENT Decoder_2_to_4
    Port ( I : in STD_LOGIC_VECTOR (1 downto 0);
           En: in STD_LOGIC;
           Y : out STD_LOGIC_VECTOR (3 downto 0));
end COMPONENT;

signal I0, I1: STD_LOGIC_VECTOR(1 DOWNTO 0);
signal Y0, Y1: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL En0, En1: std_logic;

begin

Decoder_2_to_4_0: Decoder_2_to_4
port map(
I => I0,
En => En0,
Y => Y0
);

Decoder_2_to_4_1: Decoder_2_to_4
port map(
I => I1,
En => En1,
Y => Y1
);

En0 <= EN AND NOT I(2);
En1 <= EN AND I(2);
I0 <= I(1 downto 0);
I1 <= I(1 downto 0);

Y(3 downto 0) <= Y0;
Y(7 downto 4) <= Y1;

end Behavioral;
