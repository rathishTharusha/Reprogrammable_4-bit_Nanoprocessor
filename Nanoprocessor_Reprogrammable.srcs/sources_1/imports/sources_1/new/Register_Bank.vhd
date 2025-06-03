----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/12/2025 04:04:28 PM
-- Design Name: 
-- Module Name: Register_Bank - Behavioral
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

entity Register_Bank is
    Port ( Data_in : in STD_LOGIC_VECTOR (3 downto 0);
           RegEn : in STD_LOGIC_VECTOR (2 downto 0);
           Res : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Data_out_0, Data_out_1, Data_out_2, Data_out_3, Data_out_4, Data_out_5, Data_out_6, Data_out_7 : out STD_LOGIC_VECTOR (3 downto 0));
end Register_Bank;

architecture Behavioral of Register_Bank is

COMPONENT REG
    Port ( D : in STD_LOGIC_VECTOR (3 downto 0);
           Res : in STD_LOGIC;
           En: in STD_LOGIC;
           Clk : in STD_LOGIC;
           Y : out STD_LOGIC_VECTOR (3 downto 0));
end COMPONENT;

COMPONENT Decoder_3_to_8
    Port ( I : in STD_LOGIC_VECTOR (2 downto 0);
           Y : out STD_LOGIC_VECTOR (7 downto 0));
end COMPONENT;

SIGNAL En: std_logic_vector (7 downto 0);

begin

Decoder_3_to_8_0:Decoder_3_to_8
port map(
I => RegEn,
Y => En
);

REG0: REG
port map(
    D => "0000",
    Res => Res,
    En => '1',
    Clk => Clk,
    Y =>  Data_out_0
);

REG1: REG
port map(
    D => Data_in,
    Res => Res,
    En => En(1),
    Clk => Clk,
    Y =>  Data_out_1
);

REG2: REG
port map(
    D => Data_in,
    Res => Res,
    En => En(2),
    Clk => Clk,
    Y =>  Data_out_2
);

REG3: REG
port map(
    D => Data_in,
    Res => Res,
    En => En(3),
    Clk => Clk,
    Y =>  Data_out_3
);

REG4: REG
port map(
    D => Data_in,
    Res => Res,
    En => En(4),
    Clk => Clk,
    Y =>  Data_out_4
);

REG5: REG
port map(
    D => Data_in,
    Res => Res,
    En => En(5),
    Clk => Clk,
    Y =>  Data_out_5
);

REG6: REG
port map(
    D => Data_in,
    Res => Res,
    En => En(6),
    Clk => Clk,
    Y =>  Data_out_6
);

REG7: REG
port map(
    D => Data_in,
    Res => Res,
    En => En(7),
    Clk => Clk,
    Y =>  Data_out_7
);

end Behavioral;