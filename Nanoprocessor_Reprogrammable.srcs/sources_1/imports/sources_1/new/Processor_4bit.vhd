----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/12/2025 07:19:38 PM
-- Design Name: 
-- Module Name: Processor_4bit - Behavioral
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

entity Processor_4bit is
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
end Processor_4bit;

architecture Behavioral of Processor_4bit is

COMPONENT Slow_Clock
    Port ( Clk_in : in STD_LOGIC;
           Clk_out : out STD_LOGIC);
end COMPONENT;


COMPONENT Register_Bank
    Port ( Data_in : in STD_LOGIC_VECTOR (3 downto 0);
           RegEn : in STD_LOGIC_VECTOR (2 downto 0);
           Res : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Data_out_0, Data_out_1, Data_out_2, Data_out_3, Data_out_4, Data_out_5, Data_out_6, Data_out_7 : out STD_LOGIC_VECTOR (3 downto 0));
end COMPONENT;

COMPONENT MUX_8_to_1_4bit 
    Port ( D0 : in STD_LOGIC_VECTOR (3 downto 0);
           D1 : in STD_LOGIC_VECTOR (3 downto 0);
           D2 : in STD_LOGIC_VECTOR (3 downto 0);
           D3 : in STD_LOGIC_VECTOR (3 downto 0);
           D4 : in STD_LOGIC_VECTOR (3 downto 0);
           D5 : in STD_LOGIC_VECTOR (3 downto 0);
           D6 : in STD_LOGIC_VECTOR (3 downto 0);
           D7 : in STD_LOGIC_VECTOR (3 downto 0);
           Sel : in STD_LOGIC_VECTOR (2 downto 0);
           Y : out STD_LOGIC_VECTOR (3 downto 0));
end COMPONENT;

COMPONENT AddSub_4bit
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           Op : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (3 downto 0);
           Overflow : out STD_LOGIC;
           Cout: out STD_LOGIC;
           Zero : out STD_LOGIC);
end COMPONENT;

COMPONENT MUX_2_to_1_4bit
    Port ( D0 : in STD_LOGIC_VECTOR (3 downto 0);
           D1 : in STD_LOGIC_VECTOR (3 downto 0);
           Sel : in STD_LOGIC;
           Y : out STD_LOGIC_VECTOR (3 downto 0));
end COMPONENT;

COMPONENT Instruction_Decoder
    Port ( Instruction : in STD_LOGIC_VECTOR (11 downto 0);
           CheckZ : in STD_LOGIC;
           RegEn : out STD_LOGIC_VECTOR (2 downto 0);
           LoadSel : out STD_LOGIC;
           ImVal : out STD_LOGIC_VECTOR (3 downto 0);
           RegA : out STD_LOGIC_VECTOR (2 downto 0);
           RegB : out STD_LOGIC_VECTOR (2 downto 0);
           Op : out STD_LOGIC;
           JumpFlag : out STD_LOGIC;
           JAddress : out STD_LOGIC_VECTOR (2 downto 0));
end COMPONENT;

COMPONENT Program_RAM
    Port ( Address : in STD_LOGIC_VECTOR (2 downto 0);
       Data_write: in STD_LOGIC_VECTOR (11 downto 0);
       W_en: in STD_LOGIC;
       Clk: in STD_LOGIC;
       Res : in STD_LOGIC;
       Instruction : out STD_LOGIC_VECTOR (11 downto 0));
end COMPONENT;

COMPONENT Seg7 
    Port ( data_in : in STD_LOGIC_VECTOR (3 downto 0);
           data_out : out STD_LOGIC_VECTOR (6 downto 0));
end COMPONENT;

COMPONENT Program_counter
    Port ( Clk : in STD_LOGIC;
           Res : in STD_LOGIC;
           Run : in STD_LOGIC;
           Step : in STD_LOGIC;
           JFlag : in STD_LOGIC;
           JAdr : in STD_LOGIC_VECTOR (2 downto 0);
           Address : out STD_LOGIC_VECTOR (2 downto 0));
end COMPONENT;

COMPONENT IO_System
    Port ( 
           Clk: in STD_LOGIC;
           DATA : in STD_LOGIC_VECTOR (3 downto 0);
           PC : in STD_LOGIC_VECTOR (2 downto 0);
           REGEN : in STD_LOGIC_VECTOR (2 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end COMPONENT;

SIGNAl LoadSel, Op, JFlag, Over, Zero, Overflow, Slow_clk, Cout: std_logic;
SIGNAL RegEn, RegSelA, RegSelB, JAdr, Address, Cnt_in, Cnt_out : std_logic_vector(2 downto 0);
SIGNAL D0, D1, D2, D3, D4, D5, D6, D7, Data_in, RegA, RegB, RegS, ImVal, REG : std_logic_vector(3 downto 0);
SIGNAL Instruction : std_logic_vector(11 downto 0);

begin

Slow_Clock_0: Slow_Clock
    port map ( 
    Clk_in => Clk,
    Clk_out => Slow_clk
);

Register_Bank_0: Register_Bank
    port map( 
    Data_in => Data_in,
    RegEn => RegEn,
    Res => ResRB,
    Clk => Slow_clk,
    Data_out_0 => D0, 
    Data_out_1 => D1, 
    Data_out_2 => D2, 
    Data_out_3 => D3, 
    Data_out_4 => D4, 
    Data_out_5 => D5, 
    Data_out_6 => D6, 
    Data_out_7 => D7
);

MUX_8_to_1_4bit_0: MUX_8_to_1_4bit 
    port map ( 
    D0 => D0,
    D1 => D1,
    D2 => D2,
    D3 => D3,
    D4 => D4,
    D5 => D5,
    D6 => D6,
    D7 => D7,
    Sel => RegSelA,
    Y => RegB
);

MUX_8_to_1_4bit_1: MUX_8_to_1_4bit 
    port map ( 
    D0 => D0,
    D1 => D1,
    D2 => D2,
    D3 => D3,
    D4 => D4,
    D5 => D5,
    D6 => D6,
    D7 => D7,
    Sel => RegSelB,
    Y => RegA
);

MUX_8_to_1_4bit_2: MUX_8_to_1_4bit 
    port map ( 
    D0 => D0,
    D1 => D1,
    D2 => D2,
    D3 => D3,
    D4 => D4,
    D5 => D5,
    D6 => D6,
    D7 => D7,
    Sel => RegSel,
    Y => REG
);

AddSub_4bit_0_0: AddSub_4bit
port map(
    A => RegA,
    B => RegB,
    Op => Op,
    Q => RegS,
    Overflow => Overflow,
    Cout => Cout,
    Zero => Zero
);

MUX_2_to_1_4bit_0: MUX_2_to_1_4bit
    port map ( 
    D0 => RegS,
    D1 => ImVal,
    Sel => LoadSel,
    Y => Data_in
);

Instruction_Decoder_0: Instruction_Decoder
    port map ( 
    Instruction => Instruction,
    CheckZ => Zero,
    RegEn => RegEn,
    LoadSel => LoadSel,
    ImVal => ImVal,
    RegA => RegSelA,
    RegB => RegSelB,
    Op => Op,
    JumpFlag => JFlag,
    JAddress => JAdr 
);

Program_counter_0: Program_counter 
    port map ( Clk => Slow_clk,
           Res => Res,
           Run => Run,
           Step => Step,
           JFlag => JFlag,
           JAdr => JAdr,
           Address => Address
           );

Program_RAM_0:Program_RAM 
    port map ( Address => Address,
       Data_write => Data_write,
       W_en => Upload,
       Clk => Slow_clk,
       Res => ResRAM,
       Instruction => Instruction);

IO_System_0_0: IO_System
    port map ( 
           Clk => Clk,
           DATA => REG,
           PC => Address,
           REGEN => RegSel,
           an => An_out,
           seg  => Data_seg
);

Flags(0) <= Zero;
Flags(1) <= Overflow;
Flags(2) <= RegS(3);

Command <= Instruction;

end Behavioral;
