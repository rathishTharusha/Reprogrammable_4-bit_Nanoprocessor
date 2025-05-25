----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/12/2025 05:27:58 PM
-- Design Name: 
-- Module Name: Instruction_Decoder - Behavioral
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

entity Instruction_Decoder is
    Port ( Instruction : in STD_LOGIC_VECTOR (11 downto 0);
           CheckZ : in STD_LOGIC;
           RegEn : out STD_LOGIC_VECTOR (2 downto 0);
           LoadSel : out STD_LOGIC;
           ImVal : out STD_LOGIC_VECTOR (3 downto 0);
           RegA : out STD_LOGIC_VECTOR (2 downto 0);
           RegB : out STD_LOGIC_VECTOR (2 downto 0);
           Op : out STD_LOGIC;
           JumpFlag : out STD_LOGIC;
           JAddress : out STD_LOGIC_VECTOR (2 downto 0));
end Instruction_Decoder;

architecture Behavioral of Instruction_Decoder is

begin

RegEn <= Instruction(9 downto 7);
LoadSel <= Instruction(11) AND (NOT Instruction(10)); -- 0
ImVal <= Instruction(3 downto 0);
RegA <= Instruction(9 downto 7);
RegB <= Instruction(6 downto 4);
Op <= (NOT Instruction(11)) AND Instruction(10); -- 1
JumpFlag <= CheckZ AND Instruction(11) AND Instruction(10); -- 0
JAddress <= Instruction(2 downto 0);

end Behavioral;


-- other method
--------------------------------------------------------

--process (Instruction) begin

--case Instruction(11 downto 10) is
--when "00" => -- ADD format: 0 0 Ra Ra Ra Rb Rb Rb 0 0 0 0
--    RegEn <= Instruction(9 downto 7);
--    LoadSel <= '0'; 
--    ImVal <= Instruction(3 downto 0);
--    RegA <= Instruction(9 downto 7);
--    RegB <= Instruction(6 downto 4);
--    Op <= '0';
--    JumpFlag <= '0';
--    JAddress <= Instruction(2 downto 0);
--when "10" => -- MOVI format: 1 0 R R R 0 0 0 d d d d  ** can be used to add
--    RegEn <= Instruction(9 downto 7);
--    LoadSel <= '1';
--    ImVal <= Instruction(3 downto 0);
--    RegA <= Instruction(9 downto 7);
--    RegB <= Instruction(6 downto 4);
--    Op <= '0';
--    JumpFlag <= '0';
--    JAddress <= Instruction(2 downto 0);
--when "01" => -- NEG format: 0 1 R R R 0 0 0 0 0 0 0
--    RegEn <= Instruction(9 downto 7);
--    LoadSel <= '0';
--    ImVal <= Instruction(3 downto 0);
--    RegA <= Instruction(9 downto 7);
--    RegB <= Instruction(6 downto 4);
--    Op <= '1';
--    JumpFlag <= '0';
--    JAddress <= Instruction(2 downto 0);
--when "11" => -- Add format: 1 1 R R R 0 0 0 0 d d d 
--    RegEn <= Instruction(9 downto 7);
--    LoadSel <= '0';
--    ImVal <= Instruction(3 downto 0);
--    RegA <= Instruction(9 downto 7);
--    RegB <= Instruction(6 downto 4);
--    Op <= '0';
--    JumpFlag <= CheckZ;
--    JAddress <= Instruction(2 downto 0);
--end case;
--end process;

--------------------------------------------------------