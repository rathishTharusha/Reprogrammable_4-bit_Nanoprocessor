----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/16/2025 11:38:24 AM
-- Design Name: 
-- Module Name: Program_counter - Behavioral
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

entity Program_counter is
    Port ( Clk : in STD_LOGIC;
           Res : in STD_LOGIC;
           JFlag : in STD_LOGIC;
           JAdr : in STD_LOGIC_VECTOR (2 downto 0);
           Address : out STD_LOGIC_VECTOR (2 downto 0));
end Program_counter;

architecture Behavioral of Program_counter is
    signal PC_reg  : STD_LOGIC_VECTOR(2 downto 0) := "000"; -- 3-bit PC register
    signal PC_next : STD_LOGIC_VECTOR(2 downto 0);           -- Next PC value
    signal PC_inc  : STD_LOGIC_VECTOR(2 downto 0);           -- Incremented PC value
begin
    
    -- Incrementer
    PC_inc <= STD_LOGIC_VECTOR(unsigned(PC_reg) + 1);
    
    -- 2-way Mux for jump
    PC_next <= JAdr when JFlag = '1' else PC_inc;
    
    -- Update PC
    process(Clk, Res)
    begin
        if Res = '1' then
            PC_reg <= "000";
        elsif rising_edge(Clk) then            
            PC_reg <= PC_next;      
        end if;
    end process;
    
    Address <= PC_reg;
end Behavioral;