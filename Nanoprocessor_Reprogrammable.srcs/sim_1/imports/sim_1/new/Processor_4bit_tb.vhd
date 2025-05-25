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
        Port ( Clk : in STD_LOGIC;
               Res : in STD_LOGIC;
               ResRB : in STD_LOGIC;
               ResRAM : in STD_LOGIC;
               Run : in STD_LOGIC;
               Step : in STD_LOGIC;
               Upload : in STD_LOGIC;
               Data_write: in STD_LOGIC_VECTOR (11 downto 0);
               RegSel : in STD_LOGIC_VECTOR (2 downto 0);
               Command : out STD_LOGIC_VECTOR (11 downto 0);
               Data_seg : out STD_LOGIC_VECTOR (6 downto 0);
               An_out: out STD_LOGIC_VECTOR (3 downto 0);
               Flags : out STD_LOGIC_VECTOR (2 downto 0));
    end component;

    -- Testbench signals
    signal Clk, Res, ResRAM, ResRB, Step, Upload : STD_LOGIC := '0';
    signal Run: STD_LOGIC := '1';
    signal Command : STD_LOGIC_VECTOR(11 downto 0);
    signal Flags : STD_LOGIC_VECTOR(2 downto 0);
    signal RegSel : STD_LOGIC_VECTOR(2 downto 0):= "001";
    Signal Data_seg : STD_LOGIC_VECTOR (6 downto 0);
    Signal An_out: STD_LOGIC_VECTOR (3 downto 0);
    Signal Data_write : STD_LOGIC_VECTOR (11 downto 0) := "000000000000";
            
    -- Clock period definitions
    constant Clk_period : time := 10 ns;

begin
-- Instantiate the Unit Under Test (UUT)
    uut: Processor_4bit port map (
        Clk => Clk,
        Res => Res,
        ResRB => ResRB,
        ResRAM => ResRAM,
        Run => Run,
        Step => Step,
        Upload => Upload,
        Data_write => Data_write,
        RegSel => RegSel,
        Command => Command,
        Data_seg => Data_seg,
        An_out => An_out,
        Flags => Flags
    );
    
reset_process: process
    begin
    Res <= '1'; ResRAM <= '1'; ResRB <= '1'; wait for 30 ns;
    Res <= '0'; ResRAM <= '0'; ResRB <= '0';
    wait for 300 ns;
    Run <= '0'; wait for clk_period;
    Res <= '1'; wait for 30 ns;
    Res <= '0'; wait for clk_period;
    RegSel <= "000";
    Data_write <= "100010000011";
    Upload <= '1'; wait for clk_period*5;
    Upload <= '0';        
    RegSel <= "001";
    Run <= '1';
        
    wait;
end process;

clk_process: process
    begin
        Clk <= '0'; wait for clk_period/2;
        Clk <= '1'; wait for clk_period/2;
    end process;



end Behavioral;
