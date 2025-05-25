library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Decoder_2_to_4_tb is
end Decoder_2_to_4_tb;

architecture Behavioral of Decoder_2_to_4_tb is
    component Decoder_2_to_4
        Port ( I : in STD_LOGIC_VECTOR(1 downto 0);
               En : in STD_LOGIC;
               Y : out STD_LOGIC_VECTOR(3 downto 0));
    end component;

    signal I : STD_LOGIC_VECTOR(1 downto 0);
    signal En : STD_LOGIC;
    signal Y : STD_LOGIC_VECTOR(3 downto 0);
begin
    uut: Decoder_2_to_4 port map(I, En, Y);

    stim_proc: process
    begin
        En <= '0'; I <= "00"; wait for 10 ns;
        En <= '1'; 
        I <= "00"; wait for 10 ns;
        I <= "01"; wait for 10 ns;
        I <= "10"; wait for 10 ns;
        I <= "11"; wait for 10 ns;
        En <= '0'; wait;
    end process;
end Behavioral;