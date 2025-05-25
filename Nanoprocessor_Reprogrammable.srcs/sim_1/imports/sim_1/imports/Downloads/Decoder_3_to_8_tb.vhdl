library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Decoder_3_to_8_tb is
end Decoder_3_to_8_tb;

architecture Behavioral of Decoder_3_to_8_tb is
    component Decoder_3_to_8
        Port ( I : in STD_LOGIC_VECTOR(2 downto 0);
               Y : out STD_LOGIC_VECTOR(7 downto 0));
    end component;

    signal I : STD_LOGIC_VECTOR(2 downto 0);
    signal Y : STD_LOGIC_VECTOR(7 downto 0);
begin
    uut: Decoder_3_to_8 port map(I, Y);

    stim_proc: process
    begin
        I <= "000"; wait for 10 ns;
        I <= "001"; wait for 10 ns;
        I <= "010"; wait for 10 ns;
        I <= "011"; wait for 10 ns;
        I <= "100"; wait for 10 ns;
        I <= "101"; wait for 10 ns;
        I <= "110"; wait for 10 ns;
        I <= "111"; wait for 10 ns;
        wait;
    end process;
end Behavioral;