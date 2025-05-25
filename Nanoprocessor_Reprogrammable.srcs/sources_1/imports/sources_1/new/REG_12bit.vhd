----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2025 08:07:00 PM
-- Design Name: 
-- Module Name: REG_12bit - Behavioral
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

entity REG_12bit is
    Port ( D : in STD_LOGIC_VECTOR (11 downto 0);
       I : in STD_LOGIC_VECTOR (11 downto 0);
       Res : in STD_LOGIC;
       En: in STD_LOGIC;
       Clk : in STD_LOGIC;
       Y : out STD_LOGIC_VECTOR (11 downto 0));
end REG_12bit;

architecture Behavioral of REG_12bit is

begin

process (Clk) begin
    if (rising_edge(Clk)) then
        if Res = '1' then
            Y <= I;
        else
            if En = '1' then
                Y <= D;
            end if;
        end if;
    end if;

end process;

end Behavioral;
