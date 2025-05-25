library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Instruction_Decoder_tb is
end Instruction_Decoder_tb;

architecture Behavioral of Instruction_Decoder_tb is
    component Instruction_Decoder
        Port ( Instruction : in STD_LOGIC_VECTOR(11 downto 0);
               CheckZ : in STD_LOGIC;
               RegEn, RegA, RegB, JAddress : out STD_LOGIC_VECTOR(2 downto 0);
               LoadSel, Op, JumpFlag : out STD_LOGIC;
               ImVal : out STD_LOGIC_VECTOR(3 downto 0));
    end component;

    signal Instruction : STD_LOGIC_VECTOR(11 downto 0);
    signal CheckZ : STD_LOGIC := '0';
    signal RegEn, RegA, RegB, JAddress : STD_LOGIC_VECTOR(2 downto 0);
    signal LoadSel, Op, JumpFlag : STD_LOGIC;
    signal ImVal : STD_LOGIC_VECTOR(3 downto 0);
begin
    uut: Instruction_Decoder port map(
        Instruction => Instruction, CheckZ => CheckZ,
        RegEn => RegEn, RegA => RegA, RegB => RegB, JAddress => JAddress,
        LoadSel => LoadSel, Op => Op, JumpFlag => JumpFlag, ImVal => ImVal);

    stim_proc: process
    begin
        -- Test MOVI instruction (1 0 R R R 0 0 0 d d d d)
        Instruction <= "100100000001"; -- MOVI R1,1
        wait for 10 ns;
        
        -- Test ADD instruction (0 0 Ra Ra Ra Rb Rb Rb 0 0 0 0)
        Instruction <= "000101000000"; -- ADD R1,R2
        wait for 10 ns;
        
        -- Test NEG instruction (0 1 R R R 0 0 0 0 0 0 0)
        Instruction <= "010100000000"; -- NEG R1
        wait for 10 ns;
        
        -- Test JZR instruction (1 1 R R R 0 0 0 0 d d d)
        Instruction <= "110100000101"; -- JZR R1,5
        CheckZ <= '0'; wait for 10 ns;
        CheckZ <= '1'; wait for 10 ns;
        wait;
    end process;
end Behavioral;