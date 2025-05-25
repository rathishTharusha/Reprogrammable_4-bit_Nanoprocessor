library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_8_to_1_4bit_tb is
end MUX_8_to_1_4bit_tb;

architecture Behavioral of MUX_8_to_1_4bit_tb is
    component MUX_8_to_1_4bit
        Port ( D0, D1, D2, D3, D4, D5, D6, D7 : in STD_LOGIC_VECTOR(3 downto 0);
               Sel : in STD_LOGIC_VECTOR(2 downto 0);
               Y : out STD_LOGIC_VECTOR(3 downto 0));
    end component;

    signal D : STD_LOGIC_VECTOR(31 downto 0) := x"01234567";
    signal Sel : STD_LOGIC_VECTOR(2 downto 0);
    signal Y : STD_LOGIC_VECTOR(3 downto 0);
begin
    uut: MUX_8_to_1_4bit port map(
        D0 => D(3 downto 0), D1 => D(7 downto 4),
        D2 => D(11 downto 8), D3 => D(15 downto 12),
        D4 => D(19 downto 16), D5 => D(23 downto 20),
        D6 => D(27 downto 24), D7 => D(31 downto 28),
        Sel => Sel, Y => Y);

    stim_proc: process
    begin
        for i in 0 to 7 loop
            Sel <= std_logic_vector(to_unsigned(i, 3));
            wait for 10 ns;
        end loop;
        wait;
    end process;
end Behavioral;