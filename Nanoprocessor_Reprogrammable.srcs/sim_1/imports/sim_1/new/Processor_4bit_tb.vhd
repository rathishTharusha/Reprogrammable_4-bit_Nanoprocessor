----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/13/2025 12:46:20 PM
-- Design Name: 
-- Module Name: Processor_4bit_tb - Behavioral
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

entity Processor_4bit_tb is
--  Port ( );
end Processor_4bit_tb;

architecture Behavioral of Processor_4bit_tb is
    component Processor_4bit
        Port ( Clk   : in STD_LOGIC;
               Res   : in STD_LOGIC;
               Data  : out STD_LOGIC_VECTOR(3 downto 0);
               Flags : out STD_LOGIC_VECTOR(1 downto 0));
    end component;

    -- Testbench signals
    signal Clk, Res : STD_LOGIC := '0';
    signal Data : STD_LOGIC_VECTOR(3 downto 0);
    signal Flags : STD_LOGIC_VECTOR(1 downto 0);
        
    -- Clock period definitions
    constant Clk_period : time := 10 ns;

begin
-- Instantiate the Unit Under Test (UUT)
    uut: Processor_4bit port map (
        Clk => Clk,
        Res => Res,
        Data => Data,
        Flags => Flags
    );
    
reset_process: process
    begin
    Res <= '1'; wait for 30 ns;
    Res <= '0'; wait;
end process;

clk_process: process
    begin
        Clk <= '0'; wait for clk_period/2;
        Clk <= '1'; wait for clk_period/2;
    end process;

end Behavioral;