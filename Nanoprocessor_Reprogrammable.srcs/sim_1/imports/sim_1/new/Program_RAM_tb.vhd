----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2025 08:57:38 PM
-- Design Name: 
-- Module Name: Program_RAM_tb - Behavioral
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

entity Program_RAM_tb is
end Program_RAM_tb;

architecture Behavioral of Program_RAM_tb is

    component Program_RAM
    Port ( 
        Address : in STD_LOGIC_VECTOR (2 downto 0);
        Data_write : in STD_LOGIC_VECTOR (11 downto 0);
        W_en : in STD_LOGIC;
        Clk : in STD_LOGIC;
        Res : in STD_LOGIC;
        Instruction : out STD_LOGIC_VECTOR (11 downto 0)
    );
    end component;

    -- Inputs
    signal Address : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal Data_write : STD_LOGIC_VECTOR(11 downto 0) := "000000000000";
    signal W_en : STD_LOGIC := '0';
    signal Clk : STD_LOGIC := '0';
    signal Res : STD_LOGIC := '0';

    -- Outputs
    signal Instruction : STD_LOGIC_VECTOR(11 downto 0);

    -- Clock period
    constant Clk_period : time := 10 ns;

begin

    uut: Program_RAM port map (
        Address => Address,
        Data_write => Data_write,
        W_en => W_en,
        Clk => Clk,
        Res => Res,
        Instruction => Instruction
    );

    -- Clock process
    Clk_process: process
    begin
        Clk <= '0';
        wait for Clk_period/2;
        Clk <= '1';
        wait for Clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize and reset
        wait for Clk_period*2;
        Res <= '1';
        wait for Clk_period;
        Res <= '0';
        wait for Clk_period;
        
        -- Test 1: Verify reset state (all registers should be 000000000000)
        Address <= "000";
        wait for Clk_period;
        assert Instruction = "000000000000" report "Address 0 not reset properly";
        
        Address <= "001";
        wait for Clk_period;
        assert Instruction = "000000000000" report "Address 1 not reset properly";
        
        Address <= "010";
        wait for Clk_period;
        assert Instruction = "000000000000" report "Address 2 not reset properly";
        
        -- Test 2: Write to address 0
        Address <= "000";
        Data_write <= "101010101010";
        W_en <= '1';
        wait for Clk_period;
        W_en <= '0';
        wait for Clk_period;
        
        -- Verify write to address 0
        Address <= "000";
        wait for Clk_period;
        assert Instruction = "101010101010" report "Write to address 0 failed";
        
        -- Verify address 1 unchanged
        Address <= "001";
        wait for Clk_period;
        assert Instruction = "000000000000" report "Address 1 changed unexpectedly";
        
        -- Test 3: Write to address 5
        Address <= "101";
        Data_write <= "110011001100";
        W_en <= '1';
        wait for Clk_period;
        W_en <= '0';
        wait for Clk_period;
        
        -- Verify write to address 5
        Address <= "101";
        wait for Clk_period;
        assert Instruction = "110011001100" report "Write to address 5 failed";
        
        -- Test 4: Verify no write when W_en is low
        Address <= "011";
        Data_write <= "111100001111";
        W_en <= '0';
        wait for Clk_period;
        assert Instruction = "000000000000" report "Write occurred without enable";
        
        -- Test 5: Simultaneous read/write different addresses
        Address <= "100";  -- Reading from address 4
        Data_write <= "001100110011";
        W_en <= '1';       -- Writing to address 3 (from decoder)
        wait for Clk_period;
        W_en <= '0';
        wait for Clk_period;
        
        -- Verify write occurred at address 3
        Address <= "011";
        wait for Clk_period;
        assert Instruction = "001100110011" report "Write to address 3 failed";
        
        -- Verify read was correct during write
        Address <= "100";
        wait for Clk_period;
        assert Instruction = "000000000000" report "Address 4 corrupted during write";
        
        report "All tests completed";
        wait;
    end process;

end Behavioral;