library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AddSub_4bit_tb is
end AddSub_4bit_tb;

architecture Behavioral of AddSub_4bit_tb is

    -- Component Declaration for the Unit Under Test (UUT)
    component AddSub_4bit
        Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
               B : in STD_LOGIC_VECTOR (3 downto 0);
               Op : in STD_LOGIC;
               Q : out STD_LOGIC_VECTOR (3 downto 0);
               Overflow : out STD_LOGIC;
               Cout: out STD_LOGIC;
               Zero : out STD_LOGIC);
    end component;

    -- Inputs
    signal A : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal B : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal Op : STD_LOGIC := '0';

    -- Outputs
    signal Q : STD_LOGIC_VECTOR(3 downto 0);
    signal Overflow : STD_LOGIC;
    signal Zero, Cout : STD_LOGIC;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: AddSub_4bit port map (
        A => A,
        B => B,
        Op => Op,
        Q => Q,
        Overflow => Overflow,
        Cout => Cout,
        Zero => Zero
    );

    -- Stimulus process
    stim_proc: process
    begin
        -- Hold reset state for 100 ns
        wait for 100 ns;

        -- Test Case 1: Simple addition (5 + 3 = 8)
        A <= "0101"; -- 5
        B <= "0011"; -- 3
        Op <= '0';   -- Add
        wait for 50 ns;
        assert Q = "1000" report "Test Case 1 Failed: 5 + 3 should be 1000 in 2's compliment" severity error;
        assert Overflow = '1' report "Test Case 1 Failed: overflow expected" severity error;
        assert Zero = '0' report "Test Case 1 Failed: Zero flag incorrect" severity error;

        -- Test Case 2: Simple subtraction (7 - 2 = 5)
        A <= "0111"; -- 7
        B <= "0010"; -- 2
        Op <= '1';   -- Subtract
        wait for 50 ns;
        assert Q = "0101" report "Test Case 2 Failed: 7 - 2 should be 5" severity error;
        assert Overflow = '0' report "Test Case 2 Failed: No overflow expected" severity error;
        assert Zero = '0' report "Test Case 2 Failed: Zero flag incorrect" severity error;

        -- Test Case 3: Addition with overflow (7 + 7 = -2 with overflow)
        A <= "0111"; -- 7
        B <= "0111"; -- 7
        Op <= '0';   -- Add
        wait for 50 ns;
        assert Q = "1110" report "Test Case 3 Failed: 7 + 7 should be -2 in 2's complement" severity error;
        assert Overflow = '1' report "Test Case 3 Failed: Overflow expected" severity error;
        assert Zero = '0' report "Test Case 3 Failed: Zero flag incorrect" severity error;

        -- Test Case 4: Subtraction with negative result (2 - 5 = -3)
        A <= "0010"; -- 2
        B <= "0101"; -- 5
        Op <= '1';   -- Subtract
        wait for 50 ns;
        assert Q = "1101" report "Test Case 4 Failed: 2 - 5 should be -3" severity error;
        assert Overflow = '0' report "Test Case 4 Failed: No overflow expected" severity error;
        assert Zero = '0' report "Test Case 4 Failed: Zero flag incorrect" severity error;

        -- Test Case 5: Zero flag test (5 - 5 = 0)
        A <= "0101"; -- 5
        B <= "0101"; -- 5
        Op <= '1';   -- Subtract
        wait for 50 ns;
        assert Q = "0000" report "Test Case 5 Failed: 5 - 5 should be 0" severity error;
        assert Overflow = '0' report "Test Case 5 Failed: No overflow expected" severity error;
        assert Zero = '1' report "Test Case 5 Failed: Zero flag should be set" severity error;

        -- Test Case 6: Negative addition (-3 + -2 = -5)
        A <= "1101"; -- -3
        B <= "1110"; -- -2
        Op <= '0';   -- Add
        wait for 50 ns;
        assert Q = "1011" report "Test Case 6 Failed: -3 + -2 should be -5" severity error;
        assert Overflow = '0' report "Test Case 6 Failed: No overflow expected" severity error;
        assert Zero = '0' report "Test Case 6 Failed: Zero flag incorrect" severity error;

        -- Test Case 7: Boundary case (minimum values)
        A <= "1000"; -- -8
        B <= "1000"; -- -8
        Op <= '0';   -- Add
        wait for 50 ns;
        assert Q = "0000" report "Test Case 7 Failed: -8 + -8 should be 0 with overflow" severity error;
        assert Overflow = '1' report "Test Case 7 Failed: Overflow expected" severity error;
        assert Zero = '1' report "Test Case 7 Failed: Zero flag should be set" severity error;

        -- Test Case 8: Boundary case (maximum values)
        A <= "0111"; -- 7
        B <= "0111"; -- 7
        Op <= '1';   -- Subtract
        wait for 50 ns;
        assert Q = "0000" report "Test Case 8 Failed: 7 - 7 should be 0" severity error;
        assert Overflow = '0' report "Test Case 8 Failed: No overflow expected" severity error;
        assert Zero = '1' report "Test Case 8 Failed: Zero flag should be set" severity error;

        wait;
    end process;

end Behavioral;