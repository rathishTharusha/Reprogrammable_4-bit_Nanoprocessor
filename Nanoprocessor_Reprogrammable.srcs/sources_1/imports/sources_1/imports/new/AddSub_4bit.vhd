----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/12/2025 11:08:59 AM
-- Design Name: 
-- Module Name: AddSub_4bit - Behavioral
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

entity AddSub_4bit is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           Op : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (3 downto 0);
           Overflow : out STD_LOGIC;
           Cout: out STD_LOGIC;
           Zero : out STD_LOGIC);
end AddSub_4bit;

architecture Behavioral of AddSub_4bit is

    signal B_xor, SUM : STD_LOGIC_VECTOR(3 downto 0);
    signal C     : STD_LOGIC_VECTOR(4 downto 0);
    
begin
    B_xor <= B when (Op = '0') else not B;
    C(0)  <= Op;  -- Carry-in for subtraction
    
    GEN_FA: for i in 0 to 3 generate
        SUM(i) <= A(i) XOR B_xor(i) XOR C(i);
        C(i+1) <= (A(i) AND B_xor(i)) OR 
                  (A(i) AND C(i)) OR 
                  (B_xor(i) AND C(i));
    end generate;
    
    Cout <= C(4);
    Q <= SUM;
    Zero <= NOT (SUM(0) OR SUM(1) OR SUM(2) OR SUM(3));
    Overflow <= C(4) XOR C(3);

end Behavioral;
