library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Register_Bank_tb is
end Register_Bank_tb;

architecture Behavioral of Register_Bank_tb is
    component Register_Bank
        Port ( Data_in : in STD_LOGIC_VECTOR(3 downto 0);
               RegEn : in STD_LOGIC_VECTOR(2 downto 0);
               Res, Clk : in STD_LOGIC;
               Data_out_0, Data_out_1, Data_out_2, Data_out_3,
               Data_out_4, Data_out_5, Data_out_6, Data_out_7 : out STD_LOGIC_VECTOR(3 downto 0));
    end component;

    signal Data_in : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal RegEn : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal Res, Clk : STD_LOGIC := '0';
    signal Data_out_0, Data_out_1, Data_out_2, Data_out_3,
           Data_out_4, Data_out_5, Data_out_6, Data_out_7 : STD_LOGIC_VECTOR(3 downto 0);
    constant clk_period : time := 10 ns;
begin
    uut: Register_Bank port map(
        Data_in => Data_in, RegEn => RegEn, Res => Res, Clk => Clk,
        Data_out_0 => Data_out_0, Data_out_1 => Data_out_1,
        Data_out_2 => Data_out_2, Data_out_3 => Data_out_3,
        Data_out_4 => Data_out_4, Data_out_5 => Data_out_5,
        Data_out_6 => Data_out_6, Data_out_7 => Data_out_7);

    clk_process: process
    begin
        Clk <= '0'; wait for clk_period/2;
        Clk <= '1'; wait for clk_period/2;
    end process;

    stim_proc: process
    begin
        Res <= '1'; wait for 15 ns;
        Res <= '0'; Data_in <= "0101";
        
        RegEn <= "001"; wait for 50 ns; -- Write to R1
        RegEn <= "010"; wait for 50 ns; -- Write to R2
        Data_in <= "1010"; RegEn <= "100"; wait for 50 ns; -- Write to R4
        Data_in <= "1001"; RegEn <= "001"; wait for 50 ns; -- Write to R1
        RegEn <= "011"; wait for 50 ns; -- Write to R2
        Data_in <= "1101"; RegEn <= "101"; wait for 50 ns; -- Write to R4
        RegEn <= "111"; wait for 50 ns; -- Write to R1
        Data_in <= "0111"; RegEn <= "110"; wait for 50 ns; -- Write to R2
        Data_in <= "0101"; RegEn <= "101"; wait for 50 ns; -- Write to R4
        RegEn <= "000"; Data_in <= "1010"; wait for 10 ns; -- No write
        
        Res <= '1'; wait for 10 ns; -- Test reset
        Res <= '0'; wait;
    end process;
end Behavioral;