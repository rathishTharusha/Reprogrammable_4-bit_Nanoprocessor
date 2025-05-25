library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REG_tb is
end REG_tb;

architecture Behavioral of REG_tb is
    component REG
        Port ( D   : in STD_LOGIC_VECTOR(3 downto 0);
               Res : in STD_LOGIC;
               En  : in STD_LOGIC;
               Clk : in STD_LOGIC;
               Y   : out STD_LOGIC_VECTOR(3 downto 0));
    end component;

    -- Input signals
    signal D   : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal Res : STD_LOGIC := '0';
    signal En  : STD_LOGIC := '0';
    signal Clk : STD_LOGIC := '0';
    
    -- Output signal
    signal Y   : STD_LOGIC_VECTOR(3 downto 0);
    
    -- Clock period definition
    constant Clk_period : time := 50 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: REG port map (
        D => D,
        Res => Res,
        En => En,
        Clk => Clk,
        Y => Y
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
        -- Test 1: Reset the register
        Res <= '1';
        wait for Clk_period;
        assert Y = "0000" report "Reset failed" severity error;
        
        -- Test 2: Enable and load data
        Res <= '0';
        D <= "0101";
        En <= '1';
        wait for Clk_period;
        assert Y = "0101" report "Data load failed" severity error;
        
        -- Test 3: Change input with enable off
        D <= "1010";
        En <= '0';
        wait for Clk_period;
        assert Y = "0101" report "Register changed when disabled" severity error;
        
        -- Test 4: Enable new data
        En <= '1';
        wait for Clk_period;
        assert Y = "1010" report "New data load failed" severity error;
        
        -- Test 5: Reset while enabled
        Res <= '1';
        wait for Clk_period;
        assert Y = "0000" report "Reset with enable failed" severity error;
        
        -- Test 6: Edge case - maximum value
        Res <= '0';
        D <= "1111";
        En <= '1';
        wait for Clk_period;
        assert Y = "1111" report "Max value load failed" severity error;
        
        -- Test 7: Edge case - minimum value
        D <= "0000";
        wait for Clk_period;
        assert Y = "0000" report "Min value load failed" severity error;
        
        -- End simulation
        wait;
    end process;

end Behavioral;