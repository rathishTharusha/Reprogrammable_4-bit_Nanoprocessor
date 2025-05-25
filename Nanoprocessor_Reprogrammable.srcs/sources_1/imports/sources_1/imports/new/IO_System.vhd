----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/19/2025 11:14:33 AM
-- Design Name: 
-- Module Name: IO_System - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IO_System is
    Port ( 
           Clk: in STD_LOGIC;
           DATA : in STD_LOGIC_VECTOR (3 downto 0);
           PC : in STD_LOGIC_VECTOR (2 downto 0);
           REGEN : in STD_LOGIC_VECTOR (2 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end IO_System;

architecture Behavioral of IO_System is

type rom_type is array (0 to 15) of std_logic_vector(6 downto 0);  
signal Seg7: rom_type := (  
"1000000", -- 0  
"1111001", -- 1  
"0100100", -- 2  
"0110000", -- 3  
"0011001", -- 4  
"0010010", -- 5  
"0000010", -- 6  
"1111000", -- 7  
"0000000", -- 8  
"1111000", -- 9  
"0000010", -- a  
"0010010", -- b  
"0011001", -- c  
"0110000", -- d  
"0100100", -- e  
"1111001"  -- f  
); 

SIGNAL refresh_count : integer range 0 to 49999 := 0;
SIGNAL digit_select  : integer range 0 to 3 := 0;      -- Current digit being refreshed
    
begin

display_refresh: process(Clk)
    begin
        if rising_edge(Clk) then
                    
            -- Refresh counter for multiplexing
            if refresh_count = 49999 then
                refresh_count <= 0;
                digit_select <= digit_select + 1;
                if digit_select = 3 then
                    digit_select <= 0;
                end if;
            else
                refresh_count <= refresh_count + 1;
            end if;
            
            -- Digit selection and segment output
            case digit_select is
                when 0 => -- Display PC (leftmost digit)
                    an <= "0111"; -- Enable digit 0
                        seg <= Seg7(to_integer(UNSIGNED(PC))); -- PC

                when 1 => -- Display Register Number (2rd digit)
                    an <= "1011"; -- Enable digit 2
                    seg <= Seg7(to_integer(UNSIGNED(REGEN))); -- R number LSB
                                
                when 2 => -- Display Negative flag (3nd digit)
                    an <= "1101"; -- Enable digit 1
                        if DATA(3) = '1' then -- Negative flag
                            seg <= "0111111"; -- Minus sign
                        else
                            seg <= "1111111"; -- Blank
                        end if;                                
                                
                when 3 => -- Display Register Value (rightmost digit)
                    an <= "1110"; -- Enable digit 3
                    seg <= Seg7(to_integer(UNSIGNED(DATA))); -- Reg value
                        end case;
                    end if;
    end process;
end Behavioral;
