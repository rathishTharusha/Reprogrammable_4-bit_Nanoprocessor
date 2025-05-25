library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_2_to_1_4bit_tb is
end MUX_2_to_1_4bit_tb;

architecture Behavioral of MUX_2_to_1_4bit_tb is
    component MUX_2_to_1_4bit
        Port ( D0, D1 : in STD_LOGIC_VECTOR(3 downto 0);
               Sel : in STD_LOGIC;
               Y : out STD_LOGIC_VECTOR(3 downto 0));
    end component;

    signal D0, D1 : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal Sel : STD_LOGIC;
    signal Y : STD_LOGIC_VECTOR(3 downto 0);
begin
    uut: MUX_2_to_1_4bit port map(D0, D1, Sel, Y);

    stim_proc: process
    begin
        D0 <= "0001"; D1 <= "1000";
        Sel <= '0'; wait for 10 ns;
        Sel <= '1'; wait for 10 ns;
        D0 <= "0101"; D1 <= "1010";
        Sel <= '0'; wait for 10 ns;
        Sel <= '1'; wait for 10 ns;
        wait;
    end process;
end Behavioral;